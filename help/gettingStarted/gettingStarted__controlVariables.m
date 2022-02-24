% =========================================================================
% Getting Started With Control Variables
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020


% Whether you're dealing with design variables in a CAD tool like Cadence
% or digital registers on a physical chip, Promethean Toolkit provides a way to
% organize it all, view and edit it, document it, export it, and ultimately
% a way to maintain cross-tool synchronization, tied to a master source
% location. That is, after all, where "Promethean Toolkit" gets its name from - it
% is your central unified source for storing the state(s) of your system.
% Any time you change a parameter value in your system, you should change
% it in Promethean Toolkit and *only* Promethean Toolkit, and then export the updated state
% to all required destination formats through automated export scripts. One
% source, multiple destinations - that's the idea.

% The Control Variable Editor tab in Promethean Toolkit GUI provides a way to view
% and edit control variables. The first step in using this is to create
% your control variable structure, or at least a first draft of it. You can
% always tweak it later. An example of how to initialize some control
% variables is provided in this example:

    open example__setupControlVariables

% Although the way that you structure and organize your control variable
% hierarchy is unconstrained, it is recommended to build a hierarchy that
% is as layered as possible. This will allow you to take the most advantage
% of the Control Varaible Editor tools. Even if your variables aren't
% organized the same way in other tools that you plan to export to, that's
% OK, because you can always remap them to any other organizational format
% with some scripting.

% Let's load up the demo state and look at the Control Variable Editor tab:
    loadDemoState;
    selectTab('Control Variable Editor');

% Browse to, for example, 'digital.CH1.STG1.amplifyDuration'. What loads up
% here is a digital control variable. Because it is used in a physical
% register, it has not only a value, but a min and max bound, and register
% bit-width defined. You can view/edit in-line documentation for the
% variable. This built-in documentation is really handy for other people
% using your system, it gives them instant insight into what each variable
% does. Below the documentation is a field with the path string. This can
% be useful when you're coding up custom scripts and want to reference a
% particular variable when using the API to interact with the Control
% Variable system in your code. Finally, take a look at the right side of
% the window. Notice that the GUI has automatically detected that the same
% control variable name 'amplifyDuration' exists elsewhere in the
% hierarchy. Go ahead and hit "Select All" for for Grandparents and
% Parents. Now try out "copy" and "print" buttons below these lists. Pretty
% useful! In any system with repeated features of the hierarchy, such as an
% interleaved ADC or a phased-array, you'll find yourself using these tools
% constantly.

% As a second example, browse to 'sim.fclk'. This variable was initialized
% as a "soft" variable for use in CAD tools like Cadence. Unlike the "hard"
% variable from before that can only be an integer value, the value here
% can be integer, decimal, or string. Since there are no duplicates of this
% variable name found in the hierarchy, the hierarchical tools from before
% are not displayed.

% That's a brief tour of the GUI side of things. Now let's get back to
% initilization. There are a few points to consider when choosing naming
% conventions. Your life will be easiest if you use a convention that
% easily translates between the different tools you are working in.
% Variable paths are organized hierarchially using the familiar "dot"
% notation of Matlab. In other tools, dot separators may not work and
% you'll need to use e.g. "underscore" notation instead. For example, let's
% look at how we could map some variable paths in Promethean Toolkit into an ADE
% variable in Cadence:

    loadDemoState;
% Let's request the raw data data from the digital part of the control
% variable hiearchy. Take a look in the Matlab Command Window to see what
% comes out:
    digitalTree = getControlHierarchy('digital')
% Now let's flatten this hierarchy (and prepend a 'D_' prefix to all
% names) in order to convert the varaible names to something we can use in
% Cadence:
    flattenStruct(digitalTree, struct(), 'D_')

% Notice how when it flattened the structure, it converted from dot
% notation to underscore notation. If you plan a little bit in advance
% when you're working in Cadence, you can make the conversion between the
% two environments trivial. In fact, if you're really using Promethean Toolkit as
% intended, this will happen automatically, because you'll never be
% creating new variables in Cadence. They will always be created in The
% Source, and then *exported* into Cadence through various export channels,
% and you will just load those e.g. ADE state files up in Cadence and
% *poof* all of your variables will be there and waiting with nice
% hierarchical names and the values of your current system configuration!
% Let Promethean Toolkit lead, and Cadence follow, and you'll be in good shape
% starting from day #1.

% Once you have a first draft of your control variable hierarchy setup,
% save the state to disk through the File Manager tab of the GUI. Now
% you're all set to make different state files with different
% configurations of variable values, but with the same underlying variable
% definitions and structure. If for some reason you find that you need to
% over-write the control variables of one state file with another one,
% there is a button in the File Manager tab called "Load Control Variables"
% that allows to overwrite your control variables with those of a different
% file (without overwriting anything else in your state). You can also
% archive snapshots of your control variable state from within Promethean Toolkit
% and restore them later, as needed. This can be done from the Results
% Manager tab by clicking the "Save Current State" button. By following the
% instructions given in the Result Notes of the saved snapshot, you can use
% this to restore your control variable state to a previous configuration.

% In every project there are 2 customized tasks that you'll ultimately find
% the need for:

% (1) exporting your system state to various destinations such as Cadence
% or a physical chip. Load up the demo state file to see some examples of
% how this is done:

    loadDemoState;
    selectTab('Execution Manager');

% Take a look at the Execution Manager tab. Several of these demo Execution
% Modules give examples of how your control variables can be re-mapped and
% exported into various output formats and destinations.

% (2) Manipulating your control variable state in custom functions. Pretty
% much every project needs some custom functions, for example the code that
% runs your measuremets in the lab will undoubtedly need to be customized
% to fit your specific needs. You'll frequently want to be able to
% reconfigure parts of the control system and sweep control parameters in
% measurements. This can all be done rather painlessly through the Control
% Variable API:

    help createControlVariable
    help deleteControlVariable
    help getControlVariable
    help setControlVariable
    help listControlVariableRelatives
    help getControlHierarchy
    help getAbsoluteControlVariablePath
    help getRelativeControlVariablePath
    
% Recall that you can always get the "variable path" that these functions
% need from the Control Variable Editor in the GUI by using the path string
% provided in the "Path" edit box.

% In the following files, an example custom user function is demonstrated
% for the very common use-case of running a 1-dimensional parametric sweep
% of one or more control variables:

    open example__sweepControlVariable.m
    open example__plot_sweepControlVariable.m
    open example__CB_sweepControlVariable.m

% This example should give you an idea of how to use the get/set functions
% in the API. You can execute these functions interactively in both the
% Execution Manager by loading the demo state file and executing the
% execution module titled "Example - Fully Interactive Function Integration
% (Example #2)" or in the Help tab by clicking the "Run Example" button in
% the "Example: Control Variable API" sub-panel.

