
sub generate_suite_mod_groups {
	my($fout, $module, $topics) = @_;
	print $fout "% declare your tests groups\n";
	print $fout "all() -> [\n";
	print $fout "	%{group, $module\_error},\n"; 
	print $fout "	{group, $module\_ok}\n";
	print $fout "].\n";
	print $fout "\n";
	print $fout "\n";
	print $fout "% and what tests every group consist of\n";
	print $fout "groups() -> [\n";
	print $fout "	%{$module\_error, [], []},\n";
	print $fout "	{$module\_ok, [sequence], [\n";
	# перечислить тесты в группе	
	my $last_topic = pop @$topics;
	foreach my $topic (@$topics) {
		print $fout "		" . basename $topic . "\_ok,\n";
	}
	print $fout "		" . basename $last_topic . "\_ok\n";
	push @$topics, $last_topic;
	print $fout "	]}\n";
	print $fout "].\n";
	print $fout "\n";
	print $fout "\n";
}
