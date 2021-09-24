function [] = LaplaceAnimation()

n = 40;
scale = 2000/n;
renewRate = n/2;
%renewRate = 9999+1;


f = @(i,j) 0;

J = constructSquareMatrix(f, n); %, scale);

renew = 0;

for k=1:9999
    Jnew = zeros(n,n);
    
   for i = 1:n
        x = i/n;
        Jnew(n, i) = 1-4*(x-0.5)^2;
        Jnew(1, i) = (1-4*(x-0.5)^2);
    end
    
    for i=2:n-1
        parfor j = 2:n-1
            Jnew(i,j) = 1/4*(J(i, j+1) + J(i, j-1) + J(i+1, j) + J(i-1, j));
        end
    end
    
     J = Jnew;
    
    if renew == renewRate
       displayMatrix(J, n, scale);
       renew = 0;
    else
       renew = renew + 1;
    end

end

figure
X = linspace(0, 1, n);
Y = linspace(0, 1, n);
[X, Y] = meshgrid(X, Y);

surf(X, Y, J);


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
    
    JT = abs(JT); %- min(JT);
    scale = 255 / max(max(JT));
    K = uint8(JT .* (scale));
    imshow(K,'Colormap',hot)
end