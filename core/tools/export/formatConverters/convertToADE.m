function convertToADE(flatlist, filename)
% Author: Benjamin Hershberg
% Date Created: May 2017
% Description: 

    pathname = fileparts(filename);
    if(~exist(pathname,'dir'))
        mkdir(pathname);
    end
    fh = fopen(filename, 'w');

    fprintf(fh,'savedComponent = (let\n');
    fprintf(fh,'(');
    varnames = fieldnames(flatlist);
    numfields = length(varnames);
    for i = 1:numfields
        if(i == 1)
            fprintf(fh,'tmp%d',i);
        else
            fprintf(fh,' tmp%d',i);
        end
    end
    fprintf(fh,')\n');
    for i = 1:numfields
        fprintf(fh,'(unless tmp%d\n',i);
        fprintf(fh,'tmp%d = make_sevVariableStruct()\n',i);
        fprintf(fh,')\n');
        fprintf(fh,'(unless tmp%d\n',i);
        fprintf(fh,'tmp%d = (ncons nil)\n',i);
        fprintf(fh,')\n');
        fprintf(fh,'tmp%d->name = "%s"\n',i,varnames{i});
        eval(sprintf('tmpval = flatlist.%s{1};',varnames{i}));
        try
            eval(sprintf('tmpmin = flatlist.%s{3};',varnames{i}));
            eval(sprintf('tmpmax = flatlist.%s{4};',varnames{i}));
            if(tmpval < tmpmin) tmpval = tmpmin; end
            if(tmpval > tmpmax) tmpval = tmpmax; end
        catch 
           % ADE variables might not have strict bounds, so in that case we
           % ignore this check when they're not specified
        end
        if(ischar(tmpval))
            fprintf(fh,'tmp%d->expression = "%s"\n',i,tmpval);
        else
            fprintf(fh,'tmp%d->expression = "%d"\n',i,tmpval);
        end
        fprintf(fh,'tmp%d->index = %d\n',i,i);
    end
    fprintf(fh,'list(');
    for i = 1:numfields
        if(i == 1)
            fprintf(fh,'tmp%d',i);
        else
            fprintf(fh,' tmp%d',i);
        end
    end
    fprintf(fh,')\n');
    fprintf(fh,')\n');

    fclose(fh);

end