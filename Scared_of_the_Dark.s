# Enhancement 1:
# a) Replay the game after it is completed
# b) Line 1005
# c) 
#	- After every move, the positions of all gameplay entities 
#	(Character, Monster, etc.) are saved on the stack.
#   - The starting address of the stack (the replay data) is 
#	stored in memory for later access.
#   - When the player chooses to replay the game, the program 
#	sequentially reads and prints each saved move from memory 
#	by iterating through the stored stack data using the saved
#	starting adress.

# Enhancement 2:
# a) Undo unlimited number of moves made
# b) Line 496
# c)
#	- After every move, the positions of all gameplay entities 
#	(Character, Monster, etc.) are saved on the stack.
#	- The `undo_start` pointer keeps track of the latest 
#	saved state.
# 	- When the player selects the Undo option, the game 
#	restores the previous state by popping the last saved 
#	positions from the stack.

# My Random number generator is on line 1253
.data
gridsize: .byte 8,8
character: .byte 0,0
match: .byte 0,0
stick: .byte 0,0
shadowMonster: .byte 0,0
fearFactor: .byte 0
Get_X: .string "Enter Number of Columns\n"
Get_Y: .string "Enter Number of Rows\n"
Get_move: .string "Enter move (WASD) or R to Restart or U to Undo\n"
Move: .byte 0
Invalid_move: .string "Invalid move!\n"
newline: .string "\n"
Game_Over: .string "You Lose \n"
Game_Over2: .string "You Win \n"
Fear_Gauge: .string "Fear Gauge: "
Got_Match: .string "Got Match?: "
checked: .byte 0
checked2: .byte 0
replay_game: .string "Press Y to replay game \n"
next: .string "Enter N for next move \n"
.align 2
save_stack: .word 0
save_stack2: .word 0
replay_start: .word 0
undo_start:   .word 0
restart_yo: .string "Enter R to Restart Game\n"
candle: .string "Candle is Lit!\n"
yo:      .word 0
.text
.global _start

_start:

	li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0
    li a0, 0
    li a1, 0
    li a2, 0
    li a3, 0
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0
	
	la t0, save_stack
    mv t1, sp
    sw t1, 0(t0) 
	
    la a0, Get_X
    li a7, 4
    ecall
    li a7, 5
    ecall
    mv t1, a0

    la a0, Get_Y
    li a7, 4
    ecall
    li a7, 5
    ecall
    mv t3, a0

    la t0, gridsize
    sb t1, 0(t0)
    sb t3, 1(t0)

    jal generate_locations
    jal draw_board
    jal game_time

_start2:

	li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0
    li a0, 0
    li a1, 0
    li a2, 0
    li a3, 0
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0
	
	la t0, save_stack2
    mv t1, sp
    sw t1, 0(t0) 
	
    la a0, Get_X
    li a7, 4
    ecall
    li a7, 5
    ecall
    mv t1, a0

    la a0, Get_Y
    li a7, 4
    ecall
    li a7, 5
    ecall
    mv t3, a0

    la t0, gridsize
    sb t1, 0(t0)
    sb t3, 1(t0)

    jal generate_locations
    jal draw_board
    jal game_time


generate_locations:
    jal generate_character
    jal generate_stick
    jal generate_match
    jal generate_monster

generate_character:
    mv a0, t1
    jal notrand
    la t0, character
    sb a0, 0(t0)
    mv a0, t3
    jal notrand
    la t0, character
    sb a0, 1(t0)

generate_stick:
    mv a0, t1
    jal notrand
    la t0, stick
    sb a0, 0(t0)
    mv a0, t3
    jal notrand
    la t0, stick
    sb a0, 1(t0)

generate_match:
    mv a0, t1
    jal notrand
    la t0, match
    sb a0, 0(t0)
    mv a0, t3
    jal notrand
    la t0, match
    sb a0, 1(t0)

generate_monster:
    mv a0, t1
    jal notrand
    la t0, shadowMonster
    sb a0, 0(t0)
    mv a0, t3
    jal notrand
    la t0, shadowMonster
    sb a0, 1(t0)

compare_character_stick:
    la t4, character
    la t5, stick
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_char_stick_y
    j compare_character_match
	
check_char_stick_y:
    beq a1, a3, generate_character
	
compare_character_match:
    la t4, character
    la t5, match
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_char_match_y
    j compare_character_monster
	
check_char_match_y:
    beq a1, a3, generate_character
	
compare_character_monster:
    la t4, character
    la t5, shadowMonster
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_char_monster_y
    j compare_stick_match
	
check_char_monster_y:
    beq a1, a3, generate_character
	
compare_stick_match:
    la t4, stick
    la t5, match
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_stick_match_y
    j compare_stick_monster
	
check_stick_match_y:
    beq a1, a3, generate_stick
	
compare_stick_monster:
    la t4, stick
    la t5, shadowMonster
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_stick_monster_y
    j compare_match_monster
	
check_stick_monster_y:
    beq a1, a3, generate_stick
	
compare_match_monster:
    la t4, match
    la t5, shadowMonster
    lb t0, 0(t4)
    lb a1, 1(t4)
    lb t2, 0(t5)
    lb a3, 1(t5)
    beq t0, t2, check_match_monster_y
    j all_checks_complete
	
check_match_monster_y:
    beq a1, a3, generate_match
	
all_checks_complete:
	jal save_position_initial

draw_board:
    li t0, 0
    li t2, 0
    la a2, gridsize
    lb t1, 0(a2)
    lb t3, 1(a2)

condition:
    bge t2, t3, game_prompt
    bge t0, t1, new_row

remove_border:
    addi t4, t3, -1
    addi t5, t1, -1

border_case:
    beqz t2, display_border
    beq t2, t4, display_border
    beqz t0, display_border
    beq t0, t5, display_border

c:
    la t4, character
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, c_coord
    j s
	
c_coord:
    beq t2, t6, display_c
    j s

s:
    la t4, stick
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, s_coord
    j m
	
s_coord:
    beq t2, t6, display_s
    j m

m:
    la t4, match
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, m_coord
    j shadow_m
	
m_coord:
    beq t2, t6, display_m
    j shadow_m

shadow_m:
    la t4, shadowMonster
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, shadow_coord
    j not_a_cord
	
shadow_coord:
    beq t2, t6, display_x
    j not_a_cord

display_c:
    li a0, 'C'
    li a7, 11
    ecall
    j increase
	
display_s:
    li a0, 'M'
    li a7, 11
    ecall
    j increase
	
display_m:
    li a0, 'S'
    li a7, 11
    ecall
    j increase
	
display_border:
    li a0, '*'
    li a7, 11
    ecall
    j increase
	
display_x:
    li a0, 'X'
    li a7, 11
    ecall
    j increase
	
not_a_cord:
    li a0, '.'
    li a7, 11
    ecall

increase:
    addi t0, t0, 1
    j condition
	
new_row:
    li a0, 10
    li a7, 11
    ecall
    li t0, 0
    addi t2, t2, 1
    j condition

invalid:
    la a0, Invalid_move
    li a7, 4
    ecall
    j game_prompt
	
game_prompt:
	la a0, Fear_Gauge
    li a7, 4
    ecall
	la t2, fearFactor
	lb a0, 0(t2)
    li a7, 1
    ecall
	
    la a0, newline
    li a7, 4
    ecall
	
    la a0, Get_move
    li a7, 4
    ecall
    li a7, 12
    ecall
    mv t5, a0
    la a0, newline
    li a7, 4
    ecall

game_time:
    li t2, 'W'
    li t4, 'w'
    beq t5, t2, up
    beq t5, t4, up
    li t2, 'A'
    li t4, 'a'
    beq t5, t2, left
    beq t5, t4, left
    li t2, 'S'
    li t4, 's'
    beq t5, t2, down
    beq t5, t4, down
    li t2, 'D'
    li t4, 'd'
    beq t5, t2, right
    beq t5, t4, right
	
	li t2, 'R'
    li t4, 'r'
    beq t5, t2, res
    beq t5, t4, res
	
	li t2, 'U'
    li t4, 'u'
    beq t5, t2, undo
    beq t5, t4, undo


    la a2, gridsize
    lb t1, 0(a2)
    lb t3, 1(a2)
	j invalid

up:
    la t0, character
    lb t2, 1(t0)
    li a4, 0
    mv a5, t2
    addi a5, a5,-1
    beq a5, a4, invalid
    addi t2, t2, -1
    sb t2, 1(t0)
    j monster_move

left:
    la t0, character
    lb t2, 0(t0)
    li a4, 0
    mv a5, t2
    addi a5, a5,-1
    beq a5, a4, invalid
    addi t2, t2, -1
    sb t2, 0(t0)
    j monster_move

right:
    la t0, character
    lb t2, 0(t0)
    mv a4, t1
    addi a4, a4, -1
    mv a5, t2
    addi a5, a5, 1
    bge a5, a4, invalid
    addi t2, t2, 1
    sb t2, 0(t0)
    j monster_move

down:
    la t0, character
    lb t2, 1(t0)
    mv a4, t3
    addi a4, a4, -1
    mv a5, t2
    addi a5, a5, 1
    beq a5, a4, invalid
    addi t2, t2, 1
    sb t2, 1(t0)
    j monster_move

undo:
    la   t0, undo_start
    lw   t1, 0(t0)            
    beqz t1, false_undo    

    la   t2, save_stack
    lw   t3, 0(t2)            

    addi t4, t1, 8           
    bge  t4, t3, false_undo 

    sw   t4, 0(t0)            
    lb   t5, 0(t4)
    lb   t6, 1(t4)
    la   a3, character
    sb   t5, 0(a3)
    sb   t6, 1(a3)

    lb   t5, 2(t4)
    lb   t6, 3(t4)
    la   a3, stick
    sb   t5, 0(a3)
    sb   t6, 1(a3)

    lb   t5, 4(t4)
    lb   t6, 5(t4)
    la   a3, match
    sb   t5, 0(a3)
    sb   t6, 1(a3)

    lb   t5, 6(t4)
    lb   t6, 7(t4)
    la   a3, shadowMonster
    sb   t5, 0(a3)
    sb   t6, 1(a3)
	
    mv   sp, t4               

    la   t0, character
    lb   t1, 0(t0)           
    lb   t2, 1(t0)          
    la   t3, stick
    lb   t4, 0(t3)           
    lb   t5, 1(t3)           

    bne  t1, t4, not_same_place   
    beq  t2, t5, same_place     
    j    not_same_place           

same_place:
    li   t6, 0
    j    set_checked_place

not_same_place:
    li   t6, 1

set_checked_place:
    la   a0, checked
    sb   t6, 0(a0)

    la   a0, newline
    li   a7, 4
    ecall
    j    draw_board2         

false_undo:
    j    draw_board2

monster_move:
    la t0, character
    lb t1, 0(t0)
    lb t2, 1(t0)
    la t3, shadowMonster
    lb t4, 0(t3)
    lb t5, 1(t3)
    sub t6, t1, t4
    sub t3, t2, t5
    mv a0, t6
    jal absolute
    mv a3, a0
    mv a0, t3
    jal absolute
    mv a4, a0
	
    bge a3, a4, move_x

move_y:
    bge t3, zero, move_down
    addi t5, t5, -1
    j move_done
	
move_down:
    addi t5, t5, 1
    j move_done

move_x:
    bge t6, zero, move_right
    addi t4, t4, -1
    j move_done
	
move_right:
    addi t4, t4, 1

move_done:
    la t3, shadowMonster
    sb t4, 0(t3)
    sb t5, 1(t3)
    j monster_check

monster_check:
    la t0, character
    lb t1, 0(t0)      
    lb t2, 1(t0)      


    la t3, shadowMonster
    lb t4, 0(t3)      
    lb t5, 1(t3)      

    sub t6, t1, t4   
    sub a0, t2, t5    

    mv a1, t6
    jal absolute
    mv a3, a0        

    mv a0, a1         
    jal absolute
    mv a4, a0         
    add a5, a3, a4    
    li a6, 2
    blt a5, a6, generate_monster2

    li a6, 1
    beq a3, a6, check_y_abs
    j get_stick

check_y_abs:
    beq a4, a6, generate_monster2
    j get_stick

absolute:
    bge a0, zero, a_done
    sub a0, zero, a0
	
a_done:
    ret

generate_monster2:
	la t1, fearFactor
	lb t2, 0(t1)
	addi t2, t2, 10
	sb t2, 0(t1)
	
	li t3, 100           
    bge t2, t3, gameover
	
	la t1, gridsize
	lb a0, 0(t1)
    jal notrand
    la t0, shadowMonster
    sb a0, 0(t0)
    lb a0, 1(t1)
    jal notrand
    la t0, shadowMonster
    sb a0, 1(t0)
	j monster_check2

monster_check2:
    la t0, character
    lb t1, 0(t0)      
    lb t2, 1(t0)      

    la t3, shadowMonster
    lb t4, 0(t3)      
    lb t5, 1(t3)      

    sub t6, t1, t4   
    sub a0, t2, t5    

    mv a1, t6
    jal absolute
    mv a3, a0        

    mv a0, a1         
    jal absolute
    mv a4, a0         
    add a5, a3, a4    
    li a6, 2
    blt a5, a6, generate_monster3

    li a6, 1
    beq a3, a6, check_y_abs2
    j get_stick

check_y_abs2:
    beq a4, a6, generate_monster3
    j get_stick

generate_monster3:
	la t1, gridsize
	lb a0, 0(t1)
    jal notrand
    la t0, shadowMonster
    sb a0, 0(t0)
    lb a0, 1(t1)
    jal notrand
    la t0, shadowMonster
    sb a0, 1(t0)
	j monster_check2

gameover:
	la a0, Game_Over
    li a7, 4
    ecall
    j restart

restart:
	la a0, restart_yo    
    li a7, 4              
    ecall
	li a7, 12          
    ecall            
	
	mv t1, a0

    la a0, newline       
    li a7, 4
    ecall
	
	li t0, 'r'
    beq t1, t0, res2
    li t0, 'R'
    beq t1, t0, res2

res:
	
    la t0, save_stack
    lw sp, 0(t0)

   
    la t0, undo_start
    sw sp, 0(t0)
    la t0, replay_start
    sw sp, 0(t0)


    la t0, checked
    sb zero, 0(t0)
    la t0, fearFactor
    sb zero, 0(t0)
	
	j _start

res2:
    la t0, checked
    sb zero, 0(t0)
    la t0, fearFactor
    sb zero, 0(t0)
	  
    j _start2

get_stick:
    la t4, character
    lb t0, 0(t4)
    lb t1, 1(t4)
    la t5, stick
    lb t2, 0(t5)
    lb t3, 1(t5)
    li t6, -1
    beq t2, t6, check_if_game
    beq t3, t6, check_if_game
    beq t0, t2, check_c_stick_y
    j check_if_game
	
check_c_stick_y:
    beq t1, t3, change_stick
    j check_if_game
	
change_stick:
    li t1, -1
    li t2, -1
    la t5, stick
    sb t1, 0(t5)
    sb t2, 1(t5)
	la a0, candle
    li a7, 4
    ecall
    j check_if_game

check_if_game:
    la t4, match
    lb t5, 0(t4)
    lb t6, 1(t4)
    la a1, character
    lb a2, 0(a1)
    lb a3, 1(a1)
    beq t5, a2, check_y_cm
	j save_positions
    j draw_board2
	
check_y_cm:
    beq t6, a3, check_for_game
	j save_positions
    j draw_board2
	
check_for_game:
    la t4, stick
    lb t5, 0(t4)
    li a4, -1
    beq a4, t5, for_game
	j save_positions
    j draw_board2
	
for_game:
    la a0, Game_Over2
    li a7, 4
    ecall
	
	la a0, replay_game
    li a7, 4
    ecall
    li a7, 12
    ecall
    li t1, 'Y'
    li t4, 'y'
    beq a0, t1, start_replay
	beq a0, t4, start_replay
    j exit

draw_board2:
    li t0, 0
    li t2, 0
    la a2, gridsize
    lb t1, 0(a2)
    lb t3, 1(a2)
	
condition2:
    bge t2, t3, game_prompt
    bge t0, t1, new_row2

remove_border2:
    addi t4, t3, -1
    addi t5, t1, -1

border_case2:
    beqz t2, display_border2
    beq t2, t4, display_border2
    beqz t0, display_border2
    beq t0, t5, display_border2
	
c2:
    la t4, character
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, c_coord2
    j s2
	
c_coord2:
    beq t2, t6, display_c2
    j s2
	
s2:
    la t4, stick
    lb t5, 0(t4)
    lb t6, 1(t4)
    li a5, 0
    blt t5, a5, m2
    beq t0, t5, s_coord2
    j m2
	
s_coord2:
    beq t2, t6, display_s2
    j m2
	
m2:
    la t4, match
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, m_coord2
    j shadow_m2
	
m_coord2:
    beq t2, t6, display_m2
    j shadow_m2
	
shadow_m2:
    la t4, shadowMonster
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, shadow_coord2
    j not_cord2
	
shadow_coord2:
    beq t2, t6, display_x2
    j not_cord2
	
display_c2:
    li a0, 'C'
    li a7, 11
    ecall
    j increment2
	
display_s2:
    li a0, 'M'
    li a7, 11
    ecall
    j increment2
	
display_m2:
    li a0, 'S'
    li a7, 11
    ecall
    j increment2
	
display_border2:
    li a0, '*'
    li a7, 11
    ecall
    j increment2
	
display_x2:
    li a0, 'X'
    li a7, 11
    ecall
    j increment2
	
not_cord2:
    li a0, '.'
    li a7, 11
    ecall
	
increment2:
    addi t0, t0, 1
    j condition2
	
new_row2:
    li a0, 10
    li a7, 11
    ecall
    li t0, 0
    addi t2, t2, 1
    j condition2
	
save_position_initial:
    addi sp, sp, -8         

    la t0, character
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 0(sp)
    sb t2, 1(sp)

    la t0, stick
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 2(sp)
    sb t2, 3(sp)

    
    la t0, match
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 4(sp)
    sb t2, 5(sp)

    la t0, shadowMonster
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 6(sp)
    sb t2, 7(sp)
	
	la t0, undo_start
    sw sp, 0(t0)

    j draw_board
	
save_positions:
    addi sp, sp, -8          

    la t0, character
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 0(sp)
    sb t2, 1(sp)

    la t0, stick
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 2(sp)
    sb t2, 3(sp)

    la t0, match
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 4(sp)
    sb t2, 5(sp)

    la t0, shadowMonster
    lb t1, 0(t0)
    lb t2, 1(t0)
    sb t1, 6(sp)
    sb t2, 7(sp)
	
	la t0, undo_start
    sw sp, 0(t0)

    j draw_board2

start_replay:
	la a0, newline
    li a7, 4
    ecall
	la a0, next
    li a7, 4
    ecall
    li a7, 12
    ecall
    li t1, 'N'
    li t4, 'n'
    beq a0, t1, load_first_saved_position
	beq a0, t4, load_first_saved_position

load_first_saved_position:
	la a0, newline
    li a7, 4
    ecall
    la t0, save_stack
    lw t1, 0(t0)            
	
    addi t1, t1, -8        
    la t2, replay_start
    sw t1, 0(t2)           

    lb t4, 0(t1)            
    lb t5, 1(t1)            
    la t0, character
    sb t4, 0(t0)
    sb t5, 1(t0)

    lb t4, 2(t1)            
    lb t5, 3(t1)            
    la t0, stick
    sb t4, 0(t0)
    sb t5, 1(t0)
	
    lb t4, 4(t1)            
    lb t5, 5(t1)           
    la t0, match
    sb t4, 0(t0)
    sb t5, 1(t0)

    lb t4, 6(t1)          
    lb t5, 7(t1)           
    la t0, shadowMonster
    sb t4, 0(t0)
    sb t5, 1(t0)

    jal draw_board3         
    j next_move_prompt

load_next_saved_position:
	la a0, newline
    li a7, 4
    ecall
    la t0, replay_start
    lw t1, 0(t0)           

    beqz t1, replay_done    
	
	addi t1, t1, -8
    sw t1, 0(t0)
	
    mv t2, sp
    blt t1, t2, replay_done


    lb t4, 0(t1)
    lb t5, 1(t1)
    la t3, character
    sb t4, 0(t3)
    sb t5, 1(t3)

    lb t4, 2(t1)
    lb t5, 3(t1)
    la t3, stick
    sb t4, 0(t3)
    sb t5, 1(t3)

    lb t4, 4(t1)
    lb t5, 5(t1)
    la t3, match
    sb t4, 0(t3)
    sb t5, 1(t3)

    lb t4, 6(t1)
    lb t5, 7(t1)
    la t3, shadowMonster
    sb t4, 0(t3)
    sb t5, 1(t3)


    jal draw_board3
    j next_move_prompt

replay_done:
    j restart


next_move_prompt:
    la a0, next            
    li a7, 4
    ecall

    li a7, 12              
    ecall                 

    li t1, 'N'
    li t2, 'n'
    beq a0, t1, load_next_saved_position
    beq a0, t2, load_next_saved_position
    j exit

draw_board3:
    li t0, 0
    li t2, 0
    la a2, gridsize
    lb t1, 0(a2)
    lb t3, 1(a2)
	
condition3:
    bge t2, t3, next_move_prompt
    bge t0, t1, new_row3

remove_border3:
    addi t4, t3, -1
    addi t5, t1, -1

border_case3:
    beqz t2, display_border3
    beq t2, t4, display_border3
    beqz t0, display_border3
    beq t0, t5, display_border3
	
c3:
    la t4, character
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, c_coord3
    j s3
	
c_coord3:
    beq t2, t6, display_c3
    j s3
	
s3:
    la t4, stick
    lb t5, 0(t4)
    lb t6, 1(t4)
    li a5, 0
    blt t5, a5, m3
    beq t0, t5, s_coord3
    j m3
	
s_coord3:
    beq t2, t6, display_s3
    j m3
	
m3:
    la t4, match
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, m_coord3
    j shadow_m3
	
m_coord3:
    beq t2, t6, display_m3
    j shadow_m3
	
shadow_m3:
    la t4, shadowMonster
    lb t5, 0(t4)
    lb t6, 1(t4)
    beq t0, t5, shadow_coord3
    j not_cord3
	
shadow_coord3:
    beq t2, t6, display_x3
    j not_cord3
	
display_c3:
    li a0, 'C'
    li a7, 11
    ecall
    j increment3
	
display_s3:
    li a0, 'M'
    li a7, 11
    ecall
    j increment3
	
display_m3:
    li a0, 'S'
    li a7, 11
    ecall
    j increment3
	
display_border3:
    li a0, '*'
    li a7, 11
    ecall
    j increment3
	
display_x3:
    li a0, 'X'
    li a7, 11
    ecall
    j increment3
	
not_cord3:
    li a0, '.'
    li a7, 11
    ecall
	
increment3:
    addi t0, t0, 1
    j condition3
	
new_row3:
    li a0, 10
    li a7, 11
    ecall
    li t0, 0
    addi t2, t2, 1
    j condition3

notrand:
    addi a0, a0, -1
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    li t2, 1
    bgt a0, t2, skip_add
    addi a0, a0, 2
	
skip_add:
    li a7, 32
    ecall
    jr ra

exit:
    li a7, 93
    li a0, 0
    ecall
	
# Random Number Generator (LCG)

# Citation:
# Manish. (2025). C program to implement linear congruential 
# method for generating pseudo random number - sanfoundry. 
# C Program to Implement Linear Congruential Method for 
# Generating Pseudo Random Number. 
# https://www.sanfoundry.com/c-program-implement-linear-congruential-generator-pseudo-random-number-generation/
LCG:
	la t0, yo
    lw t1, 0(t0)
	li t2, 1103515245
	# multiplier above and constant below are from:
	# https://en.wikipedia.org/wiki/Linear_congruential_generator
	mul t1, t1, t2
	li t2, 12345
	add t1, t1, t2
	li t3, 0x7FFFFFFF 
	# Make sure positive yo and no overflow
	and t1, t1, t3
	sw t1, 0(t0)
	li t2, 10
	# Get number 0 to 9 yo
	rem a0, t1, t2 
	jr ra


