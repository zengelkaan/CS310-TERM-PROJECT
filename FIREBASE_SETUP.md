# Firebase Database Kurulum Rehberi

Bu dosya, PetConnect uygulaması için Firebase Firestore veritabanı yapısını ve mock data'yı import etme adımlarını içerir.

## 📋 İçindekiler

1. [Database Yapısı](#database-yapısı)
2. [Mock Data](#mock-data)
3. [Import İşlemi](#import-işlemi)
4. [Sonraki Adımlar](#sonraki-adımlar)

---

## 📊 Database Yapısı

Detaylı database yapısı için `firebase_database_structure.md` dosyasına bakın.

### Koleksiyonlar

1. **users** - Kullanıcı bilgileri
2. **pets** - Evcil hayvan bilgileri (Adoption/Dating için)
3. **feedingPoints** - Beslenme noktaları
4. **vaccinations** - Aşı hatırlatıcıları
5. **conversations** - Sohbet konuşmaları
6. **messages** - Mesajlar (conversations alt koleksiyonu)
7. **likes** - Pet beğenileri (dating feature için)

---

## 📦 Mock Data

Mock data `firebase_mock_data.json` dosyasında bulunmaktadır.

### İçerik Özeti

- **6 Kullanıcı**: Mehmet Salcan, Emir Özyeşil, İrem Ulusal, Hilal Öngel, Kaan Zengil, Emily Clark
- **8 Pet**: Bal, Şimanski, Limon, Max, Luna, Coco, Bella, Charlie
- **5 Feeding Point**: Dormitory, Faculty of Engineering, Library Entrance, Student Center, Campus Gate
- **10 Vaccination**: Çeşitli pet'ler için aşı kayıtları
- **3 Conversation**: Kullanıcılar arası sohbetler
- **Mesajlar**: Sohbet mesajları
- **3 Like**: Pet beğenileri

---

## 🔧 Import İşlemi

### Yöntem 1: Node.js Script ile (Önerilen)

1. **Firebase Admin SDK'yı yükleyin:**
   ```bash
   npm install firebase-admin
   ```

2. **Firebase Console'dan Service Account Key indirin:**
   - Firebase Console > Project Settings > Service Accounts
   - "Generate New Private Key" butonuna tıklayın
   - JSON dosyasını güvenli bir yere kaydedin

3. **Script'i yapılandırın:**
   
   `scripts/import_firebase_data.js` dosyasını açın ve aşağıdakilerden birini yapın:

   **Seçenek A:** Service account key path'i ekleyin:
   ```javascript
   const serviceAccount = require('./path/to/serviceAccountKey.json');
   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });
   ```

   **Seçenek B:** Environment variable kullanın:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="./path/to/serviceAccountKey.json"
   ```
   Ve script'te:
   ```javascript
   admin.initializeApp();
   ```

4. **Script'i çalıştırın:**
   ```bash
   node scripts/import_firebase_data.js
   ```

### Yöntem 2: Firebase Console ile Manuel Import

1. Firebase Console > Firestore Database'e gidin
2. Her koleksiyon için manuel olarak dokümanları ekleyin
3. `firebase_mock_data.json` dosyasındaki verileri referans alın

### Yöntem 3: Firebase CLI ile

```bash
# Firebase CLI'yi yükleyin
npm install -g firebase-tools

# Firebase'e login olun
firebase login

# Firestore import komutunu kullanın (format uyumlu olmalı)
firebase firestore:import firebase_mock_data.json
```

**Not:** Firebase CLI import için özel bir format gerektirir. Node.js script kullanmanız önerilir.

---

## 🔐 Security Rules

Firebase Console > Firestore Database > Rules sekmesine gidin ve `firebase_database_structure.md` dosyasındaki security rules'u ekleyin.

Temel güvenlik kuralları:
- Users: Sadece kendi verilerini okuyup yazabilir
- Pets: Herkes okuyabilir, sadece owner yazabilir
- Feeding Points: Herkes okuyabilir, authenticated users yazabilir
- Vaccinations: Sadece owner erişebilir
- Conversations: Sadece participants erişebilir

---

## 📝 Indexes (Önemli!)

Firebase Console > Firestore Database > Indexes sekmesine gidin ve aşağıdaki composite indexleri oluşturun:

1. **conversations** collection:
   - Fields: `participants` (Array), `updatedAt` (Descending)
   - Query scope: Collection

2. **pets** collection:
   - Fields: `kind` (Ascending), `available` (Ascending)
   - Fields: `purpose` (Ascending), `available` (Ascending)

3. **vaccinations** collection:
   - Fields: `ownerId` (Ascending), `completed` (Ascending), `date` (Ascending)

4. **feedingPoints** collection:
   - Fields: `verified` (Ascending), `active` (Ascending)

**Not:** Uygulamayı çalıştırdığınızda Firebase Console'da eksik index uyarıları görürseniz, bunları tıklayarak otomatik oluşturabilirsiniz.

---

## 🌍 Geo Queries için GeoFirestore (Opsiyonel)

Beslenme noktaları için location-based queries için GeoFirestore kütüphanesini kullanabilirsiniz:

```bash
npm install geofirestore
```

Detaylar için: https://github.com/MichaelSolati/geofirestore

---

## ✅ Sonraki Adımlar

1. ✅ Database yapısı oluşturuldu
2. ✅ Mock data hazırlandı
3. ✅ Import script oluşturuldu
4. ⏭️ Firebase projesini oluşturun
5. ⏭️ Mock data'yı import edin
6. ⏭️ Security rules'u ekleyin
7. ⏭️ Indexes'leri oluşturun
8. ⏭️ Flutter app'te Firebase'i yapılandırın
9. ⏭️ Backend servisleri oluşturun

---

## 📚 Kaynak Dosyalar

- `firebase_database_structure.md` - Detaylı database yapısı ve açıklamalar
- `firebase_mock_data.json` - Mock data
- `scripts/import_firebase_data.js` - Import script
- `scripts/README.md` - Script kullanım detayları

---

## ❓ Sorun Giderme

### "Firebase Admin SDK not found" hatası
```bash
npm install firebase-admin
```

### "Permission denied" hatası
Service account key'inizin doğru path'ini kontrol edin ve Firebase'de gerekli izinlerin olduğundan emin olun.

### "Index missing" hatası
Firebase Console'da uyarıyı tıklayarak index'i otomatik oluşturun.

### Tarih formatı sorunları
Script otomatik olarak ISO 8601 formatındaki tarihleri Firestore Timestamp'e çevirir.

---

## 🔗 Faydalı Linkler

- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

