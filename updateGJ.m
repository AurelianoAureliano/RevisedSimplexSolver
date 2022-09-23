function [newIBmatrix, newindices, newcb] = updateGJ(IBmatrix, indices, cb, cs, s, as, leave)
    % IBmatrix is current m by m inverse basis matrix
    % indices is a column vector current identifiers for basic variables in
    % order of B columns
    % cb is a column vector of basic costs in the order of B columns
    % as is the entering column
    % s is the index of the entering variable
    % leave is the column (p) of the basis matrix that must leave
    % (not its variable index t)
    % updates the inverse basis matrix using gauss-jordan pivoting

    % Update incdices and costs
    newindices = indices;
    newindices(:, leave) = s;

    newcb = cb;
    newcb(leave) = cs;
    
    % Update inverse basis matrix
    newIBmatrix = IBmatrix;
    y = IBmatrix * as;

    for i = 1:size(IBmatrix, 1)
        if i ~= leave && y(i) ~= 0
            factor = y(i) / y(leave);
            newIBmatrix(i,:) = newIBmatrix(i,:) - newIBmatrix(leave,:) * factor;
            y(i) = 0;
        else
            if i == leave
                newIBmatrix(i,:) = newIBmatrix(i,:) ./ y(leave);
                y(i) = 1;
            end
        end
    end
end