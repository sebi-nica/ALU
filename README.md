# **8-bit ALU**

## **Overview**

An 8-bit ALU capable of addition, subtraction, multiplication and division.
- Designed structurally, emphasizing the hardware components rather than behavioral descriptions.
- Separate *Control Unit* and *Arithmetic Unit* module implementations  
- Includes an extensive and easy to use *testbench*

## **I/O Interface**

The top-level interface of the ALU operates as follows:
### 1. Control signals
 - `rst`: 1-bit signal to set all registers to 0. Only needed before the first operation when starting the ALU.
 - `op`: 2-bit signal that determines the operation to be performed. Its value should remain constant until the operation is complete.
   - 00 - addition
   - 01 - subtraction
   - 10 - multiplication
   - 11 - division
 - `start`: 1-bit signal that initiates the operation.

### 2. Inputs
- `inbus`: 8-bit signal used to provide both operands. 
   - The first operand is provided on the first positive edge of the clock after the *start* signal is activated. The second operand is provided on the next positive edge of the clock.
   - [division only] As my implementation of division divides a 16-bit number by an 8-bit one, the input is done in 3 clock cycles. First, the most significant 8 bits of the dividend, then its least significant 8 bits, and lastly, the divisor.

### 3. Outputs
- `finish`: 1-bit signal indicating the completion of the operation.
- `outbus`: 8-bit signal used to output the result.
   - The first part of the result (quotient in the case of division) is provided on the same clock cycle as the *finish* signal is on. The second part of the result (remainder in the case of division) is provided in the following clock cycle.

### Example of I/O cycle:
![*image could not load*](images/sim.png)

## **System Diagram**

### Main modules:
 - `control_unit`: handles the FSM state registers and sends the *arithmetic_unit* control signals
 - `arithmetic_unit`: does operations on the numbers when the *control_unit* tells it to
![*image could not load*](images/diagram1.png)

## **Components**

### arithmetic_unit
![*image could not load*](image/diagram2.png)
arithmetic unit description goes here

### control_unit
![*image could not load*](images/diagram3.png)
control unit description goes here

## **Complex operations**

### multiplication
The algorithm implemented for multiplication is Booth Radix-2

![*image could not load*](images/diagram4.png)

### division
The algorithm implemented for division is Restoring Division


![*image could not load*](images/diagram5.png)

## **Resources**

- [ModelSim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html) - simulating the ALU
- [Digital](https://github.com/hneemann/Digital) - designing the low-level circuits like shift register, counter and adder
- [LogicFriday](https://download.cnet.com/logic-friday/3000-20415_4-75848245.html?ex=WLS-2202.2) - next-state FSM logic
- [Drawio](https://www.drawio.com) - the diagrams and flowcharts seen in this README



















