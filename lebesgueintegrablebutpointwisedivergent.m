function [ ] = lebesgueintegrablebutpointwisedivergent(  )

    X = 0:0.001:1;
    
    figure('position', [50, 50, 1000, 1000]) 
    h = animatedline;
    axis([-0.1 1.1 0 1.1])
 
    for n=1:1000
        Y = zeros(1, length(X));
        
        k = largest_power_of_2(n);
        j = n - 2^k;
        
        f = @(x) I_n(x, j*2^(-k), (j+1)*2^(-k));
        Y = Y + arrayfun(f, X);
    
        clearpoints(h)
        addpoints(h,X,Y);
        drawnow
        if n < 16
            pause(0.4/2^n)
        end
        
    end

end

function [y] = I_n(x, a, b) 

    if a < x && x < b 
        y = 1;
    else
        y = 0;
    end
    
end

function [k] = largest_power_of_2(n)

    k = 0;
    
    while 2^(k + 1) < n
        k = k+1;
    end

end

