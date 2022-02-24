function RData = ftdi_spi_write(Data, DeviceName, Chip)
% function ftdi_spi_write creates an SPI message with the input data and writes it onto the specified USB_NoC board.
%
% Syntax: USB_DATA = USB_DATA = ftdi_spi_write(Data, DeviceNmae, Chip)
%
% Input:
%
%    Data:         Data to be embedded in an SPI message.
%    DeviceName:   Device name of the USBNOC interface board.
%    Chip:         Chip Select, if omitted chip 1 (TRX) is used
%
% Output:
%
%    RData:        Sequence of data read from the USB_NoC board.
%
% Example: RData = ftdi_spi_write([24 1 16 0], 'KRNOC27')
%
% Author: Giovanni Mangraviti, Kristof Vaesen
% Date:   12/2016 - V0.1
% Date:   10/2017 - V0.2 Reading added
% Date:   10/2018 - V0.3 Added Reading of multiple registers
% Date:   06/2019 - V0.3 Added support for multiple chips

if not(exist('Chip')) Chip=1; end

% % % % Associate the correct pin position to each signal
% % % % bitDI=0;
% % % % bitCSN=3; % called "TE" on the USB_NoC board
% % % % bitCLK=2;
% % % % bitRST=6;
% % % % bitDO=1;
% % % %when use direct connect NoC PCB w/o connector 
% % % bitDI=0; %
% % % if Chip==1 
% % %     bitCSN=5; % TRX 
% % % elseif Chip==2
% % %     bitCSN=6; % TX
% % % elseif Chip==3
% % %     bitCSN=7; % RX
% % % elseif Chip==4
% % %     bitCSN=1; % PLL
% % % elseif Chip==0
% % %     bitCSN=8; % All Wisens chips
% % % else
% % %     error('Unknown Chip Select!');
% % % end % TRX Chip 
% % % bitCLK=3; %
% % % bitRST=2;  %
% % % bitDO=4; % Connected to pin 15 (D4) in usb_noc

bitDI     =1;   % D1 of usb_noc is SPI MOSI
bitCLK    =2;   % D2 of usb_noc is SPI CK
bitRST    =6;   % D6 of usb_noc is SPI RSTn
bitDO     =0;   % D0 of usb_noc is SPI MISO
bitCSN    =5;   % D5 of usb_noc is SPI CSn
bitCSadc  =7;   % D7 of usb_noc is ADC CS   (0=pline, 1=SAR)
bitRSTNadc=4;   % D4 of usb_noc is ADC RSTN (0=RST, 1=not RST)

% If we have read messages we go SPI commands on by one
DI=[];
CSN=[];
CLK=[];
RData=[];
RDataLoc=[]; % Location of recieve data bits in stream
for i=1:2:length(Data) % Create bit bang messages
    DIadd=[0 bitand(bitshift(1,7:-1:0),Data(i))~=0  bitand(bitshift(1,7:-1:0),Data(i+1))~=0 0];
    CLKadd=[0 ones(1,16) 0];
    CSNadd=[0 zeros(1,16) 1];
    
    if bitand(Data(i),192)==128 % Read Message
       DIadd=[DIadd DIadd DIadd];  % Repeat the message 3 times for read
       CLKadd=[CLKadd CLKadd CLKadd];%
       CSNadd=[CSNadd CSNadd CSNadd];%
       DI=[DI DIadd];
       CSN=[CSN CSNadd];
       CLK=[CLK CLKadd];
       RDataLoc=[RDataLoc (length(DI)-8)]; % The location in DI of the read data is 8 bit before the end
    else
       DI=[DI DIadd];
       CSN=[CSN CSNadd];
       CLK=[CLK CLKadd]; 
    end
    
end
% Create new vectors: CLK --> CLKnew
% the new vectors have doubble length because including the CLK toggling
CLKnew(1:2*length(CLK))=0;
CLKnew(1:2:end-1)=CLK;
DInew(1:2*length(DI))=0;
DInew(1:2:end-1)=DI;
DInew(2:2:end)=DI;
CSNnew(1:2*length(CSN))=0;
CSNnew(1:2:end-1)=CSN;
CSNnew(2:2:end)=CSN;
RSTnew=ones(1,length(CSNnew));
% CSNnewN=ones(1,length(CSNnew)); % The CSN for other chips should stay high!!
ADCcs   = ones(1,length(CSNnew)); % 1 select SAR
ADCrstn = ones(1,length(CSNnew)); % 1 not RST
% Plot signals (manual debug of this function)
if 0
    plot(CLKnew);
    hold on;
    plot(DInew);
    plot(CSNnew);
    plot(RSTnew);
end

USB_DATA=  DInew*2^bitDI        + ...
          CLKnew*2^bitCLK       + ...
          RSTnew*2^bitRST       + ...
          CSNnew*2^bitCSN       + ...
           ADCcs*2^bitCSadc     + ...
         ADCrstn*2^bitRSTNadc;

% if bitCSN==8
%    USB_DATA=DInew*2^bitDI+CSNnew*2^5+CSNnew*2^6+CSNnew*2^7+CSNnewN*2^1+CLKnew*2^bitCLK+RSTnew*2^bitRST; 
% elseif bitCSN==7
%    USB_DATA=DInew*2^bitDI+CSNnew*2^bitCSN+CLKnew*2^bitCLK+RSTnew*2^bitRST+CSNnewN*2^1+CSNnewN*2^5+CSNnewN*2^6;
% elseif bitCSN==6
%    USB_DATA=DInew*2^bitDI+CSNnew*2^bitCSN+CLKnew*2^bitCLK+RSTnew*2^bitRST+CSNnewN*2^1+CSNnewN*2^5+CSNnewN*2^7;
% elseif bitCSN==5
%    USB_DATA=DInew*2^bitDI+CSNnew*2^bitCSN+CLKnew*2^bitCLK+RSTnew*2^bitRST+CSNnewN*2^1+CSNnewN*2^6+CSNnewN*2^7;
% elseif bitCSN==1
%    USB_DATA=DInew*2^bitDI+CSNnew*2^bitCSN+CLKnew*2^bitCLK+RSTnew*2^bitRST+CSNnewN*2^5+CSNnewN*2^6+CSNnewN*2^7;
% end
if RDataLoc % We have data to read
% % %     DataIn=usb_noc(USB_DATA,'debug',0,'device_name',DeviceName);
    DataIn=usb_noc(USB_DATA,'device_name',DeviceName);
    % DataIn=[0 USB_DATA(1:end-1)]; % For debugging only
    DataIn=DataIn(3:2:end); % The first one is old data; the second is rising edge
                            % Data is stable on faling edge (3e byte)
    DataIn=bitand(DataIn,2^bitDO)~=0; % Select the DO bits
    for Loc=RDataLoc        % Move to the lacation where the read data is
        RData=[RData bi2de(DataIn(Loc:Loc+7),2,'left-msb')]; % Convert to decimal
    end
else
% % %     usb_noc(USB_DATA,'debug',0,'device_name',DeviceName);
    usb_noc(USB_DATA,'device_name',DeviceName);
end