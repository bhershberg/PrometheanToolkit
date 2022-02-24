function nameAllFigures()

    figHandles = findobj('Type', 'figure');
    for i = 1:length(figHandles)
        h = figHandles(i);
        if(isempty(h.Name))
            h.Name = sprintf('Figure %d',h.Number);
        end
    end

end