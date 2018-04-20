
sub generate_suite_mod_init_testcase {
	my($fout, $module, $topic) = @_;
	print $fout "% init\n";
	print $fout "% and this init procedure is for appropriate test and prepare a place for it\n";
	print $fout "init_per_testcase($topic\_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	ct:log(\"$module\_ok:$topic\_ok[~p]~n\",  [self()]),\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}
