# Google Authentication Configuration Guide

This document outlines the steps to configure Google Sign-In for the Spoken Club app.

## Prerequisites

- Google Cloud Console account
- Flutter SDK installed
- Access to the backend server configuration

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" → "New Project"
3. Enter project name and click "Create"
4. Select your newly created project

## Step 2: Configure OAuth Consent Screen

1. Navigate to **APIs & Services** → **OAuth consent screen**
2. Select **External** user type (or Internal for organization-only)
3. Fill in the required fields:
   - App name: `Spoken Club`
   - User support email: Your email
   - Developer contact email: Your email
4. Add scopes:
   - `email`
   - `profile`
   - `openid`
5. Add test users if in testing mode
6. Click "Save and Continue"

## Step 3: Create OAuth 2.0 Credentials

### For Android

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth client ID**
3. Select **Android** as application type
4. Enter:
   - Name: `Spoken Club Android`
   - Package name: `com.karigor.spokenclub`
   - SHA-1 certificate fingerprint (see below)
5. Click "Create"

#### Get SHA-1 Fingerprint

For debug keystore:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For release keystore:
```bash
keytool -list -v -keystore <path-to-release-keystore> -alias <alias-name>
```

### For iOS

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth client ID**
3. Select **iOS** as application type
4. Enter:
   - Name: `Spoken Club iOS`
   - Bundle ID: `com.karigor.spokenclub`
5. Click "Create"
6. Download the generated `.plist` file

### For Web (if applicable)

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth client ID**
3. Select **Web application** as application type
4. Enter:
   - Name: `Spoken Club Web`
   - Authorized JavaScript origins: Your web app URL
   - Authorized redirect URIs: Your callback URL
5. Click "Create"
6. Copy the Client ID

## Step 4: Configure Environment Variables

1. Open the `.env` file in the project root
2. Update the `GOOGLE_CLIENT_ID` with your Web Client ID:

```env
GOOGLE_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

3. Run the code generator to update `env.g.dart`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 5: Android Configuration

### Update `android/app/build.gradle.kts`

Ensure the application ID matches your Google Cloud configuration:

```kotlin
android {
    namespace = "com.karigor.spokenclub"

    defaultConfig {
        applicationId = "com.karigor.spokenclub"
        // ...
    }
}
```

### Add Internet Permission (if not present)

In `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Step 6: iOS Configuration

### Update `ios/Runner/Info.plist`

Add the reversed client ID URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_IOS_CLIENT_ID` with the client ID from your iOS OAuth credential (the part before `.apps.googleusercontent.com`).

### Update Bundle Identifier

Ensure the bundle identifier in Xcode matches `com.karigor.spokenclub`.

## Step 7: Backend Configuration

The backend server must be configured to:

1. Verify Google ID tokens at the `/auth/google` endpoint
2. Extract user information from the token
3. Create or update user records
4. Issue app-specific access and refresh tokens

### Expected API Contract

**Endpoint:** `POST /auth/google`

**Request Body:**
```json
{
  "idToken": "google-id-token-string"
}
```

**Response:**
```json
{
  "user": {
    "id": "user-id",
    "username": "username",
    "email": "user@example.com",
    "mobileNumber": "optional-phone",
    "avatar": "optional-avatar-url"
  },
  "tokens": {
    "accessToken": "jwt-access-token",
    "refreshToken": "jwt-refresh-token"
  }
}
```

## Step 8: Verify Installation

1. Run the app:
   ```bash
   flutter run
   ```

2. Navigate to the Welcome screen
3. Tap "Continue with Google"
4. Complete the Google Sign-In flow
5. Verify successful authentication

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `PlatformException(sign_in_failed)` | Verify SHA-1 fingerprint matches Google Cloud configuration |
| `ApiException: 10` | Check that package name/bundle ID is correct |
| `ApiException: 12500` | Ensure OAuth consent screen is properly configured |
| Sign-in popup doesn't appear | Verify internet connectivity and Google Play Services |

### Debug Tips

1. Check logs for detailed error messages:
   ```bash
   flutter run --verbose
   ```

2. Verify OAuth credentials in Google Cloud Console

3. Ensure the backend is running and accessible

4. Test with a Google account added as a test user (if app is in testing mode)

## File References

| File | Purpose |
|------|---------|
| `lib/core/config/env.dart` | Environment configuration |
| `lib/features/auth/data/google_auth_service.dart` | Google Sign-In service |
| `lib/features/auth/data/auth_repository.dart` | Authentication repository |
| `lib/features/auth/presentation/providers/auth_provider.dart` | Auth state management |
| `.env` | Environment variables |

## Security Notes

- Never commit the `.env` file with real credentials to version control
- Use different OAuth credentials for development and production
- Implement proper token refresh logic for expired tokens
- Store tokens securely using `flutter_secure_storage`
