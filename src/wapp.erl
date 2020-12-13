%%%-------------------------------------------------------------------
%% @doc wsapp public API
%% @end
%%%-------------------------------------------------------------------

-module(wapp).

-behaviour(application).

-export([start/2, stop/1]).

start(StartType, _StartArgs) ->
   sup:start_link().


stop(_State) ->
    ok.

%% internal functions
