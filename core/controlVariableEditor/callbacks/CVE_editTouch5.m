function CVE_editTouch5(source, event, dataObject, applyButton, copyButton, cancelButton, textValue, textDescription)

        [dataValue, success] = str2num(textValue.String);
        if(~success)
            dataValue = dataObject{1};
        end
        dataValue = floor(dataValue); % digital settings --> allow integers only
        if(dataValue <= dataObject{3}) 
            dataValue = dataObject{3};
        elseif(dataValue >= dataObject{4}) 
            dataValue = dataObject{4};
        end
        textValue.String = num2str(dataValue);
        
        if((dataValue == dataObject{1}) && strcmp(textDescription.String,dataObject{5}))
            applyButton.Enable = 'off';
            cancelButton.Enable = 'off';
            copyButton.Enable = 'on';
        else
            applyButton.Enable = 'on';
            cancelButton.Enable = 'on';
            copyButton.Enable = 'off';
        end

end
