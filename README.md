# RISC-V

This is a personal project I'm doing, mostly to learn about processor architecture in general and specifically the RISC-V architecture. I hope to make this implementation better than my previous attemps in terms of performance, code readability, size on FPGA and more. 
By the end of this project I hope to have a RISC-V core with efficient pipelining and other optimizations, that will be customizable enogh to turn it into ome piece of a larger, multi-core processor in the future. This is still very much in the idea face, but that is the idea.



## Progress Report

I've successfully implemented the minimum-viable-ISA which is only the instructions LD, ST, ADD, SUB, AND, OR, and BEQ. I've done so in a parallelised way with all the forwarding and satlling I could foresee being necessary (maybe there are some that I've missed but my tests worked fine).

Next Steps:

 - [ ] Fix the race conditions (identifiable by a #1 delay statement infront of them 'cause I was lazy)
 - [ ] Add the rest of the ISA and run actual tests
 - [ ] Add interfaces for external memory
