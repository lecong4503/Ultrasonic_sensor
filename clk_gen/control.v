`timescale 1ns / 1ps

module control (
    input clk,
    input rst_n,
    input toggle,
    output o_idle,
    output o_run
);

parameter IDLE = 1'b0;
parameter RUN = 1'b1;

reg c_state, n_state;
reg r_idle, r_run;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end

always @ (*) begin
    case (c_state)
        IDLE : if (toggle == 1)
                n_state <= RUN;
        RUN  : if (toggle == 0)
                n_state <= IDLE;
        default : n_state <= IDLE;
    endcase
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_idle <= 0;
        r_run <= 0;
    end else if (c_state == IDLE) begin
        r_idle <= 1;
        r_run <= 0;
    end else if (c_state == RUN) begin
        r_idle <= 0;
        r_run <= 1;
    end
end

assign o_idle = r_idle;
assign o_run = r_run;

endmodule