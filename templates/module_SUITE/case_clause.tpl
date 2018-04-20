
sub generate_suite_mod_fun_clause {
	my($fout, $module, $topic) = @_;
	my $function = basename $topic;
	print $fout "$topic\_ok(Config) ->\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	{Saver,SavedConfig} = ?config(saved_config, Config),\n";
	print $fout "	Mqtt = ?config(mqtt, SavedConfig),\n";
	print $fout "	Res = t_$module:$function(Mqtt),\n";
	print $fout "	ct:log(\"::res -> ~p~n\", [Res]),\n";
	print $fout "	SaveConfig = SavedConfig,\n";
	print $fout "	{save_config, SaveConfig}.\n";
	print $fout "\n";
	print $fout "\n";
}
