% =========================================================================
% Example - Export of Control Variable Embedded Documentation to a CSV file
% =========================================================================
% Benjamin Hershberg, 2020
%
function example__exportDocumentation(options)
    
    % Setup:
    parser = structFieldDefaults();
    parser.add('returnDefaults',false); % do not remove
    parser.add('debug',true);
    parser.add('exportFile','./outputs/controlVariableDocumentation.csv');
    parser.add('exportDocumentation',true);
    options = parser.applyDefaults(options);
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end  % do not remove
    
    
    % Export Documentation:
    
    % preparation:
    docSpec = struct;
    [path, name, ext] = fileparts(options.exportFile);
    docSpec.exportPath = path;
    docSpec.name = [name ext];
    % assemble the export spec:
    docSpec.parts{1} = {''}; % we want to export the entire control variable tree, so just provide a null path
    % export:
    exportSettingsToDocumentation(docSpec, options);

end