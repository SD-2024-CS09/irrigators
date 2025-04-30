classdef (ConstructOnLoad) FileUpdateContents < event.EventData
   properties
      fileContents
   end
   
   methods
       function data = FileUpdateContents(newData)
         data.fileContents = newData;
      end
   end
end