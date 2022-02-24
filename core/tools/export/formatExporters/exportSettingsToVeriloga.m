% =========================================================================
% Exports control variables from Promethean Toolkit to a veriloga block definition.
% =========================================================================
% Benjamin Hershberg, 2020
% 
% Usage: exportSettingsToVeriloga(verilogaSpec, options)
%
%   + verilogaSpec is a structure that requires two fields:
%       + name: name of your veriloga block
%       + parts: an Nx2 cell array. The two elements in each row are:
%               + index 1: the path to the location in the control variable
%               hierarchy that you want to include. All variables under
%               this path location in the hiearachy will be included.
%               + index 2: an optional prefix that you can add, that will
%               be prepended to each variable name in the veriloga block.
%   + options is a structre with options defining how to execute. The main
%       option that must be set is options.libraryPath, which points to the
%       filepath location that you wish to export to.
%
% Example:
% 
% options.libraryPath = './outputs/CADENCE_LIBRARY/';
% verilogaSpec = struct;
% verilogaSpec.name = 'VerilogaBlock_TOP_and_CH1';
% verilogaSpec.parts{1} = {'digital.TOP'; 'D_TOP_'};
% verilogaSpec.parts{2} = {'digital.CH1'; 'D_CH1_'};
% exportSettingsToVeriloga(verilogaSpec, options);
%
% For more examples, see function: 'example__exportToVerilog'
%
function exportSettingsToVeriloga(verilogaSpec, options, dummy)

    global settings;

%   legacy format was:
%   exportSettingsToVeriloga(settings, verilogaSpec, options)
%   so, let's support that:
    if(isfield(verilogaSpec, 'readme') && isfield(verilogaSpec, 'options'))
        verilogaSpec = options;
        options = dummy;
    end
    
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('exportVeriloga',true);
    parser.add('libraryPath','./outputs/');
    options = parser.applyDefaults(options);

    if(options.debug)
       fprintf('Export of %s to Veriloga: ',verilogaSpec.name);
    end

    if(options.exportVeriloga)

        try
            flatlist = struct;
            for i = 1:size(verilogaSpec.parts,2)
                part = eval(getAbsoluteControlVariablePath(verilogaSpec.parts{i}{1}));
                if(iscell(part))
                    flatlist.(verilogaSpec.parts{i}{2}) = part;
                else
                    if(length(verilogaSpec.parts{i}) < 2), verilogaSpec.parts{i}{2} = ''; end
                    flatlist = flattenStruct(part, flatlist, verilogaSpec.parts{i}{2});
                end
            end
            convertToVeriloga(flatlist,verilogaSpec.name,fullfile(options.libraryPath, [verilogaSpec.name '/veriloga/veriloga.va']));
            
            if(options.debug), fprintf('done.'); end
            
        catch
            fprintf('ERROR, Veriloga export failed.');
        end

    elseif(options.debug)
        fprintf('not requested, skipping.');
    end
    
    if(options.debug), fprintf('\n'); end

end