% splits a flatlist into two parts based on a keyword. Every field
% containing the keyword gets put into list1, the rest go into list2
% default implementation for now is a case-insensitive search
function [list1, list2] = split_flatlist(list, keyword)

    list1 = struct;
    list2 = struct;
    names = fieldnames(list);
    
    for i=1:length(names)
        
        if(strfind(lower(names{i}),lower(keyword)))
           eval(['list1.' names{i} ' = list.' names{i} ';']);
        else
            eval(['list2.' names{i} ' = list.' names{i} ';']);
        end
        
    end

end