import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/user.dart';
import '../../data/user_repository.dart';

/// Profile data provider - fetches full user profile from server
final profileDataProvider = FutureProvider<User>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.getCurrentUser();
});

/// Profile actions provider for updating profile
final profileActionsProvider = Provider<ProfileActions>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return ProfileActions(
    userRepository: userRepository,
    ref: ref,
  );
});

/// Profile actions class for updating profile
class ProfileActions {
  final UserRepository _userRepository;
  final Ref _ref;

  ProfileActions({
    required UserRepository userRepository,
    required Ref ref,
  })  : _userRepository = userRepository,
        _ref = ref;

  /// Refresh user profile from server
  Future<User> refreshProfile() async {
    // Invalidate the provider to force a refetch
    _ref.invalidate(profileDataProvider);
    return await _userRepository.getCurrentUser();
  }

  /// Update username
  Future<User> updateUsername(String username) async {
    final request = UpdateProfileRequest(username: username);
    final updatedUser = await _userRepository.updateProfile(request);
    // Invalidate profile data to refetch
    _ref.invalidate(profileDataProvider);
    return updatedUser;
  }

  /// Update mobile number
  Future<User> updateMobileNumber(String mobileNumber) async {
    final request = UpdateProfileRequest(mobileNumber: mobileNumber);
    final updatedUser = await _userRepository.updateProfile(request);
    // Invalidate profile data to refetch
    _ref.invalidate(profileDataProvider);
    return updatedUser;
  }

  /// Upload avatar
  Future<User> uploadAvatar(String filePath) async {
    final avatarUrl = await _userRepository.uploadAvatar(filePath);
    // Update profile with new avatar URL
    final request = UpdateProfileRequest(avatar: avatarUrl);
    final updatedUser = await _userRepository.updateProfile(request);
    // Invalidate profile data to refetch
    _ref.invalidate(profileDataProvider);
    return updatedUser;
  }
}
