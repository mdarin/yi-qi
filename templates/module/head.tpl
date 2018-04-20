
sub generate_handler_mod_head {
	my($fout,$module,$topic) = @_;
	print $fout "%%%%----------------------------------------------\n";
	print $fout "%%% Module: ${module} \n";
	print $fout "%%% Description:\n";
	print $fout "%%% Author:\n";
	print $fout "%%% Autogen: Yi qi\n";
	print $fout "%%% wiki page -> [link to wiki or page name]\n";
	print $fout "%%%%----------------------------------------------\n";
	print $fout "-module(${module}).\n";
	print $fout "-compile([export_all]).\n";
	print $fout "\n";
	print $fout "-include(\"cargo_error.hrl\").\n";
	print $fout "\n";
	print $fout "% Подсистема TODO: Добавьте описание реализуемой подсистемы \n";
	print $fout "% MQTT pub: /<Cid>/${module}\n";
	print $fout "% MQTT sub: /<Cid>/res/${module}\n";
	print $fout "\n";
	print $fout "\n";
}
