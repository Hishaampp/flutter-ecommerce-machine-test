# Codeedex Flutter Machine Test

## Flutter Version
Flutter 3.19.x / Dart 3.x

## State Management
**GetX** — used for reactive state, dependency injection, and navigation.

## Project Structure
```
lib/
├── models/          # Data models (User, Banner, Category, Product)
├── services/        # API service layer using Dio
├── modules/
│   ├── auth/        # Login screen + controller
│   ├── home/        # Home screen + controller
│   └── products/    # Products screen + controller
├── widgets/         # Reusable UI components
├── utils/           # Constants, colors, text styles
└── main.dart
```

## Steps to Run

1. Clone the repository
2. Navigate to project folder:
   ```bash
   cd codeedex_flutter_test
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Login Credentials
- **Email:** mobile@alisonsgroup.com
- **Password:** 12345678

## Assumptions Made
- The API base URL is `https://sungod.demospro2023.in.net/api`
- Image base URL is `https://sungod.demospro023.in.net`
- Login API returns `id` and `token` which are used in subsequent requests
- Products page fetches by `category` as the default filter
- Minor UI differences from Figma are acceptable where design file was not accessible

## Known Issues / Limitations
- Figma design link required login access — UI is built based on standard e-commerce conventions
- Product list API may return data under different keys depending on filters; fallback handling is in place
- No pagination implemented (bonus feature)