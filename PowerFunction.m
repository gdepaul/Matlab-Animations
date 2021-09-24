function [ ] = PowerFunction(  )

    X = 0:0.01:2;
     
    for lambda = -5:0.01:5
        f=@(x,y) x^(lambda);
        Y=arrayfun(f,X);
        plot(X,Y)
        axis([0 2 0 2])
        drawnow
    end

end

