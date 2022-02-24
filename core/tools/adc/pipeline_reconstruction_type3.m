function [ reconstructed ] = pipeline_reconstruction_type3( digital_aligned, beta, Vref, Vresidue, channel_id )
% core pipeline function, optimized for speed with matrix-based operations
% supports 3D data inputs (multi-capture)
% supports interleaving (multi-channel) & interleave gain/offset correction

% modification by Nereo:
% omit use of residue as it is not applicable in Type 3
 

    d1 = size(digital_aligned,1);
    d3 = size(digital_aligned,3);

    if(nargin < 4 || isempty(Vresidue))
        Vresidue = zeros(d1,1,d3);
    end
    if(nargin < 3 || isempty(Vref))
        Vref = 0.5;
%         Vref = 0.75; %NM
        
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
    
    len = size(beta,2);% 
    for chIdx = (uniqueChannels(:)' + 1)
        beta(chIdx,1:len+1) = [1 beta(chIdx,1:len)];%adds channel indetification index in beta[1] - this was useful for type1, we leave it be.
        scaled_beta(chIdx,1,1) = beta(chIdx,1,1);
%NM: commented out these lines of code as beta is interpreted differently
%in context of type3
%         for j=2:length(beta(chIdx,:,1)) %this was previously used to
%             scaled_beta(chIdx,j) = beta(chIdx,j)*scaled_beta(chIdx,j-1);
%         end
    end
    
    scaled_beta = beta; % following definition of beta in context of type3

%     expanded_Vref = repmat([Vref.*ones(1,size(scaled_beta,2)-1) 1],size(digital_aligned,1),1,d3);
    expanded_Vref = repmat([Vref.*ones(1,size(scaled_beta,2)-1)],size(digital_aligned,1),1,d3);%equal Vref used in every stage
    null_alpha = zeros(size(digital_aligned,1),size(scaled_beta,2),d3);
    expanded_alpha = null_alpha;
    for i = 1:numChannels
        ch = uniqueChannels(i);
        identity_matrix = repmat(channel_id == ch,1,length(scaled_beta),1);
        channel_alpha = repmat(scaled_beta(ch+1,:),size(digital_aligned,1),1,d3);
        expanded_alpha = expanded_alpha + identity_matrix .* channel_alpha;
    end
%     reconstructed = sum(cat(2,digital_aligned,Vresidue).*expanded_alpha.*expanded_Vref,2); % residue is not used in context of Type3, should be ommitted from functions input as it is not meaningful
    reconstructed = sum(digital_aligned.*expanded_alpha(:,2:end,:).*expanded_Vref,2); % 
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