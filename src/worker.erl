-module(worker).
-behaviour(gen_server).
%-include("wstate.hrl").
-export([start/1,init/1,handle_cast/2,handle_call/3]).
-record(wstate,{
    socket,
    messages=[]
    }).

start(ListenSock)->
    gen_server:start_link(?MODULE,ListenSock,[]).
init(LSock)->
    gen_server:cast(self(),'accept'),
    {ok,#wstate{socket=LSock}}.


handle_call(From,Message,State)->
    {noreply,State}.

handle_cast('accept',Wstate=#wstate{socket=S})->
    {ok,Socket}=gen_tcp:accept(S,[binary,{active,true}]),
    {noreply,Wstate#wstate{socket=Socket}};

handle_cast({tcp,_,Message},State=#wstate{messages=Ms})->
    {noreply,State#wstate{messages=[Message|Ms]}}.



