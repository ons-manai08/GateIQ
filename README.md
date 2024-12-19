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

### 📱 **Application mobile** :  
1. Installez l'application mobile sur votre téléphone.  
2. Connectez l'application au réseau Wi-Fi de votre Raspberry Pi.  

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

