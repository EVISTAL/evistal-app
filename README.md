# 🏠 EVISTAL - Akıllı Ev Uygulaması

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

**EVISTAL**, Bluetooth Low Energy (BLE) teknolojisi kullanarak akıllı ev cihazlarınızı kontrol etmenizi sağlayan modern bir Flutter uygulamasıdır. Özellikle nemlendirici cihazlar için optimize edilmiş kullanıcı dostu bir arayüze sahiptir.

---

## 📱 Proje Hakkında

EVISTAL, "Smart Home Application" konseptiyle geliştirilmiş bir IoT kontrol uygulamasıdır. Uygulama, BLE üzerinden ESP32 tabanlı cihazlarla iletişim kurarak:
- Nemlendirici mod kontrolü (Mod 1, Mod 2, Kapalı)
- LED renk kontrolü (Rainbow, RGB, Beyaz, Kapalı)
- Gerçek zamanlı cihaz bağlantı yönetimi
- Çoklu cihaz desteği

gibi özellikleri sunar.

---

## ✨ Özellikler

### 🔵 BLE (Bluetooth Low Energy) Özellikleri
- ✅ Otomatik "EVISTAL" cihaz tarama ve bağlantı
- ✅ Gerçek zamanlı cihaz tarama modalı
- ✅ Filtrelenmiş cihaz listesi (sadece EVISTAL cihazları)
- ✅ RSSI (sinyal gücü) gösterimi
- ✅ Güvenli bağlantı ve bağlantı kesme işlemleri
- ✅ AT komutları ile cihaz kontrolü
  - `AT+RMOD=<mode>`: Renk modu kontrolü (0-3)
  - `AT+DMOD=<mode>`: Difüzör modu kontrolü (0-2)

### 🎨 Kullanıcı Arayüzü
- ✅ Modern gradient tasarım (lacivert palet)
- ✅ Animasyonlu mod geçişleri
- ✅ ON/OFF toggle butonu ile hızlı bağlantı
- ✅ Responsive tasarım (tüm ekran boyutlarına uyumlu)
- ✅ Kullanıcı dostu dialog bildirimleri (AwesomeDialog)
- ✅ İlk açılış splash screen'i

### 🔧 Teknik Özellikler
- ✅ Provider pattern ile state management
- ✅ SharedPreferences ile yerel veri saklama
- ✅ Android 6+ ve Android 12+ izin sistemi desteği
- ✅ iOS ve Android cross-platform uyumluluğu
- ✅ Modüler ve genişletilebilir kod yapısı

---

## 🛠️ Kullanılan Teknolojiler

### Ana Framework
- **Flutter SDK**: ^3.8.1
- **Dart**: ^3.0+

### Paketler
| Paket | Versiyon | Kullanım Amacı |
|-------|----------|----------------|
| `flutter_blue_plus` | ^1.35.5 | BLE iletişimi ve cihaz yönetimi |
| `provider` | ^6.0.5 | State management |
| `permission_handler` | ^11.3.1 | Sistem izinleri yönetimi |
| `shared_preferences` | ^2.2.2 | Yerel veri saklama |
| `awesome_dialog` | ^3.1.3 | Kullanıcı bildirimleri |
| `flutter_launcher_icons` | ^0.13.1 | Uygulama ikonu oluşturma |
| `flutter_native_splash` | ^2.4.1 | Splash screen oluşturma |

---

## 📋 Gereksinimler

### Minimum Sistem Gereksinimleri
- **Android**: 6.0+ (API Level 23+)
- **iOS**: 12.0+
- **Bluetooth**: BLE 4.0+

### Geliştirme Ortamı
- Flutter SDK 3.8.1 veya üzeri
- Android Studio / Xcode
- Fiziksel cihaz (BLE için)

### İzinler
**Android:**
- `BLUETOOTH_SCAN` (Android 12+)
- `BLUETOOTH_CONNECT` (Android 12+)
- `ACCESS_FINE_LOCATION` (Android 6-11)

**iOS:**
- `NSBluetoothAlwaysUsageDescription`
- `NSBluetoothPeripheralUsageDescription`

---

## 🚀 Kurulum

### 1️⃣ Depoyu Klonlayın
```bash
git clone https://github.com/your-username/evistal_1.git
cd evistal_1
```

### 2️⃣ Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 3️⃣ Uygulama İkonunu Oluşturun
```bash
flutter pub run flutter_launcher_icons
```

### 4️⃣ Splash Screen'i Oluşturun
```bash
flutter pub run flutter_native_splash:create
```

### 5️⃣ Uygulamayı Çalıştırın
```bash
flutter run
```

> **Not:** BLE özellikleri emülatörde çalışmaz, mutlaka fiziksel cihaz kullanın!

---

## 📱 Kullanım

### İlk Kullanım
1. Uygulamayı açın - Splash screen görünecektir
2. "LET GET STARTED" butonuna tıklayın
3. Ana ekrana yönlendirileceksiniz

### BLE Cihaz Bağlantısı

#### Yöntem 1: Otomatik Bağlantı
1. Ana ekranda **Humidifier** kartındaki toggle butonuna tıklayın
2. Uygulama otomatik olarak "EVISTAL" cihazını arayacaktır
3. Bağlantı başarılı olduğunda yeşil "ON" durumuna geçecektir

#### Yöntem 2: Manuel Tarama
1. **"Scan BLE"** butonuna tıklayın
2. Alt kısımda açılan modalda EVISTAL cihazlarını göreceksiniz
3. İstediğiniz cihazın yanındaki **"Bağlan"** butonuna tıklayın
4. Bağlantı başarılı olursa otomatik olarak kontrol ekranına yönlendirileceksiniz

### Nemlendirici Kontrolü
1. Ana ekranda **Humidifier** kartına tıklayın
2. Kontrol ekranında:
   - **Difüzör** butonu: Nemlendirici modlarını değiştirir (Kapalı → Mod 1 → Mod 2)
   - **Renk** butonu: LED renk modlarını değiştirir (Kapalı → Rainbow → RGB → Beyaz)
3. Değişiklikler gerçek zamanlı olarak cihaza gönderilir

### Bağlantıyı Kesme
1. Ana ekrana dönün
2. Humidifier kartındaki toggle butonu "ON" konumundaysa tıklayın
3. Onay dialogunda **"Evet"** seçeneğine tıklayın

---

## 🏗️ Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası ve routing
├── device_model.dart            # Cihaz veri modeli ve enum'lar
├── controllers/
│   └── humidifier_controller.dart   # Nemlendirici state management
├── screens/
│   ├── splash_screen.dart       # İlk açılış ekranı
│   ├── home_screen.dart         # Ana kontrol paneli
│   └── humidifier_screen.dart   # Nemlendirici kontrol ekranı
└── services/
    └── ble/
        ├── ble_service.dart     # BLE iletişim servisi
        └── ble_permissions.dart # İzin yönetimi

assets/
└── images/
    ├── background.png           # Splash screen arka planı
    ├── appimage_1.png          # Uygulama ikonu
    └── appimg_android12.png    # Android 12+ ikonu
```

---

## 🔌 BLE Protokolü

### Servis ve Karakteristikler
```
Service UUID:  6e400001-b5a3-f393-e0a9-e50e24dcca9e
Write Char:    6e400002-b5a3-f393-e0a9-e50e24dcca9e (RX)
Notify Char:   6e400003-b5a3-f393-e0a9-e50e24dcca9e (TX)
```

### AT Komutları
| Komut | Parametre | Açıklama |
|-------|-----------|----------|
| `AT+RMOD=<mode>` | 0-3 | Renk modu (0: Kapalı, 1: Rainbow, 2: RGB, 3: Beyaz) |
| `AT+DMOD=<mode>` | 0-2 | Difüzör modu (0: Kapalı, 1: Mod 1, 2: Mod 2) |

**Örnek Kullanım:**
```dart
// Renk modunu Rainbow'a ayarla
await BleService.sendCommand('AT+RMOD=1');

// Difüzör modunu Mod 1'e ayarla
await BleService.sendCommand('AT+DMOD=1');
```

---

## 🎨 Tasarım Paleti

Uygulama modern lacivert tonlarında gradient bir tasarıma sahiptir:

```dart
Birincil Renk (Primary):    #1D4ED8  // Ana lacivert
Koyu Ton (Dark):           #1E3A8A  // Koyu lacivert
Arka Plan (Background):    #0F172A  // İçerik paneli
Panel Arka Plan:           #F2F8FF  // Açık mavi-beyaz
Vurgu Rengi (Accent):      #13007F  // Koyu mor-mavi
```

---

## 🐛 Bilinen Sorunlar ve Çözümler

### Sorun: BLE cihazı bulunamıyor
**Çözüm:**
- Bluetooth'un açık olduğundan emin olun
- Konum izinlerinin verildiğinden emin olun (Android)
- Cihazınızın BLE 4.0+ desteklediğinden emin olun
- EVISTAL cihazının açık ve eşleşme modunda olduğundan emin olun

### Sorun: Bağlantı kesilmeye devam ediyor
**Çözüm:**
- Cihazı ve telefonu yeniden başlatın
- Bluetooth cache'ini temizleyin (Android Ayarlar → Uygulamalar → Bluetooth)
- Cihaz ile telefon arasındaki mesafeyi azaltın

### Sorun: İzin hatası alınıyor
**Çözüm:**
- Uygulama izinlerini kontrol edin (Ayarlar → Uygulamalar → EVISTAL)
- Android 12+ için "Nearby devices" iznini verin
- Konum servislerinin açık olduğundan emin olun

---

## 🔄 Gelecek Özellikler (Roadmap)

- [ ] Zamanlayıcı özelliği
- [ ] Çoklu cihaz profilleri
- [ ] Otomasyon senaryoları
- [ ] Veri loglaması ve grafik gösterimi
- [ ] WiFi üzerinden kontrol desteği
- [ ] Sesli asistan entegrasyonu
- [ ] Tema özelleştirme

---

## 🤝 Katkıda Bulunma

Katkılarınızı memnuniyetle karşılıyoruz! Katkıda bulunmak için:

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

---

## 👥 İletişim

Proje Sahibi - [@your-github-username](https://github.com/your-username)

Proje Linki: [https://github.com/your-username/evistal_1](https://github.com/your-username/evistal_1)

---

## 🙏 Teşekkürler

- [Flutter Blue Plus](https://github.com/boskokg/flutter_blue_plus) - Harika BLE implementasyonu için
- [Awesome Dialog](https://pub.dev/packages/awesome_dialog) - Güzel dialog tasarımları için
- Flutter Community - Sürekli destek için

---

<div align="center">
  <strong>🏠 EVISTAL - Change Your Life For Better Life 🏠</strong>
  <br/>
  <sub>Built with ❤️ using Flutter</sub>
</div>
