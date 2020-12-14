# qsr2-sim
Simulated data (and generation code) used in "Stable anatomy detection in multimodal imaging through sparse group regularization: a comparative study of iron accumulation in the aging brain" by Pietrosanu et al. (doi:TBA)

Simulated data used in the paper can be loaded via the two .mat files available at the links below.
1. sim_data_independent.mat contains data used in the paper's first simulation. DATA_INDEPENDENT{i} is data relevant to the i-th independent simulation (with atttributes A, x, y, sz, S): https://drive.google.com/file/d/1fykXdOsdKtQf9EfZ8w5XKVfpeAb9kR79/view?usp=sharing
2. sim_data_stability.mat contains data used in the paper's second simulation. DATA_STABILITY has attributes A, x, y, sz, and S: https://drive.google.com/file/d/1XF-JiIylNayaxwsPgLYu1P4uF3wIMZLD/view?usp=sharing

Code for generating this simulated data is provided in synth_data.m. Inputs and outputs (i.e., the attributes described above) are explained in the comments. For full info, see the referenced paper.
