function readWords = read_onC_spi(spi,listWords,varargin)
% read_onC_spi Read control word(s) from on-chip SPI.
% - INPUTS
%   = spi               : structure of (480 rows x 4 columns) cell arrays
%   = listWords         : list of control words to be send
%(~ OPTIONAL INPUTS)
%   = getFrom           : read from either onChip or MATLAB SPI                , 'MATLAB' by default
%   = fakeSend          : plot the data frame instead of sending it            , disabled (0) by default because for debug
%   = slowFact          : number of time each bit is repeated in the data frame, 64 by default
%   = KRNOCid           : KRNOC ID                                             , string
% - OUTPUTS
%   = readWords         : same array of structures as listWords but with control val from on-chip
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
% from chip > .ctrlVal  : decimal control word value, reconstructed from the register value

%% OPTIONAL INPUTS
ParsedIn = inputParser();

ParsedIn.addOptional('getFrom' ,'MATLAB');
ParsedIn.addOptional('fakeSend',0);
ParsedIn.addOptional('slowFact',64);
ParsedIn.addOptional('KRNOCid' ,'KRNOC50');

ParsedIn.parse(varargin{:});

getFrom  = ParsedIn.Results.getFrom;
fakeSend = ParsedIn.Results.fakeSend;
slowFact = ParsedIn.Results.slowFact;
KRNOCid  = ParsedIn.Results.KRNOCid;

%% CONTROL WORDS SEARCH

for indCW=1:length(listWords) % loop through control words
    ctrlWord = listWords(indCW); fakePrint = 1;
    if strcmp(ctrlWord.status,'found')
        % read only if the control word is found
        if strcmp(getFrom,'MATLAB')
            cwVal = ctrlWord.ctrlVal;
        else
            % bit weight
            wgtList = (ctrlWord.ctrlIdx).';
            % bit value init
            bitVal = NaN(1,length(ctrlWord.spiIdx));
            % read the register the first time
            prevSlaveCH = -1;
            prevSlaveID = -1;
            prevSlaveRG = -1;
            for indBit=1:length(ctrlWord.spiIdx)
                % update current slave ID and register number
                currSlaveCH = spi.(ctrlWord.slaveName).slaveCh;
                currSlaveID = spi.(ctrlWord.slaveName).slaveId;
                currSlaveRG = spi.(ctrlWord.slaveName).slaveReg{ctrlWord.spiIdx(indBit),1};
                % bit position in the register (+ 1 because MATLAB array start with index 1 while reg bit are from 7:0)
                bitPos      = spi.(ctrlWord.slaveName).slaveReg{ctrlWord.spiIdx(indBit),2} + 1;
                
                if ((prevSlaveCH~=currSlaveCH) || (prevSlaveID~=currSlaveID) || (prevSlaveRG~=currSlaveRG))
                    % if either the slave chain, slave ID or the register number have changed
                    % with respect to previous iteration, the new register will be read
                    readReg = 1;
                    if (prevSlaveCH~=currSlaveCH)
                        % if the slave chain is changed, update it
                        prevSlaveCH = currSlaveCH;
                        fakePrint = 1;
                    end
                    if (prevSlaveID~=currSlaveID)
                        % if the slave ID is changed, update it
                        prevSlaveID = currSlaveID;
                        % and send slave selection
                        send_spi_cfg_slaveSel(currSlaveCH*32+currSlaveID,slowFact,KRNOCid,'fakeSend',fakeSend);
                        fakePrint = 1;
                    end
                    if (prevSlaveRG~=currSlaveRG)
                        % if the slave register number is changed, update it
                        prevSlaveRG = currSlaveRG;
                        fakePrint = 1;
                    end
                else
                    % neither the slave ID nor the register number have changed,
                    % there is no need to read the register again
                    readReg = 0;
                end
                if ~fakeSend
                if readReg
                    % retrieve the register from the SPI and flip
                    % its dec2bin form so that LSB is at position 1
                    onCreg = fliplr(dec2bin(SPIread_usbnoc(KRNOCid,currSlaveID,currSlaveRG),8));
                end
                % convert bit from str to double
                bitVal(indBit) = str2double(onCreg(bitPos));
                else
                    if fakePrint
                        cwVal = ctrlWord.regVal; fakePrint = 0;
                        % show reading command only first time for multi                       % bit control words
                        disp(['Reading from chain #',sprintf('% 1d',currSlaveCH),', slave #',sprintf('% 2d',currSlaveID),', register #',sprintf('% 2d',currSlaveRG),'.']);
                    end
                end
            end
            % for one bit control word the wgt is 0
            if length(ctrlWord.spiIdx)==1
                wgtList = 0;
            end
            if ~exist('cwVal','var')
                % reconstruct the decimal control word when the COM is not faked
                % the ~exist evaluate to 1 only if the COM is not faked
                cwVal = sum(bitVal.*(2.^wgtList));
            end
        end
        % update the readWords with the cwVal from onChip
        if length(listWords)==1
            readWords = ctrlWord;
            readWords.ctrlVal = cwVal;
        else
            readWords(indCW) = ctrlWord(indCW);
            readWords(indCW).ctrlVal = cwVal;
        end
    end
end

end