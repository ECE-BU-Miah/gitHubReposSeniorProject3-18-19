function KV_LQRContinuousTime
%% Setup Differential Equation
close all
clear
clc

quanser_aero_parameters;  % contains parameters Quanser Aero
quanser_aero_state_space;  % puts parameters into state-space model 

Q = diag([3500 500 0 0 ]); % Quadratic term
R = 0.005*eye(2,2);  % Regulator term
K = lqr(A,B,Q,R);

xInit = zeros(1,4);  % set the initial conditions to 0 degrees pitch
                     % and 0 degrees yaw
xD = [deg2rad(10) deg2rad(45) 0 0]';  % desided position is 45 degrees 
                                      % pitch and 90 degrees yaw
eInit = xD'-xInit;  % error matrix is desired transposed minus actual

maxInputVoltage = 18; % cannot exceed this output in [V]

options = odeset('RelTol', 1e-4, 'AbsTol', 1e-4*ones(1,4));

t_sim = 10; % [sec]
[Te,E] = ode45(@(t,e) stateEqn(t,e,A,B,K,xD,maxInputVoltage),[0 t_sim/2],...
    eInit, options);
xD=-xD;
[Te,E] = ode45(@(t,e) stateEqn(t,e,A,B,K,xD,maxInputVoltage),[t_sim/2 t_sim],...
    eInit, options);
%% Position Error Graph
figure; 
e_1 = plot(Te,rad2deg(E(:,1)),'-','LineWidth', 1.5);
hold on
e_2 = plot(Te,rad2deg(E(:,2)),'--','LineWidth', 1.5);
hold on
e_3 = plot(Te,rad2deg(E(:,3)),'-.','LineWidth', 1.5);
hold on
e_4 = plot(Te,rad2deg(E(:,4)),':','LineWidth', 1.5);

xlabel('Time [s]');
ylabel('Error [deg]');
title('Error');
legend([e_1 e_2 e_3 e_4],{'$e_\theta$~[deg]', '$e_\psi$~[deg]',...
    '$e_{\dot\theta}$~[deg/s]','$e_{\dot\psi}$~[deg/s]'},...
    'Interpreter', 'latex');

grid on

%% Position Graph
for i=1:size(E,1)
    u(i,:) = (K*(E(i,:))')';
    uLimit(i,:) = sign(u(i,:)).*min(abs(u(i,:)),[maxInputVoltage,...
        maxInputVoltage]);
end

xDt = repmat(xD',size(E,1),1); % repeat xDt for all time instants
QuanserAeroStates = xDt - E;

figure;
theta = plot(Te,rad2deg(QuanserAeroStates(:,1)),'-','LineWidth', 1.5);
hold on
psi = plot(Te,rad2deg(QuanserAeroStates(:,2)),'--','LineWidth', 1.5);
hold on
thetaD = plot(Te,rad2deg(xDt(:,1)),'-.','LineWidth', 2);
hold on
psiD = plot(Te,rad2deg(xDt(:,2)),'--','LineWidth', 2);

xlabel('Time [s]');
ylabel('Position [deg]');
title('Position');
legend([theta psi thetaD psiD],{'$\theta$', '$\psi$','${\theta^d}$',...
    '${\psi^d}$'}, 'Interpreter', 'latex');
grid on

%% Voltage Graph
figure;
vP = plot(Te,uLimit(:,1),'-','LineWidth', 1.5);
hold on
vY = plot(Te,uLimit(:,2),'--','LineWidth', 1.5);

xlabel('Time [s]');
ylabel('Input Voltage [V]');
title('Voltages');
legend([vP vY],'V_p(t) [V]', 'V_y(t) [V]');
grid on

function eDot = stateEqn(t,e,A,B,K,xD,uMax)
    u = K*e;
    uLimit = sign(u).*min(abs(u),[uMax;uMax]);
    eDot = A*e-B*uLimit - A*xD; 