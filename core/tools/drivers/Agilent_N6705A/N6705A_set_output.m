function data = N6705A_set_output(varargin)
% sets state of the selected output to either on or off
% 
% Required arguments:
%  - output number (1,2,3,4)
%  - state (0, 1)
%
% Options:
%  - address : GPIB address (default: 1)
%  - timeout : GPIB timeout (defualt: 120sec)
%  - debug   : display more info (default: false)
% 
% example:
% N6705A_set_output(1,0); % sets output 1 to off
% 
% Kuba Raczkowski 2011
%

p = inputParser();
p.addOptional('output',1);
p.addOptional('state',0);
p.addOptional('address',1);
p.addOptional('timeout',120);
p.addOptional('debug',false);
p.addOptional('instrument',0); % can be opened gpib instrument - speed!

p.parse(varargin{:});

output = p.Results.output;
state = p.Results.state;
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
    if debug; fprintf('N6705A: opening instrument\n');end;
    %fopen(instrument); % i think it should be already open
    
    % read data from the instrument
    if debug; fprintf('N6705A: setting output state\n',type);end;
    fprintf(instrument,sprintf('OUTP:STAT %d, (@%d)',state,output));
    
    if debug; fprintf('N6705A: Closing instrument\n');end;
    fclose(instrument);
	delete(instrument);
	clear instrument;

	%query for any errors (shouldn't happen)
	err = query(instrument, 'SYST:ERR?');
	err_msg = textscan(err,'%d%s','delimiter',',');
	if err_msg{1} ~= 0
		warning(err);
	end
	
%	if ~strcmp('gpib',class(p.Results.instrument))
%		fclose(instrument);
%		delete(instrument);
%		clear instrument;
%	end

%catch exception
%	if ~strcmp('gpib',class(p.Results.instrument))
		fclose(instrument);
		delete(instrument);
		clear instrument;
%	end
	%rethrow exception
end

if debug; fprintf('N6705A: all done\n');end;