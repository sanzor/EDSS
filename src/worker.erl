-module(worker).
-behaviour(gen_server).
%-include("wstate.hrl").
-export([start/1,init/1,handle_cast/2,handle_call/3,gl/1,ga/1,con/3,sn/2]).
-record(wstate,{
    socket,
    messages=[]
    }).

%%%%%%api
start(ListenSock)->
    gen_server:start_link(?MODULE,ListenSock,[]).
gl(Port)->
    {ok,Listen}=gen_tcp:listen(Port,[]),
    Listen.
ga(LSock)->
    {ok,Sock}=gen_tcp:accept(LSock),
    Sock.

sn(Socket,Message)->
    gen_tcp:send(Socket,Message).

con(Adr,Socket,T)->
   {ok,S}= gen_tcp:connect(Adr,Socket,[binary,{active,T}]),
    S.

%%%%%%%

init(LSock)->
    gen_server:cast(self(),'accept'),
    {ok,#wstate{socket=LSock}}.

handle_call(From,Message,State)->
    {noreply,State}.

handle_cast('accept',Wstate=#wstate{socket=S})->
    {ok,Socket}=gen_tcp:accept(S),
    {noreply,Wstate#wstate{socket=Socket}};

handle_cast({tcp,_,Message},State=#wstate{messages=Ms})->
    {noreply,State#wstate{messages=[Message|Ms]}}.



