function [spi,updateSummary] = set_spi_ctrlWords(spi,ctrlNameList,ctrlValList,varargin)
% set_spi_ctrlWords Set a control word to a given value in the SPI cell array.
% - INPUTS
%   = spi            : spi, cell array (XXX rows, 4 columns) --> nr of rows to be computed
%   = ctrlNameList   : list of control word names, cell array of string
%   = ctrlValList    : list of control word values, cell array of either integers or 'min', 'mid', 'max' (with same length as ctrlNameList) 
%(~ OPTIONAL INPUTS)
%   = send2chip      : if 0 update the MATLAB SPI only; if 1 send also to on-chip SPI, don't send to chip (0) by default
%   = fakeSend       : plot the data frame instead of sending it                     , disabled (0) by default because for debug
%   = slowFact       : number of time each bit is repeated in the data frame         , 64 by default
%   = KRNOCid        : KRNOC ID                                                      , string
%   = slaveList      : cell array of slave to where the control words must be written, empty ({}) by default so all slaves are potentially written, 'all' to program in all registers
%   = debugMSGverbose: print registers corresponding to the searched control word    , disabled (0) by default
%   = debugMSGsummary: print control word and its decimal value                      , disabled (0) by default
%   = fmtLenSlave    : used to align slave names in the debug message                , default %-10s, i.e. left aligned 10 char long string
%   = fmtLenCtrlW    : used to align control word names in the debug message         , default %-35s, i.e. left aligned 35 char long string
%   = nRows          : useful for debugMSGverbose mode printing                      , default is 480 rows = 60reg * 8bit
% - OUTPUTS
%   = spi            : updated spi cell array, if the control word is found
%   = updtMatch      : output structure; empty if no match, otherwise contains the following fields
%           .CHnum   : channel number   containing the control word
%           .CHpol   : channel polarity containing the control word
%           .ctrlName: searched control word
%           .spiIdx  : SPI indexes corresponding to the searched control word
%           .ctrlIdx : control word indexes, e.g. 12:0 for a 13 bit control word such as D_qcmp6_threshold
%           .sortIdx : sortIdx ;control word indexes sorted according to their weight in descending order,
%                      e.g. 12th bit is the first for D_qcmp6_threshold
%           .regNum  : regNum(spiIdx): register numbers, important to know to update the on-chip SPI
%           .regVal  : register values, array of binaries digit
%           .ctrlVal : decimal control word value, reconstructed from the register value

%% OPTIONAL INPUTS
ParsedIn = inputParser();

ParsedIn.addOptional('send2chip'      ,0);
ParsedIn.addOptional('fakeSend'       ,0);
ParsedIn.addOptional('slowFact'       ,64);
ParsedIn.addOptional('KRNOCid'        ,'KRNOC50');

ParsedIn.addOptional('slaveList'      ,{});
% if 1 warning are not shown, disabled by default
ParsedIn.addOptional('quietWarning'   ,0);
% disable update results by default 
ParsedIn.addOptional('printUpdate'    ,0);
% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('debugMSGverbose',0);
ParsedIn.addOptional('debugMSGsummary',0);
ParsedIn.addOptional('foundMSGsummary',0);
ParsedIn.addOptional('fmtLenSlave'    ,'%-10s');
ParsedIn.addOptional('fmtLenCtrlW'    ,'%-35s');
ParsedIn.addOptional('nRows'          ,480);

ParsedIn.parse(varargin{:});

send2chip       = ParsedIn.Results.send2chip;
fakeSend        = ParsedIn.Results.fakeSend;
slowFact        = ParsedIn.Results.slowFact;
KRNOCid         = ParsedIn.Results.KRNOCid;

slaveList       = ParsedIn.Results.slaveList;
% if 1 warning are not shown, disabled by default
quietWarning    = ParsedIn.Results.quietWarning;
% disable update results by default 
printUpdate     = ParsedIn.Results.printUpdate;
% for debug purposes in the printing function in get_spi_ctrlWords
debugMSGverbose = ParsedIn.Results.debugMSGverbose;
debugMSGsummary = ParsedIn.Results.debugMSGsummary;
foundMSGsummary = ParsedIn.Results.foundMSGsummary;
fmtLenSlave     = ParsedIn.Results.fmtLenSlave;
fmtLenCtrlW     = ParsedIn.Results.fmtLenCtrlW;
nRows           = ParsedIn.Results.nRows;

%% INPUT CHECK
if send2chip
    % if not 0, set it to 1; only 0 (don't send to chip) or 1 (send to chip) are allowed
    send2chip = 1;
end

if length(ctrlNameList) ~= length(ctrlValList)
    error('Number of control words names different from number of control words values!');
end

%% CONTROL WORDS SEARCH
listMatch = get_spi_ctrlWords(spi,ctrlNameList,'getFrom','MATLAB','slaveList',slaveList,...
                              'debugMSGverbose',debugMSGverbose,...
                              'debugMSGsummary',debugMSGsummary,'foundMSGsummary',foundMSGsummary,...
                              'fmtLenSlave',fmtLenSlave,'fmtLenCtrlW',fmtLenCtrlW,'nRows',nRows, ...
                              'quietWarning'   ,1);
                          
for indMatch=1:length(listMatch)
    % adapt the number of passed control word values to
    % the number of control words found
    indVal=find(strcmp(listMatch(indMatch).ctrlName,ctrlNameList));
    listValue{indMatch} = ctrlValList{indVal};
end

%% CONTROL WORDS SETUP
for indCtrl=1:length(listMatch)
    % current control word name and...
    ctrlMatch  = listMatch(indCtrl);
    % ... corresponding control word value
    ctrlValDec = listValue{indCtrl};
    
    if strcmp(ctrlMatch.status,'found') % control word and slave are known
        
        %% CHECKS CONTROL WORD VALUE AND CONVERT IT TO BINARY
        if ischar(ctrlValDec) % was isstr in 3C
            % if ctrlValDec is a string check if it is valid
            % and convert to the corresponding integer
            switch lower(ctrlValDec)
                case 'max'
                    ctrlValDec = 2^length(ctrlMatch.spiIdx)-1;
                case 'min'
                    ctrlValDec = 0;
                case 'mid'
                    ctrlValDec = floor(2^length(ctrlMatch.spiIdx)/2);
                otherwise
                    if ~quietWarning
                        warning(['Value ',ctrlValDec,' is unrecognized; set "',ctrlMatch.ctrlName,'" to 0.']);
                    end
                    ctrlValDec = 0;
            end
        else
            % check validness of ctrlValDec, i.e. bigger than 0 and smaller than
            % 2^(number of control word bit) - 1
            if ctrlValDec>2^length(ctrlMatch.spiIdx)-1
                if ~quietWarning
                    warning(['Value ',sprintf('% 10d',ctrlValDec),' is bigger  than the allowed maximum ',sprintf('% 10d',2^length(ctrlMatch.spiIdx)-1),'; set "',ctrlMatch.ctrlName,'" to the max.']);
                end
                ctrlValDec = 2^length(ctrlMatch.spiIdx)-1;
            elseif ctrlValDec<0
                if ~quietWarning
                    warning(['Value ',sprintf('% 10d',ctrlValDec),' is smaller than the allowed maximum ',sprintf('% 10d',                           0),'; set "',ctrlMatch.ctrlName,'" to the min.']);
                end
                ctrlValDec = 0;
            end
        end
        % convert the control value from decimal to binary,
        % the MSB is in the leftmost position
        ctrlValBin = dec2bin(ctrlValDec,length(ctrlMatch.spiIdx));
        
        %% SPI UPDATE
        slave2wr = ctrlMatch.slaveName;
        % update SPI in MATLAB
        if length(ctrlMatch.spiIdx)==1
            %spi.(slave2wr).slaveReg{nRows*3+ctrlMatch.spiIdx} = str2double(ctrlValBin);
            spi.(slave2wr).slaveReg{ctrlMatch.slaveSize*3+ctrlMatch.spiIdx} = str2double(ctrlValBin); %NM to accomodate for smaller slaves when needed
        else
            % update the bit of the control word in the spi cell array
            for ind=1:length(ctrlMatch.spiIdx)
                %spi.(slave2wr).slaveReg{nRows*3+ctrlMatch.spiIdx(ctrlMatch.sortIdx(ind))} = str2double(ctrlValBin((ind)));
                spi.(slave2wr).slaveReg{ctrlMatch.slaveSize*3+ctrlMatch.spiIdx(ctrlMatch.sortIdx(ind))} = str2double(ctrlValBin((ind)));%NM
            end
        end
        ctrlMatch.ctrlVal = ctrlValDec;
        
        % update SPI on-chip, if required
        if send2chip
            %send_onC_spi(spi,ctrlMatch,'fakeSend',fakeSend,'slowFact',slowFact,'nRows',nRows);
            send_onC_spi(spi,ctrlMatch,'fakeSend',fakeSend,'slowFact',slowFact,'nRows',ctrlMatch.slaveSize,'KRNOCid',KRNOCid);%NM
        end
        
        updateSTATUS = 'success: CtlrW updated';
        
    else % control word is not found in any slave
        if strcmp(ctrlMatch.status,'not found: Slave')
            updateSTATUS = 'FAILURE: Slave unknown';
        else
            updateSTATUS = 'FAILURE: CtlrW unknown';
        end
        ctrlValDec = NaN;
        slave2wr   = ctrlMatch.slaveName;        
    end
    updateSummary{indCtrl,:} = {updateSTATUS slave2wr ctrlMatch.ctrlName ctrlValDec};
end

% print update result if requested by setting printUpdate = 1
print_set_spi_ctrlWords(updateSummary,'printUpdate',printUpdate);

end