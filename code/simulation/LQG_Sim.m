% function LQR_ServoMiahV0
% Written by Dr. Miah, Jan. 7, 2019
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
Q_hat = diag([1 1 1 1 10 1]);  % n+p sq. matrix
R_hat = 0.01*eye(m,m);
K_hat = lqr(A_hat,B_hat,Q_hat,R_hat);  % Controller gain matrix

K = K_hat(1:m,1:n);
Ki = -K_hat(1:m,n+1:n+p);

%%%%%%%%%%%%%%%%%% weight for Kalman estimator %%%%%%%%%%%%%%
Qe =diag(ones(1,n));
Re =diag(ones(size(C,1)));
Bw = eye(n);
