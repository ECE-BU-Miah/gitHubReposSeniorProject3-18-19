% CRITIC WEIGHT TUNING NEURAL NETWORK
% This function is specific to the helicopter because of the number of
% weights and error model
% THIS FUNCTION CANNOT HAVE ANY ANONYMOUS FUNCTIONS DUE TO THE C CODE
% GENERATION UNSUPPORTING IT
function K = quanserAEROCriticTuning(xd,pitchData,yawData,pitchDotData,yawDotData,wcInit)
    % CREATE THE ERROR VECTOR MATRIX
    % Use the data from the tapped delay blocks to create the error state
    % vector matrix
    e_vec = [pitchData'; yawData'; pitchDotData'; yawDotData'];
    
    % REFERENCE DR. MIAH'S PAPER FOR EQUATION NUMBERS
    % Sampling time [s]
    tau = 0.05;
    
    % COST FUNCTION
    % Q and R matrices used in the cost function
    Q_Mat = diag([270 100 1 1]);
    R_Mat = 0.005*diag([1 1]);
    
    % SYSTEM PARAMETERS SPECIFIC TO THE 2-DOF QUANSER AERO
    A = [0 0 1 0; 0 0 0 1; -1.7442 0 -0.3307 0; 0 0 0 -0.9283];
    B = [0 0; 0 0; -0.0149 0.0414; -0.0751 -0.1295];
    % UNCOMMENT TO USE A STATE-SPACE MODEL THAT IS NOT THE CORRECT ONE DERIVED
    % A = [1 1 1 1; 1 1 1 1; 1 1 1 1; 1 1 1 1];
    % B = [0 0; 0 0; 0.1 0.1; -0.3 -0.3];
    % System dimensions specific for our model
    [n,~] = size(B);
    
    % ERROR MODEL OF THE HELICOPTER
    % gbar and hbar -- EQ 8
    % An anonymous function cannot be used for fbar
    gbar = -B;
    hbar = -A*xd;
    
    % DISCRETE-TIME ERROR MODEL FOR TIME TAU
    % g and h -- EQ 10
    % An anonymous function cannot be used for f
    g = gbar*tau;
    h = hbar*tau;
    
    % COST FUNCTION PARAMETERS
    % The Q matrix cannot be treated as an anonymous function as in the
    % MATLAB simulations
    % Control penalizing matrix in the continuous cost function
    Rbar = R_Mat;
    % The discrete-time cost function will have terms:
    % Right after EQ 11 in paper
    % Control penalizing matrix in the discretized cost function
    R = Rbar*tau;
    
    % NEURAL NETWORK FUNCTIONS
    % These functions cannot be written as anonymous functions as in the
    % MATLAB simulations
    
    % TOLERANCES
    % Convergence tolerance for control policy 
    EpsilonPolicy = 0.1;
    % Convergence tolerance for critic neural network
    EpsilonWcritic = 0.1;
    
    % TRAINING PARAMETERS
    % Number of outer loop iterations
    outerLoopMax = 700;
    % Number of inner loop iterations
    innerLoopMax = 100;
    % Number of equations needed for training, number of sub-intervals
    % Number of training samples
    [~,nbar] = size(e_vec);

    % WEIGHT INITIALIZATION
    % Initialize the weights of the critic neural network to zero
    % Number of rows hard-coded for the helicopter
    WcLast = zeros(14,1);
    
    % LEAST-SQUARES COMPUTATION INITIALIZATION
    % Matrices required for computing least squares weights of the critic 
    % neural networks -- EQ 20
    V = zeros(nbar,1);
    Lambda = zeros(nbar,14);
    
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
                % Because of no anonymous functions we have modified f
                % fbar = @(e) A*e;
                % f = @(e) fbar(e)*tau + e;
                e_k_plus_1(:,k) = (A*e_vec(:,k)*tau) + e_vec(:,k) + g*uLast + h;
                % Compute the new optimal inputs
                % Partial derivative of rho with respect to e
                drhode = [1, 0, 0, 0;
                          0, 1, 0, 0;
                          0, 0, 1, 0;
                          0, 0, 0, 1;
                          2*e_vec(1,k), 0, 0, 0;
                          e_vec(2,k), e_vec(1,k), 0, 0;
                          e_vec(3,k), 0, e_vec(1,k), 0;
                          e_vec(4,k), 0, 0, e_vec(1,k);
                          0, 2*e_vec(2,k), 0, 0;
                          0, e_vec(3,k), e_vec(2,k), 0;
                          0, e_vec(4,k), 0, e_vec(2,k);
                          0, 0, 2*e_vec(3,k), 0;
                          0, 0, e_vec(4,k), e_vec(3,k);
                          0, 0, 0, 2*e_vec(4,k)];
                uNew  = -0.5*(R^(-1))*g'*drhode'*WcLast;
                
                % Check convergence of the optimal inputs
                if norm(uNew - uLast) < EpsilonPolicy
                    break;
                end
            end

            % Update the values for the least-squares computation
            % Critic neural network activation functions
            rhoE = [e_vec(1,k); e_vec(2,k); e_vec(3,k); e_vec(4,k);...
                    e_vec(1,k)^2; e_vec(1,k)*e_vec(2,k);...
                    e_vec(1,k)*e_vec(3,k); e_vec(1,k)*e_vec(4,k);...
                    e_vec(2,k)^2; e_vec(2,k)*e_vec(3,k);...
                    e_vec(2,k)*e_vec(4,k); e_vec(3,k)^2;...
                    e_vec(3,k)*e_vec(4,k); e_vec(4,k)^2];
           rhoEK = [e_k_plus_1(1,k); e_k_plus_1(2,k); e_k_plus_1(3,k);...
                    e_k_plus_1(4,k); e_k_plus_1(1,k)^2;...
                    e_k_plus_1(1,k)*e_k_plus_1(2,k);...
                    e_k_plus_1(1,k)*e_k_plus_1(3,k);...
                    e_k_plus_1(1,k)*e_k_plus_1(4,k);...
                    e_k_plus_1(2,k)^2; e_k_plus_1(2,k)*e_k_plus_1(3,k);...
                    e_k_plus_1(2,k)*e_k_plus_1(4,k); e_k_plus_1(3,k)^2;...
                    e_k_plus_1(3,k)*e_k_plus_1(4,k); e_k_plus_1(4,k)^2];
            % State penalizing function in the continuous cost function
            % Qbar = @(e) e'*Q_Mat*e; 
            % State penalizing function in the discretized cost function
            % Q = @(e) Qbar(e)*tau;
            V(k,:) = (e_vec(:,k)'*Q_Mat*e_vec(:,k)*tau) + uNew'*R*uNew + WcLast'*rhoEK;
            Lambda(k,:) = rhoE';
        end
    end

    % Verify the least square solution exists for the critic's weights
    % If the error data is consistent or there is no error, this will not
    % hold, so set the weights to what they were initially before the
    % simulation
    if det(Lambda'*Lambda) == 0
        weights = wcInit;
        break;
    end;

    % Calulcate least squares solution of critic's weights -- EQ 20
    WcNew = (Lambda'*Lambda)^(-1)*Lambda'*V;
    % Make sure the weights did not diverge
    % If the weights diverged, set the weights to what they were initially
    % before the simulation
    if isnan(WcNew)
        weights = wcInit;
        break;
    % Check for convergence of the critic weights
    elseif norm(WcNew - WcLast) < EpsilonWcritic               
        weights = WcNew;
        break;
    % If we reach the last iteration of the loop, just use the last weights
    elseif (i == (outerLoopMax-1))
        weights = WcNew;
    % If all else fails, just set the weights to the initial weights
    else
        weights = wcInit;
    end
    % If the weights did not converge, do another iteration of the loop
    WcLast = WcNew;
    end
    
    % Use the weights to determine the P matrix
    P_Mat = [weights(5) weights(6) weights(7) weights(8);
             weights(6) weights(9) weights(10) weights(11);
             weights(7) weights(10) weights(12) weights(13);
             weights(8) weights(11) weights(13) weights(14)];

    % Find the state-feedback gain EQ
    K = 0.5*(R_Mat^-1)*B'*P_Mat;
end
