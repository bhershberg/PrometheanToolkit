function SNval=SPIread_usbnoc(DeviceName, SNaddr,SNreg)
% function SPIread read data from the SPI interface board.
%
% Syntax: SNval=SPIread_usbnoc(DeviceName, SNaddr,SNreg)
%
% Input:
%
%    DeviceName:   Device name of the USBNOC interface board.
%    SNaddr:       Address of the SPI slave-node.  
%    SNreg:        Register number of the SPI slave-node
%
%    (SNaddr, SNreg can be arrays of data to read.
%
% Output:
%
%    SNval:        Value read from SNreg.
%
% Example: SNval = SPIread_usbnoc(DeviceName, 33, 2)
%
% Author: Kristof Vaesen
% Date:   10/2017 - V0.1
% Data:   10/2018 - V0.2 Adapted for array read

curSNaddr=NaN; % stores current SN address
SPIbuf=[]; % SPÏ write buffer
% SPIrdbuf=[]; % SPÏ read buffer
for k=1:length(SNreg)
    if SNaddr(k)~=curSNaddr % Slave node address needs to be selected
        curSNaddr=SNaddr(k);
        if ~bitand(31,SNaddr(k)) % Low slave node address is 0 --> Group addressing
            SPIbuf=[SPIbuf 40 SNaddr(k)]; % CFG command to change SN group address
        else % Full slave node address
            SPIbuf=[SPIbuf 32 SNaddr(k)]; % CFG command to change SN address
        end
    end
    SPIbuf=[SPIbuf (128+SNreg(k)) 0]; % Adds a read command to the write buffer
end
% Write data to the SPI interface
global DEBUG
if DEBUG==1
    for k=1:2:length(SPIbuf)
        fprintf('SPI CMD: %s %d\n',dec2bin(SPIbuf(k),8), SPIbuf(k+1));
    end
    % Generate random numbers
    SNval=floor(rand(1,length(SNreg))*255);
elseif DEBUG==2
    for k=1:2:length(SPIbuf)
        fprintf('SPI CMD: %x, %d\n',SPIbuf(k), SPIbuf(k+1));
    end
    % Read the data
    SNval=ftdi_spi_write(SPIbuf, DeviceName);
else
    % Read the data
    SNval=ftdi_spi_write(SPIbuf, DeviceName);
end

