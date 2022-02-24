% =========================================================================
% Exports control variables from Promethean Toolkit to an ADE variable state that
% can be loaded in Cadence.
% =========================================================================
% Benjamin Hershberg, 2020
% 
% Usage: exportSettingsToADE(adeSpec, options)
%
%   + adeSpec is a structure that requires two fields:
%       + name: name of your cellview in Cadence to export the ADE state to
%       + parts: an Nx2 cell array. The two elements in each row are:
%               + index 1: the path to the location in the control variable
%               hierarchy that you want to include. All variables under
%               this path location in the hiearachy will be included.
%               + index 2: an optional prefix that you can add, that will
%               be prepended to each variable name in the ADE variable list.
%   + options is a structre with options defining how to execute. The main
%       option that must be set is options.libraryPath, which points to the
%       filepath location that you wish to export to. Also useful is the
%       option 'statePrefix', which can be set to a string that will be
%       prepended as a prefix to the output state name. This is
%       particularly useful for multi-user scenarios; each user can use
%       their own prefix string, so there will be no one over-writing the
%       export outputs of other users.
%
% Example:
%
% options.libraryPath = './outputs/CADENCE_LIBRARY/';
% options.statePrefix = 'BH_';
% adeSpec = struct;
% adeSpec.name = 'Testbench_TOP';
% adeSpec.parts{1} = {'digital'; 'D_'};
% adeSpec.parts{2} = {'sim'};
% exportSettingsToADE(adeSpec, options);
%
% For more examples, see function 'example__exportToADE'.
%
function exportSettingsToADE(adeSpec, options, dummy)

    global settings;

%   legacy format was:
%   exportSettingsToADE(settings, adeSpec, options)
%   so, let's support that:
    if(isfield(adeSpec, 'readme') && isfield(adeSpec, 'options'))
        adeSpec = options;
        options = dummy;
    end
    
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('exportADE',true);
    parser.add('libraryPath','./outputs/');
    parser.add('statePrefix','');
    options = parser.applyDefaults(options);

    if(options.debug)
       fprintf('Export of %s to ADE: ',adeSpec.name);
    end

    if(options.exportADE)

        try
            flatlist = struct;
            makeSureADEDirectoryExists(fullfile(options.libraryPath, [adeSpec.name '/' options.statePrefix 'VarOnly']));
            for i = 1:size(adeSpec.parts,2)
                part = eval(getAbsoluteControlVariablePath(adeSpec.parts{i}{1}));
                if(~length(adeSpec.parts{i}) < 2), adeSpec.parts{i}{2} = ''; end
                flatlist = flattenStruct(part, flatlist, adeSpec.parts{i}{2});
            end
            convertToADE(flatlist,fullfile(options.libraryPath, [adeSpec.name '/' options.statePrefix 'VarOnly/variables.state']));
            
            if(options.debug), fprintf('done.'); end
            
        catch
            fprintf('ERROR, ADE export failed.');
        end

    elseif(options.debug)
        fprintf('not requested, skipping.');
    end
    
    if(options.debug), fprintf('\n'); end

end

% subfunction
function makeSureADEDirectoryExists(pathname)
    if(~exist(pathname,'dir'))
       mkdir(pathname); 
       h = fopen([pathname '/ADE_state.info'],'w');
       fprintf(h,'');
       fclose(h);
       h = fopen([pathname '/paramSetup.state'],'w');
       fprintf(h,'');
       fclose(h);
       h = fopen([pathname '/master.tag'],'w');
       fprintf(h,'-- Master.tag File, Rev:1.0\nADE_state.info');
       fclose(h);
    end
end