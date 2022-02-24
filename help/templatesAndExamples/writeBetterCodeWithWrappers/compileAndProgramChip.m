function compileAndProgramChip(  )

    %wrapper for your own project-specific function for compiling the
    %settings structure into a NoC vector and sending it to the chip:
    
    global settings;
    if(structFieldPathExists(settings,'settings.export.profiles'))
        programChip();
    else
        % legacy support for HSADC4C-era legacy settings files
        HSADC4C_compileAndProgramNoC;
    end

end