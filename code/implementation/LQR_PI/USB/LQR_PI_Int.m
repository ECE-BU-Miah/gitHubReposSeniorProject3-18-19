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
Q_hat = diag([50 50 1 1 10 0.3]);  % Miah
%Q_hat = diag([ 250 75 0 0 100 100]); 
R_hat = 0.0001*eye(m,m); % Miah
%R_hat = 0.001*eye(m,m); % Quanser
K_hat = lqr(A_hat,B_hat,Q_hat,R_hat);  % Controller gain matrix

K = 1.35*K_hat(1:m,1:n);
%K = K_hat(1:m,1:n);
Ki = -K_hat(1:m,n+1:n+p);

