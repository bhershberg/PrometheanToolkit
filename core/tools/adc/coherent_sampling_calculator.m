%===============================================================================
% coherent_sampling_calculator.m
%-------------------------------------------------------------------------------
% Description:
%	Frequencies calculator for coherent sampling
%	Ref. 
% Inputs:
%	Fclock_desired	Desired sampling frequency
%	Fsignal_desired	Desired input frequency
%	Npoints			Number of data points used in your FFT record
%	Nprecision		Signal generator resolution in decimal places ***after MHz***
%-------------------------------------------------------------------------------
% Changelog:
% Date:			Ver.	Author:		Notes:
% 2016.09.06	1v0		jlagos		Created from Maxim's "Coherent_Sampling_Calculator.xls"
% 2018.09.30    1v1     bhershberg  adjusted Nperiods_signal_coherent to avoid drift when already coherent values are fed into this function
%===============================================================================
function [Fclock_coherent, Fsignal_coherent] = coherent_sampling_calculator(Fclock_desired, Fsignal_desired, Npoints, Nprecision)

	% Calculations assume precision defined w.r.t frequencies in MHZ
	Fclock_desired			= Fclock_desired*1e-6;
	Fsignal_desired			= Fsignal_desired*1e-6;
 
	% Actual calculations
	Fbin_desired			= Fclock_desired/Npoints;													% [MHz] Desired FFT bin width
	Fbin_coherent			= roundn(Fbin_desired,-Nprecision);											% [MHz] Coherent FFT bin width
% 	Twindow_desired			= Npoints/Fclock_desired;													% [us] Desired sampling window
	Fclock_coherent			= roundn(Fbin_coherent*Npoints,-Nprecision);								% [MHz] Coherent sampling frequency
% 	Twindow_coherent		= roundn(Npoints/Fclock_coherent,-Nprecision);								% [us] Coherent sampling window
	Nperiods_signal_desired	= Fsignal_desired/Fclock_coherent*Npoints;									% Number of input cycles in the desired sampling windown (tWINDOW)

    
    % This next line I've slightly modified so that when you feed an
    % already coherent set of frquencies in, it doesn't drift to new
    % values. The only change is a +1 is removed. ~BH May 2018
%     	Nperiods_signal_coherent= 2*floor((floor(Nperiods_signal_desired)+1)/2)+1;
    Nperiods_signal_coherent= 2*floor((floor(Nperiods_signal_desired))/2)+1;							% Number of input cycles in the coherent sampling window
	
    
    Fsignal_coherent		= roundn(Fclock_coherent*Nperiods_signal_coherent/Npoints,-Nprecision);		% [MHz] Coherent input frequency

	% Conversion back to absolute units (Hz)
	Fclock_coherent			= Fclock_coherent*1e6;
	Fsignal_coherent		= Fsignal_coherent*1e6;
	
end