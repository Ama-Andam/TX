/* Implementing UART RTL From Scratch based off of my understanding
   of how UART receives parallel data bits and transmits them serially.
   This would take an 8 bit of parallel data and send it serially. Cheers!
*/

// This is the main module
module uart_rx #(
    parameter SYS_CLOCK = 1000000,  // 1 MHz
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire reset,
    input wire rx_input,
    output reg [7:0] data_output,
    output reg busy
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

    reg [9:0] shift_register; // all the bits to be received
    reg [3:0] index; // 0 to 9

    // Read the line if its HIGH then it means START bit has not been detected, when there is a switch from 1 to 0 it means START bit has been detected

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_register <= 0;
            index <= 0;
            busy <= 0;
        end else if (tick) begin
            if (!rx_input && !busy) begin
                // Start bit detected
                busy <= 1;
                index <= 0;
            end else if (busy) begin
                // Shift in the data bits
                shift_register <= {rx_input, shift_register[9:1]};
                index <= index + 1;

                // If we have received all 10 bits (1 start bit + 8 data bits + 1 stop bit)
                if (index == 9) begin
                    data_output <= shift_register[8:1]; // Store the received data bits
                    busy <= 0; // Reset busy state
                end
            end
        end
    end


endmodule