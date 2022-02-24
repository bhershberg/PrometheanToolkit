function data = N6705A_set(varargin)
% sets the voltage/current at the selected output of the
% instrument
% 
% Required arguments:
%  - output number (1,2,3,4)
%  - voltage to be set
%
% Options:
%  - address : GPIB address (default: 27)
%  - timeout : GPIB timeout (defualt: 120sec)
%  - debug   : display more info (default: false)
% 
% Returned data is in form of a structure with fields .i and .v (current,
% voltage)
% 
% Kuba Raczkowski 2011
%

p = inputParser();
p.addOptional('output',1);
p.addOptional('voltage',0);
p.addOptional('CURR', 50);
p.addOptional('address', 1);
p.addOptional('timeout',120);
p.addOptional('debug',false);
p.addOptional('instrument',0); % can be opened gpib instrument - speed!

p.parse(varargin{:});

output = p.Results.output;
voltage = p.Results.voltage;
CURR = p.Results.CURR;
debug = p.Results.debug;

if debug; fprintf('N6705A: accessing the instrument\n');end
% if strcmp('gpib',class(p.Results.instrument))
% 	instrument = p.Results.instrument;
% else
% 	instrument=gpib('ni',0,p.Results.address);
% 	set(instrument, 'InputBufferSize', 2^13);
% 	set(instrument, 'Timeout', p.Results.timeout);
% 	fopen(instrument);
% end
if(isnumeric(p.Results.address))
	instrument = gpib('ni',0,p.Results.address);
else
    instrument = visa('agilent',['TCPIP0::' p.Results.address '::inst0::INSTR']);
end
set(instrument, 'InputBufferSize', 2^13);
set(instrument, 'Timeout', p.Results.timeout);
fopen(instrument);


try
%     if debug; fprintf('N6705A: opening instrument\n');end;
%     fopen(instrument);
    
    % read data from the instrument
    if debug; fprintf('N6705A: reading data of the measurement\n',type);end;
%     sprintf('SOUR:VOLT %f,(@%d)',voltage,output)
    fprintf(instrument,sprintf('SOUR:VOLT %f,(@%d)',voltage, output));
    
    fprintf(instrument,sprintf('SOUR:CURR %f,(@%d)',CURR/1000, output));
    
    
    data.v = str2num(query(instrument,sprintf('MEAS:VOLT:DC? (@%d)',output)));
    data.i = str2num(query(instrument,sprintf('MEAS:CURR:DC? (@%d)',output)));
    
		%query for any errors (shouldn't happen)
		err = query(instrument, 'SYST:ERR?');
		err_msg = textscan(err,'%d%s','delimiter',',');
        
		if err_msg{1} ~= 0
			warning(err);
		end
	
	
  if debug; fprintf('N6705A: Closing instrument\n');end;
	if ~strcmp('gpib',class(p.Results.instrument))
		fclose(instrument);
		delete(instrument);
		clear instrument;
	end

catch err
	if ~strcmp('gpib',class(p.Results.instrument))
		fclose(instrument);
		delete(instrument);
		clear instrument;
	end
	rethrow(err);
end

if debug; fprintf('N6705A: all done\n');end;