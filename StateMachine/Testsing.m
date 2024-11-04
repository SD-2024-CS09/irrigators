readChannelID = 2667716;
readAPIKey = 'RE7V83AT4USIDZN7';

writeChannelID = 2667716;
writeAPIKey = '6AO4PYC5RM7D1KJX';

%% Read Data %%
data = thingSpeakRead(readChannelID,'Fields', 1, 'ReadKey', readAPIKey);


%% Analyze Data %%
% Add code in this section to analyze data and store the result in the
% 'analyzedData' variable.
%% Write Data %%
if data > 30 
    send = 1;
else 
    send = 2;
end 
pause(15);
thingSpeakWrite(writeChannelID,'Fields',[2],'Values', [send], 'WriteKey', writeAPIKey);
