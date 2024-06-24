# Implementation-of-RISC-V-Architecture
![lnkd_img](https://github.com/Dhairya-Senghani/Implementation-of-RISC-V-Architecture/assets/163739270/e4ab65c2-6614-4728-b7a6-54245dda2d61)
![instr_formate_main](https://github.com/Dhairya-Senghani/Implementation-of-RISC-V-Architecture/assets/163739270/c9613b12-b496-4efa-b943-6dc5c7425754)
![instr_formate](https://github.com/Dhairya-Senghani/Implementation-of-RISC-V-Architecture/assets/163739270/90729ef8-e8a8-4d3d-80f4-8b770f7480dc)

# Assembly programm to add all the elements of an array store in to the memory :
addi    a0, zero, 0x9    # Number of Array elements
add    t0, zero, zero    # Array iterator
add    t1, zero, zero    # Address register for Data Memory
add    t2, zero, zero    # Data Register for Data Memory

again_store:
beq   a0, t0, end_store  # if i >= size, break\n
add zero, zero, zero     # Stall in pipelining\n
add zero, zero, zero     # Stall in pipelining\n
addi   t2, t2, 0x1   
sw    t2, 0x0(t1)        # Dereference address to get integer
addi  t0, t0, 1          # Increment the iterator
addi  t1, t1, 4          # Address Increment
j     again_store        # Jump back to start of loop (1 backwards)
add zero, zero, zero     # Stall in pipelining
add zero, zero, zero     # Stall in pipelining
end_store:

addi    t0, zero, 0x0    # Reset required Registers
addi    t1, zero, 0x0        
addi    t2, zero, 0x0       
addi    t3, zero, 0x0       
again_load:

beq   a0, t0, end_load   # if i >= size, break
add zero, zero, zero     # Stall in pipelining
add zero, zero, zero     # Stall in pipelining
lw    t2, 0x0(t1)        # Dereference address to get integer
add zero, zero, zero     # Stall in pipelining
add   t3, t3, t2         # Add integer value to sum
addi  t0, t0, 1          # Increment the iterator
addi  t1, t1, 4          # Address Increment
j     again_load         # Jump back to start of loop (1 backwards)
add zero, zero, zero     # Stall in pipelining
add zero, zero, zero     # Stall in pipelining
end_load:
add    a1, t3, zero      # Move t0 sum  into a1



# Generated Hex Code:
0x00900513
0x000002B3
0x00000333
0x000003B3
0x02550463
0x00000033
0x00000033
0x00138393
0x00732023
0x00128293
0x00430313
0xFE5FF06F
0x00000033
0x00000033
0x00000293
0x00000313
0x00000393
0x00000E13
0x02550663
0x00000033
0x00000033
0x00032383
0x00000033
0x007E0E33
0x00128293
0x00430313
0xFE1FF06F
0x00000033
0x00000033
0x000E05B3


# Output Waveform :
![wave](https://github.com/Dhairya-Senghani/Implementation-of-RISC-V-Architecture/assets/163739270/b13c782e-18b5-4585-9d97-e2454fd5dcb1)
