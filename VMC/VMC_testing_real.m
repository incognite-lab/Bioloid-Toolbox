%% TESTING THE LEARNED SOM

while(1)
    
    % get an image from the camera and preprocess it
    img_orig=vcapg2;
    img_preproc=preprocessImage(img_orig, siz);
    [centroid_nn_response, response_power]=...
        computeCentroidNNResponse( nw_centroid, img_preproc);
    xy_nn_response=computeXYNNResponse(nw_xy, centroid_nn_response);
    
    if response_power <= response_threshold
        continue;
    end
    
    % get coordinates from the SOM
    bmusIndex=som_bmus(sMap,[xy_nn_response, NaN, NaN, NaN],1);
    bmus=sMap.codebook(bmusIndex,:);
    angle_data=[bmus(3),bmus(4),bmus(5)];
    
    % move the hand to the position acquired from the SOM
    setGoalPosition(s,2,angle_data(1));
    setGoalPosition(s,4,angle_data(2));
    setGoalPosition(s,6,angle_data(3));
    while(isMotorMoving(s,2) || isMotorMoving(s,4) || isMotorMoving(s,6))
    end
    

end





