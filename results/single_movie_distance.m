function [ distance ] = single_movie_distance( diffusion_matrix, rank1, rank2 )
%calculates diffusion distance between two users each having watched 1
%movie
% WH changes s and r into vectors on Jan30.

    s = zeros(length(diffusion_matrix), 1);
    r = zeros(length(diffusion_matrix), 1);
    
    s(rank1) = 1;
    r(rank2) = 1;
    
    distance = diffusion_distance(diffusion_matrix, s,r);


end

