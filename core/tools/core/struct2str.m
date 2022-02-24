% handy utility that (sort of) converts a struct to a string that can be
% used to re-make that same struct
%
% currently only supports 1D structs and a limited set of basic variable formats
%
% Benjamin Hershberg 2018
function [charString, cellString] = struct2str(theStruct, structName, options)

    if(nargin < 3), options = struct; end
    parser = structFieldDefaults();
    parser.add('printAll',false);
    parser.add('printSubStructures', false);
    parser.add('lengthLimit',50);
    parser.add('printLongVectors',false);
    parser.add('printCells',false);
    options = parser.applyDefaults(options);

    cellString = {};
    msg = {};
    f = fieldnames(theStruct);
    for i = 1:length(f)
       append = 0;
       subStr = '';
       key = f{i};
       value = theStruct.(key);
       if(isstruct(value))
           if(options.printSubStructures)
                try
                    [~, subStr] = struct2str(value,sprintf('%s.%s',structName,key), options);
    %                 subStr = subStr{1:end-1};
                    append = 1;
                catch
                    msg{end+1} = sprintf('%% Skipped structure ''%s.%s''. Attempted to unwrap this sub-structure, but failed.',structName,key);
                    append = 0;
                end
           else
               msg{end+1} = sprintf('%% Skipped structure ''%s.%s''.',structName,key);
           end
       elseif(ischar(value))
           subStr = sprintf('%s.%s = ''%s'';',structName,key,strrep(value,'''',''''''));
           append = 1;
       elseif(isnumeric(value))
           if(length(value(:)) == 1)
                valStr = chopRoundingError(value);
                subStr = sprintf('%s.%s = %s;',structName,key,valStr);
                append = 1;
           elseif(length(value(:)) < options.lengthLimit || options.printLongVectors)
                subStr = sprintf('%s.%s = [ ',structName,key);
                for x = 1:length(value(:))
                    valStr = chopRoundingError(value(x));
                    subStr = [subStr valStr ' '];
                end
                subStr = sprintf('%s ];',subStr);
                append = 1;
           else
               msg{end+1} = sprintf('%% Skipped vector ''%s.%s'' because it contains %d elements.',structName,key,length(value(:)));
           end
       elseif(islogical(value))
           if(value)
               subStr = sprintf('%s.%s = true;',structName,key);
           else
               subStr = sprintf('%s.%s = false;',structName,key);
           end
           append = 1;
       elseif(iscell(value))
           if(options.printCells)
               subStr = {};
               subStr{end+1} =  sprintf('%s.%s = {}; %% Do not delete this.',structName,key);
               for kk = 1:length(value)
                   if(isnumeric(value{kk}))
                       valStr = chopRoundingError(value{kk});
                       subStr{end+1} =  sprintf('%s.%s{end+1} = %s;',structName,key,valStr);
                   elseif(ischar(value{kk}))
                       subStr{end+1} =  sprintf('%s.%s{end+1} = ''%s'';',structName,key,value{kk});
                   else
                       msg{end+1} =  sprintf('%% Skipped %s.%s{}. Unsupported data type.',structName,key);
                   end
                   append = 1;
               end
           else
                msg{end+1} = sprintf('%% Skipped cell ''%s.%s''.',structName,key);
           end
       else
           msg{end+1} = sprintf('%% Skipped ''%s.%s''. Unsupported format.',structName,key);
       end
       
       if(append)
           if(iscell(subStr))
               for kk = 1:length(subStr)
                    cellString{end+1} = subStr{kk}; 
               end
           else
                cellString{end+1} = subStr;
%                 cellString{end+1} = '';
           end
           cellString{end+1} = '';
       end
       
    end
    
    cellString = cellString(1:end-1);
    
    if(~isempty(msg))
        cellString{end+1} = '';
        for i = 1:length(msg)
            cellString{end+1} = msg{i}; 
        end
    end
    
    charString = '';
    for i = 1:length(cellString)
       charString = [charString cellString{i} '\n']; 
    end
    
end

function str = chopRoundingError(value)

    str = num2str(value);

    %look for rounding error:
    if(length(str) > 5 && ~isequal(str(end),'0'))
        for i = 1:5
            if(~isequal(str(end-i),'0'))
                return;
            end
        end
        str(end) = '0';
    end
    % now remove trailing zeros:
    if(strfind(str,'.')) % make sure we're only working on decimals
        while(isequal(str(end),'0') && length(str) > 1)
            str = str(1:end-1);
        end
    end
    
end