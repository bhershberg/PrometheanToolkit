function tf = Agilent_16902B_logicAnalyzer_connect( interfaceObject )
global LogicAnalyzerHandle;
global settings;
LA = interfaceObject;

try
    LAdriver = 'Adam';
    switch LAdriver
        case 'Ben'
            LogicAnalyzerHandle = logicAnalyzer_Ag16902B(LA.getProperty('configuration_file'),LA.getProperty('bus_width'));
            LogicAnalyzerHandle.IP = LA.getProperty('own_ip_address');
            LogicAnalyzerHandle.open();
            
        case 'Adam'
            tmp = settings.lab.interfaces{getLogicAnalyzerIndex};
            LogicAnalyzerHandle = ksla("configuration_file_name",tmp.configuration_file);
            LogicAnalyzerHandle.signal_name = "hsadc6a";
    end
    LA.setProperty('handle',LogicAnalyzerHandle);
    tf = 1;
catch
    warning('could not open logic analyzer interface.');
    tf = 0;
end


end