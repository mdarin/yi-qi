% this init procedure is for every groups one by one
init_per_group(${module}_ok, Config) ->
	process_flag(trap_exit, true),
	Supervisor = ?config(supervisor, Config),
	
	%TODO(darin-m): it's better to register a new user and delete them after the test has end	
	Creds = t_auth:login(<<"89615244722">>, <<"123123">>),                                      
	Cid = proplists:get_value(cid, Creds), 
	Phone = proplists:get_value(mqtt_login, Creds),                                               
	MQTTPassword = proplists:get_value(mqtt_password, Creds), 

	Mqtt = tst:new_connection(?MODULE, Phone, MQTTPassword, Cid),
	
	%FIXME(darin-m): temporary for debug only!
	tst:sub(Mqtt, <<"res/#">>),
	
	{save_config, [{cid, Cid}, {mqtt, Mqtt}|Config]};
