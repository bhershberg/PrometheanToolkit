function vector = convertToNocBits(orderedPinList, stateFlatlist, searchTerm, replaceTerm)

    % column 2 of the ordered pin list is assumed to be the bit name
    % column 3 of the ordered pin list is assumed to be the bit offset
    
    % This function iterates through each pin in the pin list and looks 
    % up its state value in the state flatlist and uses that to assemble
    % the state vector.
    
    for i = 1:size(orderedPinList,1)
        
        bitName = strrep(orderedPinList{i,2},searchTerm,replaceTerm);
        bitOffset = orderedPinList{i,3};
        
        if(isnan(bitOffset))
            bitOffset = 0;
        end
        
        variableState = getfield(stateFlatlist,bitName);
        variableValue = variableState{1};
        
        bitValue = bitand(variableValue, 2^bitOffset);
        
        if(bitValue)
            vector(i) = 1;
        else
            vector(i) = 0;
        end
            
        
    end
    
end