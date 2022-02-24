function output=usb_noc(varargin)
% Function for programming the USB_NOC device. Tested with v1 of the
% devices.
% Requires that in the execution path you have:
%   - server_ftdi.exe
%   - client_ftdi_mex.mexw32
% 
% To send a vector of data pass it as the FIRST parameter as either a 
% vector of decimals (each decimal represents state of bus) or a string 
% (containing decimals).
% 
% Example:
% usb_noc([1:100]);   % programs 100 bytes to the device with data
%                     % 1,2,3,4,5,6,...,100
% 
% Optional:
%   - device_name : name of the device to be programmed (check label on PCB)
%   - debug (0/1) : prints debugging information
%   - server_exit  (0/1) : forces the server of device to quit immediately 
% (check other documentation) - allows for quick changing of calls with
%   named/anonymous devices. (seldom used)
% 
% IMPORTANT! The device name can also be taken from the global variable
%   USB_NOC_DEVICE_NAME    and it overrides the name given as a parameter
% to this function. This is useful if you want to have two matlabs open 
% for controlling two chips with the same code. Just set the variable to
% the device name attached to appropriate chip and run programming.
%  example: 
%      global USB_NOC_DEVICE_NAME;
%      USB_NOC_DEVICE_NAME = 'KRNOC1';
%      usb_noc([1:100]);    % device 'KRNOC1' will be programmed
%      
%      % to remove the global variable and use parameter-given names:
%      clear global USB_NOC_DEVICE_NAME;
%      usb_noc([1:100]);    % default (first) device will be programmed
% 
% version 1.0
% Kuba Raczkowski @imec 2012

p = inputParser();
p.addRequired('data');
p.addOptional('device_name','none');
p.addOptional('dump_to_file',0);
p.addOptional('readnow',0)
p.addOptional('debug',0);
p.addOptional('server_exit',0);

p.parse(varargin{:});

if p.Results.dump_to_file
    if ischar(p.Results.dump_to_file)
        filename = p.Results.dump_to_file;
    else
        filename = 'sent_to_usbnoc.txt';
    end
    fid = fopen(filename,'w');
    fprintf(fid,'%d ',p.Results.data);
    fclose(fid);
end

global sent_to_usbnoc;
sent_to_usbnoc = p.Results.data';

global USB_NOC_DEVICE_NAME; 
if ~isempty(USB_NOC_DEVICE_NAME)
    dev_name = USB_NOC_DEVICE_NAME;
else
 dev_name =  p.Results.device_name;
end

if p.Results.debug
    disp(dev_name);
end

if p.Results.readnow
    output = str2num(client_ftdi_mex('readnow', dev_name, p.Results.debug));
    return;
end

if ~p.Results.server_exit
    if ischar(p.Results.data)
        data = str2double(p.Results.data);
    else
        data = p.Results.data;
    end
    if size(data,1) > size(data,2)  % if ordered not like what we like
        data = data';
    end
    
    % fold the data into cell array to fit in the buffer (1000 elements)
    data_folded = {};
    if isunix
        chunk_size = 512;
    else
        chunk_size = 512;
    end
    chunks = ceil(length(data)/chunk_size);
    if chunks == 1 % no chunking needed
        data_folded(1) = {data};
    else
        for i = 1:chunks
            chunk_start = 1+chunk_size*(i-1);
            chunk_stop = chunk_size+chunk_size*(i-1);
            if chunk_stop > length(data)
                chunk_stop = length(data);
            end
            data_folded(i,:) = {data(chunk_start:chunk_stop)};
        end
    end
    
    % ok now time for programming
    for i = 1:size(data_folded,1)
        if isunix
            client_ftdi_mex(uint8(cell2mat(data_folded(i,:))), dev_name, p.Results.debug);
        else
            client_ftdi_mex(sprintf('%d ',cell2mat(data_folded(i,:))), dev_name, p.Results.debug);
        end
    end
else
    if isunix
        client_ftdi_mex(uint8(cell2mat(data_folded(i,:))), dev_name, p.Results.debug);
    else
        client_ftdi_mex('EXIT_USB_NOC', dev_name, p.Results.debug);
    end
end
