`timescale 1ns/1ps

module fme_controller (
    input  wire [2:0] COUNT,           // current cycle count (from cycle_ctrl)
    input  wire [3:0] Active_Depth,    // current active depth (2, 4, or 8)
    input  wire [1:0] PMR_current,
    input  wire [1:0] PMR_next,
    output wire       FME,             // FME signal — fires at penultimate cycle
    output wire       fme_final,       // fires at final cycle (one cycle after FME)
    output wire       fme_transfer,    // triggers PMR_current ← PMR_next
    output wire       PRECISION_CHANGE
);

    // -------------------------------------------------------------------------
    // Detect any precision change pending (2 XOR gates — negligible delay)
    // -------------------------------------------------------------------------
    assign PRECISION_CHANGE = (PMR_next[1] ^ PMR_current[1]) |
                               (PMR_next[0] ^ PMR_current[0]);

    // -------------------------------------------------------------------------
    // F5: Hardcoded comparators for penultimate and final cycle detection.
    //
    // Active_Depth=2 → penultimate=COUNT==0, final=COUNT==1
    // Active_Depth=4 → penultimate=COUNT==2, final=COUNT==3
    // Active_Depth=8 → penultimate=COUNT==6, final=COUNT==7
    //
    // Three parallel equality checks (each a 3-bit XNOR + AND = ~2 gates),
    // then a 3:1 mux on Active_Depth. No subtraction, no carry chain.
    // -------------------------------------------------------------------------
    wire depth_is_2 = (Active_Depth == 4'd2);
    wire depth_is_4 = (Active_Depth == 4'd4);
    // depth_is_8 is the default — covers both 4'd8 and the reserved case

    wire penultimate;
    assign penultimate = (depth_is_2 & (COUNT == 3'd0)) |
                         (depth_is_4 & (COUNT == 3'd2)) |
                         (          ~depth_is_2 & ~depth_is_4 & (COUNT == 3'd6));

    wire final_cycle;
    assign final_cycle = (depth_is_2 & (COUNT == 3'd1)) |
                         (depth_is_4 & (COUNT == 3'd3)) |
                         (          ~depth_is_2 & ~depth_is_4 & (COUNT == 3'd7));

    // -------------------------------------------------------------------------
    // FME: fires at penultimate cycle when a precision change is pending.
    // This arms the write-then-clear mechanism for the final cycle.
    // -------------------------------------------------------------------------
    assign FME = penultimate & PRECISION_CHANGE;

    // fme_final: fires at final cycle to execute all 4 reconfiguration ops
    assign fme_final   = final_cycle & PRECISION_CHANGE;

    // PMR transfer: same signal — copy PMR_next → PMR_current
    assign fme_transfer = fme_final;

    // -------------------------------------------------------------------------
    // Special case: Active_Depth=2 → FME fires at COUNT==0 (cycle 0 of 2).
    // Host must have written PMR_next before COUNT starts.
    // This is guaranteed by host writing PMR_next at layer configuration
    // (many cycles before mac_start), so the timing constraint is always met.
    // -------------------------------------------------------------------------

endmodule
