## 5.0.2

**Fixes**
- Resolved a critical issue in shuffle mode where the current track could display a duration of 0, preventing playback from automatically advancing to the next track.

**Features**
- Added desktop drag-and-drop support for backup files and folders, making it easier to restore your library or add local folders directly from your file manager.

## 5.0.1

**Fixes**

- Fixed an issue where renaming playlists did not work.
- Fixed a problem that prevented adding tracks to playlists on Android.
- Fixed errors that occurred when starting the app without an internet connection.
- Restored proper initialization of YouTube Music after reconnecting to the internet — previously, the app required restarting with an active connection to regain access.

**Improvements**

- Added window control icons (minimize, maximize, close) for Windows and Linux, now displayed correctly when hovering over the buttons.
- Improved connection monitoring for a more reliable transition between online and offline modes.
- Enhanced audio extraction: the app now retrieves the highest audio quality available from YouTube.

## 5.0.0

**New Features**

- Refined and more consistent interface, with general improvements to visual organization and navigation.
- Improved UI/UX on desktop: better behavior with windows, mouse, and overall PC usage.
- Added Sleep Timer.
- Local Library: you can now add folders from your device to your library.
Note: The local library and the Musily library are managed separately to ensure data integrity.
- Persistent queue: your playback queue is preserved even after restarting the app.
- Offline mode: the app now automatically detects when there is no internet connection and switches to offline mode.
- Update Manager: you can now update the app or download other versions directly from within the application.

**Improvements**
**Backup**

- Backup and restore now run fully in the background without freezing the app — even with a high number of active downloads.
- Cross-platform backups are now more stable and reliable.
- Downloads
- Download system optimized with multiple simultaneous connections, dynamic speed control, and more reliable reconnections.
- Significantly faster download speeds — up to 50× faster depending on the connection.
- Multiple simultaneous downloads without freezing the application.

**Interface**

- The app’s accent color now changes automatically based on the currently playing track
(This behavior can be changed in the settings.)
- Feedback messages revised for improved clarity.
- Recommendations
- Enhanced recommendation algorithm, providing more relevant suggestions.
- Music suggestions shown on the home screen based on your listening profile.
- Playlists and Library
- Playlists now show total playback time.
- Older tracks without stored duration now have their duration updated automatically when played.

**Player – Stability Fixes**

- Several critical issues have been resolved:
- Fixed concurrency issues that caused the app to freeze when rapidly switching tracks.
- Repeat-one mode now works correctly.
- Fixed an issue that prevented playback from resuming after long periods of inactivity.
- The player now correctly moves to the next track at the end of playback on devices where it previously stopped unexpectedly.
- Fixed a bug that prevented users from reordering the queue.
- When playing a track from an album or playlist already in playback, in shuffle mode, an incorrect random track was sometimes selected — now fixed.
- Shuffle mode could destabilize the app — this has been fully resolved.

**Lyrics**

- Tracks without synced lyrics now display timing aligned with the playback timer.
- For some tracks without timestamps, automatic lyric syncing is generated.

**General Fixes**

- Windows: the download button now correctly switches to “Completed” when the download finishes.
- Various stability and performance improvements throughout the application.

**Interface and Localization**

- Added support for 13 new languages: French, German, Italian, Japanese, Chinese, Korean, Hindi, Indonesian, Turkish, Arabic, Polish, and Thai.

## 4.0.4

**Fixes**

- Fixed an issue where users were unable to load music streams.
- Resolved an issue preventing Musily from opening on Linux.

## 4.0.3

**Fixes**

- Fixed an issue where users were unable to load music streams.

## 4.0.2

**Fixes**

- Fixed an issue where the window title did not update when the song changed.
- Resolved regional issues by adding `CurlService`

**Features**

- New: Automatically scrolls to the start of the queue when the song changes.

## 4.0.1

**Fixes**

- Resolved an issue where the Smart Queue couldn't be disabled when empty.
- Fixed Smart Queue not working when when only one item is present in the queue.

**Improvments**

- Completely rewrote the audio playback system for better performance and stability.

**Desktop**

- Improved Windows icon resolution.
- Added a minimum window size to enhance window management.

## 4.0.0

**Features**

- Introduced timed lyrics support, allowing lyrics to synchronize with playback.
- Implemented accent color detection: system accent on desktop and wallpaper accent on Android.
- Added desktop support, enabling downloads and usage on Linux and Windows.
- Implemented native Android 12+ splash screen API for faster and smoother app launch experience.
- Enhanced queue management with intuitive song ordering: next songs appear first followed by previous tracks.
- Added smooth track transition animations in the now playing section.
- Added *in-app updater*, allowing users to update the app directly without leaving it (Android & Desktop only).

**Fixes**

- Fixed an issue where the app would close after importing a playlist from YouTube.
- Resolved an issue where the app would freeze after restoring a library backup.

## 3.1.1

**Improvements**

- Magic Queue: Fixed and completely redesigned for a smoother and smarter experience.

## 3.1.0

**Features**

- Added the ability to import playlists from YouTube to your library.

**Improvements**

- Improved library backup.
- Other UI improvments.

**Fixes**

- Fixed inconsistencies in the library.
- Resolved an issue where albums were not added to playlists or the queue from the menu.

## 3.0.0

**Features**

- Backup Library: Introduced functionality for seamless backup operations.
- Save Music to Downloads: Added the ability to save music directly to the downloads folder.

**Improvments**

- Enhanced UI: Improved the user interface for a more intuitive and visually appealing experience.
- Faster Downloads: Optimized download speeds for quicker and more efficient file transfers.

**Fixes**

- Navigation Bar Issues: Resolved bugs affecting phones with navigation bars instead of gesture-based navigation.

## 2.1.2

**Hot Fixes**

- Fixed an issue where music would load infinitely (again).

## 2.1.1

**Hot Fixes**

- Fixed an issue where music would load infinitely.
- Fixed a bug where the miniplayer was overlaying the last library item.

**Minor Improvements**

- Empty library message is now displayed correctly.

## 2.1.0

**Fixes**

- Resolved an issue where certain search terms resulted in empty search results.
- Addressed a problem where some artists couldn't be found.
- Fixed an issue where some albums were not being found.
- Resolved a bug where downloaded playlists were deleted when the download button was pressed.

**Localization**

- Added Ukrainian language support.

**Improvements**

- Enhanced the Magic Queue feature to better discover related tracks.

**Features**

- Introduced a new settings screen for managing language preferences and switching between dark and light themes.

**Minor Improvements**

- Various minor improvements and refinements.

## 2.0.0

**Features**

- Download Manager: Introduced a new download manager for better control and tracking of files.
- Library Filters: Apply filters to your library for easier organization.
- Search in Playlists and Albums: Added the ability to search within playlists and albums for more precise navigation.

**Localization**

- Improved Language Support: Added new translation entries for improved localization.
- Added Spanish Support: Full support for the Spanish language has been added.

**Improvements**

- Offline Mode Optimization: Improved performance in offline mode, providing a smoother and more efficient experience.
- Faster Library Loading: The library now loads faster, reducing wait times when browsing through your music and content.
- Increased Player Stability: Improved the stability of the player.

**Breaking change**

- Download Manager Incompatibility: The new download manager is not compatible with the previous version. As a result, all downloaded music will need to be re-downloaded.

## 1.2.0

- **Feature**: Option to disable lyrics sync
- **Feature**: Magic Queue - Discover new music with automatic recommendations added to your current playlist.
- **Localization:** Added Russian language support
- **Performance:** Optimizations in the Library section

## 1.1.0

### New Features

- **New Feature:** Lyrics
- **Multi-language Support:** English and Portuguese

### Fixes

- **Fixed:** Infinite loading when adding the first favorite song

### Improvements

- **Performance Improvements:** Optimizations in Lists
- **New Loading Animations**
- **Improvements in Favorites**
- **Player Enhancements**

## 1.0.1

- Fixed: Grey home screen
- Fixed: Get audio file directory
- Fixed: Navigation bar colors in white mode
- Fixed: Crashes when the user tries to play a song

## 1.0.0

- Initial version.
