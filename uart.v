module uart
#(parameter WAIT_CYCLES=234)
(
    input clk, uart_rx, btn,
    output uart_tx,
    output reg[5:0] led
);

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START = 1;
localparam RX_STATE_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP = 4;

localparam HALF_WAIT_CYCLES = WAIT_CYCLES/2;
localparam DATA_WIDTH = 8;


reg [2:0] state;
reg [7:0] counter;
reg [7:0] data;
reg [2:0] how_many_bits_are_ready;


always @ (posedge clk) begin
    case(state)
        RX_STATE_IDLE: begin
            if (uart_rx == 1'b0) begin
                counter <= 1;
                how_many_bits_are_ready <= 0;
                state <= RX_STATE_START;
            end
        end
        RX_STATE_START: begin
            counter <= counter + 1;
            if (counter == HALF_WAIT_CYCLES) begin
                counter <= 0;
                state <= RX_STATE_WAIT;
            end
        end
        RX_STATE_WAIT: begin
            counter <= counter + 1;
            if (counter == (WAIT_CYCLES - 1)) begin
                state = RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            how_many_bits_are_ready <= how_many_bits_are_ready + 1;
            data <= {uart_rx, data[7:1]};
            counter <= 1;
            if (how_many_bits_are_ready == DATA_WIDTH-1) begin
                state <= RX_STATE_STOP;
            end else begin
                state <= RX_STATE_WAIT;
            end
        end
        RX_STATE_STOP: begin
        end
        default:
            state <= RX_STATE_IDLE;
    endcase
end

endmodule