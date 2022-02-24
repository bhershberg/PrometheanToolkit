% =========================================================================
% Getting Started With the File Manager
% =========================================================================
% Promethean Toolkit
% Benjamin Hershberg, 2020

% The File Manager tab of Promethean Toolkit GUI is fairly self-explanatory for the
% most part. From here you can load up system state files and save the
% current state to disk. There is also a Read-me scratchpad where you can
% attach whatever notes, documentation, or code snippets you have to the
% state file.

% The "Tools" sub-panel has some important features that you will find
% yourself needing / wanting to use as you get into more advanced aspects
% of Promethean Toolkit.

% To begin with, we have the "Edit Global Options" button. This allows you
% to view / edit the global options of the current system state. Basically,
% these parameters define your system configuration. You can access them
% from any function simply by using the Global Options API functions:

    help getGlobalOption
    help setGlobalOption
    help deleteGlobalOption
    
% The following short tutorial shows examples of how to use the Global
% Options API:

    open example__usingGlobalOptions
    
% For the most part, it is best-practice to keep your options as localized
% as possible. But some things you will want globally set parameter that
% have persistant state independent of what functions you are running. This
% is what the Global Options are there for! For example, some of the
% equipment interfaces will do safety checks for max signal power or max
% supply voltage. These values will of course vary depending on your design
% and/or technology, so they are intialized as global options so that the
% user can set their safety limits without having to hack around inside the
% code for the equipment interfaces. As an example, take a look at some
% safety options that are defined in the demo state file:

    loadDemoState;

% Also in the "Tools" sub-panel are some buttons for loading up Control
% Variables, Equipment Interfaces, and Execution Modules from other files.
% These buttons will only overwrite the specific data that they refer to,
% and nothing else. You'll often find this to be useful if you change some
% part of your system setup but not the rest, and need to bring an old file
% up-to-date. For example, let's say you did measurements in Lab #1 with
% the equipement there. Then you shipped a sample to a client and they want
% to test in Lab #2 that has different equipment available. You could then
% use the "Load Equipment Interfaces" tab to update an old test file that
% you made when working in Lab #1 with the physical test setup of Lab #2.

