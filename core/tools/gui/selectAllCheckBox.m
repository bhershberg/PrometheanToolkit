function selectAllCheckBox(source, event, checkBoxList)
    sum = 0;
    for i = 1:length(checkBoxList)
        sum = sum + checkBoxList{i}.Value;
    end
    if(sum < length(checkBoxList))
        newValue = 1;
    else
        newValue = 0;
    end
    for i = 1:length(checkBoxList)
        checkBoxList{i}.Value = newValue;
    end
end
