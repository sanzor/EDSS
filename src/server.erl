-module(server).
-behaviour(gen_server).
-export([handle_call/3,handle_cast/2,terminate/2]).


start()->
    {ok,[]}.

handle_cast(connect,From,State)->
    supervisor:start_child(wsup,[]),
    {noreply,State}.
handle_call(From,Message,State)->
    {noreply,State}.