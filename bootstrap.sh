#!/bin/bash
# RaptorLog first-time setup
set -e

echo "🦅 RaptorLog bootstrap"
echo "====================="

# Check Flutter
if ! command -v flutter &> /dev/null; then
  echo "❌ Flutter not found. Install from https://docs.flutter.dev/get-started/install"
  exit 1
fi
echo "✅ Flutter: $(flutter --version 2>&1 | head -1)"

# Generate platform scaffold (safe — skips existing lib/)
echo ""
echo "Generating Flutter platform scaffold..."
flutter create --org io.raptorlog --project-name raptor_log . 2>&1

# Get dependencies
echo ""
echo "Fetching packages..."
flutter pub get

echo ""
echo "✅ Done! Next steps:"
echo ""
echo "1. Fill in your Supabase credentials in lib/core/supabase_config.dart"
echo "2. Run the SQL schema: supabase/schema.sql"
echo "3. Configure deep link in iOS/Android (see README.md)"
echo "4. flutter run"
