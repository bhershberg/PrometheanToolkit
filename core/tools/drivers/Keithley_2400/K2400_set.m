function K2400_set(varargin)

% NAME
%    K2400_set
%
% DESCRIPTION
%    Sets the voltage of a Keihtley 2400 voltage source
%
% USE
%    K2400_set('NVset', vsource, 'Non', true)
%
% INPUTS
%    Name-value pairs:
%      'NVset' : sets the DC voltage
%      'Non'   : [true|false] turns on/off the DC source
%      'GPIBaddress' : [24*] sets GPIB address
%      'Mode' : CURR|VOLT
%
% AUTHOR
%    Ewout Martens (imec) - CONFIDENTIAL
%    Nereo Markulic

%% Arguments
vsource = NaN; NVset = false;
ON  = NaN; Non   = false;
vlimit = NaN;
ilimit = NaN;
isource = NaN;
GPIBaddress = 24;
for k = 1:2:nargin,
  name = validatestring(varargin{k}, {'NVset','Non','GPIBaddress', 'Mode', 'Iset', 'Vlimit', 'Ilimit'});
  switch name,
   case 'NVset',
    vsource = varargin{k+1};
    Vrange = 10^ceil(log10(vsource));
   case 'Non',
    ON = varargin{k+1};
   case 'GPIBaddress',
    GPIBaddress = varargin{k+1};
   case 'Mode'
    mode = varargin{k+1};
   case 'Iset'
    isource  = varargin{k+1}; 
    Irange = 10^ceil(log10(abs(isource)));
   case 'Vlimit'
    vlimit  = varargin{k+1};     
   case 'Ilimit'
    ilimit  = varargin{k+1};     
  end
end

% Open interface
k2400 = gpib('ni', 0, GPIBaddress); %% second keithley has address 23 !
k2400.InputBufferSize = 512;

fopen(k2400)
fprintf(k2400,':*RST')                      %reset
% setup the 2400 to generate an SRQ on buffer full 
fprintf(k2400,':*ESE 0')                    %program standard Event Enable Register 0..65535
fprintf(k2400,':*CLS')                      %reset registers
fprintf(k2400,':STAT:MEAS:ENAB 512')        %Enable buffer full for the measurement register set
fprintf(k2400,':*SRE 1')                    %Program the service request register 0..255
fprintf(k2400,':SYST:BEEP:STAT 0');

% setup voltage source
if strcmpi(mode,'VOLT') && ON
    if ~isnan(vsource)
      fprintf(k2400,':SOUR:FUNC:MODE VOLT')
      fprintf(k2400,':SOUR:VOLT:MODE FIXED')
      fprintf(k2400,[':SOUR:VOLT:RANGE ', num2str(Vrange)])
      fprintf(k2400,[':SOUR:VOLT:LEV ',num2str(vsource)])
      if ~isnan(ilimit)
           fprintf(k2400,[':SENS:CURR:PROT ', num2str(ilimit)]); 
           fprintf(k2400,[':SENS:VOLT:PROT ', num2str(1.25*vsource)]);
      end
    end
elseif strcmpi(mode,'CURR') && ON
      if ~isnan(isource)
      fprintf(k2400,':SOUR:FUNC:MODE CURR')
      fprintf(k2400,':SOUR:CURR:MODE FIXED')
      fprintf(k2400,[':SOUR:CURR:RANGE ', num2str(Irange)])
      fprintf(k2400,[':SOUR:CURR:LEV ', num2str(isource)])
      if ~isnan(vlimit) 
          fprintf(k2400,[':SENS:VOLT:PROT ',num2str(vlimit)]); 
          fprintf(k2400,[':SENS:CURR:PROT ', num2str(1.25*isource)]);
      end
      
      end
end
%% turn on or off
if ~isnan(ON),
  if ON,
    fprintf(k2400,':OUTP ON')
    pause(0.2);
    fprintf(k2400,':INIT')
  else
    fprintf(k2400,':OUTP OFF')
  end
  
end


%% Close the interface
fclose(k2400)
delete(k2400)
clear k2400







% function K2400_set(varargin)
% 
% % NAME
% %    K2400_set
% %
% % DESCRIPTION
% %    Sets the voltage of a Keihtley 2400 voltage source
% %
% % USE
% %    K2400_set('NVset', VDD, 'Non', true)
% %
% % INPUTS
% %    Name-value pairs:
% %      'NVset' : sets the DC voltage
% %      'Non'   : [true|false] turns on/off the DC source
% %      'GPIBaddress' : [24*] sets GPIB address
% %
% % AUTHOR
% %    Ewout Martens (imec) - CONFIDENTIAL
% 
% %% Arguments
% VDD = NaN; NVset = false;
% ON  = NaN; Non   = false;
% GPIBaddress = 24;
% for k = 1:2:nargin,
%   name = validatestring(varargin{k}, {'NVset','Non','GPIBaddress'});
%   switch name,
%    case 'NVset',
%     VDD = varargin{k+1};
%    case 'Non',
%     ON = varargin{k+1};
%    case 'GPIBaddress',
%     GPIBaddress = varargin{k+1};
%   end
% end
% 
% % Open interface
% k2400 = gpib('ni', 0, GPIBaddress); %% second keithley has address 23 !
% k2400.InputBufferSize = 512;
% 
% fopen(k2400)
% fprintf(k2400,':*RST')                      %reset
% % setup the 2400 to generate an SRQ on buffer full 
% fprintf(k2400,':*ESE 0')                    %program standard Event Enable Register 0..65535
% fprintf(k2400,':*CLS')                      %reset registers
% fprintf(k2400,':STAT:MEAS:ENAB 512')        %Enable buffer full for the measurement register set
% fprintf(k2400,':*SRE 1')                    %Program the service request register 0..255
% 
% % setup voltage source
% if ~isnan(VDD),
%   fprintf(k2400,':SOUR:FUNC:MODE VOLT')
%   fprintf(k2400,':SOUR:VOLT:MODE FIXED')
%   fprintf(k2400,':SOUR:VOLT:RANGE 10')
%   fprintf(k2400,[':SOUR:VOLT:LEV ',num2str(VDD)])
% end
% 
% %% turn on or off
% if ~isnan(ON),
%   if ON,
%     fprintf(k2400,':OUTP ON')
%   else
%     fprintf(k2400,':OUTP OFF')
%   end
%   fprintf(k2400,':INIT')
% end
% 
% pause(1)
% 
% %% Close the interface
% fclose(k2400)
% delete(k2400)
% clear k2400
