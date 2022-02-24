function CB_openFile(source, event, fileName)

    if(~iscell(fileName))
        tmp = fileName;
        fileName = {};
        fileName{1} = tmp;
    end

    for i = length(fileName):-1:1
        try
            open(fileName{i});
        catch
            fprintf('Could not open the file named ''%s''.\n',fileName{i});
        end
    end

end