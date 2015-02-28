
%% A test ranges over a range of alpha finding quantitative measures

clear all; close all; clc;
alpha_nL_range = logspace(-5, 1.5, 200); % alpha for normalized Laplacian

%movieList = [2,9,17,24,23,283,434,64, 82,113,33,96,426];
%movie_classes = {[1],[2,3,4],[5,6,7],[8,9,10],[11,12,13]};
%movie_classes_ind = [1,2,2,2,3,3,3,4,4,4,5,5,5];
movieList = [29,34,360,12,22,461,31,35,161,200];
movie_classes = {[1,2,3],[4,5,6,7],[8,9,10]};
movie_classes_ind = [1,1,1,2,2,2,2,3,3,3]; 
% movieList = [49,66,277,313,293,214,248,477,290,498];
% movie_classes = {[1,2,3,4,5],[6,7,8,9,10]};
% movie_classes_ind = [1,1,1,1,1,2,2,2,2,2]; 

load('undir_tags.mat');
load('undir_user_alpha_5');

options = statset('MaxIter', 500);


thresholds = 0;
results_best = zeros(length(alpha_nL_range),2);
threshold_best = 0;
ratio_best = 2;

for threshold=thresholds
    
    %A = A1;
    %A(A<threshold)=0;
    A = to_similarity(diff_tags,threshold);

    L = laplacian_matrix(A, 'unnormalized'); L_norm = laplacian_matrix(A, 'normalized');
    ratio_diagL_diagNL = sum(diag(L)) / sum(diag(L_norm));
    results = zeros(length(alpha_nL_range), 2);
    
    for alpha_nL_idx = 1:length(alpha_nL_range)

        alpha_nL = alpha_nL_range(alpha_nL_idx);
        alpha_L = alpha_nL / ratio_diagL_diagNL;

        diff_matrix = diffusion_matrix(L, alpha_L);
        diff_matrix_norm = diffusion_matrix(L_norm, alpha_nL);

        distances = distance_matrix(diff_matrix, movieList);
        distances_norm = distance_matrix(diff_matrix_norm,movieList);

        ratio = mean_intraclass_dist(distances,movie_classes) / mean_interclass_dist(distances,movie_classes);
        ratio_norm = mean_intraclass_dist(distances_norm,movie_classes) / mean_interclass_dist(distances_norm,movie_classes);
        
        md_dist = mdscale(distances,length(movieList) - 1, 'Options', options); 
        md_dist_norm = mdscale(distances_norm,length(movieList) - 1, 'Options', options);
        
% Instead of kmeans on md-scaled data, you can just kmeans on diffused
% features. See below.

        pred_classes = kmeans(md_dist,length(movie_classes));
        pred_classes_norm = kmeans(md_dist_norm,length(movie_classes));
        
        randInd = rand_index(movie_classes_ind,pred_classes);
        randInd_norm = rand_index(movie_classes_ind,pred_classes_norm);
        
        results(alpha_nL_idx, 1) = randInd;
        results(alpha_nL_idx, 2) = randInd_norm;
    end

    if ratio_best > min(min(results))
        fprintf('%d\n',ratio_best);
        results_best = results;
        ratio_best = min(min(results));
        threshold_best = threshold;
    end
    
end
results = results_best;

%% Optional, visulization tools.

% Heatmap & Boxplot
%
figure; subplot(2, 1, 1); imagesc(results); colorbar
subplot(2, 1, 2); boxplot(results); grid on

% Dendrogram for the best alpha used in normalized Laplacian.
%
%idx = find(results(:, 2) <= 1.001 * min(results(:, 2))); idx = floor(median(idx));

% find alpha with highest rand_index scores
max_scores = find(results(:,2) == max(results(:,2)));
idx = max_scores(1);

alpha_best = alpha_nL_range(idx);
diff_matrix_norm = diffusion_matrix(L_norm, alpha_best);
distances_norm = distance_matrix(diff_matrix_norm, movieList);
Z = linkage(squareform(distances_norm), 'ward');
figure; dendrogram(Z);

% Double mdscale scatter plots
%

md = mdscale(distances, 2, 'Options', options); 
md_norm = mdscale(distances_norm, 2, 'Options', options);
figure; subplot(2, 1, 1); scatter(md(:,1),md(:,2),50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
text(md(:,1), md(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

subplot(2, 1, 2); scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
text(md_norm(:,1), md_norm(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

%% Instead of Kmeans on mds, Kmeans on diffused features

rng(14);

alpha_nL_idx = 100;

% Compute matrix and distances.
%
alpha_nL = alpha_nL_range(alpha_nL_idx);
alpha_L = alpha_nL / ratio_diagL_diagNL;
diff_matrix = diffusion_matrix(L, alpha_L);
diff_matrix_norm = diffusion_matrix(L_norm, alpha_nL);

% Define non-diffused instance - feature (10 x 500) matrix and then diffuse
% feature space by diff_matrix.
%
X = full(sparse(1:length(movieList), movieList, ones(size(movieList)), length(movieList), 500));
X_L = X * diff_matrix;
X_nL = X * diff_matrix_norm;

result = zeros(200, 2);

% Try multiple
for trial = 1:200
    
    % Your code goes here.
    %
    pred_classes = kmeans(X_L, length(movie_classes));
    pred_classes_norm = kmeans(X_nL, length(movie_classes));
    randInd = rand_index(movie_classes_ind, pred_classes);
    randInd_norm = rand_index(movie_classes_ind, pred_classes_norm);
    
    results(trial, 1) = randInd;
    results(trial, 2) = randInd_norm;
    
end

%% Confirm stability of Kmeans using current approach

rng(14);
alpha_nL_idx = floor(rand(1) * length(alpha_nL_range));

% Compute matrix and distances.
%
alpha_nL = alpha_nL_range(alpha_nL_idx);
alpha_L = alpha_nL / ratio_diagL_diagNL;
diff_matrix = diffusion_matrix(L, alpha_L);
diff_matrix_norm = diffusion_matrix(L_norm, alpha_nL);
distances = distance_matrix(diff_matrix, movieList);
distances_norm = distance_matrix(diff_matrix_norm,movieList);

% Initialze storage space.
%
result = zeros(200, 2);

% Try multiple
for trial = 1:200
    
    md_dist = mdscale(distances,length(movieList) - 1, 'Options', options);
    md_dist_norm = mdscale(distances_norm,length(movieList) - 1, 'Options', options);
    
    pred_classes = kmeans(md_dist,length(movie_classes));
    pred_classes_norm = kmeans(md_dist_norm,length(movie_classes));
    
    randInd = rand_index(movie_classes_ind, pred_classes);
    randInd_norm = rand_index(movie_classes_ind ,pred_classes_norm);
    
    results(trial, 1) = randInd;
    results(trial, 2) = randInd_norm;
    
end

% Confirmed

