% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Usage:
% 
%   success = deleteControlVariable(pathString, forceDelete);
% 
% REQUIRED INPUTS:
%   pathString:     string - the variable path in the control hierarchy to delete.
% OPTIONAL INPUTS:
%   forceDelete:	true/false - force deletion even if this path is not a variable. Can be used to delete an entire 'folder' of variables in the hierarchy. 
% OUTPUTS:
%   success:        1 if the variable was successfully deleted and 0 otherwise.
function success = deleteControlVariable(pathString, forceDelete)

    global settings;
    
    if(nargin < 2)
        forceDelete = false;
    end
    
    success = 0;

    [absolutePath, tf] = getAbsoluteControlVariablePath(pathString);
    if(~tf && ~forceDelete)
       warning('Invalid variable path requested for deletion. Variable: ''%s''.',pathString);
       return; 
    elseif(forceDelete && ~structFieldPathExists(settings,absolutePath))
        warning('Invalid folder path requested for deletion. Folder: ''%s''.',pathString);
        return;
    end
    
    dots = strfind(absolutePath,'.');
    parentStruct = absolutePath(1:dots(end)-1);
    varName = absolutePath(dots(end)+1:end);
    
    eval(sprintf('%s = rmfield(%s,''%s'');',parentStruct,parentStruct,varName));
    success = 1;

end