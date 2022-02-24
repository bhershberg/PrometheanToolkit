function results = calculate_inlDnl( options )
% Benjamin Hershberg, 2018.
% Based on the 2002 script from Boris Murmann
%
% options.data is assumed to be a full-scale sine wave composed of 
% digitized integer values ranging from 0 to the max ADC code.


    if(nargin < 1)
        options = struct;
    end
    parser = structFieldDefaults();
    parser.add('returnDefaults',false);
    parser.add('percentEndCodesToRemove',1); % codes to actually remove from INL (the bins on the edges can be erroneous due to imperfect full-scale fit)
    parser.add('percentEndCodesToIgnore',10); % codes to just ignore when doing an INL best-fit calculation
    options = parser.applyDefaults(options);
    if(options.returnDefaults)
        global defaultOptions; 
        defaultOptions = options; return; 
    end
    
    
    vec = options.dataCodes;

    % histogram boundaries
    minbin=min(vec);
    maxbin=max(vec);

    % histogram
    h= hist(vec, minbin:maxbin);

    % cumulative histogram
    ch= cumsum(h);

    % linearized histogram
    T = -cos(pi*ch/sum(h));
    hlin = T(2:end) - T(1:end-1);

    % truncate at least first and last bin, more if input did not clip ADC
    toRemove = round(0.5*0.01*length(hlin)*options.percentEndCodesToRemove);
    hlin_trunc = hlin(1+toRemove:end-toRemove);

    gainCorrect = 0;
    radix = 1.6;
    step = 40;

    toIgnore = round(0.5*0.01*length(hlin_trunc)*options.percentEndCodesToIgnore);
    for i = 1:36
        % calculate lsb size and dnl
        lsb= sum(hlin_trunc) / (length(hlin_trunc)+ gainCorrect);
        dnl= [0 hlin_trunc/lsb-1];
        % calculate inl
        inl= cumsum(dnl);
        inl= inl - mean(inl);
        % test for best-fit:
        if(mean(inl(1+toIgnore:round(end/2))) > mean(inl(round(end/2):end-toIgnore)))
            gainCorrect = gainCorrect + step;
        else
            gainCorrect = gainCorrect - step;
        end
        step = step / radix;
    end

    results.inl = inl;
    results.dnl = dnl;
    results.codes = minbin+toRemove:maxbin-toRemove;
    results.histogram = h;

end

