function varargout = Agilent_E8267D_setSig_AllInOne(varargin)
% function Agilent_E8267D_setSig_AllInOne Setup Agilent E8267D and measure.
%
% - INPUTS
%   N.A.
%(~ OPTIONAL INPUTS)
% > Communication setup
% * VENDOR    : GPIB vendor name (default: 'ni')
% * Instr     : instrument object obtained via DeviceOpenClose from TMControl
%                -> if not provided a new instrument is created inside the function
% * openclose : open and close communication,
%                -> if not provided the communication is opened after entering the function and closed before leaving
% * GPIBAddr  : GPIB primary address (default: 28)
%                -> Using it is not reccomended, prefer DeviceOpenClose from TMControl
% * GPIBiBrd  : GPIB board index number (default: 0)
%                -> Using it is not reccomended, prefer DeviceOpenClose from TMControl
% * reset     : set to 1 to reset the instrument (default: 0)
% > RF signal options (SMA 100A and 100B)
% * RST       : [0/1] reset the instrument before setting it
%               -> default is empty so no action is performed
% * CF        : signal frequency in Hz
%               -> default is empty so no action is performed
% * PLev      : signal power level in dBm
%               -> default is empty so no action is performed
% * RFOn      : [0/1] switch the RF output on
%               -> default is empty so no action is performed
% > Measurement
% * RFget    : if 1, measure RF output power and frequency
%               -> default is empty so no action is performed
% - OUTPUTS
% * varargout{1} is the measurement result, if a measurement is performed,
%   empty otherwise; the measurement result is in a structure that can
%   contain an RF field:
%   * output.RF.pow  = RF power
%   * output.RF.frq  = RF frequency
%   * output.RF.volt = dBm from .pow in 50Ohm system, i.e. sqrt((1e-3*10^(output.RF.pow/20))*50)*sqrt(2)
%
% Examples using DeviceOpenClose from TMControl (preferred usage):
%
% Prelimiary, create instrument object via DeviceOpenClose
% objDC   = 'SMA100A_NN'; % pick NN according to your setup
% DeviceOpenClose(objDC,'state','open','DEBUG',0);
% 
% obj = instrfind('Tag',objDC);
% internopen = 0;
% if isempty(obj)
%     DeviceOpenClose(objname,'state','open');
%     internopen = 1;
%     obj = instrfind('Tag',objname);
% else
%     if strcmp(obj.Status,'closed')
%         DeviceOpenClose(objname,'state','open');
%         internopen = 1;
%         obj = instrfind('Tag',objname);
%     end
% end
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 1) instrument reset
% SMA_setSig_AllInOne('Instr',obj,'openclose',0,'reset',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 2) setup RF output @ f=1.5GHz,p=0dBm; turn it on;
% SMA_setSig_AllInOne('Instr',obj,'openclose',0,'CF',1.5e9,'PLev',0,'RFon',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 3) turn-off RF output, set clock to square wave (clkSNnotSQ=0), set it to
% differential (clkSEnotDF=1), set clock frequency=50MHz, CMOS clock voltage=1.2V
% and phase=0
% SMA_setSig_AllInOne('Instr',obj,'openclose',0,'RFon',0,'clkSQnotSN',1,'clkSEnotDF',1,'clkFrq',50e6,'clkPow',1.2,'clkPhi',45,'clkOn',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 4) setup RF output @ f=2.0GHz,p=-3dBm                  ; turn it on;
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,...
%                     'CF',2.0e9,'PLev',-3,'RFon',1);                                             % RF output settings
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 5) measure and print RF powers and frequency
% res = SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFget',1,'CKget',1);
% fprintf(['pRF =',sprintf('%+0.4f',res.RF.pow),'dBm ; fRF =',sprintf('%0.4g',res.RF.frq),'Hz \n']);
% clearvars res;
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% Author: JL based on code by DD
% Confidential and Copyright Protected
%
% Version history:
% 2020/06/18    v0.1    created from "SMB_setSig_AllInOne.m"

%%

InPars = inputParser();

% set default if propery are not passed as input arguments
InPars.addOptional('VENDOR'    ,  'ni'    ); % default vendor is NI
InPars.addOptional('Instr'     ,  'create'); % create a communication object by default
InPars.addOptional('openclose' ,  1       ); % open and close by default
InPars.addOptional('reset'     ,  0       ); % don't reset by default
InPars.addOptional('GPIBAddr'  , 15       ); % GPIB default address
InPars.addOptional('GPIBiBrd'  ,  0       ); % board index, added on 23/7/2019 while measuring HSADC3C
InPars.addOptional('CF'        ,  NaN      ); % RF frequency
InPars.addOptional('PLev'      ,  NaN      ); % RF power
InPars.addOptional('RFon'      ,  NaN      ); % RF on
% measurement
InPars.addOptional('RFget'     ,  NaN      ); % if 1, measure RF output power and frequency
% % % % % InPars.addOptional('CKget'     ,  NaN      ); % if 1, measure CK output power and frequency

InPars.parse(varargin{:});
FuncArg = InPars.Results;

%% create instrument object if required
if strcmp(FuncArg.Instr,'create') && FuncArg.openclose
    % GPIB only, use TMC instead for LAN support
%     if strcmp(FuncArg.VENDOR, 'ni')
%         Ag_E8267D = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
%         Ag_E8267D.InputBufferSize  = 2^10;
%         Ag_E8267D.OutputBufferSize = 2^10;
%     else
%         Ag_E8267D=visa('agilent',['GPIB0::' num2str(FuncArg.GPIBAddr) '::0::INSTR']);
%         Ag_E8267D.InputBufferSize  = 2^10;
%         Ag_E8267D.OutputBufferSize = 2^10;
%     end
    if(isnumeric(FuncArg.GPIBAddr))
        Ag_E8267D = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
    else
        Ag_E8267D = visadev(['TCPIP0::' FuncArg.GPIBAddr '::inst0::INSTR']);
    end
    Ag_E8267D.InputBufferSize  = 2^10;
    Ag_E8267D.OutputBufferSize = 2^10;
else
    Ag_E8267D = FuncArg.Instr;
end

%% open communication if required
if FuncArg.openclose
    fopen(Ag_E8267D);
end

%% reset
if FuncArg.reset
    fprintf(Ag_E8267D,'*RST');
end

%% RF output settings applicable to both SMA100A and 100B
if ~isnan(FuncArg.CF)       ,fprintf(Ag_E8267D,'FREQ %.8f MHz',FuncArg.CF/1e6)               ;end % signal frequency
if ~isnan(FuncArg.PLev)     ,fprintf(Ag_E8267D,'POW:AMPL %f dBm',FuncArg.PLev) ;end % signal power level in dBm

%% RF on/off
if ~isnan(FuncArg.RFon)
    if FuncArg.RFon
        fprintf(Ag_E8267D,'OUTP:STAT ON');
    else
        fprintf(Ag_E8267D,'OUTP:STAT OFF');
    end
end

%% measure RF output
if all(~isnan(FuncArg.RFget))
    % loop over channels
    if FuncArg.RFget
        output.RF.pow = str2double(query(Ag_E8267D,':POW:AMPL?'));
        output.RF.frq = str2double(query(Ag_E8267D,':FREQ?'));
        Pin=(1e-3*10^(output.RF.pow/20));
        output.RF.volt = sqrt(Pin*50)*sqrt(2);
    end
end

%% varargout definition
if exist('output','var')
    varargout{1} = output;
else
    varargout = {};
end

%% close communication if required
if FuncArg.openclose
    if isnumeric(FuncArg.GPIBAddr)
        fclose(Ag_E8267D);
    end
    pause(0.5);
    delete(Ag_E8267D)
    clear Ag_E8267D;
end

end