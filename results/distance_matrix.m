function [ matrix ] = distance_matrix( diff_matrix, movieList )
%computes the diffusion distance between artificial users with each user
%having watched one movie in the movieList

C = nchoosek(movieList,2);
matrix = zeros(length(movieList));
combind = 1;
for k=1:length(C)
    movie_nums = C(k,:);
    
    i = find(movieList==movie_nums(1),1);
    j = find(movieList==movie_nums(2),1);
    
    matrix(i,j) = single_movie_distance(diff_matrix,movie_nums(1),movie_nums(2));
    
end

matrix = matrix + matrix';


end

