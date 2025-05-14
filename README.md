<div align="center">
  <img src="assets/icons/ic_launcher_round.png" alt="Musily Logo" width="100px">
</div>

# Musily: A great music app.

This repository contains the source code for Musily, a music app built with Flutter.

### Download

Get it on [Telegram](https://t.me/MusilyApp) or [GitHub](https://github.com/MusilyApp/musily/releases).

### Features

- **User-friendly interface:** Musily has an intuitive and easy-to-use interface.
- **Powerful search:** Easily find songs, artists, and albums using our advanced search bar.
- **Offline playback:** Download your favorite songs and listen to them without an internet connection.
- **Library management:** Create and edit custom playlists.

---

### Screenshots

| ![Home Page](assets/screenshots/mobile/home.jpg)          | ![Album Page](assets/screenshots/mobile/album.jpg) | ![Artist Page](assets/screenshots/mobile/artist.jpg) |
| --------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------- |
| ![Playlist Page](assets/screenshots/mobile/favorites.jpg) | ![Player](assets/screenshots/mobile/player.jpg)    | ![Lyrics](assets/screenshots/mobile/lyrics.jpg)      |

---

### Technologies

- **Programming Language:** Dart
- **Framework:** Flutter

---

### Prerequisites

Before you begin, ensure you have Flutter installed. You can find installation instructions on the [official Flutter website](https://docs.flutter.dev/get-started/install).

---

### Tested On

Musily has been tested and works seamlessly on the following platforms:

- **Flutter SDK**: 3.27.4
- **Operating Systems**:
  - **Debian 13 Trixie** (GNOME)
  - **Kubuntu 25.04** (KDE)
  - **Windows 11**

Make sure you have the correct Flutter version and system dependencies installed for an optimal experience.

---

### Linux Setup

> **Note:** The system tray feature requires `libayatana-appindicator3` (or `libappindicator-gtk3`). This has been tested on Debian 13 (GNOME). Functionality on other desktop environments or distributions may vary.

Musily is compatible with most Linux-based distributions. To ensure the app functions properly when building or running from source, please install the following required dependencies.

**Required Dependencies**:

The following libraries must be installed:

- **libmpv**: For audio playback using MPV media player.
- **libsecret**: For secure storage of user credentials and sensitive information.
- **libjsoncpp**: Required for JSON handling (dependency of Flutter Secure Storage).
- **gnome-keyring**: Provides the backend service for `libsecret`.
- **libayatana-appindicator3 / libappindicator-gtk3**: For system tray integration.

#### Install Dependencies on Ubuntu/Debian-based Systems

```bash
sudo apt update && sudo apt install libmpv-dev libsecret-1-dev libjsoncpp-dev gnome-keyring libayatana-appindicator3-dev
```

#### Install Dependencies on Other Linux Distributions

- **Fedora/RHEL (Not Tested)**:

```bash
sudo dnf update && sudo dnf install mpv-devel libsecret-devel jsoncpp-devel gnome-keyring libappindicator-gtk3-devel
```

- **Arch/Manjaro (Not Tested)**:

```bash
sudo pacman -Syu mpv libsecret jsoncpp gnome-keyring libappindicator-gtk3
```

---

### Windows Setup

For building and running Musily from source on Windows, you'll need to set up your development environment. This includes installing Rust via Rustup, which might be required by certain Flutter dependencies for native code compilation.

**1. Install Rustup:**

- Go to the official Rust website: [https://rustup.rs/](https://rustup.rs/)
- Download the `rustup-init.exe` installer for Windows.
- Run the downloaded installer.

**2. Install Visual Studio Build Tools:**

- Download the [Visual Studio Installer](https://visualstudio.microsoft.com/downloads/).
- Install the "Desktop development with C++" workload.

**3. Enable Developer Mode**

- Open Settings from the Start menu.
- Go to Update & Security > For Developers.
- Enable Developer Mode.
---

### Building and Running from Source

1. **Clone this repository:**

```shell
git clone https://github.com/MusilyApp/musily.git
cd musily
```

2. **Install Flutter dependencies:**

```shell
flutter pub get
```

3. **Run the app:**

To run Musily with a specific flavor on **Android**, use the following commands:

- **Stable flavor:**

```shell
flutter run --flavor stable
```

- **Dev Flavor**

```shell
flutter run --flavor dev
```

For other platforms, simply use:

```shell
flutter run
```

---

### Contributions

Contributions are welcome! If you want to contribute to this project, please follow these steps:

1.  **Fork this repository.**
2.  **Create a new branch for your modification.**
3.  **Make your changes and submit a pull request.**

---

### License

Musily is open-source and licensed under the GNU GENERAL PUBLIC LICENSE. You can find the full license text in the [LICENSE](LICENSE) file.

---

### Contact

For any questions or suggestions, please contact via [Telegram](https://t.me/FelipeYslaoker) or [E-mail](mailto:contact@musily.app).