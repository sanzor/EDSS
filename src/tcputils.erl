%%% @author Adrian Bercovici
%%% @description wrapper methods around gen_tcp for ease of use
%%% 
-module(tcputils).
-export([gl/1,ga/1,con/3,sn/2,cl/1]).

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
