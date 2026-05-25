# SLICE-CiM : Selective Layer-wise Inference Control Engine with Confidence-Based Early Exit for SRAM based Digital Compute-in-Memory
We will make the complete program code and data available upon acceptance. In addition, the manuscript provides a detailed methodology, including the proposed architecture and evaluation procedures, to facilitate replication of the experiments.
## Overview

SLICE-CiM is a synthesizable peripheral framework designed for
digital SRAM Compute-in-Memory accelerators.

The framework introduces four key mechanisms:

- Precision-aware bit-slice activation
- Confidence-based early exit
- Zero-overhead precision transitions
- Deterministic cycle control

The design addresses:

- L1: Bit-slice over-activation
- L2: Excess accumulation depth
- L3: Precision transition stalls

without modifying the SRAM bitcell.

---

## Architecture



The architecture consists of:

1. Precision Register (PR)
2. Precision Decoder (PD)
3. Flush-Merge Enable Controller (FME)
4. Cycle Controller (CC)
5. Confidence-Based Early Exit Module (EE)
6. Wordline Driver (WLG)

---


## RTL Modules

| Module | Function |
|----------|----------|
| precision_register.v | Stores precision mode |
| precision_decoder.v | Generates slice enable signals |
| fme_controller.v | Eliminates transition stalls |
| cycle_controller.v | Bit-serial cycle scheduling |
| early_exit_controller.v | Confidence-based termination |
| wordline_driver.v | Selective wordline activation |

---

## Repository Contents

RTL implementations are provided for all proposed peripheral blocks.

The SRAM macro itself is not included because it was implemented as a custom layout in Cadence Virtuoso.
The python code and the remaining code data used for evaluation will be provided after the acceptance of this work.
 ---

## Citation

If you use this work, please cite:

@article{sharma2026slicecim,
title={SLICE-CiM: Selective Layer-wise Inference Control Engine with Confidence-Based Early Exit for SRAM based Digital Compute-in-Memory},
author={Pratham Sharma and Mohd Faisal Khan and Santosh Kumar Vishvakarma},
journal={IEEE Transactions on Circuits and Systems},
year={2026}
}  
