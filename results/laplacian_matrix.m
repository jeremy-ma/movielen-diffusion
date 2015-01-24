function [ L ] = laplacian_matrix( A, normalized )
%Calculates Laplacian of a matrix

%set diagonal to zero (in case of a similarity matrix diagonal should be
%NULL
A(logical(eye(size(A)))) = 0;

%get laplacian
L = diag(sum(A,2)) - A;

if strcmp(normalized,'normalized') == 1
    %change into the normalized laplacian
    %normalised laplacian
    D_inv = diag(sum(A,2));
    D_inv = 1./D_inv;
    D_inv(isinf(D_inv)) = 0;
    %D_inv = D_inv^(1/2);
    L = D_inv * L;
end

end

