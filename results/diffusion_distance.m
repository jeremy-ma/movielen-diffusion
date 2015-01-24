function [ distance ] = diffusion_distance( diffusion_matrix, s, r)
%computes diffusion distance between signals s and r

    distance = norm(diffusion_matrix * (s-r));

end

