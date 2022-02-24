function print_get_spi_ctrlWords(getMatch,varargin)
% print_get_spi_ctrlWords Print the ctrlMatch output of get_spi_CtrlWord command.
% - INPUTS
%   = ctrlMatch      : output structure of get_spi_CtrlWord
%(~ OPTIONAL INPUTS)
%   = debugMSGverbose: print registers corresponding to the searched control word, disabled (0) by default
%   = spi            : required for debugMSGverbose mode                         , empty struct([]) by deault
%   = debugMSGsummary: print control word and its decimal value                  , disabled (0) by default
%   = foundMSGsummary: print only found control word in debugMSGsummary mode     , disabled (0) by default
%   = fmtLenSlave    : used to align slave names in the debug message            , default %-10s, i.e. left aligned 10 char long string
%   = fmtLenCtrlW    : used to align control word names in the debug message     , default %-35s, i.e. left aligned 35 char long string
%   = nRows          : useful for debugMSGverbose mode printing                  , default is 480 rows = 60reg * 8bit
% - OUTPUTS
%   N.A.

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('debugMSGverbose',0);
ParsedIn.addOptional('spi'            ,struct([]));
ParsedIn.addOptional('debugMSGsummary',0);
ParsedIn.addOptional('foundMSGsummary',0);
ParsedIn.addOptional('fmtLenSlave'    ,'%-10s');
ParsedIn.addOptional('fmtLenCtrlW'    ,'%-35s');
ParsedIn.addOptional('nRows'          ,480);

ParsedIn.parse(varargin{:});

debugMSGverbose = ParsedIn.Results.debugMSGverbose;
spi             = ParsedIn.Results.spi;
debugMSGsummary = ParsedIn.Results.debugMSGsummary;
foundMSGsummary = ParsedIn.Results.foundMSGsummary;
fmtLenSlave     = ParsedIn.Results.fmtLenSlave;
fmtLenCtrlW     = ParsedIn.Results.fmtLenCtrlW;
nRows           = ParsedIn.Results.nRows;

if debugMSGsummary
    fprintf([fmtLenSlave ,', ',fmtLenCtrlW   ,', ','% 3s, ','% 3s, ','% 6s, ','%-15s\n'],...
             'slave name',     'control word',     'ID'    ,'Nb'    ,'value' ,'status');
    for indGet=1:length(getMatch)
        ctrlMatch = getMatch(indGet);
        % print everything if foundMSGsummary=0 or print only ctrlMatch.status='found' if foundMSGsummary=1
        if ~foundMSGsummary || (foundMSGsummary && strcmp(ctrlMatch.status,'found'))
            % print slave name, slaveID, ctrl word name, ctrl word length, ctrl word decimal value
            fprintf([fmtLenSlave        ,', ',fmtLenCtrlW       ,', ','% 3d, '        ,'% 3d, '                ,'% 6d, '         ,'%-15s'],...
                ctrlMatch.slaveName     ,ctrlMatch.ctrlName     ,ctrlMatch.slaveId,length(ctrlMatch.spiIdx),ctrlMatch.ctrlVal,ctrlMatch.status);
            if ~strcmp(ctrlMatch.status,'found')
                disp(' <=== WARNING');
            else
                disp(' ');
            end
        end
    end
end

%% VERBOSE DEBUG PRINTING ONLY FOR FOUND CONTROL WORDS
if debugMSGverbose
    for indGet=1:length(getMatch)
        ctrlMatch = getMatch(indGet);
        if strcmp(ctrlMatch.status,'found')
            % print verbose debug messages only if the variable is found
            
            if ~isempty(spi)
                % print channel number, polarity, slaveID, reg number, reg bit, ctrl word name and bit, ctrl word bit value
                for ind=1:length(ctrlMatch.spiIdx)
                    disp([sprintf(fmtLenSlave,char(ctrlMatch.slaveName)),', ',sprintf('% 3d',ctrlMatch.slaveId) ,', ',...
                          sprintf('% 3d'     ,spi.(ctrlMatch.slaveName).slaveReg{nRows*0+ctrlMatch.spiIdx(ind)}),', ',...
                          sprintf('% 2d'     ,spi.(ctrlMatch.slaveName).slaveReg{nRows*1+ctrlMatch.spiIdx(ind)}),', ',...
                          sprintf(fmtLenCtrlW,spi.(ctrlMatch.slaveName).slaveReg{nRows*2+ctrlMatch.spiIdx(ind)}),', ',...
                          sprintf('% 2d'     ,spi.(ctrlMatch.slaveName).slaveReg{nRows*3+ctrlMatch.spiIdx(ind)})     ,...
                         ]);
                end
            else
                warning('SPI structure is not provided! Please provide a valid SPI structure for the verbose debug mode.');
            end
        end
        
        disp(' ');
    end
    
end

end