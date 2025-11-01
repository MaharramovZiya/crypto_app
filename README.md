# 💜 Crypto App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

**Modern cryptocurrency mobile application built with Flutter**

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#️-tech-stack) • [Installation](#-installation) • [Usage](#-usage)

</div>

---

## ✨ Features

### 🏠 **Branding View**
- 💰 **Balance Card** - Beautiful gradient card displaying current balance with deposit/withdraw buttons
- 📊 **Holdings Section** - Real-time cryptocurrency holdings with:
  - Live price data from CoinGecko API
  - Mini sparkline charts (green/red waves based on price changes)
  - Coin icons and detailed information
  - Scrollable list of top cryptocurrencies

### 📈 **Trading View**
- 🎯 **Interactive Tabs** - Switch between top 6 cryptocurrencies (BTC, ETH, BNB, SOL, XRP, DOGE)
- 📉 **Large Area Chart** - Beautiful gradient chart with price history and dates
- 💵 **Buy/Sell Interface** - Complete trading interface with:
  - Price input fields
  - Amount calculation with percentage buttons (25%, 50%, 100%)
  - Buy and Sell action buttons

### 👤 **Profile View**
- 🎨 **Modern UI** - Beautiful purple gradient theme
- 📊 **Statistics Cards** - Total invested and profit tracking
- ⚙️ **Settings Menu** - Complete settings section with:
  - Personal Information
  - Security settings
  - Notifications
  - Payment Methods
  - Help Center
  - Terms & Privacy

### 🔍 **Coin Detail Page**
- 📱 **Detailed Coin Information** - Complete cryptocurrency details
- 📊 **Full Statistics** - Market cap, 24h high/low, volume, ATH/ATL
- 📈 **Price Chart** - Interactive sparkline chart with 7-day price data
- 🎨 **Beautiful UI** - Modern card-based design

---

## 📸 Screenshots

<div align="center">

| Splash Screen | Holdings | Trading |
|:---:|:---:|:---:|
| 🎨 Animated splash screen | 💰 Real-time crypto data | 📈 Interactive charts |

| Profile | Coin Details |
|:---:|:---:|
| 👤 User profile | 🔍 Detailed coin info |

</div>

---

## 🛠️ Tech Stack

### **Architecture**
- 🏗️ **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- 🔄 **State Management** - Provider pattern for state management
- 💉 **Dependency Injection** - GetIt for dependency management

### **Core Technologies**
- 📱 **Flutter** - Cross-platform mobile framework
- 🎯 **Dart** - Programming language
- 🌐 **REST API** - CoinGecko API for real-time cryptocurrency data
- 📡 **Dio** - HTTP client with interceptors

### **Key Packages**
```
dio                    # HTTP client
go_router              # Declarative routing
provider               # State management
equatable              # Value equality
dartz                  # Functional programming
get_it                 # Dependency injection
device_preview         # UI testing across devices
```

---

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Android SDK / iOS SDK

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/crypto_app.git
   cd crypto_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

---

## 🚀 Usage

### **API Configuration**

The app uses CoinGecko API for cryptocurrency data. Make sure you have:

1. **API Key** - Get your free API key from [CoinGecko](https://www.coingecko.com/en/api)
2. **Configuration** - Add your API key in `lib/config/configuration.dart`:
   ```dart
   final String apiKey = 'YOUR_API_KEY_HERE';
   ```

### **Running the App**

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### **Hot Reload**

- Press `r` in the terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

---

## 📁 Project Structure

```
lib/
├── config/              # Configuration and dependency injection
│   ├── injector.dart
│   └── configuration.dart
├── core/                # Core utilities and constants
│   ├── constants/
│   ├── error/
│   └── router/
├── data/                # Data layer
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/              # Domain layer
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/        # Presentation layer
│   ├── pages/
│   ├── providers/
│   └── widgets/
└── ui/                  # UI components
    ├── base/
    └── theme/
```

---

## 🎨 Design

### **Color Palette**
- 🟣 **Primary**: `#6552FE` (Purple)
- 🟢 **Secondary**: `#48D49E` (Green)
- ⚫ **Background**: `#1A1A1A` (Dark)
- ⚪ **Card Background**: `#2A2A2A` (Dark Gray)

### **Theme**
- 🌙 **Dark Mode** - Beautiful dark theme throughout
- 🎨 **Material 3** - Modern Material Design 3 components
- 📐 **Responsive** - Works on all screen sizes

---

## 🔧 Features in Detail

### **Real-time Data**
- ✅ Live cryptocurrency prices
- ✅ 7-day sparkline price charts
- ✅ Market statistics
- ✅ Price change indicators

### **Navigation**
- ✅ Bottom navigation bar
- ✅ Deep linking with go_router
- ✅ Smooth page transitions

### **UI/UX**
- ✅ Animated splash screen
- ✅ Loading states
- ✅ Error handling
- ✅ Pull-to-refresh
- ✅ Smooth scrolling

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Alex Johnson**

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: alex.johnson@example.com

---

## 🙏 Acknowledgments

- [CoinGecko](https://www.coingecko.com/) - For providing the cryptocurrency API
- [Flutter](https://flutter.dev/) - For the amazing framework
- All contributors who helped improve this project

---

<div align="center">

**Made with 💜 and Flutter**

⭐ If you like this project, give it a star!

</div>
