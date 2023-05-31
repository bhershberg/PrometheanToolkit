function CVE_displayDataObject(dataObject, breadcrumb, parentPanel, parentMenu)
    
    col_a = [1 1.5];
    col_b = [1.5 3.4];
    col_c = [1.5 4];
    col_d = [3.5 4];
    col_e = [4.5 5.5];
    col_ef = [4.5 6.5];
    col_f = [5.5 6.5];
    
    textOptions.HorizontalAlignment = 'right';
    
    pathString = getRelativeControlVariablePath(breadcrumbToString(breadcrumb));
    
    button_copyTo = [];
    
    % determine what type of variable:
    if(iscell(dataObject) && length(dataObject) >= 5)
        varType = 'Digital Control Variable';
    elseif(iscell(dataObject) && length(dataObject) <= 3)
        varType = 'Soft Variable';
    else
        varType = 'Unknown';
    end
    
% ==== Draw the Main Variable Interface: ==================================
    
    % Digital Control Variable:
    if(isequal(varType,'Digital Control Variable'))
    
        row = 1;
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Value:',textOptions);
        text_dataValue2 = placeEdit(parentPanel,row,col_b,num2str(dataObject{1}));
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Bit Width:',textOptions);
        placeText(parentPanel,row,col_b,num2str(dataObject{2}));

        row = row + 1;
        placeText(parentPanel,row,col_a,'Min Value:',textOptions);
        placeText(parentPanel,row,col_b,num2str(dataObject{3}));   
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Max Value:',textOptions);
        placeText(parentPanel,row,col_b,num2str(dataObject{4}));    
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Type:',textOptions);
        placeText(parentPanel,row,col_b,'Digital Control Variable');   
        
        if(length(dataObject) < 5)
            dataObject{5} = '';
        end
        row = row + 1;
        placeText(parentPanel,row,col_a,'Description:',textOptions);
        text_dataDescription2 = placeEdit(parentPanel,[row row + 5],col_c,num2str(dataObject{5}));
        text_dataDescription2.Max = 100;  
        
        row = row + 5;
        placeText(parentPanel,row,col_a,'Path:',textOptions);
        placeEdit(parentPanel,row,col_b,pathString);  
   
        row = 1;
        
        row = row + 1;
        button_applyChanges = placeButton(parentPanel,row,col_d,'Apply');
        button_applyChanges.Enable = 'off';
        
        row = row + 1;
        button_cancelChanges = placeButton(parentPanel,row,col_d,'Cancel');
        button_cancelChanges.Enable = 'off';
        
    % ADE variable:
    elseif(isequal(varType,'Soft Variable'))

        row = 1;
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Value:',textOptions);
        text_dataValue2 = placeEdit(parentPanel,row,col_b,num2str(dataObject{1}));
        
        row = row + 1;
        placeText(parentPanel,row,col_a,'Type:',textOptions);
        placeText(parentPanel,row,col_b,'Soft Variable');
        
        if(length(dataObject) < 2)
            dataObject{2} = '';
        end
        row = row + 2;
        placeText(parentPanel,row,col_a,'Description:',textOptions);
        text_dataDescription2 = placeEdit(parentPanel,[row row + 5],col_c,num2str(dataObject{2}));
        text_dataDescription2.Max = 100;
        
        row = row + 5;
        placeText(parentPanel,row,col_a,'Path:',textOptions);
        placeEdit(parentPanel,row,col_b,pathString);  
        
        row = 1;
        
        row = row + 1;
        button_applyChanges = placeButton(parentPanel,row,col_d,'Apply');
        button_applyChanges.Enable = 'off';
        
        row = row + 1;
        button_cancelChanges = placeButton(parentPanel,row,col_d,'Cancel');
        button_cancelChanges.Enable = 'off';

    % Unsupported:
    else
          placeText(parentPanel,2,1,'Data format: unsupported.');
          return;
    end
    
% ==== Draw the Hierarchy Tool: ==================================
    
    [~, relatives] = listControlVariableRelatives(breadcrumb);
    relativesLvl1 = relatives.parent;
    relativesLvl2 = relatives.grandparent;

    if(length(relativesLvl1) > 1 || length(relativesLvl2) > 1)

        row = 2;
        boldTextOptions.FontWeight = 'bold';
        placeText(parentPanel,row,col_ef,'Controls with the same name detected in the hierarchy:',boldTextOptions);

        row = 3;
        txtLvl2 = placeText(parentPanel,row,col_e,'Grandparents:');

        span = 6; % height of the listboxes

        row = row + 1;
        idxSelect = [];
        for i = 1:length(relativesLvl2)
            if(isequal(relativesLvl2{i},breadcrumb{end-2}))
                idxSelect = i;
            end
        end
        lvl2_listbox = placeListbox(parentPanel,[row row+span],col_e, relativesLvl2, idxSelect);
        row = row + span;
        button_selectAllLvl2 = placeButton(parentPanel,row,col_e,'Select All',{@selectAllListBox,lvl2_listbox});
        row_a = row;
        
        if(isempty(relativesLvl2))
            txtLvl2.Enable = 'off';
            lvl2_listbox.Enable = 'off';
            button_selectAllLvl2.Enable = 'off';
        end

        row = 3; 
        placeText(parentPanel,row,col_f,'Parents:');

        row = row + 1;
        idxSelect = [];
        for i = 1:length(relativesLvl1)
            if(isequal(relativesLvl1{i},breadcrumb{end-1}))
                idxSelect = i;
            end
        end
        lvl1_listbox = placeListbox(parentPanel,[row row+span],col_f, relativesLvl1, idxSelect);
        row = row + span;
        button_selectAllLvl1 = placeButton(parentPanel,row,col_f,'Select All',{@selectAllListBox,lvl1_listbox});
        row_b = row;

        row = max(row_a,row_b)+1.5;
        button_copyTo = placeButton(parentPanel,row,col_ef,'Copy This Control to All Selected');
        button_copyTo.Callback = {@CVE_copyToSelected, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox};
        button_copyTo.Enable = 'on';

        row = row + 1;
        button_printValuesSelected = placeButton(parentPanel,row,col_ef,'Print Values of All Selected');
        button_printValuesSelected.Callback = {@CVE_printSelected, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox};
        button_printValuesSelected.Enable = 'on';

        row = row + 1;
        button_printPathsSelected = placeButton(parentPanel,row,col_ef,'Print Control Paths of All Selected');
        button_printPathsSelected.Callback = {@CVE_printPathsSelected, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox};
        button_printPathsSelected.Enable = 'on';
        
        row = row + 1;
        button_sweepRegisterValue = placeButton(parentPanel,row,col_ef,'Sweep Register Values');
        button_sweepRegisterValue.Callback = {@CVE_sweepRegister, dataObject, breadcrumb, lvl2_listbox, lvl1_listbox};
        button_sweepRegisterValue.Enable = 'on';
    end
    
% ==== Callback setup and finishing touches: ==============================

    if(isequal(varType,'Digital Control Variable'))
        % things to do last:
        text_dataValue2.Callback = {@CVE_editTouch5, dataObject, button_applyChanges, button_copyTo, button_cancelChanges, text_dataValue2, text_dataDescription2};
        text_dataDescription2.Callback = {@CVE_editTouch5, dataObject, button_applyChanges, button_copyTo, button_cancelChanges, text_dataValue2, text_dataDescription2};
        button_cancelChanges.Callback = {@CVE_editCancel5,dataObject, button_applyChanges, button_copyTo, button_cancelChanges, text_dataValue2, text_dataDescription2};
        button_applyChanges.Callback = {@CVE_apply5, dataObject, breadcrumb, parentPanel, parentMenu, text_dataValue2, text_dataDescription2};
    elseif(isequal(varType,'Soft Variable'))
        % things to do last:
        text_dataValue2.Callback = {@CVE_editTouch2, dataObject, button_applyChanges, button_cancelChanges, text_dataValue2, text_dataDescription2};
        text_dataDescription2.Callback = {@CVE_editTouch2, dataObject, button_applyChanges, button_cancelChanges, text_dataValue2, text_dataDescription2};
        button_cancelChanges.Callback = {@CVE_editCancel2,dataObject, button_applyChanges, button_cancelChanges, text_dataValue2, text_dataDescription2};
        button_applyChanges.Callback = {@CVE_apply2, dataObject, breadcrumb, parentPanel, parentMenu, text_dataValue2, text_dataDescription2};
    end
    
end

