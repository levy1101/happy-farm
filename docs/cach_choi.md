# Hướng Dẫn Cách Chơi & Vai Trò Tài Nguyên (Croptails - Godot 4)

Chào mừng bạn đến với tựa game nông trại **Croptails** trên Godot 4! Dưới đây là hướng dẫn chơi game chi tiết, thực tế và vai trò của từng loại tài nguyên trong phiên bản hiện tại.

---

## 🎮 1. Hướng Dẫn Cách Chơi (Gameplay Guide)

### 🏃 Di chuyển nhân vật
* Sử dụng các phím **`W`**, **`A`**, **`S`**, **`D`** để đi lại trên nông trại.
* Giữ phím **`Shift`** để chạy nhanh hơn (Sprint).

### 🛠️ Sử dụng Công cụ & Hành động
* **Mở khóa công cụ**: Toàn bộ công cụ đã được **mở khóa sẵn** ngay khi bạn bắt đầu game ở thanh công cụ phía dưới màn hình.
* **Cuốc đất**: Chọn **Cuốc (Hoe)** $\rightarrow$ Quay mặt nhân vật về phía thảm cỏ xanh $\rightarrow$ **Click Chuột Trái** $\rightarrow$ Đất sẽ tự động tơi xốp lên (đất nâu).
* **Gieo hạt**: Chọn túi hạt giống **Ngô (Corn)** hoặc **Cà chua (Tomato)** $\rightarrow$ Đứng cạnh và hướng mặt vào ô đất nâu đã cuốc $\rightarrow$ **Click Chuột Trái** $\rightarrow$ Hạt mầm sẽ được gieo xuống đất. *(Lưu ý: Không thể gieo hạt lên cỏ chưa cuốc).*
* **Tưới nước**: Chọn **Bình tưới (Watering Can)** $\rightarrow$ Ra mép sông **Click Chuột Trái** để múc đầy nước $\rightarrow$ Đi tới chỗ cây trồng **Click Chuột Trái** để tưới ẩm.
* **Tua thời gian (Qua ngày mới)**: Để cây lớn lên, bạn cần qua ngày mới. Nhấp vào các nút điều khiển thời gian ở **góc trên bên phải màn hình** để tua nhanh thời gian hoặc chuyển sang ngày hôm sau. Đất sẽ khô đi và cây trồng sẽ lớn thêm 1 giai đoạn.
* **Thu hoạch**: Khi cây lớn hết cỡ (ra bắp Ngô vàng hoặc quả Cà chua đỏ), bạn chỉ cần **đi bộ đi đè lên cây** để tự động thu hoạch nông sản vào ba lô bên trái.

### 🐻 1.1. Ảnh Đại Diện Biểu Cảm Động (Emotes Panel - Góc Trên Cùng Bên Trái)
Ảnh đại diện hình chú gấu trắng Kitty ở góc trên cùng bên trái màn hình không chỉ để trang trí mà được lập trình các biểu cảm rất sinh động phản hồi lại hành động của bạn:
* **Khi rảnh rỗi (Idle)**: Chú gấu sẽ tự động hiển thị ngẫu nhiên 4 biểu cảm siêu đáng yêu sau mỗi khoảng thời gian ngắn:
  * Chớp mắt ngơ ngác (`emote_1_idle`).
  * Mỉm cười vui vẻ (`emote_2_smile`).
  * Vẫy vẫy đôi tai dễ thương (`emote_3_ear_wave`).
  * Nháy mắt tinh nghịch (`emote_4_blink`).
* **Khi có thu hoạch (`on_inventory_changed`)**: Bất cứ khi nào bạn thu thập được tài nguyên mới vào ba lô (nhặt gỗ, đập đá, thu hoạch ngô/cà chua/trứng/sữa), chú gấu sẽ ngay lập tức **nhảy biểu cảm cực kỳ phấn khích (`emote_excited`)** với đôi mắt lấp lánh để chúc mừng và cổ vũ tinh thần làm việc của bạn!

### 🧘 1.2. Chế Độ Tập Trung (Focus Mode — Forest App Style)
Khi bạn đi vào trong nhà và đứng gần chiếc giường, gợi ý phím **`K`** sẽ xuất hiện. Nhấn phím **`K`** để kích hoạt **Chế độ tập trung (Focus Mode)** toàn màn hình:
* **Hiệu ứng Zoom mượt mà**: Avatar chú gấu ở góc trái sẽ tự động phóng to lấp đầy màn hình trước khi chuyển sang giao diện tập trung chuyên nghiệp như ứng dụng Forest.
* **Thời gian thực tế**: Bạn chọn 1 trong 3 mốc thời gian (**25 phút**, **45 phút**, hoặc **60 phút**) và bấm **Start Growing** để gieo trồng cây mầm. Đồng hồ đếm ngược sẽ chạy theo giây thực tế.
* **Đồng bộ hóa thời gian game**: Để đảm bảo tính logic, **25 phút tập trung thời gian thực = 4 tiếng trôi qua trong nông trại**. Game sẽ tự động đẩy nhanh tốc độ vòng lặp ngày/đêm tương ứng với thời gian bạn tập trung!
* **Kết quả gieo trồng**:
  * **Hoàn thành**: Cây sẽ lớn dần qua 6 giai đoạn tuyệt đẹp từ hạt mầm bé xíu cho đến khi kết trái chín mọng!
  * **Bỏ cuộc (Abandon)**: Cây mầm sẽ héo úa và chết ngay lập tức.

## 🪵 2. Vai Trò Của Các Tài Nguyên Trong Game

Dưới đây là vai trò thực tế của từng loại tài nguyên hiển thị ở bảng ba lô bên trái màn hình. Phiên bản hiện tại phân tách rõ ràng giữa tài nguyên **có chức năng** và tài nguyên **chỉ để trang trí/chưa có chức năng**:

### 🌟 Nhóm Tài Nguyên Có Chức Năng (Active Gameplay)

1. **Ngô (Corn)**:
   * **Cách có**: Trồng bằng hạt giống ngô và tưới nước qua các ngày để thu hoạch.
   * **Chức năng**: Dùng làm **Thức ăn cho Gà**. Mang Ngô lại gần chiếc rương gỗ (máng ăn) trong chuồng gà, bấm phím **`E`** và chọn **`yes`** để cho gà ăn và đổi lấy **Trứng**.

2. **Cà chua (Tomato)**:
   * **Cách có**: Trồng bằng hạt giống cà chua và tưới nước qua các ngày để thu hoạch.
   * **Chức năng**: Dùng làm **Thức ăn cho Bò**. Mang Cà chua lại gần chiếc rương gỗ (máng ăn) trong chuồng bò, bấm phím **`E`** và chọn **`yes`** để cho bò ăn và đổi lấy **Sữa**.

3. **Trứng gà (Egg) & Sữa (Milk)**:
   * **Cách có**: Thu được từ việc cho Gà ăn (Ngô) và cho Bò ăn (Cà chua).
   * **Chức năng**: Đây là **sản phẩm cuối cùng (End-game reward)** của chuỗi hoạt động nông trại, đóng vai trò là "điểm số thành tựu" chứng minh bạn đã hoàn thành xuất sắc toàn bộ quy trình trồng trọt và chăn nuôi.

---

### 🎨 Nhóm Tài Nguyên Chỉ Để Trang Trí / Chưa Có Chức Năng (Decorative Only)

Các tài nguyên dưới đây hiện tại **chưa được lập trình tính năng sử dụng** (không dùng để chế tạo hay nâng cấp được gì) và **chỉ mang tính chất trang trí**, tạo cảm giác phong phú cho thế giới nông trại:

1. **Gỗ (Log)**:
   * **Cách có**: Dùng **Rìu (Axe)** chặt cây sồi lớn trên bản đồ để nhặt gỗ rơi ra (hoặc nói chuyện với NPC Gấu Trắng để nhận 10 cái).
   * **Chức năng**: **Chỉ dùng để trang trí / Tích lũy chơi cho vui**. Chưa có chức năng xây nhà hay chế tạo trong phiên bản này.

2. **Đá (Stone)**:
   * **Cách có**: Dùng **Búa (Hammer)** đập các mỏ đá trên bản đồ để nhặt đá rơi ra (hoặc nói chuyện với NPC Gấu Trắng để nhận 10 cái).
   * **Chức năng**: **Chỉ dùng để trang trí / Tích lũy chơi cho vui**. Chưa có chức năng chế tạo hay xây hàng rào trong phiên bản này.
