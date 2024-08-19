`timescale 1ns/1ps

module CounterValue
#(
    parameter WAIT_NUMBER = 234
)
(
    input clk, uart_rx
);
    reg[1:0] state; // 0 in idle, 1 in start, 2 in other just for debugging
    reg[7:0] counter;

    always @(posedge clk) begin
        case (state)
            0: // meaning idle
            begin
                if (uart_rx == 1'b0) begin
                    counter <= 1;
                    state <= 1; // move to start
                end
            end
            1: // meaning start
            begin
                counter <= counter + 1;
                if (counter == WAIT_NUMBER) begin
                    counter <= 0;
                    state <= 2; // for debugging done waiting
                end
            end
            2: begin
                counter <= 0; //stuck at state 2s
            end
            default:
                state <= 0;
        endcase
    end

endmodule

module CounterValue_tb;

reg clk = 0;
reg uart_rx = 1;

CounterValue #(.WAIT_NUMBER(8)) uut0
(
    .clk(clk), .uart_rx(uart_rx)
);

always #1 clk = ~clk;

initial begin
    $dumpfile("counter_value_in_while_waiting_in_start.vcd");
    $dumpvars;
    #5; // so default case is executed and and now shoud be idle

    uart_rx = 0; // now we should start

    #1000 $finish;

end

endmodule