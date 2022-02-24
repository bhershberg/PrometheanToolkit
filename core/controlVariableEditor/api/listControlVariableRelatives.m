% This function is a part of the Control Variable API
% Benjamin Hershberg, 2020
%
% Description: searches the control variable hierarchy for other variables
%   with the same name as the one in the path provided. Only searches two 
%   levels up at most (parent and grandparent of the path provided).
% 
% Usage:
%
%   [relatedPaths, relatives] = listControlVariableRelatives(pathString);
% 
% REQUIRED INPUTS:
%   pathString:     string - the path in the control hierarchy of the 
%                       variable to be inspected
% OUTPUTS:
%   relatedPaths:   a cell array list of paths in the control hierarchy 
%                       where the same variable name was found
%   relatives:      a structure with two fields:
%                       + relatives.parent - the field names one level up 
%                           in the hierarchy where one or more matches were 
%                           found
%                       + relatives.grandparent - the field names two levels up 
%                           in the hierarchy where one or more matches were 
%                           found
%
function [relatedPaths, relatives] = listControlVariableRelatives(pathString)
    
    global settings;
    
    if(iscell(pathString))
        pathString = breadcrumbToString(pathString);
    end

    absolutePath = getAbsoluteControlVariablePath(pathString);
    relativePath = getRelativeControlVariablePath(pathString);
    breadcrumb = strsplit(absolutePath,'.');
    relativeBreadcrumb = strsplit(relativePath,'.');

    % level 1 variables refer to the base level minus two (channel)
    % level 2 variables refer to the base level minus one (stage)
    % level 3 variables refer to the base level (local)
    relatedPaths = {};
    siblingsLvl2 = {};
    siblingsLvl1 = {};
    relatives.parent = {};
    relatives.grandparent = {};

    if(length(relativeBreadcrumb) == 1)
        return;
    elseif(length(relativeBreadcrumb) == 2)
        levelTwo = eval(breadcrumbToString(breadcrumb(1:end-2)));
        levelTwoNames = fieldnames(levelTwo);
        for j = 1:length(levelTwoNames)
            levelThree = getfield(levelTwo,levelTwoNames{j});
            if(isfield(levelThree,breadcrumb{end}))
                breadcrumbTmp = [breadcrumb(1:end-2) levelTwoNames{j} breadcrumb{end}];
                siblingsLvl2{end+1} = levelTwoNames{j};
                relatedPaths{end+1} = getRelativeControlVariablePath(breadcrumbToString(breadcrumbTmp));
            end
        end
    else
        levelOne = eval(breadcrumbToString(breadcrumb(1:end-3)));
        levelOneNames = fieldnames(levelOne);
        for i = 1:length(levelOneNames)
            levelTwo = getfield(levelOne,levelOneNames{i});
            if(isstruct(levelTwo))
                levelTwoNames = fieldnames(levelTwo);
                for j = 1:length(levelTwoNames)
                    levelThree = getfield(levelTwo,levelTwoNames{j});
                    if(isfield(levelThree,breadcrumb{end}))
                        breadcrumbTmp = [breadcrumb(1:end-3) levelOneNames{i} levelTwoNames{j} breadcrumb{end}];
                        siblingsLvl1{end+1} = levelOneNames{i};
                        siblingsLvl2{end+1} = levelTwoNames{j};
                        relatedPaths{end+1} = getRelativeControlVariablePath(breadcrumbToString(breadcrumbTmp));
                    end
                end
            end
        end
    end
    relatives.parent = unique(siblingsLvl2);
    relatives.grandparent = unique(siblingsLvl1);
end