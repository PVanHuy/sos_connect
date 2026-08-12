# CI/CD — SOS Connect

Tài liệu mô tả pipeline **Continuous Integration / Continuous Delivery** của dự án SOS Connect trên **GitHub Actions**.

---

## Mục lục

- [Tổng quan](#tổng-quan)
- [Sơ đồ luồng](#sơ-đồ-luồng)
- [Nhánh & quy ước](#nhánh--quy-ước)
- [Workflow CI](#workflow-ci)
- [Workflow Release](#workflow-release)
- [GitHub Secrets](#github-secrets)
- [Quyền Actions](#quyền-actions)
- [Artifacts & GitHub Releases](#artifacts--github-releases)
- [Cách chạy Release](#cách-chạy-release)
- [Versioning](#versioning)
- [Checklist trước khi merge](#checklist-trước-khi-merge)
- [Troubleshooting](#troubleshooting)
- [Hướng mở rộng](#hướng-mở-rộng)

---

## Tổng quan

| Workflow | File | Trigger | Mục đích |
|----------|------|---------|----------|
| **Flutter CI** | [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) | `push` / `pull_request` → `dev` | Push: tự tăng `versionCode` (`+N`) rồi build signed APK/AAB. PR: analyze + build, không bump |
| **Release** | [`.github/workflows/release.yml`](../.github/workflows/release.yml) | Manual (`workflow_dispatch`) | Bump version, cập nhật CHANGELOG, tag, GitHub Release + đính kèm APK/AAB |

**Stack build**

| Thành phần | Giá trị |
|------------|---------|
| Runner | `ubuntu-latest` |
| Java | Temurin **17** |
| Flutter | **3.41.4** (channel `stable`) |
| Signing | Android upload keystore (từ Secrets) |

---

## Sơ đồ luồng

```text
feature/* ──PR──► dev ──CI──► bump +N trong pubspec.yaml
                     │         (commit lại nhánh dev)
                     │         build signed APK + AAB
                     ▼
              Artifacts sos-connect-X.Y.Z+N.aab  →  upload Play Console
                     │
                     │  Actions → Release (manual)
                     ▼
              bump versionName (patch/minor/major) + CHANGELOG
                     │
                     ▼
              tag vX.Y.Z + GitHub Release
                     │
                     ▼
              APK / AAB đính kèm Release
```

---

## Nhánh & quy ước

| Nhánh / Tag | Vai trò |
|-------------|---------|
| `dev` | Nhánh tích hợp chính; CI chạy trên mọi push/PR vào đây |
| `feature/*`, `fix/*`, … | Làm việc local → mở PR vào `dev` |
| `vX.Y.Z` | Tag semver do workflow Release tạo |

**Commit message (khuyến nghị)**

- `feat:` tính năng mới
- `fix:` sửa lỗi
- `chore:` bảo trì (bump dependency, CI, …)
- `docs:` tài liệu
- `refactor:` tái cấu trúc không đổi hành vi

Release notes và CHANGELOG được sinh từ message commit kể từ tag gần nhất.

---

## Workflow CI

**File:** `.github/workflows/ci.yml`
**Tên trên Actions:** `Flutter CI`

### Khi nào chạy

- Push lên `dev`
- Pull request nhắm vào `dev`

### Các bước chính

1. Checkout source
2. **Push vào `dev`:** tăng `versionCode` trong `pubspec.yaml` (`1.0.0+6` → `1.0.0+7`), commit + push (`[skip ci]`)
3. Tạo `.env` từ secret `ENV_FILE`
4. Decode keystore (`KEYSTORE_BASE64`) → `android/upload-keystore.jks`
5. Tạo `android/key.properties` từ secrets signing
6. Setup Java 17 + Flutter 3.41.4 (có cache)
7. Cache Gradle
8. `flutter pub get`
9. `dart run build_runner build --delete-conflicting-outputs`
10. `flutter analyze`
11. `flutter build apk --release`
12. `flutter build appbundle --release`
13. Upload Artifacts: `sos-connect-X.Y.Z+N-apk` / `-aab`

> Pull request **không** bump version (tránh conflict). Chỉ push lên `dev` mới tăng `+N` — đây là số Google Play bắt buộc tăng mỗi lần upload AAB (`versionCode`).

### Quyền

```yaml
permissions:
  contents: write
```

Cần write để CI commit lại `pubspec.yaml` sau khi bump.

---

## Workflow Release

**File:** `.github/workflows/release.yml`
**Tên trên Actions:** `Release`
**Trigger:** chỉ chạy thủ công (`workflow_dispatch`)

### Input

| Input | Kiểu | Mặc định | Mô tả |
|-------|------|----------|--------|
| `bump` | `patch` \| `minor` \| `major` | `patch` | Cách tăng version trong `pubspec.yaml` |

### Các bước chính

1. Checkout (full history, `fetch-depth: 0`)
2. Bump `version:` trong `pubspec.yaml` (`versionName+buildNumber`)
3. Sinh `release_notes.md` từ `git log` kể từ tag gần nhất
4. Chèn section mới vào `CHANGELOG.md`
5. Commit `chore(release): X.Y.Z+N`, push, tạo annotated tag `vX.Y.Z`
6. Build signed APK + AAB (giống CI)
7. Đổi tên artifact: `sos-connect-X.Y.Z.apk` / `.aab`
8. Upload Actions Artifacts
9. Tạo **GitHub Release** và đính kèm APK + AAB

### Concurrency

```yaml
concurrency:
  group: release
  cancel-in-progress: false
```

Đảm bảo không chạy song song hai release cùng lúc.

### Quyền

```yaml
permissions:
  contents: write
```

Cần để commit bump version, push tag và tạo GitHub Release.

---

## GitHub Secrets

Cấu hình tại: **Settings → Secrets and variables → Actions**

| Secret | Bắt buộc | Mô tả |
|--------|----------|--------|
| `ENV_FILE` | Có | Toàn bộ nội dung file `.env` (xuống dòng giữ nguyên) |
| `KEYSTORE_BASE64` | Có | File `.jks` / `.keystore` encode Base64 |
| `KEYSTORE_PASSWORD` | Có | Mật khẩu keystore |
| `KEY_PASSWORD` | Có | Mật khẩu key |
| `KEY_ALIAS` | Có | Alias của key signing |

### Tạo `KEYSTORE_BASE64` (local)

```bash
# macOS / Linux
base64 -i upload-keystore.jks | pbcopy   # hoặc copy output

# Windows (Git Bash / WSL)
base64 -w 0 upload-keystore.jks
```

Dán nguyên chuỗi Base64 vào secret `KEYSTORE_BASE64` (một dòng, không xuống dòng giữa chừng nếu dùng `-w 0`).

### Ví dụ nội dung `ENV_FILE`

```env
BASE_URL=https://api.example.com
SOCKET_URL=https://socket.example.com
OSRM_ROUTE_URL=https://router.example.com
```

> Không commit `.env` hay keystore vào git. Các file này chỉ tồn tại trên runner trong lúc job chạy.

---

## Quyền Actions

**Settings → Actions → General → Workflow permissions**

- Chọn **Read and write permissions**
- (Khuyến nghị) bật **Allow GitHub Actions to create and approve pull requests** nếu sau này cần bot mở PR

Thiếu quyền write → Release sẽ fail khi commit / tạo tag / tạo GitHub Release.

---

## Artifacts & GitHub Releases

### CI Artifacts

Sau khi CI xanh:

1. Vào **Actions** → chọn run thành công
2. **Artifacts** → tải `sos-connect-X.Y.Z+N-apk` / `sos-connect-X.Y.Z+N-aab` (đúng `versionCode` vừa bump)

### GitHub Release

Sau khi Release thành công:

- Trang Releases: `https://github.com/<org-or-user>/sos_connect/releases`
- Mỗi release có tag `vX.Y.Z` và file:
  - `sos-connect-X.Y.Z.apk`
  - `sos-connect-X.Y.Z.aab`

---

## Cách chạy Release

1. Đảm bảo nhánh làm việc đã merge vào `dev` (hoặc nhánh đang checkout khi chạy workflow — mặc định checkout default branch của repo; nên chạy từ trạng thái đã sẵn sàng release).
2. Vào **Actions** → **Release** → **Run workflow**
3. Chọn `bump`:
   - `patch` — `1.0.0` → `1.0.1` (sửa lỗi nhỏ)
   - `minor` — `1.0.1` → `1.1.0` (tính năng tương thích ngược)
   - `major` — `1.1.0` → `2.0.0` (breaking change)
4. **Run workflow** và theo dõi log đến bước Create GitHub Release

---

## Versioning

Định dạng trong `pubspec.yaml`:

```yaml
version: 1.0.0+6
#         ^^^^^ ^
#         name  build number = versionCode Android (Play Console)
```

Google Play **không cho upload AAB trùng `versionCode`**. Mỗi bản lên store phải có `+N` lớn hơn bản trước.

| Workflow | Version name (`1.0.0`) | Build number (`+N`) |
|----------|------------------------|---------------------|
| **CI** (push `dev`) | Giữ nguyên | Tự `+1` rồi commit `pubspec.yaml` |
| **Release** `patch` | `X.Y.(Z+1)` | `+1` |
| **Release** `minor` | `X.(Y+1).0` | `+1` |
| **Release** `major` | `(X+1).0.0` | `+1` |

Tag Git (Release): `v` + version name (ví dụ `v1.0.1`).

AAB từ CI artifact đã mang `versionCode` mới — upload Play không cần sửa tay `pubspec.yaml`.

---

## Checklist trước khi merge

- [ ] PR vào `dev`, CI **Flutter CI** đã pass
- [ ] `flutter analyze` sạch (không error)
- [ ] Không commit `.env`, keystore, `google-services` secret thừa
- [ ] Message commit rõ ràng (phục vụ release notes)
- [ ] Secrets trên GitHub đã cấu hình đủ trước khi cần build signed

---

## Troubleshooting

| Triệu chứng | Nguyên nhân thường gặp | Cách xử lý |
|-------------|------------------------|------------|
| Fail ở Create `.env` | Thiếu / sai `ENV_FILE` | Kiểm tra secret, giữ đúng format nhiều dòng |
| Fail signing / keystore | Sai Base64, password, alias | Encode lại keystore; đối chiếu `key.properties` local |
| `flutter analyze` fail | Lỗi lint / type | Chạy `flutter analyze` local, sửa trước khi push |
| `build_runner` fail | Conflict generated files | Chạy lại `--delete-conflicting-outputs` local |
| Release không push được | Workflow permissions read-only | Bật **Read and write permissions** |
| Tag đã tồn tại | Chạy release trùng version | Không chạy lại cùng bump nếu tag đã tạo; tăng bump phù hợp |
| Artifact rỗng | Path build sai / build fail trước đó | Xem log bước Build APK / AAB |
| Play: version code already used | AAB vẫn `+N` cũ (CI chưa bump / tải nhầm artifact) | Push lại `dev` để CI tăng `+N`; tải artifact tên `sos-connect-X.Y.Z+N.aab` |
| CI không push được bump | Workflow permissions read-only | Bật **Read and write permissions** |

---

## Hướng mở rộng

Các bước có thể bổ sung sau khi ổn định Android release:

1. **Upload Google Play** — secret `PLAY_SERVICE_ACCOUNT_JSON`, publish AAB lên track `internal` / `beta`
2. **iOS CI** — runner `macos-latest`, certificates + provisioning profiles qua Secrets / App Store Connect API
3. **Test job** — `flutter test` trước `analyze` / build
4. **PR checks bắt buộc** — branch protection trên `dev`: yêu cầu CI xanh mới merge
5. **Matrix / flavor** — tách `dev` / `staging` / `prod` env nếu có nhiều môi trường

---

## Liên kết nhanh

| Mục | Đường dẫn |
|-----|-----------|
| CI workflow | [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) |
| Release workflow | [`.github/workflows/release.yml`](../.github/workflows/release.yml) |
| Changelog | [`CHANGELOG.md`](../CHANGELOG.md) |
| Hướng dẫn cài đặt chung | [`README.md`](../README.md) |

---

*Tài liệu phản ánh cấu hình CI/CD hiện tại của SOS Connect. Khi thay đổi workflow, cập nhật file này cho đồng bộ.*
