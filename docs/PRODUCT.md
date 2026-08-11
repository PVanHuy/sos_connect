# SOS Connect — Tài liệu sản phẩm

**SOS Connect** kết nối người gặp sự cố với người / đội cứu hộ xung quanh.

> Đăng sự cố (SOS) kèm vị trí → thông báo lực lượng gần nhất → nhận hỗ trợ, chỉ đường, chat realtime → báo đã an toàn.

| Vai trò                | Việc chính                                                  |
| ---------------------- | ----------------------------------------------------------- |
| **Người gặp sự cố**    | Gửi SOS, theo dõi, chat với đội, báo đã an toàn             |
| **Người / đội cứu hộ** | Xem SOS gần khu vực, nhận hỗ trợ, chỉ đường, chat, hoàn tất |

### Mục tiêu

| Mục tiêu                  | Ý nghĩa                                        |
| ------------------------- | ---------------------------------------------- |
| Đăng sự cố nhanh          | Loại khẩn cấp, mô tả, GPS, SĐT, ảnh            |
| Kêu gọi trợ giúp đúng chỗ | Đẩy SOS tới đội / tình nguyện viên gần khu vực |
| Đến hiện trường rõ ràng   | Bản đồ + chỉ đường trong app                   |
| Phối hợp realtime         | Chat SOS + FCM + cập nhật trạng thái           |
| Tổ chức lực lượng         | Đăng ký / quản lý đội, duyệt xin gia nhập      |

### Luồng tổng quan

```text
Onboarding → Đăng nhập → Dashboard
        ┌──────────────────┬─────────────────────┐
        │ Người gặp sự cố  │ Người / đội cứu hộ  │
        │ Gửi SOS → Theo dõi → Chat → An toàn    │
        │ Hỗ trợ → Bản đồ → Chỉ đường → Hoàn tất │
        └──────────────────┴─────────────────────┘
Thông báo · Đội cứu hộ · Tài khoản · Trợ lý AI
```

---

## 1. Bắt đầu dùng app

### Onboarding

<p>
<img src="../assets/images_app/onboarding_step1.jpg" width="48%" alt="Onboarding 1 — Gửi SOS khi gặp nguy hiểm" />
<img src="../assets/images_app/onboarding_step2.jpg" width="48%" alt="Onboarding 2 — Đội cứu hộ đến hỗ trợ" />
</p>
<p>
<img src="../assets/images_app/onboarding_step3.jpg" width="48%" alt="Onboarding 3 — Bạn an toàn" />
</p>

### Đăng nhập / Đăng ký

<p>
<img src="../assets/images_app/login.jpg" width="48%" alt="Đăng nhập" />
<img src="../assets/images_app/register.jpg" width="48%" alt="Đăng ký" />
</p>
<p>
<img src="../assets/images_app/verify_otp.jpg" width="48%" alt="Xác thực OTP" />
<img src="../assets/images_app/forget_password.jpg" width="48%" alt="Quên mật khẩu" />
</p>
<p>
<img src="../assets/images_app/create_new_password.jpg" width="48%" alt="Tạo mật khẩu mới" />
</p>

---

## 2. Dashboard — 5 tab

| Tab           | Chức năng                               |
| ------------- | --------------------------------------- |
| **Bản đồ**    | SOS quanh khu vực, thời tiết, định vị   |
| **Hoạt động** | Yêu cầu của bạn / nhiệm vụ đang nhận    |
| **Hỗ trợ**    | Danh sách SOS cần giúp (lọc loại, tỉnh) |
| **Tin tức**   | Thông báo + badge chưa đọc              |
| **Tài khoản** | Hồ sơ, đội, đổi mật khẩu                |

---

## 3. Người gặp sự cố — đăng SOS & nhận giúp

**Bước 1–2.** Chọn loại trên tab Hỗ trợ → điền form Gửi SOS (mô tả, vị trí, SĐT, ảnh)

<p>
<img src="../assets/images_app/ui_support_2.jpg" width="48%" alt="Hỗ trợ — chọn loại SOS" />
<img src="../assets/images_app/ui_support.jpg" width="48%" alt="Hỗ trợ — danh sách SOS" />
</p>
<p>
<img src="../assets/images_app/send_sos.jpg" width="48%" alt="Form gửi SOS" />
<img src="../assets/images_app/send_sos_2.jpg" width="48%" alt="Form gửi SOS đã điền" />
</p>

**Bước 3–4.** Theo dõi trên Hoạt động: Chờ nhận → Đang hỗ trợ → An toàn

<p>
<img src="../assets/images_app/activity_support_me.jpg" width="48%" alt="Yêu cầu đang chờ nhận" />
<img src="../assets/images_app/sos_received.jpg" width="48%" alt="Đã có đội nhận" />
</p>
<p>
<img src="../assets/images_app/your_sos.jpg" width="48%" alt="Yêu cầu của bạn" />
<img src="../assets/images_app/view_photo_full.jpg" width="48%" alt="Xem ảnh hiện trường" />
</p>

**Bước 5.** Chat với đội cứu hộ

<p>
<img src="../assets/images_app/chat.jpg" width="48%" alt="Chat SOS" />
<img src="../assets/images_app/chat_team.jpg" width="48%" alt="Chat với leader" />
</p>

---

## 4. Người / đội cứu hộ — tới giúp

**Bước 1–2.** Xem SOS cần hỗ trợ → Bản đồ / sự kiện quanh khu vực

<p>
<img src="../assets/images_app/ui_support.jpg" width="48%" alt="Danh sách SOS cần hỗ trợ" />
<img src="../assets/images_app/map.jpg" width="48%" alt="Bản đồ tổng quan" />
</p>
<p>
<img src="../assets/images_app/map_zoom.jpg" width="48%" alt="Zoom bản đồ" />
<img src="../assets/images_app/view_event_map.jpg" width="48%" alt="Sự kiện trên bản đồ" />
</p>

**Bước 3–4.** Chỉ đường tới hiện trường → Quản lý nhiệm vụ đang nhận

<p>
<img src="../assets/images_app/view_routes_event.jpg" width="48%" alt="Chỉ đường tới sự kiện" />
<img src="../assets/images_app/activity_receiving.jpg" width="48%" alt="Cứu trợ đang nhận" />
</p>

**Bước 5–6.** Chat phối hợp → Hoàn thành cứu hộ

<p>
<img src="../assets/images_app/chat_team.jpg" width="48%" alt="Chat phối hợp" />
<img src="../assets/images_app/rescue_complete.jpg" width="48%" alt="Cứu trợ đã hoàn thành" />
</p>

---

## 5. Thông báo

Badge đỏ trên tab **Tin tức** = số chưa đọc. Tap (trong app / FCM) → điều hướng + đánh dấu đã đọc.

<p>
<img src="../assets/images_app/notification.jpg" width="48%" alt="Thông báo ứng dụng" />
<img src="../assets/images_app/notification_2.jpg" width="48%" alt="Thông báo hệ thống" />
</p>

---

## 6. Đội cứu hộ

Danh sách đội → chi tiết / thông tin → xin gia nhập → thành viên (Leader)

<p>
<img src="../assets/images_app/view_list_team.jpg" width="48%" alt="Danh sách đội" />
<img src="../assets/images_app/list_team_details.jpg" width="48%" alt="Chi tiết đội" />
</p>
<p>
<img src="../assets/images_app/view_info_team.jpg" width="48%" alt="Thông tin đội" />
<img src="../assets/images_app/list_request_team.jpg" width="48%" alt="Yêu cầu tham gia" />
</p>
<p>
<img src="../assets/images_app/view_member_team.jpg" width="48%" alt="Thành viên đội" />
</p>

---

## 7. Tài khoản & Trợ lý AI

<p>
<img src="../assets/images_app/profile.jpg" width="48%" alt="Tài khoản" />
<img src="../assets/images_app/information_you.jpg" width="48%" alt="Thông tin cá nhân" />
</p>
<p>
<img src="../assets/images_app/change_password.jpg" width="48%" alt="Đổi mật khẩu" />
<img src="../assets/images_app/AI_CHAT.jpg" width="48%" alt="Trợ lý AI" />
</p>

---

## 8. Tóm tắt nhanh

| Mục tiêu            | Chức năng                                   |
| ------------------- | ------------------------------------------- |
| Đăng sự cố          | Gửi SOS (loại / mô tả / vị trí / SĐT / ảnh) |
| Người khác tới giúp | Hỗ trợ + Bản đồ + chỉ đường                 |
| Theo dõi tiến trình | Hoạt động (của bạn / đang nhận)             |
| Phối hợp realtime   | Chat SOS + Thông báo FCM                    |
| Kết thúc an toàn    | Báo đã an toàn / hoàn thành cứu hộ          |
| Tổ chức lực lượng   | Đội cứu hộ, xin gia nhập, thành viên        |

**Dev:** `sos_connect` · OSM + OSRM · FCM + Socket.IO · Chat theo `sosId` · role guest / volunteer / leader

_Ảnh từ `assets/images_app/` — screenshot UI thực tế._
