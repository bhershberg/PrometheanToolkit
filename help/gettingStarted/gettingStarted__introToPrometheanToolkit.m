% =========================================================================
% Introduction to Promethean Toolkit - Centralized Design and Test
% =========================================================================
% Benjamin Hershberg, 2020


% A tool for IC design and test.

    
% Getting Started ===============

% If you are already familiar with coding in Matlab, you should plan to
% dedicate about one day in order earn your black-belt in Promethean
% Toolkit.

% An introduction to Promethean Toolkit explaining the main features,
% motivations, and benefits, is given in the slides here:

    open introToPrometheanToolkit_Presentation.pdf
    
% To launch Promethean Toolkit, simply make sure that "Promethean
% Toolkit.m" is in your search path and then type "Promethean Toolkit" into
% the Matlab command window:

    PrometheanToolkit;

% If you're eager to explore the different tabs of this GUI, you can load
% up the demo state file to see what it looks like with actual system state
% data loaded up:

    loadDemoState;
    
% To get started, begin in the Help tab of the GUI and read through the
% tutorial files that open when you click the buttons in the "Tutorials"
% sub-panel located in the Help tab. Start from top to bottom. Don't worry
% about the other sub-panels in here yet, you'll use them later on in some
% of the tutorials.

% Each of these tutorials are briefly summarized below:


% Core (Default) Modules ======================

% File Manager
%   This tab handles the basics of loading / saving system states into The
%   Source and allows you to setup your system configuration with so-called
%   "global options".
    open gettingStarted__fileManager
    
% Control Variable Editor
%   This tab provides an interface for viewing and editing variables
%   involved in control. This includes variables related to digital control
%   and variables used in CAD environments.
    open gettingStarted__controlVariables

% Equipment Interfaces
%   This tab provides an interface to your physical lab equipment and
%   instrumentation. It enables remote software control of your measurement
%   setup and provides a record of exactly what state your external test
%   setup is in when taking measurements and collecting data.
    open gettingStarted__equipmentInterfaces

% Execution Manager
%   This tab provides a way to quickly integrate custom code into The
%   Source, and provides special features for exporting to various output
%   destination formats such as a physical chip programmer or automatically
%   generated CAD files such as Cadence ADE state variables or Veriloga
%   control blocks.
    open gettingStarted__executionManager

% Results Manager
%   This tab provides a way to save results from either lab or CAD outputs,
%   and then interactively plot and/or analyze these results in a way that
%   each plotting or analysis is custom tailored to the particular type of
%   result data that is stored. It also provides a way to save system state
%   information, and restore these states, thereby providing a way to
%   reproduce the exact setup that existed when the measurements were first
%   run.
    open gettingStarted__resultsManager

    
    
% Customization and Code Integration ==================================

% All designs and all projects are different, and inevitably require custom
% code. Promethean Toolkit is built to support rapid integration of custom
% code through the use of several techniques.

% First of all, a set of Application Programming Interface or "API"
% function libraries allow custom code to interface with all of the
% features of the core modules:

    open gettingStarted__APIs
    
% Second, a set of templates are provided for how to write your custom
% code, and if these templates are followed you will immediately benefit
% from a number of best-practice features regarding reproducability and
% interactive user-based control of setting up tests and measurements:
    
    open gettingStarted__customProjectFunctions
    
% Finally, to put it all together, it is possible to add any number of
% custom tabs to the GUI, and quickly build them up using a sub-set of the
% graphical API function library:

    open gettingStarted__customGUI
    

% Good luck, and may Promethean Toolkit help to pave your road to glory!



% The Background, History & Motivation ========

% Prometheus is known, among other things, as the Greek god of foresight.
% In IC design and test, a little foresight can pay large dividends later.
% This is a tool made by IC designers for IC designers, based on decades of
% experience, that enforces compliance with best-practices that will help
% you and your organization avoid many common pitfalls.
% 
% Promethean Toolkit solves many of the most common problems encountered in
% both IC design and test by centralizing information describing the state
% of your system in a single source location. This centralization provides
% many advantages of synchronization, reproducibility, traceability, and
% usability. It is all handled through a graphical environment and
% programming API that boosts productivity and increases insight, enabling
% rapid test automation and multi-user collaboration.
%
% This software was originally built for the purpose of providing a visual
% interface that could automate common tasks in the measurement of
% integrated circuits and enforce best-practices leading to important
% secondary features such as reproducability, traceability, and usability.
% During its development, it soon became clear that many of the roles it
% was fulfiling in the lab environment, it could also fulfill in the CAD
% design environment. It thus expanded to a larger role as a single,
% central, synchronized data source that represents the full "system
% state". In designs containing many variables, such as digital controls,
% maintaining synchronization between various parts of the workflow quickly
% falls apart. By consolidating all of this into Promethean Toolkit, and
% only changing state information within Promethean Toolkit itself and then
% exporting out to various external formats and desitnations,
% synchronization across all environments, both virtual and physical, can
% be maintained. Each system state is stored in simple human-readable data
% structures that can be saved to disk as regular .mat data files. Simply
% loading a saved system state file can instantly restore you to exactly
% where you left off previously in that file. This provides the key
% advantage of reproducability. It becomes trivial to reproduce complex and
% long forgotten measurements instantly. When delivering physical IP to
% external clients, this ability to transfer your local system setup in a
% consistent coherent manner to other physical locations and teams in the
% form of a simple point-and-click graphical interface provides significant
% added value to customers.

% Promethean Tools was iteratively developed over the course of several
% design and measurement cycles, expanding features and functionality based
% on necessity. This, hopefully, results in a tool that is streamlined
% enough to have a realtively short learning curve, but still contains the
% essential aspects that all IC designers and test engineers need in order
% to carry out professional work.
    