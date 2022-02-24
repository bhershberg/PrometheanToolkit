function CVE_editCancel2(source, event, dataObject, applyButton, cancelButton, textValue, textDescription)
    applyButton.Enable = 'off';
    cancelButton.Enable = 'off';
    if(ischar(dataObject{1}))
        objectValue = dataObject{1};
    else
        objectValue = num2str(dataObject{1});
    end
    textValue.String = objectValue;
    textDescription.String = dataObject{2};
end
