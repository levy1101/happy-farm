# Sprout Valley - Player SpriteSheet Design Guide

This guide explains the spacing, dimensions, and layout rules for creating custom player animations that fit perfectly with the game's rendering engine.

---

## 📐 Spacing & Dimension Rules

The game uses Flame's `SpriteSheet` class to cut sprite files based on the following configurations:

* **Frame Width (Chiều rộng khung)**: `48 pixels`
* **Frame Height (Chiều cao khung)**: `48 pixels`
* **Inner Spacing (Khoảng cách giữa các khung)**: `1 pixel` (padding/gap between frames)
* **Outer Margin (Lề ngoài cùng)**: `0 pixels` (no border spacing on the edges)

---

## 📏 Dimension Formula

For an animation sequence containing **$N$ frames**, the total dimensions of your image asset must be:

* **Total Width**: $(48 \times N) + (N - 1)$ pixels
* **Total Height**: $48$ pixels

---

## 💡 Example: Designing an 8-Frame Animation Sheet ($N = 8$)

If you are designing a custom character action with exactly **8 frames**, your image dimensions and grid layout will look like this:

### 1. Dimension Calculation
* **Total Width**: $(48 \times 8) + 7 = 384 + 7 = \mathbf{391 \text{ pixels}}$
* **Total Height**: $\mathbf{48 \text{ pixels}}$

### 2. Grid Placement Map (Pixels)

```
|--- Frame 1 ---| S |--- Frame 2 ---| S |--- Frame 3 ---| ... |--- Frame 8 ---|
[ 0px to 48px   ] 1px [49px to 97px  ] 1px [98px to 146px ] ... [343px to 391px]
```

* **Frame 1**: `0px` to `48px`
* **Spacing 1**: `48px` to `49px` (1 pixel gap)
* **Frame 2**: `49px` to `97px`
* **Spacing 2**: `97px` to `98px` (1 pixel gap)
* **Frame 3**: `98px` to `146px`
* **Spacing 3**: `146px` to `147px` (1 pixel gap)
* **Frame 4**: `147px` to `195px`
* **Spacing 4**: `195px` to `196px` (1 pixel gap)
* **Frame 5**: `196px` to `244px`
* **Spacing 5**: `244px` to `245px` (1 pixel gap)
* **Frame 6**: `245px` to `293px`
* **Spacing 6**: `293px` to `294px` (1 pixel gap)
* **Frame 7**: `294px` to `342px`
* **Spacing 7**: `342px` to `343px` (1 pixel gap)
* **Frame 8**: `343px` to `391px` (end of image)

---

## 🎨 Design Tips

1. Keep your character centered inside each `48x48 px` block so they don't jump or jitter during movements.
2. Ensure the background of your `.png` file is completely transparent.
3. Keep the 1px divider lines fully transparent to avoid drawing clipping lines.
