function [results, options] = fft_analysis(data, options)
% Benjamin Hershberg
% v1 2016.09
% updated 2018.06 to support 3D / multi-capture inputs

    data3D = data;

    if(nargin < 2)
        if(isstruct(data))
            % this is probably being sent by the getDefaultOptions
            % function, which things options is the first parameter
            options = data; 
        else
            % otherwise, just initialize it:
            options = struct;
        end
    end

    [divisionFactor, ordering, ~, interleaveFactor] = getInterleaveConfig();
    
    if(getFftSize > 0 && ~(isfield(options,'environment') && isequal(options.environment,'sim')))
        fft_size = getFftSize;
    else
        fft_size = floor(log10(length(data))/log10(2));  
    end
    if(interleaveFactor == 1), calcS = false;
    else calcS = true; end
    
    parser = structFieldDefaults();
    parser.add('debug',1);
    parser.add('type',getType);
    parser.add('fft_size',fft_size); %options.fft_size = floor(log10(length(data))/log10(2)); 
    if(~(isfield(options,'environment') && isequal(options.environment,'lab')))
        parser.add('fclk',getClockFrequency);
        parser.add('fsig',getSignalFrequency);
        parser.add('Ndec',getDecimationFactor);
    end
    parser.add('fft_dc_ignore',1); % number of bins at low frequency to ignore
    parser.add('fft_fund_skirt_include',0); % number of bins on either side of fundamental to count as signal
    parser.add('num_harmonics',getNumHarmonicsToSave);
    parser.add('num_interleaveSpurs',10);
    parser.add('interleave_factor',length(ordering)); % Number of interleaved channels
    parser.add('interleave_divisionFactor',divisionFactor); % Total number of channels divided by number of interleaved channels
    parser.add('calculateHarmonics',true);
    parser.add('calculateInterleaveSpurs',calcS);
    parser.add('normalizationMode','dBFS'); % options: dBc, dBFS
    parser.add('Afs',2*ones(1,size(data3D,3)));
    parser.add('returnDefaults',false);
    parser.add('interactive', false);
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
    
    % over-ride local option w.r.t. global option:
    options.num_harmonics = getNumHarmonicsToSave;

    for i = 1:size(data3D,3)

        data = reshape(data3D(:,:,i),1,[]);

        % Calculate FFT and variants
        fft_complex = fft(data(1:options.fft_size));
        fft_trunc = fft_complex(1:(1+end/2))/options.fft_size;
        fft_abs = sqrt(fft_trunc .* conj(fft_trunc));
        fft_abs(2:end-1) = 2*fft_abs(2:end-1);
        switch options.normalizationMode
            case 'dBc'
                fft_norm = fft_abs ./ max(fft_abs(:));
            case 'dBFS'
                fft_norm = (fft_abs ./ max(fft_abs)) .* (max(data) - min(data)) ./ options.Afs(i);
        end
        results.fft_norm_dB(i,:) = 20*log10(abs(fft_norm));
        fft_norm_P = fft_norm .^ 2;

        % calculate SNDR, SFDR, ENOB
        [~, sigBin] = max(fft_norm_P(2:end)); sigIdx = sigBin+1;
        if(sigIdx == 2)
            options.fft_dc_ignore = min(options.fft_dc_ignore,1);
        elseif(sigIdx <= options.fft_dc_ignore)
            options.fft_dc_ignore = sigIdx - 1;
        end
        P_sig = sum(fft_norm_P(max(1,sigIdx-options.fft_fund_skirt_include):min(sigIdx+options.fft_fund_skirt_include,end)));
        P_spectrum = [fft_norm_P(options.fft_dc_ignore:max(sigIdx-1-options.fft_fund_skirt_include,options.fft_dc_ignore)) ...
                    fft_norm_P(min(sigIdx+1+options.fft_fund_skirt_include,end):end)];
        results.SNDR(i) = 10*log10(P_sig / (sum(fft_norm_P(1+options.fft_dc_ignore:end)) - P_sig));
        results.SFDR(i) = 10*log10(P_sig / max(P_spectrum(2:end)));
        results.ENOB(i) = (results.SNDR(i) - 1.76) / (20*log10(2)); 
        results.P_sig(i) = sum(P_sig);
        results.P_spectrum(i) = sum(P_spectrum);
        results.data(i,:) = data;
        
        % If the signal frequency is not known (function
        % getSignalFrequency returned '1'), let's detect it by looking at
        % the bin with the peak power:
        if(options.fsig == 1)
            options.fsig = sigBin * options.fclk / options.fft_size;
        end
        
        options.fclk                = options.fclk / options.interleave_divisionFactor;
        Fclk_decimated				=  options.fclk/options.Ndec/2;
        Fs_step                     =  Fclk_decimated/(length(results.fft_norm_dB));
        freq_vector_f_decimated     =  0:Fs_step:Fclk_decimated-Fs_step;
        Fsig_undecimated            =  options.fsig;
        results.xfreq               = freq_vector_f_decimated;
        
        % --------------------------------------------
        % Identify bins that contain harmonics:
        if(options.calculateHarmonics)
            try
                resultsBACKUP = results;
                Nharmonics_to_calc         = options.num_harmonics;
                f_HD_folded                = zeros(1,Nharmonics_to_calc);
                index_harmonics            = zeros(1,Nharmonics_to_calc);
                for k=1:Nharmonics_to_calc
                   f_HD_folded(k) = jlagos__decimation__folding(k*Fsig_undecimated, options.fclk/2, options.Ndec)*1;
                   harmFreqDecIdx = find(freq_vector_f_decimated >= f_HD_folded(k),1);
                   if(~isempty(harmFreqDecIdx))
                        index_harmonics(k) = harmFreqDecIdx(1);
                   else
                       error('something went wrong when trying to calculate harmonics');
%                        warning('couldn''t find the harmonic frequency index.');
%                        index_harmonics(k) = 1;
                   end
                end
                results.index_harmonics(i,:) = index_harmonics - 1;
                P_harmonics = sum(fft_norm_P(unique(index_harmonics(2:end)-1)));
                results.P_harmonics(i) = P_harmonics;
                results.THD(i) = 10*log10(P_sig / P_harmonics);
                results.HD2(i) = 10*log10(P_sig / fft_norm_P(unique(index_harmonics(2)-1)));
                results.HD3(i) = 10*log10(P_sig / fft_norm_P(unique(index_harmonics(3)-1)));
                results.HD(1) = 0;
                for xxx = 2:length(index_harmonics)
                    results.HD(xxx) = 10*log10(P_sig / fft_norm_P(unique(index_harmonics(xxx)-1)));
                end
            catch
%                 warning('failed to calculate harmonic locations, skipping.');
                results = resultsBACKUP;
            end
        end
        % --------------------------------------------

        
        % --------------------------------------------
        % Identify bins that contain interleave spurs:
        if(options.calculateInterleaveSpurs)
            try 
                resultsBACKUP = results;
                index_int_spur = [];
                Nharmonics_to_calc_forSpurs = 1; % just calculate spurs for the fundamental tone
                for k=1:options.num_interleaveSpurs
                    for j = 1:1:Nharmonics_to_calc_forSpurs
                           f_INTER_SPUR_folded_H1(k,j) = jlagos__decimation__folding(Fsig_undecimated*j + k*options.fclk/options.interleave_factor, options.fclk/2, options.Ndec)*1 ; %red X are the folded spurs around the fundamental
                           index_int_spur(end+1) = min(find(freq_vector_f_decimated >= f_INTER_SPUR_folded_H1(k,j)));           
                    end
                end
                index_int_spur = unique(index_int_spur - 1);
                results.P_interleaveSpurs(i) = sum(fft_norm_P(setdiff(index_int_spur,sigIdx)));
                results.index_interleaveSpurs(i,:) = index_int_spur;
            catch
                warning('failed to calculate interleaving spur locations, skipping.');
                results = resultsBACKUP;
            end
        else
            results.P_interleaveSpurs = 0;
            results.index_interleaveSpurs = [];
        end
        % --------------------------------------------
        
    end

end