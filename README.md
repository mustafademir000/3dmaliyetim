# 📦 3D Maliyetim - 3D Printing Cost & Pricing Estimator

[![Flutter](https://img.shields.io/badge/Flutter-3.35+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen)](#)

**3D Maliyetim**, 3D baskı (FDM / SLA / Reçine) üreticileri, atölyeler ve hobi geliştiricileri için tasarlanmış hassas **3D Baskı Üretim Maliyeti ve Satış Fiyatı Hesaplama** mobil uygulamasıdır.

Filament harcamasından cihaz elektrik tüketimine, amortisman ücretinden işçilik süresine, KDV ve pazaryeri komisyonlarından kargo maliyetine kadar tüm kalemleri otomatik hesaplar.

---

## ✨ Öne Çıkan Özellikler

- ⚖️ **Doğrudan 1 Kg Filament Fiyatı Hesabı**: Karmaşık makara gramajları ile uğraşmadan kullanılan gramaj ve 1 kg fiyatı üzerinden net hammadde maliyeti.
- 🖨️ **3D Yazıcı Ön Ayarları**: **Snapmaker U1**, Bambu Lab X1C/P1S, Creality Ender 3 gibi popüler yazıcı profilleri veya özel cihaz ekleme.
- ⚡ **Elektrik & Amortisman Hesabı**: Cihazın Watt tüketimi ve saatlik yıpranma maliyeti bazlı otomatik hesaplama.
- 📊 **Dinamik Grafik & Fiyat Dökümü**: `fl_chart` destekli görsel maliyet dağılımı (Donut chart).
- 🧾 **KDV, Komisyon & Kargo Kalemleri**:
  - KDV (%) hesabı
  - **Pazaryeri Komisyonu (%)**: *KDV dahil ürün fiyatı üzerinden otomatik hesaplanır.*
  - Sabit Kargo Ücreti (TL)
- 💾 **Kaydedilenler (Local DB)**: Teklifleri model ismiyle kaydetme ve kayıtlı tekliflerin isimlerini sonradan **düzenleme / güncelleme** (SharedPreferences persistence).
- 📈 **Kâr Marjı Rozeti**: Kaydedilen tekliflerde kâr yüzdesi ve tutarını (`Kâr Oranı: %40 (50.00 TL)`) anında görüntüleme.
- 🌗 **Karanlık & Aydınlık Tema (Material Design 3)**: Göz yormayan modern karanlık arayüz.

---

## 🧮 Hesaplama Formülü

$$\text{Filament Maliyeti} = \left(\frac{\text{Gramaj}}{1000}\right) \times \text{1 Kg Fiyatı}$$

$$\text{Elektrik Maliyeti} = \left(\frac{\text{Watt}}{1000}\right) \times \text{Baskı Saati} \times \text{kWh Fiyatı}$$

$$\text{Amortisman Maliyeti} = \text{Baskı Saati} \times \text{Saatlik Yıpranma Ücreti}$$

$$\text{Net Ürün Fiyatı} = \text{Üretim Maliyeti} + \text{Kâr Tutarı}$$

$$\text{KDV Dahil Fiyat} = \text{Net Ürün Fiyatı} \times \left(1 + \frac{\text{KDV \%}}{100}\right)$$

$$\text{Komisyon Tutarı} = \text{KDV Dahil Fiyat} \times \left(\frac{\text{Komisyon \%}}{100}\right)$$

$$\mathbf{\text{Nihai Satış Fiyatı}} = \text{KDV Dahil Fiyat} + \text{Komisyon Tutarı} + \text{Kargo Ücreti}$$

---

## 🛠️ Kurulum & Çalıştırma

### Gereksinimler
- Flutter SDK (v3.35 veya üzeri)
- Dart SDK (v3.9 veya üzeri)
- Android Studio / VS Code

### Projeyi Klonlama ve Çalıştırma

```bash
# Depoyu klonlayın
git clone https://github.com/mustafademir000/3dmaliyetim.git
cd 3dmaliyetim

# Bağımlılıkları yükleyin
flutter pub get

# Testleri çalıştırın
flutter test

# Android cihazınızda çalıştırın
flutter run -d android
```

### Release APK Derleme

```bash
flutter build apk --release
```
Derlenen APK dosyası `build/app/outputs/flutter-apk/app-release.apk` dizininde oluşturulur.

---

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── constants/       # AppColors, AppTheme (Material 3)
│   └── utils/           # Calculator formülleri, CurrencyFormatter
├── features/
│   └── calculator/
│       ├── models/      # FilamentModel, PrinterModel, CalculationResult, HistoryItem
│       ├── providers/   # State management (Provider)
│       ├── screens/     # HomeScreen, CalculatorTab, PresetsTab, HistoryTab
│       └── widgets/     # CostResultCard, CostBreakdownChart, Dialoglar
└── main.dart
```

---

## 📜 Lisans

Bu proje **[MIT Lisansı](LICENSE)** ile lisanslanmıştır. Açık kaynaklıdır ve serbestçe kullanılabilir, geliştirilebilir.

---

**Geliştirici:** [Mustafa Demir](https://github.com/mustafademir000)
