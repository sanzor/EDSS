-module(wsup).
-behaviour(supervisor).
-export([init/0,start/0]).

-define(NAME,?MODULE).

start()->
    supervisor:start_link({loocal,?NAME},[]).

init()->
    ListenSock=gen_tcp:listen(8300),
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
