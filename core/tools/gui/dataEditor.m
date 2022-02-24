% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% dataStruct = dataEditor( dataStruct, 'dataStructName', dataEditorOptions );
% 
% 
% DESCRIPTION:
% 
% The Data Editor is a very useful tool that enables the user to directly edit the contents of a structure.
% 
% Notice the "Display All..." button at bottom right of the Data Editor. By default certain data elements like overly long vectors, cell arrays, nested structures, etc will not be displayed. But through this button, you can choose to override that and view everything.
% 
% 
% WORKING EXAMPLE:
% 
% data = getDefaultOptions(@example_userFunction);
% data.anExampleNestedStructure.foo = 'hello';
% data.anExampleNestedStructure.bar = 'world!';
% data.aVeryLongVector = 1:1000;
% options.message = 'You can specify whatever message you want here...';
% data = dataEditor(data, 'data', options);
% 
function [dataStruct, tf] = dataEditor( dataStruct, structName, parserOptions )

    if(nargin < 2), structName = 'options'; end
    if(nargin < 3), parserOptions = struct; end
    parser = structFieldDefaults();
    parser.add('mergeWithOriginal',true);
    parser.add('title','Data Editor');
    parser.add('message','View and edit data structure contents:');
    parser.add('printAll',false);
    parser.add('printSubStructures', false);
    parser.add('lengthLimit',50);
    parser.add('printLongVectors',false);
    parser.add('printCells',false);
    parserOptions = parser.applyDefaults(parserOptions);

    tf = false;

    numRows = 16; numCols = 4;
    
    d = dialog('Name',parserOptions.title);
    p = relativePosition(d,[1 numRows],[1 numCols]);
    d.Position = [0 0 p(3)+20 p(4)+20];
    movegui(d,'center');
    
   	row = 1; col = 1;
    placeText(d,row,[col numCols],parserOptions.message);
    
    row = row + 1;
    boxHeight = numRows - 3;
    p = relativePosition(d,[row row+boxHeight],[col numCols]);
    txtMain = uicontrol('Parent',d,'Style','edit','String','','Units','pixels','Position',p,'HorizontalAlignment','left','Max',10000);
    [~, txtMain.String] = struct2str(dataStruct,structName,parserOptions);
    
    row = numRows-1;
    btnOK = placeButton(d,row, 1, 'OK');
    btnOK.Callback = @CB_optionsEditor_OKbutton;
    
    btnCancel = placeButton(d,row, 2, 'Cancel');
    btnCancel.Callback = @CB_optionsEditor_Cancelbutton;
    
    btnPrintAll = placeButton(d,row, 3, 'Display All...');
    btnPrintAll.Callback = @CB_optionsEditor_displayPreferencesButton;
    
    uiwait(d);
    
    function CB_optionsEditor_OKbutton(source, event)
        try
            structOriginal = dataStruct;
            structNew = struct;
            for i = 1:size(txtMain.String,1)
                if(iscell(txtMain.String))
                    oneLine = txtMain.String{i};
                else
                    oneLine = txtMain.String(i,:);
                end
                oneLine = strtrim(oneLine);
                if(startsWith(oneLine,[structName '.']))
                    oneLine = ['structNew.' oneLine(length(structName)+2:end)];
                end
                eval(oneLine);
            end
            if(parserOptions.mergeWithOriginal)
                dataStruct = mergeStruct(structNew,structOriginal);
            else
                dataStruct = structNew;
            end
            tf = true;
        catch
            msgbox(sprintf('Could not parse options, please check your syntax.\n\nEach line should be in the form: %s.varName = varValue;\nAlso, be careful with apostrophes!',structName));
            return;
        end
        delete(d);
    end

    function CB_optionsEditor_Cancelbutton(source, event)
        delete(d);
    end

    function CB_optionsEditor_displayPreferencesButton(source, event)
        list = {'Long Vectors','Cells','Nested Structures'};
        optEquiv = {'printLongVectors', 'printCells', 'printSubStructures'};
        [choices, tf, values] = checkboxDialog('Also Include:',list,ones(1,length(list)));
        if(~tf), return; end
        for jjj = 1:length(values)
            parserOptions.(optEquiv{jjj}) = values(jjj);
        end
        [~, txtMain.String] = struct2str(dataStruct,structName,parserOptions);
    end
    
end



