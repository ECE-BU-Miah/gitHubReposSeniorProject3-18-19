close all
clear
clc
 
% Important dimensions for the system
n = 4; % Dimension of state equation (number of state variables)
m = 2; % input dimension
p = 2; % output dimension
% Define system matrix 
% Load model parameters
quanser_aero_parameters;
% Load state-space matrices 
quanser_aero_state_space;
% 

% LQR formulation
A_hat = [A zeros(n,p);
         -C zeros(p,p)];
B_hat = [B;zeros(p,m)];

%% State-Feedback LQR Control Design
Q_hat = diag([1 1 1 1 50 50]);
%Q_hat = diag([0.009 1 0 0 500 1]);  % n+p sq. matrix
%Q_hat = diag([200 75 0 0 1 1]);  % n+p sq. matrix
R_hat = .00001*eye(m,m);
K_hat = lqr(A_hat,B_hat,Q_hat,R_hat);  % Controller gain matrix

K = K_hat(1:m,1:n);
Ki = -K_hat(1:m,n+1:n+p);
%less than 3 more than 2

Kout = diag([0.25 1]);

%%%%%%%%%%%%%%%%%% weight for Kalman estimator %%%%%%%%%%%%%%
Qe =.001*diag(ones(1,n));
Re =.001*diag(ones(size(C,1)));
Bw = eye(n);
