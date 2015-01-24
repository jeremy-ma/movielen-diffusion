
% similarity matrix
A = to_similarity(diff_tags,28);

L = laplacian_matrix(A,'unnormalized');

diff_matrix = diffusion_matrix(L,0.6);

%forrest gump-2
%9,17,24 star wars original
%23, 283, 434 Matrix 
%64, 82, 113 LOTR
%33 96 426 godfather
movieList = [2,9,17,24,23,283,434,64, 82,113, 33,96,426];

distances = distance_matrix(diff_matrix, movieList);

md = mdscale(distances,2);
    
scatter(md(:,1),md(:,2),50,linspace(1,13,13),'o', 'filled');
    
figure;


%normalised stuff
L_norm = laplacian_matrix(A,'normalized');
diff_matrix_norm = diffusion_matrix(L_norm,0.6);
distances_norm = distance_matrix(diff_matrix_norm,movieList);
md_norm = mdscale(distances_norm,2);
scatter(md_norm(:,1),md_norm(:,2),50,linspace(1,13,13),'o', 'filled');







