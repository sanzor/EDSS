%%% Used for forwarding incoming requests to workers
-module(server).
-behaviour(gen_server).

% API

-export([handle_call/3,handle_cast/2,init/1,start/0]).

% MISC

-define(NAME,?MODULE).
-record(state,{
    count=0
}).

% Callbacks

start()->
    gen_server:start_link({local,?NAME},?NAME,[],[]).
init(Args)->
    {ok,#state{count=0}}.
handle_cast(connect,State)->
    wsup:start_child(),
    {noreply,State}.
handle_call(From,Message,State)->
    {noreply,State}.
