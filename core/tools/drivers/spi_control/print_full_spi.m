function listMatch = print_full_spi(spi,varargin)
% print_full_spi Print all control words in all/some slave(s) of SPI.
% - INPUTS
%   = spi            : structure of (480 rows x 4 columns) cell arrays
%(~ OPTIONAL INPUTS)
%   = getFrom        : read from either onChip or MATLAB SPI                          , 'MATLAB'     by default
%   = sortBy         : sort print by register number ('ctrlRegN') or name ('ctrlName'), 'ctrlName' by default
%   = sortOrder      : sort print in 'descend' or 'ascend' order                      , 'ascend' by default
%   = fakeSend       : plot the data frame instead of sending it                      , disabled (0) by default because for debug
%   = slowFact       : number of time each bit is repeated in the data frame          , 64 by default
%   = KRNOCid        : KRNOC ID                                                       , string
%   = slaveList      : cell array of slave to where the control words must be written , empty ({}) by default so all slaves are potentially written, 'all' to program in all registers
%   = fmtLenSlave    : used to align slave names in the debug message                 , default %-10s, i.e. left aligned 10 char long string
%   = fmtLenCtrlW    : used to align control word names in the debug message          , default %-35s, i.e. left aligned 35 char long string
%   = quiet          : if 1, suppress printing                                        , default 0 so that information are printed
% - OUTPUTS
%   = ctrlMatch      : output structure, array of structures
%          .ctrlName : searched control word
%          .status   : 'found' or 'not found' (if 'not found' the remaining fields below are set to NaN, if integers, or '', if strings)
%          .slaveName: slave name containing the control word
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
ParsedIn.addOptional('sortBy'         ,'ctrlName');
ParsedIn.addOptional('sortOrder'      ,'ascend');
ParsedIn.addOptional('fakeSend'       , 0);
ParsedIn.addOptional('slowFact'       ,64);
ParsedIn.addOptional('KRNOCid'        ,'KRNOC50');

ParsedIn.addOptional('slaveList'      ,{});

ParsedIn.addOptional('fmtLenSlave'    ,'%-10s');
ParsedIn.addOptional('fmtLenCtrlW'    ,'%-35s');

ParsedIn.addOptional('quiet'          , 0);

ParsedIn.parse(varargin{:});

getFrom         = ParsedIn.Results.getFrom;
sortBy          = ParsedIn.Results.sortBy;
sortOrder       = ParsedIn.Results.sortOrder;
fakeSend        = ParsedIn.Results.fakeSend;
slowFact        = ParsedIn.Results.slowFact;
KRNOCid         = ParsedIn.Results.KRNOCid;

slaveList       = ParsedIn.Results.slaveList;

fmtLenSlave     = ParsedIn.Results.fmtLenSlave;
fmtLenCtrlW     = ParsedIn.Results.fmtLenCtrlW;

quiet           = ParsedIn.Results.quiet;

%% INPUT CHECK
if ~(strcmp(getFrom,'onChip') || strcmp(getFrom,'MATLAB'))
    error(['getFrom equal to "',char(CHpol),'" is not allowed; allowed getFrom is either "onChip" or "MATLAB".']);
end

if ~(strcmp(sortBy,'ctrlRegN') || strcmp(sortBy,'ctrlName'))
    error(['sortBy equal to "',char(sortBy),'" is not allowed; allowed sortBy is either "ctrlRegN" (to sort by register number) or "ctrlName" (to sort by register name).']);
end

if ~(strcmp(sortOrder,'ascend') || strcmp(sortOrder,'descend'))
    error(['sortOrder equal to "',char(sortOrder),'" is not allowed; allowed sortOrder is either "descend" or "ascend".']);
end

%% CONTROL WORD SEARCH
listMatch = [];
indSearch = 0;

if isempty(slaveList) || (length(slaveList)==1 && strcmp(char(slaveList),'all'))
    % if slaveList empty or is equal to 'all' loop over all slaves
    slaveList = fieldnames(spi);
end

for indSlave=1:length(slaveList)
    if isfield(spi,slaveList{indSlave})
        % check that the slave exist, important if passed by the user
        slaveName = (slaveList{indSlave});
        % skip first three SPI bits (Reg 59, bit 7:5) because they
        % are always connected to In0_p, In1_p, In2_p
        spiAllWords  = {spi.(slaveName).slaveReg{(3+1):end,3}};
        for indWord=1:length(spiAllWords)
            % suppress all the <*> from multi-bit control words, so that the
            % subsequent 'unique' command can correctly operate
            % split by < and keep only the first match
            ctrlName = regexp(spiAllWords{indWord},'<','split');
            spiAllWords{indWord} = ctrlName{1};
        end
        
        % unique without sorting
        [ctrlList,idxList,~] = unique(spiAllWords,'stable');
        idxList(strncmpi(ctrlList,'NC',2))=[]; % suppress 'NC' from indexes...
        ctrlList(strncmpi(ctrlList,'NC',2))=[]; % ... and names lists
        
        % sort by default in ascending order
        if strcmp(sortBy,'ctrlRegN')
            % by register number
            [~,idxList] = sort(idxList);
            ctrlList = ctrlList(idxList);
        else
            % by control word name
            ctrlList = sort(ctrlList);
        end
        
        if strcmp(sortOrder,'descend')
            % flip vector if descending order is preferred
            ctrlList = fliplr(ctrlList);
        end
        
        % retrieve control words
        ctrlMatch = get_spi_ctrlWords(spi,ctrlList,...
                                      'slaveList',{slaveName},'getFrom' ,getFrom ,...
                                      'fakeSend' ,fakeSend   ,'slowFact',slowFact,'KRNOCid',KRNOCid);
        
        if ~quiet
            % print slave information
            disp(['=> start slave: name=',sprintf(fmtLenSlave,char(unique({ctrlMatch.slaveName}))),'/ id=',sprintf('% 3d',unique([ctrlMatch.slaveId])),'/ chain=',sprintf('% 3d',unique([ctrlMatch.slaveCh])),'/ #ctrl=',sprintf('% 3d',length(ctrlMatch)),'/ from=',getFrom]);
            % print control words name, number of bit and value
            fprintf([fmtLenCtrlW   ,', ','% 3s, ','% 6s\n'],...
                     'control word'     ,'Nb'    ,'value');
            for indCtrl=1:length(ctrlMatch)
                fprintf([fmtLenCtrlW                ,', ','% 3d, '                         ,'% 6d\n'],...
                         ctrlMatch(indCtrl).ctrlName     ,length(ctrlMatch(indCtrl).spiIdx),ctrlMatch(indCtrl).ctrlVal);
            end
            disp(['<= end   slave: name=',sprintf(fmtLenSlave,char(unique({ctrlMatch.slaveName}))),'/ id=',sprintf('% 3d',unique([ctrlMatch.slaveId])),'/ chain=',sprintf('% 3d',unique([ctrlMatch.slaveCh])),'/ #ctrl=',sprintf('% 3d',length(ctrlMatch)),'/ from=',getFrom]);
            disp(' ');
        end
        listMatch = [listMatch, ctrlMatch];
    else
        if ~quiet
            warning([slaveList{indSlave},' is not a slave of the SPI.']);
        end
    end
end

end