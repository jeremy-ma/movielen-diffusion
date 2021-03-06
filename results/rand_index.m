function [ R ] = rand_index( actual, test )
%calculates the rand index


% rand_index = (a + b) / (number of possible pairs)
% a=number of pairs of elements in S that are in the same set in actual clustering &
% same set in test clustering

%b= number of pairs of elements in S that are in the different sets in
%actual clustering and different sets in test clustering

    pairs = nchoosek(1:length(test),2);
    a=0;
    b=0;
    for idx=1:length(pairs)
        pair = pairs(idx,:);
        if actual(pair(1)) == actual(pair(2)) && test(pair(1)) == test(pair(2))
            a = a + 1;
        elseif actual(pair(1)) ~= actual(pair(2)) && test(pair(1)) ~= test(pair(2))
            b = b + 1;
        end
    end
    
    R = (a + b) / nchoosek(length(test),2);

end

