% Benjamin Hershberg, 2020
%
% This is a slight modification of default_plotFunction.m that is
% customized to use the results.sweepValues data from the control 
% variable sweep to scale the x-axis.
%
function example__plot_sweepControlVariable( results, options )

    if(nargin < 2), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',1);
    parser.add('returnDefaults',false);
    parser.add('interactivePlot',false);
    parser.add('variablesToPlot',{'data'});
    parser.add('blackList',{'plotFunction'});
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions;
        defaultOptions = options;
        return;
    end
    if(options.interactivePlot)
        options = askWhatToPlot(results, options);
    end
    
    f = namedFigure('(Example) Control Variable Sweep Output');
    clf;
    hold on;
    for i = 1:length(options.variablesToPlot)
        p = plot(results.sweepValues,results.(options.variablesToPlot{i}));
        p.DisplayName = options.variablesToPlot{i};
    end
    hold off;
    if(length(results.options.parameterPath) > 1)
        andOthers = ' (And Others)';
    else
        andOthers = '';
    end
    title(sprintf('Sweep of %s%s',results.options.parameterPath{1},andOthers));
    xlabel('sweep code value');
    legend;

end
