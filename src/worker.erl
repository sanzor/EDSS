-module(worker).
-behaviour(gen_server).
%-include("wstate.hrl").
-export([start/1,init/1,
        handle_cast/2,handle_call/3,handle_info/2,
        gl/1,ga/1,con/3,sn/2,st/1,cl/1]).
-record(wstate,{
    socket,
    messages=[],
    incr=0
    }).

%%%Api
start(ListenSock)->
    gen_server:start_link(?MODULE,ListenSock,[]).

st(ListenSock)->
    L=worker:gl(ListenSock),
    {ok,P}=worker:start(L),
    {L,P}.
%%% Utilities

cl(Socket)->gen_tcp:close(Socket).

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

handle_call(Message,From,State)->
    {reply,State,State}.

handle_cast('accept',Wstate=#wstate{socket=S})->
    {ok,Socket}=gen_tcp:accept(S),
    {noreply,Wstate#wstate{socket=Socket}}.

handle_info({tcp,_,Message},State=#wstate{messages=Ms,socket=S,incr=I})->
    Nm=[Message|Ms],
    St=case Message of
        state  -> sn(S,State),
                  State#wstate{messages=Nm};
        incr   -> State#wstate{messages=Nm,incr=I+1};
        decr   -> State#wstate{messages=Nm,incr=I-1};
        _      -> sn(S,erlang:term_to_binary("Unknwon message"++Message)),
                  State#wstate{messages=Nm}
    end,
    {noreply,St}.



