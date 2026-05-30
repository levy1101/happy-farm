# Tài liệu Đặc tả Thiết kế & Vẽ lại Tài nguyên (Asset Specifications - Godot 4)

Chào bạn! Dưới đây là tài liệu đặc tả tài nguyên hình ảnh được cấu trúc lại **chính xác 100% theo mã nguồn Godot 4 (Croptails)** mà bạn vừa tải về. 

Trong Godot, thay vì chia nhỏ thành nhiều file lẻ, các hoạt ảnh nhân vật và gạch địa hình được gom nhóm lại thành các tệp ảnh lớn (Consolidated Spritesheets). Việc vẽ lại chuẩn xác kích thước và thứ tự dòng dưới đây sẽ giúp bạn chỉ cần **ghi đè tệp hình ảnh mới lên** là game tự nhận diện hoàn hảo!

---

## 📐 1. Quy chuẩn chung (Global Standards)

*   **Định dạng**: Tất cả tệp tin phải ở định dạng `.png` nền trong suốt (Transparent background).
*   **Kích thước Lưới cơ sở (Base Grid)**: **16x16 pixel** (Mọi ô đất, gạch nước, bàn ghế đều dựa trên lưới này).
*   **Origin (Trục tọa độ)**: Godot sử dụng hệ tọa độ chuẩn, trục Y hướng xuống dưới.

---

## 🏃‍♂️ 2. Hoạt ảnh Nhân vật & Thú nuôi (Characters & Animals)

Tất cả hoạt ảnh nhân vật nằm tập trung trong 2 tệp ảnh lớn dưới dạng lưới vuông **48x48 pixel** cho mỗi khung hình (frame).

### A. Tệp di chuyển: `Basic_Charakter_Spritesheet.png`
*   **Kích thước ô đơn**: 48x48 px
*   **Quy cách**: 4 cột (4 Khung hình nằm ngang) x 8 dòng (Tổng kích thước: **192x384 px**).
*   **Phân tích Chi tiết Lưới Khung Hình (Từ Trái sang Phải, Trên xuống Dưới)**:

    #### 🔴 DÒNG 0 (Y: 0px đến 47px) - HƯỚNG XUỐNG (DOWN)
    *   **Cột 0** (X: 0 - 47 px): **Đứng im 1 (Idle Down 1)** - Tư thế đứng thẳng nhìn về phía trước.
    *   **Cột 1** (X: 48 - 95 px): **Đứng im 2 (Idle Down 2)** - Tư thế thở nhẹ hoặc cử động nháy mắt/tóc.
    *   **Cột 2** (X: 96 - 143 px): **Bước đi 1 (Walk Down 1)** - Chân trái bước lên trước, tay phải vung.
    *   **Cột 3** (X: 144 - 191 px): **Bước đi 2 (Walk Down 2)** - Chân phải bước lên trước, tay trái vung.

    #### 🟢 DÒNG 1 (Y: 48px đến 95px) - HƯỚNG LÊN (UP)
    *   **Cột 0** (X: 0 - 47 px): **Đứng im 1 (Idle Up 1)** - Tư thế đứng thẳng quay lưng lại.
    *   **Cột 1** (X: 48 - 95 px): **Đứng im 2 (Idle Up 2)** - Tư thế thở nhẹ quay lưng lại.
    *   **Cột 2** (X: 96 - 143 px): **Bước đi 1 (Walk Up 1)** - Chân trái bước lên trước quay lưng lại.
    *   **Cột 3** (X: 144 - 191 px): **Bước đi 2 (Walk Up 2)** - Chân phải bước lên trước quay lưng lại.

    #### 🔵 DÒNG 2 (Y: 96px đến 143px) - QUAY TRÁI (LEFT)
    *   **Cột 0** (X: 0 - 47 px): **Đứng im 1 (Idle Left 1)** - Đứng yên nhìn nghiêng bên trái.
    *   **Cột 1** (X: 48 - 95 px): **Đứng im 2 (Idle Left 2)** - Thở nhẹ nhìn nghiêng bên trái.
    *   **Cột 2** (X: 96 - 143 px): **Bước đi 1 (Walk Left 1)** - Chân trái bước lên hướng bên trái.
    *   **Cột 3** (X: 144 - 191 px): **Bước đi 2 (Walk Left 2)** - Chân phải bước lên hướng bên trái.

    #### 🟡 DÒNG 3 (Y: 144px đến 191px) - QUAY PHẢI (RIGHT)
    *   **Cột 0** (X: 0 - 47 px): **Đứng im 1 (Idle Right 1)** - Đứng yên nhìn nghiêng bên phải.
    *   **Cột 1** (X: 48 - 95 px): **Đứng im 2 (Idle Right 2)** - Thở nhẹ nhìn nghiêng bên phải.
    *   **Cột 2** (X: 96 - 143 px): **Bước đi 1 (Walk Right 1)** - Chân trái bước lên hướng bên phải.
    *   **Cột 3** (X: 144 - 191 px): **Bước đi 2 (Walk Right 2)** - Chân phải bước lên hướng bên phải.

    *(Lưu ý: Các dòng từ Dòng 4 đến Dòng 7 là phần lặp lại hoạt ảnh di chuyển vung tay vung chân ở cường độ chạy/đi nhanh hơn hoặc các biến thể chuyển động khác)*

*   **⚠️ Lưu ý quan trọng khi vẽ (Dành cho AI/Họa sĩ)**:
    1. **Đặt nhân vật ở tâm ô (Centering)**: Luôn đặt tọa độ tâm chân nhân vật ở chính giữa ô 48x48 px để hoạt ảnh di chuyển mượt mà, không bị giật hoặc trượt chân (jitter) trong game.
    2. **Đồng bộ bóng đổ (Shadow)**: Thêm bóng đổ tròn mờ nhẹ ở phần chân nhân vật đồng bộ trên tất cả các khung hình.
    3. **Không làm mượt nét (Pixel Perfect)**: Giữ nguyên nét Pixel Art sắc nét (Clean outline), xuất ảnh PNG nền trong suốt 100%.

*   **Kích thước ô đơn**: 48x48 px
*   **Quy cách**: 2 cột (2 Khung hình nằm ngang) x 24 dòng (Tổng kích thước: **96x1152 px**).
*   **Thứ tự các dòng hành động cốt lõi**:
    *   `Dòng 0 - 3`: Vung Rìu chặt gỗ (Chop) [Hướng Xuống, Lên, Trái, Phải - mỗi hướng 2 frames]
    *   `Dòng 4 - 7`: Vung Cuốc cuốc đất (Hoe) [Hướng Xuống, Lên, Trái, Phải - mỗi hướng 2 frames]
    *   `Dòng 8 - 11`: Tưới nước (Watering) [Hướng Xuống, Lên, Trái, Phải - mỗi hướng 2 frames]
    *   `Dòng 12 - 15`: Cầm búa đập đá (Hammer) [Hướng Xuống, Lên, Trái, Phải - mỗi hướng 2 frames]
    *   `Dòng 16 - 19`: Vung cuốc nông nghiệp nâng cao [Hướng Xuống, Lên, Trái, Phải]
    *   `Dòng 20 - 23`: Hoạt ảnh gieo hạt giống (Sowing) [Hướng Xuống, Lên, Trái, Phải]

### C. Động vật: `Free_Chicken_Sprites.png` & `Free_Cow_Sprites.png`
*   **Gà (`Free_Chicken_Sprites.png`)**: Kích thước ô đơn 16x16 px. Hoạt ảnh gà đi bộ, mổ thóc nằm trên các dòng ngang.
*   **Bò (`Free_Cow_Sprites.png`)**: Kích thước ô đơn 32x32 px. Hoạt ảnh bò đứng ăn cỏ, đi bộ thong thả.

---

## 🧱 3. Bộ Gạch Địa Hình & Bản Đồ (Tilesets - Lưới 16x16 px)

Nằm trong thư mục [Croptails/Assets/game/Tilesets/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/game/Tilesets/). Đây là các tấm địa hình lớn dùng tính năng **Terrain Auto-tile** (Bitmask 2x2 hoặc 3x3) của Godot:

*   **`Grass.png`**: Gạch thảm cỏ xanh, các ô chuyển tiếp viền cỏ góc tròn.
*   **`Water.png`**: Gạch nước tĩnh biển/sông và các họa tiết sóng lăn tăn nhấp nhô.
*   **`Hills.png`**: Khối bờ đá cao, vách núi, bờ vực đứng.
*   **`Tilled_Dirt.png` & `Tilled_Dirt_Wide_v2.png`**: Các ô đất tơi xốp sau khi cuốc để trồng cây (chứa đủ 16 ô liên kết góc cạnh gieo hạt).
*   **`Fences.png`**: Hàng rào gỗ, rào đá tự động nối mạch khi đặt cạnh nhau.
*   **`Wooden_House_Walls_Tilset.png` & `Wooden_House_Roof_Tilset.png`**: Các mảnh ghép lắp ráp tường gỗ, mái ngói nghiêng, cửa sổ để dựng lên ngôi nhà.

---

## 🌻 4. Cây Cối, Cây Trồng & Vật Thể (Objects - Lưới 16x16 px)

Nằm trong thư mục [Croptails/Assets/game/Objects/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/game/Objects/).

*   **`Basic_Grass_Biom_things.png`**: Tệp tổng hợp thế giới tự nhiên bên ngoài:
    *   **Cây xanh (Oak Tree)**: Cần vẽ các trạng thái Cây lớn (gồm Thân gỗ, Tán lá xanh xòe rộng), Cây nhỏ, Gốc cây bị đứt (Stump), khúc củi lăn lóc.
    *   **Đá khai thác (Rock)**: Mỏ đá lớn, đá xám nhỏ có thể đập vỡ.
    *   **Đồ trang trí**: Các thảm hoa dại sắc màu (đỏ, vàng, tím), cây nấm đỏ, bụi cỏ dại nhỏ.
*   **`Basic_Plants.png`**: Vòng đời của cây trồng (Cà chua, Ngô...):
    *   Dòng 0: Cây Ngô (Từ Hạt mầm $\rightarrow$ Cây non $\rightarrow$ Đơm hoa $\rightarrow$ Trái ngô chín vàng $\rightarrow$ Héo).
    *   Dòng 1: Cây Cà chua (Hạt mầm $\rightarrow$ Mầm cây $\rightarrow$ Cây lớn $\rightarrow$ Ra quả xanh $\rightarrow$ Cà chua chín đỏ $\rightarrow$ Héo).
*   **`Basic_Furniture.png`**: Đồ đạc trong nhà:
    *   Giường ngủ đơn có chăn nệm, tủ kéo bằng gỗ, bàn tròn ăn uống, thảm vuông phòng khách.
*   **`Chest.png`**: Rương báu vật hoạt ảnh đóng/mở nắp khi tương tác.

---

## 🎒 5. Vật Phẩm & Giao Diện (Items & UI - Lưới 16x16 px)

*   **`Basic_tools_and_meterials.png`**: Biểu tượng hiển thị trong túi đồ và bay ra khi thu hoạch:
    *   Cây rìu sắt, chiếc cuốc đất, xô nước, khúc gỗ vuông, viên đá xám, hạt giống ngô/cà chua, nông sản đã chín để bán.
*   **Giao diện túi đồ (UI)**: Nằm trong [Assets/UI/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/UI/). Bao gồm các khung gỗ, bảng menu, ô chứa đồ (Slots) bo tròn góc mang đậm phong cách pixel cổ điển.

---

## 📂 6. Đường dẫn thư mục xuất tệp trong Godot

Khi bạn vẽ xong trên **Aseprite**, hãy lưu đè file hình ảnh `.png` mới trực tiếp vào đường dẫn sau trong dự án Godot:

*   **Nhân vật & Công cụ**: [Croptails/Assets/game/Characters/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/game/Characters/)
*   **Bộ gạch Tileset địa hình**: [Croptails/Assets/game/Tilesets/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/game/Tilesets/)
*   **Cây cối, Nội thất, Cây trồng**: [Croptails/Assets/game/Objects/](file:///home/enable/repos/android/happy_farm/Croptails/Assets/game/Objects/)

---

## 📦 7. Danh mục đầy đủ các file PNG trong repository

Dưới đây là bản kê tự động (tổng hợp các file `.png` hiện có) theo thư mục chính trong dự án. Nếu bạn muốn thêm mô tả chi tiết cho từng tệp (kích thước ô, thứ tự dòng, mục đích), tôi có thể mở rộng từng mục theo yêu cầu.

### Croptails/Assets/game/Characters
- `Croptails/Assets/game/Characters/Basic_Charakter_Actions.png` — spritesheet hoạt động nhân vật (đập/chop/hoe/water/hammer/sow; 48x48 frames)
- `Croptails/Assets/game/Characters/Basic_Charakter_Spritesheet.png` — spritesheet di chuyển/idle (walk/idle 4 hướng; 48x48 frames)
- `Croptails/Assets/game/Characters/Free_Chicken_Sprites.png` — spritesheet gà (chân, mổ; 16x16 frames)
- `Croptails/Assets/game/Characters/Free_Cow_Sprites.png` — spritesheet bò (đứng/đi; 32x32 frames)
- `Croptails/Assets/game/Characters/Egg_And_Nest.png` — icon vật phẩm/tài nguyên: trứng và tổ
- `Croptails/Assets/game/Characters/Tools.png` — biểu tượng công cụ/khung công cụ (rìu, cuốc, bình tưới)

### Croptails/Assets/game/Objects
- `Croptails/Assets/game/Objects/Basic_Grass_Biom_things.png` — cây cối, đá, vật trang trí thế giới (trees, stumps, rocks)
- `Croptails/Assets/game/Objects/Basic_Plants.png` — spritesheet vòng đời cây trồng (ngô, cà chua: nhiều giai đoạn growth)
- `Croptails/Assets/game/Objects/Basic_Furniture.png` — đồ nội thất trong nhà (giường, bàn, tủ, thảm)
- `Croptails/Assets/game/Objects/Basic_tools_and_meterials.png` — biểu tượng công cụ & nguyên liệu (rìu/cuốc/xô/wood/stone/seed)
- `Croptails/Assets/game/Objects/Chest.png` — rương (animation đóng/mở)
- `Croptails/Assets/game/Objects/Egg_item.png` — icon/ảnh item trứng
- `Croptails/Assets/game/Objects/Free_Chicken_House.png` — chuồng gà (object đặt trên map)
- `Croptails/Assets/game/Objects/Paths.png` — tiles/tileset đường đi
- `Croptails/Assets/game/Objects/Simple_Milk_and_grass_item.png` — biểu tượng sữa & cỏ (items)
- `Croptails/Assets/game/Objects/Wood_Bridge.png` — cây cầu gỗ (object/tiles)

### Croptails/Assets/game/Tilesets
- `Croptails/Assets/game/Tilesets/Bitmask_references 1.png` — tham chiếu bitmask cho auto-tiling (hướng dẫn sắp xếp tiles)
- `Croptails/Assets/game/Tilesets/Bitmask_references 2.png` — tham chiếu bitmask bổ sung
- `Croptails/Assets/game/Tilesets/Doors.png` — tiles cửa/khung cửa
- `Croptails/Assets/game/Tilesets/Fences.png` — tiles hàng rào (auto-connect)
- `Croptails/Assets/game/Tilesets/Grass.png` — tiles thảm cỏ và chuyển tiếp viền cỏ
- `Croptails/Assets/game/Tilesets/Hills.png` — tiles địa hình đồi/vách đá
- `Croptails/Assets/game/Tilesets/Tilled_Dirt.png` — tiles đất đã cuốc (tilling) cho gieo hạt
- `Croptails/Assets/game/Tilesets/Tilled_Dirt_Wide_v2.png` — phiên bản rộng của tiles đất đã cuốc
- `Croptails/Assets/game/Tilesets/Water.png` — tiles nước (sông/hồ)
- `Croptails/Assets/game/Tilesets/Wooden_House_Roof_Tilset.png` — tiles mái nhà gỗ
- `Croptails/Assets/game/Tilesets/Wooden_House_Walls_Tilset.png` — tiles tường nhà gỗ

### Croptails/Assets/UI
- `Croptails/Assets/UI/Sprite sheet for Basic Pack.png` — sprite sheet UI chung (icons, frames dùng cho menu)
- `Croptails/Assets/UI/Setting menu.png` — background/khung cho menu settings
- `Croptails/Assets/UI/UI Big Play Button.png` — nút Play lớn (main menu)
- `Croptails/Assets/UI/UI Settings Buttons.png` — bộ nút settings (icons cho các tùy chọn)
- `Croptails/Assets/UI/Icons/All Icons.png` — sheet tất cả icon UI (inventory/action icons)
- `Croptails/Assets/UI/Icons/white icons.png` — sheet icon trắng đơn sắc (overlay/templated icons)
- `Croptails/Assets/UI/Icons/special icons/Special Icons.png` — biểu tượng đặc biệt (shop, quest, v.v.)
- `Croptails/Assets/UI/Icons/special icons/Small Happines-Sadness icons.png` — icon trạng thái cảm xúc nhỏ
- `Croptails/Assets/UI/buttons/Small Square Buttons.png` — bộ nút vuông nhỏ (menu/inventory)
- `Croptails/Assets/UI/buttons/Square Buttons 19x26.png` — nút vuông 19x26
- `Croptails/Assets/UI/buttons/Square Buttons 26x19.png` — nút vuông 26x19
- `Croptails/Assets/UI/buttons/Square Buttons 26x26.png` — nút vuông 26x26
- `Croptails/Assets/UI/Dialouge UI/dialog box.png` — dialog box (đóng/mở/khung thoại)
- `Croptails/Assets/UI/Dialouge UI/dialog box big.png` — version lớn của dialog box
- `Croptails/Assets/UI/Dialouge UI/dialog box medium.png` — version vừa của dialog box
- `Croptails/Assets/UI/Dialouge UI/dialog box small.png` — version nhỏ của dialog box
- `Croptails/Assets/UI/Dialouge UI/dialog box character finished talking click to continue indicator - spritesheet .png` — indicator spritesheet (bấm tiếp tục)
- `Croptails/Assets/UI/Dialouge UI/Emotes/Teemo Basic emote animations sprite sheet.png` — emote spritesheet cho dialog
- `Croptails/Assets/UI/Mouse sprites/Catpaw holding Mouse icon.png` — con trỏ chuột: bàn tay cầm
- `Croptails/Assets/UI/Mouse sprites/Catpaw pointing Mouse icon.png` — con trỏ chuột: chỉ
- `Croptails/Assets/UI/Mouse sprites/Catpaw Mouse icon.png` — con trỏ mặc định (catpaw)
- `Croptails/Assets/UI/Mouse sprites/Triangle Mouse icon 1.png` — con trỏ tam giác (var 1)
- `Croptails/Assets/UI/Mouse sprites/Triangle Mouse icon 2.png` — con trỏ tam giác (var 2)
- `Croptails/Assets/UI/Mouse sprites/Triangle Mouse icon 3.png` — con trỏ tam giác (var 3)

### Croptails/Assets/font (bao gồm GameBoy subfolder)
- `Croptails/Assets/font/ZX Palm.png` — bitmap font / font sprite used in UI
- `Croptails/Assets/font/ZX Palm Bold.png` — đậm của bitmap font
- `Croptails/Assets/font/GameBoy/ZX Palm.png` — phiên bản font phong cách GameBoy
- `Croptails/Assets/font/GameBoy/ZX Palm-var.png` — biến thể font GameBoy
- `Croptails/Assets/font/GameBoy/ZX Palm Bold.png` — bold GameBoy font
- `Croptails/Assets/font/GameBoy/ZX Palm Bold-var.png` — bold variant
- `Croptails/Assets/font/GameBoy/ZX Palm Bold-dark.png` — dark variant
- `Croptails/Assets/font/GameBoy/ZX Palm-dark.png` — dark variant regular

---

### Lệnh shell để tìm tất cả file PNG trong workspace

Bạn có thể chạy lệnh sau trong thư mục gốc của dự án để liệt kê tất cả file `.png` (không phân biệt chữ hoa/thường):

```
find . -type f -iname "*.png"
```

Nếu bạn dùng `fd` (nhanh hơn):

```
fd -e png
```

---

Nếu muốn, tôi sẽ mở rộng mỗi mục trên bằng kích thước ô (tile/frame size) và đề xuất tên file chuẩn cho việc vẽ đè (overwrite) — muốn bắt đầu từ thư mục nào trước? 
