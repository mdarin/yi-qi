% this init procedure is for every groups one by one
init_per_group(${module}_ok, Config) ->
	process_flag(trap_exit, true),
	Supervisor = ?config(supervisor, Config),
	%TODO(darin-m): it's better to register a new user and delete them after the test has end
	[{cid, Cid}, {phone, Phone}, {mqtt_password, MQTTPassword}, {id, Id}] = t_auth:login(<<"89615244722">>, <<"123">>),
	Mqtt = tst:new_connection(?MODULE, Phone, MQTTPassword, Cid),
	%FIXME(darin-m): temporary for debug only!
	tst:sub(Mqtt, <<"res/#">>),
	{save_config, [{cid, Cid}, {mqtt, Mqtt}|Config]};
