function varargout = Ktly2602B_ctrl(varargin)
% Ktly2602B_ctrl: Configure KEITHLEY 2602B in voltage or current mode and measure.
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
% objDC   = 'K2602B_NN'; % pick NN according to your setup
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
% Ktly2602B_ctrl('Instr',obj,'openclose',0,'reset',1,'clear',1);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 2) setup SMU A (channel 1) to a voltage source with Vsrc=1.0V and Ilim=1mA
%    setup SMU B (channel 2) to a voltage source with Vsrc=0.5V and Ilim=2mA
% Ktly2602B_ctrl('Instr',obj,'openclose',0,...
%                'Node' ,[1    2],...
%                'NVset',[1    0.5],...
%                'NCset',[1e-3 2e-3]);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 3) turn-on both SMU(s) as they are
% Ktly2602B_ctrl('Instr',obj,'openclose',0,...
%                'Node' ,[1    2],...
%                'Non'  ,[1    1]);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 4) turn-off both SMU B (channel 2)
% Ktly2602B_ctrl('Instr',obj,'openclose',0,'Node' ,2,'Non',0);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 5) change the output voltage of SMU A (channel 1)
% Ktly2602B_ctrl('Instr',obj,'openclose',0,'Node' ,1,'NVset',0.8);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 6) measure SMU A (channel 1) voltage
% measDC = Ktly2602B_ctrl('Instr',obj,'openclose',0,...
%                         'NVget',1);
% fprintf('v,ch%d=%0.2fV\n',measDC.v{1}.node,measDC.v{1}.value);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 7) measure SMU B (channel 2) current
% measDC = Ktly2602B_ctrl('Instr',obj,'openclose',0,...
%                         'NCget',2);
% fprintf('i,ch%d=+%0.2fA\n',measDC.c{1}.node,measDC.c{1}.value);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 8)  measure SMU A and B (channel 1 and 2) voltages and currents
% measDC = Ktly2602B_ctrl('Instr',obj,'openclose',0,...
%                         'NVget',[1, 2],...
%                         'NCget',[1, 2]);
% fprintf('v,ch%d=%0.2fV ; v,ch%d=%0.2fV\n',measDC.v{1}.node,measDC.v{1}.value,measDC.v{2}.node,measDC.v{2}.value);
% fprintf('i,ch%d=%+0.2fA ; i,ch%d=%+0.2fA\n',measDC.c{1}.node,measDC.c{1}.value,measDC.c{2}.node,measDC.c{2}.value);
%
% 9) setup SMU A (channel 1) to a current source with Vlim=0.2V and Isrc=50uA
%    setup SMU B (channel 2) to a voltage source with Vsrc=0.3V and Ilim=4mA
% Ktly2602B_ctrl('Instr'  ,obj,'openclose',0,...
%                'Node'   ,[1     2   ],...
%                'NVset'  ,[0.2   0.3 ],...
%                'NCset'  ,[50e-6 4e-3],...
%                'Isource',[1     0   ]);
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=

% Author: Davide Dermit
% Confidential and Copyright Protected
%
% Version history:
% 2020/08/13    v1.1    upgraded to comply with TMC standard, added current source mode
% 2020/09/17    v1.2    expanded to support GUI

%% OPTIONAL INPUTS
InPars = inputParser();

InPars.addOptional('VENDOR'   ,  'ni'       ); % default vendor is NI
InPars.addOptional('Instr'    ,  'create'   ); % create a communication object by default
InPars.addOptional('openclose',  1          ); % open and close by default
InPars.addOptional('reset'    ,  0          ); % don't reset by default
InPars.addOptional('clear'    ,  0          ); % don't clear by default
InPars.addOptional('GPIBAddr' ,  27         ); % GPIB default address
InPars.addOptional('GPIBiBrd' ,   0         ); % board index, added on 23/7/2019 while measuring HSADC3C
InPars.addOptional('Node'     ,[ NaN,  NaN ]); % SMU ID (1 is A, 2 is B)
InPars.addOptional('Non'      ,[ NaN,  NaN ]); % SMU on
InPars.addOptional('NVset'    ,[ NaN,  NaN ]); % SMU voltages
InPars.addOptional('NCset'    ,[ NaN,  NaN ]); % SMU current compliances
InPars.addOptional('Isource'  ,[ 0  ,  0   ]); % Use as current source uf 1, by default set V source mode
InPars.addOptional('NVget'    ,[ NaN,  NaN ]); % read channel voltage if not NaN
InPars.addOptional('NCget'    ,[ NaN,  NaN ]); % read channel current if not NaN

InPars.parse(varargin{:});
FuncArg = InPars.Results;

%% create instrument object if required
if strcmp(FuncArg.Instr,'create') && FuncArg.openclose
    %     % GPIB only, use TMC instead for LAN support
    %     if strcmp(FuncArg.VENDOR, 'ni')
    %         KTLY_2602B = gpib('ni', FuncArg.GPIBiBrd, FuncArg.GPIBAddr);
    %         KTLY_2602B.InputBufferSize  = 2^10;
    %         KTLY_2602B.OutputBufferSize = 2^10;
    %     else
    %         KTLY_2602B=visa('agilent',['GPIB0::' num2str(FuncArg.GPIBAddr) '::0::INSTR']);
    %         KTLY_2602B.InputBufferSize  = 2^10;
    %         KTLY_2602B.OutputBufferSize = 2^10;
    %     end
    if(isnumeric(FuncArg.GPIBAddr))
        KTLY_2602B = gpib('ni',0,FuncArg.GPIBAddr);
    else
        KTLY_2602B = visa('agilent',['TCPIP0::' FuncArg.GPIBAddr '::inst0::INSTR']);
    end
    KTLY_2602B.InputBufferSize  = 2^10;
    KTLY_2602B.OutputBufferSize = 2^10;
else
    KTLY_2602B = FuncArg.Instr;
end

%% open communication if required
if FuncArg.openclose
    fopen(KTLY_2602B);
end

%% reset
if FuncArg.reset
    fprintf(KTLY_2602B,'*RST');
end

% reset

% % setup the 2600 to generate an SRQ on buffer full 
% % program standard Event Enable Register 0..65535
% fprintf(KTLY_2602B,'*ESE 0');

%% clear
if FuncArg.clear
    fprintf(KTLY_2602B,'*CLS');
end

% % Program the service request register 0..255
% fprintf(KTLY_2602B,'*SRE 1');

%% loop over channels and set them up
for ind=1:length(FuncArg.Node)
    % setup voltage sources
    if     FuncArg.Node(ind)==1
        SMUname = 'a';
    elseif FuncArg.Node(ind)==2
        SMUname = 'b';
    elseif isnan(FuncArg.Node(ind))
        SMUname = nan;
    else
        error(['SMU number equal to ',num2str(FuncArg.Node(ind),'%d'),' not allowed! Set it to either 1 or 2.']);
    end
    
    if ~FuncArg.Isource(ind)
        % voltage source, current limit
        VsrcType = 'levelv';
        IsrcType = 'limiti';
    else
        % current source, voltage limit
        VsrcType = 'limitv';
        IsrcType = 'leveli';
    end
    
    if ~isnan(SMUname)
        if ~isnan(FuncArg.NVset(ind)) % voltage
            fprintf(KTLY_2602B,['smu',SMUname,'.source.',VsrcType,' = ',num2str(FuncArg.NVset(ind))]);
%             fprintf(KTLY_2602B,['smu',SMUname,'.source.levelv = ',num2str(FuncArg.NVset(ind))]);
        end
        if ~isnan(FuncArg.NCset(ind)) % current compliance
            fprintf(KTLY_2602B,['smu',SMUname,'.source.',IsrcType,' = ',num2str(FuncArg.NCset(ind))]);
%             fprintf(KTLY_2602B,['smu',SMUname,'.source.limiti = ',num2str(FuncArg.NCset(ind))]);
        end
        if ~isnan(FuncArg.Non(ind))   % ON/OFF
            fprintf(KTLY_2602B,['smu',SMUname,'.source.output = ',num2str(FuncArg.Non(ind))  ]);
        end
    end
end

%% measure voltages
if all(~isnan(FuncArg.NVget))
    % loop over channels
    for k = 1:length(FuncArg.NVget)
        if FuncArg.NVget(k)==1
            smuName = 'a';
        else
            smuName = 'b';
        end
        output.v{k}.node  = FuncArg.NVget(k);                       % channel number
        fprintf(KTLY_2602B,['print(smu',smuName,'.measure.v())']);  % ask for Vmeas
        output.v{k}.value = str2double(fscanf(KTLY_2602B));         % read Vmeas
    end
end

%% measure currents
if all(~isnan(FuncArg.NCget))
    % loop over channels
    for k = 1:length(FuncArg.NCget)
        if FuncArg.NVget(k)==1
            smuName = 'a';
        else
            smuName = 'b';
        end
        output.c{k}.node  = FuncArg.NCget(k);                       % channel number
        fprintf(KTLY_2602B,['print(smu',smuName,'.measure.i())']);  % ask for Imeas
        output.c{k}.value = str2double(fscanf(KTLY_2602B));         % read Imeas
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
    fclose(KTLY_2602B);
    pause(0.5);
    delete(KTLY_2602B)
    clear KTLY_2602B;
end

end