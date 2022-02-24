function sendWords = send_onC_spi(spi,listWords,varargin)
% send_onC_spi Send control word(s) to on-chip SPI.
% - INPUTS
%   = spi               : structure of (480 rows x 4 columns) cell arrays
%   = listWords         : list of control words to be send
%(~ OPTIONAL INPUTS)
%   = fakeSend          : plot the data frame instead of sending it            , disabled (0) by default because for debug
%   = slowFact          : number of time each bit is repeated in the data frame, 64 by default
%   = KRNOCid           : KRNOC ID                                             , string
% - OUTPUTS
%   = sendWords         : same array of structures as listWords
%             .ctrlName : searched control word
%             .status   : 'found' or 'not found' (if 'not found' the remaining fields below are set to NaN, if integers, or '', if strings)
%             .slaveName: slave name containing the control word
%             .slaveId  : slave ID containing the control word
%             .spiIdx   : SPI indexes corresponding to the searched control word
%             .ctrlIdx  : control word indexes, e.g. 12:0 for a 13 bit control word such as D_qcmp6_threshold
%             .sortIdx  : sortIdx ;control word indexes sorted according to their weight in descending order,
%                         e.g. 12th bit is the first for D_qcmp6_threshold
%             .regNum   : regNum(spiIdx): register numbers, important to know to update the on-chip SPI
%             .regVal   : register values, array of binaries digit
%             .ctrlVal  : decimal control word value, reconstructed from the register value

%% OPTIONAL INPUTS
ParsedIn = inputParser();

ParsedIn.addOptional('fakeSend' ,0);
ParsedIn.addOptional('slowFact',64);
ParsedIn.addOptional('KRNOCid' ,'KRNOC50');
ParsedIn.addOptional('nRows'   ,480);

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;
slowFact = ParsedIn.Results.slowFact;
KRNOCid  = ParsedIn.Results.KRNOCid;
nRows    = ParsedIn.Results.nRows;

%% CONTROL WORDS SEARCH

for indCW=1:length(listWords)
    ctrlWord = listWords(indCW);
    if strcmp(ctrlWord.status,'found')
        regList = ctrlWord.regNum;
        % chain and slave selection, chain number is multiplied by 32 as in VHDL code
        send_spi_cfg_slaveSel(ctrlWord.slaveCh*32+ctrlWord.slaveId,slowFact,KRNOCid,'fakeSend',fakeSend);
        for ind=1:length(regList)
            % find the register address in the spi structure
            address_in  = regList(ind);
            regIdx      = find([spi.(ctrlWord.slaveName).slaveReg{:,1}]==address_in);
            % create the register value from the spi structure
            data_in     = sum((2.^(length(regIdx)-1:-1:0)).*([spi.(ctrlWord.slaveName).slaveReg{nRows*3+regIdx}]));
            % send the register value
            TXdata      = send_spi_reg(address_in,data_in,slowFact,KRNOCid,'fakeSend',fakeSend);
        end
        if length(listWords)==1
            sendWords = ctrlWord;
        else
            sendWords(indCW) = ctrlWord(indCW);
        end
    end
end

end