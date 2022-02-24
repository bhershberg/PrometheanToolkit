% How to use the global options
% Benjamin Hershberg, 2020
%
% Sometimes you will want to have certain variables in your system
% that are persistent and "global". This is what the globalOptions provide.
% Examples of how this can be useful are e.g. for specifying which
% instrument is your core supply, which is your signal source, which is
% your clock source, the exact details of how you want your capture and
% plotting functions to behave, etc.
%
% You can view/edit the global options graphically with the "Edit Global
% Options" button in the File Manager tab.
% 
% There is also an API that you can use to get/set options in your custom
% code:
%
%   [value, allOptions, tf] = getGlobalOption(optionName, defaultValue)
%   
%   [options] = setGlobalOption(optionName, value)
%
% you can read more about these functions with the built-in matlab 'help'
% command, i.e.:
help getGlobalOption;
help setGlobalOption;

% if you have a global option you want to clear entirely, just call the
% delete function:
deleteGlobalOption('justSomeExample');

% check if a global option exists:
if(~isempty(getGlobalOption('justSomeExample')))
    fprintf('it exists!\n');
else
    fprintf('nothing to see here, folks...\n');
end

% get an option value, and if it does not exist, initialize it with a
% default value
optionValue = getGlobalOption('justSomeExample', 'hello world!');
fprintf('%s\n',optionValue);


% set a new option value:
setGlobalOption('justSomeExample', ['let''s say it again: ' optionValue]);

optionValue = getGlobalOption('justSomeExample');
fprintf('%s\n',optionValue);

% go ahead and run this script a few times.

% now take a look in the File Manager tab and click on the Edit Global
% Options button. You'll see the option value. You can delete it, and start
% over, or modify the value as desired.
