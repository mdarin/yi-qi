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
use strict;
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
#	сгенеировать функци API к тестируемому модулю
# зкрыть файл

# Файл модуля обработчика каналов, реализующего функционал подсистемы
#	CARGOROOT/lib/<module>.erl
#	Алгоритм
#	открыть файл
#	вывести заголовок
#	сгенеировать функци API к тестируемому модулю
#	зкрыть файл
