function [as, cs, s] = findenter(Amatrix, pivalues, c, indices) 
    % Given:
    %   the complete m by n matrix Amatrix,
    %   the complete cost vector c with n components
    %   the vector pivalues with m components
    % findenter finds the index of the entering variable and its column
    % It returns the column as, its cost coefficient cs, and its column index s Returns s=0 if no entering variable can be found (i.e. optimal)
    % This will happen when minimum reduced cost > tolerance
    % where tolerance = -1.0E-6
    tolerance = -1.0E-6;

    % Set initial values, returned only when no reduced cost is found
    as = Amatrix(:,1);
    cs = c(1);
    s = 0;
    
    % Find a non-basic column with a negative reduced cost
    for i = 1:size(Amatrix, 2)
        if ~any(indices==i)
            r = c(i) - pivalues * Amatrix(:,i);
    
            if r <= tolerance
                s = i;
                as = Amatrix(:,i);
                cs = c(i);
            end
        end
    end
end
                 