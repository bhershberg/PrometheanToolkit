function TXdata = send_spi_frm(config_in,address_in,data_in,slowFact,KRNOCid,varargin)
% send_spi_frm Send a frame of data to the SPI.
% - INPUTS
%   = config_in : configuration, 2 char long string of '0' and '1'
%   = address_in: address      , 6 char long string of '0' and '1'
%   = data_in   : data         , 8 char long string of '0' and '1'
%   = slowFact  : number of time each bit is repeated in the data frame
%   = KRNOCid   : string representing the KRNOC ID
%(~ OPTIONAL INPUTS)
%   = fakeSend  : plot the data frame instead of sending it, disabled (0) by default because for debug
%   = plotCkO   : if 1, plot clock out in the fakeSend mode, disabled (0) by default
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
% procedure spi_access (
%     signal sclk_out  : out std_logic;
%     signal cs_n_out  : out std_logic;
%     signal mosi_out  : out std_logic;
%     signal miso_in   : in  std_logic;
%     signal clk_in    : in  std_logic;
%     config_in        : in  std_logic_vector( 1 downto 0);
%     address_in       : in  std_logic_vector( 5 downto 0);
%     data_in          : in  std_logic_vector( 7 downto 0)
%   ) is 
%   variable packet_v : std_logic_vector(15 downto 0);
%   begin
%     sclk_out    <= '0';
%     cs_n_out    <= '1';
%     mosi_out    <= '0';
%     packet_v    := config_in & address_in & data_in;
%     wait until falling_edge(clk_in);
%     cs_n_out    <= '0'; 
%     for k in 15 downto 0 loop
%       wait until rising_edge(clk_in);
%       sclk_out  <= '1';
%       mosi_out  <= packet_v(k);
%       wait until falling_edge(clk_in);
%       sclk_out  <= '0';
%     end loop;
%     wait until rising_edge(clk_in);
%     mosi_out    <= '0';
%     wait for 100 ps; -- avoid hold violations
%     cs_n_out    <= '1'; 
%   end procedure spi_access;

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('fakeSend',0);
ParsedIn.addOptional('plotCkO' ,0);
% ParsedIn.addOptional('DeviceName','KRNOC50');
% ParsedIn.addOptional('designName','ESSAR1');
ParsedIn.addOptional('programmerFunction', getGlobalOption('nocProgramFunction',NaN));
ParsedIn.parse(varargin{:});

fakeSend   = ParsedIn.Results.fakeSend;
plotCkO    = ParsedIn.Results.plotCkO;
% DeviceName = ParsedIn.Results.DeviceName;
programmerFunction = ParsedIn.Results.programmerFunction;

%% INPUTS CHECK
if config_in>(2^2-1) || config_in<0
    error(['0 <= confing_in <= ',sprintf('%d',(2^2-1))]);
end

if address_in>(2^6-1) || address_in<0
    error(['0 <= address_in <= ',sprintf('%d',(2^6-1))]);
end

if data_in>(2^8-1) || data_in<0
    error(['0 <= data_in <= ',sprintf('%d',(2^8-1))]);
end

%% FRAME CREATION
dataBin = [dec2bin(config_in ,2) ...
           dec2bin(address_in,6) ...
           dec2bin(data_in   ,8)];
data = NaN(size(dataBin));
for ind=1:length(dataBin)
    data(ind) = str2double(dataBin(ind));
end

% data = [0 data 0];

Nclk = length(data);

clk_in   = [0 0 repmat([1 0],1,Nclk) 0];
cs_n_out = [1 0 repmat([0 0],1,Nclk) 1];
clk_out  = clk_in;
packet   = [0 0 reshape(repmat(data,2,1),1,2*length(data)) 0];

TXdata.dataBin  = dataBin;
TXdata.slowFact = slowFact;
TXdata.clk_in   = reshape(repmat(clk_in  ,slowFact,1),1,slowFact*length(clk_in)  );
TXdata.cs_n_out = reshape(repmat(cs_n_out,slowFact,1),1,slowFact*length(cs_n_out));
TXdata.clk_out  = reshape(repmat(clk_out ,slowFact,1),1,slowFact*length(clk_out) );
TXdata.packet   = reshape(repmat(packet  ,slowFact,1),1,slowFact*length(packet)  );

%% PLOT OR SEND (SEND IS DEFAULT)
if fakeSend % plot the data
    if plotCkO
        [~,aH] = bus_plot([TXdata.packet.'    ...
                           TXdata.clk_out.'   ...
                           TXdata.cs_n_out.'  ...
                           TXdata.clk_in.'],  ...
               'BUSname',{'DATA';             ...
                          'CLKo';             ...
                          'CSn' ;             ...
                          'CLKi'},            ...
                           'figSize',[1000 90 600 600],'yLabels',1);
    else
        [~,aH] = bus_plot([TXdata.packet.'    ...
                           TXdata.cs_n_out.'  ...
                           TXdata.clk_in.'],  ...
               'BUSname',{'DATA';             ...
                          'CSn' ;             ...
                          'CLKi'},            ...
             'figSize',[1000 90 600 600],'yLabels',1);
    end
    aH.FontWeight = 'bold'; aH.LineWidth = 2; aH.XGrid = 'off';
    % annotate CLKi falling edges on the figure
    fallCLKi = find(diff(sign(TXdata.clk_in-0.5))<0)+0.5;
    for ind=1:length(fallCLKi)
        switch ind % change the color of the dashed lines at the limit of CFG,ADD,DAT
            case {1,...
                  1+length(TXdata.dataBin(1:2)),...
                  1+length(TXdata.dataBin(1:2))+length(TXdata.dataBin(3:8)),...
                    length(TXdata.dataBin)}
                lineCol = 'magenta';
                lineSty = '-';
            otherwise
                lineCol = [0.5 0.5 0.5];
                lineSty = ':';
        end
        plot([fallCLKi(ind) fallCLKi(ind)],[aH.YLim(1) aH.YLim(2)],lineSty,'Color',lineCol,'LineWidth',2)
%         if (ind>1 && ind<length(TXdata.dataBin)+2)
            text(fallCLKi(ind)+(aH.XLim(end)-aH.XLim(1))*1/100,1,TXdata.dataBin(ind),'VerticalAlignment','bottom','HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
%         end
    end
    title({['Frame ({\color{magenta}|}',                                       'CFG','{\color{magenta}|}',                                       'ADD','{\color{magenta}|}',                                         'DAT','{\color{magenta}|}):',...
                 ' ({\color{magenta}|}',                       TXdata.dataBin(1:2)  ,'{\color{magenta}|}',                       TXdata.dataBin(3:8)  ,'{\color{magenta}|}',                       TXdata.dataBin(9:end)  ,'{\color{magenta}|})b',... % bin form
                 '=({\color{magenta}|}',sprintf('% 2d',bin2dec(TXdata.dataBin(1:2))),'{\color{magenta}|}',sprintf('% 2d',bin2dec(TXdata.dataBin(3:8))),'{\color{magenta}|}',sprintf('% 3d',bin2dec(TXdata.dataBin(9:end))),'{\color{magenta}|})d',... % dec form
           ];['slowness factor=',num2str(TXdata.slowFact,'%d')]});
else % transmit the data
    
    %     ADCcs   = ones(size(TXdata.clk_in));    % ADCs sel  = 1: select SAR
    %     SPIrstn = ones(size(TXdata.clk_in));    % SPI RSTn  = 1: SPI not in reset
    %     SPIcsn  = TXdata.cs_n_out;              % SPI CSn generated by this function
    %     ADCrstn = ones(size(TXdata.clk_in));    % ADC RSTn  = 1: ADC not in reset
    %     PLINEcs = zeros(size(TXdata.clk_in));   % pline sel = 0: select T1 pipeline ADC, doesn't matter since SAR is selected
    %     SPIck   = TXdata.clk_in;                % SPI clock generated by this function
    %     SPIin   = TXdata.packet;                % SPI MOSI generated by this function
    %
    %     usb_noc((2^7).*ADCcs   + ...
    %             (2^6).*SPIrstn + ...
    %             (2^5).*SPIcsn  + ...
    %             (2^4).*ADCrstn + ...
    %             (2^3).*PLINEcs + ...
    %             (2^2).*SPIck   + ...
    %             (2^1).*SPIin     ...
    %             ,'device_name',KRNOCid);
    % %           (2^0).*          ... % SPI MISO is not programmed because it is an input
    
    programmerFunction(TXdata,KRNOCid);
% %     try
%         if exist('getDesignInfo','file')
%             info = getDesignInfo;
%         else
%             info.designName = designName;
%         end
%         switch info.designName
%             case 'ESSAR1'
%                 ESSAR1_sendSPI2Chip(TXdata,KRNOCid);
%             case 'HSADC4E'
%                 Type3_sendSPI2Chip(TXdata,KRNOCid);
%             otherwise
%                 warning(['Unrecognized designName ',info.designName,'.']);
%         end
% %     catch
% %         warning('getDesignInfo is undefined.');
% %     end
    

end

end