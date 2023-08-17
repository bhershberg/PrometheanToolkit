function results = fft_plot(results, options)

    if(nargin < 2)
        if(isstruct(results) && isfield(results,'returnDefaults'))
            % this is probably being sent by the getDefaultOptions
            % function, which things options is the first parameter
            options = results; 
        else
            % otherwise, just initialize it:
            options = struct;
        end
    end

    if(~isfield(results,'returnDefaults') && length(results.fft_norm_dB) <= 512)
        lineStyle = 'bar';
        baselineStyle = 'min';
    else
        lineStyle = 'line';
        baselineStyle = 'smart';
    end
    
    parser = structFieldDefaults();
    parser.add('style',lineStyle);
    parser.add('baseline',baselineStyle);
    parser.add('show_harmonics',true);
    parser.add('show_interleaveSpurs',true);
    parser.add('numHarmonicsToHighlight',getNumHarmonicsToHighlight);
    parser.add('num_interleaveSpurs',getInterleaveConfig);
    parser.add('interleave_factor',1); % Number of interleaved channels
    parser.add('interleave_divisionFactor',1); % Total number of channels divided by number of interleaved channels
    parser.add('show_xGridlines',false);
    parser.add('show_yGridlines',true);
    parser.add('returnDefaults',false);
    parser.add('interactive', false);
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
    
    % force over-ride of local options w.r.t. global options:
    options.numHarmonicsToHighlight = getNumHarmonicsToHighlight;


    scale_axis = 0;
    xvalues = 1:length(results.fft_norm_dB);

    if (isfield(options,'fclk') && isfield(options,'fsig') && isfield(options,'Ndec'))
        % options.fclk = options.fclk / options.interleave_divisionFactor; % Added by Ben to re-adjust to 
        options.fclk = getClockFrequency/ options.interleave_divisionFactor;
        Fclk_decimated				=  options.fclk/options.Ndec/2; %results.Fclk_undecimated/results.decimation_factor; 
        Fs_step                     =  Fclk_decimated/(length(results.fft_norm_dB));
        freq_vector_f_decimated     =  0:Fs_step:Fclk_decimated-Fs_step;
        % This was modified to match spectrum as output by function "fft_analysis()"
        %freq_vector_f_decimated		= freq_vector_f_decimated(1:length(results.fft_norm_dB)/2);
        Fsig_undecimated            =  options.fsig; %results.Fsig_undecimated;
        xvalues = freq_vector_f_decimated;
    else
        options.show_harmonics = 0;
    end

    % Determine the baseline (y-axis value at origin)
    minYvalue = min(results.fft_norm_dB)-1;
    if(minYvalue == -Inf)
        values = sort(unique(results.fft_norm_dB));
        if(length(values) > 1)
            minYvalue = round(values(2)-10);
        else
            minYvalue = -100;
        end
        results.fft_norm_dB = max(minYvalue,results.fft_norm_dB);
    end
    if(isequal(options.baseline,'mean'))
        baseline = mean(results.fft_norm_dB) - 1;
    elseif(isequal(options.baseline,'smart'))
        sorted = sort(results.fft_norm_dB);
        baseline = sorted(round(length(sorted)/4));
    elseif(isequal(options.baseline,'min'))
        baseline = minYvalue;
    else
        baseline = minYvalue;
    end

    % Plot
    if(isequal(options.style,'bar'))
        results.figure = bar(xvalues,results.fft_norm_dB,'barwidth',1,'baseValue',baseline);
        ylim([baseline max(results.fft_norm_dB)+10]);
    elseif(isequal(options.style,'stem'))
        results.figure = stem(xvalues,results.fft_norm_dB,'baseValue',baseline);
        ylim([baseline max(results.fft_norm_dB)+10]);
    else
        results.figure = plot(xvalues,results.fft_norm_dB);

        if(options.show_harmonics)
            hold on

            Nharmonics_to_calc         = options.numHarmonicsToHighlight;
    %         f_HD_folded                = zeros(1,Nharmonics_to_calc);
            %if(isfield(options,'harmonic_search'))
                   for i=1:Nharmonics_to_calc
    %                    f_HD_folded(i) = jlagos__decimation__folding(i*Fsig_undecimated, options.fclk/2, options.Ndec)*1;
    %                    index = min(find(freq_vector_f_decimated >= f_HD_folded(i)));

                       index = results.index_harmonics(i);
                       results.figure =  plot(freq_vector_f_decimated(index), results.fft_norm_dB(index), 'o');
                       dx = 0; dy = 4; % displacement so the text does not overlay the data points
                       text(freq_vector_f_decimated(index)+dx, results.fft_norm_dB(index)+dy, num2str(i));

                   end
          % end
            hold off
            scale_axis = 1;
        end

        if(options.show_interleaveSpurs && options.interleave_factor > 1)
            hold on
            nr_of_interleaved_spurs = options.num_interleaveSpurs;
            Nharmonics_to_calc_forSpurs = 1;
            for i=1:nr_of_interleaved_spurs
                for j = 1:1:Nharmonics_to_calc_forSpurs
                       % f_INTER_SPUR_folded_H1(i,j) = jlagos__decimation__folding(Fsig_undecimated*j + i*options.fclk/options.interleave_factor, options.fclk/2, options.Ndec)*1 ; %red X are the folded spurs around the fundamental
                       % index_int_spur = min(find(freq_vector_f_decimated >= f_INTER_SPUR_folded_H1(i,j)));
                       if( results.index_int_spur_matrix(i,j) ~= results.index_harmonics(1)) % skip the fundamental
                            % results.figure =  plot(freq_vector_f_decimated(index_int_spur-1), results.fft_norm_dB(index_int_spur-1), 'X', 'MarkerEdgeColor',[mod(j,3)==1,mod(j,3)==2,mod(j,3)==0]); %,[r,g,b]) %red around fundamental, green around 2nd harmonic, blue around 3rd harmonic 
                            results.figure =  plot(freq_vector_f_decimated( results.index_int_spur_matrix(i,j)), results.fft_norm_dB( results.index_int_spur_matrix(i,j)), 'X', 'MarkerEdgeColor',[mod(j,3)==1,mod(j,3)==2,mod(j,3)==0]); %,[r,g,b]) %red around fundamental, green around 2nd harmonic, blue around 3rd harmonic 
    %                       text(freq_vector_f_decimated(index_int_spur)+dx, results.fft_norm_dB(index_int_spur-1)+dy, ['x' num2str(i)]); 
                       end
                end
            end
           %% added for offset spur search
            nr_of_interleaved_offset_spurs = 1;
            for i=1:nr_of_interleaved_offset_spurs
                 f_INTER_SPUR_folded(i) = jlagos__decimation__folding(i*options.fclk/options.interleave_factor, options.fclk/2, options.Ndec)*1 ; %r* for offset spurs
                 index_int_spur = min(find(freq_vector_f_decimated >= f_INTER_SPUR_folded(i)));
                 results.figure = plot(freq_vector_f_decimated(index_int_spur-1), results.fft_norm_dB(index_int_spur-1), 'r*'); 
%                  text(freq_vector_f_decimated(index_int_spur)+dx, results.fft_norm_dB(index_int_spur-1)+dy, num2str(i)); 
            end
        hold off 
        end
    end

    if(find(results.fft_norm_dB == max(results.fft_norm_dB)) > length(results.fft_norm_dB)/2)
        label_location = 0.1;
    else
        label_location = 0.7;
    end

    performanceSummary = '';
    fieldsToPrint = {'SNDR','SFDR','HD2','HD3','THD', 'THDint','ENOB','ENOB_SNR','dBFS'};
    unitsToPrint = {'dB','dB','dB','dB','dB','dB','b', 'b','dB'};
    for xyz = 1:length(fieldsToPrint)
        if(isfield(results,fieldsToPrint{xyz}))
            performanceSummary = [performanceSummary sprintf('%s = %0.2f %s\n',fieldsToPrint{xyz},results.(fieldsToPrint{xyz}),unitsToPrint{xyz})];
        end
    end
    if(length(performanceSummary) > 1), performanceSummary = performanceSummary(1:end-1); end
    if(scale_axis)
        axis([0 freq_vector_f_decimated(end) baseline 10]);
        t = text(round(label_location*freq_vector_f_decimated(end)),max(results.fft_norm_dB)-20,performanceSummary);
    else
        axis([0 length(results.fft_norm_dB) baseline 10]);
        t = text(round(label_location*length(results.fft_norm_dB)),max(results.fft_norm_dB)-20,performanceSummary);
    end
    t.BackgroundColor = [1 1 1];

    xlabel('frequency (Hz)');
    if(isfield(options,'normalizationMode'))
        ylabel(options.normalizationMode);
    else
        ylabel('dB');
    end
    f = gcf;
    if(options.show_xGridlines)
        f.CurrentAxes.XGrid = 'on';
    end
    if(options.show_yGridlines)
        f.CurrentAxes.YGrid = 'on';
    end
    

end