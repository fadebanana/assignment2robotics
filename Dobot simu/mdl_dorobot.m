 

function r = mdl_dorobot()
    
    deg = pi/180;
    
    % robot length values (metres)
           L1 = Link('d',0.08,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset', pi);
            L2 = Link('d',0,'a',-0.135,'alpha',0,'qlim',deg2rad([-360 360]) , 'offset',0); 
            L3 = Link('d',0,'a',-0.160,'alpha',0,'qlim',deg2rad([-360 360]) , 'offset', 0);
            
    
    % and build a serial link manipulator
    
    % offsets from the table on page 4, "Mico" angles are the passed joint
    % angles.  "DH Algo" are the result after adding the joint angle offset.

    robot = SerialLink([L1 L2 L3], ...
        'name', 'UR3');
    


    
    % place the variables into the global workspace
    if nargin == 1
        r = robot;
    elseif nargin == 0
        assignin('caller', 'ur3', robot);
        assignin('caller', 'qz', [0 0 0 0 0 0]); % zero angles
        assignin('caller', 'qr', [0 -90 0 -90 0 0]*deg); % vertical pose as per Fig 2
    end
     drawnow()            
     teach(self.robot);
end