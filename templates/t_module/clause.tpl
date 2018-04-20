
sub generate_t_mod_fun_clause {
	my($fout, $module, $topic) = @_;
	my $function = basename $topic;
	print $fout "% MQTT pub:  /<CID>/$module/$topic\n";
	print $fout "% MQTT sub:  /<CID>/$module/res/$topic\n";
	print $fout "$function(Mqtt) -> %TODO: Довьте требуетмые аргументы фукнции\n";
	print $fout "	Outgoing = <<\"$module/$topic\">>,\n";
	print $fout "	Incomeing = <<\"$module/res/$topic\">>,\n";
	print $fout "	tst:sub(Mqtt, Incomeing),\n";
	print $fout "	Payload = [\n";
	print $fout "		%TODO:insert your data here as a proplilst {key, Value} pairs\n";
	print $fout "	],\n";
	print $fout "	Reply = tst:pubr(Mqtt, Outgoing, Payload),\n";
	print $fout "	ct:log(\"::reply -> ~p~n\", [Reply]),\n";
	print $fout "	Reply.\n";
	print $fout "\n";
	print $fout "\n";
}
