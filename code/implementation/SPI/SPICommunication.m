% THIS FUNCTION CONTROLS THE SPI INTERFACING
% THIS FUNCTION DETERMINES WHAT DATA IS SENT TO THE QUANSER AERO AND WHAT
% DATA IS RETRIEVED FROM THE QUANSER AERO
function [MOSI,SS,pitchEncoder,yawEncoder,byteNumber,bitNumber,encoder2_23_16,encoder2_15_8,encoder2_7_0,encoder3_23_16,encoder3_15_8,encoder3_7_0] = fcn(MISO, pitchVolt,yawVolt,redValue,greenValue,blueValue,byteNumber,bitNumber,encoder2_23_16,encoder2_15_8,encoder2_7_0,encoder3_23_16,encoder3_15_8,encoder3_7_0)
% Variables used in the function
complement = '0000000000000000';
pitchEncoderBin = '000000000000000000000000';
yawEncoderBin = '000000000000000000000000';
tempBin = '00000000000000000000000000000000';
tempVoltBin = '00000000';

% Output the value of the pitch encoder using the latest byte values
% Combine all of the encoder bytes
pitchEncoderIn = [encoder2_23_16 encoder2_15_8 encoder2_7_0];
% Convert the encoder binary vector into a character array
for i = 1:24
    if (pitchEncoderIn(i) == 1)
        pitchEncoderBin(i) = '1';
    else
        pitchEncoderBin(i) = '0';
    end
end
% Calculate the 2's complement value of the encoder
if(pitchEncoderBin(1) == '1')
    for i = 1:32
        if (i < 9)
            tempBin(i) = '1';
        else
            tempBin(i) = pitchEncoderBin(i - 8);
        end
    end
else
    for i = 1:32
        if (i < 9)
            tempBin(i) = '0';
        else
            tempBin(i) = pitchEncoderBin(i - 8);
        end
    end
end
pitchEncoderTemp = typecast(uint32(bin2dec(tempBin)),'int32');
pitchEncoderOut = cast(pitchEncoderTemp,'double');
pitchEncoder = pitchEncoderOut(1);

% Output the value of the yaw encoder using the latest byte values
% Combine all of the encoder bytes
yawEncoderIn = [encoder3_23_16 encoder3_15_8 encoder3_7_0];
% Convert the encoder binary vector into a character array
for i = 1:24
    if (yawEncoderIn(i) == 1)
        yawEncoderBin(i) = '1';
    else
        yawEncoderBin(i) = '0';
    end
end
% Calculate the 2's complement value of the encoder
if(yawEncoderBin(1) == '1')
    for i = 1:32
        if (i < 9)
            tempBin(i) = '1';
        else
            tempBin(i) = yawEncoderBin(i - 8);
        end
    end
else
    for i = 1:32
        if (i < 9)
            tempBin(i) = '0';
        else
            tempBin(i) = yawEncoderBin(i - 8);
        end
    end
end
yawEncoderTemp = typecast(uint32(bin2dec(tempBin)),'int32');
yawEncoderOut = cast(yawEncoderTemp,'double');
yawEncoder = yawEncoderOut(1);

% Determine which byte we are currently sending
% Specify the slave select value
% - 0 to activate the SPI on the Quanser AERO
% - 1 to de-activate the SPI on the Quanser AERO
% Determine the what the byte to be transmitted should be
switch byteNumber
    case 0
    % ** START OF BASE PACKET **
    % BYTE 0
    % MOSI DATA - BASE MODE (0X01)
    % MISO DATA - BASE ID MSB
    % Beginning of the transmission, so SS goes low
    SS = 0;
    readyMOSI = dec2bin(1,8);        

    case 1
    % BYTE 1
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - BASE ID LSB
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 2
    % BYTE 2
    % MOSI DATA - BASE WRITE MASK
    % MISO DATA - ENCODER 2 (23-16)
    SS = 0;
    % Enable the overwriting of encoders 2 and 3 and the LED colors
    % Bit 4 - Set encoder 3 enable
    % Bit 3 - Set encoder 2 enable
    % Bit 2 - Write blue LED
    % Bit 1 - Write green LED
    % Bit 0 - Write red LED
    % Don't want to overwrite the encoder values
    readyMOSI = dec2bin(7,8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder2_23_16(1) = 1;
            else
                encoder2_23_16(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder2_23_16(2) = 1;
            else
                encoder2_23_16(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder2_23_16(3) = 1;
            else
                encoder2_23_16(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder2_23_16(4) = 1;
            else
                encoder2_23_16(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder2_23_16(5) = 1;
            else
                encoder2_23_16(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder2_23_16(6) = 1;
            else
                encoder2_23_16(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder2_23_16(7) = 1;
            else
                encoder2_23_16(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder2_23_16(8) = 1;
            else
                encoder2_23_16(8) = 0;
            end
    end
    
    case 3
    % BYTE 3
    % MOSI DATA - RED LED MSB
    % MISO DATA - ENCODER 2 (15-8)
    SS = 0;
    readyMOSI = dec2bin(redValue(1),8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder2_15_8(1) = 1;
            else
                encoder2_15_8(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder2_15_8(2) = 1;
            else
                encoder2_15_8(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder2_15_8(3) = 1;
            else
                encoder2_15_8(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder2_15_8(4) = 1;
            else
                encoder2_15_8(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder2_15_8(5) = 1;
            else
                encoder2_15_8(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder2_15_8(6) = 1;
            else
                encoder2_15_8(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder2_15_8(7) = 1;
            else
                encoder2_15_8(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder2_15_8(8) = 1;
            else
                encoder2_15_8(8) = 0;
            end
    end

    case 4
    % BYTE 4
    % MOSI DATA - RED LED LSB
    % MISO DATA - ENCODER 2 (7-0)
    SS = 0;
    readyMOSI = dec2bin(redValue(2),8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder2_7_0(1) = 1;
            else
                encoder2_7_0(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder2_7_0(2) = 1;
            else
                encoder2_7_0(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder2_7_0(3) = 1;
            else
                encoder2_7_0(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder2_7_0(4) = 1;
            else
                encoder2_7_0(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder2_7_0(5) = 1;
            else
                encoder2_7_0(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder2_7_0(6) = 1;
            else
                encoder2_7_0(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder2_7_0(7) = 1;
            else
                encoder2_7_0(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder2_7_0(8) = 1;
            else
                encoder2_7_0(8) = 0;
            end
    end

    case 5
    % BYTE 5
    % MOSI DATA - GREEN LED MSB
    % MISO DATA - ENCODER 3 (23-16)
    SS = 0;
    readyMOSI = dec2bin(greenValue(1),8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder3_23_16(1) = 1;
            else
                encoder3_23_16(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder3_23_16(2) = 1;
            else
                encoder3_23_16(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder3_23_16(3) = 1;
            else
                encoder3_23_16(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder3_23_16(4) = 1;
            else
                encoder3_23_16(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder3_23_16(5) = 1;
            else
                encoder3_23_16(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder3_23_16(6) = 1;
            else
                encoder3_23_16(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder3_23_16(7) = 1;
            else
                encoder3_23_16(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder3_23_16(8) = 1;
            else
                encoder3_23_16(8) = 0;
            end
    end

    case 6
    % BYTE 6
    % MOSI DATA - GREEN LED LSB
    % MISO DATA - ENCODER 3 (15-8)
    SS = 0;
    readyMOSI = dec2bin(greenValue(2),8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder3_15_8(1) = 1;
            else
                encoder3_15_8(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder3_15_8(2) = 1;
            else
                encoder3_15_8(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder3_15_8(3) = 1;
            else
                encoder3_15_8(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder3_15_8(4) = 1;
            else
                encoder3_15_8(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder3_15_8(5) = 1;
            else
                encoder3_15_8(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder3_15_8(6) = 1;
            else
                encoder3_15_8(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder3_15_8(7) = 1;
            else
                encoder3_15_8(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder3_15_8(8) = 1;
            else
                encoder3_15_8(8) = 0;
            end
    end

    case 7
    % BYTE 7
    % MOSI DATA - BLUE LED MSB
    % MISO DATA - ENCODER 3 (7-0)
    SS = 0;
    readyMOSI = dec2bin(blueValue(1),8);
    % Receive the MISO byte bit by bit and update the vector holding the
    % byte
    switch bitNumber
        case 1
            if (MISO == true)
                encoder3_7_0(1) = 1;
            else
                encoder3_7_0(1) = 0;
            end
        case 2
            if (MISO == true)
                encoder3_7_0(2) = 1;
            else
                encoder3_7_0(2) = 0;
            end
        case 3
            if (MISO == true)
                encoder3_7_0(3) = 1;
            else
                encoder3_7_0(3) = 0;
            end
        case 4
            if (MISO == true)
                encoder3_7_0(4) = 1;
            else
                encoder3_7_0(4) = 0;
            end
        case 5
            if (MISO == true)
                encoder3_7_0(5) = 1;
            else
                encoder3_7_0(5) = 0;
            end
        case 6
            if (MISO == true)
                encoder3_7_0(6) = 1;
            else
                encoder3_7_0(6) = 0;
            end
        case 7
            if (MISO == true)
                encoder3_7_0(7) = 1;
            else
                encoder3_7_0(7) = 0;
            end
        case 8
            if (MISO == true)
                encoder3_7_0(8) = 1;
            else
                encoder3_7_0(8) = 0;
            end
    end

    case 8
    % BYTE 8
    % MOSI DATA - BLUE LED LSB
    % MISO DATA - TACHOMETER 2 (23-16)
    SS = 0;
    readyMOSI = dec2bin(blueValue(2),8);

    case 9
    % BYTE 9
    % MOSI DATA - SET ENCODER 2 (23-16)
    % MISO DATA - TACHOMETER 2 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 10
    % BYTE 10
    % MOSI DATA - SET ENCODER 2 (15-8)
    % MISO DATA - TACHOMETER 2 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 11
    % BYTE 11
    % MOSI DATA - SET ENCODER 2 (7-0)
    % MISO DATA - TACHOMETER 3 (23-16)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 12
    % BYTE 12
    % MOSI DATA - SET ENCODER 3 (23-16)
    % MISO DATA - TACHOMETER 3 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 13
    % BYTE 13
    % MOSI DATA - SET ENCODER 3 (15-8)
    % MISO DATA - TACHOMETER 3 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 14
    % BYTE 14
    % MOSI DATA - SET ENCODER 3 (7-0)
    % MISO DATA - RESERVED (0X00)
    SS = 0;
    readyMOSI = dec2bin(0,8);
    
    case 15
    % ** START OF CORE PACKET **
    % BYTE 15
    % MOSI DATA - CORE MODE (0X01)
    % MISO DATA - CORE ID MSB
    SS = 0;
    readyMOSI = dec2bin(1,8);

    case 16
    % BYTE 16
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - CORE ID LSB
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 17
    % BYTE 17
    % MOSI DATA - CORE WRITE MASK
    % MISO DATA - CURRENT SENSE 0 (15-8)
    SS = 0;
    % Do not enable the overwriting of encoders 0 and 1, but do enable the
    % overwriting of the motor voltages
    % Bit 5 - Set encoder 1 enable
    % Bit 4 - Set encoder 0 enable
    % Bit 3 - Write motor 1 voltage
    % Bit 2 - Write motor 1 enable
    % Bit 1 - Write motor 0 voltage
    % Bit 0 - Write motor 0 enable
    readyMOSI = dec2bin(15,8);

    case 18
    % BYTE 18
    % MOSI DATA - MOTOR 0 COMMAND (15-8)
    % MISO DATA - CURRENT SENSE 0 (7-0)
    SS = 0;
    % Convert the desired voltage to a value between -999 and 999
    % 24 is the saturation level in the model
    pitchVoltTemp = ceil((999*pitchVolt)/24);
    % If the desired voltage is positive, concatenate a '1' to the front of
    % the voltage value
    % Pass the MSB of the new value
    if (sign(pitchVoltTemp) == 1)
        temp = dec2bin(pitchVoltTemp,15);
        for i = 1:8
            if (i == 1)
                tempVoltBin(i) = '1';
            else
                tempVoltBin(i) = temp(i - 1);
            end
        end
        readyMOSI = tempVoltBin;
    % If the desired voltage is negative, find the 2's complement value of
    % the voltage
    elseif (sign(pitchVoltTemp) == -1)
        temp = dec2bin(-1*pitchVoltTemp,15);
        % Find the complement
        for i = 1:15
            if (temp(i) == '1')
                complement(i) = '0';
            else
                complement(i) = '1';
            end
        end
        temp1 = bin2dec(complement) + 1;
        temp2 = dec2bin(temp1,15);
        for i = 1:8
            if (i == 1)
                tempVoltBin(i) = '1';
            else
                tempVoltBin(i) = temp2(i - 1);
            end
        end
        readyMOSI = tempVoltBin;
    % If the desired voltage is zero, don't activate the motor
    else
        readyMOSI = dec2bin(0,8);
    end

    case 19
    % BYTE 19
    % MOSI DATA - MOTOR 0 COMMAND (7-0)
    % MISO DATA - CURRENT SENSE 1 (15-8)
    SS = 0;
    % Convert the desired voltage to a value between -999 and 999
    % 24 is the saturation level in the model
    pitchVoltTemp = ceil((999*pitchVolt)/24);
    % If the voltage is positive, pass the LSB
    if (sign(pitchVoltTemp) == 1)
        temp = dec2bin(pitchVoltTemp,15);
        readyMOSI = temp(8:15);
    % If the voltage is negative, find the 2's complement value and then
    % pass the LSB
    elseif (sign(pitchVoltTemp) == -1)
        temp = dec2bin(-1*pitchVoltTemp,15);
        % Find the complement
        for i = 1:15
            if (temp(i) == '1')
                complement(i) = '0';
            else
                complement(i) = '1';
            end
        end
        temp1 = bin2dec(complement) + 1;
        temp2 = dec2bin(temp1,15);
        readyMOSI = temp2(8:15);
    % If the desired voltage is zero, do not activate the motor
    else
        readyMOSI = dec2bin(0,8);
    end

    case 20
    % BYTE 20
    % MOSI DATA - MOTOR 1 COMMAND (15-8)
    % MISO DATA - CURRENT SENSE 1 (7-0)
    SS = 0;
     % Convert the desired voltage to a value between -999 and 999
    % 24 is the saturation level in the model
    yawVoltTemp = ceil((999*yawVolt)/24);
    % If the desired voltage is positive, concatenate a '1' to the front of
    % the voltage value
    % Pass the MSB of the new value
    if (sign(yawVoltTemp) == 1)
        temp = dec2bin(yawVoltTemp,15);
        for i = 1:8
            if (i == 1)
                tempVoltBin(i) = '1';
            else
                tempVoltBin(i) = temp(i - 1);
            end
        end
        readyMOSI = tempVoltBin;
    % If the desired voltage is negative, find the 2's complement value of
    % the voltage
    elseif (sign(yawVoltTemp) == -1)
        temp = dec2bin(-1*yawVoltTemp,15);
        % Find the complement
        for i = 1:15
            if (temp(i) == '1')
                complement(i) = '0';
            else
                complement(i) = '1';
            end
        end
        temp1 = bin2dec(complement) + 1;
        temp2 = dec2bin(temp1,15);
        for i = 1:8
            if (i == 1)
                tempVoltBin(i) = '1';
            else
                tempVoltBin(i) = temp2(i - 1);
            end
        end
        readyMOSI = tempVoltBin;
    % If the desired voltage is zero, don't activate the motor
    else
        readyMOSI = dec2bin(0,8);
    end

    case 21
    % BYTE 21
    % MOSI DATA - MOTOR 1 COMMAND (7-0)
    % MISO DATA - TACHOMETER 0 (23-16)
    SS = 0;
    % Convert the desired voltage to a value between -999 and 999
    % 24 is the saturation level in the model
    yawVoltTemp = ceil((999*yawVolt)/24);
    % If the voltage is positive, pass the LSB
    if (sign(yawVoltTemp) == 1)
        temp = dec2bin(yawVoltTemp,15);
        readyMOSI = temp(8:15);
    % If the voltage is negative, find the 2's complement value and then
    % pass the LSB
    elseif (sign(yawVoltTemp) == -1)
        temp = dec2bin(-1*yawVoltTemp,15);
        for i = 1:15
            if (temp(i) == '1')
                complement(i) = '0';
            else
                complement(i) = '1';
            end
        end
        temp1 = bin2dec(complement) + 1;
        temp2 = dec2bin(temp1,15);
        readyMOSI = temp2(8:15);
    % If the desired voltage is zero, do not activate the motor
    else
        readyMOSI = dec2bin(0,8);
    end

    case 22
    % BYTE 22
    % MOSI DATA - SET ENCODER 0 (23-16)
    % MISO DATA - TACHOMETER 0 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 23
    % BYTE 23
    % MOSI DATA - SET ENCODER (7-0)
    % MISO DATA - TACHOMETER 0 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 24
    % BYTE 24
    % MOSI DATA - SET ENCODER 0 (7-0)
    % MISO DATA - TACHOMETER 1 (23-16)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 25
    % BYTE 25
    % MOSI DATA - SET ENCODER 1 (23-16)
    % MISO DATA - TACHOMETER 1 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 26
    % BYTE 26
    % MOSI DATA - SET ENCODER 1 (15-8)
    % MISO DATA - TACHOMETER 1 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 27
    % BYTE 27
    % MOSI DATA - SET ENCODER 1 (7-0)
    % MISO DATA - STATUS
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 28
    % BYTE 28
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 0 (23-16)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 29
    % BYTE 29
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 0 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 30
    % BYTE 30
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 0 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 31
    % BYTE 31
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 1 (23-16)
    SS = 0;
    readyMOSI = dec2bin(0,8);
    
    case 32
    % BYTE 32
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 1 (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 33
    % BYTE 33
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ENCODER 1 (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 34
    % BYTE 34
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER X (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);
    
    case 35
    % BYTE 35
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER X (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 36
    % BYTE 36
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER Y (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 37
    % BYTE 37
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER Y (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 38
    % BYTE 38
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER Z (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 39
    % BYTE 39
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - ACCELEROMETER Z (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 40
    % BYTE 40
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE X (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 41
    % BYTE 41
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE X (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 42
    % BYTE 42
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE Y (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 43
    % BYTE 43
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE Y (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 44
    % BYTE 44
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE Z (15-8)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 45
    % BYTE 45
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - GYROSCOPE Z (7-0)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 46
    % BYTE 46
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - RESERVED (0X00)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 47
    % BYTE 47
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - RESERVED (0X00)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 48
    % BYTE 48
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - RESERVED (0X00)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 49
    % BYTE 49
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - RESERVED (0X00)
    SS = 0;
    readyMOSI = dec2bin(0,8);

    case 50
    % BYTE 50
    % MOSI DATA - PADDING BYTE (0X00)
    % MISO DATA - RESERVED (0X00)
    readyMOSI = dec2bin(0,8);
    % Reset the the slave select to begin the process again
    % Maybe not needed
    SS = 1;
    
    otherwise
    % Just in case
    readyMOSI = dec2bin(0,8);
    SS = 0;
end
% Pass the byte we have derived bit by bit
% Use the character array to determine the bit value
switch bitNumber
    case 1
        if (readyMOSI(1) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 2
        if (readyMOSI(2) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 3
        if (readyMOSI(3) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 4
        if (readyMOSI(4) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 5
        if (readyMOSI(5) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 6
        if (readyMOSI(6) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 7
        if (readyMOSI(7) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
    case 8
        if (readyMOSI(8) == '1')
            MOSI = 1;
        else
            MOSI = 0;
        end
        % If we have just sent the last bit, update the byte number
        byteNumber = byteNumber + 1;
        % Reset back to zero if we have finished one transfer
        if (byteNumber == 51)
            byteNumber = 0;
        end
    otherwise
        MOSI = 0;
end
% Update the bit number that we are sending
bitNumber = bitNumber + 1;
% Reset back to 1 if we have finished one byte
if (bitNumber == 9)
    bitNumber = 1;
end
end