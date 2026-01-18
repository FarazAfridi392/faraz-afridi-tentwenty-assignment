# Setup Instructions

## Prerequisites
1. Flutter SDK installed and in PATH
2. `.env` file in the root directory with `TMDB_API_KEY=your_api_key`

## Steps to Run

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate Floor database code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Important Notes

### Database Generation
The Floor database code needs to be generated using `build_runner`. After running the command above, the file `lib/data/datasources/local/database/app_database.g.dart` will be created.

### Video Player
The current video player implementation uses `video_player` which doesn't support YouTube URLs directly. For production, consider using `youtube_player_flutter` package or extracting the actual video stream URL from YouTube.

### API Key
Make sure to create a `.env` file with your TMDB API key:
```
TMDB_API_KEY=your_actual_api_key_here
```

## Project Structure

- `lib/data/` - Data layer with models, repositories, and data sources
- `lib/domain/` - Domain layer with entities, repositories, and use cases
- `lib/presentation/` - Presentation layer with screens, widgets, and providers
- `lib/core/` - Core utilities and constants

## Features Implemented

✅ Movie list screen with upcoming movies
✅ Movie detail screen with genres and overview
✅ Search functionality with debouncing
✅ Seat selection screen (UI only)
✅ Video player screen (needs YouTube support)
✅ Offline-first architecture with Floor database caching
✅ Landscape and portrait orientation support
✅ Clean architecture with Riverpod
