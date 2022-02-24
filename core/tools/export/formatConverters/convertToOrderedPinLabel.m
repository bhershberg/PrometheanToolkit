function orderedPinString = convertToOrderedPinLabel(NocTable, SearchTerm, ReplaceTerm)
% Author: Benjamin Hershberg
% Date Created: May 2017
% Description: 

    orderedPinString = '';
    i = 1;
    NocTable_length = size(NocTable,1);
    NocTable(end+1,1:3) = {0, 'dummyEntry_padding', NaN};
    NocTable(end+1,1:3) = {0, 'dummyEntry_padding', NaN};
    
    while (i <= NocTable_length)
        
        if(NocTable{i,3} > -1)
            
            % check for contiguous ascending indicies:
            if(strcmp(NocTable{i,2},NocTable{i+1,2}) && (NocTable{i,3} == NocTable{i+1,3}+1))
                indexStart = NocTable{i,3};
                i = i + 1;
                while(strcmp(NocTable{i,2},NocTable{i+1,2}) && (NocTable{i,3} == NocTable{i+1,3}+1))
                    i = i + 1;
                    if(i == NocTable_length)
                        break;
                    end
                end
                indexEnd = NocTable{i,3};
                orderedPinString = [orderedPinString strrep(NocTable{i,2},SearchTerm,ReplaceTerm) '<' num2str(indexStart) ':' num2str(indexEnd) '>,']; 
             % check for contiguous descending indicies:
            elseif(strcmp(NocTable{i,2},NocTable{i+1,2}) && (NocTable{i,3} == NocTable{i+1,3}-1))
                indexStart = NocTable{i,3};
                i = i + 1;
                while(strcmp(NocTable{i,2},NocTable{i+1,2}) && (NocTable{i,3} == NocTable{i+1,3}-1))
                    i = i + 1;
                    if(i == NocTable_length)
                        break;
                    end
                end
                indexEnd = NocTable{i,3};
                orderedPinString = [orderedPinString strrep(NocTable{i,2},SearchTerm,ReplaceTerm) '<' num2str(indexStart) ':' num2str(indexEnd) '>,'];
            % otherwise, it is a lone indicie:
            else
                orderedPinString = [orderedPinString strrep(NocTable{i,2},SearchTerm,ReplaceTerm) '<' num2str(NocTable{i,3}) '>,']; 
%                 warning(['lone index found: ' strrep(NocTable{i,2},'CH0',PrefixReplacement) '<' num2str(NocTable{i,3}) '>,']);
            end
        % if there is no indicie at all:    
        else
            orderedPinString = [orderedPinString strrep(NocTable{i,2},SearchTerm,ReplaceTerm) ','];
        end
        i = i+1;
    end
    orderedPinString = orderedPinString(1:end-1);
end