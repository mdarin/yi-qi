#!/usr/bin/perl -w
#** ------------------------------------------------------------------
# nam: Yi qi - Template generator for CargoNet project 
# vsn: 0.0.1
# dsc: This is a devtool  
# crt: Ср апр 18 17:36:10 MSK 2018
# upd: 
# ath: Michael DARIN, Moscow, Russia, (c) 2018
# lic: gnu>=2, "AS-IS", "NO WARRENTY"
# cnt: darin.m@tvzavr.ru
# 
##
use warnings;
#use strict;
use File::Basename qw(basename dirname);
use File::Spec;
use Getopt::Long;
use autodie;

print "hello yiqi\n";

my $usage = "yiqi [options]\n\n";

# получить аргументы командной строки
my %options;
GetOptions("module=s" => \$options{"module"},
						"topics=s" => \$options{"topics"},
						"cargo-root=s" => \$options{"cargo-root"},
						"log=s" => \$options{"log"},
						"help" => \$options{"help"},
						"usage" => \$options{"usage"},
						"version" => \$options{"version"},
						"silent" => \$options{"silent"},
						"verbose" => \$options{"verbose"},
          )
  or die("$usage");

print $options{"module"} . "\n";

print basename "move/to" . "\n";


# получить список обработчиков
# Файл модуля тестирования
#	CARGOROOT/test/<module>_SUITE.erl
# Алгоритм:
# открыть файл
# вывести зоголовок
# сгенерировать инициализацию для всего модуля теста
# сгенерировать окончание для всего модуля теста
# сгенерировать инициализации для групп
# сгенерировать окончания для групп
# сгенерировать инициализации для тестов для каждой группы
# сгенерировать окончания для тестов для каждой группы
# сгенеровароть заготовки тестов
# закрыть файл

# Файл модуля API функций для тестов
#	CARGOROOT/lib/t_<module>.erl
# Алгоритм
#	открыть файл
# вывести заголовок
&generate_t_mod_head(stdout, "yiqi_test_mod");
#	сгенеировать функци API к тестируемому модулoю
&generate_t_mod_fun_clause(stdout, "yiqi_test_mod", "yiqi_test_topic");
# зкрыть файл
sub generate_t_mod_head {
	my($fout, $module) = @_;
	print $fout "%%%%----------------------------------------------\n";
	print $fout "%%% Module: API $module module for test suite\n";
	print $fout "%%% Desc: \n";
	print $fout "%%% Author:\n";
	print $fout "%%% Autogen: Yi qi\n";
	print $fout "%%% wiki page -> [link to wiki or page name]\n";
	print $fout "%%%%----------------------------------------------\n";
	print $fout "-module(t_$module).\n";
	print $fout "-compile([export_all]).\n";
	print $fout "\n";
	print $fout "% Команды управления подсистемой Добавьте название\n";
	print $fout "\n";
}

sub generate_t_mod_fun_clause {
	my($fout, $module, $topic) = @_;
	print $fout "% MQTT pub:  /<CID>/$module/$topic\n";
	print $fout "% MQTT sub:  /<CID>/$module/res/$topic\n";
	print $fout "\$function(Mqtt) -> %TODO: Довьте требуетмые аргументы фукнции\n";
	print $fout "	Outgoing = <<\"$module/$topic\">>,\n";
	print $fout "	Incomeing = <<\"$module/res/$topic\">>,\n";
	print $fout "	tst:sub(Mqtt, Incomeing),\n";
	print $fout "	Payload = [\n";
	print $fout "		%TODO:insert your data here as a proplilst {key, Value} pairs\n";
	print $fout "	],\n";
	print $fout "	Reply = tst:pubr(Mqtt, Outgoing, Payload),\n";
	print $fout "	ct:log(\"::reply -> ~p~n\", [Reply]),\n";
	print $fout "	Reply.\n";
}

# Файл модуля обработчика каналов, реализующего функционал подсистемы
#	CARGOROOT/lib/<module>.erl
#	Алгоритм
#	открыть файл
#	вывести заголовок
#	сгенеировать функци API к тестируемому модулю
#	зкрыть файл
