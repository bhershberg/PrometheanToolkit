function CB_FM_saveFile(source,event,checkbox_PrependDate,textEdit_Readme, checkbox_useLoadFilePath, filepathTextBox)
    global settings;    
    try 
        
        % attach the readme to the settings structure:
        if(ischar(textEdit_Readme.String))
            readme = {};
            for i = 1:size(textEdit_Readme.String,1)
                readme{i} = deblank(textEdit_Readme.String(i,:));
            end
        elseif(iscell(textEdit_Readme.String))
            readme = textEdit_Readme.String;
        else
            warning('unknown readme format. could not save');
            readme = {};
        end
        settings.readme = readme;
        
        % save to disk:
        if(checkbox_useLoadFilePath.Value)
            pathname = filepathTextBox.String;
        else
            pathname = '';
        end
        filename = 'settings';
        if(checkbox_PrependDate.Value == 1)
            filename = [datestr(datetime,'yyyy-mm-dd__HH-MM-ss____') filename];
        end
        [filename pathname] = uiputfile('*.mat','Save Settings Structure',[pathname filename]);
        if(isnumeric(filename) || isnumeric(pathname)), return;  end
        if(~regexp(filename,'.mat'))
            filename = [filename '.mat'];
        end
        save([pathname filename],'settings');
    catch
       warning('Error saving file. Not saved.'); 
    end
end