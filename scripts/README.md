# Firebase Data Import Scripts

Bu klasör Firebase Firestore'a mock data import etmek için scriptleri içerir.

## Kurulum

1. Node.js ve npm'in yüklü olduğundan emin olun:
   ```bash
   node --version
   npm --version
   ```

2. Firebase Admin SDK'yı yükleyin:
   ```bash
   npm install firebase-admin
   ```

3. Firebase Console'dan service account key dosyasını indirin:
   - Firebase Console > Project Settings > Service Accounts
   - "Generate New Private Key" butonuna tıklayın
   - İndirilen JSON dosyasını güvenli bir yere kaydedin

## Kullanım

### Yöntem 1: Service Account Key Dosyası ile

1. `import_firebase_data.js` dosyasını düzenleyin ve service account key path'ini ekleyin:
   ```javascript
   const serviceAccount = require('./path/to/serviceAccountKey.json');
   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });
   ```

2. Script'i çalıştırın:
   ```bash
   node scripts/import_firebase_data.js
   ```

### Yöntem 2: Environment Variable ile

1. Environment variable'ı set edin:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="./path/to/serviceAccountKey.json"
   ```

2. Script'teki ilgili satırı uncomment edin:
   ```javascript
   admin.initializeApp();
   ```

3. Script'i çalıştırın:
   ```bash
   node scripts/import_firebase_data.js
   ```

### Yöntem 3: Firebase Project ID ile (Emulator veya Default Credentials)

1. Script'te project ID'nizi güncelleyin:
   ```javascript
   admin.initializeApp({
     projectId: 'your-project-id'
   });
   ```

2. Script'i çalıştırın:
   ```bash
   node scripts/import_firebase_data.js
   ```

## Import Edilecek Veriler

- **users**: 6 kullanıcı
- **pets**: 8 evcil hayvan
- **feedingPoints**: 5 beslenme noktası
- **vaccinations**: 10 aşı kaydı
- **conversations**: 3 sohbet
- **messages**: Sohbet mesajları (subcollection)
- **likes**: 3 beğeni

## Notlar

- Script, tarihleri otomatik olarak Firestore Timestamp formatına çevirir
- Batch işlemler kullanarak performansı optimize eder
- Her 500 doküman sonrası commit yapar
- Hata durumunda detaylı error mesajı gösterir

## Güvenlik

⚠️ **ÖNEMLİ**: Service account key dosyasını asla git'e commit etmeyin! `.gitignore` dosyanıza ekleyin:

```
serviceAccountKey.json
*.json
!package.json
!package-lock.json
!firebase_mock_data.json
```

