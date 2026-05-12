import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/profile/data/user_repository.dart';
import 'package:speaking_club/features/profile/presentation/providers/profile_provider.dart';
import 'package:speaking_club/shared/models/user.dart';

class _MockUserRepository extends Mock implements UserRepository {}

// ── Fixtures ───────────────────────────────────────────────────────────────

User _user({String name = 'Alice', String email = 'alice@test.com'}) => User(
      id: 'u1',
      name: name,
      email: email,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

({
  ProviderContainer container,
  _MockUserRepository repo,
}) _makeContainer() {
  final repo = _MockUserRepository();
  final container = ProviderContainer(
    overrides: [userRepositoryProvider.overrideWithValue(repo)],
  );
  return (container: container, repo: repo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const UpdateProfileRequest(name: 'fallback'));
  });

  // ── profileDataProvider ────────────────────────────────────────────────────

  group('profileDataProvider', () {
    test('fetches user from repository', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCurrentUser()).thenAnswer((_) async => _user());

      final result = await container.read(profileDataProvider.future);
      expect(result.email, 'alice@test.com');
    });

    test('transitions to error state when repository throws', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCurrentUser())
          .thenAnswer((_) async => throw Exception('server error'));

      // Trigger the provider load then flush microtasks.
      container.read(profileDataProvider);
      await pumpEventQueue();

      expect(container.read(profileDataProvider).hasError, isTrue);
    });
  });

  // ── ProfileActions.refreshProfile ─────────────────────────────────────────

  group('ProfileActions.refreshProfile', () {
    test('returns latest user from repository', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCurrentUser())
          .thenAnswer((_) async => _user(name: 'Alice Refreshed'));

      final actions = container.read(profileActionsProvider);
      final user = await actions.refreshProfile();

      expect(user.name, 'Alice Refreshed');
      verify(() => repo.getCurrentUser()).called(1);
    });

    test('invalidates profileDataProvider so it refetches', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      var callCount = 0;
      when(() => repo.getCurrentUser()).thenAnswer((_) async {
        callCount++;
        return _user();
      });

      // First read of profileDataProvider
      await container.read(profileDataProvider.future);

      // refreshProfile invalidates the provider
      await container.read(profileActionsProvider).refreshProfile();

      // After invalidation, re-reading the future triggers a new fetch
      await container.read(profileDataProvider.future);

      // At minimum 2 calls: initial + after invalidation
      expect(callCount, greaterThanOrEqualTo(2));
    });
  });

  // ── ProfileActions.updateName ──────────────────────────────────────────────

  group('ProfileActions.updateName', () {
    test('calls updateProfile with name request and returns updated user',
        () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.updateProfile(any()))
          .thenAnswer((_) async => _user(name: 'New Name'));

      final user = await container.read(profileActionsProvider).updateName('New Name');

      expect(user.name, 'New Name');
      final captured = verify(() => repo.updateProfile(captureAny()))
          .captured
          .first as UpdateProfileRequest;
      expect(captured.name, 'New Name');
      expect(captured.mobileNumber, isNull);
    });

    test('invalidates profileDataProvider after update', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCurrentUser()).thenAnswer((_) async => _user());
      when(() => repo.updateProfile(any()))
          .thenAnswer((_) async => _user(name: 'Changed'));

      await container.read(profileDataProvider.future);
      await container.read(profileActionsProvider).updateName('Changed');

      // After invalidation the future is marked stale
      // Reading it again forces a new fetch
      when(() => repo.getCurrentUser())
          .thenAnswer((_) async => _user(name: 'Changed'));
      final refreshed = await container.read(profileDataProvider.future);
      expect(refreshed.name, 'Changed');
    });
  });

  // ── ProfileActions.updateMobileNumber ─────────────────────────────────────

  group('ProfileActions.updateMobileNumber', () {
    test('calls updateProfile with mobile number and returns updated user',
        () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.updateProfile(any())).thenAnswer(
        (_) async => _user()
            .copyWith(mobileNumber: '01234567890'),
      );

      final user = await container
          .read(profileActionsProvider)
          .updateMobileNumber('01234567890');

      expect(user.mobileNumber, '01234567890');

      final captured = verify(() => repo.updateProfile(captureAny()))
          .captured
          .first as UpdateProfileRequest;
      expect(captured.mobileNumber, '01234567890');
      expect(captured.name, isNull);
    });
  });

  // ── ProfileActions.uploadProfilePicture ───────────────────────────────────

  group('ProfileActions.uploadProfilePicture', () {
    test('uploads, updates profile with URL, and returns user', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      const imageUrl = 'https://cdn.example.com/avatar.jpg';
      when(() => repo.uploadProfilePicture(any()))
          .thenAnswer((_) async => imageUrl);
      when(() => repo.updateProfile(any())).thenAnswer(
        (_) async => _user().copyWith(profilePicture: imageUrl),
      );

      final user = await container
          .read(profileActionsProvider)
          .uploadProfilePicture('/tmp/photo.jpg');

      expect(user.profilePicture, imageUrl);

      // Verify the update request used the uploaded URL
      final captured = verify(() => repo.updateProfile(captureAny()))
          .captured
          .first as UpdateProfileRequest;
      expect(captured.profilePicture, imageUrl);
    });

    test('propagates upload error from repository', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.uploadProfilePicture(any()))
          .thenThrow(Exception('upload failed'));

      await expectLater(
        container
            .read(profileActionsProvider)
            .uploadProfilePicture('/tmp/bad.jpg'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
