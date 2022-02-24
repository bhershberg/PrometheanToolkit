%=============================================================================== 
% jlagos__decimation__folding.m
% JLB @ 2016
%-------------------------------------------------------------------------------
% Description:
%	Maps a frequency to its folded alias due to decimation
%-------------------------------------------------------------------------------
% Changelog:
% Date:			Ver.	Author:		Notes:
% 2016.09.04	1v0		jlagos		Created
%-------------------------------------------------------------------------------
% Notes:
%=============================================================================== 
function f_destination = jlagos__decimation__folding(f_source,FNyquist,decimation_factor)

	folding_width		= FNyquist/decimation_factor;	
	folding_zone_index	= fix(f_source/folding_width);
	
	if (rem(folding_zone_index,2)==0)
		% Odd folding zone
		f_destination	= f_source-folding_zone_index*folding_width;
	else
		% Even folding zone
		f_destination	= (folding_zone_index+1)*folding_width-f_source;
	end
	

end