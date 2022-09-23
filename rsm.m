function [z, x, pivalues, indices, exitflag] = rsm(A, b, c, m, n, verbose)
    % Solves min cx s.t. Ax=b, x>=0
    % exitflag is 0 if solved successfully, 1 if infeasible, and -1 if unbounded 
    % Performs a Phase I procedure starting with an all artificial basis
    % and then calls function simplex
    % Uses modified leaving variable criterion (when in Phase II).

    %--------------------------------Phase1--------------------------------

    % Initialise variables
    % Initialise variables
    s = 1;
    indices = n+1 : n+m;
    cmod = [zeros(n, 1); ones(m, 1)];

    cb = cmod(indices);

    IBmatrix = eye(m);
    exitflag = 0;

    z = cb.' * IBmatrix * b;

    % Main loop, until optimal solution is found or unbounded
    while s && z > 0
        % Calculate x and pi for current B matrix
        pivalues = cmod(indices).' * IBmatrix;
        xb = IBmatrix * b;

        % Search for new entering variable, end loop if optimal
        [as, cs, s] = findenter(A, pivalues, cmod(1:n), indices);
        if s ~= 0

            % Search for new leaving variable, end loop if unbounded
            [leave] = findleave(IBmatrix, as, xb, 1, indices, n);
            if leave == 0

                s = 0;
                exitflag = -1;
            else

                % Update variables if neither optimal nor unbounded
                [IBmatrix, indices, cb] = updateGJ(IBmatrix, indices, cb, cs, s, as, leave);
                z = cb.' * (IBmatrix * b);
            end
        end
    end

    %--------------------------------Phase2--------------------------------
    
    % End loop if problem is infeasible
    if s ~= 0
        cmod = [c; zeros(m,1)];
        % Main loop, until optimal solution is found or unbounded
        while s
            % Calculate x and pi for current B matrix
            pivalues = cmod(indices).' * IBmatrix;
            xb = IBmatrix * b;
    
            % Search for new entering variable, end loop if optimal
            [as, cs, s] = findenter(A, pivalues, c, indices);
            if s ~= 0
    
                % Search for new leaving variable, end loop if unbounded
                [leave] = findleave(IBmatrix, as, xb, 2, indices, n);
                if leave == 0
                    s = 0;
                    exitflag = -1;
                else
    
                    % Update variables if neither optimal nor unbounded
                    [IBmatrix, indices, cb] = updateGJ(IBmatrix, indices, cb, cs, s, as, leave);
                end
            end
        end
    else
        exitflag = 1;
    end

    % Calculate optimal x values and its corresponding cost, z
    x = zeros(n+m,1);
    x(indices,1) = IBmatrix * b;
    x = x(1:n, 1);
    z = c.' * x;
    
    if verbose
        disp("")
        % Print out results
        if exitflag == 0
            disp("Exit flag = 0, Solved successfully")
        elseif exitflag == -1
            disp("Exit flag = -1, Problem is unbounded")
        elseif exitflag == 1
            disp("Exit flag = 1, Problem is infeasible")
        else
            disp("Unexpected exit flag")
        end
    
        fprintf("Total cost = %.2f\n", z)
        fprintf("x values = [%s]\n", join(string(round(x,2).'), ","))
        fprintf("Indices = [%s]\n", join(string(indices), ","))
        fprintf("Pi values = [%s]\n", join(string(round(pivalues,2)), ","))
    end
end