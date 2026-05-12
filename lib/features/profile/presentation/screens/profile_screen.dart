import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/auth_tokens.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/sc_app_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/streak_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/avatar_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  bool _isEditingUsername = false;
  bool _isEditingMobileNumber = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  AuthUser _toAuthUser(User user) {
    return AuthUser(
      id: user.id,
      name: user.name,
      email: user.email,
      mobileNumber: user.mobileNumber,
      profilePicture: user.profilePicture,
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          Semantics(
            label: 'logout_confirm',
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  Future<void> _handleAvatarTap() async {
    final avatarPicker = AvatarPicker();
    final imagePath = await avatarPicker.pickAndCropAvatar(context);
    if (imagePath == null || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final profileActions = ref.read(profileActionsProvider);
      final updatedUser = await profileActions.uploadProfilePicture(imagePath);
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload avatar: $e')),
        );
      }
    }
  }

  Future<void> _handleUpdateUsername() async {
    final name = _usernameController.text.trim();
    if (name.isEmpty) return;
    try {
      final profileActions = ref.read(profileActionsProvider);
      final updatedUser = await profileActions.updateName(name);
      if (mounted) {
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));
        setState(() => _isEditingUsername = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update username: $e')),
        );
      }
    }
  }

  Future<void> _handleUpdateMobileNumber() async {
    final mobileNumber = _mobileNumberController.text.trim();
    if (mobileNumber.isEmpty) return;
    final validationError = Validators.validateMobileNumber(mobileNumber);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }
    try {
      final profileActions = ref.read(profileActionsProvider);
      final updatedUser =
          await profileActions.updateMobileNumber(mobileNumber);
      if (mounted) {
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));
        setState(() => _isEditingMobileNumber = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile number updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update mobile number: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScAppBar(
            title: 'Profile',
            right: IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.ink),
              onPressed: () => ref.invalidate(profileDataProvider),
            ),
          ),
          Expanded(
            child: profileState.when(
              data: (user) => _buildContent(user),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.redPrimary),
                    const SizedBox(height: 16),
                    Text(error.toString(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: AppColors.mutedInk)),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(profileDataProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        children: [
          _ProfileHeadCard(
            user: user,
            onAvatarTap: _handleAvatarTap,
          ),
          const SizedBox(height: 14),
          const _StatsRow(),
          const SizedBox(height: 14),
          _AccountSection(
            user: user,
            usernameController: _usernameController,
            mobileController: _mobileNumberController,
            isEditingUsername: _isEditingUsername,
            isEditingMobile: _isEditingMobileNumber,
            onEditUsername: () => setState(() {
              _isEditingUsername = true;
              _usernameController.text = user.name;
            }),
            onCancelUsername: () =>
                setState(() => _isEditingUsername = false),
            onSaveUsername: _handleUpdateUsername,
            onEditMobile: () => setState(() {
              _isEditingMobileNumber = true;
              _mobileNumberController.text = user.mobileNumber ?? '';
            }),
            onCancelMobile: () =>
                setState(() => _isEditingMobileNumber = false),
            onSaveMobile: _handleUpdateMobileNumber,
          ),
          const SizedBox(height: 14),
          _PreferencesSection(
            user: user,
            onChangePassword: () =>
                context.push(Routes.changePassword),
            onLogout: _handleLogout,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeadCard extends ConsumerWidget {
  final User user;
  final VoidCallback onAvatarTap;

  const _ProfileHeadCard({required this.user, required this.onAvatarTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);
    // Prefer the stats `memberSince` (server-authoritative) over the user
    // model's createdAt, but fall back gracefully.
    final memberSince = statsAsync.maybeWhen(
      data: (s) => s.memberSince ?? user.createdAt,
      orElse: () => user.createdAt,
    );
    final since = DateFormat('MMM yyyy').format(memberSince);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                AppAvatar(name: user.name, size: 68),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Member since $since',
            style: const TextStyle(fontSize: 13, color: AppColors.mutedInk),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.lavenderBg,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              '⚡ Free plan · Upgrade',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.lavenderText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    return statsAsync.when(
      loading: () => Row(
        children: const [
          _StatCard(value: '—', label: 'Sessions'),
          SizedBox(width: 10),
          _StatCard(value: '—', label: 'Words'),
          SizedBox(width: 10),
          _StatCard(value: '—', label: 'Streak'),
        ],
      ),
      error: (_, _) => GestureDetector(
        onTap: () => ref.invalidate(userStatsProvider),
        child: Row(
          children: const [
            _StatCard(value: '—', label: 'Sessions'),
            SizedBox(width: 10),
            _StatCard(value: '—', label: 'Words'),
            SizedBox(width: 10),
            _StatCard(value: '—', label: 'Streak'),
          ],
        ),
      ),
      data: (stats) => Row(
        children: [
          _StatCard(
            value: stats.totalSessions.toString(),
            label: 'Sessions',
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: stats.totalWords.toString(),
            label: 'Words',
          ),
          const SizedBox(width: 10),
          _StatCard(
            value: '${stats.streakDays}d',
            label: 'Streak',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  final User user;
  final TextEditingController usernameController;
  final TextEditingController mobileController;
  final bool isEditingUsername;
  final bool isEditingMobile;
  final VoidCallback onEditUsername;
  final VoidCallback onCancelUsername;
  final VoidCallback onSaveUsername;
  final VoidCallback onEditMobile;
  final VoidCallback onCancelMobile;
  final VoidCallback onSaveMobile;

  const _AccountSection({
    required this.user,
    required this.usernameController,
    required this.mobileController,
    required this.isEditingUsername,
    required this.isEditingMobile,
    required this.onEditUsername,
    required this.onCancelUsername,
    required this.onSaveUsername,
    required this.onEditMobile,
    required this.onCancelMobile,
    required this.onSaveMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Account'),
          _EditableField(
            label: 'Username',
            value: user.name,
            controller: usernameController,
            isEditing: isEditingUsername,
            onEdit: onEditUsername,
            onCancel: onCancelUsername,
            onSave: onSaveUsername,
            editSemLabel: 'profile_edit_username',
            saveSemLabel: 'profile_save_field',
            cancelSemLabel: 'profile_cancel_field',
          ),
          _divider(),
          _ReadOnlyField(
            label: 'Email',
            value: user.email,
            icon: Icons.email_outlined,
          ),
          _divider(),
          _EditableField(
            label: 'Mobile Number',
            value: user.mobileNumber ?? 'Not provided',
            controller: mobileController,
            isEditing: isEditingMobile,
            onEdit: onEditMobile,
            onCancel: onCancelMobile,
            onSave: onSaveMobile,
            keyboardType: TextInputType.phone,
            hint: '+1234567890',
            editSemLabel: 'profile_edit_mobile',
            saveSemLabel: 'profile_save_field',
            cancelSemLabel: 'profile_cancel_field',
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedInk,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.lineSoft,
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final String value;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final TextInputType keyboardType;
  final String? hint;
  final String? editSemLabel;
  final String? saveSemLabel;
  final String? cancelSemLabel;

  const _EditableField({
    required this.label,
    required this.value,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    required this.onCancel,
    required this.onSave,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.editSemLabel,
    this.saveSemLabel,
    this.cancelSemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.mutedSoft),
          ),
          const SizedBox(height: 4),
          if (isEditing)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: cancelSemLabel,
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onCancel,
                ),
                IconButton(
                  tooltip: saveSemLabel,
                  icon: const Icon(Icons.check, size: 20,
                      color: AppColors.greenPrimary),
                  onPressed: onSave,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Semantics(
                  label: editSemLabel,
                  button: true,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: const Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.mutedInk),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.mutedSoft),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.mutedInk),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  final User user;
  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  const _PreferencesSection({
    required this.user,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Preferences'),
          _PrefItem(
            emoji: '🌐',
            label: 'English level',
            value: 'B2 · Upper-Inter.',
            onTap: () {},
          ),
          _divider(),
          _PrefItem(
            emoji: '🔔',
            label: 'Notifications',
            value: 'On',
            onTap: () {},
          ),
          _divider(),
          _PrefItem(
            emoji: '🌙',
            label: 'Theme',
            value: 'System',
            onTap: () {},
          ),
          if (user.authProvider != 'google') ...[
            _divider(),
            _PrefItem(
              icon: Icons.lock_reset_outlined,
              label: 'Change Password',
              onTap: onChangePassword,
            ),
          ],
          _divider(),
          _PrefItem(
            icon: Icons.logout,
            label: 'Sign out',
            labelColor: AppColors.redPrimary,
            semanticLabel: 'profile_logout',
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedInk,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.lineSoft,
    );
  }
}

class _PrefItem extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String label;
  final String? value;
  final Color labelColor;
  final VoidCallback onTap;
  final String? semanticLabel;

  const _PrefItem({
    this.emoji,
    this.icon,
    required this.label,
    this.value,
    this.labelColor = AppColors.ink,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: semanticLabel != null,
      child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        child: Row(
          children: [
            if (emoji != null)
              Text(emoji!, style: const TextStyle(fontSize: 16))
            else if (icon != null)
              Icon(icon, size: 18, color: labelColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedInk,
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.mutedSoft),
          ],
        ),
      ),
    ),
    );
  }
}
