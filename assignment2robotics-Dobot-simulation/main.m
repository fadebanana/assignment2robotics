%% clear
clc;
clf;
%% load robot
robotbase = eye(4);
camlight;
robot = dorobot('robot',robotbase);
%% Movement
%function : move2knowlocation() & move2unknowlocation()
robot.plotCloud();