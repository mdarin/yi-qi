
sub generate_suite_mod_end_testcase {
	my($fout, $module, $topic) = @_;
	print $fout "% end \n";
	print $fout "% this finisthing procedure is for clean up related test after end\n";
	print $fout "end_per_testcase($topic\_ok, Config) ->\n";
	print $fout "	process_flag(trap_exit, true),\n";
	print $fout "	ct:log(\"$module\_ok:$topic\_ok[~p]~n\",  [self()]),\n";
	print $fout "	ct:pal(\"::config -> ~p~n\", [Config]),\n";
	print $fout "	Config;\n";
	print $fout "\n";
	print $fout "\n";
}
