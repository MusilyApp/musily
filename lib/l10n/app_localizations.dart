import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('ru'),
    Locale('uk')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @searchMusicAlbumOrArtist.
  ///
  /// In en, this message translates to:
  /// **'Search Music, Album, or Artist'**
  String get searchMusicAlbumOrArtist;

  /// No description provided for @musics.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get musics;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// No description provided for @addToQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get addToQueue;

  /// No description provided for @goToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Go to Album'**
  String get goToAlbum;

  /// No description provided for @goToArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to Artist'**
  String get goToArtist;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @shufflePlay.
  ///
  /// In en, this message translates to:
  /// **'Shuffle Play'**
  String get shufflePlay;

  /// No description provided for @addToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add to Library'**
  String get addToLibrary;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @topSongs.
  ///
  /// In en, this message translates to:
  /// **'Top Songs'**
  String get topSongs;

  /// No description provided for @topAlbums.
  ///
  /// In en, this message translates to:
  /// **'Top Albums'**
  String get topAlbums;

  /// No description provided for @topSingles.
  ///
  /// In en, this message translates to:
  /// **'Top Singles'**
  String get topSingles;

  /// No description provided for @similarArtists.
  ///
  /// In en, this message translates to:
  /// **'Similar Artists'**
  String get similarArtists;

  /// No description provided for @removeFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Remove from Library'**
  String get removeFromLibrary;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylist;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit Playlist'**
  String get editPlaylist;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @doYouWantToDeleteThePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the playlist?'**
  String get doYouWantToDeleteThePlaylist;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @theActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get theActionCannotBeUndone;

  /// No description provided for @playingNow.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get playingNow;

  /// No description provided for @emptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get emptyLibrary;

  /// No description provided for @emptyLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Add items to your library to see them here'**
  String get emptyLibraryDescription;

  /// No description provided for @albumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get albumNotFound;

  /// No description provided for @artistNotFound.
  ///
  /// In en, this message translates to:
  /// **'Artist not found'**
  String get artistNotFound;

  /// No description provided for @cancelDownload.
  ///
  /// In en, this message translates to:
  /// **'Cancel Download'**
  String get cancelDownload;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @singles.
  ///
  /// In en, this message translates to:
  /// **'Singles'**
  String get singles;

  /// No description provided for @noMoreSingles.
  ///
  /// In en, this message translates to:
  /// **'No more singles available for this artist.'**
  String get noMoreSingles;

  /// No description provided for @noMoreAlbums.
  ///
  /// In en, this message translates to:
  /// **'No more albums available for this artist.'**
  String get noMoreAlbums;

  /// No description provided for @songsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No songs found.'**
  String get songsNotFound;

  /// No description provided for @playlistNotFound.
  ///
  /// In en, this message translates to:
  /// **'Playlist not found.'**
  String get playlistNotFound;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @deleteDownload.
  ///
  /// In en, this message translates to:
  /// **'Delete Download'**
  String get deleteDownload;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'You have no playlists.'**
  String get noPlaylists;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get removeFromPlaylist;

  /// No description provided for @downloadManager.
  ///
  /// In en, this message translates to:
  /// **'Download Manager'**
  String get downloadManager;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @lyricsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Lyrics not found'**
  String get lyricsNotFound;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to the clipboard'**
  String get copiedToClipboard;

  /// No description provided for @noDownloads.
  ///
  /// In en, this message translates to:
  /// **'No downloads'**
  String get noDownloads;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @downloadCompleted.
  ///
  /// In en, this message translates to:
  /// **'Download completed'**
  String get downloadCompleted;

  /// No description provided for @selectALanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get selectALanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your e-mail'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid e-mail'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @passwordMustBeAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustBeAtLeast8Characters;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get internalServerError;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request'**
  String get invalidRequest;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'The email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// No description provided for @itemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get itemNotFound;

  /// No description provided for @invalidUserId.
  ///
  /// In en, this message translates to:
  /// **'Invalid user ID'**
  String get invalidUserId;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @comeCheckTEMPLATEOnMusily.
  ///
  /// In en, this message translates to:
  /// **'Come check TEMPLATE on Musily!'**
  String get comeCheckTEMPLATEOnMusily;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @backupLibrary.
  ///
  /// In en, this message translates to:
  /// **'Backup Library'**
  String get backupLibrary;

  /// No description provided for @backupCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully!'**
  String get backupCompletedSuccessfully;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @includeLibrary.
  ///
  /// In en, this message translates to:
  /// **'Include Library'**
  String get includeLibrary;

  /// No description provided for @includeDownloads.
  ///
  /// In en, this message translates to:
  /// **'Include Downloads'**
  String get includeDownloads;

  /// No description provided for @startBackup.
  ///
  /// In en, this message translates to:
  /// **'Start Backup'**
  String get startBackup;

  /// No description provided for @doYouWantToRestoreThisBackup.
  ///
  /// In en, this message translates to:
  /// **'Do you want to restore this backup?'**
  String get doYouWantToRestoreThisBackup;

  /// No description provided for @backupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Backup in progress'**
  String get backupInProgress;

  /// No description provided for @backupRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get backupRestoredSuccessfully;

  /// No description provided for @backupFileDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Backup file does not exist'**
  String get backupFileDoesNotExist;

  /// No description provided for @musicSavedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Music saved to downloads'**
  String get musicSavedToDownloads;

  /// No description provided for @saveToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads'**
  String get saveToDownloads;

  /// No description provided for @importingPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Importing Playlist'**
  String get importingPlaylist;

  /// No description provided for @playlistNameOrUrl.
  ///
  /// In en, this message translates to:
  /// **'Playlist name or URL'**
  String get playlistNameOrUrl;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @whenClosingTheApplication.
  ///
  /// In en, this message translates to:
  /// **'When closing the application'**
  String get whenClosingTheApplication;

  /// No description provided for @showWindow.
  ///
  /// In en, this message translates to:
  /// **'Show Window'**
  String get showWindow;

  /// No description provided for @closeWindow.
  ///
  /// In en, this message translates to:
  /// **'Close Window'**
  String get closeWindow;

  /// No description provided for @newUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New Update Available'**
  String get newUpdateAvailable;

  /// No description provided for @defaultColor.
  ///
  /// In en, this message translates to:
  /// **'Default Color'**
  String get defaultColor;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @recommendedAlbums.
  ///
  /// In en, this message translates to:
  /// **'Recommended Albums'**
  String get recommendedAlbums;

  /// No description provided for @recommendedMusic.
  ///
  /// In en, this message translates to:
  /// **'Recommended Music'**
  String get recommendedMusic;

  /// No description provided for @moreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'More Recommendations'**
  String get moreRecommendations;

  /// No description provided for @cancelOperation.
  ///
  /// In en, this message translates to:
  /// **'Cancel Operation?'**
  String get cancelOperation;

  /// No description provided for @cancelBackupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the backup? Progress will be lost.'**
  String get cancelBackupConfirmation;

  /// No description provided for @cancelRestoreConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the restore? Progress will be lost.'**
  String get cancelRestoreConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @initializingBackup.
  ///
  /// In en, this message translates to:
  /// **'Initializing backup...'**
  String get initializingBackup;

  /// No description provided for @creatingBackupArchive.
  ///
  /// In en, this message translates to:
  /// **'Creating backup archive...'**
  String get creatingBackupArchive;

  /// No description provided for @backingUpDownloadsMetadata.
  ///
  /// In en, this message translates to:
  /// **'Backing up downloads metadata...'**
  String get backingUpDownloadsMetadata;

  /// No description provided for @backingUpAudioFiles.
  ///
  /// In en, this message translates to:
  /// **'Backing up audio files...'**
  String get backingUpAudioFiles;

  /// No description provided for @backingUpLibraryData.
  ///
  /// In en, this message translates to:
  /// **'Backing up library data...'**
  String get backingUpLibraryData;

  /// No description provided for @writingBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Writing backup file...'**
  String get writingBackupFile;

  /// No description provided for @savingToStorage.
  ///
  /// In en, this message translates to:
  /// **'Saving to storage...'**
  String get savingToStorage;

  /// No description provided for @backupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Backup cancelled'**
  String get backupCancelled;

  /// No description provided for @startingBackup.
  ///
  /// In en, this message translates to:
  /// **'Starting backup...'**
  String get startingBackup;

  /// No description provided for @startingRestore.
  ///
  /// In en, this message translates to:
  /// **'Starting restore...'**
  String get startingRestore;

  /// No description provided for @initializingRestore.
  ///
  /// In en, this message translates to:
  /// **'Initializing restore...'**
  String get initializingRestore;

  /// No description provided for @readingBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Reading backup file...'**
  String get readingBackupFile;

  /// No description provided for @extractingLibraryData.
  ///
  /// In en, this message translates to:
  /// **'Extracting library data...'**
  String get extractingLibraryData;

  /// No description provided for @extractingDownloadsData.
  ///
  /// In en, this message translates to:
  /// **'Extracting downloads data...'**
  String get extractingDownloadsData;

  /// No description provided for @extractingAudioFiles.
  ///
  /// In en, this message translates to:
  /// **'Extracting audio files...'**
  String get extractingAudioFiles;

  /// No description provided for @finalizingRestore.
  ///
  /// In en, this message translates to:
  /// **'Finalizing restore...'**
  String get finalizingRestore;

  /// No description provided for @restoreCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully!'**
  String get restoreCompletedSuccessfully;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreFailed;

  /// No description provided for @backupFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Backup file not found'**
  String get backupFileNotFound;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to: {filename}'**
  String savedTo(String filename);

  /// No description provided for @playlistEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your playlist a fresh identity.'**
  String get playlistEditSubtitle;

  /// No description provided for @playlistDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get playlistDetailsTitle;

  /// No description provided for @playlistEmptyStateDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist to start saving your favourite tracks.'**
  String get playlistEmptyStateDescription;

  /// No description provided for @playlistSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a playlist'**
  String get playlistSelectTitle;

  /// No description provided for @playlistSelectDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose where the selected tracks should be added.'**
  String get playlistSelectDescription;

  /// No description provided for @playlistCreatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a name or paste a playlist link'**
  String get playlistCreatorSubtitle;

  /// No description provided for @playlistCreatorPasteInfo.
  ///
  /// In en, this message translates to:
  /// **'You can paste a YouTube playlist URL to import it automatically.'**
  String get playlistCreatorPasteInfo;

  /// No description provided for @artistNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The artist you are looking for was not found.'**
  String get artistNotFoundDescription;

  /// No description provided for @artistNoSinglesDescription.
  ///
  /// In en, this message translates to:
  /// **'No singles available for this artist.'**
  String get artistNoSinglesDescription;

  /// No description provided for @artistNoAlbumsDescription.
  ///
  /// In en, this message translates to:
  /// **'No albums available for this artist.'**
  String get artistNoAlbumsDescription;

  /// No description provided for @artistNoSongsDescription.
  ///
  /// In en, this message translates to:
  /// **'No songs available for this artist.'**
  String get artistNoSongsDescription;

  /// No description provided for @lyricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lyrics available for this track.'**
  String get lyricsNotAvailable;

  /// No description provided for @queueEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your queue is empty'**
  String get queueEmptyTitle;

  /// No description provided for @queueEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add songs to the queue to enjoy your music experience.'**
  String get queueEmptyMessage;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @downloadsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your downloaded tracks will appear here.'**
  String get downloadsEmptyMessage;

  /// No description provided for @downloadingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloadingSectionTitle;

  /// No description provided for @queuedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queuedSectionTitle;

  /// No description provided for @completedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedSectionTitle;

  /// No description provided for @failedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedSectionTitle;

  /// No description provided for @searchSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get searchSuggestions;

  /// No description provided for @searchStartTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search'**
  String get searchStartTyping;

  /// No description provided for @smartSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestionsTitle;

  /// No description provided for @smartSuggestionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Auto-add similar tracks'**
  String get smartSuggestionsDescription;

  /// No description provided for @libraryManagementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Library Management'**
  String get libraryManagementSectionTitle;

  /// No description provided for @backupLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a backup of your library'**
  String get backupLibraryDescription;

  /// No description provided for @restoreLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore your library from a backup'**
  String get restoreLibraryDescription;

  /// No description provided for @includeLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Backup your saved albums, artists, and playlists'**
  String get includeLibraryDescription;

  /// No description provided for @includeDownloadsDescription.
  ///
  /// In en, this message translates to:
  /// **'Backup your downloaded tracks'**
  String get includeDownloadsDescription;

  /// No description provided for @fullScreenPlayerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Full screen player'**
  String get fullScreenPlayerTooltip;

  /// No description provided for @sleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Sleep Timer'**
  String get sleepTimer;

  /// No description provided for @sleepTimerDescription.
  ///
  /// In en, this message translates to:
  /// **'Music will pause after selected time'**
  String get sleepTimerDescription;

  /// No description provided for @sleepTimerActive.
  ///
  /// In en, this message translates to:
  /// **'Sleep timer: {time}'**
  String sleepTimerActive(String time);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes(int count);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String hours(int count);

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get hour;

  /// No description provided for @customTime.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customTime;

  /// No description provided for @enterTime.
  ///
  /// In en, this message translates to:
  /// **'Enter time'**
  String get enterTime;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hoursLabel;

  /// No description provided for @cancelTimer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Timer'**
  String get cancelTimer;

  /// No description provided for @cancelTimerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel the sleep timer?'**
  String get cancelTimerQuestion;

  /// No description provided for @timerInfo.
  ///
  /// In en, this message translates to:
  /// **'Timer active for {time}'**
  String timerInfo(String time);

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
