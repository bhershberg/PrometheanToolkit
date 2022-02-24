function [ reconstructed ] = pipeline_reconstruction( digital_aligned, beta, Vref, Vresidue, channel_id )
% core pipeline function, optimized for speed with matrix-based operations
% supports 3D data inputs (multi-capture)
% supports interleaving (multi-channel) & interleave gain/offset correction

    d1 = size(digital_aligned,1);
    d3 = size(digital_aligned,3);

    if(nargin < 4 || isempty(Vresidue))
        Vresidue = zeros(d1,1,d3);
    end
    if(nargin < 3 || isempty(Vref))
        Vref = 0.5;
    end
    if(nargin < 5 || isempty(channel_id))
        channel_id = zeros(d1,1,d3);
    end
    
%     channel_id = channel_id(d1,1,:);  % this was added in 4D t1 setup, but it is incorrect
    channel_id = channel_id(1:d1,1,1:d3); % ...is this what I was trying to do???
    
    uniqueChannels = unique(channel_id);
    numChannels = length(uniqueChannels);
    
    if(size(beta,1) < max(uniqueChannels)+1)
        % expand beta if necessary
        beta = repmat(beta(1,:),max(uniqueChannels)+1,1);
    end
    
    len = size(beta,2);
    for chIdx = (uniqueChannels(:)' + 1)
        beta(chIdx,1:len+1) = [1 beta(chIdx,1:len)];
        scaled_beta(chIdx,1,1) = beta(chIdx,1,1);
        for j=2:length(beta(chIdx,:,1))
            scaled_beta(chIdx,j) = beta(chIdx,j)*scaled_beta(chIdx,j-1);
        end
    end

    expanded_Vref = repmat([Vref.*ones(1,size(scaled_beta,2)-1) 1],size(digital_aligned,1),1,d3);
    null_alpha = zeros(size(digital_aligned,1),size(scaled_beta,2),d3);
    expanded_alpha = null_alpha;
    for i = 1:numChannels
        ch = uniqueChannels(i);
        identity_matrix = repmat(channel_id == ch,1,length(scaled_beta),1);
        channel_alpha = repmat(scaled_beta(ch+1,:),size(digital_aligned,1),1,d3);
        expanded_alpha = expanded_alpha + identity_matrix .* channel_alpha;
    end
    reconstructed = sum(cat(2,digital_aligned,Vresidue).*expanded_alpha.*expanded_Vref,2);
    
    if(numChannels > 1)
        reconstructed = pipeline_correctOffsetAndGain(reconstructed, channel_id);
    end

end

% the old code, 
% which had a bug in the way that scaled alpha was constructed:
%
% scaled_beta = [1 alpha .* 2.^(0:-1:(1-length(alpha)))];
% expanded_Vref = repmat([-Vref.*ones(1,length(scaled_beta)-1) 1],size(digital_aligned,1),1);
% expanded_alpha = repmat(scaled_beta,size(digital_aligned,1),1);
% reconstructed = sum([digital_aligned Vresidue].*expanded_alpha.*expanded_Vref,2);



% function [ reconstructed ] = pipeline_reconstruction( digital_aligned, beta, Vref, Vresidue, channel_id )
% 
%     d1 = size(digital_aligned,1);
%     d3 = size(digital_aligned,3);
% 
%     if(nargin < 4)
%         Vresidue = zeros(d1,1,d3);
%         if(nargin < 3)
%             Vref = 0.5;
%         end
%     end
%     
%     beta = [1 beta];
%     scaled_beta(1) = beta(1);
%     for i=2:length(beta)
%         scaled_beta(i) = beta(i)*scaled_beta(i-1);
%     end
% 
%     expanded_Vref = repmat([-Vref.*ones(1,length(scaled_beta)-1) 1],size(digital_aligned,1),1,d3);
%     expanded_alpha = repmat(scaled_beta,size(digital_aligned,1),1,d3);
%     reconstructed = sum(cat(2,digital_aligned,Vresidue).*expanded_alpha.*expanded_Vref,2);
% 
% end