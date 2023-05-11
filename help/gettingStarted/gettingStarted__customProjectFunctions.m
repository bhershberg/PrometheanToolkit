% =========================================================================
% Integrating your own code and functionality into Promethean Toolkit
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020


% Every project requires some custom code. At very least, it needs code
% that can export the internal system state to project-specific external
% formats, such as the registers of a physical chip, or ADE variables in a
% Cadence cellview. But that's really just the beginning. Automating
% measurements in a lab environment necessarily requires quite a bit of
% custom code. For complex designs or large test campaigns, this can easily
% turn into a function library unto itself. The role of Promethean Toolkit
% in all this is three-fold: (1) automate the most common tasks that every
% designer needs with the already provided default GUI tabs, (2) do this in
% a way that provides best-practice tools for traceability, repeatability,
% and collaboration, and (3) enforce a framework that will encourage
% designers to adhere to best-practices. It is this third point where
% Promethean Toolkit and custom code intersect. By following the templates
% and examples that are provided for custom code integration, it will
% enforce a number of best-practices that you will be thankful to have
% followed further down the road.

% It is first useful to say a little bit about the way that code and
% functions are structured. The "execution stack" or "function stack" in
% Promethean Toolkit is as follows:

% L0:   Promethean Toolkit
% L1:       |--- GUI tab (e.g. a Custom tab or Execution Manager)
% L2:           |--- UI element in GUI (e.g. a button)
% L3:               |--- UI element Callback Function
% L4:                   |--- Top Level Custom Function
% L5:                       |--- Plotting Function for analyzing / visualizing results.
%                           |--- Nested Sub Function(s)

% Level 0 is Promethean Toolkit and the GUI itself. Below that, in level 1 is the
% high-level GUI tab "modules". For the case that we're discussing here,
% which is running custom code, Level 1 is either the Execution Manager or
% a custom GUI tab of your own design. At level 2, there are UI
% sub-elements of the GUI such as a button saying "click me to run this
% code!". Below that in level 3 is a callback function for the UI element
% that connects the e.g. button to your actual function. At level 4 we
% arrive at your top level custom function. And then below that in level 5
% there is (1) other nested code including custom sub-functions or whatever
% else you need, and (2) a plotting function that knows how to analyze
% and/or plot your results and outputs. When you open old data saved in the
% Results Manager, it will know to use this custom plotting function too.

% As a side note: it is often very useful to add an extra layer of
% abstraction to custom functions that do a "fundamental" task when you're
% at level 4 and below. This idea of using function "wrappers" allows you
% to separate the "idea" of what a function should do from the specific
% implementation of it. The following example of a wrapper demonstrates
% this concept and describes it further:

    open wrapperExample__captureData

% Returning to the main conversation: the point of entry in this hierarchy
% is a little different depending on how you are running custom code. If
% you are running code through the Execution Manager, then Levels 0 - 3 are
% already handled by Promethean Toolkit and you only need to worry about levels 4
% and 5. For more information about this integration into the Execution
% Manager, take a look at the "getting started" doc about that tab:

    open gettingStarted__executionManager
    
% In the other scenario, you are executing custom code through a custom
% GUI tab. In that case, you need to provide levels 1 - 5 (this is,
% afterall, the price paid for customization). The "getting started" guide
% below walks you through what you need to know for putting together
% levels 1 and 2:

    open gettingStarted__customGUI
    
% Therefore, in this guide, we only focus on what you need to know for
% levels 3 - 5. The following templates provide everything you need to
% implement these levels:

    open template_userFunction
    open template_plot_userFunction
    open template_CB_userFunctionCallback
    
% They're commented in order to help you, but once you understand what the
% code does, it can start to feel overly cluttered. No worries, here are
% some templates with identical code but without all the commenting:
    
    open template_userFunction_withoutComments
    open template_CB_userFunctionCallback_withoutComments

% Templates are great and all, but nothing beats an example, right?! Well,
% here are the files for that too:

    open example_userFunction
    open example_userSubFunction
    open example_plotFunction
    open example_CB_userFunctionCallback

% You can run this example by going to the "Help" tab of Promethean Toolkit GUI and
% clicking the "Run Example" button in the "Example: Intro to Custom
% Functions" sub-panel. Or, if you load up the demo state file, you can
% also run the exact same code from the Execution Manager by running the
% "Example - Fully Interactive Function Integration (Example #1)" execution
% module:

    loadDemoState;

% Try both options, and try to understand how they both work with regard to
% the levels of the execution stack that we discussed earlier.

% From the templates and examples above, you should be able to understand
% the following concepts:

%   + Concept: Default options are defined inside of each function (and
%       sub-function). Anything in your code that you want to be able to
%       configure externally should be set with an option. It is
%       best-practice to only define the default options for the code
%       inside the function at hand. Any options (parameters) inside
%       sub-functions should be defined in those sub-functions, not in the
%       top level function. You can always pull those parameters out (e.g.
%       so that the user can interactively edit them before execution) like
%       this:

    % Just some hypothetical option values of a "top level" function:
    optionsMaster.exampleField = 'hello world'; % Only the master has this
    optionsMaster.debug = 0;                    % Both slave and master have this. In slave value is '1' instead.
    
    % Request the default option values of a sub-function:
    optionsSlave = getDefaultOptions(@example_userSubFunction); 
    
    % Merge them together. If there is a conflict, the "master" set wins:
    optionsMerged = mergeStruct(optionsMaster, optionsSlave); % if both have the same field, master wins
    
    % Let the user view / edit combined set of options for the function and sub-function:
    optionsFinal = optionsEditor(optionsMerged);
    
%   + Every function supports an "interactive mode" that is enabled by
%       passing in "options.interactive = true;" to a function. This will
%       execute the "interactiveSetup" function (see botton of the template
%       file). It is up to you to define how fancy you want to make the
%       interactive mode. See the "Tools for Building GUIs and
%       Interactivity" in the "Help" tab of Promethean Toolkit GUI for inspiration.
%       The "Interactive Pop-up Elements" are provided to help you
%       customize the interactive mode to your needs. It is also important
%       to understand why interactive mode is, by default, always set to
%       'false' in the function templates and examples. This is because we
%       always want functions to serve a dual purpose. If they are
%       top-level, sometimes we want them to be interactive. But if they
%       are not top level then we almost always want them to be
%       non-interactive. For example:

    % If we are calling the function from within another function (i.e. at
    % level 5 of the execution stack), we just want it to execute based on
    % what the parent function provides to it. The user already got a
    % chance to set up the run control for this sub-function through the
    % interactive mode of the parent function, assuming that the parent
    % function also pulled in the default options of the sub-function using
    % the getDefaultOptions function that was discussed above:
    options.linearGrowth = 10:30;
    example_userSubFunction(options);

    % If we are calling the function at the top-level (i.e. at level 4 of
    % the exectuion stack) then we will let the user modify parameters
    % before execution:
    options.interactive = true;
    example_userSubFunction(options);
    
% Very often, what began as your "function" will later on become your
% "sub-function" as your code builds up and becomes more complex. Having
% this flexibility to both have the capability for interactivity if
% explicitly specified, but by default have it run like a regular
% non-interactive piece of code is very useful.

% The API contins many functions that allow you to create interactivity and
% GUIs:

    % Figures and Plotting:
    help namedFigure
    help askWhatToPlot

    % Interactive Pop-up Elements:
    help dataEditor
    help optionsEditor
    help textEditor
    help parametricSweepDialog
    help radioButtonDialog
    help checkboxDialog
    help listDialog
    
    % Interactive Fixed Elements:
    help relativePosition
    help placeButton
    help placeCheckbox
    help placeDropdown
    help placeEdit
    help placeListbox
    help placePanel
    help placeTab
    help placeText

%   + Concept: Adding your output results is simply a matter of packing
%       them all up into a "results" structure and adding to the Results
%       Manager with the function "addResult(result, 'Result Name');" It is
%       up to you whether you add the result at level 3 or level 4 of the
%       execution stack, since you will have access to it in both the
%       callback function and the top level custom function. If you are
%       executing through the Execution Manager, you must place it in level
%       4. If you are execution through a custom GUI it is your choice
%       where to do it. In the templates and examples provided earlier, it
%       is done in level 4, but only when the "options.saveResult = true;".
%       It is possible to set this parameter when either the Execution
%       Manager serves as level 3 or when a custom callback function serves
%       as level 3. So saving your results in level 4 has the benefit of
%       supporting both modes. But there are other cases where you will
%       prefer to add them in a Callback of level 3. With experience you
%       will figure out what is best for your case.

% 	+ Concept: Every custom function or bit of code will have its own needs 
%       with regard to analysis and plotting, so it is left to you to
%       define your plotting functions. The function handle must be
%       attached to the "results" output structure so that the Results
%       Manager will know what plotting function to use. Like the
%       interactive mode for the main function, the plotting function
%       template above also has a similar "options.interactivePlot"
%       parameter that, by default, is "false". This is because, generally
%       when you're running code, you don't want interactive plotting, you
%       just want it to plot the default visualization. For example, let's
%       say your code is running an input frequency sweep on an ADC, and it
%       takes 20 minutes to finish the full thing. It would be nice to see
%       some intermediate results along the way so that you know that your
%       sweep was set up correctly and everything is running smooth. In
%       that case, you could easily plot intermediate results in the
%       following way:

    results.plotFunction(results);
    
%   This would plot the default set of traces (or whatever default analysis
%   you want to report. It won't ask the user any questions, so the
%   plotting will run "in the background". But let's suppose that during
%   this hypothetical sweep, you saved a lot of different measurements,
%   e.g. SNDR, SFDR, THD, HD2, HD3, HD[4...20], Ain(dBm), Ain(dBFS), etc.
%   You don't necessarily want to plot all of this in the default mode, its
%   just too much information. But once your sweep is complete and saved to
%   the Results Manager, you will want to be able to do further analysis on
%   your results, and this is where the interactive plotting mode becomes
%   very useful. Behind the scenes, the Results Manager will always pass
%   "options.interactivePlot = true" into your plotting function. As
%   demonstrated in the plot function template, the "askWhatToPlot"
%   function is provided as a quick and easy way to ask the user what they
%   which saved fields in the results dataset to plot.

%   + Concept: For the sake or reproducability, it is advised as a 
%   best-practice to use the "addStateDataToResult" function, as shown in
%   the templates and examples above, to attach the current system state to
%   each result. This will give you a system snapshot at the moment right
%   before you run your code. It is also recommended to save the "options"
%   that the function is operating with. The combination - system state +
%   local execution state (defined by the run-time defined options) gives
%   you the full set of information that you will need to reproduce your
%   measurements at any time in the future. For convenience the
%   "addStateDataToResult" function lets you attach both of these things
%   with a single line of code:

    results.example = 'results are what you attach your output results to';
    options.example = 'options parameters can be reconfigured for every execution run by the user. This forms our "local"/"temporary" state';
    
    % This will add 'options' to results, and also several fields that are
    % the current system state (Control Variables, Equipment Interfaces,
    % Execution Manager, Global Options):
    results = addStateDataToResult(results, options); 
