% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% options = optionsEditor( options );
% 
% 
% DESCRIPTION:
% 
% The Options Editor is the same as the Data Editor in that it allows a user to edit the data of a structure, but it is special-purpose. The customizable parameters have been defined for you, i.e. the base structure will be named 'options'. The Options Editor is very useful for allowing the user to modify function parameters prior to code execution. If you're using Promethean Toolkit correctly, then you will be using this tool constantly!
% 
% Notice the "Display All..." button at bottom right of the Data Editor. By default certain data elements like overly long vectors, cell arrays, nested structures, etc will not be displayed. But through this button, you can choose to override that and view everything.
% 
% 
% WORKING EXAMPLE:
% 
% options = getDefaultOptions(@example_userFunction);
% data.anExampleNestedStructure.foo = 'hello';
% data.anExampleNestedStructure.bar = 'world!';
% data.aVeryLongVector = 1:1000;
% options = optionsEditor(options);
% 
function [options, tf] = optionsEditor( options, parserOptions )
    if(nargin <2)
        parserOptions = struct;
    end
    parserOptions.title = 'Options Editor';
    parserOptions.message = 'Edit the options that will be passed into the function:';
    [options, tf] = dataEditor( options, 'options', parserOptions );
end