% =========================================================================
% Getting Started With the Execution Manager
% =========================================================================
% Promethean Toolkit Benjamin Hershberg, 2020


% Ultimately, every project is unique and requires some custom code.
% Promethean Toolkit includes several APIs that allow you to interface your
% custom code with the tools of Promethean Toolkit itself, using only
% function calls. Thus, if you like to do everything with only text files
% and the Command Window in Matlab, that's all you'll need. However, it is
% often very advantageous to integrate your custom code into the graphical
% frontent of Promethean Toolkit. Not only will this make your life much
% easier, but it will make the lives of your colleagues and clients much
% easier too. Instead of having to dig through cryptic code libraries,
% they'll be able to use your work graphically through Promethean Toolkit
% itself. It really cannot be overstated just how much a graphical way of
% working can boost productivity. You catch mistakes quicker, instantly get
% insight into the underlying data, and can experiment with different
% settings much easier.

% There are two main ways that this custom code integration can be done:
% (1) with the Execution Manager, and (2) with a Custom GUI tab. The
% Execution Manager is the easiest option for getting started immediately,
% and that's what we'll focus on in this file. It has limitations to what
% it can do, but if you only have a few custom functions that you need to
% run, this is a good place to start. Later, you can always expand to a
% full custom GUI tab if you find that have the need for it.

% A core principle of building custom functions in Promethean Toolkit is
% that all custom code should be capable of two modes of execution. First,
% it should be executable as a non-interactive direct function call from a
% script, function, or the Matlab Command Window. If you're calling a
% function from some other piece of code, you generally don't want
% interactive windows popping up all over the place asking for user input,
% you just want it to run in "silent mode". Second, it should be executable
% as an interactive function if called from within the GUI environment of
% Promethean Toolkit. You will find that this mode is very useful! In
% interactive mode, the user is able to edit the parameters of execution
% that will determine how a function runs. For example, if you're running a
% measurement sweep, the user can interactively define the sweep start,
% stop, and step parameters, how many samples to average when measuring,
% etc. The custom function programming guide provided below will get you
% started on writing custom code that will support both modes of operation
% (and more!):

    open gettingStarted__customProjectFunctions.m
    
% That's some background, now let's load up the demo state file and take a
% look at an example use-case of the Execution Manager:

    loadDemoState;
    selectTab('Execution Manager');

% The modules in the first column of the first sub-tab of the Execution
% Manager tab are all examples of custom user functions or scripts. Notice
% that both scripts and functions can be executed through this interface.
% Take a look at the templates provided for each:

    open template__basicExecuteFunction.m
    open template__basicExecuteScript.m
    
% How you code your low-level functions is up to you, but coding top level
% functions that interface with Promethean Toolkit should adhere to a fixed
% structue of single input argument (options) and single output argument
% (results). Both arguments are of data-type structure. The input "options"
% structure lets you adjust optional parameters about how your code will
% run, and the results structure contains all relevant outputs. The
% Execution Manager allows you to fine-tune the options that will be passed
% into your function. Take a look at the "Edit Options" and "View Defaults"
% buttons in each Execution Module. "View Defaults" pulls the default
% option parameter values that you define inside the function itself (using
% the structFieldDefaults() parser object). This button is just there to
% make your life easier so that you know what options are even available to
% begin with. The "Edit Options" is the main thing to pay attention to,
% because the values in here will be passed into your function when you
% click the "Execute" button. In the case of a script, a similar scheme is
% possible, except of course you cannot pass arguments into a script, so
% instead the Execution Manager will simply include the options structure
% in the runtime environment of the script. Go ahead and try changing some
% of the options in these first two execution modules with the "Edit
% Options" button and see what happens to the function / script outputs.

% If you need to execute any of these modules from within your code, you
% can use the API functions for this:

    help executeModule
    help programChip
    help batchExecute
    
% "executeModule" is self-explanatory. The others we will discuss later on.
    
% The bottom two modules in the first column of the demo setup are two
% examples of custom user functions. Again, take a look at the "View
% Defaults" and "Edit Options" buttons for these modules. Notice how there
% are several default parameters but we are only over-riding two of them
% with our own custom values. Namely, "options.interactive" and
% options.saveResults". By setting the "interactive" option to "true", we
% are telling the underlying function that we want it to execute in a
% graphical & interactive mode that allows the user to edit the options
% before they are passed to the function for execution. By setting the
% "saveResults" options to "true" we are telling the underlying function to
% add its output results to the Results Manager. Go ahead and click Execute
% on these functions and try them out (and see what shows up in the Results
% Manager).

% Notice how when you run these two examples, some interactive steps allow
% you to customize exactly how you want the code to execute. This is
% incredibly useful for running experiments in the lab, where you often
% want to do something fairly generic (e.g. sweep input frequency of an
% ADC) but often want to do that generic thing in a specific way that
% constantly changes (e.g. sweep input from 100MHz to 400MHz with 100 steps
% and average 5 samples per step, and re-equalize the input power to
% produce -1.5 dFS at the ADC output for each step).

% Also visible at the bottom of each module panel is the name of the
% function that will be executed. Let's try running these functions from
% the command line and see what happens:

    example_userFunction();
    example__sweepControlVariable();
    
% Notice how the interactivity is gone, the function executes based only on
% its internal default values. Of course, we can set up different options
% in our code and pass those in directly without interactivity. For
% example:

    % set some options:
    options = struct;
    options.sweepValues = 5:1:20;
    options.parameterPath = {'digital.CH2.STG1.ringampBiasControl'};
    
    % pass them in and run:
    result = example__sweepControlVariable(options);
    
    % store the output result:
    result.notes{1} = 'This came from the execution manager help file';
    addResult(result, 'This_Came_From_Command_Line');
    

% Let's move on. The second column of execution modules in the demo state
% are various format exporters. The first one is an example for exporting
% to a physical chip. The next two export into a CAD environment,
% auto-generating ADE Variable states and Veriloga digital blocks for use
% in Cadence. The last one auto-generates a documentation for the Control
% Varialbe hierarchy.

% Notice how the interface panel for each execution module contains a
% number of helpful configuration options, including the "batch execute"
% and "chip programmer" toggles. You can use these to flag which functions
% should be executed (sequentially from first to last if multiple are
% flagged) by the programChip and batchExecute API functions. For your
% convenience, a "Program Chip" button is included in the Control Variable
% Editor, since it's often the case that you're often wanting to program
% the chip after fiddling with control variable values.

% To add a new Execution Module to the panel, go to the last sub-tab (in
% this example, that would be "Execution Modules (Tab 2)". You will see a
% panel that lets you initialize a new module.

% If at some point you find that the Execution Manager just isn't cutting
% it and you need a more complex GUI for your work (and very often you
% will), then you can easily do so with a large number of tools included
% with Promethean Toolkit for helping you to painlessly do that:

    open gettingStarted__customGUI.m

% Often, you will find that it is still useful to keep all of the export
% related functions and scripts in the Execution Manager even if you've
% built a custom GUI tab, because the options you set up in the Execution
% Manager are persistent and saved as a part of your system state. For
% things like measurement scripts, you often intend to ask the user to
% setup the options from scratch each time, so this isn't necessary. But
% for exporting, you only want to configure the exporter options once and
% then let it run repeatedly using that setup. This allows you to configure
% things for the particular enviroment you're in without needing to modify
% any underlying code. It is extremely useful when you're, for example,
% working with several users. Let's say each user has a different Cadence
% library path that they wish to export state data into. With the Execution
% Manager approach, each user can specify their own personal library paths
% in the execution module without needing to modify any internal code of
% the underlying generic export function. Another example is the chip
% programmer: in the new networked imec lab environment each "Kuba NoC" usb
% programmer has an ID that identifies it on the network. Just set up your
% options.NocID value to the device you want to program to through the
% Execution Manager interface, to be passed into the underlying programmer
% function, and you're up and running! External clients receiving IP
% samples will also benefit from making it so easy to reconfigure the
% system to their unique environment.

% As a side note, you may notice that a lot of the Execution Manager
% related functions in the core code library use "export" or "export
% profile" terminiology rather than "execution". This is simply a
% historical quirk, because originally this tool was developed only for
% executing export related code, but it was eventually realized that it
% could be generalized to support execution of anything. Someday perhaps
% someone will go through all the files and functions and rename them, but
% that day is not today!
