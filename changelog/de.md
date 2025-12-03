## 5.0.2

**Fehlerbehebungen**
- Behoben: Ein kritisches Problem im Zufallsmodus, bei dem der aktuelle Titel eine Dauer von 0 anzeigen konnte, was verhinderte, dass die Wiedergabe automatisch zum nächsten Titel wechselte.

**Funktionen**
- Hinzugefügt: Drag-and-Drop-Unterstützung auf dem Desktop für Backup-Dateien und Ordner, was es einfacher macht, Ihre Bibliothek wiederherzustellen oder lokale Ordner direkt aus Ihrem Dateimanager hinzuzufügen.

## 5.0.1

**Fehlerbehebungen**

- Behoben: Ein Problem, bei dem das Umbenennen von Wiedergabelisten nicht funktionierte.
- Behoben: Ein Problem, das das Hinzufügen von Titeln zu Wiedergabelisten auf Android verhinderte.
- Behoben: Fehler, die beim Starten der App ohne Internetverbindung auftraten.
- Wiederhergestellt: Die ordnungsgemäße Initialisierung von YouTube Music nach der erneuten Verbindung mit dem Internet — zuvor musste die App mit einer aktiven Verbindung neu gestartet werden, um den Zugriff wiederzuerlangen.

**Verbesserungen**

- Hinzugefügt: Fenstersteuerungssymbole (Minimieren, Maximieren, Schließen) für Windows und Linux, die jetzt korrekt angezeigt werden, wenn Sie mit der Maus über die Schaltflächen fahren.
- Verbessert: Die Verbindungsüberwachung für einen zuverlässigeren Übergang zwischen Online- und Offline-Modi.
- Verbessert: Die Audioextraktion: Die App ruft jetzt die höchste verfügbare Audioqualität von YouTube ab.

## 5.0.0

**Neue Funktionen**

- Verfeinerte und konsistentere Benutzeroberfläche mit allgemeinen Verbesserungen der visuellen Organisation und Navigation.
- Verbesserte UI/UX auf dem Desktop: besseres Verhalten mit Fenstern, Maus und allgemeiner PC-Nutzung.
- Schlaf-Timer hinzugefügt.
- Lokale Bibliothek: Sie können jetzt Ordner von Ihrem Gerät zu Ihrer Bibliothek hinzufügen.
Hinweis: Die lokale Bibliothek und die Musily-Bibliothek werden getrennt verwaltet, um die Datenintegrität zu gewährleisten.
- Persistente Warteschlange: Ihre Wiedergabewarteschlange bleibt auch nach dem Neustart der App erhalten.
- Offline-Modus: Die App erkennt jetzt automatisch, wenn keine Internetverbindung besteht und wechselt in den Offline-Modus.
- Update-Manager: Sie können die App jetzt aktualisieren oder andere Versionen direkt aus der Anwendung herunterladen.

**Verbesserungen**
**Backup**

- Backup und Wiederherstellung laufen jetzt vollständig im Hintergrund, ohne die App einzufrieren — auch bei einer hohen Anzahl aktiver Downloads.
- Plattformübergreifende Backups sind jetzt stabiler und zuverlässiger.
**Downloads**

- Download-System mit mehreren gleichzeitigen Verbindungen, dynamischer Geschwindigkeitskontrolle und zuverlässigeren Wiederverbindungen optimiert.
- Deutlich schnellere Download-Geschwindigkeiten — bis zu 50× schneller je nach Verbindung.
- Mehrere gleichzeitige Downloads ohne Einfrieren der Anwendung.

**Benutzeroberfläche**

- Die Akzentfarbe der App ändert sich jetzt automatisch basierend auf dem aktuell abgespielten Titel
(Dieses Verhalten kann in den Einstellungen geändert werden.)
- Feedback-Nachrichten für bessere Klarheit überarbeitet.
**Empfehlungen**

- Verbesserter Empfehlungsalgorithmus, der relevantere Vorschläge liefert.
- Musikevorschläge werden auf dem Startbildschirm basierend auf Ihrem Hörprofil angezeigt.
**Wiedergabelisten und Bibliothek**

- Wiedergabelisten zeigen jetzt die Gesamtwiedergabezeit.
- Ältere Titel ohne gespeicherte Dauer erhalten jetzt automatisch ihre Dauer aktualisiert, wenn sie abgespielt werden.

**Player – Stabilitätskorrekturen**

- Mehrere kritische Probleme wurden behoben:
- Behoben: Nebenläufigkeitsprobleme, die dazu führten, dass die App beim schnellen Wechseln von Titeln einfror.
- Wiederholen-Ein-Modus funktioniert jetzt korrekt.
- Behoben: Ein Problem, das verhinderte, dass die Wiedergabe nach langen Inaktivitätsperioden fortgesetzt wurde.
- Der Player bewegt sich jetzt korrekt zum nächsten Titel am Ende der Wiedergabe auf Geräten, auf denen er zuvor unerwartet stoppte.
- Behoben: Ein Fehler, der Benutzer daran hinderte, die Warteschlange neu anzuordnen.
- Beim Abspielen eines Titels aus einem Album oder einer Wiedergabeliste, die bereits in der Wiedergabe ist, wurde im Shuffle-Modus manchmal ein falscher zufälliger Titel ausgewählt — jetzt behoben.
- Shuffle-Modus konnte die App destabilisieren — dies wurde vollständig behoben.

**Texte**

- Titel ohne synchronisierte Texte zeigen jetzt ein Timing, das mit dem Wiedergabezähler ausgerichtet ist.
- Für einige Titel ohne Zeitstempel wird automatisch eine Text-Synchronisierung generiert.

**Allgemeine Korrekturen**

- Windows: Der Download-Button wechselt jetzt korrekt zu "Abgeschlossen", wenn der Download beendet ist.
- Verschiedene Stabilitäts- und Leistungsverbesserungen in der gesamten Anwendung.

**Benutzeroberfläche und Lokalisierung**

- Unterstützung für 13 neue Sprachen hinzugefügt: Französisch, Deutsch, Italienisch, Japanisch, Chinesisch, Koreanisch, Hindi, Indonesisch, Türkisch, Arabisch, Polnisch und Thailändisch.

## 4.0.4

**Korrekturen**

- Behoben: Benutzer konnten keine Musik-Streams laden.
- Behoben: Musily konnte unter Linux nicht geöffnet werden.

## 4.0.3

**Korrekturen**

- Behoben: Benutzer konnten keine Musik-Streams laden.

## 4.0.2

**Korrekturen**

- Behoben: Fenstertitel aktualisierte sich nicht, wenn sich die Musik änderte.
- Regionale Probleme durch Hinzufügen von `CurlService` behoben

**Funktionen**

- Neu: Scrollt automatisch zum Anfang der Warteschlange, wenn sich die Musik ändert.

## 4.0.1

**Korrekturen**

- Behoben: Die Intelligente Warteschlange konnte nicht deaktiviert werden, wenn sie leer war.
- Behoben: Die Intelligente Warteschlange funktionierte nicht, wenn nur ein Element in der Warteschlange vorhanden war.

**Verbesserungen**

- Audio-Wiedergabesystem vollständig neu geschrieben für bessere Leistung und Stabilität.

**Desktop**

- Verbesserte Auflösung des Windows-Symbols.
- Minimale Fenstergröße hinzugefügt, um die Fensterverwaltung zu verbessern.

## 4.0.0

**Funktionen**

- Unterstützung für synchronisierte Texte eingeführt, wodurch Texte mit der Wiedergabe synchronisiert werden können.
- Akzentfarbe-Erkennung implementiert: Systemakzent auf dem Desktop und Akzent des Hintergrundbildes auf Android.
- Desktop-Unterstützung hinzugefügt, ermöglicht Downloads und Nutzung unter Linux und Windows.
- Native Android 12+ Startbildschirm-API implementiert für eine schnellere und flüssigere App-Start-Erfahrung.
- Warteschlangenverwaltung verbessert mit intuitiver Sortierung von Liedern: nächste Lieder erscheinen zuerst, gefolgt von vorherigen Titeln.
- Sanfte Übergangsanimationen für Titel im aktuellen Wiedergabebereich hinzugefügt.
- *In-App-Updater* hinzugefügt, ermöglicht Benutzern, die App direkt zu aktualisieren, ohne sie zu verlassen (nur Android und Desktop).

**Korrekturen**

- Behoben: App schloss sich nach dem Import einer Playlist von YouTube.
- Behoben: App blockierte nach der Wiederherstellung eines Bibliotheks-Backups.

## 3.1.1

**Verbesserungen**

- Magische Warteschlange: Behoben und vollständig neu gestaltet für ein flüssigeres und intelligenteres Erlebnis.

## 3.1.0

**Funktionen**

- Möglichkeit hinzugefügt, Playlists von YouTube in Ihre Bibliothek zu importieren.

**Verbesserungen**

- Bibliotheks-Backup verbessert.
- Weitere UI-Verbesserungen.

**Korrekturen**

- Inkonsistenzen in der Bibliothek behoben.
- Behoben: Alben wurden nicht über das Menü zu Playlists oder zur Warteschlange hinzugefügt.

## 3.0.0

**Funktionen**

- Bibliotheks-Backup: Funktionalität für nahtlose Backup-Operationen eingeführt.
- Musik in Downloads speichern: Möglichkeit hinzugefügt, Musik direkt im Download-Ordner zu speichern.

**Verbesserungen**

- Verbesserte Benutzeroberfläche: UI verbessert für ein intuitiveres und visuell ansprechenderes Erlebnis.
- Schnellere Downloads: Download-Geschwindigkeiten optimiert für schnellere und effizientere Dateiübertragungen.

**Korrekturen**

- Navigationsleisten-Probleme: Fehler behoben, die Telefone mit Navigationsleisten anstatt gestenbasierter Navigation betrafen.

## 2.1.2

**Schnelle Korrekturen**

- Behoben: Musik lud unendlich (wieder).

## 2.1.1

**Schnelle Korrekturen**

- Behoben: Musik lud unendlich.
- Behoben: Miniplayer überlagerte das letzte Bibliothekselement.

**Kleine Verbesserungen**

- Nachricht über leere Bibliothek wird jetzt korrekt angezeigt.

## 2.1.0

**Korrekturen**

- Behoben: Bestimmte Suchbegriffe führten zu leeren Suchergebnissen.
- Behoben: Einige Künstler konnten nicht gefunden werden.
- Behoben: Einige Alben wurden nicht gefunden.
- Behoben: Heruntergeladene Playlists wurden gelöscht, wenn die Download-Taste gedrückt wurde.

**Lokalisierung**

- Unterstützung für die ukrainische Sprache hinzugefügt.

**Verbesserungen**

- Funktion der Magischen Warteschlange verbessert, um verwandte Titel besser zu entdecken.

**Funktionen**

- Neuer Einstellungsbildschirm eingeführt, um Spracheinstellungen zu verwalten und zwischen dunklen und hellen Themen zu wechseln.

**Kleine Verbesserungen**

- Verschiedene kleine Verbesserungen und Verfeinerungen.

## 2.0.0

**Funktionen**

- Download-Manager: Neuer Download-Manager für bessere Kontrolle und Nachverfolgung von Dateien eingeführt.
- Bibliotheksfilter: Wenden Sie Filter auf Ihre Bibliothek an, um die Organisation zu erleichtern.
- Suche in Playlists und Alben: Möglichkeit hinzugefügt, in Playlists und Alben zu suchen, für präzisere Navigation.

**Lokalisierung**

- Verbesserte Sprachunterstützung: Neue Übersetzungseinträge für verbesserte Lokalisierung hinzugefügt.
- Spanische Unterstützung hinzugefügt: Vollständige Unterstützung für die spanische Sprache wurde hinzugefügt.

**Verbesserungen**

- Offline-Modus-Optimierung: Leistung im Offline-Modus verbessert, bietet ein flüssigeres und effizienteres Erlebnis.
- Schnelleres Laden der Bibliothek: Bibliothek lädt jetzt schneller, verkürzt Wartezeiten beim Durchsuchen Ihrer Musik und Inhalte.
- Erhöhte Player-Stabilität: Stabilität des Players verbessert.

**Unveränderte Änderung**

- Inkompatibilität des Download-Managers: Der neue Download-Manager ist nicht mit der vorherigen Version kompatibel. Infolgedessen muss alle heruntergeladene Musik erneut heruntergeladen werden.

## 1.2.0

- **Funktion**: Option zum Deaktivieren der Text-Synchronisation
- **Funktion**: Magische Warteschlange - Entdecken Sie neue Musik mit automatischen Empfehlungen, die zu Ihrer aktuellen Playlist hinzugefügt werden.
- **Lokalisierung**: Unterstützung für die russische Sprache hinzugefügt
- **Leistung**: Optimierungen im Bibliotheksbereich

## 1.1.0

### Neue Funktionen

- **Neue Funktion**: Texte
- **Mehrsprachiger Support**: Englisch und Portugiesisch

### Korrekturen

- **Behoben**: Unendliches Laden beim Hinzufügen des ersten Lieblingsliedes

### Verbesserungen

- **Leistungsverbesserungen**: Optimierungen in Listen
- **Neue Ladeanimationen**
- **Verbesserungen bei Favoriten**
- **Player-Verbesserungen**

## 1.0.1

- Behoben: Grauer Startbildschirm
- Behoben: Audio-Dateiverzeichnis erhalten
- Behoben: Navigationsleisten-Farben im hellen Modus
- Behoben: Abstürze, wenn der Benutzer versucht, ein Lied abzuspielen

## 1.0.0

- Erste Version.

