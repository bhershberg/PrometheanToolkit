function sMerged = mergeStruct(sMaster, sSlave)
% recursive merge of two structs. 
% Master always overwrites slave if there is a conflict

    sMerged = sSlave;

    f = fieldnames(sMaster);
    for i = 1:length(f);
        if(isfield(sSlave,f{i}))
            if(isstruct(sSlave.(f{i})) && isstruct(sMaster.(f{i})))
                sMerged.(f{i}) = mergeStruct(sMaster.(f{i}),sSlave.(f{i}));
            else
                sMerged.(f{i}) = sMaster.(f{i});
            end
        else
            sMerged.(f{i}) = sMaster.(f{i});
        end
    end
    
    
end