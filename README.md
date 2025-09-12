# 🧩 Morpiony

Morpiony is a game built with **Godot**, inspired by the classic tic-tac-toe but on a much bigger scale!

## 🎯 Goal of the Game
The objective is similar to traditional tic-tac-toe: align **3 of your symbols** (horizontally, vertically, or diagonally) to win.  
The twist? You’re playing on a **big tic-tac-toe board** made of several **small tic-tac-toe boards**.

### How it works
- Each cell of the big board is actually a **small tic-tac-toe board**.  
- To claim a cell in the big board, you must win the corresponding small board.  
- The key rule:  
  - When you play in a cell of a small board, your move dictates **where your opponent must play next** on the big board.  
  - Example: if you place your symbol in the top-left cell of a small board, your opponent has to play in the top-left small board of the big board.  
  - If the target small board is already won by someone, then your opponent is free to play **anywhere**.  

## 🚀 Technology
- [Godot Engine](https://godotengine.org/)  

---

✨ Have fun playing Morpiony!
