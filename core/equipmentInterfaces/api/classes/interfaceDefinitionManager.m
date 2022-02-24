% This class is a part of the Equipment Control API
% Benjamin Hershberg, 2020
%
% Description: This class helps manage the equipment interfaces that are
% installed in the system. That is, it allows the user to add their own
% equipment interfaces to the GUI. The details of this class are not
% important, you only need to know how to use it in the context of the
% file: custom__interfaceDefinitionsInclude.m
% 
% See the documentation in custom__interfaceDefinitionsInclude.m for
% further explanation and examples.
%
classdef interfaceDefinitionManager < handle

   properties
        interfaceName = {};
        interfaceCreateFunction = {};
        interfaceApplyFunction = {};
   end
   methods
      function object = interfaceDefinitionManager(object)
         object.interfaceName = {};
         object.interfaceCreateFunction = {};
         object.interfaceApplyFunction = {};
      end
      function add(object, name, createFunction, applyFunction)
         object.interfaceName{end+1} = name;
         object.interfaceCreateFunction{end+1} = createFunction;
         object.interfaceApplyFunction{end+1} = applyFunction;
      end
      function [createFunction, applyFunction, name] = get(object, name)
         for i = 1:length(object.interfaceName)
            if(isequal(name,object.interfaceName{i}))
               createFunction = object.interfaceCreateFunction{i};
               applyFunction = object.interfaceApplyFunction{i};
               return;
            end
         end
         createFunction = -1; applyFunction = -1;
         warning('Interface definition ''%s'' not found.',name);
      end
      function interfaceName = list(object)
         interfaceName = sort(object.interfaceName); 
      end
   end
end