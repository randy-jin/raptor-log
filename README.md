# RaptorLog 🦅

A Flutter app for tracking raptor photography achievements. Four levels. One obsession.

## Achievement Levels

| Level | 中文 | Description |
|-------|------|-------------|
| 🟢 Green | 生态照 | Any record photo showing the bird |
| 🔵 Blue | 特写照 | Portrait shot showing plumage detail |
| 🟡 Yellow | 飞行照 | In-flight or action shot |
| 🔴 Red | 数毛级 | Magazine-quality sharp feather detail |

Unlocking a higher level auto-fills all lower levels.

## Tech Stack

- **Flutter** (iOS + Android)
- **Supabase** — Auth (magic link), PostgreSQL, Storage
- **Riverpod** — state management
- **go_router** — navigation

## First-Time Setup

### 1. Prerequisites

```bash
# Install Flutter if not installed
# https://docs.flutter.dev/get-started/install

flutter --version  # verify
```

### 2. Create the app scaffold

```bash
git clone <this-repo>
cd raptor-log

# Generate Flutter platform boilerplate (safe — won't overwrite lib/)
flutter create --org io.raptorlog --project-name raptor_log .
```

### 3. Configure Supabase

1. Create a project at https://supabase.com
2. Run `supabase/schema.sql` in the SQL Editor
3. Enable Auth → Email (magic link)
4. Create Storage bucket: `achievement-photos` (public read)
5. Copy your project URL and anon key into `lib/core/supabase_config.dart`

### 4. Run

```bash
flutter pub get
flutter run
```

## Deep Link (magic link auth)

Add to `AndroidManifest.xml`:
```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="io.raptorlog.app"/>
</intent-filter>
```

Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>io.raptorlog.app</string></array>
  </dict>
</array>
```

## Supabase Dashboard setup

In Authentication → URL Configuration:
- Site URL: `io.raptorlog.app://login-callback`
- Redirect URLs: add `io.raptorlog.app://login-callback`

## Project Structure

```
lib/
  core/         # theme, constants (36 species), Supabase config
  models/       # Species, Achievement (with non-linear unlock logic)
  services/     # species_service, achievement_service, storage_service
  providers/    # Riverpod providers + notifiers
  screens/
    auth/       # magic link login
    home/       # species grid tab + achievement stats tab
    species/    # add custom species sheet
  widgets/      # species_card, achievement_drawer, level_tile, progress_dots
supabase/
  schema.sql    # run this in Supabase SQL Editor
```
