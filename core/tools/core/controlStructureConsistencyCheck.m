% This is a partial implementation of a control structure consistency check
% that can be run e.g. when a settings file is loaded into the GUI. Only
% the features that are deemend necessary (based on issues that have been
% encountered) are implemented here so far. ~BH 2019
function [ctrl, fixlist] = controlStructureConsistencyCheck(ctrl, options)

    fixlist = {};

    if(nargin < 2), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',true);
    parser.add('returnDefaults',false);
    parser.add('interactive', false);
    parser.add('breadcrumb',{});
    parser.add('top',true);
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end

    fnames = fieldnames(ctrl);
    for i = 1:length(fnames)
        var = ctrl.(fnames{i});
        varname =  fnames{i};
        tmpBreadcrumb = options.breadcrumb;
        tmpBreadcrumb{end+1} = varname;
       
        if(isstruct(var))
        % Hierarchy layer, make recursive call
            newOptions = options;
            newOptions.breadcrumb = tmpBreadcrumb;
            newOptions.top = false;
            [~,subFixlist] = controlStructureConsistencyCheck(var, newOptions);
            fixlist = [fixlist subFixlist];
            
        elseif(iscell(var) && length(var) >= 4)
        % Control Variable Check
            for j = 1:4
                if(~isscalar(var{j}))
                    fprintf('Non-scalar variable detected in index %d at %s\n',j,printBreadcrumb(tmpBreadcrumb));
                    fixlist{end+1} = sprintf('ctrl.%s{%d} = %d;',printBreadcrumb(tmpBreadcrumb),j,var{j}(1));
                end
            end
            if(length(var) == 4)
                fprintf('Digital Control Variable is missing the documentation field (index 5) at %s\n',printBreadcrumb(tmpBreadcrumb));
                fixlist{end+1} = sprintf('ctrl.%s{5} = '''';',printBreadcrumb(tmpBreadcrumb));
            end
        
        elseif(iscell(var) && length(var) <= 3)
        % Soft Variable Check
        
            if(length(var) == 1)
                fprintf('Soft Variable is missing the documentation field (index 2) at %s\n',printBreadcrumb(tmpBreadcrumb));
                fixlist{end+1} = sprintf('ctrl.%s{2} = '''';',printBreadcrumb(tmpBreadcrumb));
            end
            
        else
            fprintf('Unrecognized variable type at %s\n',printBreadcrumb(tmpBreadcrumb));
        end
    end
    
    if(~isempty(fixlist) && options.top)
        answer = questdlg('Inconsistencies were found in the control structure. Would you like to correct them?','Correct errors?','Fix Automatically','Fix Interactively','No','Fix Automatically');
        if(isequal(answer,'Fix Automatically'))
            for k = 1:length(fixlist)
                eval(fixlist{k});
            end
        elseif(isequal(answer,'Fix Interactively'))
            [txt, tf] = textEditor(fixlist);
            if(tf)
                for k = 1:length(txt)
                    eval(txt{k});
                end
            end
        end
    elseif(options.debug && options.top)
        fprintf('Consistency check passed.\n');
    end
end
function str = printBreadcrumb(breadcrumb)
    str = '';
    for i = 1:length(breadcrumb)
       str = [str breadcrumb{i} '.'];
    end
    str = str(1:end-1);
end