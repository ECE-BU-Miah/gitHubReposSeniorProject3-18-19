clc
close all

pitch_d = Pitch.signals.values(:,1);
pitch_a = Pitch.signals.values(:,2);

yaw_d = Yaw.signals.values(:,2);
yaw_a = Yaw.signals.values(:,1);

P_volt = Voltage.signals.values(:,1);
Y_volt = Voltage.signals.values(:,2);

%Pitch
figure
pD=plot(Pitch.time,pitch_d);
hold on 
pA=plot(Pitch.time,pitch_a);
grid
xlabel('Time [s]')
ylabel('Position [deg]')
legend([pD, pA],{'$\theta^{d}$','$\theta$'},'Interpreter','latex','location','SouthEast')

savefilename = 'OUT/Pitch_LQG_Sim';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

%Yaw
figure
yD=plot(Yaw.time,yaw_d);
hold on 
yA=plot(Yaw.time,yaw_a);
grid
xlabel('Time [s]')
ylabel('Position [deg]')
legend([yD, yA],{'$\psi^{d}$','$\psi$'},'Interpreter','latex','location','SouthEast')

savefilename = 'OUT/Yaw_LQG_Sim';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

%Pitch Volt
figure
pV=plot(Voltage.time,P_volt);
grid
xlabel('Time [s]')
ylabel('Voltage [V]')
%legend([pD, pA],{'$\theta^{d}$','$\theta$'},'Interpreter','latex','location','SouthEast')

savefilename = 'OUT/Pitch_Volt_LQG_Sim';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);

%Yaw Volt
figure
yV=plot(Voltage.time,Y_volt);
grid
xlabel('Time [s]')
ylabel('Voltage [V]')

savefilename = 'OUT/Yaw_Volt_LQG_Sim';
saveas (gcf,savefilename,'fig');
print('-depsc2', '-r300', [savefilename,'.eps']);