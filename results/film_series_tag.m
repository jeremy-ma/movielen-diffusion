%% Create Laplacian matrix and diffusion matrix

clear all; close all; clc;
load('undir_tags.mat')
% similarity matrix
A = to_similarity(diff_tags,28);
% A = A1;
A(A < 0.42) = 0; % WH: is this line really necessary?
L = laplacian_matrix(A,'unnormalized');

% Define the alpha (diffurion rate) for unnormalized Laplacian, the alpha
% (diffusion rate) for normalized Laplacian is alpha_L * sum(diag(L))
% / sum(diag(L_norm)) in order to make results comparable.
%
alpha_L = 0.001; 

diff_matrix = diffusion_matrix(L, alpha_L);
%1.8141e-04
%4.5354e-04

%% Create movie list

% FIRST SUB-DATASET: SERIES MOVIE
%forrest gump-2
%9,17,24 star wars original
%23, 283, 434 Matrix 
%64, 82, 113 LOTR
%33 96 426 godfather
movieList = [2,9,17,24,23,283,434,64, 82,113,33,96,426];
movie_classes = {[1],[2,3,4],[5,6,7],[8,9,10],[11,12,13]};

% SECOND SUB-DATASET: DIFFERENT GENRE
%29 mission impossible (1996(
%34- die hard with a vengeance 1995
%360-tomorrow never dies 1997 //
%12- toy story 1999
%22 Aladdin 1992
%461 Antz 1998
%31  lion king //
%35 the sixth sense
%161 blair witch project
%200 scream
% movieList = [29,34,360,12,22,461,31,35,161,200];
% movie_classes = {[1,2,3],[4,5,6,7],[8,9,10]};

% THIRD SUB-DATASET: DIFFERENT TIME
%action movies from 80s
%49 the terminator (1984)
%66 die hard (1988)
%277 Robocop (1987)
%313 Lethal weapon (1987)
%293 predator (1987)//
%action movies from 2000s
%214 mission impossible 2 (2000)
%248 the bourne identity (2002)
%477 black hawk down
%290 Kill bill 2
%498 lethal weapon 3
% movieList = [49,66,277,313,293,214,248,477,290,498];
% movie_classes = {[1,2,3,4,5],[6,7,8,9,10]};

labels = num2str(movieList','%d');

%kids movies, time

%% compute diffusion distance matrix and mdscale

distances = distance_matrix(diff_matrix, movieList);

% Increase max number of iteration in mdscale.
%
options = statset('MaxIter', 500);
md = mdscale(distances, 2, 'Options', options);

% Scatter plot for MDS results.
%
scatter(md(:,1),md(:,2),50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
% text(md(:,1), md(:,2), labels, 'horizontal','left', 'vertical','bottom')
text(md(:,1), md(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

%% Normalised stuff

L_norm = laplacian_matrix(A, 'normalized');

% The ratio between sum(diag(L)) and sum(diag(L))
%
ratio_diagL_diagNL = sum(diag(L)) / sum(diag(L_norm));
alpha_nL = alpha_L * ratio_diagL_diagNL;

% diff_matrix_norm = diffusion_matrix(L_norm, alpha_nL);
diff_matrix_norm = diffusion_matrix(L_norm, 9);

distances_norm = distance_matrix(diff_matrix_norm,movieList);

% Increase max number of iteration in mdscale.
%
options = statset('MaxIter', 500);
md_norm = mdscale(distances_norm, 2, 'Options', options);

% Scatter plot for MDS results.
scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
% text(md_norm(:,1), md_norm(:,2), labels, 'horizontal','left', 'vertical','bottom')
text(md_norm(:,1), md_norm(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

%% Plot mdscale together

figure; subplot(2, 1, 1);
scatter(md(:,1),md(:,2),50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
% text(md(:,1), md(:,2), labels, 'horizontal','left', 'vertical','bottom')
text(md(:,1), md(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

subplot(2, 1, 2);
scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
% text(md_norm(:,1), md_norm(:,2), labels, 'horizontal','left', 'vertical','bottom')
text(md_norm(:,1), md_norm(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

%% Intral-inter class ratio.

ratio = mean_intraclass_dist(distances,movie_classes) / mean_interclass_dist(distances,movie_classes);

ratio_norm = mean_intraclass_dist(distances_norm,movie_classes) / mean_interclass_dist(distances_norm,movie_classes);

disp([ratio, ratio_norm])

%% A test ranges over a range of alpha finding quantitative measures

clear all; close all; clc;
alpha_nL_range = logspace(-2, 1, 200); % alpha for normalized Laplacian

% movieList = [2,9,17,24,23,283,434,64, 82,113,33,96,426];
% movie_classes = {[1],[2,3,4],[5,6,7],[8,9,10],[11,12,13]};
movieList = [29,34,360,12,22,461,31,35,161,200];
movie_classes = {[1,2,3],[4,5,6,7],[8,9,10]};
% movieList = [49,66,277,313,293,214,248,477,290,498];
% movie_classes = {[1,2,3,4,5],[6,7,8,9,10]};

load('undir_tags.mat');
A = to_similarity(diff_tags,28);
A(A < 0.42) = 0; % WH: is this line really necessary?
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

    results(alpha_nL_idx, 1) = ratio;
    results(alpha_nL_idx, 2) = ratio_norm;
end

%% Optional, visulization tools.

% Heatmap & Boxplot
%
figure; subplot(2, 1, 1); imagesc(results); colorbar
subplot(2, 1, 2); boxplot(results); grid on

% Dendrogram for the best alpha used in normalized Laplacian.
%
idx = find(results(:, 2) <= 1.001 * min(results(:, 2))); idx = floor(median(idx));
alpha_best = alpha_nL_range(idx);
diff_matrix_norm = diffusion_matrix(L_norm, alpha_best);
distances_norm = distance_matrix(diff_matrix_norm, movieList);
Z = linkage(squareform(distances_norm), 'ward');
figure; dendrogram(Z);

% Double mdscale scatter plots
%
options = statset('MaxIter', 500);
md = mdscale(distances, 2, 'Options', options); 
md_norm = mdscale(distances_norm, 2, 'Options', options);
figure; subplot(2, 1, 1); scatter(md(:,1),md(:,2),50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
text(md(:,1), md(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;

subplot(2, 1, 2); scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
text(md_norm(:,1), md_norm(:,2), num2str(cell2mat(movie_classes)'), 'horizontal','left', 'vertical','bottom');
grid on;
