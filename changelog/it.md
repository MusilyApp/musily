## 5.0.0

**Nuove Funzionalità**

- Interfaccia raffinata e più coerente, con miglioramenti generali all'organizzazione visiva e alla navigazione.
- UI/UX migliorata su desktop: migliore comportamento con finestre, mouse e utilizzo generale del PC.
- Aggiunto Timer del Sonno.
- Libreria Locale: puoi ora aggiungere cartelle dal tuo dispositivo alla tua libreria.
Nota: La libreria locale e la libreria Musily sono gestite separatamente per garantire l'integrità dei dati.
- Coda persistente: la tua coda di riproduzione è preservata anche dopo il riavvio dell'app.
- Modalità offline: l'app ora rileva automaticamente quando non c'è connessione internet e passa alla modalità offline.
- Gestore Aggiornamenti: puoi ora aggiornare l'app o scaricare altre versioni direttamente dall'applicazione.

**Miglioramenti**
**Backup**

- Backup e ripristino ora funzionano completamente in background senza bloccare l'app — anche con un numero elevato di download attivi.
- I backup multipiattaforma sono ora più stabili e affidabili.
**Download**

- Sistema di download ottimizzato con più connessioni simultanee, controllo dinamico della velocità e riconnessioni più affidabili.
- Velocità di download significativamente più veloci — fino a 50× più veloci a seconda della connessione.
- Download simultanei multipli senza bloccare l'applicazione.

**Interfaccia**

- Il colore di accento dell'app ora cambia automaticamente in base alla traccia attualmente in riproduzione
(Questo comportamento può essere modificato nelle impostazioni.)
- Messaggi di feedback rivisti per maggiore chiarezza.
**Raccomandazioni**

- Algoritmo di raccomandazione migliorato, fornendo suggerimenti più pertinenti.
- Suggerimenti musicali mostrati nella schermata principale basati sul tuo profilo di ascolto.
**Playlist e Libreria**

- Le playlist ora mostrano il tempo di riproduzione totale.
- Le tracce più vecchie senza durata memorizzata ora hanno la loro durata aggiornata automaticamente quando riprodotte.

**Player – Correzioni di Stabilità**

- Diversi problemi critici sono stati risolti:
- Risolti problemi di concorrenza che causavano il blocco dell'app durante il cambio rapido di tracce.
- La modalità ripeti-una ora funziona correttamente.
- Risolto un problema che impediva la ripresa della riproduzione dopo lunghi periodi di inattività.
- Il player ora si sposta correttamente alla traccia successiva alla fine della riproduzione sui dispositivi dove si fermava inaspettatamente.
- Risolto un bug che impediva agli utenti di riordinare la coda.
- Quando si riproduce una traccia da un album o una playlist già in riproduzione, in modalità shuffle, veniva talvolta selezionata una traccia casuale errata — ora risolto.
- La modalità shuffle poteva destabilizzare l'app — questo è stato completamente risolto.

**Testi**

- Le tracce senza testi sincronizzati ora mostrano un timing allineato con il timer di riproduzione.
- Per alcune tracce senza timestamp, viene generata la sincronizzazione automatica dei testi.

**Correzioni Generali**

- Windows: il pulsante di download ora passa correttamente a "Completato" quando il download termina.
- Varie migliorie di stabilità e prestazioni in tutta l'applicazione.

**Interfaccia e Localizzazione**

- Aggiunto il supporto per 13 nuove lingue: Francese, Tedesco, Italiano, Giapponese, Cinese, Coreano, Hindi, Indonesiano, Turco, Arabo, Polacco e Thailandese.

## 4.0.4

**Correzioni**

- Risolto un problema dove gli utenti non riuscivano a caricare stream musicali.
- Risolto un problema che impediva a Musily di aprirsi su Linux.

## 4.0.3

**Correzioni**

- Risolto un problema dove gli utenti non riuscivano a caricare stream musicali.

## 4.0.2

**Correzioni**

- Risolto un problema dove il titolo della finestra non si aggiornava quando la musica cambiava.
- Risolti problemi regionali aggiungendo `CurlService`

**Funzionalità**

- Nuovo: Scorre automaticamente all'inizio della coda quando la musica cambia.

## 4.0.1

**Correzioni**

- Risolto un problema dove la Coda Intelligente non poteva essere disabilitata quando vuota.
- Risolto un problema dove la Coda Intelligente non funzionava quando è presente solo un elemento nella coda.

**Miglioramenti**

- Sistema di riproduzione audio completamente riscritto per migliori prestazioni e stabilità.

**Desktop**

- Migliorata la risoluzione dell'icona Windows.
- Aggiunta una dimensione minima della finestra per migliorare la gestione delle finestre.

## 4.0.0

**Funzionalità**

- Introdotto il supporto per testi sincronizzati, permettendo ai testi di sincronizzarsi con la riproduzione.
- Implementata la rilevazione del colore di accento: accento del sistema sul desktop e accento dello sfondo su Android.
- Aggiunto il supporto desktop, permettendo download e utilizzo su Linux e Windows.
- Implementata l'API nativa della schermata di avvio Android 12+ per un'esperienza di avvio dell'app più rapida e fluida.
- Migliorata la gestione della coda con ordinamento intuitivo delle canzoni: le prossime canzoni appaiono per prime seguite dalle tracce precedenti.
- Aggiunte animazioni fluide di transizione delle tracce nella sezione di riproduzione attuale.
- Aggiunto *aggiornamento nell'app*, permettendo agli utenti di aggiornare l'app direttamente senza uscire (solo Android e Desktop).

**Correzioni**

- Risolto un problema dove l'app si chiudeva dopo aver importato una playlist da YouTube.
- Risolto un problema dove l'app si bloccava dopo aver ripristinato un backup della libreria.

## 3.1.1

**Miglioramenti**

- Coda Magica: Risolta e completamente ridisegnata per un'esperienza più fluida e intelligente.

## 3.1.0

**Funzionalità**

- Aggiunta la capacità di importare playlist da YouTube nella tua libreria.

**Miglioramenti**

- Migliorato il backup della libreria.
- Altri miglioramenti all'interfaccia.

**Correzioni**

- Risolte inconsistenze nella libreria.
- Risolto un problema dove gli album non venivano aggiunti alle playlist o alla coda dal menu.

## 3.0.0

**Funzionalità**

- Backup della Libreria: Introdotta funzionalità per operazioni di backup perfette.
- Salva Musica nei Download: Aggiunta la capacità di salvare musica direttamente nella cartella download.

**Miglioramenti**

- Interfaccia Migliorata: Migliorata l'interfaccia utente per un'esperienza più intuitiva e visivamente attraente.
- Download Più Veloci: Ottimizzate le velocità di download per trasferimenti di file più rapidi ed efficienti.

**Correzioni**

- Problemi della Barra di Navigazione: Risolti bug che interessavano telefoni con barre di navigazione invece di navigazione basata sui gesti.

## 2.1.2

**Correzioni Rapide**

- Risolto un problema dove la musica si caricava infinitamente (di nuovo).

## 2.1.1

**Correzioni Rapide**

- Risolto un problema dove la musica si caricava infinitamente.
- Risolto un bug dove il mini player sovrapponeva l'ultimo elemento della libreria.

**Miglioramenti Minori**

- Il messaggio di libreria vuota ora viene visualizzato correttamente.

## 2.1.0

**Correzioni**

- Risolto un problema dove certi termini di ricerca risultavano in risultati di ricerca vuoti.
- Risolto un problema dove alcuni artisti non potevano essere trovati.
- Risolto un problema dove alcuni album non venivano trovati.
- Risolto un bug dove le playlist scaricate venivano eliminate quando il pulsante di download veniva premuto.

**Localizzazione**

- Aggiunto il supporto per la lingua ucraina.

**Miglioramenti**

- Migliorata la funzionalità Coda Magica per scoprire meglio tracce correlate.

**Funzionalità**

- Introdotta una nuova schermata delle impostazioni per gestire le preferenze della lingua e alternare tra temi scuri e chiari.

**Miglioramenti Minori**

- Varie migliorie e raffinamenti minori.

## 2.0.0

**Funzionalità**

- Gestore Download: Introdotto un nuovo gestore di download per un migliore controllo e tracciamento dei file.
- Filtri della Libreria: Applica filtri alla tua libreria per un'organizzazione più facile.
- Ricerca in Playlist e Album: Aggiunta la capacità di cercare all'interno di playlist e album per una navigazione più precisa.

**Localizzazione**

- Supporto Lingue Migliorato: Aggiunte nuove voci di traduzione per una localizzazione migliorata.
- Aggiunto Supporto Spagnolo: È stato aggiunto il supporto completo per la lingua spagnola.

**Miglioramenti**

- Ottimizzazione Modalità Offline: Migliorate le prestazioni in modalità offline, fornendo un'esperienza più fluida ed efficiente.
- Caricamento Più Veloce della Libreria: La libreria ora si carica più velocemente, riducendo i tempi di attesa durante la navigazione nella tua musica e contenuti.
- Stabilità Aumentata del Player: Migliorata la stabilità del player.

**Cambiamento Incompatibile**

- Incompatibilità del Gestore Download: Il nuovo gestore di download non è compatibile con la versione precedente. Di conseguenza, tutta la musica scaricata dovrà essere scaricata di nuovo.

## 1.2.0

- **Funzionalità**: Opzione per disabilitare la sincronizzazione dei testi
- **Funzionalità**: Coda Magica - Scopri nuova musica con raccomandazioni automatiche aggiunte alla tua playlist attuale.
- **Localizzazione**: Aggiunto supporto per la lingua russa
- **Prestazioni**: Ottimizzazioni nella sezione Libreria

## 1.1.0

### Nuove Funzionalità

- **Nuova Funzionalità**: Testi
- **Supporto Multi-lingua**: Inglese e Portoghese

### Correzioni

- **Risolto**: Caricamento infinito aggiungendo la prima canzone preferita

### Miglioramenti

- **Miglioramenti delle Prestazioni**: Ottimizzazioni nelle Liste
- **Nuove Animazioni di Caricamento**
- **Miglioramenti nei Preferiti**
- **Miglioramenti al Player**

## 1.0.1

- Risolto: Schermata iniziale grigia
- Risolto: Ottenere la directory del file audio
- Risolto: Colori della barra di navigazione in modalità chiara
- Risolto: Crash quando l'utente tenta di riprodurre una canzone

## 1.0.0

- Versione iniziale.

