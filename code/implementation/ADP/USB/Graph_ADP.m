close all
clc
%% Load Data
% load ADP_USB_Constant.mat
% load RMSE_LQR_Quanser.mat

%% Assign data to variable names 

ADP_t = ADP_USB_Constant(1,:);
ADP_pitch_volt = ADP_USB_Constant(2,:);
ADP_pitch_d = ADP_USB_Constant(3,:);
ADP_pitch_a = ADP_USB_Constant(4,:);
ADP_yaw_volt = ADP_USB_Constant(5,:);
ADP_yaw_d_ = ADP_USB_Constant(6,:);
ADP_yaw_a = ADP_USB_Constant(7,:);

LQR_t = RMSE_LQR_Quanser(1,:);
LQR_pitch_volt = RMSE_LQR_Quanser(2,:);
LQR_pitch_d = RMSE_LQR_Quanser(3,:);
LQR_pitch_a = RMSE_LQR_Quanser(4,:);
LQR_yaw_volt = RMSE_LQR_Quanser(5,:);
LQR_yaw_d_ = RMSE_LQR_Quanser(6,:);
LQR_yaw_a = RMSE_LQR_Quanser(7,:);

%% Aquire size of data
ADP_N = size(ADP_t);
ADP_N = ADP_N(2);

LQR_N = size(LQR_t);
LQR_N = LQR_N(2);

%% Calculate RMSE
%ADP RMSE
ADP_p_e = ADP_pitch_d - ADP_pitch_a;
ADP_p_e = ADP_p_e.^2;
ADP_RMSE_p = sum(ADP_p_e);
ADP_RMSE_p = 1/ADP_N*ADP_RMSE_p;
ADP_RMSE_p = sqrt(ADP_RMSE_p)
%RMSE_p_quanser = 4.2469
ADP_y_e = ADP_yaw_d_ - ADP_yaw_a;
ADP_y_e = ADP_y_e.^2;
ADP_RMSE_y = sum(ADP_y_e);
ADP_RMSE_y = 1/ADP_N*ADP_RMSE_y;
ADP_RMSE_y = sqrt(ADP_RMSE_y)
%RMSE_y_quanser = 4.8644

%LQR RMSE
LQR_p_e = LQR_pitch_d - LQR_pitch_a;
LQR_p_e = LQR_p_e.^2;
LQR_RMSE_p = sum(LQR_p_e);
LQR_RMSE_p = 1/LQR_N*LQR_RMSE_p;
LQR_RMSE_p = sqrt(LQR_RMSE_p)

LQR_y_e = LQR_yaw_d_ - LQR_yaw_a;
LQR_y_e = LQR_y_e.^2;
LQR_RMSE_y = sum(LQR_y_e);
LQR_RMSE_y = 1/LQR_N*LQR_RMSE_y;
LQR_RMSE_y = sqrt(LQR_RMSE_y)

%% Graphs
%Pitch
figure
plot(ADP_t, ADP_pitch_d,'--', 'LineWidth', 1.5)
hold on
plot(ADP_t, ADP_pitch_a,'-.', 'LineWidth', 1.5)
hold on
plot(LQR_t, LQR_pitch_a, 'LineWidth', 1.5)
grid
legend({'$\theta_d$~[deg]', '$\theta_{ADP}$~[deg]', '$\theta_{LQR}$~[deg]'}, 'Interpreter', 'latex');
%'location',[0.85 0.5 0 0])
ylim([-1 15])
xlabel('time(s)')
ylabel('Pitch(deg)')
%title('Pitch Orientation')

savefilename = 'OUT/Pitch_ADP_LQR';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

%Yaw
figure
plot(ADP_t, ADP_yaw_d_,'--', 'LineWidth', 1.5)
hold on
plot(ADP_t, ADP_yaw_a,'-.', 'LineWidth', 1.5)
hold on
plot(LQR_t, LQR_yaw_a, 'LineWidth', 1.5)
grid
legend({'$\psi_d$~[deg]', '$\psi_{ADP}$~[deg]', '$\psi_{LQR}$~[deg]'}, 'Interpreter', 'latex','location','SouthEast')
ylim([-1 62])
xlabel('time(s)')
ylabel('Yaw(deg)')
%title('Yaw Orientation')

savefilename = 'OUT/Yaw_ADP_LQR';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

%Pitch Voltage
figure
plot(ADP_t, ADP_pitch_volt)
hold on
plot(LQR_t, LQR_pitch_volt,'--')
grid
ylim([-20 20])
xlabel('time(s)')
ylabel('Pitch(V)')
%title('Pitch Voltage')
legend({'$V_{ADP}$~[V]', '$V_{LQR}$~[V]'}, 'Interpreter', 'latex','location','NorthEast')
savefilename = 'OUT/PitchVoltage_ADP_LQR';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);


%Yaw Voltage
figure
plot(ADP_t, ADP_yaw_volt)
hold on
plot(LQR_t, LQR_yaw_volt,'--')
grid
ylim([-20 20])
xlabel('time(s)')
ylabel('Yaw(V)')
%title('Yaw Voltage')
legend({'$V_{ADP}$~[V]', '$V_{LQR}$~[V]'}, 'Interpreter', 'latex','location','NorthEast')
savefilename = 'OUT/YawVoltage_ADP_LQR';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

