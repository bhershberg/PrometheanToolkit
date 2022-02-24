classdef logicAnalyzer_Ag16902B < handle
  
  % NAME
  %    logicAnalyzer_Ag16902B
  %
  % DESCRIPTION
  %    Performs measurements using the logic analyzer 16902B from Agilent.
  %
  %    When constructing an object, the configuration file will be opened on
  %    the configuration file. As this takes a while, it only needs to be
  %    done at the start of a sweep. Then, subsequent measurements can be
  %    performed with the .measure() function.
  %
  %
  % EXAMPLE
  %    LA = logicAnalyzer_Ag16902B('Z:/UserData/HS_ADC_3A.ala', 19);
  %    LA.open();
  %    for k = 1:N,
  %        ...
  %        bitArray = LA.measure();
  %        ...
  %    end
  %    LA.close();
  %
  %
  % logicAnalyzer_Ag16902B METHODS:
  %    logicAnalyzer_Ag16902B - Constructor.
  %    open                   - Opens the configuration file.
  %    measure                - Runs logic analyzer and grabs the bits
  %    close                  - Closes the connection to the logic analyzer.
  %
  %
  % AUTHOR
  %    Ewout Martens, Peter Van Wesemael (imec) - CONFIDENTIAL
  
  
  %%%%%%%%%%%%%%%%%
  %%  PROPERTIES
  %%%%%%%%%%%%%%%%%

  properties

    % The data structure from the old Ag16902B function
    ProgID   = 'AgtLA.Connect';          % Programmatic ID
%    IP       = '10.90.1.8';              % IP of the remote logic analyzer (since 9-Dec-2016)
%    IP       = '10.82.1.96';             % IP of the remote logic analyzer
%    IP       = '10.90.1.4';             % IP of the remote logic analyzer (rented LA)
    IP       = '10.90.1.15';
    SaveOld  = false;                    % Save old configuration file?
    OldName  = 'dummy.ala';              % Name of old configuration, if to save it
    SetupOnly = false;                   % Do only setup?
    
    hConnect;                            % Handle to connection server
    hInst;                               % Handle to instance of instrument
    hModules;                            % Handle to collection of modules property
    hModule;                             % Handle to module property
    Ana;                                 % Handle to slot to measure from
    hAnalyzerSigs;                       % Handle to signals from logic analyzer
    hSig;                                % Handle to our signal
    hData;                               % Handle to actual data
    
    strName;                             % Name of the logic analyzer
    strModel;                            % Model of the logic analyzer
    strType;                             % Type of data
    strSlot;                             % Slot where to grab the data from
    strAna;                              % Indicates which slot we need to use
    strStatus;                           % Status indicator
    
    LoadName;                            % Name of configuration file to load 
    nBits;                               % Number of bits to grab per sample
    %nIL = 2;                             % Number of interleaved channels
    nIL = 1;                             % Number of interleaved channels - in HSADC 4C Type2 is 1
    signalName = 'My Bus 1';             % Name of the signal to grab

  end  % properties

  %---------------------------------------------------------------------------

  methods

    %%%%%%%%%%%%%%%%%%%%%
    %%  PUBLIC METHODS
    %%%%%%%%%%%%%%%%%%%%%

    function self = logicAnalyzer_Ag16902B(configFileName, nBits, busName)
    
      % NAME
      %    logicAnalyzer_Ag16902B.logicAnalyzer_Ag16902B
      %
      % DESCRIPTION
      %    Initializes the object.
      %
      % USE
      %    obj = logicAnalyzer_Ag16902B(configFileName, nBits[, busName])
      %
      % INPUTS
      %    configFileName : name of the configuration file to load
      %    nBits          : number of bits to grab per sample (excluding the clock)
      %    busName        : name of the bus to grab
      
      self.LoadName = configFileName;
      self.nBits    = nBits;
      if nargin > 2,
	self.signalName = busName;
      end

    end   % logicAnalyzer_Ag16902B

    %--------------------------------------------------------------------------
    
    function open(self)
    
      % NAME
      %    logicAnalyzer_Ag16902B.open
      %
      % DESCRIPTION
      %    Opens the configuration file on the logic analyzer.
      %
      % USE
      %    obj.open()
      
      disp('Starting logic analyzer...');

     % hardCodedFile = '\\unix\hsadc\markulic\Measurements\HSADC4C\scripts\single_bus_64k_conf.ala';
      
      % Start the connection server
      try                                        % Start error trapping
% 	self.hConnect = actxserver(self.ProgID, 'machine', '16902B-1382434I'); % Create an instance of Connect
    self.hConnect = actxserver(self.ProgID); % Create an instance of Connect
      catch                                      % If an error is detected
	error ('Unable to create the local COM object.  Controlled Abort.')
      end                                        % End error trapping

      % Connect to instrument
      try
	self.hInst = get(self.hConnect, 'Instrument', self.IP);
      catch     % If there's an error getting the Instrument interface...
	err = lasterror;
	display ('Controlled abort while creating remote COM object.');
	display (err.message);
	error ('Controlled abort.');    
      end
      
      % Open the measurement program on the logic analyzer
      invoke(self.hInst, 'New')
      strModel = get(self.hInst, 'Model');
      strVersion = get(self.hInst, 'Version');

      % Open the configuration file
      try
 	invoke (self.hInst, 'Open', self.LoadName, self.SaveOld, self.OldName, self.SetupOnly);
%    invoke (self.hInst, 'Open', hardCodedFile, self.SaveOld, self.OldName, self.SetupOnly);
      catch     % If there's an error saving, like an invalid name
	err = lasterror;
	display ('Controlled abort while saving.');
	display (err.message);
	error ('Controlled abort.');
      end

      % Save old active session
      if self.SaveOld
	display (['The active session was saved as ' self.OldName ' to the logic analyzer.']);
      end

      % Getting Module Name and Slot Number
      self.hModules = self.hInst.get('Modules');  % Get the Modules property
      % There is no Z slot in any Agilent logic analyzer.
      % Use Z as a flag to indicate that  there is not a particular module installed
      self.strAna = 'Z'; % Storage for the slot of an analyzer if installed

      for i = 0:(self.hModules.Count - 1)  % For each Module in the collection
	self.hModule = get(self.hModules, 'Item', int32(i));    % Get the module

        % Notice that you must force the data-type of the int32 parameter.
        % This behavior may seem inconsistent, but really MATLAB is dynamically
        % re-casting the data types of your variables to fit the data.  When we
        % create it in the loop, it is a [1,1] array of type double by default.
        % The Item property requires an integer parameter.

        % Get a bunch of the Module properties
	self.strName   = self.hModule.Name;
	self.strModel  = self.hModule.Model;
	self.strType   = self.hModule.Type;
	self.strSlot   = self.hModule.Slot;
	self.strStatus = self.hModule.Status;

        % If a analyzer module is detected, set the flag from Z to the
        % slot of the analyzer module.
	if (strcmp(self.strType, 'Analyzer'))
	  self.strAna = self.strSlot; 
	end;
      end
      self.Ana = get (self.hModules, 'Item', self.strAna); 
      
      pause(0.5);

    end   % open

    %--------------------------------------------------------------------------
    
    function [bitArray,data] = measure(self)
    
      % NAME
      %    logicAnalyzer_Ag16902B.measure
      %
      % DESCRIPTION
      %    Do a measurement.
      %
      % USE
      %    [bitArray,data] = obj.measurement()
      %
      % OUTPUTS
      %    bitArray : array with the bits; each row correspond to a sample
      %    data     : data combined into signed integers
      
      % Run all modules in the analyzer's configuration.
      try
	self.hInst.Run;
      catch     % If there's an error running, like no modules installed?
	err = lasterror;
	display ('Controlled abort while running.');
	display (err.message);
	error ('Controlled abort');
      end
      
      try %added by Ben because this part keeps crashing
      self.hInst.WaitComplete (int32(30));
      catch 
          try
              self.hInst.Run; % try again...
              self.hInst.WaitComplete (int32(45));
          catch
              self.hInst.Run; % third time's the charm...
              self.hInst.WaitComplete (int32(60));
          end
      end

      % Getting captured data
      % Get all Busses and Signals                            
      self.hAnalyzerSigs = get (self.Ana, 'BusSignals');
    
      % Introduced on 4E-T3 -- breaks the project-agnostic character of the driver
      if getType == 3
          self.hSig = get (self.hAnalyzerSigs, 'Item', 'HSADC4E_Type3_Bus');
      else
          self.hSig = get (self.hAnalyzerSigs, 'Item', 'My Bus 1');
      end
      
      % Get the captured data associated with counter.
      self.hData = get (self.hSig, 'BusSignalData');
      intDataType = self.hData.DataType;

      %% Get the samples on the range
      [dataArray lngRowsReturned] = self.hData.GetDataBySample (self.hData.StartSample, self.hData.EndSample, intDataType);
      
      % Combine the bytes
      nBytes = ceil (self.nBits / 8);
      data = double(dataArray(1:nBytes:end));
      for iBytes = 2:nBytes,
	data = data*2^8 + double(dataArray(iBytes:nBytes:end));
      end
      % Convert to bits
      bitArray = dec2bin(data, self.nBits) - double('0');
      % Shifts the bits around zero
      negindex = find(data > 2^(self.nBits-1)-1);
      data(negindex) = data(negindex) - 2^self.nBits;
      
      % Try to get a multiple of 20ms
      if self.hData.EndTime - self.hData.StartTime > 20e-3,
        Ts = (self.hData.EndTime - self.hData.StartTime)/(length(data)-1);
        nPeriod20m = floor((self.hData.EndTime - self.hData.StartTime)/20e-3);
        nSamples = round(nPeriod20m*20e-3/Ts/self.nIL)*self.nIL;
        bitArray = bitArray(1:nSamples,:);
        data = data(1:nSamples);
      end
      
    end  %  measure

    %--------------------------------------------------------------------------
    
    function close(self, toClose)
    
      % NAME
      %    logicAnalyzer_Ag16902B.close
      %
      % DESCRIPTION
      %    Closes the connection to the logic analyzer.
      %
      % USE
      %    obj.close([toClose])
      %
      % INPUTS
      %    toClose: [true*|false] if false, close command is ignored
      
      if nargin < 2,
	toClose = true;
      end
      
      if toClose,
	%% Cleaning up
	%% Since our structure was built in an m-file, it is a local structure
	%% and does not persist after the m-file completes.  However, it is good
	%% practice to clean up by releasing the memory dedicated to the
	%% handles.
	self.hConnect.release
	self.hInst.release
	self.hModules.release
	if self.strAna ~= 'Z'
	  self.Ana.release    
	end
      end
      
    end  % close

    %--------------------------------------------------------------------------
    
  end  % methods

end  % logicAnalyzer_Ag16902B
