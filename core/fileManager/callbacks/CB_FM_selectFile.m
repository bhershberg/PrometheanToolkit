function CB_FM_selectFile(source,event,filepathTextBox)

    [filename, pathname] = uigetfile('*.mat','Select your settings .mat file...',filepathTextBox.String);
    if(isstr(filename) && isstr(pathname))
        filepathTextBox.String = [pathname filename];
        filepathTextBox.UserData.filename = filename;
        filepathTextBox.UserData.pathname = pathname;
        source.Parent.Parent.UserData.filename = filename;
        source.Parent.Parent.UserData.pathname = pathname;
    end

end