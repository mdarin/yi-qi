%%%%----------------------------------------------
%%% Module: ${module} test suite 
%%% Description:
%%% Author:
%%% Autogen: Yi qi
%%% wiki page -> [link to wiki or page name]
%%%%----------------------------------------------
% NOTE:
% module name must conitain _SUITE postfix
% your_module_name_SUITE.erl
-module(${module}_SUITE).
% this header is required
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").
-include_lib("tst.hrl").

-export([all/0]).
-compile([{parse_transform, lager_transform}]).


% можно заменить на:
% {Saver, SavedConfig} = ?config(saved_config, Config) ~ SavedConfig = ?LOAD,
% {save_config, SaveConfig} ~ ?SAVE(SavedConfig)


