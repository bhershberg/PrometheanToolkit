function CB_Ag16902B_logicAnalyzerCaptureConnect( source, event, doCapture)

    if(nargin < 3)
        doCapture = 1;
    end

    LA = equipmentInterface(source.Parent.UserData.interfaceName);
    
    if(~doCapture)
        Agilent_16902B_logicAnalyzer_connect(LA);
    else
        capture = Agilent_16902B_logicAnalyzer_capture(LA);
        addResult(capture,'lastCapture');
    end

end

