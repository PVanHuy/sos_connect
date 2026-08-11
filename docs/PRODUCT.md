# SOS Connect — Tài liệu sản phẩm

Tài liệu mô tả **mục tiêu**, **chức năng** và **luồng sử dụng** của ứng dụng di động **SOS Connect**, minh họa bằng screenshot thực tế trong `assets/images_app/`.

---

## 1. Dự án là gì?

**SOS Connect** kết nối người gặp sự cố với người / đội cứu hộ xung quanh:

> Người gặp nạn **đăng sự cố** (SOS) kèm vị trí → hệ thống thông báo tới lực lượng gần nhất → người khác **nhận hỗ trợ, đi tới hiện trường, chat realtime** → kết thúc khi nạn nhân **đã an toàn**.

Ứng dụng phục vụ hai phía:

| Vai trò                | Việc chính                                                                     |
| ---------------------- | ------------------------------------------------------------------------------ |
| **Người gặp sự cố**    | Gửi SOS, theo dõi trạng thái, chat với đội đang hỗ trợ, báo “đã an toàn”       |
| **Người / đội cứu hộ** | Xem SOS gần khu vực, nhận hỗ trợ, dẫn đường trên bản đồ, chat, hoàn tất cứu hộ |

---

## 2. Mục tiêu

| Mục tiêu                      | Ý nghĩa                                                                |
| ----------------------------- | ---------------------------------------------------------------------- |
| **Đăng sự cố nhanh**          | Mô tả, loại khẩn cấp, vị trí GPS, SĐT, ảnh — chỉ vài thao tác          |
| **Kêu gọi trợ giúp đúng chỗ** | Đẩy thông báo / danh sách SOS tới đội và tình nguyện viên gần khu vực  |
| **Đến hiện trường rõ ràng**   | Bản đồ + chỉ đường trong app; theo dõi tiến trình trên tab Hoạt động   |
| **Phối hợp realtime**         | Chat SOS, push notification (FCM), cập nhật trạng thái đến khi an toàn |
| **Tổ chức lực lượng**         | Đăng ký / quản lý đội cứu hộ, duyệt yêu cầu tham gia                   |

---

## 3. Luồng tổng quan (step)

```text
Onboarding → Đăng nhập
     ↓
Dashboard (Bản đồ)
     ↓
┌────────────────────────────┬────────────────────────────────┐
│  NGƯỜI GẶP SỰ CỐ           │  NGƯỜI / ĐỘI CỨU HỘ            │
│  1. Gửi SOS                │  1. Xem danh sách Hỗ trợ       │
│  2. Theo dõi yêu cầu       │  2. Nhận SOS / xem trên bản đồ │
│  3. Chat với đội           │  3. Chỉ đường tới hiện trường  │
│  4. Báo đã an toàn         │  4. Chat + hoàn thành cứu hộ   │
└────────────────────────────┴────────────────────────────────┘
     ↓
Thông báo · Đội cứu hộ · Tài khoản · Trợ lý AI
```

---

## 4. Bắt đầu dùng app

### Bước 1 — Onboarding (3 màn)

Giới thiệu mục tiêu: gặp nguy hiểm → đội đến hỗ trợ → bạn an toàn.

**1.1. Gửi SOS khi gặp nguy hiểm**

![Onboarding bước 1](../assets/images_app/onboarding_step1.jpg)

**1.2. Đội cứu hộ được kết nối và đến hỗ trợ**

![Onboarding bước 2](../assets/images_app/onboarding_step2.jpg)

**1.3. Đồng hành đến khi bạn an toàn**

![Onboarding bước 3](../assets/images_app/onboarding_step3.jpg)

---

### Bước 2 — Đăng ký / Đăng nhập

**2.1. Đăng nhập** bằng số điện thoại và mật khẩu

![Đăng nhập](../assets/images_app/login.jpg)

**2.2. Đăng ký tài khoản mới**

![Đăng ký](../assets/images_app/register.jpg)

**2.3. Xác thực OTP** (khi quên mật khẩu / xác minh)

![Xác thực OTP](../assets/images_app/verify_otp.jpg)

**2.4. Quên mật khẩu → tạo mật khẩu mới**

![Quên mật khẩu](../assets/images_app/forget_password.jpg)

![Tạo mật khẩu mới](../assets/images_app/create_new_password.jpg)

---

## 5. Dashboard — 5 tab chính

Sau khi đăng nhập, người dùng làm việc trên 5 tab:

| Tab           | Chức năng                                         |
| ------------- | ------------------------------------------------- |
| **Bản đồ**    | Xem vị trí SOS quanh khu vực, thời tiết, định vị  |
| **Hoạt động** | Yêu cầu SOS của bạn / nhiệm vụ cứu hộ đang nhận   |
| **Hỗ trợ**    | Danh sách SOS cần giúp (lọc loại, tỉnh/thành)     |
| **Tin tức**   | Thông báo ứng dụng & hệ thống (có badge chưa đọc) |
| **Tài khoản** | Hồ sơ, đội, đổi mật khẩu, cài đặt                 |

---

## 6. Luồng người gặp sự cố — đăng SOS và nhận giúp đỡ

### Bước 1 — Mở form Gửi SOS

Từ tab **Hỗ trợ**, chọn loại khẩn cấp để bắt đầu đăng sự cố (hoặc mở màn Gửi SOS).

![Tab Hỗ trợ — chọn loại SOS](../assets/images_app/ui_support_2.jpg)

![Tab Hỗ trợ — danh sách SOS xếp hạng AI](../assets/images_app/ui_support.jpg)

### Bước 2 — Điền thông tin sự cố

- Chọn loại: **Cần cứu hộ** / **Cấp cứu y tế** / **Thực phẩm/nước**
- Mô tả tình huống, vị trí, số điện thoại
- Đính kèm ảnh hiện trường (nếu có)
- Bấm **Gửi SOS**

![Form gửi SOS (trống)](../assets/images_app/send_sos.jpg)

![Form gửi SOS (đã điền + ảnh)](../assets/images_app/send_sos_2.jpg)

### Bước 3 — Theo dõi yêu cầu của bạn

Tab **Hoạt động** → **Yêu cầu hỗ trợ của bạn**:

- Trạng thái **Chờ nhận** khi chưa có đội nhận
- Có thể báo **Tôi đã được an toàn** để kết thúc sớm

![Yêu cầu đang chờ nhận](../assets/images_app/activity_support_me.jpg)

### Bước 4 — Khi đã có đội nhận hỗ trợ

Card cập nhật trạng thái **Đang hỗ trợ**, hiện thông tin đội, nút xem bản đồ / nhắn tin / báo an toàn.

![SOS đã được đội nhận](../assets/images_app/sos_received.jpg)

![Yêu cầu của bạn — đang / đã hỗ trợ](../assets/images_app/your_sos.jpg)

### Bước 5 — Chat với đội cứu hộ

Phối hợp vị trí, tình trạng, hướng dẫn tới hiện trường.

![Chat SOS](../assets/images_app/chat.jpg)

![Chat với leader đội](../assets/images_app/chat_team.jpg)

---

## 7. Luồng người / đội cứu hộ — tới giúp

### Bước 1 — Xem SOS cần hỗ trợ

Tab **Hỗ trợ**: lọc theo loại sự cố và tỉnh/thành; danh sách được **xếp hạng bởi AI**.

![Danh sách SOS cần hỗ trợ](../assets/images_app/ui_support.jpg)

### Bước 2 — Xem trên bản đồ & sự kiện quanh khu vực

Tab **Bản đồ**: cluster điểm SOS, định vị hiện tại, thời tiết khu vực.

![Bản đồ tổng quan](../assets/images_app/map.jpg)

![Zoom bản đồ](../assets/images_app/map_zoom.jpg)

![Xem sự kiện trên bản đồ](../assets/images_app/view_event_map.jpg)

### Bước 3 — Chỉ đường tới hiện trường

Sau khi nhận hỗ trợ, mở chỉ đường trong app (khoảng cách + thời gian ước tính).

![Chỉ đường tới sự kiện](../assets/images_app/view_routes_event.jpg)

### Bước 4 — Quản lý nhiệm vụ đang nhận

Tab **Hoạt động** → **Cứu trợ đang nhận**: xem mô tả, gọi điện, mở bản đồ, nhắn tin.

![Cứu trợ đang nhận](../assets/images_app/activity_receiving.jpg)

### Bước 5 — Chat với người gặp nạn

![Chat phối hợp cứu hộ](../assets/images_app/chat_team.jpg)

### Bước 6 — Hoàn thành cứu hộ

Khi kết thúc, xem lại thông tin sự cố đã hoàn thành; vẫn có thể mở lịch sử chat (read-only nếu đã đóng).

![Cứu trợ đã hoàn thành](../assets/images_app/rescue_complete.jpg)

---

## 8. Thông báo (Tin tức)

Giữ người dùng được cập nhật khi có SOS mới, đội nhận hỗ trợ, duyệt đội, tin hệ thống…

**Tab Ứng dụng** — thông báo liên quan vận hành SOS / đội

![Thông báo ứng dụng](../assets/images_app/notification.jpg)

**Tab Hệ thống** — thông báo hệ thống

![Thông báo hệ thống](../assets/images_app/notification_2.jpg)

> Badge đỏ trên tab **Tin tức** = số thông báo chưa đọc. Tap thông báo (trong app hoặc FCM) sẽ điều hướng đúng màn hình liên quan và đánh dấu đã đọc.

---

## 9. Đội cứu hộ — tổ chức lực lượng giúp đỡ

### Bước 1 — Xem danh sách đội

![Danh sách đội cứu hộ](../assets/images_app/view_list_team.jpg)

### Bước 2 — Xem chi tiết / thông tin đội

![Chi tiết đội](../assets/images_app/list_team_details.jpg)

![Thông tin đội cứu hộ](../assets/images_app/view_info_team.jpg)

### Bước 3 — Xin tham gia đội & theo dõi yêu cầu

![Yêu cầu tham gia của tôi](../assets/images_app/list_request_team.jpg)

### Bước 4 — Xem thành viên đội (Leader)

![Danh sách thành viên](../assets/images_app/view_member_team.jpg)

---

## 10. Tài khoản & hồ sơ

**Thông tin cá nhân**

![Hồ sơ / thông tin bạn](../assets/images_app/information_you.jpg)

![Trang tài khoản](../assets/images_app/profile.jpg)

**Đổi mật khẩu**

![Đổi mật khẩu](../assets/images_app/change_password.jpg)

---

## 11. Trợ lý AI

Hỗ trợ hướng dẫn cách gửi SOS, vận hành app, lưu ý khi gặp sự cố.

![Trợ lý AI](../assets/images_app/AI_CHAT.jpg)

---

## 12. Xem ảnh hiện trường (toàn màn)

Ảnh đính kèm trong SOS có thể mở xem full màn hình.

![Xem ảnh full](../assets/images_app/view_photo_full.jpg)

---

## 13. Tóm tắt chức năng theo mục tiêu dự án

| Mục tiêu                   | Chức năng trên app                          | Ảnh minh họa chính                                                      |
| -------------------------- | ------------------------------------------- | ----------------------------------------------------------------------- |
| Đăng sự cố mình gặp        | Gửi SOS (loại / mô tả / vị trí / SĐT / ảnh) | `send_sos.jpg`, `send_sos_2.jpg`                                        |
| Người khác thấy & tới giúp | Tab Hỗ trợ + Bản đồ + chỉ đường             | `ui_support.jpg`, `map.jpg`, `view_routes_event.jpg`                    |
| Theo dõi tiến trình        | Tab Hoạt động (của bạn / đang nhận)         | `activity_support_me.jpg`, `activity_receiving.jpg`, `sos_received.jpg` |
| Phối hợp realtime          | Chat SOS + Thông báo FCM                    | `chat.jpg`, `chat_team.jpg`, `notification.jpg`                         |
| Kết thúc an toàn           | Báo đã an toàn / hoàn thành cứu hộ          | `rescue_complete.jpg`, `your_sos.jpg`                                   |
| Tổ chức lực lượng          | Đội cứu hộ, xin gia nhập, thành viên        | `view_info_team.jpg`, `list_request_team.jpg`                           |

---

## 14. Ghi chú kỹ thuật ngắn (cho dev)

- Package: `sos_connect`
- Bản đồ: OpenStreetMap + chỉ đường trong app (OSRM)
- Realtime: Firebase Cloud Messaging + Socket.IO
- Chat SOS theo từng sự kiện (`sosId`)
- Vai trò: người dùng thường / volunteer / leader (quyền nhận SOS & quản lý đội khác nhau)

---

_Ảnh trong tài liệu lấy từ `assets/images_app/` — screenshot UI thực tế của app._
