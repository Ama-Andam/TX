/* Implementing UART RTL From Scratch based off of my understanding
   of how UART receives parallel data bits and transmits them serially.
   This would take an 8 bit of parallel data and send it serially. Cheers!
*/

// This is the main module
module uart_tx #(
    parameter SYS_CLOCK = 1000000,  // 1 MHz
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire reset,
    input wire send_signal,
    input wire [7:0] data_input,
    output reg busy,
    output reg tx_output
);

    //Stuff I need
    localparam integer DIVISION = SYS_CLOCK / BAUD_RATE;
    reg [15:0] counter;
    reg tick;


    // Baud Rate Generator
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            tick <= 0;
        end else if (counter == DIVISION - 1) begin
            tick <= 1;
            counter <= 0;
        end else begin
            tick <= 0;
            counter <= counter + 1;
        end
    end

    // Finite State Machine Logic for UART || Idle ---> Start ---> Data bits ---> Stop bit ---> Idle
    // When UART is not transmitting data, the signal line is held at a high voltage level 10'b1111111111

    reg [9:0] shift_register; // all the bits to be sent
    reg [3:0] index; // 0 to 9


    always @(posedge clk or posedge reset) begin

        if (reset) begin // do nothing no transmission == IDLE

            // Reset all signals
            busy   <= 0;
            tx_output <= 1; // Idle line is always HIGH
            shift_register <= 10'b1111111111;
            index <= 0;

        end 

        else if (send_signal && !busy) begin

            // Send singal received and line is not busy
            shift_register <= {1'b1, data_input, 1'b0}; // Start ---> Data bits ---> Stop bit
            busy <= 1;
            index <= 0;

        end 
            
        else if (busy && tick) begin

            tx_output <= shift_register[index];

            if (index == 9)begin
            busy <= 0;
            end 
            else begin
            index = index + 1;
            end

        end
    end


endmodule