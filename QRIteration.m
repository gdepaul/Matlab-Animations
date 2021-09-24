function [] = QRIteration() 

    i = 2^7;
    f = @(i,j) randn()
    scale = floor(2^11/i);
    J = constructSquareMatrix(f, i, 0); 

    A = eig(J)
    sum = 0;
    for k=1:length(A)
        if(isreal(A(k)))
            sum = sum+1;
        end
    end

    reals = sum
    complex = i - sum
    clumps = complex / 2

    displayMatrix(J, i, scale);

    for k=1:10^4
        [Q,R] = qr(J);
        J = R*Q;
        if mod(k, 4) == 0
            displayMatrix(J, i, scale);
        end
    end

end


function [M] = constructSquareMatrix(f, n, symmetric) 
    M  = zeros(n,n);

    for i = 1:n
        for j = 1:n
            M(i,j) = MatrixDefinition(f, i, j); 
        end
    end
    
    if(symmetric == 1)
        for i = 1:n
            for j = 1:n
                if(i > j)
                    M(i,j) = M(j,i);
                end
            end
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
end