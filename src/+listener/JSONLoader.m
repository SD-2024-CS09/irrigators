classdef JSONLoader
    methods (Static)

        % Reads a Json file passed by file name into an object with JSON values as
        % properties.
        function jsonObj = loadJSON(fileName)
            try
                f = fopen(fileName);
                jsonStr = fread(f);
            catch e
                [~,name,ext] = fileparts(fileName);
                error("Unable to read ' %s%s' with exception: %s", name, ext, getReport(e));
                return;
            end
            try
                json = char(jsonStr');
                jsonObj = jsondecode(json);
                fclose(f);
            catch e
                [~,name,ext] = fileparts(fileName);
                error("Unable to load JSON ' %s%s' into object. %s", name, ext, getReport(e));
            end
        end
    end
end
