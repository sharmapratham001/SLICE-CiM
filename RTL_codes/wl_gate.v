`timescale 1ns/1ps

module wl_gate #(
    parameter B = 8,    // number of bit-slices
    parameter M = 64    // number of rows (weight words)
)(
    input  wire [B-1:0]   SLICE_EN,        // from precision_decoder
    input  wire [M-1:0]   WL_global,       // global wordline from address decode
    output wire [B*M-1:0] WL_final         // gated wordlines, flattened [s*M + r]
);
    genvar s, r;
    generate
        for (s = 0; s < B; s = s + 1) begin : slice_loop
            for (r = 0; r < M; r = r + 1) begin : row_loop
                assign WL_final[s*M + r] = WL_global[r] & SLICE_EN[s];
            end
        end
    endgenerate

endmodule
