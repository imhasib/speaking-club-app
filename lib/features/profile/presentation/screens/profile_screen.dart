import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/auth_tokens.dart';
import '../../../../shared/models/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/avatar_picker.dart';

/// Profile screen showing user information
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

  /// Convert User to AuthUser for auth state update
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
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
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

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final profileActions = ref.read(profileActionsProvider);
      final updatedUser = await profileActions.uploadProfilePicture(imagePath);

      if (mounted) {
        // Close loading dialog
        Navigator.of(context, rootNavigator: true).pop();

        // Update auth state
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        // Close loading dialog
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

      // Update auth state with new user
      if (mounted) {
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));
        setState(() {
          _isEditingUsername = false;
        });

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

    // Basic validation for mobile number format
    if (!mobileNumber.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mobile number must start with + and country code'),
        ),
      );
      return;
    }

    try {
      final profileActions = ref.read(profileActionsProvider);
      final updatedUser = await profileActions.updateMobileNumber(mobileNumber);

      // Update auth state with new user
      if (mounted) {
        ref.read(authProvider.notifier).updateUser(_toAuthUser(updatedUser));
        setState(() {
          _isEditingMobileNumber = false;
        });

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profileState = ref.watch(profileDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(profileDataProvider);
            },
          ),
        ],
      ),
      body: profileState.when(
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar
                GestureDetector(
                  onTap: _handleAvatarTap,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: user.profilePicture != null
                            ? CachedNetworkImageProvider(user.profilePicture!)
                            : null,
                        child: user.profilePicture == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: colorScheme.onPrimaryContainer,
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Username (editable)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Username',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (!_isEditingUsername)
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _isEditingUsername = true;
                                    _usernameController.text = user.name;
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isEditingUsername)
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter username',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _isEditingUsername = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: _handleUpdateUsername,
                              ),
                            ],
                          )
                        else
                          Text(
                            user.name,
                            style: textTheme.titleMedium,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email (read-only)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.email,
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile Number (editable)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mobile Number',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (!_isEditingMobileNumber)
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _isEditingMobileNumber = true;
                                    _mobileNumberController.text =
                                        user.mobileNumber ?? '';
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isEditingMobileNumber)
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _mobileNumberController,
                                  decoration: const InputDecoration(
                                    hintText: '+1234567890',
                                    helperText: 'Format: +[country code][number]',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _isEditingMobileNumber = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: _handleUpdateMobileNumber,
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user.mobileNumber ?? 'Not provided',
                                style: textTheme.titleMedium?.copyWith(
                                  color: user.mobileNumber == null
                                      ? colorScheme.onSurfaceVariant.withOpacity(0.6)
                                      : null,
                                  fontStyle: user.mobileNumber == null
                                      ? FontStyle.italic
                                      : null,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Member Since
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Member Since',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMMM dd, yyyy')
                                  .format(user.createdAt),
                              style: textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _handleLogout,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout),
                        const SizedBox(width: 8),
                        const Text('Logout'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Failed to load profile',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  ref.invalidate(profileDataProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
