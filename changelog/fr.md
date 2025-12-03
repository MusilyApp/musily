## 5.0.2

**Corrections**
- Résolu un problème critique en mode aléatoire où la piste actuelle pouvait afficher une durée de 0, empêchant la lecture de passer automatiquement à la piste suivante.

**Fonctionnalités**
- Ajout du support du glisser-déposer sur bureau pour les fichiers de sauvegarde et les dossiers, facilitant la restauration de votre bibliothèque ou l'ajout de dossiers locaux directement depuis votre gestionnaire de fichiers.

## 5.0.1

**Corrections**

- Corrigé un problème où renommer les listes de lecture ne fonctionnait pas.
- Corrigé un problème qui empêchait d'ajouter des pistes aux listes de lecture sur Android.
- Corrigé les erreurs qui se produisaient au démarrage de l'application sans connexion Internet.
- Restauré l'initialisation appropriée de YouTube Music après la reconnexion à Internet — auparavant, l'application nécessitait un redémarrage avec une connexion active pour retrouver l'accès.

**Améliorations**

- Ajout d'icônes de contrôle de fenêtre (réduire, agrandir, fermer) pour Windows et Linux, maintenant affichées correctement lors du survol des boutons.
- Amélioration de la surveillance de la connexion pour une transition plus fiable entre les modes en ligne et hors ligne.
- Amélioration de l'extraction audio : l'application récupère maintenant la plus haute qualité audio disponible sur YouTube.

## 5.0.0

**Nouvelles Fonctionnalités**

- Interface raffinée et plus cohérente, avec des améliorations générales de l'organisation visuelle et de la navigation.
- Amélioration de l'UI/UX sur le bureau : meilleur comportement avec les fenêtres, la souris et l'utilisation globale du PC.
- Ajout du Timer de Sommeil.
- Bibliothèque Locale : vous pouvez maintenant ajouter des dossiers de votre appareil à votre bibliothèque.
Note : La bibliothèque locale et la bibliothèque Musily sont gérées séparément pour assurer l'intégrité des données.
- File d'attente persistante : votre file de lecture est conservée même après le redémarrage de l'application.
- Mode hors ligne : l'application détecte maintenant automatiquement lorsqu'il n'y a pas de connexion Internet et passe en mode hors ligne.
- Gestionnaire de Mises à Jour : vous pouvez maintenant mettre à jour l'application ou télécharger d'autres versions directement depuis l'application.

**Améliorations**
**Sauvegarde**

- La sauvegarde et la restauration s'exécutent maintenant entièrement en arrière-plan sans figer l'application — même avec un grand nombre de téléchargements actifs.
- Les sauvegardes multiplateformes sont maintenant plus stables et fiables.
**Téléchargements**

- Système de téléchargement optimisé avec plusieurs connexions simultanées, contrôle de vitesse dynamique et reconnexions plus fiables.
- Vitesses de téléchargement considérablement plus rapides — jusqu'à 50× plus rapides selon la connexion.
- Plusieurs téléchargements simultanés sans figer l'application.

**Interface**

- La couleur d'accent de l'application change maintenant automatiquement en fonction de la piste actuellement en lecture
(Ce comportement peut être modifié dans les paramètres.)
- Messages de retour révisés pour plus de clarté.
**Recommandations**

- Algorithme de recommandation amélioré, fournissant des suggestions plus pertinentes.
- Suggestions musicales affichées sur l'écran d'accueil basées sur votre profil d'écoute.
**Listes de Lecture et Bibliothèque**

- Les listes de lecture affichent maintenant le temps de lecture total.
- Les pistes plus anciennes sans durée stockée voient maintenant leur durée mise à jour automatiquement lors de la lecture.

**Lecteur – Corrections de Stabilité**

- Plusieurs problèmes critiques ont été résolus :
- Corrigé les problèmes de concurrence qui provoquaient le gel de l'application lors du changement rapide de pistes.
- Le mode répéter-une fonctionne maintenant correctement.
- Corrigé un problème qui empêchait la lecture de reprendre après de longues périodes d'inactivité.
- Le lecteur se déplace maintenant correctement vers la piste suivante à la fin de la lecture sur les appareils où il s'arrêtait auparavant de manière inattendue.
- Corrigé un bug qui empêchait les utilisateurs de réorganiser la file d'attente.
- Lors de la lecture d'une piste d'un album ou d'une liste de lecture déjà en lecture, en mode aléatoire, une piste aléatoire incorrecte était parfois sélectionnée — maintenant corrigé.
- Le mode aléatoire pourrait déstabiliser l'application — cela a été complètement résolu.

**Paroles**

- Les pistes sans paroles synchronisées affichent maintenant un timing aligné avec le minuteur de lecture.
- Pour certaines pistes sans horodatages, une synchronisation automatique des paroles est générée.

**Corrections Générales**

- Windows : le bouton de téléchargement passe maintenant correctement à "Terminé" lorsque le téléchargement se termine.
- Diverses améliorations de stabilité et de performances dans toute l'application.

**Interface et Localisation**

- Ajout du support pour 13 nouvelles langues : Français, Allemand, Italien, Japonais, Chinois, Coréen, Hindi, Indonésien, Turc, Arabe, Polonais et Thaï.

## 4.0.4

**Corrections**

- Corrigé un problème où les utilisateurs ne pouvaient pas charger des flux musicaux.
- Résolu un problème qui empêchait Musily de s'ouvrir sur Linux.

## 4.0.3

**Corrections**

- Corrigé un problème où les utilisateurs ne pouvaient pas charger des flux musicaux.

## 4.0.2

**Corrections**

- Corrigé un problème où le titre de la fenêtre ne se mettait pas à jour lorsque la musique changeait.
- Résolus des problèmes régionaux en ajoutant `CurlService`

**Fonctionnalités**

- Nouveau : Défile automatiquement vers le début de la file d'attente lorsque la musique change.

## 4.0.1

**Corrections**

- Résolu un problème où la File Intelligente ne pouvait pas être désactivée lorsqu'elle était vide.
- Corrigé un problème où la File Intelligente ne fonctionnait pas lorsqu'un seul élément est présent dans la file.

**Améliorations**

- Système de lecture audio complètement réécrit pour de meilleures performances et stabilité.

**Bureau**

- Améliorée la résolution de l'icône Windows.
- Ajouté une taille de fenêtre minimale pour améliorer la gestion des fenêtres.

## 4.0.0

**Fonctionnalités**

- Introduit le support des paroles synchronisées, permettant aux paroles de se synchroniser avec la lecture.
- Implémentée la détection de couleur d'accent : accent système sur le bureau et accent du fond d'écran sur Android.
- Ajouté le support bureau, permettant les téléchargements et l'utilisation sur Linux et Windows.
- Implémentée l'API native d'écran de démarrage Android 12+ pour une expérience de lancement plus rapide et fluide.
- Améliorée la gestion de la file d'attente avec un tri intuitif des chansons : les prochaines chansons apparaissent en premier suivies des pistes précédentes.
- Ajoutées des animations fluides de transition de pistes dans la section de lecture actuelle.
- Ajouté *mise à jour dans l'application*, permettant aux utilisateurs de mettre à jour l'application directement sans la quitter (Android et Bureau uniquement).

**Corrections**

- Corrigé un problème où l'application se fermait après avoir importé une playlist depuis YouTube.
- Résolu un problème où l'application se bloquait après avoir restauré une sauvegarde de la bibliothèque.

## 3.1.1

**Améliorations**

- File Magique : Corrigée et complètement repensée pour une expérience plus fluide et intelligente.

## 3.1.0

**Fonctionnalités**

- Ajoutée la capacité d'importer des playlists depuis YouTube vers votre bibliothèque.

**Améliorations**

- Amélioré la sauvegarde de la bibliothèque.
- Autres améliorations de l'interface.

**Corrections**

- Corrigées des incohérences dans la bibliothèque.
- Résolu un problème où les albums n'étaient pas ajoutés aux playlists ou à la file depuis le menu.

## 3.0.0

**Fonctionnalités**

- Sauvegarde de la Bibliothèque : Introduite la fonctionnalité pour des opérations de sauvegarde parfaites.
- Enregistrer la Musique dans les Téléchargements : Ajoutée la capacité d'enregistrer la musique directement dans le dossier de téléchargements.

**Améliorations**

- Interface Améliorée : Améliorée l'interface utilisateur pour une expérience plus intuitive et visuellement attrayante.
- Téléchargements Plus Rapides : Optimisées les vitesses de téléchargement pour des transferts de fichiers plus rapides et efficaces.

**Corrections**

- Problèmes de la Barre de Navigation : Résolus des bugs qui affectaient les téléphones avec barres de navigation au lieu de navigation basée sur les gestes.

## 2.1.2

**Corrections Rapides**

- Corrigé un problème où la musique se chargeait infiniment (encore).

## 2.1.1

**Corrections Rapides**

- Corrigé un problème où la musique se chargeait infiniment.
- Corrigé un bug où le mini lecteur chevauchait le dernier élément de la bibliothèque.

**Améliorations Mineures**

- Le message de bibliothèque vide est maintenant affiché correctement.

## 2.1.0

**Corrections**

- Résolu un problème où certains termes de recherche donnaient des résultats de recherche vides.
- Résolu un problème où certains artistes ne pouvaient pas être trouvés.
- Corrigé un problème où certains albums n'étaient pas trouvés.
- Résolu un bug où les playlists téléchargées étaient supprimées lorsque le bouton de téléchargement était pressé.

**Localisation**

- Ajouté le support de la langue ukrainienne.

**Améliorations**

- Améliorée la fonctionnalité File Magique pour mieux découvrir des pistes liées.

**Fonctionnalités**

- Introduit un nouvel écran de paramètres pour gérer les préférences de langue et basculer entre les thèmes sombre et clair.

**Améliorations Mineures**

- Diverses améliorations et raffinements mineurs.

## 2.0.0

**Fonctionnalités**

- Gestionnaire de Téléchargements : Introduit un nouveau gestionnaire de téléchargements pour un meilleur contrôle et suivi des fichiers.
- Filtres de Bibliothèque : Appliquez des filtres à votre bibliothèque pour une organisation plus facile.
- Recherche dans les Playlists et Albums : Ajoutée la capacité de rechercher dans les playlists et albums pour une navigation plus précise.

**Localisation**

- Support de Langues Amélioré : Ajoutées de nouvelles entrées de traduction pour une localisation améliorée.
- Ajouté le Support Espagnol : Le support complet de la langue espagnole a été ajouté.

**Améliorations**

- Optimisation du Mode Hors Ligne : Améliorée les performances en mode hors ligne, offrant une expérience plus fluide et efficace.
- Chargement Plus Rapide de la Bibliothèque : La bibliothèque se charge maintenant plus rapidement, réduisant les temps d'attente lors de la navigation dans votre musique et contenu.
- Stabilité Augmentée du Lecteur : Améliorée la stabilité du lecteur.

**Changement Incompatible**

- Incompatibilité du Gestionnaire de Téléchargements : Le nouveau gestionnaire de téléchargements n'est pas compatible avec la version précédente. En conséquence, toute la musique téléchargée devra être téléchargée à nouveau.

## 1.2.0

- **Fonctionnalité** : Option pour désactiver la synchronisation des paroles
- **Fonctionnalité** : File Magique - Découvrez de la nouvelle musique avec des recommandations automatiques ajoutées à votre playlist actuelle.
- **Localisation** : Ajouté le support de la langue russe
- **Performances** : Optimisations dans la section Bibliothèque

## 1.1.0

### Nouvelles Fonctionnalités

- **Nouvelle Fonctionnalité** : Paroles
- **Support Multi-langues** : Anglais et Portugais

### Corrections

- **Corrigé** : Chargement infini lors de l'ajout de la première chanson favorite

### Améliorations

- **Améliorations de Performances** : Optimisations dans les Listes
- **Nouvelles Animations de Chargement**
- **Améliorations dans les Favoris**
- **Améliorations du Lecteur**

## 1.0.1

- Corrigé : Écran d'accueil gris
- Corrigé : Obtenir le répertoire du fichier audio
- Corrigé : Couleurs de la barre de navigation en mode clair
- Corrigé : Plantages lorsque l'utilisateur essaie de lire une chanson

## 1.0.0

- Version initiale.

