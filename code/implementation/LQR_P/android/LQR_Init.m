clear
clc
close all

% Load model parameters
quanser_aero_parameters;
% Load state-space matrices 
quanser_aero_state_space;
% 
%% State-Feedback LQR Control Design
% Q = diag([150 75 0 0 ]);
Q = diag([200 75 0 0 ]);
R = 0.005*eye(2,2);
K = lqr(A,B,Q,R)

% clearvars -except K