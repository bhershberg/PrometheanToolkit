classdef manageCustomTabs < handle

    properties
      tabNames;
      tabHandles;
      tabInitFunctions;
   end
   methods
      function object = manageCustomTabs(object)
         object.tabNames = {};
         object.tabHandles = {};
         object.tabInitFunctions = {};
      end
      function placeTab(object, tabGroup, tabName, tabInitFunctionHandle)
         object.tabNames{end+1} = tabName;
         object.tabInitFunctions{end+1} = tabInitFunctionHandle;
         object.tabHandles{end+1} = placeTab(tabGroup,tabName);
         tabInitFunctionHandle(object.tabHandles{end});
      end
      function deleteAllTabs(object)
          for i = 1:length(object.tabHandles)
             delete(object.tabHandles{i});
          end
          object.tabNames = {};
          object.tabHandles = {};
          object.tabInitFunctions = {};
      end
   end
end