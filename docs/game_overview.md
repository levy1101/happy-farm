# Sprout Valley - Game Overview & Controls

This document provides a summary of the current features, UI elements, and input controls implemented in the **Sprout Valley** (Happy Farm) codebase.

---

## 1. Implemented Features in `lib/`

- **Game Engine & Rendering**: Built using the **Flame engine** for Flutter. Tiled maps (`farm.tmx` and `house.tmx`) are pre-rendered and loaded using high-performance batch image compilers (`ImageBatchCompiler`).
- **Multiple Worlds/Scenes**:
  - **Farm World**: Outdoor map featuring animated water tiles, trees, the player's house exterior, and physical boundary collisions.
  - **House World**: Indoor area containing furniture, indoor walls, and a doorway path back to the farm.
- **Scene Routing/Switching**: Real-time scene transition when the player enters door boundary areas (`IntersectionBlock`), routing them dynamically between the farm and the house.
- **Player States & Animations**:
  - Supported States: `idle`, `walk`, `chopping`, `tiling`, and `watering`.
  - Fully animated with specific sprite sheets for all 4 directions (Up, Down, Left, Right).
- **Y-Sorting Render Priority**: Dynamic priority calculation for trees and characters, ensuring the tree is layered correctly depending on whether the player is standing in front of or behind it (`calculateTreeRender`).
- **Interactive Action Hitboxes**: Temporary hitboxes are generated and disposed dynamically during actions (e.g., chopping) depending on the direction the player is facing.

---

## 2. Game UI & Buttons

- **Toolbox Hotbar Panel (Bottom Overlay)**:
  - Rendered at the bottom center of the screen containing exactly **10 slots** for selecting various items/tools.
  - Highlighted with a selection indicator frame (`toolbox_selector_overlays.png`) that slides smoothly to the active tool slot.

---

## 3. Game Controls

The game utilizes keyboard inputs for player movement and actions:

### Movement
- **`W`**: Walk Up
- **`S`**: Walk Down
- **`A`**: Walk Left
- **`D`**: Walk Right

### Action
- **`K`**: Chop. Performs the chopping action, triggering the corresponding character animation and generating a temporary action hitbox in front of the character.

### Hotbar Selection
- **`Q`**: Move the active slot selector to the **Left** (wraps around to the 10th slot if currently at the 1st slot).
- **`E`**: Move the active slot selector to the **Right** (wraps around to the 1st slot if currently at the 10th slot).

### World Transition
- **Enter House**: Walk directly into the door of the house in the Farm scene.
- **Exit House**: Walk downwards through the doorway at the bottom of the House scene.
