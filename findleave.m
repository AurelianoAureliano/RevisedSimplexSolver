function [leave] = findleave(IBmatrix, as, xb, phase, indices, n)
    % Given entering column as and vector xb of basic variables
    % findleave finds the pivot index to update the inverse basis matrix
    % It returns 0 if no pivot can be found (i.e. unbounded)

    
    invBas = IBmatrix * as;
    leave = 0;

    % Check if there's an artificial variable in phase 2
    if phase == 2 && any(indices > n)

        % If so, then make the artificial variable the leaving variable if
        % it's possible
        index = find(indices > n, 1, 'first');
        if invBas(index) ~= 0
            leave = index;
        end
    end
    
    if leave == 0
        % Get indices of all positive non-zero elements of inv(B) * as
        indices = find(invBas>0);
    
        % Return index of leaving variable if bounded, else return 0
        if indices
            lambda(1:length(invBas)) = Inf;
            lambda(indices) = xb(indices) ./ invBas(indices);
            leave = find(lambda==min(lambda), 1, 'first');
        end
    end
end