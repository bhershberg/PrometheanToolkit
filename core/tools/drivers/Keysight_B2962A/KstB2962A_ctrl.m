function varargout = KstB2962A_ctrl(varargin)
% KstB2962A_ctrl: control Keysight B2962A power source with optional
%                  N1294AOpt 020 High-current ultra-low-noise filter.
% Setup the instrument (V and Ilim if Vsource, I and Vlim if Isource),
% enable/disable optional N1294AOpt 020 High-current ultra-low-noise
% filter, enable/disable the 4 wires measurement, measure V and/or I.
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
% * GPIBAddr : GPIB address (using it is not reccomended, prefer DeviceOpenClose from TMControl)
%               -> default value is 15
% * GPIBiBrd : GPIB board index (using it is not reccomended, prefer DeviceOpenClose from TMControl)
%               -> default value is  0
% * reset    : set to 1 to reset the instrument
%               -> 0 by default
% * clear    : set to 1 to clear the instrument
%               -> 0 by default
% > Instrument setup
% * ExtFilt  : channel(s) external filter(s) selection, can be a string or a 2 columns cell array of string
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are:
%                   => HCULNF (i.e. N1294A-020 high current ultra low noise filter)
%                   => ULNF (N1294A-021 ultra low noise filter)
%                   => LNF (N1294A-022 low noise filter)
%                   => 2 columns cell array of previous string
% * MeasMode : channel(s) measurement mode selection, can be a string or a 2 columns cell array of string
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are:
%                   => 2w (i.e. two  wire sensing)
%                   => 4w (i.e. four wire sensing)
%                   => 2 columns cell array of previous string
% > Voltage and current setup
% * Node     : channel(s) to setup, can be an integer (1 or 2) or a 2 columns vector of integers
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are: 1 - 2 - [1 2]
% * Non      : channel(s) to turn on, can be an integer (0 or 1) or a 2 columns vector of integers
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are: 0 - 1 - a 2 element vector of 0/1
% * NVset    : channel(s) voltage(s), can be a float or a 2 columns vector of floats
%               -> default is [NaN NaN] so no action is performed
% * NCset    : channel(s) current compliance(s), can be a float or a 2 columns vector of floats
%               -> default is [NaN NaN] so no action is performed
% * Isource  : set to 1 to setup the channel(s) as current source(s)
%               -> default is [0 0] so the channel(s) are setup as voltage source(s)
%               -> allowed values are: 0 - 1 - a 2 element vector of 0/1
% > Meausrement
% * NVget    : voltage(s) to be measured, can be an integer or a 2 columns vector of integers
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are: 1 - 2 - [1 2]
% * NCget    : current(s) to be measured, can be an integer or a 2 columns vector of integers
%               -> default is [NaN NaN] so no action is performed
%               -> allowed values are: 1 - 2 - [1 2]
% - OUTPUTS
% * varargout{1} is the measurement result, if a measurement is performed,
%   empty otherwise; the measurement result is in a structure that can
%   contain a v and/or a c fields, while k is either 1 and/or 2:
%   * output.v{k}.node  = node number
%   * output.v{k}.value = value of the voltage of node number
%   * output.c{k}.node  = node number
%   * output.c{k}.value = value of the current of node number
%
% Examples using DeviceOpenClose from TMControl (preferred usage):
%
% Prelimiary, create instrument object via DeviceOpenClose
% objDC   = 'B2962A_NN'; % pick NN according to your setup
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
% 1) instrument reset and clear
% KstB2962A_ctrl('Instr',obj,'openclose',0,'reset',1,'clear',1);
% 
% 2) turn-on  channel 1 and set it to current source with voltage limit of 0.1V and current       of 1.1mA
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node'   ,1  ,...
%                'Non'    ,1  ,...
%                'Isource',1  ,...
%                'NVset' ,0.1,...
%                'NCset' ,1.1e-3);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 3) turn-off channel 1 and set it to voltage source with voltage       of 1.0V and current limit of 0.5mA
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node' ,1,...
%                'Non'  ,0,...
%                'NVset',1,...
%                'NCset',0.5e-3);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 4) turn-on  channel 1 and set it to current source with voltage limit of 0.2V and current       of 0.9mA, enable high-current ultra-low-noise filter and 4 wires measurement
%    turn-on  channel 2 and set it to voltage source with voltage       of 1.2V and current limit of 5.0mA
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node'    ,[1       ,2    ],...
%                'Non'     ,[1       ,1    ],...
%                'NVset'   ,[0.2     ,1.2  ],...
%                'NCset'   ,[0.9e-3  ,5e-3 ],...
%                'ExtFilt' ,{'HCULNF','OFF'},...
%                'MeasMode',{'4w'    ,'2w' },...
%                'Isource' ,[1       ,0    );
% 
% %5) turn-on  channel 1 and set it to voltage source with voltage of 0.8V and current limit of 2mA, enable high-current ultra-low-noise filter and 4 wires measurement
%     turn-on  channel 2 and set it to voltage source with voltage of 0.9V and current limit of 3mA, enable high-current ultra-low-noise filter and 4 wires measurement
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node'    ,[1       ,2       ],...
%                'Non'     ,[1       ,1       ],...
%                'NVset'   ,[0.8     ,0.9     ],...
%                'NCset'   ,[2e-3    ,3e-3    ],...
%                'ExtFilt' ,{'HCULNF','HCULNF'},...
%                'MeasMode',{'4w'    ,'4w'    });
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 6) turn-off channels while not changing the way they are setup
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node'    ,[1 2],...
%                'Non'     ,[0 0]);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 7) turn-off channels while not changing the way they are setup
% KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                'Node'    ,[1 2],...
%                'Non'     ,[1 1]);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 8) measure channel 1 voltage
% measDC = KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                         'NVget',1);
% fprintf('v,ch%d=%0.2fV\n',measDC.v{1}.node,measDC.v{1}.value);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 9) measure channel 2 current
% measDC = KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                         'NCget',2);
% fprintf('i,ch%d=+%0.2fA\n',measDC.c{1}.node,measDC.c{1}.value);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
% 
% 10) measure channels 1 and 2 voltages and currents
% measDC = KstB2962A_ctrl('Instr',obj,'openclose',0,...
%                         'NVget',[1, 2],...
%                         'NCget',[1, 2]);
% fprintf('v,ch%d=%0.2fV ; v,ch%d=%0.2fV\n',measDC.v{1}.node,measDC.v{1}.value,measDC.v{2}.node,measDC.v{2}.value);
% fprintf('i,ch%d=%+0.2fA ; i,ch%d=%+0.2fA\n',measDC.c{1}.node,measDC.c{1}.value,measDC.c{2}.node,measDC.c{2}.value);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=

% Author: Davide Dermit
% Confidential and Copyright Protected
%
% Version history:
% 2018/04/27    v1.0    first release
% 2020/08/12    v1.1    upgraded to comply with TMC standard, added current source mode

%% OPTIONAL INPUTS
InPars = inputParser();

% set default if propery are not passed as input arguments
InPars.addOptional('VENDOR'   ,  'ni'       );   % default vendor is NI
InPars.addOptional('Instr'    ,  'create'   );   % create a communication object by default
InPars.addOptional('openclose',  1          );   % open and close by default
InPars.addOptional('reset'    ,  0          );   % don't reset by default
InPars.addOptional('clear'    ,  0          );   % don't clear by default
InPars.addOptional('GPIBAddr' , 15          );   % GPIB default address
InPars.addOptional('GPIBiBrd' ,  0          );   % board index, added on 23/7/2019 while measuring HSADC3C
InPars.addOptional('Node'     ,[ NaN,  NaN ]);   % Setup both channels
InPars.addOptional('Non'      ,[ NaN,  NaN ]);   % Turn off both channels
InPars.addOptional('NVset'    ,[ NaN,  NaN ]);   % channels voltages in V source mode
InPars.addOptional('NCset'    ,[ NaN,  NaN ]);   % channels current  in V source mode
InPars.addOptional('ExtFilt'  ,{ NaN,  NaN });   % by default external filter are OFF; can be set to:
                                                 % - HCULNF (N1294A-020 high current ultra low noise filter),
                                                 % - ULNF (N1294A-021 ultra low noise filter),
                                                 % - LNF (N1294A-022 low noise filter)
InPars.addOptional('MeasMode' ,{ NaN,  NaN });   % by default, to wire measure mode; can be set to 4w
InPars.addOptional('Isource'  ,[ 0  ,  0   ]);   % Use as current source, by default set V source mode
InPars.addOptional('NVget'    ,[ NaN,  NaN ]);   % read channel voltage if not NaN
InPars.addOptional('NCget'    ,[ NaN,  NaN ]);   % read channel current if not NaN

InPars.parse(varargin{:});
FuncArg = InPars.Results;

%% create instrument object if required
if strcmp(FuncArg.Instr,'create') && FuncArg.openclose
    % GPIB only, use TMC instead for LAN support
%     if strcmp(FuncArg.VENDOR, 'ni')
%         KS_B2962A = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
%         KS_B2962A.InputBufferSize  = 2^10;
%         KS_B2962A.OutputBufferSize = 2^10;
%     else
%         KS_B2962A=visa('agilent',['GPIB0::' num2str(FuncArg.GPIBAddr) '::0::INSTR']);
%         KS_B2962A.InputBufferSize  = 2^10;
%         KS_B2962A.OutputBufferSize = 2^10;
%     end
    if(isnumeric(FuncArg.GPIBAddr))
        KS_B2962A = gpib('ni',0,FuncArg.GPIBAddr);
    else
        KS_B2962A = visa('agilent',['TCPIP0::' FuncArg.GPIBAddr '::inst0::INSTR']);
    end
    KS_B2962A.InputBufferSize  = 2^10;
    KS_B2962A.OutputBufferSize = 2^10;
else
    KS_B2962A = FuncArg.Instr;
end

%% open communication if required
if FuncArg.openclose
    fopen(KS_B2962A);
end

%% reset
if FuncArg.reset
    fprintf(KS_B2962A,'*RST');
end

%% clear
if FuncArg.clear
    fprintf(KS_B2962A,'*CLS');
end

% % monitor operation completed
% fprintf(KS_B2962A,'*OPC');
% % wait for operation completed
% fprintf(KS_B2962A,'*WAI');

%% loop over channels
for ind=1:length(FuncArg.Node)
    
    if ~isnan(FuncArg.Node(ind))
        % turn on internal filter
        fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),':FILT ON']);
    end
    
    %% type of external filter
    % check if FuncArg.ExtFilt is a cell array to simplify the successive
    % if conditions coding
    if iscell(FuncArg.ExtFilt)
        ExtFilt  = FuncArg.ExtFilt{ind} ;
    else
        ExtFilt  = FuncArg.ExtFilt;
    end
    if ~isnan(ExtFilt)
        
        filterIsOn = str2double(query(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),':FILT:EXT:STAT?']));
        channelIsOn = str2double(query(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),'?']));
        filterIsOnReq = ~isequal(ExtFilt,'OFF');
        
        if ~strcmpi(ExtFilt,'OFF')
            % turn ON external filter if ExtFilt field is not OFF, set the
            % filter to be the same as specified by ExtFilt field; only
            % strings allowed are 'HCULNF', 'ULNF', 'LNF' or 'OFF'
            if(channelIsOn && filterIsOn ~= filterIsOnReq)
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' OFF']); % turn off channel
            end
            if any(strcmp(ExtFilt,{'HCULNF','ULNF','LNF'}))
                % turn on the filter
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),':FILT:EXT:STAT ON']);
                % set the filter
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),':FILT:EXT:TYPE ',ExtFilt]);
            else
                warning(['External filter ',ExtFilt,' is unkown, therefore not used. Allowed values are: HCULNF, ULNF, LNF.']);
            end
            if(channelIsOn && filterIsOn ~= filterIsOnReq)
                pause(0.2);
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' ON']); % turn on channel
            end
        else
            % else turn OFF external filter
            if(channelIsOn && filterIsOn ~= filterIsOnReq)
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' OFF']); % turn off channel
            end
            fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),':FILT:EXT:STAT OFF']); % switch filter mode
            if(channelIsOn && filterIsOn ~= filterIsOnReq)
                pause(0.2);
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' ON']); % turn on channel
            end
        end
    end
    
    %% type of measuremnt, i.e. 4 or 2 wires
    % check if FuncArg.MeasMode is a cell array to simplify the successive
    % if conditions coding
    if iscell(FuncArg.MeasMode)
        MeasMode = FuncArg.MeasMode{ind};
    else
        MeasMode = FuncArg.MeasMode;
    end
    if ~isnan(MeasMode)
        if strcmp(MeasMode,'4w')
            % set 4 wire sensing
            fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':REM ON']);
        elseif strcmp(MeasMode,'2w')
            % set 2 wire sensing
            fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':REM OFF']);
        else
            warning(['Measurement mode ',MeasMode,' is unkown, therefore not used. Allowed values are: 4w, 2w.']);
        end
    end
    
    %% voltage or current source mode
    if ~isnan(FuncArg.Isource(ind))
        
        % Vsetting, applied as Vsrc if Isrc=0 or Vlim if Isrc=1
        if ~isnan(FuncArg.NVset(ind))
            Vsetting = FuncArg.NVset(ind);
        else
            Vsetting = nan;
        end
        
        % Isetting, applied as Ilim if Isrc=0 or Isrc if Isrc=1
        if ~isnan(FuncArg.NCset(ind))
            Isetting = FuncArg.NCset(ind);
        else
            Isetting = nan;
        end
        
        if ~FuncArg.Isource(ind)
            if ~isnan(FuncArg.Node(ind))
                % setup the channel as a voltage source
                fprintf(KS_B2962A,[':SOUR',num2str(FuncArg.Node(ind)),':FUNC:MODE VOLT']);
                if ~isnan(Vsetting)
                    % set the DC voltage
                    fprintf(KS_B2962A,[':SOUR',num2str(FuncArg.Node(ind)),':VOLT '     ,num2str(Vsetting)]);
                end
                if ~isnan(Isetting)
                    % set the DC current compliance
                    fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':CURR:PROT ',num2str(Isetting)]);
                end
                measWhat = 'CURR';
            end
        else
            if ~isnan(FuncArg.Node(ind))
                % setup the channel as a current source
                fprintf(KS_B2962A,[':SOUR',num2str(FuncArg.Node(ind)),':FUNC:MODE CURR']);
                if ~isnan(Vsetting)
                    % set the DC voltage limitation
                    fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':VOLT:PROT ',num2str(Vsetting)]);
                end
                if ~isnan(Isetting)
                    % set the DC current
                    fprintf(KS_B2962A,[':SOUR',num2str(FuncArg.Node(ind)),':CURR '     ,num2str(Isetting)]);
                end
                measWhat = 'VOLT';
            end
        end
    end

    %% turn channel on or off
    if ~isnan(FuncArg.Non(ind))
        if (FuncArg.Non(ind))
            if ~isnan(FuncArg.Node(ind))
                % % setup measurement
                % fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':FUNC "',measWhat,'"']);
                % % set aperture time for  measurement
                % fprintf(KS_B2962A,[':SENS',num2str(FuncArg.Node(ind)),':',measWhat,':APER 100e-3']);
                
                % turn ON channel
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' ON'] );
                
                % % pause(1.5);
                % % query(KS_B2962A,[':MEAS? (@',num2str(FuncArg.Node(ind)),')']);
                % fprintf(KS_B2962A,[':TRIG:ACQ (@',num2str(FuncArg.Node(ind)),')']);
            end
        else
            if ~isnan(FuncArg.Node(ind))
                % turn OFF channel
                fprintf(KS_B2962A,[':OUTP',num2str(FuncArg.Node(ind)),' OFF']);
            end
        end
    end
    
end

%% measure voltages
if all(~isnan(FuncArg.NVget))
%     % create read string, can be (@1), (@2), (@1,2) or (@2,1)
%     readString = num2str(FuncArg.NVget,'%d,'); % last ',' is suppressed with next command
%     readString = ['(@',readString(1:end-1),')'];
%     
%     % measure and split with comma
%     measV = strsplit(query(KS_B2962A,[':MEAS:VOLT? ',readString]),',');
    
    for k = 1:length(FuncArg.NVget)
        % channel number
        output.v{k}.node  = FuncArg.NVget(k);
        % Vmeas
        output.v{k}.value = str2num(query(KS_B2962A,['MEAS:VOLT? (@',num2str(FuncArg.NVget(k)),')']));
    end
end

%% measure currents
if all(~isnan(FuncArg.NCget))
%     % create read string, can be (@1), (@2), (@1,2) or (@2,1)
%     readString = num2str(FuncArg.NCget,'%d,'); % last ',' is suppressed with next command
%     readString = ['(@',readString(1:end-1),')'];
%     
%     measI = strsplit(query(KS_B2962A,[':MEAS:CURR? ',readString]),',');
    
    for k = 1:length(FuncArg.NCget)
        % channel number
        output.c{k}.node  = FuncArg.NCget(k);
        % Imeas
        output.c{k}.value = str2num(query(KS_B2962A,['MEAS:CURR? (@',num2str(FuncArg.NCget(k)),')']));
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
    fclose(KS_B2962A);
    pause(0.5);
    delete(KS_B2962A)
    clear Instr
end
    
end