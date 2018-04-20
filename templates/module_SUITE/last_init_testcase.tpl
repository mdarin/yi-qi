
sub generate_suite_mod_last_init_testcase {
	my($fout, $module) = @_;
	print $fout "% other\n";
	print $fout "init_per_testcase(_, Config) ->\n";
	print $fout "	ct:log(\"group empty init per testcase pid ~p~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}
