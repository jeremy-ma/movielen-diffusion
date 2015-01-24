function [ distance ] = single_movie_distance( diffusion_matrix, rank1, rank2 )
%calculates diffusion distance between two users each having watched 1
%movie

    s = zeros(length(diffusion_matrix));
    r = zeros(length(diffusion_matrix));
    
    s(rank1) = 1;
    r(rank2) = 1;
    
    distance = diffusion_distance(diffusion_matrix, s,r);


end

