-module(server).
-behaviour(gen_server).
-export([handle_call/3,handle_cast/2,init/1,start/0]).

-record(state,{
    count=0
}).

-define(NAME,?MODULE).

start()->
    gen_server:start_link({local,?NAME},?NAME,[],[]).
init(Args)->
    {ok,#state{count=0}}.
handle_cast(connect,State)->
    supervisor:start_child(wsup,[]),
    {noreply,State}.
handle_call(From,Message,State)->
    {noreply,State}.
