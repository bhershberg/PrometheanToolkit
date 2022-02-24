function capture = Agilent_16902B_logicAnalyzer_capture( interfaceObject )

    LA = interfaceObject;
    capture = [];
    
    if(isempty(LA.getProperty('handle')) || ~isvalid(LA.getProperty('handle')))
        Agilent_16902B_logicAnalyzer_connect(LA);
    end

    try
        LogicAnalyzerHandle = LA.getProperty('handle');
        capture = LogicAnalyzerHandle.measure();
    catch
        warning('could not capture data with logic analyzer interface.');
    end

end