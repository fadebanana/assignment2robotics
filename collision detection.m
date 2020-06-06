          

            L1 = Link('d',0.1,'a',0,'alpha',0,'qlim',[-pi pi], 'offset', 0);
            L2 = Link('d',0,'a',-0.15,'alpha',0,'qlim',[-pi pi], 'offset',0);
            L3 = Link('d',0,'a',-0.15,'alpha',0,'qlim',[-pi pi],'offset', 0);

%             L1 = Link('d',0.1,'a',0,'alpha',pi/2,'qlim',deg2rad([-135,135]), 'offset', 0);
%             L2 = Link('d',0,'a',-0.15,'alpha',0,'qlim', deg2rad([5,80]), 'offset',-pi/2);
%             L3 = Link('d',0,'a',-0.15,'alpha',pi/2,'qlim',deg2rad([-5,85]),'offset', 0);
%             L4 = Link('d',0,'a',0,'alpha',pi/2,'qlim',deg2rad([-180,180]),'offset',0);

              robot = SerialLink([L1 L2 L3],'name','myRobot');
              base=transl(1,0,0);
              robot.base = base;
                                 

q = zeros(1,3);                                                     % Create a vector of initial joint angles        
scale = 0.5;
workspace = [-2 2 -2 2 -0.05 2];                                       % Set the size of the workspace when drawing the robot
% robot.plot(q,'workspace',workspace,'scale',scale);                  % Plot the robot 
robot = dorobot('robot',robotbase);

%%
centerpnt = [2,0,-0.5];
side = 1.5;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
axis equal
camlight
% pPoints = [1.25,0,-0.5 ...
%         ;2,0.75,-0.5 ...
%         ;2,-0.75,-0.5 ...
%         ;2.75,0,-0.5];
% pNormals = [-1,0,0 ...
%             ; 0,1,0 ...
%             ; 0,-1,0 ...
%             ;1,0,0];
robot.teach;

%%
tr = zeros(4,4,robot.n+1);
tr(:,:,1) = robot.base;
L = robot.links;
for i = 1 : robot.n
    tr(:,:,i+1) = tr(:,:,i) * trotz(q(i)+L(i).offset) * transl(0,0,L(i).d) * transl(L(i).a,0,0) * trotx(L(i).alpha);
end

%%
for i = 1 : size(tr,3)-1    
    for faceIndex = 1:size(faces,1)
        vertOnPlane = vertex(faces(faceIndex,1)',:);
        [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
        if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
            plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
            disp('Intersection');
        end
    end    
end
%%
q1 = [-pi/4,0,0];
q2 = [pi,0,0];
steps = 2;
while ~isempty(find(1 < abs(diff(rad2deg(jtraj(q1,q2,steps)))),1))
    steps = steps + 1;
end
 qMatrix = jtraj(q1,q2,steps);

% 2.7
result = true(steps,1);
for i = 1: steps
    result(i) = IsCollision(robot,qMatrix(i,:),faces,vertex,faceNormals,false);
    robot.animate(qMatrix(i,:));
end
% %% 
% robot.animate(q1);
% robot.teach
% qWaypoints = [q1 ...
%     ; -pi/4,deg2rad([-111,-72]) ...
%     ; deg2rad([169,-111,-72]) ...
%     ; q2];
% qMatrix = InterpolateWaypointRadians(qWaypoints,deg2rad(5));
% if IsCollision(robot,qMatrix,faces,vertex,faceNormals)
%     error('Collision detected!!');
% else
%     display('No collision found');
% end
% robot.animate(qMatrix);

% %%
% robot.animate(q1);
% qWaypoints = [q1;q2];
% isCollision = true;
% checkedTillWaypoint = 1;
% qMatrix = [];
% while (isCollision)
%     startWaypoint = checkedTillWaypoint;
%     for i = startWaypoint:size(qWaypoints,1)-1
%         qMatrixJoin = InterpolateWaypointRadians(qWaypoints(i:i+1,:),deg2rad(10));
%         if ~IsCollision(robot,qMatrixJoin,faces,vertex,faceNormals)
%             qMatrix = [qMatrix; qMatrixJoin]; %#ok<AGROW>
%             robot.animate(qMatrixJoin);
%             size(qMatrix)
%             isCollision = false;
%             checkedTillWaypoint = i+1;
%             % Now try and join to the final goal (q2)
%             qMatrixJoin = InterpolateWaypointRadians([qMatrix(end,:); q2],deg2rad(10));
%             if ~IsCollision(robot,qMatrixJoin,faces,vertex,faceNormals)
%                 qMatrix = [qMatrix;qMatrixJoin];
%                 % Reached goal without collision, so break out
%                 break;
%             end
%         else
%             % Randomly pick a pose that is not in collision
%             qRand = (2 * rand(1,3) - 1) * pi;
%             while IsCollision(robot,qRand,faces,vertex,faceNormals)
%                 qRand = (2 * rand(1,3) - 1) * pi;
%             end
%             qWaypoints =[ qWaypoints(1:i,:); qRand; qWaypoints(i+1:end,:)];
%             isCollision = true;
%             break;
%         end
%     end
% end

%% IsIntersectionPointInsideTriangle
% Given a point which is known to be on the same plane as the triangle
% determine if the point is 
% inside (result == 1) or 
% outside a triangle (result ==0 )
function result = IsIntersectionPointInsideTriangle(intersectP,triangleVerts)

u = triangleVerts(2,:) - triangleVerts(1,:);
v = triangleVerts(3,:) - triangleVerts(1,:);

uu = dot(u,u);
uv = dot(u,v);
vv = dot(v,v);

w = intersectP - triangleVerts(1,:);
wu = dot(w,u);
wv = dot(w,v);

D = uv * uv - uu * vv;

% Get and test parametric coords (s and t)
s = (uv * wv - vv * wu) / D;
if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
    result = 0;
    return;
end

t = (uv * wu - uu * wv) / D;
if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
    result = 0;
    return;
end

result = 1;                      % intersectP is in Triangle
end

%% IsCollision
% This is based upon the output of questions 2.5 and 2.6
% Given a robot model (robot), and trajectory (i.e. joint state vector) (qMatrix)
% and triangle obstacles in the environment (faces,vertex,faceNormals)
function result = IsCollision(robot,qMatrix,faces,vertex,faceNormals,returnOnceFound)
if nargin < 6
    returnOnceFound = true;
end
result = false;

for qIndex = 1:size(qMatrix,1)
    % Get the transform of every joint (i.e. start and end of every link)
    tr = GetLinkPoses(qMatrix(qIndex,:), robot);

    % Go through each link and also each triangle face
    for i = 1 : size(tr,3)-1   
        for faceIndex = 1:size(faces,1)
            vertOnPlane = vertex(faces(faceIndex,1)',:);
            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
            if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
                disp('collision detected');
                pause ()  ;
                result = true;
                if returnOnceFound
                    return
                end
            end
        end    
    end
end
end

%% GetLinkPoses
% q - robot joint angles
% robot -  seriallink robot model
% transforms - list of transforms
function [ transforms ] = GetLinkPoses( q, robot)

links = robot.links;
transforms = zeros(4, 4, length(links) + 1);
transforms(:,:,1) = robot.base;

for i = 1:length(links)
    L = links(1,i);
    
    current_transform = transforms(:,:, i);
    
    current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
    transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
    transforms(:,:,i + 1) = current_transform;
end
end

%% FineInterpolation
% Use results from Q2.6 to keep calling jtraj until all step sizes are
% smaller than a given max steps size
function qMatrix = FineInterpolation(q1,q2,maxStepRadians)
if nargin < 3
    maxStepRadians = deg2rad(1);
end
    
steps = 2;
while ~isempty(find(maxStepRadians < abs(diff(jtraj(q1,q2,steps))),1))
    steps = steps + 1;
end
qMatrix = jtraj(q1,q2,steps);
end

%% InterpolateWaypointRadians
% Given a set of waypoints, finely intepolate them
function qMatrix = InterpolateWaypointRadians(waypointRadians,maxStepRadians)
if nargin < 2
    maxStepRadians = deg2rad(1);
end

qMatrix = [];
for i = 1: size(waypointRadians,1)-1
    qMatrix = [qMatrix ; FineInterpolation(waypointRadians(i,:),waypointRadians(i+1,:),maxStepRadians)]; %#ok<AGROW>
end
end
