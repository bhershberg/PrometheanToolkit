% How to do a capture with the Agilent 16902B Logic Analyzer
% Benjamin Hershberg, 2020
% 
% The basic "apply()" methods provided in the equipmentInterface and
% equipmentInterfaceGroup classes allows you to "click" the apply button in
% the GUI for the given interface(s) through the API.
%
% However, sometimes you will have several functions that an interface
% needs to be able to execute, and a single "apply" function isn't enough
% to do the job. This is very often true for capture devices where you need
% to do more complex operations to grab data and stream it in.
%
% An example is the Agilent 16902B Logic Analyzer interface definition that
% is provided as one of the default interface definitions. That interface
% manages to provide extra function call options by simply storing the
% relevant function pointers as interface properties. Here's how you can do
% a data capture following that approach:


% First, use the API to interface with the logic analyzer interface:
LogicAnalyzer = equipmentInterface('Logic Analyzer');

% Now pull out the 'capture_function' property. This property is a function
% handle pointing to @Agilent_16902B_logicAnalyzer_capture, which is the
% function that was written to pull capture data from the logic analyzer.
captureFunction = LogicAnalyzer.getProperty('capture_function');

% That function expects an equipmentInterface object as an input, 
% specifying what interface to capture with (in case there were more than 
% one logic analyzer in the setup, for example). So we just pass in the 
% interface we created above:
captureData = captureFunction(LogicAnalyzer);

% while we're at it, let's save the result to the result manager:
addResult(captureData,'lastCapture');

% And that's it! With this approach, you can easily add whatever extra 
% functionality or special abilities to your equipment interfaces that you 
% need for your testing. Go ahead and inspect the code of the following 
% functions to see how it all fits together for this example case:
open Agilent_16902B_logicAnalyzer_createInterface.m;
open Agilent_16902B_logicAnalyzer_capture.m;
