`timescale 1ns/1ps

module precision_decoder #(
    parameter B = 8
)(
    input  wire [1:0]   PMR_current,
    output reg  [B-1:0] SLICE_EN,
    output reg  [3:0]   Active_Depth
);

    always @(*) begin
        case (PMR_current)
            2'b00: begin   // INT2
                SLICE_EN     = 8'b00000011;
                Active_Depth = 4'd2;
            end
            2'b01: begin   // INT4
                SLICE_EN     = 8'b00001111;
                Active_Depth = 4'd4;
            end
            2'b10: begin   // INT8
                SLICE_EN     = 8'b11111111;
                Active_Depth = 4'd8;
            end
            default: begin // Reserved — safe fallback to INT8
                SLICE_EN     = 8'b11111111;
                Active_Depth = 4'd8;
            end
        endcase
    end

endmodule
