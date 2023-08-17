function DoneSound
%% DoneSound
% Play a sound when script finishes. This script allows the user to
% continue with other tasks. As soon as a big sweep is finished, the
% user will be notified with a sound!
% Johan Nguyen - imec (2019)
olddir = pwd;
CdCodeDir;
    try
        addpath(genpath('./Auxiliary'));
        path_name = './Auxiliary/DoneSounds/';
        lst = ls(path_name);
        lst = lst(3:end,:);
        filenr = randi(size(lst,1),1);
        % Choose random file
        [doneaudio,Fs_sound] = audioread([path_name,lst(filenr,:)]);
        doneaudio = doneaudio/std(doneaudio);
        playerObj = audioplayer(doneaudio,Fs_sound);
        start = playerObj.SampleRate * 4;
        play(playerObj,start);
    catch
        warning('Problem with making sound! Verify path to sounds!')
        load handel.mat;
        y = y/std(y);
        playerObj = audioplayer(y,Fs);
        start = playerObj.SampleRate * 4;
        play(playerObj,start);
    end
    while( strcmp(playerObj.Running,'on'))
        pause(0.1);
    end
cd(olddir);
end