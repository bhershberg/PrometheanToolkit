function options = getDefaultOptions(functionHandle, options)

    global defaultOptions;
    defaultOptions = struct;
    options.returnDefaults = true;
    
    % determine if we're trying to execute a function or a script:
    try
        nargs = nargin(functionHandle);
        isFunction = true;
    catch 
        isFunction = false;
    end
    
    if(isFunction)
        functionHandle(options);
    else
        functionHandle();
    end
    if(isfield(defaultOptions,'returnDefaults'))
        options = rmfield(defaultOptions,'returnDefaults');
    end

end