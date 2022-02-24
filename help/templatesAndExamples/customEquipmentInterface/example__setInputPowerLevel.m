% =========================================================================
% Example use of Equipment Interface API: Equalize the generator power
% level of an input signal source (dBm) so that it produces a requested
% digitized signal amplitude in an ADC output (dBFS).
% =========================================================================
% Benjamin Hershberg, 2020
%
function [dBm] = example__setInputPowerLevel(options)

    % Setup default option values: 
    if(nargin < 1), options = struct; end
    parser = structFieldDefaults();
    parser.add('interactive',false);
    parser.add('debug',true);
    parser.add('target_dBFS',-1);
    parser.add('dBm_max',getInputPowerLimit);
    parser.add('max_trials',6);
    parser.add('dBm_initial',0);
    parser.add('accuracyThreshold', 0.02);
    parser.add('signalGeneratorName','Signal Input');
    options = parser.applyDefaults(options);

    % Make sure the request level is something we can actually produce:
    if(options.target_dBFS >= 0)
        warning('target dBFS must be less than zero. Setting to -0.05');
        options.target_dBFS = -0.05;
    end
    
    % Open interface with the signal generator:
    sigGen = equipmentInterface(options.signalGeneratorName);
    
    % Initialize the search loop:
    dBm = options.dBm_initial;
    attempt = 0;
    dBFS = -100;
    fail = false;
    
    % Progress bar setup:
    if(options.interactive)
        wb = waitbar(0,'Capturing Data for Power Level Analysis...','Name','Adjusting Power Level...',...
            'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(wb,'canceling',0);
    end
        
    % Main search loop:
    while(abs(dBFS - options.target_dBFS) > options.accuracyThreshold  && attempt <= options.max_trials)

        % Set the signal generator power and apply this to the physical
        % instrument:
        sigGen.setPropertyAndApply('signal_power',dBm);

        % Capture the resulting ADC output and determine the output
        % amplitude in dBFS:
        captureResults = captureAdcOutput(options); % This is a fake capture function (see bottom of this file)
        analysisResults = analyzeAdcOutput(captureResults, options); % This is a fake analysis function (see bottom of this file)
        dBFS = analysisResults.dBFS;

        % Report the current search progress:
        if(options.debug)
            fprintf('Power level of %3.3g dBm resulted in %3.3g dBFS, %3.3g dB from target.\n',dBm,dBFS,dBFS - options.target_dBFS);
        end
        if(options.interactive)
            waitbar(attempt/options.max_trials,wb,sprintf('%3.3g dBm produces %3.3g dBFS, %3.3g dB from target.',dBm,dBFS,dBFS - options.target_dBFS));
            if getappdata(wb,'canceling')
                break;
            end
        end

        % Avoid hysterisis or indefinite osciallation around target due
        % to idosynracies in the generator by adding a decay factor to
        % the search on later steps:
        if(attempt > 3)
            damping = 0.9;
        else
            damping = 1;
        end
        % Observe measured distance from target and use this to decide
        % the next value to search:
        dBm = round(1000*(dBm + damping*(options.target_dBFS - dBFS)))/1000;

        % safety check (let's not fry the chip input)
        if(dBm > options.dBm_max)
            dBm = options.dBm_max - 3;
            sigGen.setPropertyAndApply('signal_power',dBm);
            break;
        end

        attempt = attempt + 1;

    end

    % Report the final result:
    if(options.debug)
        if(attempt >= options.max_trials)
            fprintf('Maximum number of search iterations has been reached, giving up now.\n');
        else
            fprintf('Amplitude equalization completed.\n');
        end
    end
    
    % Progress bar termination:
    if(options.interactive)
       pause(1);
       waitbar(1,wb,sprintf('Done. Took %d iterations',attempt));
       pause(1);
       delete(wb);
    end
    
    

    function results = captureAdcOutput(options)

        % This is a dummy/fake capture function.

        results.cheat_dBm_fullScale = 5; % let's cheat and say that 5 dBm corresponds to 0 dBFS
        
        pause(1); % emulate the delay of physical capture

    end
    function results = analyzeAdcOutput(captureResults, options)

        % This is a dummy/fake analysis. We're emulating the measurement
        % error and instrumentation errors that would affect the search
        % accuracy:
        
        ideal_dBFS = dBm - captureResults.cheat_dBm_fullScale;
        instrumentError = 0.05*(2*rand - 1);
        
        results.dBFS = ideal_dBFS * ( 1 + instrumentError );

    end
end