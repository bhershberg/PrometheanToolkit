function results = wrapperExample__captureData()

    % It is often best-practice to place your low-level project-specific
    % functions inside a "wrapper" function that adds a layer of separation
    % between the basic operation you want the code to perform, and the
    % implementation-specific way that you need to implement it. Examples
    % of useful wrappers are functions like decodeData(), captureData(),
    % setInputPowerLevel(), etc.
    
    % Here is an example of how you could use a single "captureData"
    % wrapper function to provide backwards compatibility across several
    % design iterations / generations:
    
    % let's assume that you keep the name of your design 
    designName = getGlobalOption('designName', 'unknown');
    
    if(isequal(designName,'myCoolCircuit_v1'))
        % here is one specific implementation of the general concept:
        results = MCCv1_captureData();  
    elseif(isequal(designName,'myCoolCircuit_v2'))
        % here is another, maybe a little bit different because you updated
        % things in this newer version:
        results = MCCv2_captureData();  
    end

    % The benefit here is that if you use wrappers properly, you'll be able
    % to re-use almost all of your project-specific functions from earlier
    % versions of your design in later version because you separated the
    % implementation-specific code from generic code. Most of your code is
    % probably generic stuff that doesn't depend on your design internals.
    % Whatever is implementation specific, just wrap it up and you'll be
    % future-proofed!
    
end