function [fH,aH] = bus_plot(busIN,varargin)
%BUS_PLOT Plot a digital bus coming form Logic Analyzer.
% busIN is a matrix with a number of rows equal to the number of acquired
% points and a number of columns equal to the bits. Each row is plotted
% versus samples number (or time, if provided in t vector).
%
% The first column of busIN is plotted at the bottom of the figure; the
% following column and then plotted above of it, i.e. :
% 
% busIN(:,end)  101 ...
%      ...
% busIN(:,  3)  110 ...
% busIN(:,  2)  010 ...
% busIN(:,  1)  001 ...
%
% Inputs:
% * busIN: matrix with #acquired points rows and #bit columns
%
% Optional inputs:
% * t      : time axis, if not given bus are plotted versus sample
%               -> default value: NaN
%               -> allowed values: vector of float representing time in s
% * BUSname: waveform names cell array, contains as many string name as the
%            number of columns of busIN. If not provided, the bit are
%            labeled as D00, D01, ecc..
%               -> default value: NaN
%               -> allowed values: cell array containing as many string as
%                  busIN columns
% * BUSnmPs: position of the BUSname
%               -> default value: is 'L', i.e. left, but like this it
%                  might overlap with y labels, if they are used
%               -> allowed values: 'L' (left) or 'R' (right)
% * figSize: figure size vector as in standard plot command,
%            specified in points
%               -> default value: NaN
%               -> allowed values: float vector [left bottom width height]
% * yLabels: if 1, print '0' and 'VDD' y labels for each wave; by default
%            these are not printed
%               -> default value: is 0, i.e. y labels not printed
%               -> allowed values: 0 or 1 (i.e. print y labels)
%
% Outputs:
% * fH     : figure handle
% * aH     : axis handle
%
% Examples:
%
% 1) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done]);
% Settings:
% - Plot matrix B1 then B2 and then Done. The waveform order will be:
%   B1(3) (bottom), B1(2), B1(1), B2(2), B2(1), Done (top)
% - Print default waveforms names, i.e. D0, D1, ... D5
% - Plot waveforms versus sample on the x-axis
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 2) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done],'t',t);
% Settings: 
% - Plot waveforms versus time on the x-axis
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 3) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done],'t',t,...
%                       'BUSname',{'B1<0>';'B1<1>';'B1<2>';'B2<0>';'B2<1>';'Done'});
% Settings: 
% - add waveforms custom name
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 4) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done],'t',t,...
%                       'BUSnmPs','R');
% Settings: 
% - Print default waveforms names to the right
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 5) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done],'figSize',[30 60 600 600]);
% Settings: 
% - Change figure size
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=
%
% 6) [fH,aH] = bus_plot([B1(:,3:-1:1) B2(:,2:-1:1) Done],'yLabels',1);
% Settings: 
% - print '0' and 'VDD' y labels for each waveform
% ~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=~~~=

% Author: Davide Dermit
% Confidential and Copyright Protected
%
% Version history:
% 2018/05/18    v1.0    first release
% 2018/05/22    v1.1    cleaned code, added BUSnmPs and yLabels

InPars = inputParser();

% set default if propery are not passed as input arguments
InPars.addOptional('t'      ,NaN); % no time axis by default
InPars.addOptional('busName',NaN); % D00 D01 ecc are default waveform names
InPars.addOptional('busNmPs','L'); % print BUSname on the left by default
InPars.addOptional('figSize',NaN); % default figure size
InPars.addOptional('yLabels',  0); % do not print yLabels by default

InPars.parse(varargin{:});
FuncArg = InPars.Results;

if isnan(FuncArg.t)
    % if t is not provided, then x axis are samples
    xAX  = 1:size(busIN,1);
    xAxLbl = 'samples';
else
    % if t is provided    , then x axis are seconds
    xAX = FuncArg.t;
    xAxLbl = 't (s)';
end

if iscell(FuncArg.busName)
    % if bits name are provided they are used
    busName = FuncArg.busName;
else
    % otherwise bits are called D00, D01, ...
    % the number of digits are chosen according to how many tens there are
    % in the bits number
    fmtString = ['%0',num2str(floor(log10(size(busIN,2)))+1,'%d'),'d'];
    busName = cell(1,size(busIN,2));
    for ind=1:size(busIN,2)
        busName{ind} = ['D',sprintf(fmtString,ind-1)];
    end
end

if strcmp(FuncArg.busNmPs,'R')
    busNmPs = 'R';
else
    busNmPs = 'L';
end

if unique(isnan(FuncArg.figSize))
    % if figSize is not provided, then it is set to NaN
    figSize = NaN;
else
    % if figSize is     provided, then it is kept
    figSize = FuncArg.figSize;
end

if FuncArg.yLabels
    % cell array with '0' 'VDD' Y ticks label
    YTickLbl = repmat({'0';'VDD'},size(busIN,2),1);
    yAXlabel = 1;
else
    % cell array with empty Y ticks label (default)
    YTickLbl = repmat({'';''},size(busIN,2),1);
    yAXlabel = 0;
end
% add one extra at the end to create some space
YTickLbl{end+1} = '';

clear FuncArg;

if isnan(figSize)
    fH = figure;
else
    fH = figure('pos',figSize); 
end

hold on;
aH = gca;
for ind=1:size(busIN,2)
    % plot each bits on top of the previous one
    plot(xAX,busIN(:,ind)+(ind-1)*2,'LineWidth',2,'Color',[0 0 1]);
end

XTick = get(aH,'XTick');

for ind=1:size(busIN,2)
    % plot each bit name near the corresponding plot and outside the plot
    % area
    if ~strcmp(busNmPs,'R')
        % on the left (by default)
        text(XTick(1),(ind-1)*2+0.5,busName{ind}  ,'VerticalAlignment','middle','HorizontalAlignment','right','Color',[0 0 1],'FontWeight','bold','BackGround',[1 1 1]);
    else
        % on the right
        text(XTick(end),(ind-1)*2+0.5,busName{ind},'VerticalAlignment','middle','HorizontalAlignment','left' ,'Color',[0 0 1],'FontWeight','bold','BackGround',[1 1 1]);
    end
end

% create Y ticks 
YTick = 0:size(busIN,2)*2;
% set the Y limits
set(gca,'YLim',[YTick(1) YTick(end)],'YTick',YTick,'YTickLabel',YTickLbl);
% add y axis label if y ticks labels are printed
if yAXlabel
    ylabel('(V)');
end
% add x axis label
xlabel(xAxLbl);
% turn grid on
grid on;

end