-module(wsup).
-behaviour(supervisor).
-export([init/1,start/0]).
-import(gen_tcp,[listen/1]).

-define(NAME,?MODULE).
-define(PORT,8300).

start()->
    supervisor:start_link({local,?NAME},?NAME,[]).

init(Args)->
    Options=[inet,]
    ListenSock=gen_tcp:listen(?PORT,[]),
    SupFlags=#{
        strategy=>simple_one_for_one,
        intensity=>5,
        period=>1000
        },
    ChildSpec=#{
        identity=>{worker,start,[ListenSock]},
        restart=>transient,
        shutdown=>brutal_kill,
        type=>worker
        },
    {ok,{SupFlags,ChildSpec}}.

