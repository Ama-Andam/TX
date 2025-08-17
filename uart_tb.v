// UART TX Testbench
`timescale 1ns/1ps
module uart_tb;

reg clk;
reg reset;
reg send_signal;
reg [7:0] data_input;
wire busy;
wire tx_output;

localparam SYS_CLOCK = 1000000;
localparam BAUD_RATE = 9600;

// Instantiate the UART module
uart_tx #(
    .SYS_CLOCK(SYS_CLOCK),
    .BAUD_RATE(BAUD_RATE)
) tx_controller (
    .clk(clk),
    .reset(reset),
    .send_signal(send_signal),
    .data_input(data_input),
	.busy(busy),
    .tx_output(tx_output)
);

// clock Generation
initial begin
    clk = 0;
    forever #0.05 clk = ~clk; // 1 MHz
end

// Final test
initial begin
    $dumpfile("uart.vcd");   // name of the waveform file
    $dumpvars(0, uart_tb); // dump all signals in this module

    reset = 1;
    send_signal = 0;
    data_input = 8'h00;
    #20;
    reset = 0;

    // Send first byte
    data_input = 8'hA5;
    send_signal = 1;
    #5;
    send_signal = 0;

    // Wait till the transmission is done
    wait(!busy);
    #5


    // Send second byte
    data_input = 8'h3C;
    send_signal = 1;
    #10;
    send_signal = 0;

    // Wait till the transmission is done
    wait(!busy);
    #5

    $finish;
end

endmodule
