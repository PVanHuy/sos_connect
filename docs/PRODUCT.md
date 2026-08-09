# SOS Connect — Mục tiêu & Chức năng

Tài liệu mô tả **mục tiêu dự án** và các **chức năng** của ứng dụng di động SOS Connect (package `sos_connect`, application ID `com.sosconnect.app`).

---

## 1. Mô tả ngắn

**SOS Connect** là ứng dụng hỗ trợ cứu hộ khẩn cấp khi thiên tai / sự cố: người gặp nạn gửi tín hiệu SOS kèm vị trí chỉ với vài thao tác; hệ thống kết nối họ với đội cứu hộ gần nhất; hai bên theo dõi sự kiện trên bản đồ, chat realtime và cập nhật trạng thái cứu hộ đến khi hoàn tất.

> *Gặp nguy hiểm → Gửi SOS → Đội cứu hộ nhận & đến hỗ trợ → An toàn.*

---

## 2. Mục tiêu dự án

| Mục tiêu | Ý nghĩa |
| -------- | ------- |
| **Giảm thời gian phản ứng** | Người dân gửi SOS nhanh, kèm GPS / địa chỉ / mô tả / ảnh |
| **Kết nối đúng lực lượng** | Ghép người gặp nạn với đội cứu hộ (leader / tình nguyện viên) trong khu vực |
| **Minh bạch tiến trình** | Theo dõi trạng thái SOS trên bản đồ & danh sách hoạt động |
| **Phối hợp realtime** | Push notification (FCM) + Socket.IO cho sự kiện mới, bản đồ, chat |
| **Nâng cao sẵn sàng** | Hướng dẫn sinh tồn; quản lý đội cứu hộ và yêu cầu tham gia |

Ứng dụng phục vụ hai nhóm chính:

- **Người dùng / nạn nhân**: gửi SOS, theo dõi yêu cầu của mình, hủy khi không còn cần, xem hướng dẫn sinh tồn.
- **Đội cứu hộ** (Leader / Volunteer thuộc team): nhận yêu cầu, nhận nhiệm vụ, chat với người gặp nạn, hoàn tất cứu hộ, quản lý đội.

---

## 3. Vai trò người dùng

| Vai trò | Mã | Khả năng chính |
| ------- | -- | -------------- |
| **Guest / người dùng thường** | `guest` (hoặc chưa thuộc team) | Đăng ký/đăng nhập, gửi SOS, xem bản đồ & hoạt động của mình, xem danh sách đội, xin gia nhập đội, xem hướng dẫn sinh tồn |
| **Volunteer** | `volunteer` (đã có `teamId`) | Như trên + nhận / chấp nhận SOS trong phạm vi đội, xem nhiệm vụ đang hỗ trợ, chat SOS |
| **Leader** | `leader` | Như volunteer + đăng ký / chỉnh sửa đội cứu hộ, duyệt yêu cầu gia nhập, xem danh sách thành viên |

Quyền nhận SOS (`canAcceptSos`) chỉ khi user là **leader**, hoặc **volunteer đã thuộc team**, và **không đang có nhiệm vụ hỗ trợ dang dở** (`IN_PROGRESS`).

---

## 4. Mô tả đầy đủ chức năng

### 4.1. Khởi động & onboarding

- **Splash**: kiểm tra trạng thái đăng nhập / lần đầu mở app.
- **Onboarding** (3 bước):
  1. Gặp nguy hiểm do thiên tai → gửi SOS & chia sẻ vị trí.
  2. Hệ thống kết nối tới đội cứu hộ gần nhất.
  3. Đồng hành đến khi người dùng an toàn.
- Hỗ trợ **bỏ qua** onboarding; lần sau vào thẳng đăng nhập / dashboard.

### 4.2. Tài khoản & bảo mật

| Chức năng | Mô tả |
| --------- | ----- |
| Đăng ký | Số điện thoại, mật khẩu, họ tên, tỉnh/thành… |
| Đăng nhập | SĐT + mật khẩu; lưu token local |
| Quên mật khẩu | Nhập SĐT → OTP → tạo mật khẩu mới |
| OTP | Xác thực mã OTP (pin code), đếm ngược gửi lại |
| Thông tin cá nhân | Xem / cập nhật hồ sơ (avatar, thông tin liên hệ…) |
| Đổi mật khẩu | Đổi mật khẩu khi đã đăng nhập |
| Đăng xuất | Xóa phiên, về màn đăng nhập |
| Đa ngôn ngữ | i18n `vi` / `en` |

### 4.3. Dashboard (5 tab chính)

1. **Bản đồ (Map)** — điểm SOS trên OpenStreetMap, vị trí hiện tại, nhận / theo dõi sự kiện gần đây.
2. **Hoạt động (Activity)** — yêu cầu SOS của tôi; với thành viên đội: thêm tab nhiệm vụ đang nhận.
3. **Hỗ trợ (Support)** — danh sách SOS đang chờ (`PENDING`), lọc theo loại / tỉnh / bán kính / khung thời gian; chấp nhận cứu hộ.
4. **Tin tức / Thông báo (News)** — danh sách thông báo đẩy & trong app; badge số chưa đọc.
5. **Tài khoản (Account)** — hồ sơ, khu vực cứu hộ, cài đặt, đăng xuất.

### 4.4. Gửi SOS

Màn `Send SOS`:

- Chọn **loại sự cố**: cần cứu hộ / y tế / lương thực (và loại khác nếu có).
- Tự điền **vị trí GPS** (từ map hoặc geolocator) và chuyển thành địa chỉ.
- Nhập **mô tả**, **SĐT liên hệ**, đính kèm **ảnh** (tuỳ chọn).
- Gửi yêu cầu → tạo sự kiện SOS trên hệ thống → realtime tới đội cứu hộ / bản đồ.

**Trạng thái SOS** (tóm tắt):

| Status | Ý nghĩa |
| ------ | ------- |
| `PENDING` / `REQUESTED` | Đang chờ đội nhận |
| `IN_PROGRESS` | Đã được nhận, đang hỗ trợ |
| `COMPLETE` | Hoàn tất cứu hộ |
| `CANCELED` | Người gửi hủy |

Người gửi có thể **hủy** yêu cầu của mình khi còn phù hợp (từ Activity / màn chi tiết liên quan).

### 4.5. Bản đồ cứu hộ

- Hiển thị marker / cluster sự kiện SOS theo viewport.
- Theo dõi vị trí người dùng.
- Cập nhật realtime qua Socket (`sos:new_request`, `sos:map_updated`, …).
- Thành viên đội có thể **nhận cứu hộ** trực tiếp từ marker (giới hạn: không nhận khi đang có nhiệm vụ dang dở).
- Chế độ live của đội (namespace team live): bật live mode, cập nhật vị trí đội, cảnh báo SOS gần (`sos:nearby_alert`).

### 4.6. Hỗ trợ & nhận nhiệm vụ

Tab **Support**:

- Danh sách SOS chờ xử lý, phân trang.
- Lọc: loại sự cố, tỉnh/thành, bán kính (km), khung thời gian.
- **Chấp nhận cứu hộ** → chuyển trạng thái sang đang hỗ trợ.
- Chỉ leader / volunteer thuộc team mới nhận được; mỗi người chỉ giữ **một** nhiệm vụ `IN_PROGRESS` tại một thời điểm.

Tab **Activity**:

- **Yêu cầu của bạn**: SOS do chính user gửi.
- **Đang nhận hỗ trợ** (nếu có role team): nhiệm vụ đang thực hiện.
- Có thể đánh dấu / thao tác liên quan an toàn / hủy theo luồng nghiệp vụ.

**Rescue completed**: lịch sử cứu hộ đã nhận / đã hoàn tất (xem từ Account).

### 4.7. Chat cứu hộ (SOS Chat)

- Phòng chat gắn với sự kiện SOS giữa người gửi và đội hỗ trợ.
- Realtime qua Socket namespace `/chat` (`chat:join`, `chat:send_message`, `chat:new_message`, …).
- Lịch sử tin nhắn (pagination) qua API chat / SOS chat repository.

### 4.8. Đội cứu hộ

| Chức năng | Ai dùng | Mô tả |
| --------- | ------- | ----- |
| Đăng ký đội | Leader (đăng ký mới) | Form 2 bước: thông tin đội (tên, tỉnh, xã/phường, quy mô, đơn vị, giấy tờ) + người liên hệ; **vai trò mặc định Leader** |
| Xem / sửa thông tin đội | Leader | Xem chi tiết; chỉnh sửa khi đủ quyền |
| Danh sách đội đã duyệt | Tất cả | Duyệt / tìm đội cứu hộ |
| Chi tiết đội | Tất cả | Thông tin đội; gửi **yêu cầu gia nhập** kèm lời nhắn |
| Yêu cầu gia nhập | Leader: duyệt/từ chối; User: xem yêu cầu của mình | Danh sách + chi tiết request |
| Thành viên đội | Leader / thành viên | Danh sách member; xem chi tiết user |
| Live mode đội | Thành viên đội | Chia sẻ vị trí đội khi đang hoạt động |

### 4.9. Thông báo

- **FCM** (Firebase Cloud Messaging) + local notification.
- Đăng ký / cập nhật FCM token sau khi vào Dashboard.
- Deep link theo loại thông báo: yêu cầu gia nhập đội, chi tiết đội, danh sách request, sự kiện SOS, v.v.
- Màn danh sách thông báo + **chi tiết thông báo**.

### 4.10. Hướng dẫn sinh tồn

- Danh sách bài hướng dẫn sinh tồn.
- Màn chi tiết (nội dung HTML / rich content).
- Hỗ trợ người dùng chuẩn bị / ứng phó khi chưa hoặc đang chờ cứu hộ.

### 4.11. Realtime & hạ tầng liên quan

| Thành phần | Vai trò |
| ---------- | ------- |
| REST API (`BASE_URL`) | Auth, SOS, team, profile, notification, chat… |
| Socket.IO (`SOCKET_URL`) | Feed SOS, map update, team live, chat |
| Firebase Messaging | Push khi app nền / tắt |
| Geolocator + flutter_map | GPS & bản đồ OSM |
| Local storage | Token, trạng thái đăng nhập, onboarding… |

---

## 5. Luồng nghiệp vụ chính

### 5.1. Người gặp nạn gửi SOS

```text
Mở app → (Đăng nhập) → Bản đồ / Gửi SOS
  → Chọn loại + mô tả + vị trí (+ ảnh)
  → Tạo SOS (PENDING)
  → Theo dõi ở Activity / nhận thông báo khi đội nhận
  → Chat với đội (nếu có)
  → Hoàn tất hoặc tự hủy
```

### 5.2. Đội cứu hộ nhận nhiệm vụ

```text
Leader đăng ký đội / Volunteer xin gia nhập & được duyệt
  → Tab Support hoặc Map thấy SOS PENDING
  → Lọc khu vực → Chấp nhận
  → Nhiệm vụ IN_PROGRESS (Activity – đang nhận)
  → Chat / điều phối → COMPLETE
```

### 5.3. Quản lý đội

```text
Đăng ký đội (Leader) → Duyệt join request
  → Quản lý thành viên
  → (Tuỳ chọn) bật live mode khi đi cứu hộ
```

---

## 6. Phạm vi kỹ thuật (tóm tắt)

- **Nền tảng**: Flutter (Dart `^3.11.1`), Android / iOS.
- **Kiến trúc UI**: GetX (routing, DI, state) — mỗi feature gồm `page` / `controller` / `binding` (+ `parameter` nếu cần).
- **Dữ liệu**: Repository pattern (`lib/resourese/`), model `json_serializable`.
- **Chi tiết cài đặt / CI/CD / build**: xem [README.md](../README.md) và [CI_CD.md](./CI_CD.md).

---

## 7. Tóm tắt giá trị sản phẩm

SOS Connect hướng tới một **cầu nối số giữa người gặp nạn và lực lượng cứu hộ địa phương**: gửi tín hiệu nhanh, định vị rõ, phân phối nhiệm vụ có kiểm soát theo đội, phối hợp realtime và lưu vết quá trình cứu hộ — đồng thời bổ sung nội dung sinh tồn để tăng khả năng tự bảo vệ trước khi lực lượng tới nơi.
