function [] = AdvectionProblem2D() 

    lambda = 0.5;
    number_of_grid_points = 30;
    x_bounds = [-1, 1];
    y_bounds = [-1, 1];
    t_bound = 20;
    
    display_results('FTFS', x_bounds, y_bounds, t_bound, number_of_grid_points, @u0, lambda);
    
end

function [] = display_results(str, x_bounds, y_bounds, t_bound, number_of_grid_points, initial_cond, lambda)
    
    X = linspace(x_bounds(1), x_bounds(2), number_of_grid_points + 1);
    
    Y = linspace(y_bounds(1), y_bounds(2), number_of_grid_points + 1);
    
    deltaT = (X(2) - X(1))*lambda;
    T = 0:deltaT:t_bound;
    
    U = FTBS(lambda, X(1:length(X) - 1), Y(1:length(X) - 1), T, initial_cond);
    
   figure()
    [X,Y] = meshgrid(X(1:length(X) - 1),Y(1:length(Y) - 1));
    
    z_start = 1;
    z_end = 0.2;
    
    for i=1:length(T)
       Z = squeeze(U(i, :, :));
       surf(X, Y, Z);
       z_curr = z_start + (z_end - z_start)*i/length(T);
       az = 45;
       el = 30;
       %view(az, el);
       axis([-1 1 -1 1 -z_curr z_curr]);
       title(strcat('t=', num2str(T(i))))
       pause(0.06);
    end
    
end

function z = u0(x, y)
    
    epsilon = 5*10^(-4);

    if(abs(x) <= 1/3 + epsilon && abs(y) <= 1/3 + epsilon)
        z = cos(3*pi/2 * x)*sin(3*pi/2 * y);
    else
        z = 0;
    end
    
end

function [U] = FTBS(lambda, X, Y, T, inital_cond)

    % Initializing U at t == 0
    U = zeros(length(T), length(X), length(Y));
    for i = 1:length(X)
        for j = 1:length(Y)
            U(1, i, j) = inital_cond(X(i), Y(j));
        end
    end
    for j = 1:length(Y)
        U(1, length(X), j) = U(1, 1, j);
    end
    for i = 1:length(X)
        U(1, i, length(Y)) = U(1, i, 1);
    end
    U(1, length(X), length(Y)) = U(1, 1, 1);
    
    %%%%%%%%
    a = 1; 
    b = 1;
    
    % Running 2D Finite Difference over T   
    for n = 1:length(T)-1
        
        % Case i == 1 and j == 1
        U(n+1, 1, 1) = U(n, 1, 1) - a*lambda*(U(n, 1, 1) - U(n, length(X)-1, 1)) - b*lambda*(U(n, 1, 1) - U(n, 1, length(Y)-1));
        
        % Case i == 1 and j ~= 1
        for j = 2:length(X)
            U(n+1, 1, j) = U(n, 1, j) - a*lambda*(U(n, 1, j) - U(n, length(X)-1, j)) - b*lambda*(U(n, 1, j) - U(n, 1, j-1));
        end
        
        for i = 2:length(X)
            
            % Case j == 1 and i ~= 1
            U(n+1, i, 1) = U(n, i, 1) - a*lambda*(U(n, i, 1) - U(n, i-1, 1)) - b*lambda*(U(n, i, 1) - U(n, i, length(Y)-1));
            
            % Case j ~= 1 and i ~= 1
            for j = 2:length(X)
                U(n+1, i, j) = U(n, i, j) - a*lambda*(U(n, i, j) - U(n, i-1, j)) - b*lambda*(U(n, i, j) - U(n, i, j-1));
            end
        end
        
        % Update Edges
        
        for j = 1:length(Y)
            U(n+1, length(X), j) = U(n+1, 1, j);
        end
        for i = 1:length(X)
            U(n+1, i, length(Y)) = U(n+1, i, 1);
        end
        U(n+1, length(X), length(Y)) = U(n+1, 1, 1);
    end

end
