% =========================================================================
% Example - Export of Control Variables to Veriloga digital control blocks
% =========================================================================
% Benjamin Hershberg, 2020
%
function example__exportToVerilog(options)

    % Setup:
    parser = structFieldDefaults();
    parser.add('returnDefaults',false); % do not remove
    parser.add('debug',true);
    parser.add('libraryPath','./outputs/CADENCE_LIBRARY/');
    parser.add('exportVeriloga',true);
    options = parser.applyDefaults(options);
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end  % do not remove
    
    % An example veriloga block for the "top-level" digital controls:
    verilogaSpec = struct;
    verilogaSpec.name = 'VerilogaBlock_TOP';
    verilogaSpec.parts{1} = {'digital.TOP'; 'D_TOP_'};
    exportSettingsToVeriloga(verilogaSpec, options);
    
    % An example veriloga block for the "channel 1" digital controls:
    verilogaSpec = struct;
    verilogaSpec.name = 'VerilogaBlock_CH1';
    verilogaSpec.parts{1} = {'digital.CH1'; 'D_CH1_'};
    exportSettingsToVeriloga(verilogaSpec, options);

end