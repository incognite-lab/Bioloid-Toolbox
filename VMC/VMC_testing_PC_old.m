%% TESTING LEARNED SOM
%PREPARATION
N=8;
num=N*15;
positive=0;
bad15=0;
bad6=0;
while(1)
    object_position=[];
    for j=1:N
        %op=1:6;
        op=1:15;
        op=op(randperm(length(op)));
        object_position=[object_position, op];
    end
    object_position=object_position';
    temp=1;
    for i=2:length(object_position)
        if (object_position(i)-object_position(i-1))==0
            temp=0;
            continue;
        end
    end
    if temp==1
        break;
    end
end

%TESTING ITERATIONS
for i=1:num
    
    % create a picture for this iteration and show it to the robot
    %{
    [ img, label, position ] =...
        createPicture([150 150], [3, 5], 0,object_position(i) );
    %}
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
    
    if response_power < response_threshold
        positive=positive+1;
    else
        op=object_position(i);
        if op==1 || op==3 || op==7 || op==9 || op==13 || op==15
            bad6=bad6+1;
        else
            bad15=bad15+1;
        end
    end
    disp(['iteration: ' num2str(i), ',response: ' num2str(response_power)]);
end

disp(['Error overal: ' num2str((num-positive)/num),...
    ' Error orig pos:' num2str(bad6),...
    ' Error new pos:' num2str(bad15)])



