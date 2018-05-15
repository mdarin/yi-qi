% MQTT pub:  /<CID>/${module}/${topic}
% MQTT sub:  /<CID>/${module}/res/${topic}
%TODO: Довьте требуетмые аргументы фукнции
${function}(Mqtt) -> 
	Outgoing = <<"${module}/${topic}">>,
	Incomeing = <<"res/${module}/${topic}">>,
	tst:sub(Mqtt, Incomeing),
	Payload = [
		%TODO:insert your data here as a proplilst {key, Value} pairs
	],
	Reply = tst:pubr(Mqtt, Outgoing, Payload),
	ct:log("::reply -> ~p~n", [Reply]),
	Reply.
	
	
