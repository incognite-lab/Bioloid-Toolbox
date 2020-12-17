%% 01 BASIC INITIALIZATION
addpath('C:\Martin\BMII\4. Semestr\IND\Bioloid_Toolbox')
s=setSerialPort(16);
fopen(s);
initRobot(s);
moveHand(s,55,160,0);
%%
vcapg2(0);

%% 02 FIGURE PREPARATION
[ img, label, position ] = createPicture([150 150], [2 3], 0 ,1);
figure(1);
h1=imshow(img);
figure(2)
figure(3)

%% 03 ALGORITHM INITIALIZATION
clearvars -except s h1

%VARIOUS
N=10;%number of training series
num=N*6;%number of training iterations
siz=[18 32]; %processed image size
response_threshold=100;
t=1:num;

%HAND STRUCTURE
hand.constraints=[25 60; 85 -60];
hand.constraints_angles=[480 410; 530 770; 770 900];
hand.step=13;
hand.z=160;
hand.direction=0;
hand.position=[55 0];
hand.scan_direction=0;
hand.turn_stage=0;
hand.save_direction=hand.direction;
hand.along=0;
hand.xy=[0 0];
hand.cycling=0;
hand.cycling_offset=[0 0 0 0];

% NEURONS FOR STATIC NEURAL NETS
[nw_centroid, nw_xy]=createNeuronsWeights(siz,40);

% DATA LOGGING
data=zeros(num,5);
times=zeros(num,1);
distances=zeros(num,1);
responses=zeros(num,1);
labels=cell(num,1);

% SOM PARAMETERS
som.size=siz;% size of the SOM
som.shape='sheet';% shape of the SOM sheet/cyl/toroid
som.alpha=linspace(1,0.1,num);
som.radius=linspace(10,1,num);

som.init_values=[siz(1)/2, siz(2)/2, 450, 640, 860];
som.empty_labels=cell(som.size(1)*som.size(2),1);
for i=1:length(som.empty_labels)
    som.empty_labels(i)={''};
end

% TRAIL LOGGING PARAMETERS
of=[-24 +61];
oo=[1 -1];
canvas=zeros(61,121);
trail=canvas;
c1=hand.position.*oo+of;
trail(c1(1),c1(2))=1;

% GENERATE TRAINING POSITIONS
while(1)
    object_position=[];
    for j=1:N
        op=1:6;
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

% INITIALIZE SOM
sMap = som_randinit(som.init_values,'msize',som.size);
sMap = som_set(sMap,'shape',som.shape);

% LEARNING
%move hand to the default position
moveHand(s,hand.position(1),hand.z,hand.position(2));
while(isMotorMoving(s,2) || isMotorMoving(s,4) || isMotorMoving(s,6))
end


%% 04 TRAINING ITERATIONS
for i=1:num
    
    % create a picture for this iteration
    [ img, label, position ] =...
        createPicture([150 150], [2, 3], 0,object_position(i) );
        %createPicture([150 150], [5, 3], 0,object_position(i) );
        
    % prepare for the iteration
    trail=canvas;
    hand.along=0;
    hand.direction=0;
    hand.cycling=1;
    
    % show the picture to the robot
    figure(1)
    %clf
    hold on
    delete(h1)
    h1=imshow(img,[]);
    hold off
    drawnow

     figure(3)
     clf
    
    pause(0.3) % wait for the camera
    
    % get an image from the camera and preprocess it
    img_orig=vcapg2;
    img_preproc=preprocessImage(img_orig, siz);
    [centroid_nn_response, response_power]=...
        computeCentroidNNResponse( nw_centroid, img_preproc);
    xy_nn_response=computeXYNNResponse(nw_xy, centroid_nn_response);
    xy_data=xy_nn_response;
    
    % position of the object for path planner
    hand.xy=[-60/17, -120/31].*xy_data+[1505/17, 1980/31];
    
    tic
    
    % find winning neuron and get its weights for servos
    bmusIndex=som_bmus(sMap,[xy_data, NaN, NaN, NaN],1);
    bmus=sMap.codebook(bmusIndex,:);
    angle_data=[bmus(3),bmus(4),bmus(5)];
    
    %%{
    % show the SOM and highlight the winning neuron
    figure(3)
    hold on
    sMap.labels=som.empty_labels;
    sMap.labels(bmusIndex)={'x'};
    som_show(sMap,'umat','all','empty','Winner')
    som_show_add('label',sMap,'Textsize',15,'TextColor','r','Subplot',2)
    hold off
    %}
    
    % move the hand to the position acquired from the SOM
    setGoalPosition(s,2,angle_data(1));
    setGoalPosition(s,4,angle_data(2));
    setGoalPosition(s,6,angle_data(3));
    while(isMotorMoving(s,2) || isMotorMoving(s,4) || isMotorMoving(s,6))
    end
    
    % get an image from the camera, preprocess it and get response from NN
    pause(0.3)
    img_orig=vcapg2;
    img_preproc=preprocessImage(img_orig, siz);
    [centroid_nn_response, response_power]=...
        computeCentroidNNResponse( nw_centroid, img_preproc);
    disp(['Iteration: ' num2str(i), ', response: ' num2str(response_power)]);
    responses(i)=response_power;
    
    % get the current position of the hand
    [ x, y, z ] = whereIsHand( s );
    handPosSOM=[x z];
    disp(['Position from SOM: ', num2str(handPosSOM)])
    
    % the hand is in the right position if the response is low enough
    if response_power <= response_threshold
        distances(i)=0;
        
        % everything is alright, go to the learning stage
    else
     
        % if the hand is out of range, move it to the centre of the vision
        if x <= hand.constraints(1,1) || x >= hand.constraints(2,1) ||...
           z >= hand.constraints(1,2) || z <= hand.constraints(2,2)
            moveHand(s,55,160,0);
            hand.position=[55,0];
            disp('Hand is out of range')
        else
            moveHand(s,x,160,z);
            while(isMotorMoving(s,2) || isMotorMoving(s,4) || isMotorMoving(s,6))
            end
            hand.position=round([x,z]);
        end
        
        % continue until the correct position is found
        while(1)
            
            old_pos=hand.position;
            
            % generate next position for the hand
            hand=scanMoveHand(hand);
            
            %%{
            % log trail
            c1=old_pos.*oo+of;
            c2=hand.position.*oo+of;
            q=min([c1; c2]);
            a=q(1); c=q(2);
            q=max([c1; c2]);
            b=q(1); d=q(2);
            trail_temp=canvas;
            trail_temp(a:b,c:d)=1;
            trail_temp(c1(1),c1(2))=0;
            trail=trail+flipud(trail_temp);
            %}
            
            moveHand(s,hand.position(1),hand.z,hand.position(2));
            while(isMotorMoving(s,2) || isMotorMoving(s,4) ||...
                    isMotorMoving(s,6))
            end
            
            % get a picture and process it
            img_orig=vcapg2;
            img_preproc=preprocessImage(img_orig, siz);
            [centroid_nn_response, response_power]=...
                computeCentroidNNResponse( nw_centroid, img_preproc);
            %xy_nn_response=computeXYNNResponse(nw_xy, centroid_nn_response);
            
            if(response_power <= response_threshold)
                angle_data=getPresentPositionMore(s,[2 4 6]);
                break;
            end
        end
    end
    
    [ x, y, z ] = whereIsHand( s );
    handPosOK=[x z];
    
    % log the data for the future
    data(i,:)=[xy_data, angle_data];
    labels{i}=label;
    times(i)=toc;
    distances(i)=sqrt(sum((handPosOK-handPosSOM).^2));

    figure(2)
    clf
    hold on
    subplot(2,1,1)
    plot(t(1:i),distances(1:i));
    subplot(2,1,2)
    imshow(trail,[]);
    hold off
    drawnow
    
    % learn the SOM
    sMap = som_seqtrain(sMap,[xy_data, angle_data],'tracking',0,...
        'trainlen',1,'trainlen_type','samples',...
        'alpha',som.alpha(i),...
        'radius',som.radius(i)*ones(5,1));
    disp(['Position real    : ', num2str(handPosOK)])
    disp(['Time: ', num2str(times(i))])
    disp('********************')
end

%% 05 SAVE ACQUIRED DATA
% number for the files names
data_num=30;
saveData( data_num, distances, times, labels, data )



