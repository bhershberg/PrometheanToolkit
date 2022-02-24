function selectAllListBox(source, event, listBox)

    if(length(listBox.Value) == length(listBox.String))
        listBox.Value = [];
    else
        listBox.Value = 1:length(listBox.String);
    end
    
end
