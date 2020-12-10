-module(wsup).
-behaviour(supervisor).
-export([init/1,start/0]).
-import(gen_tcp,[listen/1]).

-define(NAME,?MODULE).
-define(PORT,8300).

start()->
    supervisor:start({local,?NAME},?NAME,[]).

start_link()->
    supervisor:start_link({local,?NAME},?NAME,[]).

init(Args)->
    case gen_tcp:listen(?PORT,[]) of
        {ok,L}->
            SupFlags=#{strategy=>simple_one_for_one,intensity=>5,period=>1000},
            ChildSpec=#{id=>worker,start=>{worker,start,[L]},restart=>transient,shutdown=>brutal_kill,type=>worker,modules=>[worker]},
            {ok,{SupFlags,[ChildSpec]}};
        Error->exit(socket_error)
    end.

