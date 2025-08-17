UART Transmitter Project
This project implements a UART (Universal Asynchronous Receiver-Transmitter) transmitter module in Verilog. The implementation converts parallel data to serial format for transmission following the standard UART protocol.

Project Overview
The UART transmitter is designed with the following features:

Configurable system clock (default: 1 MHz) and baud rate (default: 9600)
Standard UART frame format (1 start bit, 8 data bits, 1 stop bit)
Busy signal indicator to manage transmission timing
Simple interface for integration with other modules
Project Structure
uart_tx.v - Main UART transmitter module with FSM implementation
uart_tb.v - Testbench that validates the functionality
How It Works
The UART transmitter operates using these key components:

Baud Rate Generator: Divides the system clock to create timing ticks at the specified baud rate
Shift Register: Contains the full 10-bit frame (start bit + 8 data bits + stop bit)
State Machine: Controls the transmission process, maintaining idle state (high) when not transmitting

Implementation Details
The transmitter follows a simple protocol:

Idle state: TX line is high
Start bit: A low bit signals the start of transmission
Data bits: 8 bits sent LSB first
Stop bit: A high bit marks the end of transmission
Simulation Results
UART Waveform showing successful transmission of test bytes 0xA5 and 0x3C


# UART Transmitter Project  

This project implements a **UART (Universal Asynchronous Receiver-Transmitter)** transmitter module in Verilog. The implementation converts parallel data to serial format for transmission following the standard UART protocol.

## Project Overview
The UART transmitter is designed with the following features:
- Configurable system clock (default: **1 MHz**) and baud rate (default: **9600**)  
- UART frame format: **1 start bit, 8 data bits, 1 stop bit**  
- Busy signal to indicate when transmission is in progress  
- Simple interface for integration with other modules  

## Files Structure  
- `uart_tx.v` – UART transmitter module (FSM + shift register + baud generator)  
- `uart_tb.v` – Testbench for simulation and validation  

## How It Works  
1. **Idle state**: TX line is high  
2. **Start bit**: Low bit signals start of transmission  
3. **Data bits**: 8 bits, sent LSB first  
4. **Stop bit**: High bit signals end of transmission  

### Key Components  
- **Baud Rate Generator** – divides the system clock to create timing ticks  
- **Shift Register** – holds the 10-bit frame (start + data + stop)  
- **State Machine** – controls the transmission process  

## Simulation Results
UART Waveform showing successful transmission of test bytes 0xA5 and 0x3C
![Showing Full Output](<Screenshot 2025-08-17 155909.png>)
![Showing Alternating Values for the UART Operation](<Screenshot 2025-08-17 160410.png>)
