function flatlist = flattenStruct(config, flatlist, prepend)

    if(nargin < 3)
        prepend = '';
    end
    if(nargin < 2)
        flatlist = struct;
    end

    varlist = fieldnames(config);

    for i = 1:size(varlist,1)
        
        varname = varlist{i};
        varvalue = config.(varname);
        
        if(isstruct(varvalue))
            flatlist = flattenStruct(varvalue, flatlist, [prepend varname '_']);
        else
            flatlist.([prepend varname]) = varvalue;
        end
        
    end

end

% the old & much slower method, using calls to eval:

% function flatlist = flattenStruct(config, flatlist, prepend)
% 
%     if(~exist('prepend','var'))
%         prepend = '';
%     end
% 
%     varlist = fieldnames(config);
% 
%     for i = 1:size(varlist,1)
%         
%         varname = varlist{i};
%         varvalue = eval(sprintf('config.%s',varname));
%         
%         if(isstruct(varvalue))
%             flatlist = flattenStruct(varvalue, flatlist, [prepend varname '_']);
%         else
%             eval(sprintf('flatlist.%s%s = varvalue;',prepend, varname));
%         end
%         
%     end
% 
% end