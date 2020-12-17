function [ q ] = scanMoveHand( q )
%Generate next position for robots hand.

if q.cycling > 0
    next=0;
    switch (q.cycling)
        case 1
            q.direction=-2;
            next=2;
        case 2
            q.direction=-1;
            next=3;
        case 3
            q.direction=2;
            next=4;
        case 4
            q.direction=2;
            next=5;
        case 5
            q.direction=1;
            next=6;
        case 6
            q.direction=1;
            next=7;
        case 7
            q.direction=-2;
            next=8;
        case 8
            q.direction=-2;
            next=9;
        case 9
            q.direction=-1;
            next=10;
        case 10
            q.direction=2;
            next=0;
    end
    q.cycling=next;
    
    % MOVE TO THE NEXT POSITION AND CHECK CONSTRAINTS
    pos=[0 0];
    stp=q.step;
    switch q.direction
        case 1%up
            pos=[1 0];
            stp=q.step-q.cycling_offset(1);
            q.cycling_offset(1)=0;
        case 2%right
            pos=[0 -1];
            stp=q.step-q.cycling_offset(2);
            q.cycling_offset(2)=0;
        case -1%down
            pos=[-1 0];
            stp=q.step-q.cycling_offset(3);
            q.cycling_offset(3)=0;
        case -2%left
            pos=[0 1];
            stp=q.step-q.cycling_offset(4);
            q.cycling_offset(4)=0;
        otherwise
            disp('switch chyba')
    end
    q.position=q.position+pos.*stp;
    
    temp=q.position(1)-q.constraints(2,1);%up
    if temp>0
        q.position(1)=q.constraints(2,1);
        q.cycling_offset(3)=temp;
    end
    temp=q.position(1)-q.constraints(1,1);%down
    if temp<0
        q.position(1)=q.constraints(1,1);
        q.cycling_offset(1)=-temp;
    end
    temp=q.position(2)-q.constraints(1,2);%left
    if temp>0
        q.position(2)=q.constraints(1,2);
        q.cycling_offset(2)=temp;
    end
    temp=q.position(2)-q.constraints(2,2);%right
    if temp<0
        q.position(2)=q.constraints(2,2);
        q.cycling_offset(4)=-temp;
    end
    
    if (q.cycling==0)
        q.cycling_offset=[0 0 0 0];
        q.direction=0;
    end
    
    return;
end
if q.along==0
    
    % all possible directions
    possible_dir=[ 1 2 -1 -2];
    
    % NEW MOVEMENT
    if (q.direction==0)
        q.scan_direction=0;
        q.along=0;
        q.save_direction=0;
        q.turn_stage=0;
        
        % remove directions out of range
        possible_dir=removeDirection(possible_dir,q);
        
        %if in a corner
        if length(possible_dir)==2
            q.direction=possible_dir(randi(2));
            q=makeMove(q);
            possible_dir=[ 1 2 -1 -2];
            possible_dir=removeDirection(possible_dir,q);
        end
                
        % randomly choose the direction
        if sum(possible_dir)==0
            q.direction=possible_dir(randi(length(possible_dir)));
        else
            q.direction=sum(possible_dir);
        end
        
        % if the object position is unknown
        if q.xy(1)==0 && q.xy(2)==0
            % if the direction is up or down
            if abs(q.direction)==1
                possible_dir=[2 -2];
                % if the direction is left or right
            else
                possible_dir=[1 -1];
            end
        else
            xy=q.xy;
            % if the direction is up or down
            if abs(q.direction)==1
                
                % object is on the right
                if(xy(2)<q.position(2))
                    possible_dir=2;
                else
                    possible_dir=-2;
                end
                % if the direction is left or right
            else
                % object is up
                if(xy(1)>q.position(1))
                    possible_dir=1;
                else
                    possible_dir=-1;
                end
            end
        end
        
        % remove directions out of range
        possible_dir=removeDirection(possible_dir,q);
        if(isempty(possible_dir))
            error('chyba pri vyberu scan_direction');
        end
        q.scan_direction=possible_dir(randi(length(possible_dir)));
        
        
        % CONTINUE IN MOVEMENT
    else

        switch q.turn_stage
            case 0% GO STRIGHT
                q.direction=q.direction;
                
            case 1% GO RIGHT/LEFT
                q.save_direction=q.direction;
                q.direction=q.scan_direction;
                q.turn_stage=2;
                
            case 2% GO BACK
                q.direction=-q.save_direction;
                q.turn_stage=0;
        end
    end
else
    q.direction=q.direction;
end

% MOVE TO THE NEXT POSITION AND CHECK CONSTRAINTS
q=makeMove(q);
corner=0;
if (q.position(1)>=q.constraints(2,1))%up
    q.position(1)=q.constraints(2,1);
    corner=corner+1;
end
if (q.position(1)<=q.constraints(1,1))%down
    q.position(1)=q.constraints(1,1);
    corner=corner+1;
end
if (q.position(2)>=q.constraints(1,2))%left
    q.position(2)=q.constraints(1,2);
    corner=corner+1;
end
if (q.position(2)<=q.constraints(2,2))%right
    q.position(2)=q.constraints(2,2);
    corner=corner+1;
end

if corner==2
    if q.along==0
        q.along=1;
        q.turn_stage=1;
        q.scan_direction=-q.scan_direction;
        q.direction=-q.save_direction;
    else
        q.along=0;
    end
end

switch q.turn_stage
    case 0
        if corner==0
            % no edge -> go stright
            q.turn_stage=0;
        else
            % edge or 1st corner -> begin u-turn
            q.turn_stage=1;
        end
    case 2
end

end

function [q] = makeMove(q)

pos=[0 0];
switch q.direction
    case 1%up
        pos=[1 0];
    case 2%right
        pos=[0 -1];
    case -1%down
        pos=[-1 0];
    case -2%left
        pos=[0 1];
    otherwise
        disp('switch chyba')
end
q.position=q.position+pos.*q.step;

end


function [possible_dir]=removeDirection(possible_dir,q)

% remove out of range directions
if (q.position(1)>=q.constraints(2,1))%up
    possible_dir(find(1==possible_dir))=[];
end
if (q.position(1)<=q.constraints(1,1))%down
    possible_dir(find(-1==possible_dir))=[];
end
if (q.position(2)>=q.constraints(1,2))%left
    possible_dir(find(-2==possible_dir))=[];
end
if (q.position(2)<=q.constraints(2,2))%right
    possible_dir(find(2==possible_dir))=[];
end

end
