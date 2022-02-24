% =========================================================================
% Example - Chip Programmer Template
% =========================================================================
% Benjamin Hershberg, 2020
%
function example__chipProgrammer(options)
    
    % Setup:
    parser = structFieldDefaults();
    parser.add('returnDefaults',false); % do not remove
    parser.add('debug',false); % quiet, because we always program
    parser.add('NocID','none');
    parser.add('sendToChip',true);
    parser.add('exportNoC',true);
    parser.add('saveToFile',false);
    options = parser.applyDefaults(options);
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end  % do not remove
    
    % The way you choose to organize Control Variables in Promethean Toolkit is
    % unconstrained. However, when you wish to program some or all of these
    % variables into a physical digital. there are some conversion steps that
    % you will typically need to consider:
    
    
    % ====== STEP 1: Flatten the control variable hierarchy
    flatenedControlVariables = flattenStruct(getControlHierarchy);
    
    % take a look at what comes out of this:
    flatenedControlVariables
    % The names in this flattened structure replace the 'dot' notation of
    % the hierarchical structure in Matlab with an 'underscore' notation
    % that is compatible with Cadence. If you're smart and plan ahead, you
    % will already have used these variable names in Cadence too, so the
    % mapping job that comes next will be easy!
    
    
    
    % ====== STEP 2: Map the individual bits of the flattened Control Variable
    % structure onto the bits of your on-digital.register system. This is very
    % project specific, so you'll need to figure this out for yourself.
    % However, if you want to see an example, take a look at the example of
    % how to do this in the commented-out code at the bottom of this file.
    
    % < your functions / code to map the control variables into the 
    % ordering and format that your digital.programmer needs, goes here>
    
    
    
    % ====== STEP 3: Send your re-mapped data out ot your digital.programmer
    % function, e.g. your SPI function.
    
    % < your spi or digital.programmer function here >
    fprintf('(Fake) programming chip....Done!\n'); % just an example to let you try out the Execution Manager
    

end


% =========================================================================
% Example - Converting from Promethean Toolkit to a shift-register vector
% =========================================================================
function example_FullChipProgrammerExportWithRemapping()

    nocSpec = struct;
    nocSpec.exportPath = fullfile(fileparts(mfilename('fullpath')), 'outputs');
    nocSpec.name = 'Noc_Vector';

    % Translate between the hierarchical 'dot' naming convention in Promethean Toolkit
    % to the 'underscore' naming convention we used in Cadence/ADE:
    nocSpec.parts = {};
    nocSpec.parts{end+1} = {'digital.CH1','D_CH1_'}; 
    nocSpec.parts{end+1} = {'digital.CH2','D_CH1_'};
    nocSpec.parts{end+1} = {'digital.CH3','D_CH1_'};
    nocSpec.parts{end+1} = {'digital.CH4','D_CH1_'};
    nocSpec.parts{end+1} = {'digital.TOP','D_TOP_'};

    % Point to the mapping files that specify what order the bits are in the
    % physical digital. block by block of the shift register chain:
    nocSpec.mappingsPath = fullfile(fileparts(mfilename('fullpath')), 'nocMappings/HSADC4E/');
    nocSpec.mappings{1} = {'NocMapping_type1_TOP_Buffers.mat','',''};
    nocSpec.mappings{2} = {'NocMapping_type1_CHANNEL.mat','CH1','CH1'};
    nocSpec.mappings{3} = {'NocMapping_type1_CHANNEL.mat','CH2','CH2'};
    nocSpec.mappings{4} = {'NocMapping_type1_TOP_controller.mat','',''};
    nocSpec.mappings{5} = {'NocMapping_type1_CHANNEL.mat','CH3','CH3'};
    nocSpec.mappings{6} = {'NocMapping_type1_CHANNEL.mat','CH4','CH4'};

    % Specify the physical ordering of the shift register blocks specified in
    % the mappings above, as they are actually connected on the physical digital.
    nocSpec.assemblyOrder = [1 2 3 4 5 6];

    % Let the exporter tool translate from Promethean Toolkit data into an ordered
    % bitst
    outputs = exportSettingsToNoC(nocSpec, options);

    % Function for actually programming the NoC:
    if(options.sendToChip)
        HSADC4E_type1_programNoC(outputs.Noc_Vector,options.NocID);
    end
end


% =========================================================================
% Example - Converting from Promethean Toolkit to a ordered pin listing for LVS
% verification of digital blocks in Cadence.
% =========================================================================
function example_generatingOrderedPinLabelsForLVS()

    pinLabelSpec = struct;
    pinLabelSpec.exportPath = fullfile(options.exportRootPath);
    pinLabelSpec.name = 'orderedPinLabels_type1';
    pinLabelSpec.mappingsPath = fullfile(fileparts(mfilename('fullpath')), 'nocMappings/HSADC4E/');
    pinLabelSpec.mappings = {};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_CHANNEL.mat','CH0','CH0'};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_CHANNEL.mat','CH0','CH1'};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_CHANNEL.mat','CH0','CH2'};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_CHANNEL.mat','CH0','CH3'};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_TOP_Buffers.mat','',''};
    pinLabelSpec.mappings{end+1} = {'NocMapping_type1_TOP_controller.mat','',''};
    exportSettingsToOrderedPinLabel(settings, pinLabelSpec, options);
    
end