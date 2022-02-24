% How to set up a control variable hierarchy
% Benjamin Hershberg, 2020
% 
% This example shows how to build a control variable hierarchy. The
% relevant functions come from the Control Variable Editor API.
% Specifically, the relevant API functions for working with control 
% variables are:
% 
%     createControlVariable
%     deleteControlVariable
%     getControlVariable
%     setControlVariable
%     listControlVariableRelatives

% To see synatx and usage, just use the built-in 'help' command, e.g.:
help createControlVariable

% Begin with a clean setup, no control variables defined yet:
global settings;
eval(sprintf('%s = struct;', getGlobalOption('controlVariablePath')));

% Set up some 'soft' variables that we want to use only in simulation:
createControlVariable('sim.vdda',0.9,'core analog supply');
createControlVariable('sim.vcm','vdda/2','vcm');
createControlVariable('sim.vref','vdda-100m','vref');
createControlVariable('sim.fin','N_fin_fft_bin/N_fft_periods/T_period','Signal input, coherent w.r.t. Fclk');
createControlVariable('sim.fclk','1G','Master clock frequency');
createControlVariable('sim.N_fin_fft_bin',53,'fft bin that will contain the power of the input sinewave');
createControlVariable('sim.T_period','1/fclk','Master clock period');
createControlVariable('sim.N_fft_periods',128,'fft length');
createControlVariable('sim.T_runtime','T_period*(N_startup_periods+N_fft_periods+1)','total simulation runtime');
createControlVariable('sim.T_startup_periods',40,'extra periods to provide time for intiial startup convergence and settling.');

% Set up some 'hard' digital variables to use both in the lab and simulation:
createControlVariable('digital.TOP.clockBuffer_enable',1,1,0,1,'''0'' disables the clock buffer, ''1'' enables it.');
createControlVariable('digital.TOP.systemReset',1,1,0,1,'''0'' disables the entire system, ''1'' enables it.');
numChannels = 4;
numStages = 6;
for i=1:numChannels
    basePath = sprintf('digital.CH%d.TOP.',i);
    createControlVariable([basePath 'channelEnable'],1,1,0,1,'0 = channel is disabled, 1 = channel is enabled');
    for j = 1:numStages
        basePath = sprintf('digital.CH%d.STG%d.',i,j);
        createControlVariable([basePath 'amplifyDuration'],i+j,6,0,63,'0 = minimum delay, 63 = maximum delay');
        createControlVariable([basePath 'quantizeDuration'],i+j,6,0,63,'0 = minimum delay, 63 = maximum delay');
        createControlVariable([basePath 'ringampBiasControl'],2*i+j,7,0,127,'ringamp bias control used to tune stabilization behavior. 0 = most under-damped, 127=msot over-damped');
    end
end

% Don't worry too much about the values that are set here, they're just
% examples. The main points to notice are the syntax and how you can
% quickly build up a nested hierarchy of variables.

% Refresh the control variable editor tab (you can also just click the
% "Refresh" button provided in that tab).
redrawControlVariableEditorTab;
