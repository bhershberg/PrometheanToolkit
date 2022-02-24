% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   [result, tf] = getResult(resultName)
% 
%   + description: get a result from the result manager
%   + inputs:   resultName - the name of the result to fetch
%   + outputs:  result - the requested result, or an empty struct()
%                   if the requested result name was not found.
%               tf - 1 if the result was found, 0 otherwise
%
function [result, tf] = getResult(resultName)

    global settings;
    result = struct;
    tf = 0;

    resultsPath = getGlobalOption('resultsPath');
    
    try
        eval(sprintf('fnames = fieldnames(%s);',resultsPath));
        
        % first try to find the field name:
        for i = 1:length(fnames)
           if(isequal(fnames{i},resultName))
               eval(sprintf('result = %s.%s;',resultsPath,fnames{i}));
               tf = 1;
               return;
           end
        end
        % then look for a resultName field inside the result structure:
        for i = 1:length(fnames)
            if(structFieldPathExists(settings,sprintf('%s.%s.resultName',resultsPath,fnames{i})))
                eval(sprintf('resultNameTmp = %s.%s.resultName;',resultsPath,fnames{i}));
                if(isequal(resultNameTmp,resultName))
                   eval(sprintf('result = %s.%s;',resultsPath,fnames{i}));
                   tf = 1;
                   return;
                end
            end
        end
        
    catch
        warning('Unable to fetch result %s for unkonwn reasons.',resultName);
    end

end