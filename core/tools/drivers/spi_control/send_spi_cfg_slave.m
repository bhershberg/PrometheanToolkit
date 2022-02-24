function TXdata = send_spi_cfg_slave(slaveID,slowFact,KRNOCid,varargin)
% send_spi_cfg_slave Send a configure command to one of the SPI's slave.
% - INPUTS
%   = slaveID   : ID of the slave, integer from 0 to 255
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
% Cf SlaveCfg 1 0
%   - invokes:
%   cfg_SG_v = 1, group address
%   cfg_SA_v = 0, slave address
%   SPIcfgConfigSlaveNode(cfg_SG_v*32+cfg_SA_v,master_SPIclk, SPI_CLK, SPI_CSN, SPI_MOSI, SPI_MISO);
%       - invokes:
%       SG = bit 7 to 5 (MSB   to MBS-2) of slaveID=(cfg_SG_v*32+cfg_SA_v), group address
%       SA = bit 4 to 0 (MSB-3 to LSB  ) of slaveID=(cfg_SG_v*32+cfg_SA_v), slave address
%       SPIcfg("011","000",SG,SA,clk_in,sclk_out,cs_n_out,mosi_out,miso_in);
%           - invokes:
%           CMD   = 011
%           Dummy = 000
%           SG    = bit 7 to 5 (MSB   to MBS-2) of slaveID=(cfg_SG_v*32+cfg_SA_v), group address
%           SA    = bit 4 to 0 (MSB-3 to LSB  ) of slaveID=(cfg_SG_v*32+cfg_SA_v), slave address
%           spi_access(sclk_out, cs_n_out, mosi_out,miso_in, clk_in,"00",CMD & Dummy ,SG & SA);

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;

%% INPUTS CHECK
if slaveID>(2^8-1) || slaveID<0
    error(['0 <= slaveID <= ',sprintf('%d',(2^8-1))]);
end

%% FRAME CREATION AND SEND
slaveIDbin = dec2bin(slaveID,8);

CMD    = bin2dec('011');
Dummy  = bin2dec('000');
SG     = bin2dec(slaveIDbin(1:3)); % MSB   to MBS-2
SA     = bin2dec(slaveIDbin(4:8)); % MSB-3 to LSB
TXdata = send_spi_cfg(CMD,Dummy,SG,SA,slowFact,KRNOCid,'fakeSend',fakeSend); % equivalent to SPIcfg in VHDL

end