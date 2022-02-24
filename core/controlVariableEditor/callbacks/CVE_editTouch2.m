function CVE_editTouch2(source, event, dataObject, applyButton, cancelButton, textValue, textDescription)
        dataValue = textValue.String;
        if(ischar(dataObject{1}))
            objectValue = dataObject{1};
        else
            objectValue = num2str(dataObject{1});
            dataValue = num2str(str2num(dataValue));
        end
        if((strcmp(dataValue,objectValue)) && strcmp(textDescription.String,dataObject{2}))
            applyButton.Enable = 'off';
            cancelButton.Enable = 'off';
        else
            applyButton.Enable = 'on';
            cancelButton.Enable = 'on';
        end
end
