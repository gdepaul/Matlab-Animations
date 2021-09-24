function [] = RandomNNArt() 

    % actual size of generated image
    % rng shuffle
    sizew = 2560;
    sizeh = 1600;
    seconds = 30;
    record_video = 1;
    frameRate = 30;

    % settings of nnet:

    networkSize = 16; % 16 neurons in each layer
    nHidden = 8; % depth of 8 layers
    nOut = 3; % r, g, b layers

    model = initModel(networkSize, nHidden,nOut);
    
    if record_video
        uncompressedVideo = VideoWriter('NNVideo', 'MPEG-4');
        uncompressedVideo.FrameRate = frameRate;  % Default 30
        open(uncompressedVideo);
    end
    
    A = zeros(sizeh,sizew,nOut);
    T = 0;
    for t = 0:seconds*frameRate
        for i=1:sizeh
            for j = 1:sizew
               A(i,j,:) = feedForward(model, nHidden, scale(i,sizeh,sizew), scale(j,sizew,sizeh), T);
            end
        end
        
        if record_video
            writeVideo(uncompressedVideo, A);
        else
            imwrite(A,'NNImage.png')
            imshow(A)
            break;
        end
        t/(seconds*frameRate)
        T = T + 0.01;
     end
    
    if record_video
        close(uncompressedVideo);
    end
end

function model = initModel(networkSize,nHidden,nOut)
    stddev = 1;

    model = cell(nHidden + 2, 1);

    model(1) = {round(stddev*randn(networkSize, 4))}; 

    for i=2:nHidden+1
        model(i) = {round(stddev*randn(networkSize, networkSize))};
    end

    model(nHidden + 2) = {round(stddev*randn(nOut, networkSize))};
end

function forwardResult = feedForward(model, nHidden, x, y, t)
    X = [x, y, t, 1.0]';

    forwardResult = tanh(model{1} * X);
  
    for i = 2:nHidden + 1
        forwardResult = tanh(model{i} * forwardResult);
    end
    
    forwardResult = sigmoid(model{nHidden+2} * forwardResult);
end

function g = sigmoid(z)
    g = 1.0 ./ ( 1.0 + exp(-z)); 
end

function r = scale(x,index_max,other) 
    r = (x-index_max/2)/(max([index_max other]));
end