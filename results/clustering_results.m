%clear all; close all; clc;

 movieList = [2,9,17,24,23,283,434,64, 82,113,33,96,426];
 movie_classes = {[1],[2,3,4],[5,6,7],[8,9,10],[11,12,13]};
 movie_classes_ind = [1,2,2,2,3,3,3,4,4,4,5,5,5];
% movieList = [29,34,360,12,22,461,31,35,161,200];
% movie_classes = {[1,2,3],[4,5,6,7],[8,9,10]};
% movie_classes_ind = [1,1,1,2,2,2,2,3,3,3]; 
%movieList = [49,66,277,313,293,214,248,477,290,498];
%movie_classes = {[1,2,3,4,5],[6,7,8,9,10]};
%movie_classes_ind = [1,1,1,1,1,2,2,2,2,2]; 

%comedy movies vs scifi action over a range of movie rankings
%movieList = [638, 641, 808, 524, 570, 95, 117, 629,8,675,880,23,24,622];
%movie_classes = {[638, 641, 808, 524, 570, 95, 117],[629,8,675,880,23,24,622]};
%movie_classes_ind = [1,1,1,1,1,1,1,2,2,2,2,2,2,2]; 

alpha_nL_range = logspace(-5, 1.5, 30);

%% different networks
load('undir_tags.mat');
load('undir_user_alpha_5_500');
load('undir_user_alpha_5_1000');
load('diff_tags_1000.mat');
load('diff_tags_10000.mat');

threshold = 0;
ratio_best = 2;

%% initialise for user based networks
%A = undir_user_alpha_5_500
%A = undir_user_alpha_5_1000;

%% initialise for tag based networks

%A = to_similarity(diff_tags,threshold);
A = to_similarity(diff_tags_1000,threshold);
%A = to_similarity(diff_tags_10000,threshold);

%% inspect results on network
L = laplacian_matrix(A, 'unnormalized'); L_norm = laplacian_matrix(A, 'normalized');
ratio_diagL_diagNL = sum(diag(L)) / sum(diag(L_norm));
results = zeros(length(alpha_nL_range), 2);

for alpha_nL_idx = 1:length(alpha_nL_range)

    alpha_nL = alpha_nL_range(alpha_nL_idx);
    alpha_L = alpha_nL / ratio_diagL_diagNL;

    diff_matrix = diffusion_matrix(L, alpha_L);
    diff_matrix_norm = diffusion_matrix(L_norm, alpha_nL);

    X = full(sparse(1:length(movieList), movieList, ones(size(movieList)), length(movieList), length(A)));
    X_L = X * diff_matrix;
    X_nL = X * diff_matrix_norm;

    pred_classes = kmeans(X_L, length(movie_classes));
    pred_classes_norm = kmeans(X_nL, length(movie_classes));
    randInd = rand_index(movie_classes_ind, pred_classes);
    randInd_norm = rand_index(movie_classes_ind, pred_classes_norm);

    results(alpha_nL_idx, 1) = randInd;
    results(alpha_nL_idx, 2) = randInd_norm;

end
