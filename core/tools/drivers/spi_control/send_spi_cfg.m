function TXdata = send_spi_cfg(CMD,Dummy,SG,SA,slowFact,KRNOCid,varargin)
% send_spi_cfg Send a configuration command to the SPI.
% - INPUTS
%   = CMD       : 3 char long string of '0' and '1'
%   = Dummy     : 3 char long string of '0' and '1'
%   = SG        : 3 char long string of '0' and '1'
%   = SA        : 5 char long string of '0' and '1'
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
% procedure SPIcfg (
%   CMD              : in  std_logic_vector( 2 downto 0);
%   Dummy            : in  std_logic_vector( 2 downto 0);
%   SG               : in  std_logic_vector( 2 downto 0);
%   SA               : in  std_logic_vector( 4 downto 0);
%   signal clk_in           : in  std_logic;
%   signal sclk_out         : out std_logic;
%   signal cs_n_out         : out std_logic;
%   signal mosi_out         : out std_logic;
%   signal miso_in          : in  std_logic
% ) is
% begin
%   spi_access(sclk_out, cs_n_out, mosi_out,miso_in, clk_in,"00",CMD & Dummy ,SG & SA);
%   wait until rising_edge(clk_in);
% end procedure SPIcfg;

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;

%% FRAME CREATION AND SEND
config_in  = bin2dec('00');
address_in = bin2dec([dec2bin(CMD,3) dec2bin(Dummy,3)]);
data_in    = bin2dec([dec2bin(SG ,3) dec2bin(SA   ,5)]);

TXdata = send_spi_frm(config_in,address_in,data_in,slowFact,KRNOCid,'fakeSend',fakeSend); % equivalent to spi_access in VHDL

end