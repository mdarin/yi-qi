
sub generate_suite_mod_end_last_group {
	my($fout, $module) = @_;
	print $fout "% othor\n";
	print $fout "end_per_group(_, Config) ->\n";
	print $fout "	ct:log(\"end per group _ [~p]~n\",  [self()]),\n";
	print $fout "	Config.\n";
	print $fout "\n";
	print $fout "\n";
}
