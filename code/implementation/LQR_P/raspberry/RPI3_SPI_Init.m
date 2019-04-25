
%rpi = raspi('192.168.1.79','pi','raspberry');   %Raspberry Pi 1
rpi = raspi('192.168.1.20','pi','raspberry');   %Raspberry Pi 2

enableSPI(rpi);
disableSPI(rpi);

% Configure pins on Raspberry Pi for the SPI comunication
% MOSI Output
configurePin(rpi, 10,'DigitalOutput');
% SPI Clock Output
configurePin(rpi, 11,'DigitalOutput');
% SS Output
configurePin(rpi, 8,'DigitalOutput');
% MISO Input
configurePin(rpi, 9,'DigitalInput');

% SPI output clock period 2us (500kHz)
spiPeriod = 0.0001;

enableSPI(rpi);

clearvars -except rpi spiPeriod K