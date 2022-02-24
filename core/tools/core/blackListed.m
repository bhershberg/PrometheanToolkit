function tf = blackListed(item, blacklist)

    tf = 0;
    for i = 1:length(blacklist)
       if(isequal(item,blacklist{i}))
           tf = 1;
           return;
       end
    end

end