function [ ] = PeriodicContinuousFunction(  )

    X = 0:0.00001:0.25;
    
    figure('position', [50, 50, 1000, 1000]) 
    h = animatedline;
    axis([0 0.25 0 0.14])
 
    for i=1:10
        Y = zeros(1, length(X));
        
        for n=1:i
            f = @(x) phi(x*4^n)/4^n;
            Y = Y + arrayfun(f, X);
        end
    
        addpoints(h,X,Y);
        drawnow
        pause(0.4)
        
    end

end

function [y] = phi(x) 

    x = x - floor(x);

    if(x <= 1/2)
        y = x;
    end
    
    if(x > 1/2)
        y = 1-x;
    end
    
    if(x > 1 || x < 0)
        disp('fuck');
    end
    
end

