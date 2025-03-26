classdef (ConstructOnLoad) TSUpdateContents < event.EventData
   properties
      tsContents
   end
   
   methods
       function data = TSUpdateContents(newData)
         data.tsContents = newData;
      end
   end
end