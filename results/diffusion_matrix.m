function [ M ] = diffusion_matrix(L, alpha)
%Computes diffusion matrix (I + alpha*L)^(-1)
    M = (eye(length(L)) + alpha * L);
    M = inv(M);
end

