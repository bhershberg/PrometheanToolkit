% Benjamin Hershberg, 2020
%
function default_plotFunction( results, options )

    if(nargin < 2), options = struct; end
    parser = structFieldDefaults();
    parser.add('debug',1);
    parser.add('returnDefaults',false);
    parser.add('interactivePlot',false);
    parser.add('variablesToPlot',{});
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
    
    f = namedFigure('Default Plot Function Output');
    clf;
    hold on;
    for i = 1:length(options.variablesToPlot)
        p = plot(results.(options.variablesToPlot{i}));
        p.DisplayName = options.variablesToPlot{i};
    end
    hold off;
    legend;

end
