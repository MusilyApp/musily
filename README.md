<div align="center">
  <img src="assets/icons/ic_launcher_round.png" alt="Descrição da imagem" width="100px">
</div>

# Musily: A great music app.

This repository contains the source code for Musily, a music app built with Flutter.

### Download

Get it on [Telegram](https://t.me/MusilyApp).

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

### Tested On

Musily has been tested and works seamlessly on the following platforms:

- **Flutter SDK**: Version 3.22.3
- **Operating Systems**:
  - **Ubuntu 24.04 LTS** (GNOME)
  - **Nobara Linux 40** (GNOME Edition)

Make sure you have the correct Flutter version and system dependencies installed for an optimal experience.

---

### Linux Support

Musily supports Linux-based distributions with the following requirements:

**Dependencies**:  
To run Musily on Linux, you'll need the following libraries installed:

- **libmpv**: For audio playback using MPV media player.
- **libsecret**: For secure storage of user credentials and sensitive information.

#### Install Dependencies on Ubuntu/Debian-based Systems

```bash
sudo apt install libmpv-dev libsecret-1-dev libjsoncpp-dev
```

For other Linux distributions, please use the respective package managers (e.g., dnf for Fedora-based systems).

---

### Installation

1. **Clone this repository:**

```shell
git clone https://github.com/MusilyApp/musily.git
```

2. **Install dependencies:**

```shell
flutter pub get
```

3. **Run the app:**

To run Musily with a specific flavor, use the following commands:

- **Stable flavor:**

```shell
flutter run --flavor stable
```

- **Dev Flavor**

```shell
flutter run --flavor dev
```

### Contributions

Contributions are welcome! If you want to contribute to this project, please follow these steps:

1. **Fork this repository.**
2. **Create a new branch for your modification.**
3. **Make your changes and submit a pull request.**

### License

Musily is open-source and licensed under the GNU GENERAL PUBLIC LICENSE. You can find the full license text in the [LICENSE](LICENSE) file.

### Contact

For any questions or suggestions, please contact via [Telegram](https://t.me/FelipeYslaoker).
