%% TESTING LEARNED SOM
%PREPARATION
num=360;
positive=0;

%TESTING ITERATIONS
for i=1:num

    [img]=createPictureRandom([150 150]);
    label='x';
    position=0;
    
    figure(1)
    hold on
    delete(h1)
    h1=imshow(img,[]);
    hold off
    drawnow
    pause(0.5)
    
    % get an image from the camera and preprocess it
    img_orig=vcapg2;
    img_preproc=preprocessImage(img_orig, siz);
    [centroid_nn_response, response_power]=...
        computeCentroidNNResponse( nw_centroid, img_preproc);
    xy_nn_response=computeXYNNResponse(nw_xy, centroid_nn_response);
    
    if response_power >= response_threshold
        
        if response_power<250
            setGoalPosition(s,2,510);
            while isMotorMoving(s,2)
            end
            % get an image from the camera and preprocess it
            img_orig=vcapg2;
            img_preproc=preprocessImage(img_orig, siz);
            [centroid_nn_response, response_power]=...
                computeCentroidNNResponse( nw_centroid, img_preproc);
            xy_nn_response=computeXYNNResponse(nw_xy, centroid_nn_response);
        end
        % get coordinates from the SOM
        bmusIndex=som_bmus(sMap,[xy_nn_response, NaN, NaN, NaN],1);
        bmus=sMap.codebook(bmusIndex,:);
        
        % move the hand to the position acquired from the SOM
        setGoalPosition(s,2,bmus(3));
        setGoalPosition(s,4,bmus(4));
        setGoalPosition(s,6,bmus(5));
        while(isMotorMoving(s,2) || isMotorMoving(s,4) || isMotorMoving(s,6))
        end
        pause(0.3)
        
        % get an image from the camera and preprocess it
        img_orig=vcapg2;
        img_preproc=preprocessImage(img_orig, siz);
        [centroid_nn_response, response_power]=...
            computeCentroidNNResponse( nw_centroid, img_preproc);
    end
    
    % if the response is lower then the threshold, then the object is hiden
    if response_power < response_threshold
        positive=positive+1;
    end
    disp(['iteration: ' num2str(i), ', response: ' num2str(response_power),...
        ', error: ' num2str(i-positive)]);
end

disp(['Error rate: ' num2str((num-positive)/num),...
    ' Error number:' num2str(num-positive)])



