% This function is a part of the Results Manager API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   updatedResult = addStateDataToResult(result);
% 
%   + description: attach to a result all data required to fully 
%                   reconstruct the current system state. Can be used
%                   inside the results manager.
%   + inputs:   results - the result structure to attach the state information to
%               runtimeOptions - optional parameter, attaches to
%                   results.options. Can be useful for also attaching the
%                   runtime options of the function that control its
%                   execution flow (also needed to fully reconstruct the
%                   conditions of an experiment).
%   + outputs:  updatedResult - the modified result with added information
%
function results = addStateDataToResult(results, runtimeOptions)

    results.stateData_controlVariables = getControlState;
    results.stateData_equipmentInterfaces = getEquipmentState;
    results.stateData_executionManager = getExportState;
    results.stateData_globalOptions = getGlobalOptionsState;
    
    if(nargin > 1)
        results.options = runtimeOptions;
    end

end