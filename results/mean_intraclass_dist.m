function [ mean ] = mean_intraclass_dist(dist_matrix, classes)
%get average intraclass (within class) distance
    sum = 0;
    count = 0;
    for i=1:length(classes)
        for j=1:(length(classes{i})-1)
            for k=(j+1):length(classes{i})
                sum = sum + dist_matrix(classes{i}(j),classes{i}(k));
                count = count + 1;
            end
        end
    end
    
    mean = sum / count;

end

