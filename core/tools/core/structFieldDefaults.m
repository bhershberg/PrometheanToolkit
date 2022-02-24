classdef structFieldDefaults < handle
% Benjamin Hershberg
% June 2018
% 
% Description: allows default values to be set for mandatory fields in a
% structure, e.g. an options or settings structure.
% 
% Usage: 
%     parser = structFieldDefaults();
%     parser.add('foo',123);
%     parser.add('bar','foobar');
%     options = parser.applyDefaults(options);
%
   properties
      defaults;
   end
   methods
      function object = structFieldDefaults(object)
         object.defaults = {};
      end
      function addDefault(object, name, value)
         object.defaults{end+1} = {name, value};
      end
      function add(object, name, value)
         object.defaults{end+1} = {name, value};
      end
      function theStruct = applyDefaults(object, theStruct)
         for i = 1:length(object.defaults)
            if(~isfield(theStruct,object.defaults{i}{1}))
                theStruct.(object.defaults{i}{1}) = object.defaults{i}{2};
            end
         end
         
%          % special "return defaults" field:
%          if(~isfield(theStruct,'returnDefaults'))
%              theStruct.returnDefaults = false;
%          elseif(~islogical(theStruct.returnDefaults) && theStruct.returnDefaults ~= 1)
%              theStruct.returnDefaults = false;
%          end
      end
   end
end