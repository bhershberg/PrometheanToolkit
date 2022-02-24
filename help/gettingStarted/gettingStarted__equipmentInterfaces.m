% =========================================================================
% Getting Started With Equipment Interfaces
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020


% Every physical measurement environment involves instruments and test
% equipment like voltage and current sources, signal generators, clock
% generators, logic analyzers, network analyzers, phase noise analyzers,
% etc. This dependence on external instruments, with their own interfaces
% and control states represents a major weak point in terms of ensuring
% full tracking and reproducability of your measurement work. The Equipment
% Interfaces tool in Promethean Toolkit seeks to remedy this, by moving physical
% instrument configuration and control as much as possible into software.
% In addition to enhancing repeatability, this approach also provides a way
% to fully automate all of your measurements. Testing can be done remotely
% and graphically just by clicking buttons and launching measurement
% scripts.

% Let's load up a demo state file and look at an example measurement setup
% in Promethean Toolkit:

    loadDemoState;
    selectTab('Equipment Interfaces');
    
% This is a typical equipment setup for testing an ADC. Each sub-panel
% module displays the settings for a different equipment interface. If you
% go to the second  sub-tab titled "Equipment Interfaces (Tab 2)" you will
% see the "Create a New Equipment Interface Profile" module, in in the
% "Interface Type" dropdown you can see which interfaces are supported by
% the system. Adding, removing, and re-arranging interface modules can all
% be done quickly and graphically. To connect to the physical instrument,
% simply define the GPIB or LAN connection address as prompted in the
% module GUI. 


% API tools
% =========

% In your custom code and functions that you use to measure your chip, it
% is of course crucial that you be able to easily access and interact with
% these equipment interfaces in your code too. A number of API functions
% and classes are provided for this purpose. First, there is the
% "equipmentInterface" class for interfacing with a single piece of
% equipment:
    
    help equipmentInterface
    
% Here's a simple example of using the equipmentInterface class to
% calculate the power pulled from a voltage source (if that source is
% capable of measuring current):

    vSource = equipmentInterface(); % let the user choose
    vSource = equipmentInterface('VDDA'); % or choose directly
    
    if(vSource.propertyExists('measure_current'))
        vSource.setProperty('measure_current',true);
        vSource.apply;
        iDC = vSource.getProperty('current_measured');
        vDC = vSource.getProperty('voltage');
        pDC = abs(iDC * vDC);
    else
        iDC = NaN;
        vDC = vSource.getProperty('voltage');
        pDC = NaN;
    end
    
% This is just a quick example - read the documentation for the class to
% see all of the other methods in this class that are available. Below is
% an example of how to use the equipmentInterface API for a very common
% low-level measurement task used for automating ADC testing. The following
% function equalizes the signal generator power in dBm to produce a desired
% ADC digital output amplitude in dBFS:

    open example__setInputPowerLevel

% Go ahead and execute the following few lines of code to see how this
% function changes the "Power (dBm)" value in the "Signal Input" interface
% module. Note that since we don't have an actual ADC to test here, we
% cheat and suppose that 5 dBm generator-side corresponds to 0 dBFS at the
% ADC output. So our request of -0.5 dBFS should converge to something
% close to 4.5 dBm (but not exact, because we're also emulating some
% instrumentation noise/error). Let's see if we get a result close to the
% expected convergence value of 4.5 dBm:

    options.interactive = true;
    options.target_dBFS = -0.5;
    example__setInputPowerLevel(options);

% The equipmentInterface class does fine in these examples above because we
% are only dealing with one instrument at a time. But what if we want to
% work with or analyze related sets of equipment? This would become rather
% tedious and cumbersome using the equipmentInterface class. That's where
% the second equipment control class comes to the rescue - the
% equipmentInterfaceGroup class. This class provides tools for gropuing,
% filtering, and doing batch-actions on several equipment interfaces at
% once:

    help equipmentInterfaceGroup
    
% Let's repeat our DC current/power measurement example from above, but
% this time we'll do it for all instruments in the setup that can support
% it:

    vSources = equipmentInterfaceGroup;
    
    % all add voltage sources to the group:
    vSources.addAllWithProperty('voltage');
    
    % remove the ones that don't support current measurement:
    vSources.removeAllWithoutProperty('current_measured'); 
    vSources.removeAllWithoutProperty('measure_current');
    
    % tell them all to measure current, and broadcast to physical devices:
    vSources.setPropertyAndApply('measure_current',true);
    
    % read the results:
    [iDC, sourceNames] = vSources.getProperty('current_measured');
    [vDC, ~] = vSources.getProperty('voltage');

    % save to an output results structure:
    results.iDC = [iDC{:}];
    results.vDC = [vDC{:}];
    results.pDC = results.iDC .* results.vDC;
    results.sourceNames = sourceNames;
    
% This is of course just a simple example, and there is quite a bit more
% that this class can do, so it is recommended to read the documentation
% provided in the class file.

% These two tools, the equipmentInterface and equipmentInterfaceGroup
% classes are your main gateway into the Equipment Interfaces sub-system.
% However, there are some other functions in the API that you might find
% handy as well:
    
    % Functions/classes:
    help listAllInterfaces
    help selectInterface
    help interfaceDefinitionManager

% There are also some lower level functions available, but in general if
% you're using the equipmentInterface and equipmentInterfaceGroup classes
% correctly you shouldn't need to use these very often:

    help getInterface
    help getInterfaceByName
    help getInterfaceByType
    help getInterfaceHandle
    help getInterfaceIndex
    help getInterfaceName
    help getInterfaceProperty
    help getInterfacesWithProperty
    help setInterfaceProperty

% However, sometimes they might still come in handy. Here is an example
% where we use a variety of access classes/functions to attempt to
% determine which interface is the "core supply" in the system:

    open example__getCoreSupply


% Creating New Equipment Interfaces
% =================================
    
% To add a new piece of equipment not yet supported by Promethean Toolkit, simply
% follow the instructions provided in these two template files:

    open template_createInterface
    open template_applyInterface
    
% In short, the "createInterface" handles what to draw in the GUI and how
% to draw it. Note that there is very little limitation to what you can do
% here. You can even make very complicated interfaces with many rows, and
% complex UI's if you wish. The sky is the limit! Complementing this, the
% "applyInterface" file defines how to parse all the UI elements and apply
% them to both the local data structure that holds the system state as well
% as broadcast these settings to the external physical instrument. Within
% this apply function, you will also need to integrate your low-level
% communication driver function that actually talks to the instrument
% (which you probably already have and use in your old code, so this is not
% too big of a deal). Clicking the "Apply" button in the interface module
% triggers this function to exectue.

% You will also need to register your new interface design in this file so
% that Promethean Toolkit knows to provide it as an interface option and so that it
% know which "create" and "apply" functions to call:

    open custom__interfaceDefinitionsInclude

% Also, whenever an interface is deleted in the GUI, the following function
% will be executed:
  
    open custom__equipmentInterface_onDelete
    
% Although you probably won't need to use this, we have found in our own
% lab work that it was useful to do some "house cleaning" for certain
% custom GUI setups when this scenario occurs. For example, in the earlier
% example "example__getCoreSupply", it could be useful to clear the value
% stored in the "coreSupply" global option in the event that the supply
% currently registered as the core supply is deleted.
   
% For many pieces of equipment, just the "apply" function is sufficient. We
% simply want to send the current values to the instrument, and possibly
% read back some basic measurements such as DC current that are simple
% scalars that can easily be stored as a field directly inside of the
% equipment interface definition itself (as defined in the
% "createInterface" file for that device). But for other pieces of
% equipment, especially more complex devices used for data capture and
% readout such as Logic Analyzers, VNA, phase noise analyzers, etc, this
% isn't sufficient. When you're reading out large amounts of capture data,
% you do not want to save it directly into the interface because that will
% be saved as a part of the system state, and therefore when you save your
% setup to disk through the File Manager it will produce a very large file
% size with lots of unnecessary data. Even worse, if you are taking system
% state "snapshots" with each of your measurements and attaching them to
% the results that you save to the Results Manager, all this data will be
% saved there too. Your file sizes can quickly explode! To avoid these
% problems, you will need more than just an "apply" function, you will also
% need a "capture" function that directly returns data, and perhaps some
% others as well. This is actually very easy to do. The following
% example/tutorial shows how this is done for the Agilent 16902B Logic
% Analyzer interface:
    
    open example__useLogicAnalyzer
    
    