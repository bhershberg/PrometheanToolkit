% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   saveSystemState;
% 
%   + description: takes a snapshot of the current system state and stores
%                   it in the Results Manager, where the state data can be
%                   restored at a later point in time.
%   + inputs:   none.
%   + outputs:  results structure containing the system state data.
%
function results = saveSystemState(dummy1, dummy2)

    results = struct;
    results = addStateDataToResult(results);
    results.notes = {};
    results.notes{end+1} = '** System state snapshot. **';
    results.notes{end+1} = '';
    results.notes{end+1} = sprintf('Saved on %s.',datetime);
    results.notes{end+1} = '';
    results.notes{end+1} = 'To restore a part or all of this saved system state, select the relevant stateData fields from the Result Fields list below and click the "Restore Selected State Data(s)" button to overwrite the current system state with this data.';
    
    resultName = sprintf('Saved System State   %s',datestr(now,'yyyy-mm-dd HH:MM:SS'));
    
    addResult(results,resultName);
    
    refreshResultsManagerTab;

end