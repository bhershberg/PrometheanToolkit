function [supplyName, supplyId] = example__getCoreSupply()

    % Is the core supply something we can determine from the interfaces
    % themselves?:
    iGroup = equipmentInterfaceGroup();
    iGroup.addAllWithProperty('is_core_supply',1);
    [supplyName, supplyId] = iGroup.listInterfaces;
    if(length(supplyName) == 1)
        supplyName = supplyName{1};
        supplyId = supplyId{1};
        setGlobalOption('coreSupply',supplyName);
        return;
    end

    % Or is the core supply already registered in the global options?:
    if(~isempty(getGlobalOption('coreSupply')))
        supplyName = getGlobalOption('coreSupply');
        supplyId = getInterfaceByName(supplyName);
        return;
    end

    % Otherwise, we'll need to ask the user:
    [name, id] = selectInterface('Please specify the core supply:');
    supplyName = getInterfaceName(id{1});
    setGlobalOption('coreSupply',supplyName);

end