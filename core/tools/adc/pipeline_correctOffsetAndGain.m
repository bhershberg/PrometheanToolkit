function data = pipeline_correctOffsetAndGain(data, channel_id)
% 'data' is the reconstructed, numeric data that will go into .e.g. an FFT
% 'channel_id' identifies what channel each data element is from

%     IMPORTANT: for best performance, we must calculate only on the data
%     that will be used in the fft:
    if(exist('getFftSize','file'))
        truncateLength = getFftSize;
    else
        truncateLength = size(data,1);
    end
    data = data(1:truncateLength,:);

    if(isempty(channel_id))
        warning('could not correct offset and gain, skipping.');
        return;
    else
        channel_id = channel_id(1:length(data));
    end
    
    uniqueChannels = unique(channel_id);
    numChannels = length(uniqueChannels);

    for i = 1:numChannels
        ch = uniqueChannels(i);
        chIdx = ch + 1;
        CH_rows{chIdx} = data(channel_id == ch);
        CH_amplitudes(chIdx) = std(CH_rows{chIdx});
        CH_offsets(chIdx) = mean(CH_rows{chIdx});
    end

    avgAmplitude = mean(CH_amplitudes(~isnan(CH_amplitudes) & CH_amplitudes > 0));

    % this is sloppy coding....should re-do later as matrix math:
    for i = 1:length(data) 
        ch = channel_id(i);
        chIdx = ch + 1;
        data(i) = (data(i) - CH_offsets(chIdx)) * (avgAmplitude / CH_amplitudes(chIdx));
    end
    
end