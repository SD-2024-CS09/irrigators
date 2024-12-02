classdef file_listener < handle
    properties
        fileHandle
        isListening
    end

    events
        StateChange
    end

    methods

        function obj = file_listener(fileHandle)
            % checks if the file exists
            if ~isfile(fileHandle)
                error('File "%s" does not exist. Please provide a valid file.', fileHandle);
            end

            obj.fileHandle = fileHandle;
            obj.isListening = false;
        end

        % file listener loop
        function obj = openListener(obj, delay)
            obj.isListening = true;
            prev_data = fileread(obj.fileHandle);
            while obj.isListening
                pause(delay) % check every 5 seconds

                file_data = fileread(obj.fileHandle); % refresh the data
                if ~strcmp(prev_data, file_data)
                    prev_data = file_data; % update prev data
                    stateChangeData = listener.FileUpdateContents(file_data);
                    notify(obj,'StateChange', stateChangeData);
                end
            end
        end

        % stop the while loop without destroying obj
        function obj = pauseListener(obj)
            obj.isListening = false;
        end
    end
end

