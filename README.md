# Scared of the Dark

A console-based survival game written in RISC-V assembly where you must light all the candles in your house before shadow monsters drive you mad with fear.

## Features

### Core Gameplay
- Explore a procedurally generated grid-based house
- Collect matches and light candles before fear reaches 100
- Evade shadow monsters that move closer with every step
- Dynamic fear gauge system triggered by proximity to monsters
- Customizable grid size for varied difficulty

### Enhancements
- **Unlimited Undo** — Rewind any number of moves without limit. Reverts character, item, and monster positions
- **Replay System** — After winning, replay your entire winning sequence move-by-move
- **Restart Anytime** — Press R during gameplay to generate a new random level

### User Experience
- Real-time console display with intuitive symbols
- Clear feedback on game state (fear gauge, candle lit, monster proximity)
- Input validation with helpful error messages
- Infinite restart capability

## How to Play

### Getting Started
1. Load `Scared_of_the_Dark.s` in the cpulator RISC-V simulator
2. Press Run
3. Enter desired grid width and height (e.g., 8 and 8)
4. Game generates random positions for character, match, candle, and shadow monster

### Game Board
```
C  = Character (you)
M  = Match (collect to light candles)
S  = Candle (light with a match)
X  = Shadow Monster
*  = Wall (cannot pass)
.  = Empty floor
```

### Controls
| Input | Action |
|-------|--------|
| W/w   | Move up |
| A/a   | Move left |
| S/s   | Move down |
| D/d   | Move right |
| R/r   | Restart with new grid |
| U/u   | Undo last move |

### Objective
1. Locate the match (M) and step on it to collect
2. Locate the candle (S) and step on it with a match to light it
3. Repeat for all candles before fear reaches 100
4. Successfully light all candles = **WIN**

### Fear System
- Every move increases shadow proximity by 1 step
- When shadow touches you (adjacent tile): fear +10, monster respawns
- Fear gauge = 100: **GAME OVER**

## Tech Stack

**Language**
- RISC-V Assembly (32-bit)

**Simulator**
- cpulator (UTM-provided)

**Randomization**
- Linear Congruential Generator (LCG) with seeded state
- Citation: Manish. (2025). C program to implement linear congruential method

**Data Structure**
- Stack-based state saving for undo/replay
- 8 bytes per game state (character X/Y, match X/Y, candle X/Y, monster X/Y)

## Project Structure

```
Scared_of_the_Dark.s
├── _start              # Game initialization & grid setup
├── generate_locations  # Random placement of entities
├── draw_board         # Console rendering (3 variants)
├── game_time          # Input handling & move logic
├── monster_move       # Shadow AI (greedy movement toward player)
├── up/left/right/down # Movement handlers with boundary checks
├── undo               # Pop previous state from stack
├── start_replay       # Playback mode for winning sequence
├── notrand            # Non-random number generator (seeded)
├── LCG                # Linear Congruential Generator (randomness)
└── Memory Layout
    ├── gridsize       # [width, height]
    ├── character      # [x, y]
    ├── stick          # [x, y] (lit candle, marked -1 when used)
    ├── match          # [x, y]
    ├── shadowMonster  # [x, y]
    ├── fearFactor     # [fear gauge]
    ├── save_stack     # Starting stack pointer for replay
    ├── undo_start     # Latest saved state pointer
    └── replay_start   # Current replay position
```

## Key Algorithms

### Shadow AI
```
For each shadow monster move:
  Calculate Manhattan distance to player
  Move one step closer (prefer X then Y axis)
  If adjacent to player: fear += 10, respawn elsewhere
```

### Undo Mechanism
```
After every move:
  - Push 8 bytes to stack (all entity positions)
  - Save stack pointer to undo_start
  
When player presses U:
  - Load undo_start pointer
  - Pop 8 bytes (restore all positions)
  - Update undo_start to new stack position
  - Redraw board
```

### Replay System
```
At game start:
  - Save initial stack pointer to save_stack
  
On win:
  - Set replay_start = save_stack - 8
  - User presses N to step backward through saved states
  - Decrement replay_start by 8 each step
  - Stop when replay_start < current SP
```

## Enhancements Explained

### Enhancement 1: Replay
**Lines:** 1005–1117  
**Implementation:**
- After every move, game state (all entity positions) pushed to stack
- Starting address of stack saved to memory at game start
- On win, user prompted to replay
- Reads saved states sequentially backward through stack
- Displays each position, prompting user for next move

**Use Case:** Review winning strategy, watch perfect playthrough

### Enhancement 2: Undo
**Lines:** 496–507  
**Implementation:**
- Every move saves full game state to stack
- `undo_start` pointer tracks latest saved state
- User presses U to pop last 8 bytes from stack
- Restores character, match, candle, monster positions
- Updates `undo_start` to new latest state
- No limit on undo depth (limited by stack size)

**Use Case:** Recover from bad moves, explore alternative strategies

## Code Quality

- **Efficient Memory Use** — Byte-addressable data for small values (< 256)
- **Modular Design** — Separate functions for initialization, rendering, input, AI
- **Clear Conventions** — Consistent register allocation (t0-t6 for temps, a0-a7 for args/results)
- **Documented Labels** — Every section clearly labeled with function names
- **Cited Algorithms** — RNG algorithm cited with full reference

## Performance

- **Rendering:** O(width × height) per frame
- **Monster Movement:** O(1) greedy pathfinding
- **State Save/Restore:** O(1) stack operations
- **Typical Game:** 50–200 moves before win/loss

## Setup & Compilation

### Prerequisites
- cpulator RISC-V simulator

### Running
1. Open cpulator
2. Load `Scared_of_the_Dark.s` from file menu
3. Set breakpoints (optional)
4. Press Run / Continue
5. Interact via console input/output

### Debugging
- Use cpulator's register inspector to track variables
- Set breakpoints at `draw_board` or `monster_move` labels
- Step through individual instructions
- Monitor stack pointer (sp) to verify undo mechanism

## Testing

**Manual Test Cases:**
- Undo immediately after move (should restore exact state)
- Undo multiple times in a row (should step backward correctly)
- Reach candle without match (should be able to proceed after undo)
- Win game, replay, press N multiple times (should cycle through saved states)
- Try invalid moves (should reject & prompt again)
- Reach fear = 100 (should end game gracefully)

## License

Educational purposes only.
