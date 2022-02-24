function applyAllInterfaces( )

        global settings;
        global tabEquipmentControl;
        
        interfaceTab = getInterfaceTabHandle;
        
        if(structFieldPathExists(settings,'settings.lab.interfaces') && length(settings.lab.interfaces) > 1)

            h = waitbar(0,'Applying All Interfaces...');
            for i = 1:length(settings.lab.interfaces)
                if(isgraphics(h))
                    h = waitbar((i-1)/length(settings.lab.interfaces),...
                        h, sprintf('Applying %s...',settings.lab.interfaces{i}.name));
                end
                try
                    interfacePanel = interfaceTab.UserData.childrenProfiles{i};
                    index = interfacePanel.UserData.interfaceIndex;

                    % execute the interface's pre-defined 'apply' function:
                    interfaceType = settings.lab.interfaces{index}.type;
                    [~,interfaceApplyFunction] = tabEquipmentControl.UserData.interfaceDefinitions.get(interfaceType);
                    interfaceApplyFunction(interfacePanel);
                catch
                    warning('Attempt to access interface at index %d failed.',i); 
                end
            end
            if(isgraphics(h))
                delete(h);
            end
        end

end


