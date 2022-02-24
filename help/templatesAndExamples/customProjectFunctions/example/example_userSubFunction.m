% Benjamin Hershberg, 2020
%
function [results, tf] = example_userSubFunction(options)

    % DO NOT EDIT ---------------------------------------------------------
    results = struct;                       % Return any/all function outputs with a single 'results' structure
    tf = 1;                                 % Function exit status (tf=1 --> success, tf=0 --> failure/canceled)
    if(nargin < 1), options = struct; end   % All inputs are provided to the function through an 'options' structure
    parser = structFieldDefaults();         % Instantiate the options parser
    parser.add('returnDefaults',false);     % Required options field, do not edit
    parser.add('interactive', false);       % Required options field, strongly advised to set to 'false'
    % ---------------------------------------------------------------------
    
    % define default values for the options parameters that will be used:
    parser.add('debug',true);
    parser.add('linearGrowth',1:20);
    parser.add('primeGrowth', 20*primes(71)/71);
    parser.add('exponentialGrowth',20*(1:20).^2 / 20^2);
    parser.add('noisyGrowth',[1:20] + [randn(1,20)]);
    parser.add('microNoise',1e-6*randn(1,20));
    parser.add('indexesToReturn',1:20);
    options = parser.applyDefaults(options); % DO NOT EDIT

    % DO NOT EDIT ---------------------------------------------------------
    if(options.returnDefaults), global defaultOptions; defaultOptions = options; return; end
    [options, tf] = interactiveSetup(options); if(~tf), return; end
    % ---------------------------------------------------------------------
    
    % main function code begins:
    results.growthCurve_linear = options.linearGrowth(options.indexesToReturn);
    results.growthCurve_prime = options.primeGrowth(options.indexesToReturn);
    results.growthCurve_exponential = options.exponentialGrowth(options.indexesToReturn);
    results.growthCurve_noisy = options.noisyGrowth(options.indexesToReturn);
    results.microNoise = options.microNoise(options.indexesToReturn);
    
end

function [options, tf] = interactiveSetup(options)
% Local function that defines the behavior when options.interactive = true

    % DO NOT EDIT ---------------------------------------------------------
    tf = 0; if(~options.interactive), tf = 1; return; end
    % ---------------------------------------------------------------------
    
    % let the user view and edit the options before executing main code:
    [options, tf] = optionsEditor(options);
    if(~tf), return; end  

    % DO NOT EDIT --------------------------------------------------------
    options.interactive = false; % will be passed along to sub-functions, so should be set to 'false'
    tf = 1;
    % ---------------------------------------------------------------------
    
end