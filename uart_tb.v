`timescale 1ns / 1ps

`include "uart.v"

module uart_tb;

reg clk;
reg btn;
reg uart_rx;

wire uart_tx;
wire [5:0] led;

uart #(.WAIT_CYCLES(8)) uut0(
    .clk(clk), .btn(btn),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .led(led)
);

always #1 clk = ~clk;

initial begin
    clk = 1;
    $dumpfile("uart_tb.vcd");
    $dumpvars;

    uart_rx = 1; // idle
    #6; // so internally we move from default case to idle state just setting up the state register
    uart_rx = 0; // move to start state
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1; // go to stop
    
    // for the second bit
    
    #16 // stay in idle at least 16 ns in stop state
    uart_rx = 0; // move to start state
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 0;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 1;
    #16;
    uart_rx = 1; // go to stop

    #100 $finish;

end


endmodule