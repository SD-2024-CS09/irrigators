classdef file_and_service_listener < handle
    properties
        thingspeak_conn
        fileHandle
        isListening
        isListeningSM
    end

    events
        StateChange
        UpdatePulled
    end

    methods

        function obj = file_and_service_listener(fileHandle, thingspeak_conn)
            % checks if the file exists
            if ~isfile(fileHandle)
                error('File "%s" does not exist. Please provide a valid file.', fileHandle);
            end
            obj.thingspeak_conn = thingspeak_conn;
            obj.fileHandle = fileHandle;
            obj.isListening = false;
            obj.isListeningSM = false;
        end

        % Clear file so updates can be read when changes come in
        function emptyFile(obj)
            IPCFile = fopen(obj.fileHandle, 'w');
            fwrite(IPCFile, "");
            fclose(IPCFile);
        end

        % file listener loop
        function obj = openListener(obj, delay)
            st = posixtime(datetime("now"));
            obj.isListening = true;
            obj.isListeningSM = true;
            while obj.isListening
                pause(delay) % check every 5 seconds
                file_data = fileread(obj.fileHandle); % refresh the data
                if ~strcmp("", file_data)
                    stateChangeData = listener.FileUpdateContents(file_data);
                    emptyFile(obj);
                    notify(obj,'StateChange', stateChangeData);
                    disp("[" + string(datetime("now")) + "] Request State Change to " + file_data + " from Website.");
                    st = posixtime(datetime("now"));
                    obj.isListeningSM = false;
                elseif obj.isListeningSM
                    newData = obj.thingspeak_conn.readChannel(1);
                    valueChangeData = listener.TSUpdateContents(newData);
                    notify(obj,'UpdatePulled', valueChangeData);
                    disp("[" + string(datetime("now")) + "] Pulling from ThingSpeak: var = " + newData );
                elseif st - posixtime(datetime("now")) >= 240
                    obj.isListeningSM = true;
                    st = posixtime(datetime("now"));
                end
            end
        end

        % stop the while loop without destroying obj
        function obj = pauseListener(obj)
            obj.isListening = false;
            disp("Pausing File Listener");
        end
    end
end

