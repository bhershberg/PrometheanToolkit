% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
%
% Description: Ask a user which fields saved within in a results structure
%               they would like to plot. This saves you the effort of
%               re-coding this procedure in each of your custom plotting
%               functions. Note that if options.interactivePlot = false; is
%               passed in to this function, nothing will be done.
%
% Usage:
%
%   [options] = askWhatToPlot(results, options)
% 
% REQUIRED INPUTS:
%   results:    The results structure that you wish to plot data from.
%                   Each field in the structure is assumed to contain
%                   plottable data. If there are fields you wish to
%                   blacklist (skip), specify them with: 
%                       options.blackList = {'fieldName1', 'fieldName2'}; 
% OPTIONAL INPUTS:
%   options:    An optional structure that can be used to define function
%                   behavior.
%                     
% OUTPUTS:
%   optionsOut: The final options structure with a field 'variablesToPlot'
%                   that specifies what fields were ultimately selected.
%
% WORKING EXAMPLE:
% 
% options.variablesToPlot = {'exampleField1', 'exampleField2');
% options.blackList = {'exampleField3'};
% [options] = askWhatToPlot(results, options);
% for i = 1:length(options.variablesToPlot)
%   % your plotting code here...
% end
%
function [options] = askWhatToPlot(results, options)

    if(nargin < 2), options = struct; end
    parser = structFieldDefaults();
    parser.add('variablesToPlot',{});
    parser.add('interactivePlot',true);
    parser.add('includeBlackListDefaults',true);
    parser.add('blackList',{});
    parser.add('blackListDefaults',{'notes','plotFunction','options','interfaces','profiles','ctrl','stateData_controlVariables','stateData_equipmentInterfaces','stateData_executionManager','stateData_globalOptions','resultName','timestampCreated','dateCreated'});
    options = parser.applyDefaults(options);
    
    if(options.interactivePlot)
        
        if(options.includeBlackListDefaults)
            options.blackList = [options.blackList options.blackListDefaults];
        end

        list = fieldnames(results);
        list2 = {};
        for i = 1:length(list)
            if(~blackListed(list{i},options.blackList))
                list2{end+1} = list{i};
            end
        end

        selectIdx = [];
        for k = 1:length(options.variablesToPlot)
           selectIdx(k) = find(ismember(list2,options.variablesToPlot{k}));
        end
        [indx,tf] = listDialog('Select results to plot:',list2,selectIdx,'multiple');
        if(~tf), return; end
        
        options.variablesToPlot = {};
        for i = 1:length(indx)
            options.variablesToPlot{i} = list2{indx(i)};
        end
        
    end

end