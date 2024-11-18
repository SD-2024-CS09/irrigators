function []=mqttclient_setup(config_file)
    function cargs = read_cargs(config_file)
        f = fopen(config_file);
        raw_text = fread(f);
        json = char(raw_text');
        cargs = jsondecode(json);
        fclose(f);
    end

    function mqClient = subscribe_to_mqtt(cargs)
        mqClient = mqttclient(cargs.broker_url,Port=cargs.port,ClientID=cargs.client_id,Username=cargs.username,Password=cargs.password);
        topics = convertCharsToStrings(cargs.subscription_topics)';
        for topic = topics
            subscribe(mqClient, topic);
        end
    end

mqClient = subscribe_to_mqtt(read_cargs(config_file));
while true
    pause(30);
    dataTT = read(mqClient);
    clear mqClient;
    writetimetable(dataTT, "reponse.csv", "WriteMode","append");
    mqClient = subscribe_to_mqtt(read_cargs(config_file));
end
end