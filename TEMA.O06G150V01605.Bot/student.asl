// Agent tester in project prueba.mas2j

/* Initial beliefs and rules */
numAnswer(1).

//este codigo funciona correctamente para etiquetas xml con pocos anidamientos 
//no se asegura la salida con mas de 4 etiquetas anidadas

filter(Answer,Tag,Msg) :- 
	.length(Answer,L) &
	.substring("<",Answer,0) &
	.substring(">",Answer,N)&
	.substring("</",Answer,L-N-1) &
	.delete(N+1,L,Answer,Tag) &
	.substring(Tag,Answer,0) &
	.delete(0,Tag,ResTag) &
	.concat("</",ResTag,EndTag) &
	.substring(EndTag,Answer,L-N-1) &
	.delete(L-N-1,L,Answer,MediaCadena) &
	.delete(0,N+1,MediaCadena,Msg).
	
	
/* Initial goals */

!start.

/* Plans */

+!start <- 
	chat("Hola, hay alguien?");
	.wait(500);
	chat("Yo estoy bien, que tal tu?");
	.wait(500);
	chat("Juan tiene los ojos verdes");
	.wait(500);
	chat("Maria tiene el pelo azul");
	.wait(500);
	chat("Mis amigos son Juan, Lola y Pepe");
	.wait(500);
	chat("Me gustaria que recordaras que David es un pais");
	.wait(500);
	chat("Puedes repetirme el dialogo de las ultimas 3 interpelaciones");
	.wait(500);
	chat("Me gustaria que recordaras que la capital de Niger es Niamey");
	.wait(500);
	chat("Envia el siguiente mensaje con tema prueba a brais : probando aiml");
	.wait(500).

+answer(Answer) : filter(Answer, Tag, Msg) & numAnswer(N) <- 
	-+numAnswer(N+1);
	+respuesta(N, Answer);
	.println("=======================================================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ", Answer);
	.println("Encuentro el texto: ",Msg, " entre las etiquetas ", Tag);
	.println;
	.println("=======================================================================");
	.wait(1000).

+answer(Answer) : not filter(Answer, Tag, Msg) & numAnswer(N) <- 
	-+numAnswer(N+1);
	+respuesta(N, Answer);
	.println("=======================================================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ", Answer);
	.println;
	.println("=======================================================================");
	.wait(1000).

