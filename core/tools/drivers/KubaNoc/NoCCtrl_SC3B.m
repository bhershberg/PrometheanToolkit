function CTRL_STRUCT = NoCCtrl_SC3B(varargin)

% function NoCCtrl enables NoC-CTRL from MATLAB.
%
%  NI-USB6221 pin configuration:
%   - P0.1:            NocCE     (chip select - active high)
%   - P0.2/P2.4:       NocCLK    (chip clock output)
%   - P0.3:            NocRST    (chip reset - active low)
%   - P0.4:            NocTE     (transfer enable/flush - active high)
%   - P0.6:            NocDi     (serial data chip input)
%
% Syntax: 
%  CtrlStr = NoCCtrl(ParName1,ParValue1,<ParName2,ParValue2,...>,...
%            <ParName_OFF1,ParValue_OFF1,...>,'group',GroupName,...
%            <'ToFile',ToFileValue>,<'CLKD',CLKDValue>,<'Ns',NsValue>,...
%            <'SmartNoc',SmartNocValue>,<'DevName',DevNameValue>,
%            <PinName,PinValue>); 
%
%  Where
%    <...>:         Optional
%    CtrlStr:       Struct of the current NoC setting (from global variable CTRL_STRUCT) 
%    ParName1:      Name (string) of the parameter e.g. 'RXPLL_SD_NFRAC'
%    ParValue1:     Value (binary(string) or decimal) of the parameter e.g. '1'
%    ParName_OFF1:  Name (string) of the parameter followed by '_OFF' e.g. 'RXPLL_SD_NFRAC_OFF'
%                   This should only be used if a specific bit of ParName1 should be changed.
%                   The value is specified in ParValue and should be 0, 1, '0' or '1' 
%    ParValue_OFF1: Location of the bit (offset) in the parameter ParName1 to change 
%    GroupName:     Name of the group. All parameters called in the same function call should
%                   be member of the SAME group!!!
%    ToFileValue:   Specifies if the NoC stream should be written to a file or USBNOC interface OR
%				    to the USB-6221 interface. If present it allows for binary comibnations between:
%                   1: ctrlwv.txt (columns of streams),
%                   2: ctrlwv.mat
%                   4: ctrlwv_vect:txt (stream of decimal states)
%                   8: USB-NOC interface
%                   16: SPIDER board interface
%                   32: USB-6221 interface (a duplicate of default to increase support and maintain 
%                   compatibility)
%                    [0/1/2/4/8/16/32] (default: 8)
%					WARNING! The version you see works by default with the USB-NOC interface. If that's not
%					what you wanted, please remove the directory containing the driver from the list
%					ALSO: it
%    CLKDValue:     Specifies if the CLK is taken from data line P0.2 rather than from P2.4. If
%                   CLKD=1, the DIO speed is halved. [0/1] (default: 0)
%    NsValue:       Number of slaves in the NoC in decimal value; this determines the amount of
%                   additional clk cycles to complete the NoC loop. (default: 6)
%    SmartNocValue: Activates the smart Noc programming which avoids to program specific parameters
%                   which are not changed. Option 2 gives a notice when parameters are not
%                   changed. [0/1/2] (default:0)
%    DevNameValue:  Allows to specify the deviceName (as a string) of the programmer which is addressed.
%                   This feature is useful when multiple programmators are
%                   attached
%                   The devicename can be obtained via NI-MAX software for NI-6221 boxes or
%                   found on the device board for the USB_NOC (FTDI based) boards. For spider boards
%                   it is the serial number of the board.
%    PinName:       The pins that may be configured during a NoC instruction are 'P07', 'P01' and 'P00'
%                   corresponding to P0.7, P0.1 and P0.0.
%    PinValue:      Value to configure to put on the pin specified by the PinName [0/1] (default:0).
%                   This value should not be a vector.
%    LocalCtrlStr:  If passed as parameter the CtrlStr is not global, but instead the value passed is used
%                   as reference. This might slow down programming, but is necessary when >1 devices are 
%                   used simultaneusly.
%
%
%
% Function overload for RESET, RETURN STRUCT and VERSION CHECK
%   RESET:         CtrlStr = NoCCtrl('reset');  or CtrlStr = NoCCtrl('reset',1,'ToFile',ToFileValue);
%   RETURN STRUCT: CtrlStr = NoCCtrl;  
%   VERSION CHECK: CtrlStr = NoCCtrl('version');
%
% Good practice: combine different parameters of the same group in one
% single function call to optimize programming speed!!
% 
% Note:  1. The script 'defaultCtrl.m', located in the execution path,
%           contains the NoC definition structure of your application. This
%           script is automatically generated from the NoC development tool.
%        2. DIO should be functional (NI-DAQmx USB drivers) and MATLAB 
%           driver usb6221Control should be in execution path.
%
% examples:
%     CtrlStr = NoCCtrl('reset');
%     CtrlStr = NoCCtrl('RXPLL_SD_NFRAC','111111111111111111111111','group','PLL_DIV');
%     CtrlStr = NoCCtrl('RXPLL_SD_NFRAC','11111111111111111111111','RXPLL_DIV_ICTRL','00','group','PLL_DIV','ToFile',1);
%     CtrlStr = NoCCtrl('RXPLL1_Prescaler_band','11111111111111111111','RXPLL1_Prescaler_DAC1','10','group','PLL1_PRESC','ToFile',1,'SmartNoc',1);
%     CtrlStr = NoCCtrl('RXPLL1_Prescaler_band','11111111111111111111','RXPLL1_Prescaler_DAC1','10','group','PLL1_PRESC','ToFile',1,'SmartNoc',1,'P01',1);
%     CtrlStr = NoCCtrl;
%     combine normal programming with specific bit programming
%     CtrlStr = NoCCtrl('RXPLL_SD_NFRAC','1','RXPLL_SD_NFRAC_OFF',2,'RXPLL_DIV_ICTRL','00','group','PLL_DIV');
%
% Author:   Debaillie Bjorn
% Date:     07/2011 - V1.4
% With modifications of Kuba Raczkowski 
% Date:     01/2013 - V2.0
% Date:     08/2012 - V2.1
% With Modification of Mark Ingels
% Data:     08/2013 - V3.0
% Git:      $Id$
% Confidential and Copyright Protected
%


% KR: What I modified:
%  - changed evals to dynamic mappings in structs
%  - changed loops writing to files to write only once, construct string in
%     memory
%  - removed the piece that opened files
%  - changed tofile handling - now you can select one or more save options
%  - changed little things according to matlab suggestions (like strmpi...)
%  - addedd support for the FTDI controller via client_ftdi() function
%  - changed calls to exist() to fit what we look for ('var' or 'file')
%  - changed the way concatenation of streams is done in downloadCtrl
%  - changed the loop concatenating _OFF to names
%  - Added support for the FTDI-based USBNOC device
%  - Added support for spider board

% MI Modification
% The script is modified to allow for the concurrent programmation of the 
% Scaldio3B memory spi interface.
% In casu this means that the corresponding bits in the interface should
% not be modified from their previous values. 
% As CE is now used in the interface, it can not have a default 1 value
%

%3.0 Begin----------------------------------     
% Restore Last settings 
global sent_to_usbnoc
if ~isempty(sent_to_usbnoc)
    lastByteInUsb = sent_to_usbnoc(length(sent_to_usbnoc)); % Select last byte sent to the USB
    % hack for the USBNOC 2012
    % bits are somewhat swapped and so:
    % CONNECTOR:    CHIP BUS:
    % 0.0           D0
    % 0.1  CE       D3
    % 0.2  CLK      D2
    % 0.3  RST      D6
    % 0.4  TE       D5
    % 0.5           D7
    % 0.6  DI       D1
    % 0.7           D4
    
    lastByteInUsbBin = dec2bin(lastByteInUsb,8);
   
    p01 = lastByteInUsbBin(1);
    NocRST = lastByteInUsbBin(2);
    NocTE = lastByteInUsbBin(3);
    p07 = lastByteInUsbBin(4);
    NocCE = lastByteInUsbBin(5);
    NocCLK = lastByteInUsbBin(6);
    NocDi = lastByteInUsbBin(7);
    p00 = lastByteInUsbBin(8);  
   
else
    error('Global sent_to_usbnoc should be defined')
end
   
%3.0 End----------------------------------     




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% General settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % ok this is silly, but we need to check if user did not pass localctrlstr parameter. if yes, a lot of speedup is disabled to allow
  % for multiple device programming
  store_between_sessions = 1;
  for i = 1:length(varargin)
      par = varargin{i};
    if ischar(par)
        if strcmpi(par,'localctrlstr')
            store_between_sessions = 0;
            CTRL_STRUCT = varargin{i+1};
            localctrlstr = varargin{i+1};
        end
    end 
  end

  if store_between_sessions
    global CTRL_STRUCT                % global variable 
  end 
  
  MASTER.address = '10000000';      % address of the NoC master
  MASTER.NumAddClk = 12;            % NoC requires min amount of CLK pulses to travel over slaves (3*#slaves + 3(buffer))
  MASTER.EffNumAddClk = 15;         % effective CLK pulses that will be applied (>=NumAddClk)
                                    % will be changed further!!
  
  portConfig.usb6221.freq = 1000e3;portConfig.usb6221.clk_ctrl = 'rEdge';portConfig.usb6221.invert = 'n';
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Input and action control %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if store_between_sessions
    persistent defaultCtrl_persistent_var; % KR: keeps the defaultCtrl so we don't need to reload it from disk
  % -- check existance of the default struct
  % KR: Reordered for speed, added support for defaultCtrl sitting in memory
    if isempty(defaultCtrl_persistent_var)
        if exist('defaultCtrl.m','file') ~= 2
            error('The default NoC struct ''defaultCtrl'' is missing in path')
        else
            % KR: read from file
            defaultCtrl_ = defaultCtrl();
            defaultCtrl_persistent_var = defaultCtrl_;
        end
    else
        % KR: read from memory
        defaultCtrl_ = defaultCtrl_persistent_var;
    end
  else
        defaultCtrl_ = localctrlstr;
  end 
    
  % -- check reset condition, struct return and version check
    if (nargin == 0) 
      if isempty(CTRL_STRUCT)
        RST = 1;
        disp('NOTE: NoC is executed for the first time -> chip will be reset') 
      else
        RST = 0;
      end
    else
      if ((nargin == 1) && ischar(varargin{1}))
        if strcmpi(varargin{1},'version')
          disp('NoCCtrl V2.1, date 01/2013, Debaillie Bjorn, Kuba Raczkowski: Copyright protected')
          RST = 0;
        end
        if (strcmpi(varargin{1},'reset') || strcmpi(varargin{1},'rst'))
          RST = 1;
        end
      else
        if isempty(CTRL_STRUCT)
          RST = 1;
          disp('NOTE: NoC will reset before execution of your request') 
        else
          RST = 0;
        end
      end
    end
  % -- check and assign the rest of the parameters
    if (nargin > 1)
      % we will remember the ref_struct between runs because otherwise this
      % second step takes too much time...
     if store_between_sessions
      persistent ref_struct;
        if isempty(ref_struct)
            ref_struct = defaultCtrl_;
        end
     else
        ref_struct = defaultCtrl_;
     end
      if ~isfield(ref_struct,'parameters_off')
        ref_struct.parameters_off = strcat(ref_struct.parameters,'_OFF');
      end


      % check if any of the given parameters fit to the reference structure
      % if yes, it is what we loook for
      % this could be fixed with a dictionary
      % all this could be fixed with the input parser
      for k = 1:2:length(varargin)
        if (any(strcmp(varargin{k}, ref_struct.parameters))) 
          % yes this parameter fits!
          d_load_value.(varargin{k}) = varargin{k+1}; % this is already the dictionary
          if isnumeric(d_load_value.(varargin{k})) && length(d_load_value.(varargin{k}))>1
            error(['Variable ',varargin{k},' is a vector - use decimal or binary values only'])
          end
        elseif strcmpi(varargin{k}, 'group')
          eval([lower(varargin{k}),' = varargin{k+1};'])
        elseif (strcmpi(varargin{k}, 'ToFile') || strcmpi(varargin{k}, 'CLKD') || strcmpi(varargin{k}, 'Ns') ...
                || strcmpi(varargin{k}, 'SmartNoc') || strcmpi(varargin{k}, 'DevName') || strcmpi(varargin{k}, 'p00')...
                || strcmpi(varargin{k}, 'p01') || strcmpi(varargin{k}, 'p07') || strcmpi(varargin{k}, 'localctrlstr'))
          eval([lower(varargin{k}),' = varargin{k+1};'])
        elseif (strcmpi(varargin{k}, 'reset')) 
          eval([lower(varargin{k}),'_ = varargin{k+1};'])
        elseif (any(strcmp(varargin{k}, ref_struct.parameters_off)))
          d_load_offset_value.(varargin{k}) = varargin{k+1};
          if isnumeric(d_load_offset_value.(varargin{k})) && length(d_load_offset_value.(varargin{k}))>1
            error(['Variable ',varargin{k},' is a vector - use decimal or binary values only'])
          end
        else
          warning(['Struct field "', varargin{k}, '" is invalid - it will be discarded']);
        end
      end
    end
    
    % -- set default values
  % that can also be fixed with an inputparser
    if exist('tofile','var')~=1
      tofile = 8;
    end
    if exist('clkd','var')~=1
      clkd = 0;
    end
    if exist('ns','var')~=1
      ns = 6;
    end
    if exist('smartnoc','var')~=1
      smartnoc = 0;
    end
    if exist('devname','var') == 1
      portConfig.usb6221.dev_name = devname;
    else
        devname = 'none';
    end
    if exist('p00','var') ~= 1
      p00 = p00; %3.0 Silly double assignment for easy patch
    else 
      if length(p00)>1
        error('The pins P0.7, P0.1 and P0.0 can only be specified to a single value')
      end
      if ~isnumeric(p00)
        p00 = bin2dec(p00);
      end
    end
    if exist('p01','var') ~= 1
      p01 = p01; %3.0 Silly double assignment for easy patch
    else 
      if length(p01)>1
        error('The pins P0.7, P0.1 and P0.0 can only be specified to a single value')
      end
      if ~isnumeric(p01)
        p01 = bin2dec(p01);
      end
    end
    if exist('p07','var') ~= 1
      p07 = p07; %3.0 Silly double assignment for easy patch
    else 
      if length(p07)>1
        error('The pins P0.7, P0.1 and P0.0 can only be specified to a single value')
      end
      if ~isnumeric(p07)
        p07 = bin2dec(p07);
      end
    end
%3.0 Begin----------------------------------     
   if exist('NocCE','var') ~= 1
      NocCE = NocCE; %3.0 Silly double assignment for easy patch
    else 
      if length(NocCE)>1
        error('The pins NocCE, P0.7, P0.1 and P0.0 can only be specified to a single value')
      end
      if ~isnumeric(NocCE)
        NocCE = bin2dec(NocCE);
      end
    end 
%3.0 END----------------------------------    
    if exist('reset_','var')==1
      if isnumeric(reset_) && (reset_==0 || reset_==1)
        RST = reset_;
      end
    end

   % all till here can be fixed by an input parser
   
    MASTER.NumAddClk = 3*ns+3;         % NoC requires min amount of CLK pulses to travel over slaves (3*#slaves + 3(buffer))
    MASTER.EffNumAddClk = 3*ns+3+3;    % effective CLK pulses that will be applied to complete the NoC loop

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Interprete and execute %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
   
    
  % ------------------------- Reset -------------------------------------- %
    if RST == 1
        NocRST = [0 0 1 1 1 1];
        %3.0    NocCE  = [0 0 0 0 1 1]; 
        
        if (MASTER.NumAddClk > 2^5-1)
          error('MASTER.NumAddClk should be in the range [0..31]')
        end
          tmp = defaultCtrl_;
          if length(MASTER.address) ~= tmp.packet_types(2,1)
            error(['The Master Address of ',MASTER.address,' is not correct (length)'])
          end
          
        package{1} = ['111',MASTER.address,dec2bin(MASTER.NumAddClk,tmp.packet_types(2,2)),dec2bin(0,MASTER.EffNumAddClk)];  
        clear tmp

        if bitget(tofile,7)
            if strcmp(devname,'none')
                devname = 1;
            end
            NOCReset(devname,MASTER.EffNumAddClk);
        end
        
        NocDi = '';
        for k = 1:length(package)
          NocDi = [NocDi package{k}];
        end
        clear package
      
      % check if tofile is 0. then we program to usb6221
	  % WARNING! If tofile is 0 we change it to 8 to enable USB-NOC programing
      if tofile == 0
          %tofile = portConfig;
		  tofile = 8;
      end
      NocTE = [1 0];
      downloadCtrl('NocRST',NocRST,'NocCE',NocCE,'NocDi',NocDi,'NocTE',NocTE,'portConfig',tofile,'clkd',clkd,'p00',p00,'p01',p01,'p07',p07,'devname',devname)
      clear NocRST NocDi NocTE %3.0 clear NocRST NocCE NocDi NocTE
        CTRL_STRUCT = defaultCtrl_;    
    end
    
  % ---------------- Individual control download ------------------------- %     
    if exist('d_load_value','var')==1 || exist('d_load_offset_value','var')==1 

      %KR: this can be fixed by another dictionary
      fieldsTBC = fieldnames(d_load_value);
      if exist('group','var')~=1 && length(fieldsTBC)>1
        error('The group should be defined, e.g. NoCCtrl(''RXDMQ_PUP_MIX'',3,''RXDMQ_PUP_DIV'',2,''group'',''Pup'');')
      end
      % check if all fieldsTBC are in the same group
      if exist('group','var')
        if isempty(find(strcmpi(CTRL_STRUCT.groups,group),1))
          error(['The group ''',group,''' does not exist'])
        end
        for k = 1:length(fieldsTBC)
          potFields = CTRL_STRUCT.(upper(group));
          if isempty(find(strcmp(potFields,fieldsTBC{k}), 1))
            error(['The signal ''',fieldsTBC{k},''' is not part of the group ''',group,''''])
          end
        end
      end
      
      % -- Smart NoC avoids programming if the parameter is not changed
        if smartnoc ~= 0
          if exist('d_load_offset_value','var') ~= 1
            fieldsTBC_ = {};
            for k = 1:length(fieldsTBC)
              fieldsTBC_k = d_load_value.(fieldsTBC{k});
              if ~isnumeric(fieldsTBC_k)
                val = bin2dec(fieldsTBC_k);
              else
                val = fieldsTBC_k;
              end
              if val == CTRL_STRUCT.(fieldsTBC{k}){2}
                if smartnoc == 2
                  disp(['Smart NoC notice: Parameter ',fieldsTBC{k},' will not be programmed as it has not been changed']) 
                end
              else
                fieldsTBC_{end+1} = fieldsTBC{k};
              end
            end
            fieldsTBC = fieldsTBC_;
            clear fieldsTBC_
          else
            disp('Smart NoC programming is not available with bit programming (_OFF)')
          end
        end
      % end of smart noc checking
        
      
      % MAIN LOOP
      if ~isempty(fieldsTBC)  % if noting to be changed, nothing has to be done
        
        for k = 1:length(fieldsTBC) % for all busses to be programmed
          TBCFieldName = fieldsTBC{k};
          TBCDataVal = d_load_value.(TBCFieldName);
          all_groups = CTRL_STRUCT.(TBCFieldName);
          for kk = 1: all_groups{3} % loop over all groups
            optionAddrVal(kk) = all_groups{3+kk}{2}; 
            optionGroupName{kk} = all_groups{3+kk}{4}; 
          end  
          if exist('group','var')==1
            selGroupNr = find(strcmpi(optionGroupName,group));
          else
            selGroupNr = 1;
          end
          TBCAddrVal(k) = optionAddrVal(selGroupNr);      
          TBCDataLength = all_groups{1};
          if isnumeric(TBCDataVal)
            TBCDataVal = dec2bin(TBCDataVal);
          end
          if (length(TBCDataVal) > TBCDataLength) 
            error(['The provided value for ',TBCFieldName,' exceeds the specified amount of bits: ',num2str(TBCDataLength)])
          elseif exist('d_load_offset_value','var')==1 && isfield(d_load_offset_value,[TBCFieldName,'_OFF'])
            if length(TBCDataVal)~=1 || TBCDataLength<d_load_offset_value.([TBCFieldName,'_OFF'])+1
              error(['The provided data of ',TBCFieldName,' should be 1/0 and the offset defined in ',TBCFieldName,'_OFF should be smaller than ',num2str(TBCDataLength)])
            else
              tmp = dec2bin(CTRL_STRUCT.(TBCFieldName){2},TBCDataLength);
              tmp(end-d_load_offset_value.([TBCFieldName,'_OFF'])) = TBCDataVal;
              TBCDataVal = tmp;
            end      
          end
          CTRL_STRUCT.(TBCFieldName){2} = bin2dec(TBCDataVal);
        end
        addr = sort(unique(TBCAddrVal),'descend');    
        clear fieldsTBC TBCFieldName TBCAddrVal TBCDataVal TBCDataLength  
        
        if exist('group','var')==1
          [addr,data] = genPayload(addr,CTRL_STRUCT,group,store_between_sessions);                 % retrieve complete addr and data  
        else
          [addr,data] = genPayload(addr,CTRL_STRUCT,[],store_between_sessions);                    % retrieve complete addr and data  
        end


        if bitget(tofile,5)
            % hans's spider board
            for nb_addr = 1:size(addr,2)
                if (length(addr{nb_addr}) == 4)
                    slowfast = 1;
                else
                    slowfast = 0;
                end
                if strcmp(devname,'none')
                    devname = 1;
                end
                NOCWrite(devname,1,addr{nb_addr},data{nb_addr},slowfast);
            end
        end

        
        [package] = genPackage(addr,data,MASTER.EffNumAddClk,defaultCtrl_);
        NocDi = '';
        for k = 1:length(package)
          NocDi = [NocDi package{k}];
        end
        clear package      
        
        
      % check if tofile is 0. then we program to usb6221
      if tofile == 0
          %tofile = portConfig;
		  tofile = 8;
      end
        NocTE = [1 0];
        downloadCtrl('NocDi',NocDi,'NocTE',NocTE,'portConfig',tofile,'clkd',clkd,'NocCE',NocCE,'p00',p00,'p01',p01,'p07',p07,'devname',devname)
        clear NocDi NocTE

      end %if ~isemptry(fieldsTBC)
    end %if exist('d_load_value')==1 | exist('d_load_offset_value')==1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ending %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


catch err
    

    
    rethrow(err)
end
  

% ------------------------------------------------------------------------ %
% ------------------------------------------------------------------------ %
% ---------------------- Internal functions ------------------------------ %
% ------------------------------------------------------------------------ %
% ------------------------------------------------------------------------ %
    function [addr_,data_] = genPayload(addr,CTRL_STRUCT,group,store_between_sessions)
        %
        % function genPayload 'loads' and 'prepares' the data at a specified location
        % where addr is a (array of) decimal address(es)
        % The function returns two corresponing cells addr_ and data_ containing
        % binary values.
        % As the current NoC cannot read from a specified address, CTRL_STRUCT is
        %
        % provided
        % Author: Debaillie Bjorn
        % Confidential and Copyright Protected
        %
        %
        % From KR:
        % This function receives the address of bus (or busses) to be programmed
        % and looks through all other settings to find the busses residing in the
        % same address (but with different offsets).
        %
        % to speed up we maintain a dictionary of addresses mapped to busses (in
        % ctrl_struct it's the other way around). only if we catch an address we
        % don't know we loop over everything.
        
        
        % create an address map for storing the addresses we already processed
        if store_between_sessions
            persistent address_map;
        else
            address_map = [];
        end
        % if address_map does not exist, create an empty hashmap
        if (exist('address_map','var')) && isempty(address_map)
            import java.util.HashMap
            address_map = HashMap();
        end
        
        % create output holders. They will be filled with adresses and data
        data_ = {};
        addr_ = {};
        
        % check if the address exists in the address map
        if address_map.containsKey(addr) % yes! we don't need to loop much!
            FieldNamesToSearch = cell(address_map.get(addr));
            using_map = 1;
        else % we need to loop. If the user gave a group already, it will be less.
            if ~isempty(group)
                FieldNamesToSearch = CTRL_STRUCT.(upper(group)).'; % search through all parameters of group 'group'
            else
                FieldNamesToSearch = CTRL_STRUCT.parameters; % group not given. search through ALL parameters.
            end
            using_map = 0;
        end
        
        % main loop
        for kk = 1:length(addr)                         % loop over all specified addresses
            for kkk = 1:length(FieldNamesToSearch)        % loop over all relevant fields and check correspondence with address
                all_groups = CTRL_STRUCT.(FieldNamesToSearch{kkk});
                for kkkk = 1:all_groups{3}  % loop over all groups to which this bus belongs
                    if (all_groups{3+kkkk}{2} == addr(kk))
                        indexR = all_groups{3+kkkk}{3}+1;
                        dataLength = all_groups{1};
                        binValue = dec2bin(all_groups{2},dataLength);
                        dataR{kk}(indexR:-1:indexR-dataLength+1) = binValue;
                        addrTypeNr = all_groups{3+kkkk}{1};
                        addrType = CTRL_STRUCT.packet_types(addrTypeNr,:);
                        
                        % save the entry to the address_map for quicker use next
                        % time. This only is valid if we don't use the map already
                        if ~using_map
                            if ~address_map.containsKey(addr) % first time we work with this address
                                address_map.put(addr,{FieldNamesToSearch{kkk}});
                            else % need to append to list of fields
                                list_of_fields = cell(address_map.get(addr));
                                list_of_fields(end+1) = {FieldNamesToSearch{kkk}};
                                address_map.put(addr,list_of_fields);
                            end
                        end
                    end
                end
            end
            
            if ~exist('indexR','var')
                error(['The address ',num2str(addr(kk)),' is not in the control struct'])
            end
            data_{kk} = dataR{kk}(end:-1:1);
            % note that some packages are not fully filled with data => place '0'
            data_{kk}(find(~(data_{kk}=='1'|data_{kk}=='0'))) = '0';
            if length(data_{kk}) ~= addrType(2)
                error('Internal error: the bit-range does not match')
            end
            addr_{kk} = dec2bin(addr(kk),max(CTRL_STRUCT.packet_types(:,1)));
            addr_{kk} = addr_{kk}(1:addrType(1));
            clear indexR dataLength binValue binValueR dataR addrTypeNr addrType
        end

  function [package] = genPackage(addr,data,EffNumAddClk,defaultCtrl_)
  %
  % function genPackage uses the provided address and data cells to construct 
  % the NoC compliant packages as described in M4.QoE.Deliverable.MIXDT-5 
  %
  % Author:   Debaillie Bjorn
  % Confidential and Copyright Protected
 
    for kk = 1:length(addr)
      package{kk} = '';
      package{kk}(1) = '1';                                 % Sync
      % pvw 2009/07/27 if (length(addr{kk}) == 5)           % S/F indicator
      tmp = defaultCtrl_;
      if (length(addr{kk}) == tmp.packet_types(1,1))
        package{kk}(2) = '0';                               % fast
      else
        package{kk}(2) = '1';                               % slow
      end
      package{kk}(3) = '1';                                 % R/W flag
      package{kk}(4:3+length(addr{kk})) = addr{kk};         % MAC address
      package{kk}(end+1:end+length(data{kk})) = data{kk};   % Payload information
      package{kk}(end+1:end+EffNumAddClk) = dec2bin(0,EffNumAddClk);
                                                            % Additional CLK pulses (more than strictly required) 
    end
      
    
  function downloadCtrl(varargin)   
  %  
  % function downloadCtrl distributes the provided data to the physical
  % layer
  % input options are:
  % 'NocRST' and 'NocCE' => NocDi = 0, NocCLK = 0, NocTE = 0
  % 'NocDi' only => adding toggeling NocCLK, NoRST = 1, NocCE = 1, NocTE = 0
  % 'NocTE only => NocCLK = 0, NocRST = 1, NocCE = 1, NocDi = 0
  %
  % Author:   Debaillie Bjorn
  % Confidential and Copyright Protected
  
  % KR: don't fix this yet. It would require storing the values in a
  % dictionary.
  % MI: NocCE is now always given, and can be considered a normal variable
  
    for k = 1:2:length(varargin)
      if (any(strcmp(varargin{k}, {'NocDi','NocRST','NocCE','NocTE','portConfig','clkd','p00','p01','p07','devname'} )))
        eval([varargin{k},' = varargin{k+1};']) 
      else
        warning(['Struct field "', varargin{k}, '" is invalid - it will be discarted']);
      end
    end
     
    % at least NocDi should be provided!!
    % NocRST: active low -> 1 if not provided - pre-pended
        % NocTE:active high -> 0 if not provided  - post-pended    
    
    if ~exist('NocDi','var')
      error('NocDi should always be provided, even with a RST to program the master')
    end
    
    % ------- RST and CE
      if exist('NocRST','var') % && exist('NocCE','var')
%         if length(NocRST)~=length(NocCE)
%           error('The length of NocRST and NocCE should be equal')
%         end
        leng    = length(NocRST);
        NocDi_  = zeros(1,leng);
        NocRST_ = NocRST;
        NocCE_  = NocCE*ones(1,leng);
        NocCLK_ = zeros(1,leng);
        NocTE_  = zeros(1,leng);
        NocP07_ = p07*ones(1,leng);
        NocP01_ = p01*ones(1,leng);
        NocP00_ = p00*ones(1,leng);
        
%       elseif exist('NocRST','var') && ~exist('NocCE','var')
%         leng    = length(NocRST);
%         NocDi_  = zeros(1,leng);
%         NocRST_ = NocRST;
%         NocCE_  = NocCE * ones(1,leng);
%         NocCLK_ = zeros(1,leng);
%         NocTE_  = zeros(1,leng);
%         NocP07_ = p07*ones(1,leng);
%         NocP01_ = p01*ones(1,leng);
%         NocP00_ = p00*ones(1,leng);
%         
%       elseif ~exist('NocRST','var') && exist('NocCE','var')
%         leng    = length(NocCE);
%         NocDi_  = zeros(1,leng);
%         NocRST_ = ones(1,leng);
%         NocCE_  = NocCE*ones(1,leng);
%         NocCLK_ = zeros(1,leng);
%         NocTE_  = zeros(1,leng);
%         NocP07_ = p07*ones(1,leng);
%         NocP01_ = p01*ones(1,leng);
%         NocP00_ = p00*ones(1,leng);
      else
        NocDi_  = [];
        NocRST_ = [];
        NocCE_  = [];
        NocCLK_ = [];
        NocTE_  = [];
        NocP07_ = [];
        NocP01_ = [];
        NocP00_ = [];
      end

      
    % ------- Di
      if ischar(NocDi)
        NocDi = double(NocDi)-double('0');
      end
             
      if clkd == 1
        tmp(1:2:2*length(NocDi)) = NocDi; 
        tmp(2:2:2*length(NocDi)+1) = NocDi;
        NocDi = tmp;
        leng = length(NocDi);
        NocCLK = zeros(1,leng);NocCLK(2:2:end) = 1;
      else
        leng = length(NocDi);
        NocCLK = zeros(1,leng);
      end
      
      NocDi_  = [NocDi_   NocDi];
      NocRST_ = [NocRST_  ones(1,leng)];
      NocCE_  = [NocCE_   NocCE*ones(1,leng)];
      NocCLK_ = [NocCLK_  NocCLK];
      NocTE_  = [NocTE_   zeros(1,leng)];
      NocP07_ = [NocP07_ p07*ones(1,leng)];
      NocP01_ = [NocP01_ p01*ones(1,leng)];
      NocP00_ = [NocP00_ p00*ones(1,leng)];
      
      
    % ------- TE
      if exist('NocTE','var')
        leng = length(NocTE);
        NocDi_  = [NocDi_   zeros(1,leng)];
        NocRST_ = [NocRST_  ones(1,leng)];
        NocCE_  = [NocCE_   NocCE*ones(1,leng)];
        NocCLK_ = [NocCLK_  zeros(1,leng)];
        NocTE_  = [NocTE_   NocTE];
        NocP07_ = [NocP07_ p07*ones(1,leng)];
        NocP01_ = [NocP01_ p01*ones(1,leng)];
        NocP00_ = [NocP00_ p00*ones(1,leng)];
      end      
      
      if isstruct(portConfig)  % to USB device
          nvalues = bin2dec([dec2bin(NocP07_),dec2bin(NocDi_),dec2bin(NocP01_),dec2bin(NocTE_),dec2bin(NocRST_),dec2bin(NocCLK_),dec2bin(NocCE_),dec2bin(NocP00_)]);
          %                          P0.7            P0.6            P0.5            P0.4            P0.3             P0.2             P0.1             P0.0
          %nvalues = bin2dec([dec2bin(NocDi),dec2bin(NocDo),dec2bin(NocRST),dec2bin(NocTE),dec2bin(NocCLK),dec2bin(NocCE),dec2bin(NocGND)]);
          usb6221Control(portConfig.usb6221,nvalues);
      else                      % to txt file
          % 1 - put to ctrlwv.txt 		
          % 2 - put to ctrlwv.mat		
          % 4 - put to ctrlwv_vect.txt  
		  % 8 - put to USBNOC interface 
          %     BINARY COMBINATIONS (SUMS) ARE ALLOWED (e.g. 1+2+8 - txt+mat+usbnoc)
          if bitget(portConfig, 1) % case when portconfig has 1 in the number
              leng = length(NocDi_);
              temp_string = '';
              sprintf(temp_string,'%s,\t\t%s,\t\t%s,\t\t%s,\t\t%s,\t\t%s,\t\t%s,\t\t%s\n','P0.7','P0.6','P0.5','P0.4','P0.3','P0.2','P0.1','P0.0');
              temp_string = [temp_string sprintf('%s,\t%s,\t%s,\t%s,\t%s,\t%s,\t%s,\t%s\n','User07','NocDi','NocCE','NocTE','NocRST','NocCLK','User01','User00')];      
              for k = 1:leng
                  temp_string = [temp_string sprintf('%d,\t\t\t%d,\t\t\t%d,\t\t\t%d,\t\t\t%d,\t\t\t%d,\t\t\t%d,\t\t\t%d\n',NocP07_(k),NocDi_(k),NocCE_(k),NocTE_(k),NocRST_(k),NocCLK_(k),NocP01_(k),NocP00_(k))];
              end
              fid = fopen('ctrlwv.txt','w');
              fprintf(fid,'%s\n',temp_string);
              fclose(fid);
          end
          if bitget(portConfig, 2) % case when portconfig has 2 in the number
              if exist('ctrlwv.mat','file') == 2
                  load('ctrlwv.mat');
              else
                  NocVal = {};
              end
              NocVal{end+1}.NocP07 = dec2bin(NocP07_).';
              NocVal{end}.NocDi = dec2bin(NocDi_).';
              NocVal{end}.NocCE = dec2bin(NocCE_).';
              NocVal{end}.NocTE = dec2bin(NocTE_).';
              NocVal{end}.NocRST = dec2bin(NocRST_).';
              NocVal{end}.NocCLK = dec2bin(NocCLK_).';
              NocVal{end+1}.NocP01 = dec2bin(NocP01_).';
              NocVal{end+1}.NocP00 = dec2bin(NocP00_).';
              save('ctrlwv.mat','NocVal')
          end
          if bitget(portConfig, 3) % case when portconfig has 4 in the number
              fid = fopen('ctrlwv_vect.txt','w');
              nvalues = NocP07_*128 + NocDi_*64 + NocP01_*32 + NocTE_*16 + NocRST_*8 + NocCLK_*4 + NocCE_*2 + NocP00_*1;
              fprintf(fid,'%d\t',nvalues');
              fclose(fid);
          end
          if bitget(portConfig, 4) % case when portconfig has 8 in the number
              % hack for the USBNOC 2012
              % bits are somewhat swapped and so:
              % CONNECTOR:    CHIP BUS:
              % 0.0           D0  
              % 0.1  CE       D3  
              % 0.2  CLK      D2     
              % 0.3  RST      D6     
              % 0.4  TE       D5    
              % 0.5           D7  
              % 0.6  DI       D1    
              % 0.7           D4  
              nvalues = NocP07_*2^4 + NocDi_*2^1 + NocCE_*2^3 + NocTE_*2^5 + NocRST_*2^6 + NocCLK_*2^2 + NocP01_*2^7 + NocP00_*2^0;              
              % add bit 4 (CLK) toggling to create clock
              nvalues_new = zeros(1,2*length(nvalues));
              nvalues_new(1,1:2:end-1) = nvalues + 2^2; %bit - rising edge
              nvalues_new(1,2:2:end) = nvalues;
              
              
              usb_noc(nvalues_new,'debug',0,'device_name',devname);
              
              % hack for the experiment board
%               noc_ftdi = bitshift(nvalues,-2);
%               noc_ftdi = bitset(noc_ftdi,4,bitget(noc_ftdi,5));
%               usb_noc(noc_ftdi);
          end
          % bitget(portConfig, 5) is covered somewhere else
          if bitget(portConfig, 6) % case when portconfig has 8 in the number
            nvalues = bin2dec([dec2bin(NocP07_),dec2bin(NocDi_),dec2bin(NocP01_),dec2bin(NocTE_),dec2bin(NocRST_),dec2bin(NocCLK_),dec2bin(NocCE_),dec2bin(NocP00_)]);
            %                          P0.7            P0.6            P0.5            P0.4            P0.3             P0.2             P0.1             P0.0
            %nvalues = bin2dec([dec2bin(NocDi),dec2bin(NocDo),dec2bin(NocRST),dec2bin(NocTE),dec2bin(NocCLK),dec2bin(NocCE),dec2bin(NocGND)]);
            usb6221.freq = 1000e3; usb6221.clk_ctrl = 'rEdge'; usb6221.invert = 'n';
            usb6221Control(usb6221,nvalues);
        end
      end

