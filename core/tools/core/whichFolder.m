function folderpath = whichFolder(filename)

    if(ispc)
        needle = '\';
    else
        needle = '/';
    end
    
    fullpath = which(filename);
    idx = strfind(fullpath,needle);
    folderpath = fullpath(1:idx(end));

end