## 5.0.2

**Poprawki**
- Rozwiązano krytyczny problem w trybie losowym, gdzie bieżący utwór mógł wyświetlać czas trwania 0, uniemożliwiając automatyczne przejście do następnego utworu.

**Funkcje**
- Dodano obsługę przeciągania i upuszczania na pulpicie dla plików kopii zapasowych i folderów, ułatwiając przywracanie biblioteki lub dodawanie lokalnych folderów bezpośrednio z menedżera plików.

## 5.0.1

**Poprawki**

- Naprawiono problem, w którym zmiana nazwy list odtwarzania nie działała.
- Naprawiono problem, który uniemożliwiał dodawanie utworów do list odtwarzania w systemie Android.
- Naprawiono błędy występujące przy uruchamianiu aplikacji bez połączenia z internetem.
- Przywrócono prawidłową inicjalizację YouTube Music po ponownym połączeniu z internetem — wcześniej aplikacja wymagała ponownego uruchomienia z aktywnym połączeniem, aby odzyskać dostęp.

**Ulepszenia**

- Dodano ikony sterowania oknem (minimalizuj, maksymalizuj, zamknij) dla systemów Windows i Linux, teraz wyświetlane poprawnie po najechaniu myszką na przyciski.
- Ulepszono monitorowanie połączenia dla bardziej niezawodnego przejścia między trybami online i offline.
- Ulepszono ekstrakcję audio: aplikacja teraz pobiera najwyższą dostępną jakość audio z YouTube.

## 5.0.0

**Nowe Funkcje**

- Dopracowany i bardziej spójny interfejs z ogólnymi ulepszeniami organizacji wizualnej i nawigacji.
- Ulepszona UI/UX na pulpicie: lepsze zachowanie z oknami, myszą i ogólnym użyciem komputera PC.
- Dodano Timer Snu.
- Lokalna Biblioteka: możesz teraz dodawać foldery ze swojego urządzenia do biblioteki.
Uwaga: Biblioteka lokalna i biblioteka Musily są zarządzane oddzielnie, aby zapewnić integralność danych.
- Trwała Kolejka: twoja kolejka odtwarzania jest zachowywana nawet po ponownym uruchomieniu aplikacji.
- Tryb Offline: aplikacja automatycznie wykrywa, gdy nie ma połączenia internetowego i przełącza się w tryb offline.
- Menedżer Aktualizacji: możesz teraz aktualizować aplikację lub pobierać inne wersje bezpośrednio z aplikacji.

**Ulepszenia**
**Kopia Zapasowa**

- Kopia zapasowa i przywracanie działają teraz w pełni w tle bez zawieszania aplikacji — nawet przy dużej liczbie aktywnych pobierań.
- Kopie zapasowe międzyplatformowe są teraz bardziej stabilne i niezawodne.
**Pobieranie**

- System pobierania zoptymalizowany z wieloma jednoczesnymi połączeniami, dynamiczną kontrolą prędkości i bardziej niezawodnymi ponownymi połączeniami.
- Znacznie szybsze prędkości pobierania — do 50× szybsze w zależności od połączenia.
- Wiele jednoczesnych pobierań bez zawieszania aplikacji.

**Interfejs**

- Kolor akcentu aplikacji zmienia się teraz automatycznie w zależności od aktualnie odtwarzanego utworu
(To zachowanie można zmienić w ustawieniach.)
- Wiadomości zwrotne zostały poprawione dla lepszej przejrzystości.
**Rekomendacje**

- Ulepszony algorytm rekomendacji, zapewniający bardziej istotne sugestie.
- Sugestie muzyczne wyświetlane na ekranie głównym na podstawie Twojego profilu słuchania.
**Listy Odtwarzania i Biblioteka**

- Listy odtwarzania pokazują teraz całkowity czas odtwarzania.
- Starsze utwory bez przechowywanego czasu trwania mają teraz automatycznie aktualizowany czas trwania podczas odtwarzania.

**Odtwarzacz – Poprawki Stabilności**

- Rozwiązano kilka krytycznych problemów:
- Naprawiono problemy z współbieżnością, które powodowały zawieszanie aplikacji podczas szybkiego przełączania utworów.
- Tryb powtarzania jednego utworu działa teraz poprawnie.
- Naprawiono problem, który uniemożliwiał wznowienie odtwarzania po długich okresach bezczynności.
- Odtwarzacz poprawnie przechodzi teraz do następnego utworu na końcu odtwarzania na urządzeniach, na których wcześniej zatrzymywał się nieoczekiwanie.
- Naprawiono błąd, który uniemożliwiał użytkownikom zmienianie kolejności kolejki.
- Podczas odtwarzania utworu z albumu lub listy odtwarzania już w odtwarzaniu, w trybie losowym czasami wybierany był nieprawidłowy losowy utwór — teraz naprawione.
- Tryb losowy mógł destabilizować aplikację — zostało to w pełni rozwiązane.

**Teksty Piosenek**

- Utwory bez zsynchronizowanych tekstów pokazują teraz czas zgodny z licznikiem odtwarzania.
- Dla niektórych utworów bez znaczników czasu generowana jest automatyczna synchronizacja tekstów.

**Ogólne Poprawki**

- Windows: przycisk pobierania przełącza się teraz poprawnie na "Ukończono", gdy pobieranie się zakończy.
- Różne ulepszenia stabilności i wydajności w całej aplikacji.

**Interfejs i Lokalizacja**

- Dodano obsługę 13 nowych języków: Francuski, Niemiecki, Włoski, Japoński, Chiński, Koreański, Hindi, Indonezyjski, Turecki, Arabski, Polski i Tajski.

## 4.0.4

**Poprawki**

- Naprawiono problem, w którym użytkownicy nie mogli ładować strumieni muzycznych.
- Rozwiązano problem, który uniemożliwiał otwarcie Musily w systemie Linux.

## 4.0.3

**Poprawki**

- Naprawiono problem, w którym użytkownicy nie mogli ładować strumieni muzycznych.

## 4.0.2

**Poprawki**

- Naprawiono problem, w którym tytuł okna nie aktualizował się po zmianie muzyki.
- Rozwiązano problemy regionalne poprzez dodanie `CurlService`

**Funkcje**

- Nowość: Automatycznie przewija na początek kolejki po zmianie muzyki.

## 4.0.1

**Poprawki**

- Rozwiązano problem, w którym Inteligentna Kolejka nie mogła być wyłączona, gdy była pusta.
- Naprawiono problem, w którym Inteligentna Kolejka nie działała, gdy w kolejce znajdował się tylko jeden element.

**Ulepszenia**

- Całkowicie przepisano system odtwarzania audio w celu poprawy wydajności i stabilności.

**Pulpit**

- Poprawiono rozdzielczość ikony Windows.
- Dodano minimalny rozmiar okna w celu poprawy zarządzania oknami.

## 4.0.0

**Funkcje**

- Wprowadzono wsparcie dla zsynchronizowanych tekstów piosenek, umożliwiając synchronizację tekstów z odtwarzaniem.
- Zaimplementowano wykrywanie koloru akcentu: akcent systemowy na pulpicie i akcent tapety w systemie Android.
- Dodano wsparcie dla pulpitu, umożliwiając pobieranie i używanie w systemach Linux i Windows.
- Zaimplementowano natywne API ekranu startowego Android 12+ dla szybszego i płynniejszego uruchamiania aplikacji.
- Ulepszono zarządzanie kolejką dzięki intuicyjnemu sortowaniu utworów: następne utwory pojawiają się najpierw, a następnie poprzednie utwory.
- Dodano płynne animacje przejść utworów w sekcji aktualnego odtwarzania.
- Dodano *aktualizator w aplikacji*, umożliwiając użytkownikom aktualizowanie aplikacji bezpośrednio bez jej opuszczania (tylko Android i Pulpit).

**Poprawki**

- Naprawiono problem, w którym aplikacja zamykała się po zaimportowaniu playlisty z YouTube.
- Rozwiązano problem, w którym aplikacja zawieszała się po przywróceniu kopii zapasowej biblioteki.

## 3.1.1

**Ulepszenia**

- Magiczna Kolejka: Naprawiona i całkowicie przeprojektowana dla bardziej płynnego i inteligentnego doświadczenia.

## 3.1.0

**Funkcje**

- Dodano możliwość importowania playlist z YouTube do swojej biblioteki.

**Ulepszenia**

- Ulepszono kopię zapasową biblioteki.
- Inne ulepszenia interfejsu użytkownika.

**Poprawki**

- Naprawiono niespójności w bibliotece.
- Rozwiązano problem, w którym albumy nie były dodawane do playlist lub kolejki z menu.

## 3.0.0

**Funkcje**

- Kopia Zapasowa Biblioteki: Wprowadzono funkcjonalność do płynnych operacji kopii zapasowej.
- Zapisz Muzykę w Pobraniach: Dodano możliwość zapisywania muzyki bezpośrednio w folderze pobierania.

**Ulepszenia**

- Ulepszony Interfejs: Ulepszono interfejs użytkownika dla bardziej intuicyjnego i wizualnie atrakcyjnego doświadczenia.
- Szybsze Pobieranie: Zoptymalizowano prędkości pobierania dla szybszych i bardziej efektywnych transferów plików.

**Poprawki**

- Problemy z Paskiem Nawigacji: Rozwiązano błędy wpływające na telefony z paskami nawigacji zamiast nawigacji opartej na gestach.

## 2.1.2

**Szybkie Poprawki**

- Naprawiono problem, w którym muzyka ładowała się w nieskończoność (ponownie).

## 2.1.1

**Szybkie Poprawki**

- Naprawiono problem, w którym muzyka ładowała się w nieskończoność.
- Naprawiono błąd, w którym miniodtwarzacz nakładał się na ostatni element biblioteki.

**Drobne Ulepszenia**

- Wiadomość o pustej bibliotece jest teraz wyświetlana poprawnie.

## 2.1.0

**Poprawki**

- Rozwiązano problem, w którym niektóre terminy wyszukiwania powodowały puste wyniki wyszukiwania.
- Rozwiązano problem, w którym niektórzy artyści nie mogli być znalezieni.
- Naprawiono problem, w którym niektóre albumy nie były znajdowane.
- Rozwiązano błąd, w którym pobrane playlisty były usuwane po naciśnięciu przycisku pobierania.

**Lokalizacja**

- Dodano wsparcie dla języka ukraińskiego.

**Ulepszenia**

- Ulepszono funkcjonalność Magicznej Kolejki, aby lepiej odkrywać powiązane utwory.

**Funkcje**

- Wprowadzono nowy ekran ustawień do zarządzania preferencjami języka i przełączania między motywami ciemnymi i jasnymi.

**Drobne Ulepszenia**

- Różne drobne ulepszenia i dopracowania.

## 2.0.0

**Funkcje**

- Menedżer Pobierania: Wprowadzono nowego menedżera pobierania dla lepszej kontroli i śledzenia plików.
- Filtry Biblioteki: Zastosuj filtry do swojej biblioteki dla łatwiejszej organizacji.
- Wyszukiwanie w Playlistach i Albumach: Dodano możliwość wyszukiwania w playlistach i albumach dla dokładniejszej nawigacji.

**Lokalizacja**

- Ulepszone Wsparcie Językowe: Dodano nowe wpisy tłumaczeń dla lepszej lokalizacji.
- Dodano Wsparcie dla Hiszpańskiego: Dodano pełne wsparcie dla języka hiszpańskiego.

**Ulepszenia**

- Optymalizacja Trybu Offline: Ulepszono wydajność w trybie offline, zapewniając bardziej płynne i efektywne doświadczenie.
- Szybsze Ładowanie Biblioteki: Biblioteka ładuje się teraz szybciej, skracając czas oczekiwania podczas przeglądania muzyki i treści.
- Zwiększona Stabilność Odtwarzacza: Ulepszono stabilność odtwarzacza.

**Niekompatybilna Zmiana**

- Niekompatybilność Menedżera Pobierania: Nowy menedżer pobierania nie jest kompatybilny z poprzednią wersją. W rezultacie cała pobrana muzyka będzie musiała zostać pobrana ponownie.

## 1.2.0

- **Funkcja**: Opcja wyłączenia synchronizacji tekstów piosenek
- **Funkcja**: Magiczna Kolejka - Odkryj nową muzykę z automatycznymi rekomendacjami dodawanymi do swojej obecnej playlisty.
- **Lokalizacja:** Dodano wsparcie dla języka rosyjskiego
- **Wydajność:** Optymalizacje w sekcji Biblioteki

## 1.1.0

### Nowe Funkcje

- **Nowa Funkcja:** Teksty Piosenek
- **Wielojęzyczne Wsparcie:** Angielski i Portugalski

### Poprawki

- **Naprawiono:** Nieskończone ładowanie przy dodawaniu pierwszej ulubionej piosenki

### Ulepszenia

- **Ulepszenia Wydajności:** Optymalizacje w Listach
- **Nowe Animacje Ładowania**
- **Ulepszenia w Ulubionych**
- **Ulepszenia Odtwarzacza**

## 1.0.1

- Naprawiono: Szary ekran główny
- Naprawiono: Pobieranie katalogu pliku audio
- Naprawiono: Kolory paska nawigacji w trybie jasnym
- Naprawiono: Awarie, gdy użytkownik próbuje odtworzyć piosenkę

## 1.0.0

- Wersja początkowa.

