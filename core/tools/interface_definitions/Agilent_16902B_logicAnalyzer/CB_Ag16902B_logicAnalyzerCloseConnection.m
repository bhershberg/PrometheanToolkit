function CB_Ag16902B_logicAnalyzerCloseConnection( source, event )

    global settings;
    
    i = source.Parent.UserData.interfaceIndex;
    
    if(~isempty(settings.lab.interfaces{i}.handle))
        try
            settings.lab.interfaces{i}.handle.close();
        catch 
            warning('could not properly close logic analyzer interface');
        end
    end

    settings.lab.interfaces{i}.handle = [];
    
end