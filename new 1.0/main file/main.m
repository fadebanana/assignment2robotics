%% Clear
clc;
clear;
%% GUI load
app1
%% Load Robot
robotbase = eye(4)*transl(0,0.4,-0.41);
Flag = 0;
camlight;
axis equal
robot = dorobot('robot',robotbase);
hold on
%% Load environment
environment
%% Get Reach
%robot.plotCloud();
pause();
%% get data
load('testdata.mat')
xaxis = ans(:,1);
yaxis = ans(:,2);
%% Movement
%function : move2knowlocation() & move2unknowlocation()
for i = 1:size(xaxis)
    location = eye(4)*transl(xaxis(i,1),yaxis(i,1),-0.29)*trotx(pi/2);
    movement.move2unknowlocation(robot,location);
    plot3(xaxis(i,1),yaxis(i,1),-0.4,'b.')
    hold on
end
    location1 = eye(4)*transl(xaxis(1,1),yaxis(1,1),-0.29)*trotx(pi/2);         %return 2 start point
    movement.move2unknowlocation(robot,location1);
    movement.move2knowlocation(robot,deg2rad([0,80,-70,0]))

