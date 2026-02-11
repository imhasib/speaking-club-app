import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/ai_session.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../domain/ai_practice_state.dart';
import '../providers/ai_practice_provider.dart';

/// Screen for selecting AI practice mode
class ModeSelectionScreen extends ConsumerStatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  ConsumerState<ModeSelectionScreen> createState() =>
      _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends ConsumerState<ModeSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(modeSelectionProvider.notifier).loadData();
    });
  }

  void _startSession(AiSessionMode mode, {String? topic, String? scenario}) async {
    // Start the AI session
    ref.read(aiPracticeProvider.notifier).startSession(
          mode: mode,
          topic: topic,
          scenario: scenario,
        );

    // Wait for session to either connect successfully or fail
    // Don't navigate immediately - wait for the result
    final subscription = ref.listenManual<AiPracticeState>(
      aiPracticeProvider,
      (previous, next) {},
    );

    try {
      // Poll for state change with timeout
      const maxWaitSeconds = 30;
      for (var i = 0; i < maxWaitSeconds * 10; i++) {
        await Future.delayed(const Duration(milliseconds: 100));

        final state = ref.read(aiPracticeProvider);

        // Success - session is ready or in conversation
        if (state.isInConversation) {
          if (mounted) {
            context.push(Routes.aiSession);
          }
          return;
        }

        // Error - show message and stay on this screen
        if (state.phase == AiPracticePhase.error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to start session'),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 5),
              ),
            );
          }
          // Reset the state back to idle
          ref.read(aiPracticeProvider.notifier).clearError();
          return;
        }
      }

      // Timeout - show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection timeout. Please try again.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      subscription.close();
    }
  }

  void _showTopicPicker() {
    final state = ref.read(modeSelectionProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TopicPickerSheet(
        categories: state.topicCategories,
        onTopicSelected: (topic) {
          Navigator.pop(context);
          _startSession(AiSessionMode.topic, topic: topic.name);
        },
      ),
    );
  }

  void _showScenarioPicker() {
    final state = ref.read(modeSelectionProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScenarioPickerSheet(
        scenarios: state.scenarios,
        onScenarioSelected: (scenario) {
          Navigator.pop(context);
          _startSession(AiSessionMode.scenario, scenario: scenario.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(modeSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice with AI'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _buildErrorState(state.error!)
              : _buildContent(colorScheme, textTheme, state),
    );
  }

  Widget _buildErrorState(String error) {
    return AnimatedEmptyState(
      icon: Icons.error_outline,
      title: 'Failed to load',
      subtitle: error,
      actionLabel: 'Retry',
      onAction: () => ref.read(modeSelectionProvider.notifier).loadData(),
    );
  }

  Widget _buildContent(
    ColorScheme colorScheme,
    TextTheme textTheme,
    ModeSelectionState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Usage info card
          if (state.usageInfo != null) _buildUsageCard(state.usageInfo!),
          const SizedBox(height: 24),

          // Mode cards
          Text(
            'Choose a mode',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Free Chat
          StaggeredListItem(
            index: 0,
            child: _ModeCard(
              icon: Icons.chat_bubble_outline,
              title: 'Free Chat',
              description: 'Have a casual conversation on any topic',
              color: AppColors.primary,
              onTap: state.usageInfo?.hasTimeRemaining ?? true
                  ? () => _startSession(AiSessionMode.freeChat)
                  : null,
            ),
          ),
          const SizedBox(height: 12),

          // Topic-Based
          StaggeredListItem(
            index: 1,
            child: _ModeCard(
              icon: Icons.topic_outlined,
              title: 'Topic Discussion',
              description: 'Practice vocabulary around specific themes',
              color: AppColors.secondary,
              onTap: state.usageInfo?.hasTimeRemaining ?? true
                  ? _showTopicPicker
                  : null,
            ),
          ),
          const SizedBox(height: 12),

          // Scenario Roleplay
          StaggeredListItem(
            index: 2,
            child: _ModeCard(
              icon: Icons.theater_comedy_outlined,
              title: 'Scenario Roleplay',
              description: 'Practice real-world situations',
              color: AppColors.info,
              onTap: state.usageInfo?.hasTimeRemaining ?? true
                  ? _showScenarioPicker
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(AiUsageInfo usageInfo) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final progress =
        usageInfo.usedSeconds / usageInfo.dailyLimitSeconds.clamp(1, 999999);
    final isLow = usageInfo.remainingSeconds < 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Practice Time',
                  style: textTheme.titleMedium,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLow
                        ? colorScheme.errorContainer
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    usageInfo.formattedRemaining,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLow
                          ? colorScheme.onErrorContainer
                          : colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  isLow ? colorScheme.error : colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usageInfo.hasTimeRemaining
                  ? 'Time remaining today'
                  : 'Daily limit reached. Resets at midnight.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card widget for mode selection
class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = onTap == null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for topic selection
class TopicPickerSheet extends StatelessWidget {
  final List<TopicCategory> categories;
  final void Function(Topic) onTopicSelected;

  const TopicPickerSheet({
    super.key,
    required this.categories,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Choose a Topic',
                    style: textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: categories.isEmpty
                  ? const Center(child: Text('No topics available'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _TopicCategoryTile(
                          category: category,
                          onTopicSelected: onTopicSelected,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TopicCategoryTile extends StatelessWidget {
  final TopicCategory category;
  final void Function(Topic) onTopicSelected;

  const _TopicCategoryTile({
    required this.category,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ExpansionTile(
      leading: Text(category.icon, style: const TextStyle(fontSize: 24)),
      title: Text(category.name),
      children: category.topics
          .map(
            (topic) => ListTile(
              contentPadding: const EdgeInsets.only(left: 72, right: 16),
              title: Text(topic.name),
              subtitle: topic.description != null
                  ? Text(
                      topic.description!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => onTopicSelected(topic),
            ),
          )
          .toList(),
    );
  }
}

/// Bottom sheet for scenario selection
class ScenarioPickerSheet extends StatelessWidget {
  final List<Scenario> scenarios;
  final void Function(Scenario) onScenarioSelected;

  const ScenarioPickerSheet({
    super.key,
    required this.scenarios,
    required this.onScenarioSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Choose a Scenario',
                    style: textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: scenarios.isEmpty
                  ? const Center(child: Text('No scenarios available'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: scenarios.length,
                      itemBuilder: (context, index) {
                        final scenario = scenarios[index];
                        return _ScenarioTile(
                          scenario: scenario,
                          onTap: () => onScenarioSelected(scenario),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  final Scenario scenario;
  final VoidCallback onTap;

  const _ScenarioTile({
    required this.scenario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        scenario.name,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(scenario.description),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text('AI: ${scenario.aiRole}'),
                labelStyle: textTheme.labelSmall,
                visualDensity: VisualDensity.compact,
                backgroundColor: colorScheme.primaryContainer,
              ),
              Chip(
                label: Text('You: ${scenario.userRole}'),
                labelStyle: textTheme.labelSmall,
                visualDensity: VisualDensity.compact,
                backgroundColor: colorScheme.secondaryContainer,
              ),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
