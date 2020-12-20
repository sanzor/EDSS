%%%-------------------------------------------------------------------
%% @doc wsapp public API
%% @end
%%%-------------------------------------------------------------------

-module(wsapp).

-behaviour(application).

-export([start/2, stop/1]).

start(StartType, _StartArgs) ->
   {ok,Pid}=sup:start_link(),
   {ok,Pid}.


stop(_State) ->
    ok.

%% internal functions
