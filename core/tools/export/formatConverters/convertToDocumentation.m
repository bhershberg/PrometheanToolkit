% HSADC4C_exportDocumentation(config, filename)
% Benjamin Hershberg, 2018
% imec, Leuven, Belgium
% 
% Prints out the hierarchal config structure for HSADC4C as a CSV formatted 
% documentation tree.

function convertToDocumentation(settings, filename)

    pathname = fileparts(filename);
    if(~exist(pathname,'dir'))
        mkdir(pathname);
    end
    fp = fopen(filename,'w+');

    preamble{1} = ',';

    try
        writeCsvTree(fp,settings,preamble);
    catch
        warning('documentation export has failed');
    end

    fclose(fp);

end

function writeCsvTree(fp, subSettings, preamble)

    fields = fieldnames(subSettings);
    preambleNext = preamble;
    preambleNext{end} = ',';
    preambleNext{end+1} = '|--,';
    for i = 1:length(fields)
        f = fields{i};
        child = getfield(subSettings,f);
        if(iscell(child))
            fprintf(fp,'%s%s,%s\n',preambleToStr(preamble),f,assembleVariableSummary(child));
        else
            fprintf(fp,'%s%s\n',preambleToStr(preamble),f);
            writeCsvTree(fp,child,preambleNext);
        end
    end

end

function str = assembleVariableSummary(var)
    str = '';
    
    if(length(var) >= 4) % standard digital ctrl var format
        if(length(var) < 5)
            var{5} = 'None provided.'; % if no description, add a null one instead
        end
        str = sprintf('Default: %d, Min: %d, Max: %d, Bits: %d, Description: %s',var{1},var{2},var{3},var{4},var{5});
    
    elseif(length(var) <= 2) % standard ADE format
        if(isnumeric(var{1}))
            var{1} = num2str(var{1});
        end
        if(length(var) < 2)
            var{2} = 'None provided.'; % if no description, add a null one instead
        end
        str = sprintf('Default: %s, Description: %s',var{1},var{2});
    
    else
        if(isnumeric(var{1}))
            var{1} = num2str(var{1});
        end
        warning(sprintf('unrecognized variable length of %d, skipping. value{1}=%s',length(var),var{1}));
    end
    
    str = strrep(str,'"','""'); % csv escaping
    str = ['"' str '"'];        % csv escaping
end


function str = preambleToStr(preamble)
    str = '';
    preamble{1} = ''; % remove the extra comma in every line
    for i = 1:length(preamble)
        str = [str preamble{i}];
    end
end