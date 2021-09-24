function [] = pathlinesandstreaklines()
    
    u = @(x,y,t) - y;
    v = @(x,y,t) x + t;
    
    T = 0:0.01:6*pi;
    X = zeros(length(T));
    Y = zeros(length(T));

    for k = 2:length(T)
        currT = T(k);
        X(k) = X(k-1) + u(X(k-1),Y(k-1),currT)*(currT - T(k-1));
        Y(k) = Y(k-1) + v(X(k-1),Y(k-1),currT)*(currT - T(k-1));
    end
    
    plot(X,Y);
    hl = xlabel('$x$');
    set(hl, 'Interpreter', 'latex');
    hl = ylabel('$y$');
    set(hl, 'Interpreter', 'latex');
    set(gca,'FontSize',20);
    hl = title('Pathline from $(0,0)$');
    set(hl, 'Interpreter', 'latex');
    figure()
    
    Tstep = 0.01;
    X = zeros(length(0:Tstep:6*pi));
    Y = zeros(length(0:Tstep:6*pi));
    k = 1;
    for T = 0:0.01:6*pi
        for i=1:k
            currX = X(i);
            currY = Y(i);
            X(i) = X(i) + u(currX,currY,T)*(Tstep);
            Y(i) = Y(i) + v(currX,currY,T)*(Tstep);
        end
        plot(X(1:k),Y(1:k));
        axis([-35 0 -15 20])
        drawnow
        k = k + 1;
    end
    
        hl = xlabel('$x$');
    set(hl, 'Interpreter', 'latex');
    hl = ylabel('$y$');
    set(hl, 'Interpreter', 'latex');
    set(gca,'FontSize',20);
    hl = title('Streakline Released from $(0,0)$ for $0 \leq t \leq 6\pi$');
    set(hl, 'Interpreter', 'latex');
    
end