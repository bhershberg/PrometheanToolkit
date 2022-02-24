function varargout = Ktly2400_ctrl(varargin)
% Ktly2400_ctrl: Configure KEITHLEY 2400 in voltage or current mode and measure.
%
% - INPUTS
%   N.A.
%(~ OPTIONAL INPUTS)
% > Communication setup
% * VENDOR   : used if instrument object is not provided, 'ni' by default
% * Instr    : instrument object obtained via DeviceOpenClose from TMControl
%               -> if not provided a new instrument is created inside the function
% * openclose: open and close communication,
%               -> if not provided the communication is opened after entering the function and closed before leaving
% * reset    : set to 1 to reset the instrument
%               -> 0 by default
% * clear    : set to 1 to clear the instrument
%               -> 0 by default
% * GPIBAddr: GPIB address
%               -> default value is 15
% * GPIBiBrd: GPIB board index
%               -> default value is  0
% > Voltage and current setup
% * Node     : channel to setup
%               -> default is NaN so no action is performed
%               -> allowed values is: 1
% * Non      : channel to turn on, can be an integer (0 or 1)
%               -> default is NaN so no action is performed
%               -> allowed values are: 0 - 1
% * NVset    : channel voltage, can be a float
%               -> default is NaN so no action is performed
% * NCset    : channel current compliance, can be a float
%               -> default is NaN so no action is performed
% * Isource  : set to 1 to setup the channel as current source
%               -> default is 0 so the channel is setup as voltage source
%               -> allowed values are: 0 - 1
% > Meausrement
% * NVget    : voltage to be measured, can be 1
%               -> default is NaN so no action is performed
%               -> allowed values is: 1
% * NCget    : current to be measured, can be 1
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values is: 1 - 2 - [1 2]
% - OUTPUTS
% * varargout{1} is the measurement result, if a measurement is performed,
%   empty otherwise; the measurement result is in a structure that can
%   contain a v and/or a c fields, while k is either 1 and/or 2:
%   * output.v{k}.node  = node number
%   * output.v{k}.value = value of the voltage of node number
%   * output.c{k}.node  = node number
%   * output.c{k}.value = value of the current of node number
%
% Examples:
%
% 1) reset if you need
% Ktly2400_ctrl('GPIBAddr',26,'GPIBiBrd',1,'reset',1,'clear',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 2)turn-on channel 1 @ Vsrc=0.75V,Ilim=5mA
% Ktly2400_ctrl('GPIBAddr',26,'GPIBiBrd',1,'Node',1,'Non',1,'NVset',0.75,'NCset',5e-3);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 3)turn-on channel 1 @ Vlim=0.40V,Isrc=50uA
% Ktly2400_ctrl('GPIBAddr',26,'GPIBiBrd',1,'Node',1,'Non',1,'NVset',0.40,'NCset',50e-6,'Isource',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=

% Author: Davide Dermit
% Confidential and Copyright Protected
%
% Version history:
% 2020/08/13    v1.1    upgraded to comply with TMC standard, added current source mode
% 2020/09/17    v1.2    expanded to support GUI

%% OPTIONAL INPUTS
InPars = inputParser();

InPars.addOptional('VENDOR'   ,  'ni'    ); % default vendor is NI
InPars.addOptional('Instr'    ,  'create'); % create a communication object by default
InPars.addOptional('openclose',   1      ); % open and close by default
InPars.addOptional('reset'    ,   0      ); % don't reset by default
InPars.addOptional('clear'    ,   0      ); % don't clear by default
InPars.addOptional('GPIBAddr' ,  24      ); % GPIB default address
InPars.addOptional('GPIBiBrd' ,   0      ); % board index, added on 23/7/2019 while measuring HSADC3C
InPars.addOptional('Node'     , NaN      ); % single SMU
InPars.addOptional('Non'      , NaN      ); % SMU on
InPars.addOptional('NVset'    , NaN      ); % SMU voltage
InPars.addOptional('NCset'    , NaN      ); % SMU current compliance
InPars.addOptional('Isource'  ,   0      ); % Use as current source uf 1, by default set V source mode
InPars.addOptional('NVget'    , NaN      ); % read channel voltage if not NaN
InPars.addOptional('NCget'    , NaN      ); % read channel current if not NaN

InPars.parse(varargin{:});
FuncArg = InPars.Results;

%% create instrument object if required
if strcmp(FuncArg.Instr,'create') && FuncArg.openclose
    % GPIB only, use TMC instead for LAN support
    if strcmp(FuncArg.VENDOR, 'ni')
        KTLY_2400 = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
        KTLY_2400.InputBufferSize  = 2^10;
        KTLY_2400.OutputBufferSize = 2^10;
    else
        KTLY_2400=visa('agilent',['GPIB0::' num2str(FuncArg.GPIBAddr) '::0::INSTR']);
        KTLY_2400.InputBufferSize  = 2^10;
        KTLY_2400.OutputBufferSize = 2^10;
    end
else
    KTLY_2400 = FuncArg.Instr;
end

%% open communication if required
if FuncArg.openclose
    fopen(KTLY_2400);
end

%% reset
if FuncArg.reset
    fprintf(KTLY_2400,'*RST');
end

% reset

% % setup the 2400 to generate an SRQ on buffer full 
% % program standard Event Enable Register 0..65535
% fprintf(KTLY_2400,'*ESE 0');

%% clear
if FuncArg.clear
    fprintf(KTLY_2400,'*CLS');
end

% % Program the service request register 0..255
% fprintf(KTLY_2400,'*SRE 1');
% % Enable buffer full for the measurement register set
% fprintf(KTLY_2400,':STAT:MEAS:ENAB 512')
% fprintf(k2400,':SYST:BEEP:STAT 0');

%% setup the channel
if     FuncArg.Node==1
    SMUname = 1;
elseif isnan(FuncArg.Node)
    SMUname = nan;
else
    error(['SMU number equal to ',num2str(FuncArg.Node(ind),'%d'),' not allowed! Only 1 is allowed.']);
end

if ~isnan(SMUname)
        
    % Vsetting, applied as Vsrc if Isrc=0 or Vlim if Isrc=1
    if ~isnan(FuncArg.NVset)
        Vsetting = FuncArg.NVset;
        Vrange   = 10^ceil(log10(Vsetting));
    else
        Vsetting = nan;
    end

    % Isetting, applied as Ilim if Isrc=0 or Isrc if Isrc=1
    if ~isnan(FuncArg.NCset)
        Isetting = FuncArg.NCset;
        Irange   = 10^ceil(log10(abs(Isetting)));
    else
        Isetting = nan;
    end

    if ~FuncArg.Isource
        % setup in voltage source mode
        fprintf(KTLY_2400,':SOUR:FUNC:MODE VOLT');
        fprintf(KTLY_2400,':SOUR:VOLT:MODE FIXED');
        if ~isnan(Vsetting)
            % voltage setting
            fprintf(KTLY_2400,[':SOUR:VOLT:RANGE ',num2str(Vrange)  ]);
            fprintf(KTLY_2400,[':SOUR:VOLT:LEV '  ,num2str(Vsetting)]);
        end
        if ~isnan(Isetting)
            % current compliance
            fprintf(KTLY_2400,[':SENS:CURR:PROT ',num2str(Isetting)]);
%             fprintf(KTLY_2400, ':SENS:FUNC "CURR"'                  );
            fprintf(KTLY_2400,[':SENS:CURR:RANG ',num2str(Irange)  ]); % was num2str(Isetting)
            if ~isnan(Vsetting)
                fprintf(KTLY_2400,[':SENS:VOLT:PROT ',num2str(1.25*Vsetting)]);
            end
        end
    else
        % setup in current source mode
        fprintf(KTLY_2400,':SOUR:FUNC:MODE CURR');
        fprintf(KTLY_2400,':SOUR:CURR:MODE FIXED');
        if ~isnan(Vsetting)
            % voltage setting
            fprintf(KTLY_2400,[':SENS:VOLT:PROT ',num2str(Vsetting) ]);
%             fprintf(KTLY_2400, ':SENS:FUNC "VOLT"'                   );
            fprintf(KTLY_2400,[':SENS:VOLT:RANG ',num2str(Vrange)   ]); % was num2str(Vsetting)
            if ~isnan(Isetting)
                fprintf(KTLY_2400,[':SENS:CURR:PROT ',num2str(1.25*Isetting)]);
            end
        end
        if ~isnan(Isetting)
            % current compliance
            fprintf(KTLY_2400,[':SOUR:CURR:RANG ',num2str(Irange)]  );
            fprintf(KTLY_2400,[':SOUR:CURR:LEV ' ,num2str(Isetting)]);
        end
    end
    
    if ~isnan(FuncArg.Non)
        % ON/OFF
        if FuncArg.Non
            fprintf(KTLY_2400,':OUTP ON');
            pause(0.2);
            fprintf(KTLY_2400,':INIT');
        else
            pause(1);
            fprintf(KTLY_2400,':OUTP OFF');
        end
    end
end

%% measure voltage
if all(~isnan(FuncArg.NVget))
    output.v{1}.node  = 1;
%     output.v{1}.value = query(KTLY_2400,':SOUR:VOLT:LEV?','%s\n','%f');
    fprintf(KTLY_2400,':SENS:FUNC ''VOLT''');
    fprintf(KTLY_2400,':SENS:FUNC:CONC ON');
    fprintf(KTLY_2400,':SENS:VOLT:NPLC 1');
    fprintf(KTLY_2400,':FORM:ELEM:SENS VOLT');
    output.c{1}.value = query(KTLY_2400,'READ?','%s\n','%f');
end

%% measure current
if all(~isnan(FuncArg.NCget))
    output.c{1}.node  = 1;
    fprintf(KTLY_2400,':SENS:FUNC ''CURR''');
    fprintf(KTLY_2400,':SENS:FUNC:CONC ON');
    fprintf(KTLY_2400,':SENS:CURR:NPLC 1');
    fprintf(KTLY_2400,':FORM:ELEM:SENS CURR');
    output.c{1}.value = query(KTLY_2400,'READ?','%s\n','%f');
end

%% varargout definition
if exist('output','var')
    varargout{1} = output;
else
    varargout = {};
end

%% close communication if required
if FuncArg.openclose
    fclose(KTLY_2400);
    pause(0.5);
    delete(KTLY_2400);
    clear KTLY_2400;
end

end