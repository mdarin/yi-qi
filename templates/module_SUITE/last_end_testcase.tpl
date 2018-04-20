
sub generate_suite_mod_last_end_testcase {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "end_per_testcase(_, Config) ->\n";
	print $fout "	ct:log(\"$module\_ok: _ [~p]~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}
