# GateIQ - 🚪🔒 Système de Reconnaissance Faciale et Contrôle d'Accès

Bienvenue dans **GateIQ**, une solution innovante pour le contrôle d'accès sécurisé via la reconnaissance faciale, la gestion RFID, et une application mobile interactive. 🚀  

---

## 📦 **Technologies utilisées**

### Matériel :  
- 🖥️ **Raspberry Pi 3**  
- 🛠️ **Module RC522 (RFID)**  
- 📸 **Caméra compatible avec Raspberry Pi**  

### Logiciel :  
- 🧠 **OpenCV** pour le traitement d'images.  
- 📱 **Application mobile** développée en Flutter.  
- 🐍 **Scripts Python** pour la gestion des périphériques (RC522, caméra).  

---

## ⚙️ **Installation et Configuration**

### 🔌 **Matériel** :  
1. 🛠️ Connectez le module **RC522** au **Raspberry Pi 3** selon le schéma de câblage.  
2. 📸 Installez la caméra et configurez-la pour fonctionner avec le **Raspberry Pi**.  

### 🖥️ **Logiciel** :  
1. Installez les dépendances nécessaires :  
    ```bash  
    sudo apt-get update  
    sudo apt-get install python3-opencv python3-pip  
    pip3 install spidev RPi.GPIO  
    ```  
2. Clonez ce dépôt GitHub :  
    ```bash  
    git clone https://github.com/votre-nom-utilisateur/gateiq.git  
    ```  
3. Lancez les scripts pour tester les fonctionnalités :  
    ```bash  
    python3 main.py  
    ```  

---

## 📱 **Application Mobile - Flutter avec Firebase**

L'application mobile Flutter est un composant essentiel de GateIQ, offrant une interface intuitive et connectée pour interagir avec le système. Elle intègre **Firebase** pour des fonctionnalités avancées telles que l'authentification, le stockage cloud, et les notifications en temps réel.  

---

### ✨ **Fonctionnalités principales**  
- 🔑 **Connexion sécurisée avec Firebase Auth** : Authentifiez-vous à l'aide d'un email et d'un mot de passe ou via Google/Apple.  
- 🚪 **Contrôle d'accès** : Ouvrez ou fermez la porte via des commandes envoyées au Raspberry Pi.  
- 🧑‍🎤 **Reconnaissance faciale** : Prenez une photo et synchronisez-la avec le système backend pour vérification.  
- 📊 **Historique des accès** : Les journaux sont stockés et consultables grâce à Firebase Firestore.  
- ✉️ **Notifications Push** : Recevez des alertes en temps réel via Firebase Cloud Messaging (FCM).  
- 🛠️ **Mode administrateur** : Déverrouillez la porte à l'aide d'une carte RFID en cas de panne du système de reconnaissance faciale.  

---

### 🛠️ **Installation et Configuration Application Mobile **  

#### **Prérequis :**  
1. Un compte Firebase (https://firebase.google.com).  
2. Un projet Firebase configuré pour Android et/ou iOS.  

#### **Étapes d'installation :**  

1. **Configurer Firebase :**  
   - Créez un projet Firebase.  
   - Ajoutez les configurations Android/iOS (fichiers `google-services.json` pour Android et `GoogleService-Info.plist` pour iOS).  
   - Activez les services Firebase nécessaires :  
     - **Authentication** (Email/Google).  
     - **Firestore Database** pour les journaux d'accès.  

2. **Installer l'application Flutter :**  
   - Clonez le dépôt :  
     ```bash  
     git clone https://github.com/ons-manai08/GateIQ.git
     cd GateIQ-mobile  
     ```  
   - Installez les dépendances Flutter :  
     ```bash  
     flutter pub get  
     ```  
   - Ajoutez les fichiers de configuration Firebase (`google-services.json` ou `GoogleService-Info.plist`).  

3. **Lancer l'application :**  
   - Exécutez l'application sur un simulateur ou un appareil réel :  
     ```bash  
     flutter run  
     ```  

---

### 🖼️ **Interface Utilisateur**  

#### **Pages principales :**  
1. **Connexion/Inscription :**  
   - Authentification avec Firebase Auth (email/mot de passe, Google).  

2. **Tableau de bord :**  
   - Boutons pour :  
     - 🚪 Ouvrir/Fermer la porte.  
     - 📊 Consulter les journaux d'accès.  
     - 📸 Lancer la reconnaissance faciale.  

3. **Notifications :**  
   - Réception d'alertes en temps via Email.  

4. **Profil utilisateur :**  
   - Gérer les paramètres personnels et déconnexion.  

---

### 🔧 **Technologies utilisées dans l'application mobile**  
- 🎨 **Flutter** : Framework pour le développement multiplateforme.  
- 🔗 **Firebase** :  
  - **Firebase Auth** : Authentification utilisateur.  
  - **Firestore** : Base de données pour stocker les journaux d'accès.  
  - **Firebase Storage** : Sauvegarde des images pour la reconnaissance faciale.  
- 📷 **Camera Plugin** : Capture d'images pour la reconnaissance faciale.  
- 📡 **HTTP** : Communication avec le backend sur Raspberry Pi.  

---




## 🚀 **Utilisation**

1. 📱 **Ouvrez l'application mobile** et connectez-vous au système.  
2. 🖱️ Utilisez les boutons pour **ouvrir ou fermer la porte**.  
3. 🧑‍🎤 **Authentifiez-vous via reconnaissance faciale** pour un accès sécurisé.  
4. 🔑 En cas de panne du système de reconnaissance faciale, les administrateurs peuvent utiliser une **carte RFID** pour déverrouiller la porte.  
5. 📹 **Surveillez l'accès en temps réel** via la caméra.  
6. 🗂️ Consultez les **journaux d'historique** pour suivre les activités.  
7. ✉️ Recevez des **alertes par email** en cas de tentative d'accès forcé non autorisé.  

---

