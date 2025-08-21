`timescale 1ns/1ps
module uart_tx_rx_tb;

reg clk;
reg reset;
reg send_signal;
reg [7:0] data_input;
wire tx_busy;
wire tx_output;

wire [7:0] rx_data_output;
wire rx_busy;

// Parameters
localparam SYS_CLOCK = 1000000;
localparam BAUD_RATE = 9600;

// Instantiate UART TX
uart_tx #(
    .SYS_CLOCK(SYS_CLOCK),
    .BAUD_RATE(BAUD_RATE)
) tx_controller (
    .clk(clk),
    .reset(reset),
    .send_signal(send_signal),
    .data_input(data_input),
    .busy(tx_busy),
    .tx_output(tx_output)
);

// Instantiate UART RX
uart_rx #(
    .SYS_CLOCK(SYS_CLOCK),
    .BAUD_RATE(BAUD_RATE)
) rx_controller (
    .clk(clk),
    .reset(reset),
    .rx_input(tx_output), // Connect TX output to RX input
    .data_output(rx_data_output),
    .busy(rx_busy)
);

// Clock generation
initial begin
    clk = 0;
    forever #0.05 clk = ~clk; // 1 MHz
end

// Test sequence
initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tx_rx_tb);

    reset = 1;
    send_signal = 0;
    data_input = 8'h00;
    #20;
    reset = 0;

    // Send first byte
    data_input = 8'h80;
    send_signal = 1;
    #5;
    send_signal = 0;

    // Wait till TX is done
    wait(!tx_busy);
    #5;

    // Wait for RX to finish
    wait(!rx_busy);
    #5;
    $display("RX received: %h", rx_data_output);

    // Send second byte
    data_input = 8'h3C;
    send_signal = 1;
    #10;
    send_signal = 0;

    wait(!tx_busy);
    #10;
    wait(!rx_busy);
    #10;
    $display("RX received: %h", rx_data_output);

    $finish;
end

endmodule