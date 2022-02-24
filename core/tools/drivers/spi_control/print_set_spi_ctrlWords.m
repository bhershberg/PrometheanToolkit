function print_set_spi_ctrlWords(updateSummary,varargin)
% print_set_spi_ctrlWords Print the updateSummary output of set_spi_CtrlWord command.
% command.
% - INPUTS
%   = updateSummary  : output cell array of set_spi_CtrlWord
%(~ OPTIONAL INPUTS)
%   = printUpdate    : if 1 print the update status                         , disabled (0) by default
%   = fmtLenSlave    : used to align slave names in the debug message       , default %-10s, i.e. left aligned 10 char long string
%   = fmtLenCtrlW    : used to align control word names in the debug message, default %-35s, i.e. left aligned 35 char long string
% - OUTPUTS
%   N.A.

%% OPTIONAL INPUTS
ParsedIn = inputParser();

% disable debugging messages by default, activated if optional input are passed 
ParsedIn.addOptional('printUpdate',0);
ParsedIn.addOptional('fmtLenSlave','%-10s');
ParsedIn.addOptional('fmtLenCtrlW','%-35s');

ParsedIn.parse(varargin{:});

printUpdate = ParsedIn.Results.printUpdate;
fmtLenSlave = ParsedIn.Results.fmtLenSlave;
fmtLenCtrlW = ParsedIn.Results.fmtLenCtrlW;

%% DEBUG PRINTING %NM: the idea is to modify this so that plotting happens only if a variable writing had NEVER been sucessful
% if printUpdate
%     fprintf(['%-24s, ',fmtLenSlave,', ',fmtLenCtrlW,', %4s\n'],'update result','slave name','control word','value');
%     for indUpdate=1:size(updateSummary,1)
%         updateRow = updateSummary{indUpdate};
%         fprintf(['%-24s, ',fmtLenSlave,', ',fmtLenCtrlW,', %6d'],...
%             updateRow{1}, ...
%             updateRow{2}, ...
%             updateRow{3}, ...
%             updateRow{4});
%         if startsWith(updateRow{1},'failure','IgnoreCase',1)
%             disp(' <=== WARNING');
%         else
%             disp(' ');
%         end
%     end
% end

if printUpdate
    detector =0; 
%     fprintf(['%-24s, ',fmtLenSlave,', ',fmtLenCtrlW,', %4s\n'],'update result','slave name','control word','value');
    for indUpdate=1:size(updateSummary,1)
        updateRow = updateSummary{indUpdate};
        
        if ~strcmp(updateRow{1}, 'success: CtlrW updated') %if is not a success, see if it was a success anywhere else
            for indUpdate2=1:size(updateSummary,1) %pass again through all
                 updateRow2 = updateSummary{indUpdate2};
                 if strcmp(updateRow2{1}, 'success: CtlrW updated') && strcmp(updateRow2{3}, updateRow{3})
                     detector = detector+1; %accumulate successes
                 end
            end
        if detector == 0
            fprintf(['%-24s, ',fmtLenSlave,', ',fmtLenCtrlW,', %6d'],...
            updateRow{1}, ...
            updateRow{2}, ...
            updateRow{3}, ...
            updateRow{4});
            disp(' <=== WARNING');
        
        end
            detector =0;
        end
    end
end


end