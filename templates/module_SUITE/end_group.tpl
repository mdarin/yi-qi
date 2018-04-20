
sub generate_suite_mod_end_group {
	my($fout, $module) = @_;
	print $fout "% this poroceduer cleaning up related group\n";
	print $fout "end_per_group($module\_ok, Config) ->\n";
	print $fout "	ct:log(\"end per group $module\_ok[~p]~n\",  [self()]),\n";
	print $fout "	Mqtt = ?config(mqtt, Config),\n";
	print $fout "	%FIXME(darin-m): падает тут t_auth:logout(Mqtt, admin),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}
