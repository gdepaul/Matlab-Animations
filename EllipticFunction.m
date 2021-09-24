function [ ] = EllipticFunction(  )

    X = -1:0.1:5;
    Y = -2:0.01:2;
     
    [X,Y]=meshgrid(X,Y);
    for lambda = -3:0.1:3
        f=@(x,y) y^2 - x*(x - 1)*(x - lambda);
        z=arrayfun(f,X,Y);
        [M,c] = contourf(X,Y,z,[0:0.1:0.1]);
        c.LineWidth = 3;
        axis([-1 5 -2 2])
        drawnow
    end

end

