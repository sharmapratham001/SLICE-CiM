`timescale 1ns/1ps

module precision_reg (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       host_wr_next,
    input  wire [1:0] host_pmr_next_in,
    input  wire       host_wr_current,
    input  wire [1:0] host_pmr_current_in,
    input  wire       fme_transfer,
    output reg  [1:0] PMR_current,
    output reg  [1:0] PMR_next
);
    // 2'b00=INT2  2'b01=INT4  2'b10=INT8

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)            PMR_next <= 2'b10;
        else if (host_wr_next) PMR_next <= host_pmr_next_in;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                PMR_current <= 2'b10;
        else if (fme_transfer)     PMR_current <= PMR_next;
        else if (host_wr_current)  PMR_current <= host_pmr_current_in;
    end

endmodule
