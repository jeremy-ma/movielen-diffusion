function [ A ] = to_similarity( A, threshold)
%Converts a difference matrix to a similarity matrix
    A = 1 ./ A;
    
    A(A<threshold) = 0;
    
end

