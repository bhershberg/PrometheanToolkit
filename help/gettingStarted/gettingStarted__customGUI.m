% =========================================================================
% Getting Started With A Custom GUI
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020


% Most projects quickly outgrow the Execution Manager as the sole method
% for running custom code in Promethean Toolkit environment. The Execution Manager
% is always a great option for exporting to external formats such as a Chip
% Programmer or into CAD tools because of its persistent user-defined
% 'options' structures that are passed into the underlying script or
% function. These persistent options don't need to be setup each and every
% time, they remember whatever you set them to and can be saved to disk
% along with the rest of the system state. However, for code that you don't
% want or need persistent 'options' a custom GUI tab can often make a lot
% of sense. This is usually the case for e.g. most measurements because you
% actually *want* your interactive measurement configuration process to
% start from fresh defaults each time. A custom GUI tab is also much more
% flexible than the Execution Manager. There is really no limit to what you
% can do or what you can implement with a custom GUI. It can even be as
% complex (or even more complex) as the core tabs of Promethean Toolkit.

% We will build upon the related guide for integrating your own
% custom code, so please read that first:

    open gettingStarted__customProjectFunctions
    
% Recall from this other guide that the exection stack of Promethean Toolkit is as
% follows:

% L0:   Promethean Toolkit
% L1:       |--- GUI tab (e.g. a Custom tab or Execution Manager)
% L2:           |--- UI element in GUI (e.g. a button)
% L3:               |--- UI element Callback Function
% L4:                   |--- Top Level Custom Function
% L5:                       |--- Plotting Function for analyzing / visualizing results.
%                           |--- Nested Sub Function(s)

% In this guide we will discuss how to set up levels 1 - 3 with your own
% Custom GUI tab in the main GUI interface. You can use the following
% template for building your custom GUI tab:

    open template_GUI_tabInit_customTab
    
% Hopefully the comments in this file make it fairly self-explanatory.
% Notice how UI elements are added with simple function calls provided by
% Promethean Toolkit's graphical API:

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

% To display your tab in the main GUI, we must register it in the following
% file:

    open custom__initializeProjectGuiTab

% For example, as we see from the default shown in that file, you can add a
% tab to the end of the sequence with the line:

    manager.placeTab(mainGuiTabs, 'Your Tab Name', @your_tab_functionName);
    
% Edit the "CUSTOM LOGIC (USER DEFINED)" part of this file however you
% wish. It doesn't need to be static. This function will re-execute and
% re-draw these tabs every time you load a file through the File Manager
% tab. So, if for example, you have different design generations (v1, v2,
% v3) and you want different custom tabs to show for each generation, you
% can do some simple if/else logic to make that happen. You can also
% include any other code you might want to run when a file loads (e.g.
% check that certain Global Options are defined) in this file.
    
% Each UI element in your custom GUI tab (e.g. button) needs a callback.
% Attaching the callback to the UI element is simple to do. For example,
% for the button, the syntax is:

    buttonObj = placeButton(tabObject, row, col, 'Button Name', {@CB_yourCallback, param1, param2}, options);
    
% Take a look at the help for each API function to see more about usage.
% Notice that in the above example, we define a callback function and pass
% into it to parameters 'param1' and 'param2'. The callback function will
% thus expect 4 parameters and the function definition will look like:

    function CB_yourCallback(source, event, param1, param2)
        % code to run when button is clicked.
    end

% Note that this just follows the standard Matlab UI callback system. So if
% you're confused by the above example, just see the main Matlab
% documentation for callback functions. The 'buttonObj' object that the
% placeButton function above returns is just a regular Matlab UI object, so
% all of the object properties for such an object that are described in the
% following Matlab documentation can also be accessed using dot notation
% for these objects too:

    help uicontrol
    
% To repeat the above example, you can also assign the callback directly
% with dot notation for the same outcome:

    buttonObj = placeButton(tabObject, row, col, 'Button Name');
    buttonObj.Callback = {@CB_yourCallback, param1, param2};
    
% As another example of how to build out a custom tab, you can take a look
% at the code for the "Help" tab of the GUI:

    open example_GUI_tabInit_helpTab.m
    
% Of course, you probably don't want to edit this one too much since it is
% used by Promethean Toolkit!