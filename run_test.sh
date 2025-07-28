#!/bin/bash

# Home Page Test Runner Script
# This script helps you quickly test your home page and Firebase connection

echo "🚀 Pakaije Home Page Test Runner"
echo "================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter and try again"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n1)"
echo ""

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Not in a Flutter project directory"
    echo "Please run this script from your Flutter project root"
    exit 1
fi

echo "✅ Flutter project detected"
echo ""

# Check if test file exists
if [ ! -f "test_home_page.dart" ]; then
    echo "❌ test_home_page.dart not found"
    echo "Please make sure the test file is in the project root"
    exit 1
fi

echo "✅ Test file found"
echo ""

# Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo "✅ Dependencies updated"
echo ""

# Check for connected devices
echo "📱 Checking for connected devices..."
flutter devices

echo ""
echo "🎯 Choose how to run the test:"
echo "1. Run test file directly (recommended)"
echo "2. Temporarily replace main.dart"
echo "3. Just show instructions"
echo ""

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Running test file directly..."
        echo "Make sure you have a device connected or emulator running"
        echo ""
        flutter run test_home_page.dart
        ;;
    2)
        echo ""
        echo "⚠️  Backing up original main.dart..."
        cp lib/main.dart lib/main.dart.backup
        
        echo "🔄 Replacing main.dart with test content..."
        cp test_home_page.dart lib/main.dart
        
        echo "🚀 Running test app..."
        flutter run
        
        echo ""
        echo "🔄 Restoring original main.dart..."
        cp lib/main.dart.backup lib/main.dart
        rm lib/main.dart.backup
        echo "✅ Original main.dart restored"
        ;;
    3)
        echo ""
        echo "📖 Please read TEST_INSTRUCTIONS.md for detailed instructions"
        echo ""
        echo "Quick start:"
        echo "1. Open Android Studio"
        echo "2. Open this project"
        echo "3. Run test_home_page.dart"
        echo "4. Test your home page and Firebase connection"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Test runner completed!"
echo "📖 Check TEST_INSTRUCTIONS.md for more details"