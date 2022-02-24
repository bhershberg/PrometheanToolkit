% =========================================================================
% Exports control variables from Promethean Toolkit to a Documentation CSV file
% =========================================================================
% Benjamin Hershberg, 2020
% 
% Usage: exportSettingsToDocumentation(docSpec, options)
%
%   + docSpec is a structure that requires three fields:
%       + name: filename of the CSV file
%       + exportPath: filepath to save the CSV file to
%       + parts: an 1x1 cell. The control variable path to generate
%           documentation for. Anything variables under this path in the
%           control variable hiearchy will be included.
%   + options is a structre with options defining how to execute.
%
% Example:
%     % preparation:
%     docSpec = struct;
%     [path, name, ext] = fileparts('./outputs/controlVariableDocumentation.csv');
%     docSpec.exportPath = path;
%     docSpec.name = [name ext];
%     % assemble the export spec:
%     docSpec.parts{1} = {''}; % we want to export the entire control variable tree, so just provide a null path
%     % export:
%     exportSettingsToDocumentation(docSpec, options);
%
% For more examples, see function 'example__exportDocumentation'.
%
function exportSettingsToDocumentation(docSpec, options, dummy)

    global settings;

%   legacy format was:
%   exportSettingsToDocumentation(settings, docSpec, options)
%   so, let's support that:
    if(isfield(docSpec, 'readme') && isfield(docSpec, 'options'))
        docSpec = options;
        options = dummy;
    end
    
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('exportDocumentation',true);
    options = parser.applyDefaults(options);

    if(options.debug)
       fprintf('Export of Documentation to %s: ',docSpec.name);
    end

    if(options.exportDocumentation)

        try
            docSpec.exportPath = fullfile(docSpec.exportPath);
            if(~exist(docSpec.exportPath,'dir'))
                mkdir(docSpec.exportPath); 
            end
            fileName = docSpec.name;
            settings_doc = eval(getAbsoluteControlVariablePath(docSpec.parts{1}{1}));
            convertToDocumentation(settings_doc,fullfile(docSpec.exportPath, fileName));
            
            if(options.debug), fprintf('done.'); end
            
        catch
            fprintf('ERROR, Documentation export failed.');
        end

    elseif(options.debug)
        fprintf('not requested, skipping.');
    end
    
    if(options.debug), fprintf('\n'); end

end