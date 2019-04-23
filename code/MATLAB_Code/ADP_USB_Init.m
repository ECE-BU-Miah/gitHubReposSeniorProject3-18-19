%Glenn Janiak & Ken Vonckx
close all;
clear;
clc;

quanser_aero_parameters;
quanser_aero_state_space;

% Sampling time [s]
tau = 0.05;
% Update time [s]
T = 1;

% COST FUNCTION
% Q and R matrices used in the cost function
Q_Mat_ADP = diag([270 100 1 1]);
R_Mat_ADP = 0.005*diag([1 1]);

[n,~] = size(B);

nbar = 100;     % Why is this 100, we would think this would be
                % T/tau = 20 
               
e_vec = (2*(pi)).*rand(n,nbar) - (pi); % does this initialize 
                                       % the weights?

% What are fbar and gbar
fbar = @(e) A*e;
gbar = -B;

f = @(e) fbar(e)*tau + e;
g = gbar*tau;

% ???
Qbar = @(e) e'*Q_Mat_ADP*e; 
Rbar = R_Mat_ADP;

Q = @(e) Qbar(e)*tau;
R = Rbar*tau;

% Is this the P matrix

rho = @(e) [e(1); e(2); e(3); e(4);...
            e(1)^2; e(1)*e(2); e(1)*e(3); e(1)*e(4);...
            e(2)^2; e(2)*e(3); e(2)*e(4); e(3)^2; e(3)*e(4); e(4)^2];

drhode =@(e) [1, 0, 0, 0;
              0, 1, 0, 0;
              0, 0, 1, 0;
              0, 0, 0, 1;
              2*e(1), 0, 0, 0;
              e(2), e(1), 0, 0;
              e(3), 0, e(1), 0;
              e(4), 0, 0, e(1);
              0, 2*e(2), 0, 0;
              0, e(3), e(2), 0;
              0, e(4), 0, e(2);
              0, 0, 2*e(3), 0;
              0, 0, e(4), e(3);
              0, 0, 0, 2*e(4)];

% Learning Rate
EpsilonPolicy = 0.1;
EpsilonWcritic = 0.1;

% Number of outer loop iterations
outerLoopMax = 700;
% Number of inner loop iterations
innerLoopMax = 100;

% So does this mean that T is iterated 700 times and 
% and inner loop is iterated 700/100 = 7 times per loop?

% Number of training samples
[~,nbar] = size(e_vec); % resizing nbar?

% WEIGHT INITIALIZATION
% Initialize the weights of the critic neural network to zero
WcLast = zeros(length(rho(e_vec(:,1))),1);

% LEAST-SQUARES COMPUTATION INITIALIZATION
% Matrices required for computing least squares weights of the critic 
% neural networks -- EQ 20
V = zeros(nbar,1);
Lambda = zeros(nbar,length(rho(e_vec(:,1))));

% Matrix to hold the derivative of the error model during policy
% updating
e_k_plus_1 = zeros(n,nbar);

% Product of the least squares matrices must be invertible
% Logic flag indicating if the critic weights are unsolvable
% The weights are unsolvable because the least squares matrices have no
% solution -- not invertible
diverged = 0;

% OUTER LOOP
for i = 1:(outerLoopMax-1)
% Determine if the least squares matrices are invertible
if diverged == 0
    % For each of the data collection (discrete time index)
    for k = 1:nbar
        % Initialize the optimal inputs to zero 
        uNew = [0; 0];
        % INNER LOOP
        for j = 1:(innerLoopMax-1)
            % Get the updated input value
            uLast = uNew;
            % Update the error model
            e_k_plus_1(:,k) = f(e_vec(:,k)) + g*uLast;
            % Compute the new optimal inputs
            uNew  = -0.5*(R^(-1))*g'*drhode(e_k_plus_1(:,k))'*WcLast;

            % Check convergence of the optimal inputs
            if norm(uNew - uLast) < EpsilonPolicy
                break;
            end
        end

        % Update the values for the least-squares computation
        V(k,:) = Q(e_vec(:,k)) + uNew'*R*uNew + WcLast'*rho(e_k_plus_1(:,k));
        Lambda(k,:) = rho(e_vec(:,k))';
    end
end

% Verify the least square solution exists for the critic's weights
% If the error data is consistent or there is no error, this will not
% hold, so set the weights to zero
if det(Lambda'*Lambda) == 0
    weights = zeros(length(rho(e_vec(:,1))),1);
    break;
end;

% Calculate least squares solution of critic's weights -- EQ 20
WcNew = (Lambda'*Lambda)^(-1)*Lambda'*V;
% Make sure the weights did not diverge
% If the weights are diverging, just set them to a large number
if isnan(WcNew)
    weights = 1000*ones(length(rho(e_vec(:,1))),1);
    break;
end;

% Check for convergence of the critic weights
if norm(WcNew - WcLast) < EpsilonWcritic               
    weights = WcNew;
    break;
end
% If the weights did not converge, repeat the loop
WcLast = WcNew;

% If we reached the last iteration of the loop, just use the last
% weights found
if (i == (outerLoopMax-1))
    weights = WcNew;
end
end

% Use the weights to determine the P matrix
P_Mat = [weights(5) weights(6) weights(7) weights(8);
         weights(6) weights(9) weights(10) weights(11);
         weights(7) weights(10) weights(12) weights(13);
         weights(8) weights(11) weights(13) weights(14)];

% Find the state-feedback gain EQ
K = 0.5*(R_Mat_ADP^-1)*B'*P_Mat;

% Save the initial weights
wcInit = weights;

% Keep only the ADP gain
clearvars -except K tau T wcInit;