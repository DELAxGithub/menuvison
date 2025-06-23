# MenuVision

A Flutter-based iOS app for scanning menu text and searching for dish images.

## Features

- Camera OCR for menu text recognition (supports English, French, German, Spanish)
- Tap detected text to search for dish images
- Image grid view with full-screen preview
- iOS-native design following Apple Human Interface Guidelines

## Setup

1. Create a `.env` file from `.env.example`:
   ```bash
   cp .env.example .env
   ```

2. Add your Google API credentials to `.env`:
   - `GOOGLE_CUSTOM_SEARCH_API_KEY`: Your Google Custom Search API key
   - `GOOGLE_SEARCH_ENGINE_ID`: Your Programmable Search Engine ID

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run on iOS simulator or device:
   ```bash
   flutter run
   ```

## License

This app is inspired by [MenuScan](https://github.com/recursiverob/MenuScan) (© 2023 recursiverob, MIT License).

## Development

Built with Flutter for iOS 15+. Uses:
- `camera` for photo capture
- `google_mlkit_text_recognition` for OCR
- Google Custom Search API for image search
- Cupertino widgets for iOS-native UI