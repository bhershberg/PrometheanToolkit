function CVE_editCancel5(source, event, dataObject, applyButton, copyButton, cancelButton, textValue, textDescription)
    applyButton.Enable = 'off';
    cancelButton.Enable = 'off';
    copyButton.Enable = 'on';
    textValue.String = num2str(dataObject{1});
    textDescription.String = dataObject{5};
end
