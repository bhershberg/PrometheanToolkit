function str = breadcrumbToString(breadcrumb)
    str = '';
    for i = 1:length(breadcrumb)
        str = [str '.' breadcrumb{i}];
    end
    str = str(2:end);
end
