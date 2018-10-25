% MQTT pub:  /<CID>/${module}/${topic}
% MQTT sub:  /<CID>/res/${module}/${topic}
%TODO: Довьте требуетмые аргументы фукнции
${function}(Mqtt) -> 
	Outgoing = <<"${module}/${topic}">>,
	Incoming = <<"res/${module}/${topic}">>,
	tst:sub(Mqtt, Incoming),
	Payload = [
		%TODO:insert your data here as a proplilst {key, Value} pairs
	],
	Reply = tst:pubr(Mqtt, Outgoing, Payload),
	ct:log("::reply -> ~p~n", [Reply]),
	Reply.
	
	
