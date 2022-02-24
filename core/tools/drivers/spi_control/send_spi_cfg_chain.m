function TXdata = send_spi_cfg_chain(config,slowFact,KRNOCid,varargin)
% send_spi_cfg_chain Send configure chain command to the SPI.
% - INPUTS
%   = config    : 0 to deselect, 1 select chain 1, 4 select chain 2, 5 select chains 1 and 2
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
% Cf ChainCfg 1
%   - invokes:
%   cfg_chain_v = 1
%   SPIcfg("010",std_logic_vector(to_unsigned(cfg_chain_v,3)),"000","00000",master_SPIclk, SPI_CLK, SPI_CSN, SPI_MOSI, SPI_MISO);
%       - invokes:
%       CMD   = 010
%       Dummy = cfg_chain_v
%       SG    = 000
%       SA    = 00000
%       spi_access(sclk_out, cs_n_out, mosi_out,miso_in, clk_in,"00",CMD & Dummy ,SG & SA);

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;

%% INPUTS CHECK
switch config
    case 0
        % deselect
    case 1
        % chain 1
    case 2
        % chain 2
    case 5
        % chain 1 and 2
    otherwise
        error('Config allowed values are 0 (deselect), 1 (chain 1), 2 (chain 2), 5 (chain 1 and 2).');
end

%% FRAME CREATION AND SEND
CMD    = bin2dec('010');
Dummy  = config;
SG     = bin2dec('000');
SA     = bin2dec('00000');
TXdata = send_spi_cfg(CMD,Dummy,SG,SA,slowFact,KRNOCid,'fakeSend',fakeSend); % equivalent to SPIcfg in VHDL

end