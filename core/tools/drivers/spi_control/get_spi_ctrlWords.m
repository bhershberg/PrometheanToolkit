function ctrlMatch = get_spi_ctrlWords(spi,ctrlNameList,varargin)
% get_spi_ctrlWords Get control words from the SPI.
% - INPUTS
%   = spi            : spi, cell array (XXX rows, 4 columns) -> this should be computed per slave
%   = ctrlNameList   : list of control word names, cell array of string
%(~ OPTIONAL INPUTS)
%   = getFrom        : read from either onChip or MATLAB SPI                         , 'MATLAB'     by default
%   = fakeSend       : plot the data frame instead of sending it                     , disabled (0) by default because for debug
%   = slowFact       : number of time each bit is repeated in the data frame         , 64 by default
%   = KRNOCid        : KRNOC ID                                                      , string
%   = slaveList      : cell array of slave to where the control words must be written, empty ({}) by default so all slaves are potentially written, 'all' to program in all registers
%   = quietWarning   : if 1 disable the display of warning                           , warning enabled (0) by default
%   = debugMSGverbose: print registers corresponding to the searched control word    , disabled (0) by default
%   = debugMSGsummary: print control word and its decimal value                      , disabled (0) by default
%   = foundMSGsummary: print only found control word in debugMSGsummary mode         , disabled (0) by default
%   = fmtLenSlave    : used to align slave names in the debug message                , default %-10s, i.e. left aligned 10 char long string
%   = fmtLenCtrlW    : used to align control word names in the debug message         , default %-35s, i.e. left aligned 35 char long string
%   = nRows          : useful for debugMSGverbose mode printing                      , default is 480 rows = 60reg * 8bit
% - OUTPUTS
%   = ctrlMatch      : output structure, array of structures
%          .ctrlName : searched control word
%          .status   : 'found' or 'not found' (if 'not found' the remaining fields below are set to NaN, if integers, or '', if strings)
%          .slaveName: slave name containing the control word
%          .slaveSize: Size of the slave containing the control word in total number of bits
%          .slaveId  : slave ID containing the control word
%          .spiIdx   : SPI indexes corresponding to the searched control word
%          .ctrlIdx  : control word indexes, e.g. 12:0 for a 13 bit control word such as D_qcmp6_threshold
%          .sortIdx  : sortIdx ;control word indexes sorted according to their weight in descending order,
%                      e.g. 12th bit is the first for D_qcmp6_threshold
%          .regNum   : regNum(spiIdx): register numbers, important to know to update the on-chip SPI
%          .regVal   : register values, array of binaries digit
%          .ctrlVal  : decimal control word value, reconstructed from the register value

%% OPTIONAL INPUTS
ParsedIn = inputParser();

ParsedIn.addOptional('getFrom'        ,'MATLAB');
ParsedIn.addOptional('fakeSend'       , 0);
ParsedIn.addOptional('slowFact'       ,64);
ParsedIn.addOptional('KRNOCid'        ,'KRNOC50');

ParsedIn.addOptional('slaveList'      ,{});
% if 1 warning are not shown, disabled by default
ParsedIn.addOptional('quietWarning'   ,0);
% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('debugMSGverbose',0);
ParsedIn.addOptional('debugMSGsummary',0);
ParsedIn.addOptional('foundMSGsummary',0);
ParsedIn.addOptional('fmtLenSlave'    ,'%-10s');
ParsedIn.addOptional('fmtLenCtrlW'    ,'%-35s');
ParsedIn.addOptional('nRows'          ,480);

ParsedIn.parse(varargin{:});

getFrom         = ParsedIn.Results.getFrom;
fakeSend        = ParsedIn.Results.fakeSend;
slowFact        = ParsedIn.Results.slowFact;
KRNOCid         = ParsedIn.Results.KRNOCid;

slaveList       = ParsedIn.Results.slaveList;
% if 1 warning are not shown, disabled by default
quietWarning    = ParsedIn.Results.quietWarning;
% for debug purposes in the printing function
debugMSGverbose = ParsedIn.Results.debugMSGverbose;
debugMSGsummary = ParsedIn.Results.debugMSGsummary;
foundMSGsummary = ParsedIn.Results.foundMSGsummary;
fmtLenSlave     = ParsedIn.Results.fmtLenSlave;
fmtLenCtrlW     = ParsedIn.Results.fmtLenCtrlW;
nRows           = ParsedIn.Results.nRows;

%% INPUT CHECK
if ~(strcmp(getFrom,'onChip') || strcmp(getFrom,'MATLAB'))
    error(['getFrom equal to "',char(CHpol),'" is not allowed; allowed getFrom is either "onChip" or "MATLAB".']);
end

%% CONTROL WORD SEARCH
indSearch = 0;

if isempty(slaveList) || (length(slaveList)==1 && strcmp(char(slaveList),'all'))
    slaveList = fieldnames(spi);
end
ctrlListFound = zeros(size(ctrlNameList));

for indCtrlW=1:length(ctrlNameList) % loop over control words
    ctrlName = ctrlNameList{indCtrlW};
    for indSlave=1:length(slaveList) % loop over all the slaves
        
        slaveName = slaveList{indSlave};
        
        if isfield(spi,slaveName)
            % loop over slaves
            regNum   = [spi.(slaveName).slaveReg{:,1}];   % register number array
            ctrlList = {spi.(slaveName).slaveReg{:,3}}.'; % control words cell array
            regVal   = [spi.(slaveName).slaveReg{:,4}];   % register value array
            slaveId  =  spi.(slaveName).slaveId;          % slave ID
            slaveCh  =  spi.(slaveName).slaveCh;          % slave chain
            slaveSize= length(spi.(slaveName).slaveReg);  % Size of the slave in total number of bits it operates with. %NM
            
            % search in the list for the control word name
            %spiIdx =find(not(cellfun('isempty',strfind(ctrlList,ctrlName)))); %NM: not a unique pattern search
            spiIdx = find(not(cellfun('isempty',strfind(ctrlList,[ctrlName '<'])))); %NM: finds words spread across multiple registers 
            if isempty(spiIdx)
               spiIdx = find(strcmp(ctrlList, ctrlName)); %if word is not spread, find its unique location (if it exists)
            elseif find(strcmp(ctrlList, ctrlName)) %if a unique word exist with the same name as spread word thats a problem
                error('Control word not unique - verify mapping table.')
            end
            
            if ~isempty(spiIdx)
                % control word is found
                if length(spiIdx)==1
                    % values not meaningful for a 1 bit control, so set to NaN
                    ctrlIdx = NaN;
                    sortIdx = NaN;
                else
                    % store the control bit indexes
                    ctrlIdx = NaN(size(spiIdx));
                    for indBit=1:length(spiIdx)
                        % retrieve a multi-digit integer surrounded by < >
                        ind=regexp(char(ctrlList{spiIdx(indBit)}),'<\d+>','match');
                        % keep the multi-digit integer removing the < >
                        ind=regexp(char(ind),'\d+','match');
                        ctrlIdx(indBit) = str2double(ind{1});
                    end
                    clear indBit ind;
                    % control bit indexes sorted in descending order
                    [~,sortIdx] = sort(ctrlIdx,'descend');
                end
                
                if ~ctrlListFound(indCtrlW)
                    % set ctrlListFound(indCtrlW) to 1 if it is still at 0
                    ctrlListFound(indCtrlW) = 1;
                end
                
                % searched control word
                searchRes.ctrlName  = ctrlName;
                % found
                searchRes.status    = 'found';
                % slave name and ID containing the control word
                searchRes.slaveName = slaveName;
                searchRes.slaveSize = slaveSize; %size pf the slave in number or registers
                
                searchRes.slaveId   = slaveId;
                searchRes.slaveCh   = slaveCh;
                
                % SPI indexes corresponding to the searched control word
                searchRes.spiIdx   = spiIdx  ;
                % control word indexes, e.g. 12:0 for a 13 bit control word such
                % as D_qcmp6_threshold
                searchRes.ctrlIdx  = ctrlIdx ;
                % control word indexes sorted according to their weight in descending
                % order, e.g. 12th bit is the first for D_qcmp6_threshold
                searchRes.sortIdx  = sortIdx ;
                
                % register numbers, important to know to update the on-chip SPI
                searchRes.regNum   = sort(unique(regNum(spiIdx)),'descend');
                % register values, array of binaries digit
                searchRes.regVal   = (regVal(spiIdx)).';
                
                % read from MATLAB or from chip
                searchRes.getFrom  = getFrom;
                
                if strcmp(getFrom,'MATLAB')
                    % read value from MATLAB
                    if length(spiIdx)==1
                        % if 1 bit control word, just assign the value
                        searchRes.ctrlVal  = regVal(spiIdx);
                    else
                        % else, the decimal control word value is reconstructed from the
                        % register value: sort the register values according to the
                        % control word weights and weight them with the corresponding
                        % power of 2, then sum
                        searchRes.ctrlVal  = sum(((2.^ctrlIdx(sortIdx)).').*regVal(spiIdx(sortIdx)));
                    end
                else
                    % read value from on-chip SPI
                    searchRes = read_onC_spi(spi,searchRes,'getFrom',getFrom,'fakeSend',fakeSend,'slowFact',slowFact,'KRNOCid',KRNOCid);
                end
                
            else
                searchRes.ctrlName  = ctrlName;
                searchRes.status    = 'not found: CtrlW';
                searchRes.slaveName = slaveName;
                searchRes.slaveSize = NaN; %NM
                searchRes.slaveId   = NaN;
                searchRes.slaveCh   = NaN;
                searchRes.spiIdx    = NaN;
                searchRes.ctrlIdx   = NaN;
                searchRes.sortIdx   = NaN;
                searchRes.regNum    = NaN;
                searchRes.regVal    = NaN;
                searchRes.getFrom   = '';
                searchRes.ctrlVal   = NaN;

                if ~quietWarning
                    warning(['Control word "',ctrlName,'" not found in SPI slave "',slaveName,'".']);
                end
            end
        else
            % control word is not yet found
            if indSlave==length(slaveList) && ~ctrlListFound(indCtrlW)
                % if all the slaves have been tested and the control word
                % is not found anywhere the control word is not present
                searchRes.ctrlName  = ctrlName;
                searchRes.status    = 'not found: Slave';
                searchRes.slaveName = slaveName;
                searchRes.slaveSize = NaN; %NM
                searchRes.slaveId   = NaN;
                searchRes.slaveCh   = NaN;
                searchRes.spiIdx    = NaN;
                searchRes.ctrlIdx   = NaN;
                searchRes.sortIdx   = NaN;
                searchRes.regNum    = NaN;
                searchRes.regVal    = NaN;
                searchRes.getFrom   = '';
                searchRes.ctrlVal   = NaN;
                
                if ~quietWarning
                    warning(['Slave "',slaveName,'" not found in the SPI.']);
                end
            end
        end
        if exist('searchRes','var')
            % save the search result if existing
            % this if-else is used to create ...
            if indSearch==0
                % a single element structure in case there is only one hit
                ctrlMatch = searchRes;
                indSearch=2;
            else
                % an array of structures in case there are multiple hits
                ctrlMatch(indSearch) = searchRes;
                indSearch = indSearch + 1;
            end
        end
        clearvars searchRes; % clear to search the same ctrlName in other slaves
    end
end

%% DEBUG PRINTING
print_get_spi_ctrlWords(ctrlMatch,...
                        'debugMSGverbose',debugMSGverbose,'spi',spi,...
                        'debugMSGsummary',debugMSGsummary,'foundMSGsummary',foundMSGsummary,...
                        'fmtLenSlave',fmtLenSlave,'fmtLenCtrlW',fmtLenCtrlW,'nRows',nRows);

end