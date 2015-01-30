function [ mean ] = mean_interclass_dist( dist_matrix, classes )
%mean interclass distance (between classes)
    sum = 0;
    count = 0;
    for i=1:(length(classes)-1)
        for j=(i+1):length(classes)
            for k=1:length(classes{i})
                for l=1:length(classes{j})
                    sum = sum + dist_matrix(classes{i}(k),classes{j}(l));
                    count = count + 1;
                end
            end
        end
    end
    mean = sum / count;

    
end

