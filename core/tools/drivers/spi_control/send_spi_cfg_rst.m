function TXdata = send_spi_cfg_rst(slowFact,KRNOCid,varargin)
% send_spi_cfg_rst Send reset command to the SPI.
% - INPUTS
%   = slowFact  : number of time each bit is repeated in the data frame
%   = KRNOCid   : string representing the KRNOC ID
%(~ OPTIONAL INPUTS)
%   = fakeSend  : plot the data frame instead of sending it, disabled (0) by default because for debug
% - OUTPUTS
%   = TXdata    : output structure of transmitted data, contains the following fields
%           .dataBin  : [config address_in data_in]
%           .slowFact : number of time each bit is repeated in the data frame
%           .clk_in   : 1(starting) + 2(cfg) + 6(add) + 8(dat) clock periods, each sample repeated slowFact times
%           .cs_n_out : stay lows as long as clk_in oscillate, each sample repeated slowFact times
%           .clk_out  : same as clk_in, each sample repeated slowFact times
%           .packet   : dataBin, each sample repeated slowFact time
%
% Corresponding VHDL code:
% Cf RstSlave
%   - invokes:
%   SPIcfgResetSlaveNodeCfgAndRegs(master_SPIclk, SPI_CLK, SPI_CSN, SPI_MOSI, SPI_MISO);
%       - invokes:
%       SPIcfg("000","000","000","00000",clk_in,sclk_out,cs_n_out,mosi_out,miso_in);
%           - invokes:
%           CMD   = 000
%           Dummy = 000
%           SG    = 000
%           SA    = 00000
%           spi_access(sclk_out, cs_n_out, mosi_out,miso_in, clk_in,"00",CMD & Dummy ,SG & SA);

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;

%% FRAME CREATION 
CMD    = bin2dec('000');
Dummy  = bin2dec('000');
SG     = bin2dec('000');
SA     = bin2dec('00000');
TXdata = send_spi_cfg(CMD,Dummy,SG,SA,slowFact,KRNOCid,'fakeSend',fakeSend); % equivalent to SPIcfg in VHDL

end