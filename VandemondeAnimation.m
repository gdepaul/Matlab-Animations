function [] = VandemondeAnimation() 

i = 4;
while i < 2200*2
    a = 0;
    b = 1;
    X = linspace(a, b, i);
    f = @(i,j) (X(i))^(j-1);
    scale = floor(2^11/i);
    J = constructSquareMatrix(f, i); %, scale);
    displayMatrix(J, i, scale);
    i = i*2;
    if(i < 513)
        pause(0.5)
    end
end

end


function [M] = constructSquareMatrix(f, n) 
    M  = zeros(n,n);

    for i = 1:n
        for j = 1:n
            M(i,j) = MatrixDefinition(f, i, j); 
        end
    end
    

end

function [y] = MatrixDefinition(f, i, j)
    y = f(i,j);
end

function [] = displayMatrix(J, n, scale)

    nn = n*scale-1;

    JT = zeros(nn,nn);
    
    for i=1:nn
        for j=1:nn
            JT(i,j) = J(floor(i/scale)+1 , floor(j/scale)+1);
        end
    end
    
    scale = 255 / max(max(JT));
    JT = abs(JT);
    K = uint8(JT .* (scale));
    imshow(K,'Colormap',parula)
    drawnow
end