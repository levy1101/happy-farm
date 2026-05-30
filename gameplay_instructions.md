# Hướng Dẫn Cách Chơi & Hệ Thống Nút Tương Tác (Godot 4 - Croptails)

Chào mừng bạn đến với tựa game nông trại **Croptails** được xây dựng trên động cơ game **Godot 4**! Dưới đây là tài liệu chi tiết hướng dẫn cách điều khiển nhân vật, sử dụng công cụ nông nghiệp và các tương tác hệ thống trong game.

---

## 🏃‍♂️ 1. Phím Di Chuyển (Movement Controls)

Để điều hướng nhân vật chính đi vòng quanh nông trại và trong nhà, bạn sử dụng các phím bấm tiêu chuẩn:

*   **`W`**: Đi thẳng lên trên (Walk Up)
*   **`S`**: Đi lùi xuống dưới (Walk Down)
*   **`A`**: Sang bên trái (Walk Left)
*   **`D`**: Sang bên phải (Walk Right)
*   **`Shift (Left Shift)`**: Nhấn giữ khi di chuyển để **Chạy nhanh / Tăng tốc** (Sprint).

---

## 🛠️ 2. Hệ Thống Nút Công Cụ & Tương Tác Nông Nghiệp (Actions & Tools)

Các tương tác cuốc đất, tưới nước, chặt cây và khai thác tài nguyên được thực hiện chủ yếu bằng sự kết hợp giữa bàn phím và chuột:

*   **`Chuột Trái (Left Click)`** (`hit` action):
    *   **Sử dụng công cụ đang cầm**: Vung Rìu để chặt cây, vung Cuốc để đào đất tơi xốp, dùng Bình để tưới nước cho cây trồng.
    *   **Gieo hạt**: Click chuột trái vào ô đất đã cuốc để gieo hạt giống (ngô, cà chua).
*   **`Chuột Phải (Right Click)`** (`release_tool` action):
    *   Hủy chọn / Buông công cụ hiện tại đang cầm để rảnh tay (Fist/Hand state).
*   **`Ctrl + Chuột Trái`** (`remove_hit` action):
    *   Đào xới / Dọn dẹp ô đất hoặc phá bỏ cây trồng bị hỏng.

---

## 💬 3. Hội Thoại & Tương Tác Thế Giới (Interactions & Dialogues)

*   **Phím `E`** (`show_dialogue` action):
    *   **Nói chuyện với NPC**: Nhấn phím `E` khi đứng gần NPC Hướng dẫn (Guide NPC) để mở hộp thoại kịch bản tương tác.
    *   **Mở Rương (Chest)**: Nhấn phím `E` khi đứng cạnh rương kho báu gỗ để mở nắp rương và lấy vật phẩm.

---

## 📂 4. Trình Đơn & Lưu Trữ Hệ Thống (Menu & Save)

*   **Phím `Esc (Escape)`** (`game_menu` action):
    *   Mở bảng Trình Đơn trò chơi (Game Menu) chứa ba lô đồ dùng (Inventory) và các tùy chỉnh hệ thống.
*   **Phím `P`** (`save_game` action):
    *   **Lưu game tức thời (Quick Save)**: Lưu lại toàn bộ dữ liệu vị trí nhân vật, trạng thái phát triển của cây cối và số lượng củi đá đã nhặt vào bộ nhớ máy để không bị mất khi thoát game.

---

## 🚜 5. Vòng Lặp Trải Nghiệm Game (Gameplay Loop Tutorial)

Khi mới bắt đầu chơi, bạn có thể thực hành các bước nông nghiệp cơ bản sau để làm quen:

1.  **Chặt cây thu hoạch gỗ**: Cầm Rìu (Axe), tiến đến gần một cây sồi lớn và **Click Chuột Trái** liên tiếp. Cây sẽ rung lá, đổ gục và rơi ra các khúc gỗ (`Wood Logs`). Tiến đến gần để nhặt chúng vào túi đồ.
2.  **Khai mỏ lấy đá**: Cầm Búa (Hammer), tiến đến mỏ đá và **Click Chuột Trái** để đập vỡ đá thu thập nguyên liệu đá xây dựng (`Stone`).
3.  **Cuốc đất**: Cầm Cuốc nông nghiệp (Hoe), di chuyển đến thảm cỏ và **Click Chuột Trái** để cuốc thành các luống đất nâu tơi xốp (`Tilled Dirt`).
4.  **Tưới nước**: Cầm Bình tưới (Watering Can), di chuyển đến mép nước sông và **Click Chuột Trái** để múc đầy nước. Sau đó quay lại ô đất đã cuốc và **Click Chuột Trái** để tưới ẩm đất.
5.  **Gieo hạt & Thu hoạch**: Chọn hạt giống trong túi đồ, gieo xuống luống đất ẩm, tưới nước hàng ngày. Cây sẽ lớn dần qua 5 giai đoạn từ hạt mầm đến khi chín đỏ (Cà chua/Ngô) để bạn thu hoạch!
