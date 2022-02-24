% Tells if a structure field (or object property) exists.
% Supports multi-level structure or object property paths.
% This is essentially the 'path' version of the built-in isfield() function.
function exitCode = structFieldPathExists(structIn, pathString)

    pathPieces = strsplit(pathString,'.');
    
    path = 'structIn';
    for i = 2:length(pathPieces)
       tmpStruct = eval(path);
       if((isstruct(tmpStruct) && isfield(tmpStruct,pathPieces{i})) ...
               || (isobject(tmpStruct) && min(isprop(tmpStruct,pathPieces{i}))))
            path = [path '.' pathPieces{i}];
       else
           exitCode = 0;
           return;
       end
    end
    
    exitCode = 1;

end