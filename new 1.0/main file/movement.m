classdef movement< handle
    
    properties
    end
    
    methods(Static)
        function object = movement()
        end
        
        function move2knowlocation(robot,q2)            %location(know) -->location(know)
            robotname=robot.robot.name;
            steps = 5;
            qMatrix = jtraj(robot.robot.getpos,q2,steps);           %   Quintic Polynomial
           robot.robot.plot(qMatrix,'trail','r')  
            drawnow()                  %colour error         s = lspb(0,1,steps);                                             	% First, create the scalar function
%             qMatrix = nan(steps,4);                                             % Create memory allocation for variables
%             for i = 1:steps
%                 qMatrix(i,:) = (1-s(i))*robot.robot.getpos + s(i)*q2;           % Generate interpolated joint angles
%                 animate(robot.robot,qMatrix(i,:));
%                 drawnow();
%             end 
        end
          
        function move2unknowlocation(robot,location)
            steps = 10;
            q1=robot.robot.getpos();
            q2 = robot.robot.ikcon(location,q1);
          qMatrix = jtraj(robot.robot.getpos,q2,steps);           %   Quintic Polynomial
          robot.robot.plot(qMatrix,'trail','r')  
          drawnow()                  %colour error
%             s = lspb(0,1,steps); 
%             qMatrix = nan(steps,4);                                             % Create memory allocation for variables
%             for i = 1:steps
%                 qMatrix(i,:) = (1-s(i))*robot.robot.getpos + s(i)*q2;           % Generate interpolated joint angles
%                 animate(robot.robot,qMatrix(i,:));
%                 drawnow();
            end    
        end  
    end




