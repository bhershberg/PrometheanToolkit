function varargout = SMB_setSig_AllInOne(varargin)
% function SMB_setSig_AllInOne Setup Rohde & Schwarz SMA 100B and measure.
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
% > RF signal options (SMA 100B only)
% * HarmRej   : [0/1] turn on harmonic rejection
%               -> default is empty so no action is performed
% * LOWD      : [0/1] turn on low distortion
%               -> default is empty so no action is performed
% * LOWN      : [0/1] turn on low noise
%               -> default is empty so no action is performed
% * NormMode  : [0/1] turn on normal mode
%               -> default is empty so no action is performed
% > CK signal options (SMA 100B only)
% * clkFrq    : clock frequency
%               -> default is empty so no action is performed
% * clkPow    : clock power (but it is a voltage <2.7V if CMOS clock)
%               -> default is empty so no action is performed
% * clkOn      : [0/1] switch the clock output on
%               -> default is empty so no action is performed
% * clkPhi    : clock phase
%               -> default is empty so no action is performed
% * clkSQnotSN: [0/1] 1 is a square wave  output while 0 is a sine wave output
%               -> default is empty so no action is performed
% * clkSEnotDF: [0/1] 1 is a single-ended output while 0 is a differential output
%               -> default is empty so no action is performed
% > Measurement
% * RFget    : if 1, measure RF output power and frequency
%               -> default is empty so no action is performed
% * CKget    : if 1, measure CK output power and frequency
%               -> default is empty so no action is performed
% - OUTPUTS
% * varargout{1} is the measurement result, if a measurement is performed,
%   empty otherwise; the measurement result is in a structure that can
%   contain an RF and/or a CK fields:
%   * output.RF.pow  = RF power
%   * output.RF.frq  = RF frequency
%   * output.RF.volt = dBm from .pow in 50Ohm system, i.e. sqrt((1e-3*10^(output.RF.pow/20))*50)*sqrt(2)
%   * output.CK.pow  = RF power
%   * output.CK.frq  = RF frequency
%   * output.CK.volt = dBm from .pow in 50Ohm system, i.e. sqrt((1e-3*10^(output.CK.pow/20))*50)*sqrt(2)
%
% Examples using DeviceOpenClose from TMControl (preferred usage):
%
% Prelimiary, create instrument object via DeviceOpenClose
% objDC   = 'SMA100B_NN'; % pick NN according to your setup
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
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'reset',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 2) setup RF output @ f=1.5GHz,p=0dBm; turn it on;
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'CF',1.5e9,'PLev',0,'RFon',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 3) turn-off RF output, set clock to square wave (clkSNnotSQ=0), set it to
% differential (clkSEnotDF=1), set clock frequency=50MHz, CMOS clock voltage=1.2V
% and phase=0
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFon',0,'clkSQnotSN',1,'clkSEnotDF',1,'clkFrq',50e6,'clkPow',1.2,'clkPhi',45,'clkOn',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 4) setup RF output @ f=2.0GHz,p=-3dBm                  ; turn it on;
%    setup CK output @ f=4.0GHz,p=+8dBm,sine,differential; turn it on;
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,...
%                     'CF',2.0e9,'PLev',-3,'RFon',1,...                                             % RF output settings
%                     'clkSQnotSN',0,'clkSEnotDF',0,'clkFrq',4e9,'clkPow',8,'clkPhi',0,'clkOn',1);  % CK output settings
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 5) measure and print RF and CK powers and frequencies
% res = SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFget',1,'CKget',1);
% fprintf(['pRF =',sprintf('%+0.4f',res.RF.pow),'dBm ; fRF =',sprintf('%0.4g',res.RF.frq),'Hz \n']);
% fprintf(['pRF =',sprintf('%+0.4f',res.CK.pow),'dBm ; fRF =',sprintf('%0.4g',res.CK.frq),'Hz \n']); % if CK is in CMOS mode, res.CK.pow is NaN; look instead at res.CK.volt
% clearvars res;
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 6) turn on RF output, enable harmonic rejection together with:
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFon',1,'HarmRej',1,'LOWN'    ,1); % either low noise
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFon',1,'HarmRej',1,'LOWD'    ,1); % or low distortion
% SMB_setSig_AllInOne('Instr',obj,'openclose',0,'RFon',1,'HarmRej',1,'NormMode',1); % % or normal mode
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=

% Author: Davide Dermit
% Confidential and Copyright Protected
%
% Version history:
% 2020/08/14    v1.1    upgraded to comply with TMC standard + improvements

%%

InPars = inputParser();

% set default if propery are not passed as input arguments
InPars.addOptional('VENDOR'    ,  'ni'    ); % default vendor is NI
InPars.addOptional('Instr'     ,  'create'); % create a communication object by default
InPars.addOptional('openclose' ,  1       ); % open and close by default
InPars.addOptional('reset'     ,  0       ); % don't reset by default
InPars.addOptional('GPIBAddr'  , 15       ); % GPIB default address
InPars.addOptional('GPIBiBrd'  ,  0       ); % board index, added on 23/7/2019 while measuring HSADC3C
% SMA 100A and 100B, RF output settings
InPars.addOptional('CPhi'      ,  NaN      ); % RF phase
InPars.addOptional('CF'        ,  NaN      ); % RF frequency
InPars.addOptional('PLev'      ,  NaN      ); % RF power
InPars.addOptional('RFon'      ,  NaN      ); % RF on
% 100B specific RF output settings
InPars.addOptional('HarmRej'   ,  NaN      ); % if 1, harmonic rejection
InPars.addOptional('LOWD'      ,  NaN      ); % if 1, low-distortion mode
InPars.addOptional('LOWN'      ,  NaN      ); % if 1, low-noise
InPars.addOptional('NormMode'  ,  NaN      ); % if 1, normal-mode
% 100B specific clock output settings                
InPars.addOptional('clkFrq'    ,  NaN      ); % CK frequency
InPars.addOptional('clkPow'    ,  NaN      ); % CK power
InPars.addOptional('clkOn'     ,  NaN      ); % CK on
InPars.addOptional('clkPhi'    ,  NaN      ); % CK phase
InPars.addOptional('clkSQnotSN',  NaN      ); % if 0 outputs a square wave; if 1 outputs a sine wave
InPars.addOptional('clkSEnotDF',  NaN      ); % if 0 output is differential; if 1 output is single ended
% measurement
InPars.addOptional('RFget'     ,  NaN      ); % if 1, measure RF output power and frequency
InPars.addOptional('CKget'     ,  NaN      ); % if 1, measure CK output power and frequency

InPars.parse(varargin{:});
FuncArg = InPars.Results;

%% create instrument object if required
if strcmp(FuncArg.Instr,'create') && FuncArg.openclose
    % GPIB only, use TMC instead for LAN support
%     if strcmp(FuncArg.VENDOR, 'ni')
%         RnS_SMA = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
%         RnS_SMA.InputBufferSize  = 2^10;
%         RnS_SMA.OutputBufferSize = 2^10;
%     else
%         RnS_SMA=visa('agilent',['GPIB0::' num2str(FuncArg.GPIBAddr) '::0::INSTR']);
%         RnS_SMA.InputBufferSize  = 2^10;
%         RnS_SMA.OutputBufferSize = 2^10;
%     end
    if(isnumeric(FuncArg.GPIBAddr))
        RnS_SMA = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
    else
        RnS_SMA = visadev(['TCPIP0::' FuncArg.GPIBAddr '::inst0::INSTR']);
    end
    RnS_SMA.InputBufferSize  = 2^10;
    RnS_SMA.OutputBufferSize = 2^10;
else
    RnS_SMA = FuncArg.Instr;
end

%% open communication if required
if FuncArg.openclose
    fopen(RnS_SMA);
end

%% reset
if FuncArg.reset
    fprintf(RnS_SMA,'*RST');
end

%% RF output settings applicable to both SMA100A and 100B
if ~isnan(FuncArg.CF)       ,fprintf(RnS_SMA,'SOURCE:FREQ:CW %.8fMHz',FuncArg.CF/1e6)               ;end % signal frequency
if ~isnan(FuncArg.CPhi)     ,fprintf(RnS_SMA,'SOURCE:PHAS %8.3f',FuncArg.CPhi)                  ;end % signal phase in degrees
if ~isnan(FuncArg.PLev)     ,fprintf(RnS_SMA,'SOURCE:POWER:LEVEL:IMM:AMPLITUDE %fdBm',FuncArg.PLev) ;end % signal power level in dBm

%% RF output settings specific to SMA100B
if (FuncArg.HarmRej == 1), fprintf(RnS_SMA,'OUTPut:FILTer:MODE ON'); 
elseif(FuncArg.HarmRej == 0), fprintf(RnS_SMA,'OUTPut:FILTer:MODE AUTO'); end   % harmonic rejection mode
if(FuncArg.LOWD == 1),fprintf(RnS_SMA,'SOURce1:POWer:LMODe LOWD');              % low distortion mode
elseif(FuncArg.LOWN == 1),fprintf(RnS_SMA,'SOURce1:POWer:LMODe LOWN')           % low noise mode
elseif(FuncArg.NormMode == 1), fprintf(RnS_SMA,'SOURce1:POWer:LMODe NORM'); end % normal mode

%% CK output settings specific to SMB100
if ~isnan(FuncArg.clkSQnotSN) && ~isnan(FuncArg.clkSEnotDF)
    % sine or square wave, single ended or differential
    if ~FuncArg.clkSQnotSN
        % sine wave output
        if FuncArg.clkSEnotDF
            % single-ended
            fprintf(RnS_SMA,':CSYNthesis:OTYPe SES');
        else
            % differential
            fprintf(RnS_SMA,':CSYNthesis:OTYPe DSIN');
        end
    else
        % square wave output
        if FuncArg.clkSEnotDF
            % single-ended
            fprintf(RnS_SMA,':CSYNthesis:OTYPe CMOS');
        else
            % differential
            fprintf(RnS_SMA,':CSYNthesis:OTYPe DSQ');
        end
    end
end

% clock frequency
if ~isnan(FuncArg.clkFrq)
    fprintf(RnS_SMA,':CSYNthesis:FREQuency %30.10f',FuncArg.clkFrq);
end

% clock power (or voltage, if CMOS)
if ~isnan(FuncArg.clkPow)
    clkType = strip(query(RnS_SMA,':CSYNthesis:OTYPe?')); % strip remove white character, e.g. newline at the end
    if strcmp(clkType,'CMOS')
        if FuncArg.clkPow>2.7
            warning('CMOS output is selected, thus clkPow is a voltage. It will be limited to the maximum=2.7V.');
            FuncArg.clkPow = 2.7;
        end
        fprintf(RnS_SMA,':CSYNthesis:VOLTage %0.3f',FuncArg.clkPow);
    else
        fprintf(RnS_SMA,':CSYNthesis:POWer %10.8f',FuncArg.clkPow);
    end
end

% clock phase
if ~isnan(FuncArg.clkPhi)
    fprintf(RnS_SMA,':CSYNthesis:PHASe %10.3f',FuncArg.clkPhi);
end

%% RF on/off
if ~isnan(FuncArg.RFon)
    if FuncArg.RFon
        fprintf(RnS_SMA,'OUTPUT:STATE ON');
    else
        fprintf(RnS_SMA,'OUTPUT:STATE OFF');
    end
end

%% CK on/off
if ~isnan(FuncArg.clkOn)
    if FuncArg.clkOn
        fprintf(RnS_SMA,':CSYNthesis:STATe 1');
    else
        fprintf(RnS_SMA,':CSYNthesis:STATe 0');
    end
end

%% measure RF output
if all(~isnan(FuncArg.RFget))
    % loop over channels
    if FuncArg.RFget
        output.RF.pow = str2double(query(RnS_SMA,':SOURce:POWer?'));
        output.RF.frq = str2double(query(RnS_SMA,':SOURce:FREQuency:CW?'));
        Pin=(1e-3*10^(output.RF.pow/20));
        output.CK.volt = sqrt(Pin*50)*sqrt(2);
    end
end

%% measure CK output
if all(~isnan(FuncArg.CKget))
    % loop over channels
    if FuncArg.CKget
        clkType = strip(query(RnS_SMA,':CSYNthesis:OTYPe?')); % strip remove white character, e.g. newline at the end
        if strcmp(clkType,'CMOS')
            output.CK.pow  = NaN;
            output.CK.volt = str2double(query(RnS_SMA,':CSYNthesis:VOLTage?'));
        else
            output.CK.pow  = str2double(query(RnS_SMA,':CSYNthesis:POWer?'));
            Pck=(1e-3*10^(output.CK.pow/20));
            output.CK.volt = sqrt(Pck*50)*sqrt(2);
        end
        output.CK.frq = str2double(query(RnS_SMA,':CSYNthesis:FREQuency?'));
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
        fclose(RnS_SMA);
    end
    pause(0.5);
    delete(RnS_SMA)
    clear RnS_SMA;
end

end