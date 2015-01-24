function [ connected ] = is_connected( adj )
%use dfs to check if a graph is connected 1 if connected
%0 if not

    stack = java.util.Stack();
    visited = java.util.HashSet();
    
    stack.push(1);
    count = 0;
    while stack.empty() == 0
        node = stack.pop();
        visited.add(node);
        count = count + 1;
        neighbours = find(adj(node,:));
        for n=1:numel(neighbours)
            if visited.contains(neighbours(n)) == 0
                stack.push(neighbours(n));
                visited.add(neighbours(n));
            end
        end
    end
    %count
    if visited.size() == length(adj)
        connected = 1;
    else
        connected = 0;
    end
end

