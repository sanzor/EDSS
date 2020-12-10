-module(server).
-behaviour(gen_server).
-export([start/0,handle_call/3]).


start()->
    {ok,[]}.

handle_cast(connect,From,State)->
    supervisor:start_child(wsup,[]),
    {noreply,State}.
handle_call(From,Message,State)->
    {noreply,State}.

terminate(Reason,State)->
    {ok,State}.