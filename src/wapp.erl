%%%-------------------------------------------------------------------
%% @doc wsapp public API
%% @end
%%%-------------------------------------------------------------------

-module(wapp).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    sup:start_link({local,sup},sup,[]).

stop(_State) ->
    ok.

%% internal functions
