classdef movement< handle
    
    properties
    end
    
    methods(Static)
        function object = movement()
        end
        
        function move2knowlocation(robot,q2)            %location(know) -->location(know)
            robotname=robot.robot.name;
            robot.Logendeffectorname(robotname)
            robot.Logtransformsname(robotname)
            steps = 200;
            %qMatrix = jtraj(robot.robot.getpos,q2,steps);           %   Quintic Polynomial
            %robot.robot.plot(qMatrix,'trail','r')  
            %drawnow()                  %colour error
           q1 = [pi/10, pi/7, pi/5, pi/3, pi/4, pi/6]
            s = lspb(0,1,steps);                                             	% First, create the scalar function
            qMatrix = nan(steps,6);                                             % Create memory allocation for variables
            for i = 1:steps
                qMatrix(i,:) = (1-s(i))*q1 + s(i)*q2;           % Generate interpolated joint angles
                animate(robot.robot,qMatrix(i,:));
                drawnow();
            end 
        end
          
        function move2unknowlocation(robot,location)
            steps = 50;
            q1=robot.robot.getpos();
            q2 = robot.robot.ikcon(location,q1);
%           qMatrix = jtraj(robot.robot.getpos,q2,steps);           %   Quintic Polynomial
%           robot.robot.plot(qMatrix,'trail','r')  
%           drawnow()                  %colour error
            s = lspb(0,1,steps); 
            qMatrix = nan(steps,6);                                             % Create memory allocation for variables
            for i = 1:steps
                qMatrix(i,:) = (1-s(i))*robot.robot.getpos + s(i)*q2;           % Generate interpolated joint angles
                %[endEffector,joint] = robot.robot.fkine(qMatrix(i,:));
               % robot.LogendEffector(endEffector);
                animate(robot.robot,qMatrix(i,:));
                drawnow();
            end    
        end  
    end
end



