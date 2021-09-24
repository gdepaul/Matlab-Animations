function [] = VisualizingMappings() 

    f = @(x) cos(x);
    x_min = -pi;
    x_max = pi;
    number_of_steps = 1000;
    border = 0;
    axes = 0;
    square_off = 0;
    auto = 0;
    within_bounds = 0;
    origin = 0;
    show_length = 0;
    max_window = [-pi, pi, -1, 1];
    iterations = 7;
    
    % Do not touch
    step_size = (x_max - x_min) / number_of_steps;
    X = x_min:step_size:x_max;
    [X,Y] = plot_line_curve(X, f, number_of_steps, max_window, axes, border, square_off, auto, within_bounds, origin, show_length, iterations);
    
    figure()
    colormap cool; 
    scatter(X,Y,[],X);
    xlim([max_window(1) max_window(2)])
    ylim([max_window(3) max_window(4)])
    title('Visualizing Mappings',  'fontsize',28)
end

function [X, Y] = plot_line_curve(X, f, number_of_steps, window, axes, border, square_off, auto, within_bounds, origin, show_length, iterations)

    figure()
    h = 1; %sqrt((window(2) - window(1)) * (window(4) - window(3)));
    hold on 
    axis off
    
    title('Visualizing Mappings',  'fontsize',28)
    
    Y = arrayfun(f,X);
    
    X = X(~isinf(Y));
    Y = Y(~isinf(Y));
    
    preserve_domain = X;
    
    origin_value_x = 0;
    origin_value_y = 0;
    
    shift_x = 0;
    scale_x = 1;
    shift_y = 0;
    scale_y = 1;
    
    if square_off
        origin_value_x = (0 - min(X))/(max(X) - min(X));
        origin_value_y = (0 - min(Y))/(max(Y) - min(Y));
        
        shift_x = min(X);
        scale_x = (max(X) - min(X));
        
        shift_y = min(Y);
        scale_y = (max(Y) - min(Y));
        
        X = (X - min(X))/(max(X) - min(X));
        Y = (Y - min(Y))/(max(Y) - min(Y));
        window = [0, 1, 0, 1];
    end
    
    if auto
        window(1) = min(X);
        window(2) = max(X);
        window(3) = min(Y);
        window(4) = max(Y);
    end
    
    if axes
        x=[window(1) window(2)];
        y=[h h];
        plot(x,y, 'k', 'LineWidth',3) 
        text(window(1),h+0.02,'X', 'fontsize',18)

        x=[window(3) window(4)];
        y=[0 0];
        plot(x,y, 'k', 'LineWidth',3) 
        text(window(3),-0.02,'Y', 'fontsize',18)
    end
    
    if show_length
        text(window(2),h+0.02,strcat('length=', num2str(max(X) - min(X))), 'fontsize',18)
        text(window(4),-0.02,strcat('length=', num2str(max(Y) - min(Y))), 'fontsize',18)
    end
    
    if origin
        x=[origin_value_x origin_value_y];
        y=[(h+0.02) -0.02];
        plot(x,y, 'k', 'LineWidth',3) 
        text(origin_value_y,-0.04,'O', 'fontsize',18)
    end
    
    if border
        x=[window(1) window(3)];
        y=[h 0];
        plot(x,y, 'k', 'LineWidth',3) 
        
        x=[window(2) window(4)];
        y=[h 0];
        plot(x,y, 'k', 'LineWidth',3) 
    end
    
    color = cool(number_of_steps+1);            % get 255 RGB colors
    X_ = X;
    v = fliplr((0:iterations) / iterations);
    for j=1:iterations
        Y = arrayfun(@(x) (f(scale_x*x+shift_x)-shift_y)/scale_y,X);
        Y_ = arrayfun(@(x) (f(scale_x*x+shift_x)-shift_y)/scale_y,X_);
        for i=1:length(X)
            x=[X(i) Y(i)];
            y=[v(j) v(j+1)];
            if (Y(i) < window(3) || Y(i) > window(4)) && within_bounds
                continue
            end
            myColor = round((X(i) - min(X))/(max(X) - min(X) + 0.1)*number_of_steps)+1;
            plot(x,y, 'Color', color(myColor,:)) 
            xlim([min(window(1), window(3)) max(window(2), window(4))])
            ylim([-0.1 h+0.1])
            pause(1 / (number_of_steps*iterations))
        end
        X = unique(Y);
        X_ = Y_;
    end
    hold off
    
    X = preserve_domain;
    Y = Y_;

end