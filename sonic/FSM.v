`timescale 1ns / 1ps

module FSM(
    input clk,
    input rst_n,
    input trig_done,
    input i_read,
    input i_done,
    input re_idle,
    input toggle,
    input ms_tick,
    output o_idle,
    output o_trigger,
    output o_measure,
    output o_read
);

parameter IDLE      = 2'b00;
parameter TRIGGER   = 2'b01;
parameter MEASURE   = 2'b10;
parameter READ      = 2'b11;

reg [1:0] c_state, n_state;
reg r_idle, r_trigger, r_measure, r_read;
reg cnt_ena;

// ms_cnt
reg [5:0] ms_cnt;
wire [5:0] w_idle_ms;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ms_cnt <= 0;
    end else if (ms_tick && cnt_ena) begin
        ms_cnt <= ms_cnt + 1;
    end else if (ms_cnt == 50) begin
        ms_cnt <= 0;
    end
end

// FSM_LOGIC
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end

always @ (*) begin
    n_state = c_state;
    cnt_ena = 1;
    if (re_idle) begin
        n_state = IDLE;
        cnt_ena = 1;
    end else begin
    case (c_state)
        IDLE : if(toggle == 1 && ms_cnt == 50) begin
                n_state = TRIGGER;
                cnt_ena = 0;
               end else if (toggle == 0) begin
                n_state = IDLE;
                cnt_ena = 0;
               end

        TRIGGER : if(toggle == 1 && trig_done == 1) begin
                n_state = MEASURE;
               end else if (toggle == 0) begin
                n_state = IDLE;
               end

        MEASURE : if(toggle == 1 && i_read) begin
                n_state = READ;
               end
               else if (toggle == 0) begin
                n_state = IDLE;
               end

        READ : if(toggle == 1 && i_done) begin
                n_state = IDLE;
               end
               else if (toggle == 0) begin
                n_state = IDLE;
               end
    endcase
    end
end

// IDLE Logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_idle <= 0;
    end else if (c_state == IDLE) begin
        r_idle <= 1;
    end else if (c_state == TRIGGER) begin
        r_idle <= 0;
    end else begin
        r_idle <= 0;
    end
end

// TRIGGER Logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_trigger <= 0;
    end else if (c_state == TRIGGER) begin
        r_trigger <= 1;
    end else if (c_state == MEASURE) begin
        r_trigger <= 0;
    end else begin
        r_trigger <= 0;
    end
end

// MEASURE Logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_measure <= 0;
    end else if (c_state == MEASURE) begin
        r_measure <= 1;
    end else if (c_state == READ) begin
        r_measure <= 0;
    end else begin
        r_measure <= 0;
    end
end

// READ Logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_read <= 0;
    end else if (c_state == READ) begin
        r_read <= 1;
    end else if (c_state == IDLE) begin
        r_read <= 0;
    end else begin
        r_read <= 0;
    end
end

assign o_idle = r_idle;
assign o_trigger = r_trigger;
assign o_measure = r_measure;
assign o_read = r_read;

endmodule