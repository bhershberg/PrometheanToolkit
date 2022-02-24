function tf = Agilent_16902B_logicAnalyzer_connect( interfaceObject )

    LA = interfaceObject;
    
    try 
        LogicAnalyzerHandle = logicAnalyzer_Ag16902B(LA.getProperty('configuration_file'),LA.getProperty('bus_width'));
        LogicAnalyzerHandle.IP = LA.getProperty('own_ip_address');
        LogicAnalyzerHandle.open();
        LA.setProperty('handle',LogicAnalyzerHandle);
        tf = 1;
    catch
        warning('could not open logic analyzer interface.');
        tf = 0;
    end
    

end