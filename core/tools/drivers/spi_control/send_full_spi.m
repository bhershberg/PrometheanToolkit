function spi = send_full_spi(spi,varargin)
% send_full_spi Send all control words in all/some slave(s) of SPI.
% - INPUTS
%   = spi            : structure of (480 rows x 4 columns) cell arrays
%(~ OPTIONAL INPUTS)
% > get SPI options
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
% > set SPI options
%   = send2chip      : if 0 update the MATLAB SPI only; if 1 send also to on-chip SPI, don't send to chip (0) by default
%   = debugMSGverbose: print registers corresponding to the searched control word    , disabled (0) by default
%   = debugMSGsummary: print control word and its decimal value                      , disabled (0) by default
% - OUTPUTS
%   = spi            : updated structure of (480 rows x 4 columns) cell arrays

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

ParsedIn.addOptional('send2chip'      ,0);
% if 1 warning are not shown, disabled by default
ParsedIn.addOptional('quietWarning'   ,0);
% disable update results by default 
ParsedIn.addOptional('printUpdate'    ,0);
% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('debugMSGverbose',0);
ParsedIn.addOptional('debugMSGsummary',0);
ParsedIn.addOptional('foundMSGsummary',0);

ParsedIn.addOptional('nRows'          ,480);

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

send2chip       = ParsedIn.Results.send2chip;
quietWarning    = ParsedIn.Results.quietWarning;
printUpdate     = ParsedIn.Results.printUpdate;
debugMSGverbose = ParsedIn.Results.debugMSGverbose;
debugMSGsummary = ParsedIn.Results.debugMSGsummary;
foundMSGsummary = ParsedIn.Results.foundMSGsummary;

nRows           = ParsedIn.Results.nRows;

%%
% get control words list and values
ctrlList     = print_full_spi(spi,...
                              'getFrom'  ,getFrom  ,'sortBy'  ,sortBy  ,'sortOrder',sortOrder,...
                              'fakeSend' ,fakeSend ,'slowFact',slowFact,'KRNOCid'  ,KRNOCid,...
                              'slaveList',slaveList,...
                              'fmtLenSlave',fmtLenSlave,'fmtLenCtrlW',fmtLenCtrlW,...
                              'quiet',quiet);
ctrlNameList = {ctrlList.ctrlName};
ctrlValList  = {ctrlList.ctrlVal };
% set control words list and values
spi = set_spi_ctrlWords(spi,ctrlNameList,ctrlValList, ...
                        'send2chip',send2chip,'fakeSend',fakeSend,'slowFact',slowFact,'KRNOCid',KRNOCid,...
                        'slaveList',slaveList,...
                        'quietWarning'   ,quietWarning   ,'printUpdate'    ,printUpdate    ,...
                        'debugMSGverbose',debugMSGverbose,'debugMSGsummary',debugMSGsummary,'foundMSGsummary',foundMSGsummary,...
                        'fmtLenSlave'    ,fmtLenSlave    ,'fmtLenCtrlW'    ,fmtLenCtrlW    ,...
                        'nRows',nRows);

end