classdef dorobot< handle
    properties
        %> Robot model
        robot;

        %> workspace
        workspace =  [-2 2 -2 2 -2 2];
        
%         Point cloud data
        vertical;
        horizontal;
        Volume;
        pointCloud;


    end
    
    methods%% Class for Dorobot robot simulation
      function self = dorobot(name,base)
            self.Getdorobot(name,base);
            self.PlotAndColourRobot();
            drawnow()            
           teach(self.robot);
       end

        %% doRobot
        % Given a name (optional), create and return a dorobot  robot
        function Getdorobot(self,name,base)
            pause(0.001);
            L1 = Link('d',0.11,'a',0,'alpha',pi/2,'qlim',deg2rad([-135,135]), 'offset', 0);
            L2 = Link('d',0,'a',-0.158,'alpha',0,'qlim', deg2rad([5,80]), 'offset',-pi/2);
            L3 = Link('d',0,'a',-0.205,'alpha',pi/2,'qlim',deg2rad([-5,85]),'offset',0);

            self.robot = SerialLink([L1 L2 L3],'name',name);
            self.robot.base = base*trotz(-pi/2)
        end

%% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available 
        function PlotAndColourRobot(self)
            for linkIndex = 0:self.robot.n
                [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['dorobot',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                self.robot.faces{linkIndex+1} = faceData;
                self.robot.points{linkIndex+1} = vertexData;
            end
% 
%             if ~isempty(self.toolrobotFilename)
%                 [ faceData, vertexData, plyData{self.robot.n + 1} ] = plyread(self.toolrobotFilename,'tri'); 
%                 self.robot.faces{self.robot.n + 1} = faceData;
%                 self.robot.points{self.robot.n + 1} = vertexData;
%                 toolParameters = load(self.toolParametersFilename);
%                 self.robot.tool = toolParameters.tool;
%                 self.robot.qlim = toolParameters.qlim;
%                 warning('Please check the joint limits. They may be unsafe')
%             end
            % Display robot
            
            self.robot.plot3d(zeros(1,3),'noarrow','workspace',self.workspace);
            
        
            
            

            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.robot.n
                handles = findobj('Tag', self.robot.name);
                h = get(handles,'UserData');
                try 
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                                                                  , plyData{linkIndex+1}.vertex.green ...
                                                                  , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
        
%% point could
function plotCloud(self)
        stepRads = deg2rad(80);
        qlim = self.robot.qlim;
        pointCloudeSize = prod(floor((qlim(1:3,2)-qlim(1:3,1))/stepRads + 1));
        self.pointCloud = zeros(pointCloudeSize,3);
        counter = 1;
        tic

        for q1 = qlim(1,1):stepRads:qlim(1,2)
            for q2 = qlim(2,1):stepRads:qlim(2,2)
                for q3 = qlim(3,1):stepRads:qlim(3,2)
                             q = [q1,q2,q3];
                             tr = self.robot.fkine(q);                        
                             self.pointCloud(counter,:) = tr(1:3,4)';
                             counter = counter + 1; 
                             if mod(counter/pointCloudeSize * 100,1) == 0
                            disp(['After ',num2str(toc),' seconds, completed ',num2str(counter/pointCloudeSize * 100),'% of poses']);
                             end            
                end
            end
        end



% Calculate max reach
            Minx = min(self.pointCloud(:,1)) - self.robot.base(1,4);
            Maxx = max(self.pointCloud(:,1)) - self.robot.base(1,4);
            Miny = min(self.pointCloud(:,2)) - self.robot.base(2,4);
            Maxy = max(self.pointCloud(:,2)) - self.robot.base(2,4);
            Minz = min(self.pointCloud(:,3)) - self.robot.base(3,4);
            Maxz = max(self.pointCloud(:,3)) - self.robot.base(3,4);
             
            reach_x = max(Maxx, abs(Minx));
            reach_y = max(Maxy, abs(Miny));
            self.horizontal = max(reach_x, reach_y);
            self.vertical = max(Maxz, abs(Minz));
%cylinder caculate

            disp('Minx is: ');
            disp(Minx);
            disp('Maxx is: ');
            disp(Maxx);
            disp('Miny is: ');
            disp(Miny);
            disp('Maxy is: ');
            disp(Maxy);
            disp('Minz is: ');
            disp(Minz);
            disp('Maxz is: ');
            disp(Maxz);
end
 
         
    end
end
