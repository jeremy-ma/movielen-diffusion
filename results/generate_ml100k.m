

alpha_L = 5.5377e-07;
alpha_nL =  0.0137;
load('ml100k_difference.mat');
ml100k_sim = to_similarity(ml100k_difference,0);
%get rid of the infinities
ml100k_sim(isinf(ml100k_sim)) = 100;
%dodgy but needed infinities arise from two movies being identical
ml100k_L = laplacian_matrix(ml100k_sim,'unnormalized');
ml100k_L_norm = laplacian_matrix(ml100k_sim,'normalized');
ml100k_diffusion = diffusion_matrix(ml100k_L,alpha_L);
ml100k_diffusion_norm = diffusion_matrix(ml100k_L_norm,alpha_nL);















