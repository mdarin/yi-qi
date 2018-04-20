
sub generate_suite_mod_init_group {
	my($fout, $module) = @_;
	print $fout "% this init procedure is for every groups one by one\n";
	print $fout "init_per_group(${module}_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	Supervisor = ?config(supervisor, Config),\n";
	print $fout "	%TODO(darin-m): it's better to register a new user and delete them after the test has end\n";
	print $fout "	[{cid, Cid}, {phone, Phone}, {mqtt_password, MQTTPassword}, {id, Id}] = t_auth:login(<<\"89615244722\">>, <<\"123\">>),\n";
	print $fout "	Mqtt = tst:new_connection(admin, Phone, MQTTPassword, Cid),\n";
	print $fout "	%FIXME(darin-m): temporary for debug only!\n";
	print $fout "	tst:sub(Mqtt, <<\"res/#\">>),\n";
	print $fout "	{save_config, [{cid, Cid}, {mqtt, Mqtt}|Config]};\n";
	print $fout "\n";
	print $fout "\n";
}
