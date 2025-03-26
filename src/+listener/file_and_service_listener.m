classdef file_and_service_listener < handle
    properties
        thingspeak_conn
        waterFileHandle
        smFileHandle
        isListening
        isListeningSM
    end

    events
        StateChange
        BoundsChange
        UpdatePulled
    end

    methods

        function obj = file_and_service_listener(waterFileHandle, smFileHandle, thingspeak_conn)
            % checks if the file exists
            if ~isfile(waterFileHandle)
                error('File "%s" does not exist. Please provide a valid file.', waterFileHandle);
            end

            if ~isfile(smFileHandle)
                error('File "%s" does not exist. Please provide a valid file.', smFileHandle);
            end

            obj.thingspeak_conn = thingspeak_conn;
            obj.waterFileHandle = waterFileHandle;
            obj.smFileHandle = smFileHandle;
            obj.isListening = false;
            obj.isListeningSM = false;
        end

        % Clear file so updates can be read when changes come in
        function emptyFile(obj)
            IPCFile = fopen(obj.waterFileHandle, 'w');
            fwrite(IPCFile, "");
            fclose(IPCFile);
        end

        % file listener loop
        function obj = openListener(obj, delay)
            st = posixtime(datetime("now"));
            prev_sm_file_data = fileread(obj.smFileHandle);
            obj.isListening = true;
            obj.isListeningSM = true;
            while obj.isListening
                pause(delay) % check every delay seconds
                sm_file_data = fileread(obj.smFileHandle);
                if ~strcmp(prev_sm_file_data, sm_file_data)
                    boundsChangeData = listener.FileUpdateContents(sm_file_data);
                    notify(obj,'BoundsChange', boundsChangeData);
                    prev_sm_file_data = sm_file_data;
                    disp("[" + string(datetime("now")) + "] Request SM Bound Change to " + sm_file_data + " from Website.");
                end

                water_file_data = fileread(obj.waterFileHandle); % refresh the data
                if ~strcmp("", water_file_data)
                    stateChangeData = listener.FileUpdateContents(water_file_data);
                    emptyFile(obj);
                    notify(obj,'StateChange', stateChangeData);
                    disp("[" + string(datetime("now")) + "] Request State Change to " + water_file_data + " from Website.");
                    st = posixtime(datetime("now"));
                    if obj.isListeningSM == false
                        obj.isListeningSM = true;
                    else
                        obj.isListeningSM = false;
                    end
                elseif obj.isListeningSM
                    newData = obj.thingspeak_conn.readChannel(1);
                    if (isnan(newData)) 
                        warning("Unable to retreive valid sensor values from ThingSpeak.")
                        return
                    end
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

