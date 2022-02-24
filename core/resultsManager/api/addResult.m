% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   tf = addResult(result, resultName);
% 
%   + description: store something into the results manager.
%   + inputs:   result - the results data that you wish to save
%               resultName - the name that this data will appear as in
%               the results manager.
%   + outputs:  tf - 1 if the result was successfully added, 0 otherwise
%
function tf = addResult(result, resultName)

    global settings;

    if(~ischar(resultName))
        tf = 0;
        warning('Result name must be a char array. Could not save');
        return; 
    end
    
    resultsPath = getGlobalOption('resultsPath','settings.lab.results');
    
    if(isstruct(result))
        result.resultName = resultName;
        if(~isfield(result,'timestampCreated')) % if exists, this is just a renaming
            result.timestampCreated = now();
            result.dateCreated = sprintf('%s',datetime);
        end
    end
    
    if(isvarname(resultName))
        fieldName = resultName;
    else
        for i = 1:length(resultName)
            if(~isvarname(resultName(1:i)))
                if(i == 1)
                    prefix = 'result_';
                else
                    prefix = resultName(1:i-1);
                end
                break;
            end
        end
        id = DataHash(resultName);
        maxPrefixLength = namelengthmax - length(id) - 1;
        prefixTrunc = min(length(prefix),maxPrefixLength);
        prefix = prefix(1:prefixTrunc);
        fieldName = sprintf('%s_%s',prefix,id);
    end
    
    eval(sprintf('%s.%s = result;',resultsPath,fieldName));

end