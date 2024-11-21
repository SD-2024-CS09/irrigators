classdef ts_connection
    properties
        ChannelID
        readAPIKey
        writeAPIKey
    end
    
    methods
        
        % Constructor to initialize the ThingSpeak connection
        %
        % Name: ts_connection
        % Purpose: Initialize an instance of the ts_connection class with specified channel ID, read API key, and write API key.
        % Pre: Valid ThingSpeak channel ID and API keys must be provided.
        % Post: Object is created with specified properties.
        % Usage: obj = ts_connection(12345, 'readKey', 'writeKey');
        function obj = ts_connection(ChannelID, readAPIKey, writeAPIKey)
            obj.ChannelID = ChannelID;
            obj.readAPIKey = readAPIKey;
            obj.writeAPIKey = writeAPIKey;
        end

        % Method to read data from the ThingSpeak channel with retry logic
        %
        % Name: readChannel
        % Purpose: Reads data from the specified field of the ThingSpeak channel, retrying in case of failure up to a maximum number of attempts.
        % Pre: Field must be a valid numeric field ID; ThingSpeak channel must be accessible.
        % Post: Returns the data from the specified field if successful; raises an error if all retries fail.
        % Usage: data = obj.readChannel(1);
        function data = readChannel(obj, Field)
            success = false;
            maxRetries = 20;
            retries = 0;
            data = [];
            
            while ~success && retries < maxRetries
                try
                    % Attempt to read data
                    data = thingSpeakRead(obj.ChannelID, 'Fields', Field, 'ReadKey', obj.readAPIKey);
                    success = true; 
                catch ME
                    % Handle the error and retry
                    retries = retries + 1;
                    if retries < maxRetries
                        pause(2); 
                    else
                        disp('Max retries reached. Read failed.');
                        rethrow(ME); % Re-throw the error after max retries
                    end
                end
            end
        end

        % Method to write data to the ThingSpeak channel with retry logic
        %
        % Name: writeChannel
        % Purpose: Writes data to the specified field of the ThingSpeak channel, retrying in case of failure up to a maximum number of attempts.
        % Pre: Field must be a valid numeric field ID; Value must be valid for the ThingSpeak channel.
        % Post: Data is written to the specified field if successful; raises an error if all retries fail.
        % Usage: obj.writeChannel(2, 42);
        function writeChannel(obj, Field, Value)
            success = false;
            maxRetries = 20;
            retries = 0;
            
            while ~success && retries < maxRetries
                try
                    % Attempt to write data
                    thingSpeakWrite(obj.ChannelID,'Fields', Field,'Values', Value, 'WriteKey', obj.writeAPIKey);
                    success = true;
                catch ME
                    % Handle the error and retry
                    retries = retries + 1;
                    if retries < maxRetries
                        pause(2);
                    else
                        disp('Max retries reached. Write failed.');
                        rethrow(ME); % Re-throw the error after max retries
                    end
                end
            end
        end
    end
end
