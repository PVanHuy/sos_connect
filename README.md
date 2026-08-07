# SOS Connect

Ứng dụng di động hỗ trợ cứu hộ khẩn cấp: gửi SOS, theo dõi sự kiện trên bản đồ, kết nối đội cứu hộ, hướng dẫn sinh tồn và nhận thông báo realtime.

---

## Mục lục

- [Giới thiệu dự án](#giới-thiệu-dự-án)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Hướng dẫn cài đặt](#hướng-dẫn-cài-đặt)
- [Cấu hình môi trường (.env)](#cấu-hình-môi-trường-env)
- [CI/CD](#cicd)
- [Tài liệu CI/CD chi tiết](docs/CI_CD.md)
- [Build Android](#build-android)
- [Build iOS](#build-ios)
- [Đóng góp](#đóng-góp)
- [License](#license)

---

## Giới thiệu dự án

**SOS Connect** là ứng dụng Flutter giúp người dùng:

- Gửi yêu cầu cứu hộ (SOS) kèm vị trí, mô tả và hình ảnh
- Xem sự kiện / điểm SOS trên bản đồ
- Đăng ký / tham gia đội cứu hộ, quản lý thành viên và yêu cầu tham gia
- Xem hướng dẫn sinh tồn
- Nhận thông báo đẩy (FCM) và kết nối Socket.IO

**Thông tin kỹ thuật**

| Mục            | Giá trị              |
| -------------- | -------------------- |
| Package        | `sos_connect`        |
| Application ID | `com.sosconnect.app` |
| Version        | `1.0.0+1`            |
| Dart SDK       | `^3.11.1`            |

---

## Công nghệ sử dụng

| Công nghệ                                                              | Mục đích                      |
| ---------------------------------------------------------------------- | ----------------------------- |
| [Flutter](https://flutter.dev)                                         | Framework UI đa nền tảng      |
| [GetX](https://pub.dev/packages/get)                                   | State management, routing, DI |
| [Firebase Messaging](https://firebase.google.com/docs/cloud-messaging) | Push notification (FCM)       |
| [Socket.IO Client](https://pub.dev/packages/socket_io_client)          | Realtime                      |
| [flutter_map](https://pub.dev/packages/flutter_map)                    | Bản đồ OpenStreetMap          |
| [geolocator](https://pub.dev/packages/geolocator)                      | GPS / vị trí hiện tại         |
| [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)              | Biến môi trường               |
| [http](https://pub.dev/packages/http)                                  | REST API                      |
| [json_serializable](https://pub.dev/packages/json_serializable)        | Parse model JSON              |

Các thư viện UI / tiện ích khác: `flutter_svg`, `cached_network_image`, `toastification`, `skeletonizer`, `vietnam_provinces`, `image_picker`, …

---

## Cấu trúc thư mục

```text
sos_connect/
├── android/                 # Native Android
├── ios/                     # Native iOS
├── assets/
│   ├── fonts/               # Font SF UI Display
│   ├── icons/               # SVG icons
│   └── images/              # Hình ảnh
├── lib/
│   ├── core/                # Gradient, shadow, shared styles
│   ├── extension/           # Dart extensions
│   ├── gen/                 # Code gen (flutter_gen)
│   ├── language/            # i18n (vi / en)
│   ├── model/               # Data models
│   ├── pages/               # Màn hình (GetX: page / controller / binding)
│   ├── resourese/           # Repository + service (API, FCM, socket)
│   ├── routes/              # Routes & GetPage
│   ├── theme/               # Theme & typography
│   ├── utils/               # Constants, helpers, validators
│   ├── widget/              # Shared widgets
│   └── main.dart            # Entry point
├── .github/workflows/       # CI (GitHub Actions)
├── pubspec.yaml
└── README.md
```

**Quy ước màn hình (GetX)**

```text
lib/pages/<feature>/
├── <feature>_page.dart
├── <feature>_controller.dart
├── <feature>_binding.dart
└── <feature>_parameter.dart   # (nếu có args điều hướng)
```

---

## Hướng dẫn cài đặt

### Yêu cầu

- Flutter SDK (khuyến nghị **stable**, tương thích Dart `^3.11.1`)
- Android Studio / Xcode (tùy nền tảng build)
- Tài khoản Firebase + file cấu hình (`google-services.json`, `GoogleService-Info.plist`)

### Các bước

```bash
# 1. Clone repository
git clone <repository-url>
cd sos_connect

# 2. Tạo file môi trường (xem mục bên dưới)
cp .env.example .env   # hoặc tự tạo file .env

# 3. Cài dependencies
flutter pub get

# 4. (Tuỳ chọn) Generate code
dart run build_runner build --delete-conflicting-outputs
dart run flutter_gen

# 5. Chạy app
flutter run
```

Kiểm tra môi trường:

```bash
flutter doctor
```

---

## Cấu hình môi trường (.env)

Ứng dụng load biến môi trường qua `flutter_dotenv`. File `.env` nằm ở root project và đã được khai báo trong `pubspec.yaml` (`assets: - .env`).

> **Lưu ý:** `.env` nằm trong `.gitignore` — không commit secret lên git.

### Biến bắt buộc

| Key          | Mô tả                | Ví dụ                        |
| ------------ | -------------------- | ---------------------------- |
| `BASE_URL`   | Base URL REST API    | `https://api.example.com`    |
| `SOCKET_URL` | URL Socket.IO server | `https://socket.example.com` |

### Ví dụ `.env`

```env
BASE_URL=https://api.example.com
SOCKET_URL=https://socket.example.com
```

Các key được đọc trong `lib/utils/app_constants.dart`.

### Firebase

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

---

## CI/CD

Dùng **GitHub Actions** với 2 workflow. Chi tiết đầy đủ (secrets, versioning, troubleshooting, sơ đồ luồng): xem **[docs/CI_CD.md](docs/CI_CD.md)**.

| Workflow | File | Mục đích |
|----------|------|----------|
| CI | [`.github/workflows/ci.yml`](.github/workflows/ci.yml) | Analyze + build APK/AAB + upload Artifacts |
| Release | [`.github/workflows/release.yml`](.github/workflows/release.yml) | Bump version, CHANGELOG, GitHub Release + APK/AAB |

### CI (`ci.yml`)

**Trigger:** `push` / `pull_request` vào nhánh `dev`

**Pipeline:** checkout → `.env` + keystore → Flutter 3.41.4 → `pub get` → `build_runner` → `analyze` → build signed APK/AAB → upload Artifacts

### Release (`release.yml`)

**Trigger:** chạy tay (**Actions → Release → Run workflow**)

**Input:** `bump` = `patch` | `minor` | `major` (mặc định `patch`)

**Pipeline:**

1. Tăng `version` trong `pubspec.yaml` (`versionName+versionCode`)
2. Sinh release notes từ commit (kể từ tag gần nhất)
3. Cập nhật `CHANGELOG.md`, commit + tạo tag `vX.Y.Z`
4. Build signed APK/AAB
5. Tạo [GitHub Release](https://github.com/PVanHuy/sos_connect/releases) và đính kèm:
   - `sos-connect-X.Y.Z.apk`
   - `sos-connect-X.Y.Z.aab`

### Secrets cần có (Settings → Secrets and variables → Actions)

| Secret | Mô tả |
|--------|--------|
| `ENV_FILE` | Nội dung file `.env` |
| `KEYSTORE_BASE64` | Keystore encode base64 |
| `KEYSTORE_PASSWORD` | Mật khẩu keystore |
| `KEY_PASSWORD` | Mật khẩu key |
| `KEY_ALIAS` | Alias key |

### Quyền Actions

**Settings → Actions → General → Workflow permissions:** chọn **Read and write permissions** (để Release commit bump version + tạo Release).

### Google Play (sau này)

Khi có tài khoản Play Console, thêm secret `PLAY_SERVICE_ACCOUNT_JSON` và bước upload AAB vào `release.yml` (track `internal` trước).

---

## Build Android

```bash
# Debug
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

**Output**

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

**Ghi chú**

- `applicationId`: `com.sosconnect.app`
- `compileSdk`: 36, `targetSdk`: 35
- Release hiện ký bằng debug keystore (cần cấu hình signing thật trước khi lên store)

---

## Build iOS

```bash
cd ios
pod install
cd ..

flutter build ios --release
# hoặc
flutter build ipa --release
```

**Yêu cầu**

- macOS + Xcode
- CocoaPods đã cài đặt
- Signing & capability (Push Notifications, Location, …) cấu hình trong Xcode

---

## Đóng góp

1. Tạo branch từ `dev` (ví dụ: `feature/ten-tinh-nang`)
2. Commit rõ ràng, tập trung vào một thay đổi
3. Chạy trước khi mở PR:

```bash
flutter analyze
flutter test
```

4. Tạo Pull Request vào `dev` và mô tả ngắn gọn thay đổi

---

## License

Chưa công bố license công khai. Mọi quyền thuộc về chủ sở hữu dự án **SOS Connect**.

Nếu bạn muốn dùng / phân phối lại, vui lòng liên hệ chủ dự án để được cấp phép.
