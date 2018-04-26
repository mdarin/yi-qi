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
) or die("$usage");

#print $options{"module"} . "\n";
#print $options{"topics"} . "\n";

my $module = $options{"module"};
my @topics = split ",",$options{"topics"};
# каталог с шаблонами
my $templates_dir = File::Spec->catfile(dirname($0), "templates");
my $t_module_dir = File::Spec->catfile($templates_dir, "t_module");
my $module_suite_dir = File::Spec->catfile($templates_dir, "module_SUITE");
my $module_dir = File::Spec->catfile($templates_dir, "module");

print "module: $module\n";

foreach my $topic (@topics) {
	print "topic: $topic\n";
}
print "templates: $templates_dir\n";
print "t_module: $t_module_dir\n";
print "module_SUITE: $module_suite_dir\n";
print "module: $module_dir\n";
#print basename "move/to" . "\n";

my $cargo_root_full_path = dirname $0;

# получить список обработчиков
# Файл модуля тестирования
#	CARGOROOT/test/<module>_SUITE.erl
# Алгоритм:
# открыть файл
my $suite_fname = File::Spec->catfile($cargo_root_full_path, "$module\_SUITE.erl");
my $suite_fout;
open $suite_fout, ">$suite_fname"
	or die "Can't open $suite_fname file:$!";
# вывести зоголовок
&generate_suite_mod_head ($suite_fout, $module, $topic);
# сгенерировать инициализацию перечня групп и тестов
&generate_suite_mod_groups ($suite_fout, $module,\@topics);
# сгенерировать инициализацию для всего модуля теста
&generate_suite_mod_init_suite ($suite_fout, $module, $topic);
# сгенерировать инициализации для групп
&generate_suite_mod_init_group ($suite_fout, $module, $topic);
&generate_suite_mod_last_init_group ($suite_fout, $module, $topic);
# сгенерировать окончания для групп
&generate_suite_mod_end_group ($suite_fout, $module, $topic);
&generate_suite_mod_last_end_group ($suite_fout, $module, $topic);
foreach my $topic (@topics) { 
	# сгенерировать инициализации для тестов для каждой группы
	&generate_suite_mod_init_testcase ($suite_fout, $module, $topic);
	# сгенерировать окончания для тестов для каждой группы
	&generate_suite_mod_end_testcase ($suite_fout, $module, $topic);
}
&generate_suite_mod_last_init_testcase ($suite_fout, $module, $topic);
&generate_suite_mod_last_end_testcase ($suite_fout, $module, $topic);
# сгенерировать окончание для всего модуля теста
&generate_suite_mod_end_suite ($suite_fout, $module, $topic);
foreach my $topic (@topics) {
	# сгенеровароть заготовки тестов
	&generate_suite_mod_fun_clause ($suite_fout, $module, basename $topic);
}
# закрыть файл
close $suite_fout
	or die "Can't close $suite_fname file:$!";

# Файл модуля API функций для тестов
#	CARGOROOT/lib/t_<module>.erl
# Алгоритм
#	открыть файл
my $test_fname = File::Spec->catfile($cargo_root_full_path, "t\_$module.erl");
my $test_fout;
open $test_fout, ">$test_fname"
	or die "Can't open $test_fname file:$!";
# вывести заголовок
&generate_t_mod_head($test_fout, $module);
foreach my $topic (@topics) {
	#	сгенеировать функци API к тестируемому модулoю
	&generate_t_mod_fun_clause($test_fout, $module, $topic);
}
# зкрыть файл
close $test_fout
	or die "Can't open $test_fname file:$!";

# Файл модуля обработчика каналов, реализующего функционал подсистемы
#	CARGOROOT/lib/<module>.erl
#	Алгоритм
#	открыть файл
my $handler_fname = File::Spec->catfile($cargo_root_full_path, "$module.erl");
my $hahdler_fout;
open $handler_fout, ">$handler_fname"
	or die "Can't open $handler_fname file:$!";
#	вывести заголовок
&generate_handler_mod_head($handler_fout, $module); 
#	сгенеировать функци обработчки каналов
my $last_topic = pop @topics;
foreach my $topic (@topics) {
	&generate_handler_mod_fun_clause($handler_fout, $module, $topic);
}
&generate_handler_mod_last_fun_clause($handler_fout, $module, $last_topic);
# вернуть обратно последний топик
push @topics, $last_topic;
#	зкрыть файл
close $handler_fout
	or die "Can't close $handler_fname file:$!";


##
## subroutines for generating CARGOROOT/test/<module>_SUITE.erl
#

sub generate_suite_mod_head {
	my($fout, $module) = @_;
	my $head_fname = File::Spec->catfile($module_suite_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_suite_mod_groups {
	my($fout, $module, $topics) = @_;
	my $groups_fname = File::Spec->catfile($module_suite_dir, "groups.tpl");
	my $fin;
	open $fin, "<$groups_fname"
		or die "Can't open $groups_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		if (m/\$\{tescases\}/) {
			&generate_suite_mod_group_testcases($fout, $topics);
		} else {
			print $fout "$_\n";
		}	
	} <$fin>;
	close $fin
		or die "Can't closse $groups_fname file:$!";
}


sub generate_suite_mod_group_testcases {
	my($fout, $topics) = @_;	
	# перечислить тесты в группе	
	my $last_topic = pop @$topics;
	foreach my $topic (@$topics) {
		print $fout "		" . basename $topic . "\_ok,\n";
	}
	print $fout "		" . basename $last_topic . "\_ok\n";
	push @$topics, $last_topic;
}

sub generate_suite_mod_init_suite {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_suite.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_init_group {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_group.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_last_init_group {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "last_init_group.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_init_testcase {
	my($fout, $module, $topic) = @_;
	my $testcase = basename $topic;
	my $init_fname = File::Spec->catfile($module_suite_dir, "init_testcase.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\$\{testcase\}/$testcase/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_last_init_testcase {
	my($fout, $module) = @_;
	my $init_fname = File::Spec->catfile($module_suite_dir, "last_init_testcase.tpl");
	my $fin;
	open $fin, "<$init_fname"
		or die "Can't open $init_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $init_fname file:$!";
}

sub generate_suite_mod_end_testcase {
	my($fout, $module, $topic) = @_;
	my $testcase = basename $topic;
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_testcase.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\$\{testcase\}/$testcase/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_last_end_testcase {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "last_end_testcase.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}


sub generate_suite_mod_end_group {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_group.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_last_end_group {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "last_end_group.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_end_suite {
	my($fout, $module) = @_;
	my $end_fname = File::Spec->catfile($module_suite_dir, "end_suite.tpl");
	my $fin;
	open $fin, "<$end_fname"
		or die "Can't open $end_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $end_fname file:$!";
}

sub generate_suite_mod_fun_clause {
	my ($fout, $module, $topic) = @_;
	my $function = basename $topic;
	my $testcase = $function;
	my $caseclause_fname = File::Spec->catfile($module_suite_dir, "case_clause.tpl");
	my $fin;
	open $fin, "<$caseclause_fname"
		or die "Can't open $caseclause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{testcase\}/$testcase/;
		s/\S\{function\}/$function/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $caseclause_fname file:$!";
}


##
## subroutines for generating CARGOROOT/lib/t_<module>.elr
#

sub generate_t_mod_head {
	my ($fout, $module) = @_;
	my $head_fname = File::Spec->catfile($t_module_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_t_mod_fun_clause {
	my ($fout, $module, $topic) = @_;
	my $function = basename $topic;
	my $clause_fname = File::Spec->catfile($t_module_dir, "clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		s/\S\{function\}/$function/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}


##
## subroutines for generating CARGOROOT/lib/<module>.er
#

sub generate_handler_mod_head {
	my ($fout,$module) = @_;
	my $head_fname = File::Spec->catfile($module_dir, "head.tpl");
	my $fin;
	open $fin, "<$head_fname"
		or die "Can't open $head_fname file:$!";
	map { chomp; 
		s/\$\{module\}/$module/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $head_fname file:$!";
}

sub generate_handler_mod_fun_clause {
	my ($fout,$module,$topic) = @_;
	my $clause_fname = File::Spec->catfile($module_dir, "clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}

sub generate_handler_mod_last_fun_clause {
	my ($fout,$module,$topic) = @_;
	my $clause_fname = File::Spec->catfile($module_dir, "last_clause.tpl");
	my $fin;
	open $fin, "<$clause_fname"
		or die "Can't open $clause_fname file:$!";
	map { chomp; 
		#TODO: хэш и цикл
		s/\$\{module\}/$module/;
		s/\S\{topic\}/$topic/;
		print $fout "$_\n";	
	} <$fin>;
	close $fin
		or die "Can't closse $clause_fname file:$!";
}
