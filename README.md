# qsr2-sim
Simulated data (and generation code) used in "Stable anatomy detection in multimodal imaging through sparse group regularization: a comparative study of iron accumulation in the aging brain" by Pietrosanu et al. (doi:TBA)

Simulated data used in the paper can be loaded via the two .mat files.
1. sim_data_independent.mat contains data used in the paper's first simulation. DATA_INDEPENDENT{i} is data relevant to the i-th independent simulation (with atttributes A, x, y, sz, S).
2. sim_data_stability.mat contains data used in the paper's second simulation. DATA_STABILITY has attributes A, x, y, sz, and S.

Code for generating this simulated data is provided in synth_data.m. Inputs and outputs (i.e., the attributes described above) are explained in the comments. For full info, see the referenced paper.
