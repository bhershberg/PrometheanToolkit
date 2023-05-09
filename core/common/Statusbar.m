%% Statusbar
% Statusbar is a script that takes ii and N to calculate a status bar
% for the for loop. A message can also be provided in variable Statusbarmsg.
% Statusbar can also provide printstatements only when
% statusbartextbit is one.
% 
% Parameters:
%   - ii                : Index over which the for loop loops
%   - N                 : Total number of iterations in the loop
%   - Statusbarmsg      : Message for status bar (optional)
%   - statusbartextbit  : If 1, does not close the status bar
%   - nosound           : If 1, no sound is heard after finishing sweep
% Johan Nguyen - imec (2019)

if ~exist('Statusbarmsg','var')
    Statusbarmsg = 'Waiting...';
end
if ~exist('nosound','var')
    nosound = 0;
end
if ~exist('statusbartextbit','var')
    statusbartextbit = 0;
end

if statusbartextbit
    if ii>1
        elapsedTime = toc;
        fprintf([Statusbarmsg,' ETA ',num2str((N-ii+1)*elapsedTime/60)',...
            'min... [Elaps ',num2str(elapsedTime),...
                'sec, Avg. Elaps ', num2str(iterateTime),'sec]']);
    end
else
    if N == 1
    elseif ii==1
        elapsedTime = 0.0001;
        f = waitbar(1/N,[Statusbarmsg,' ETA ', ...
                num2str((N-ii+1)*elapsedTime/60),...
                'min... [Curr. Elaps ',num2str(elapsedTime),...
                'sec, Avg. Elaps ', num2str(elapsedTime),'sec]']);
    elseif ii==N
        try
            close(f);
        catch
        end
        if nosound == 0
            DoneSound;
        end
    else
        elapsedTime = toc;
        if ~exist('iterateTime','var')
            iterateTime = elapsedTime;
        else
            iterateTime = (iterateTime*(ii-1)+elapsedTime)/ii;
        end
        try
            waitbar(ii/N,f,[Statusbarmsg,' ETA ', ...
                num2str((N-ii+1)*iterateTime/60),...
                'min... [Curr. Elaps ',num2str(elapsedTime),...
                'sec, Avg. Elaps ', num2str(iterateTime),'sec]']);
        catch
        end
    end
end
tic;

if ii == N 
    clear statusbartextbit Statusbarmsg nosound elapsedTime
end