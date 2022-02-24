% =========================================================================
% Getting Started With the Results Manager
% =========================================================================
% Promethean Toolkit 
% Benjamin Hershberg, 2020


% The Results Manger tab in Promethean Toolkit GUI helps to solve and automate many
% common challenges related to reproducability, archiving, and data
% analysis. We will first look at the nuts and bolts of the GUI and API
% components, and afterward talk a bit more about how you can get the most
% out of this tool. The Results Manager can most obviously be used in the
% physical lab environment for test and measurement. However, it is worth
% noting that CAD tools such as Cadence ADEXL can easily be interfaced with
% Matlab, and it can serve the same purpose in software design environments
% as well.

% Let's first take a quick tour of the Result Manager GUI tab. First, load
% up the demo state file:

    loadDemoState;
    selectTab('Results Manager');
   
% You can already see a few results in here that have been generated in the
% past and saved. You can annotate each result with information using the
% "Result Notes" window. Also, you can see all of the data stored in each
% result using the "Result Fields" window. Go ahead and select the
% "populationDynamics__exampleResult" result, and click one of the
% "growthCurve_...." result fields in the "Result Fields" window. The
% "Inspect Selected Result Field(s)" button will now become clickable, and
% you can use it to examine the underlying data. Notice that with the Ctrl
% and Shift keys on your keyboard you can select and view multiple result
% fields at the same time. While we're at it, select some or all of the
% "stateData_...." fields in there. Now the "Restore Selected State
% Data(s)" button becomes clickable. To make this interesting, let's first
% change our state. Go ahead and change some other stuff in the system
% state, like Global Options, Control Variables, Equipment Interfaces,
% and/or Execution Modules. Now select these "stateData_..." items and
% click the restore button. Poof, your system state is restored to the
% exact state that you had when this result was first generated. Promethean Toolkit
% provides you with a way to have full traceability and reproducability in
% your design and measurement work. Say goodbye to the classic "I had it
% working before, but I can't figure out how to get back to those settings"
% probem! :-)

% Okay, enough "meta" stuff, let's plot something. Double-click on the
% "populationDynamics__exampleResult" line in the "Saved Results:" window.
% (Alternatively, you can click the "PLOT..." button below the main results
% window. This button allows you to select and plot several results at
% once.) A window will now pop up and ask you what part of the saved data
% set you want to plot. Go ahead and try different options and see what
% happens. Next, double-click the result again and select all the plottable
% fields when it asks. You now see a plot with four similar traces and then
% one called "microNoise" that pretty much looks like a flat line. That's a
% common problem, where you have e.g. some voltage outputs and some current
% outputs with a significantly different scaling (e.g. Volts versus uA).
% Solving commone figure handling issues like this is what the "Figure
% Control and Plot Tools" are there for: to help you get your plots ready
% for export into presentations, papers, or reports. Click the "Move
% Trace(s) to Right Yaxis" button. Follow the visual instructions and move
% the "microNoise" trace to the 2nd y-axis. It looks much better now, so
% we're ready to export to our design report. Click the "Export Figure(s)"
% button and choose the "(Example) Population Dynamics" figure. You have
% many scalings to choose from, including the first choice which lets you
% specify custom dimensions. And boom - you're ready for publication. You
% can of course still use the built-in Matlab figure editing tools to get
% things like your legend and axis labels setup exactly as you want. But
% these can also be defined in code when you set up your plotting function.

% Try plotting the other result now, the one named "ctrlVarSweep...".
% Notice how it plots a little bit differently than the previous example
% (title and axis labels, etc.). This is because each saved result also
% contains information about what function should be used to plot it. There
% is therefore no limitation to how you plot your data for different types
% of saved results, you have complete control over the underlying functions
% that do this. This is explained in more detail in the help document:

    open gettingStarted__customProjectFunctions

% This document will also show you how to get started, in general, with
% integrating your custom code so that it saves results that will appear
% automatically in the Results Manager.

% There are several API functions related to the use of the Results
% Manager:

    % Primary Functions:
    help addResult
    help getResult
    help addStateDataToResult
    help saveSystemState
    
    % Secondary Functions:
    help getControlState
    help getEquipmentState
    help getExportState
    help getGlobalOptionsState
    help setControlState
    help setEquipmentState
    help setExportState
    help setGlobalOptionsState  
    
% For the most part, you will only need to use the Primary Functions
% listed here. The "addStateDataToResult" can be used in your custom
% functions to add the reproducability features we discussed earlier. The
% "saveSystemState" function takes a snapshot of the current system state
% directly, and this can also be done graphically by clicking the "Save
% Current State" in the Results Manager tab.

