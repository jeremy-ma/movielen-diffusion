load('ml100k_utility.mat')
sim = 1 - squareform(pdist(utility','cosine'));
L_n = laplacian_matrix(sim,'normalized');
L = laplacian_matrix(sim,'unnormalized');

alpha_nL = 1.0

ratio_diagL_diagNL = sum(diag(L)) / sum(diag(L_n));
alpha_L = alpha_nL / ratio_diagL_diagNL;
diffusion = diffusion_matrix(L,alpha_L);
diffusion_n = diffusion_matrix(L_n,alpha_nL);

% columns are users in diffused utility

% star trek fans
users = zeros(1682,9);
users(227,1) = 1;
users(228,2) = 1;
users(229,3) = 1;

% die hard
users(144,4) = 1;
users(226,5) = 1;
users(550,6) = 1;

%childrens
%willy wonka
users(151,7) = 1;
%toy story
users(1,8) = 1;
%muppet treasure island
users(21,9) = 1;

diffused_users = diffusion * users;
diffused_users_n = diffusion_n * users;

dissimilarity_diffused = squareform(pdist(diffused_users','cosine'));
dissimilarity_diffused_n = squareform(pdist(diffused_users_n','cosine'));

options = statset('MaxIter', 1000);
md_norm = mdscale(dissimilarity_diffused_n, 2, 'Options', options);

% Scatter plot for MDS results.
scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,9,9),'o', 'filled');
%axis([0 1 0 1])

labels = num2str((1:size(md_norm,1))','%d');

text(md_norm(:,1), md_norm(:,2), labels, 'horizontal','left', 'vertical','bottom')






