function TXdata = send_spi_reg(address_in,data_in,slowFact,KRNOCid,varargin)
% send_spi_reg Write data_in to address_in register.
% - INPUTS
%   = address_in: address      , 6 char long string of '0' and '1'
%   = data_in   : data         , 8 char long string of '0' and '1'
%   = slowFact  : number of time each bit is repeated in the data frame
%   = KRNOCid   : string representing the KRNOC ID
%(~ OPTIONAL INPUTS)
%   = fakeSend  : plot the data frame instead of sending it, disabled (0) by default because for debug
%   = Wtype     : default Wr, i.e. config_in = '01', can be Wc as in
%                 simulation, i.e. config_in = '11'
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
% Wr 3B 82
%   - invokes:
%   address_in = 59 (3B hex)
%   data_in    = 82
%   SPIwr(addr_v(5 downto 0), data_v, master_SPIclk, SPI_CLK, SPI_CSN, SPI_MOSI, SPI_MISO);
%       - invokes
%       address_in = 59 (3B hex)
%       data_in    = 82
%       spi_access(sclk_out, cs_n_out, mosi_out,miso_in, clk_in, "01", address_in,data_in);

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);
ParsedIn.addOptional('Wtype'   ,'Wc');

ParsedIn.parse(varargin{:});

fakeSend = ParsedIn.Results.fakeSend;
Wtype    = ParsedIn.Results.Wtype;

%% INPUTS CHECK
if     address_in>59
    warning('Register address must be <= 59. It is forced to be = 59.');
    address_in = 59;
elseif address_in<0
    warning('Register address must be >=  0. It is forced to be =  0.');
    address_in =  0;
end

if     data_in>255
    warning('8b register value must be <= 255. It is forced to be = 255.');
    data_in = 255;
elseif data_in<0
    warning('8b register value must be >=   0. It is forced to be =   0.');
    data_in =   0;
end

%% FRAME CREATION AND SEND

switch Wtype
    case 'Wr'
        config_in  = bin2dec('01');
    case 'Wc'
        config_in  = bin2dec('11');
    otherwise
        error(['Unrecognized choice "',Wtype,'". Allowed choices are "Wr" and "Wc".']);
end
    
TXdata = send_spi_frm(config_in,address_in,data_in,slowFact,KRNOCid,'fakeSend',fakeSend);

end