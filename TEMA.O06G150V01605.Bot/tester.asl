// Agent tester in project prueba.mas2j

/* Initial beliefs and rules */
numAnswer(1).

service(Answer, translating):- //true.
	checkTag("<translate>",Answer).
	
service(Answer, mailing):- //true.
	checkTag("<mail>",Answer).
	
service(Answer,addRelOnMapFileFor):-
	checkTag("<addmap>",Answer).
	
service(Answer,addValueOnSetFileFor):-
	checkTag("<addset>",Answer).
	
checkTag(String,Answer) :-
	.substring("<translate>",Answer).

checkTag(String,Answer) :-
	.substring("<mail>",Answer).

checkTag(String,Answer) :-
	.substring("<addmap>",Answer).
	
checkTag(String,Answer) :-
	.substring("<addset>",Answer).
	


getTo(String,To) :- //.concat("a b",1,a,X): X unifies with "a b1a".
	.substring("<to>",String,Fst) &
	.substring("</to>",String,End) &
	.substring(String,To,Fst+4,End).
	
getValTag(Tag,String,Val) :- 
	.substring(Tag,String,Fst) &
	.length(Tag,N) &
	.delete(0,Tag,RestTag) &
	.concat("</",RestTag,EndTag) &
	.substring(EndTag,String,End) &
	.substring(String,Val,Fst+N,End).

getMapProp(Tag,String,Prop,Value) :- 
	.substring(Tag,String,Fst) &
    .length(Tag,N) &
    .delete(0,Tag,RestTag) &
    .concat("</",RestTag,EndTag) &
    .substring(EndTag,String,End) &
    .substring(String,Cadena,Fst+N,End) &
    .substring(":",String,Del) & 
    .substring(String,Prop,Fst+N,Del) &
	.substring(String,Value,Del+1,End).

	
/*
filter(Answer, translating("es",To,Msg), "La traducci贸n que me pediste es: "):- //true.
	getValTag("<to>",Answer,To) &
	.string(To) &
	getValTag("<msg>",Answer,Msg) &
	.string(Msg).
*/
filter(Answer, translating, Answered):- //true.
	getValTag("<to>", Answer, To) &
	.string(To) &
	getValTag("<msg>", Answer, Msg) &
	.string(Msg) &
	gui.translating("es", To, Msg, Translation) &
	.concat("La traducci贸n que me pediste es: ", Translation, Answered).
	
filter(Answer, mailing, "Ya he enviado el mensaje como me pediste."):- //true.
	getValTag("<to>",Answer,To) &
	getValTag("<subject>",Answer,Subject) &
	getValTag("<msg>",Answer,Msg) &
	gui.mailing(To,Subject,Msg).
	
filter(Answer,addRelOnMapFileFor,Answered):-
	getMapProp("<new>",Answer,Prop,Value)&
	gui.addRelOnMapFileFor(Prop,Value,"capital.txt","jcBot")&
	.concat("He a馻dido la nueva ciudad", Answered).
	
filter(Answer,addValueOnSetFileFor,Answered):-
	getValTag("<new>",Answer,Value)&
	gui.addValueOnSetFileFor(Value,"pais.txt","jcBot")&
	.concat("He a馻dido el nuevo pais", Answered).
	
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

+answer(Answer) : service(Answer, mailing) & filter(Answer, mailing, Answered) & numAnswer(N) <- 
	-+numAnswer(N+1);
	//gui.translating(From, To, Msg, Translation);
	+respuesta(N, Answered);
	.println("=======================================================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ", Answered);
	.println;
	.println("=======================================================================");
	.wait(1000).
	
+answer(Answer):service(Answer, addRelOnMapFileFor) & filter(Answer, addRelOnMapFileFor, Answered) & numAnswer(N)<-
	-+numAnswer(N+1);
	+respuesta(N, Answered);
	.println("=======================================================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ", Answered);
	.println;
	.println("=======================================================================");
	.wait(1000).
	
+answer(Answer):service(Answer, addValueOnSetFileFor) &  filter(Answer, addValueOnSetFileFor, Answered) & numAnswer(N)<-
	-+numAnswer(N+1);
	+respuesta(N, Answered);
	.println("=======================================================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ", Answered);
	.println;
	.println("=======================================================================");
	.wait(1000).
	
+answer(Answer) : not service(Answer,Service) & numAnswer(N) <- 
	-+numAnswer(N+1);
	+respuesta(N,Answer);
	.println("===============================================");
	.println;
	.println("Acabo de recibir del bot la contestacion: ",Answer);
	.wait(1000);
	.println;
	.println("===============================================").
	
	
/*
;
	chat("Hola, hay alguien?");
	.wait(500);
	chat("Yo estoy bien, que tal tu?");
	.wait(500);
	chat("Me llamo juan carlos.");
	.wait(500);
	chat("Como dices que te llamas?");
	.wait(500);
	chat("Puedes decirme cual es tu edad?");
	.wait(500);
	chat("Donde vives?");
	.wait(500);
	chat("Te acuerdas como me llamo?");
	.wait(500);
	chat("Sabes cual es la capital de Francia");
	.wait(500);
	chat("Cual es la capital de austria");
	.wait(500);
	chat("La capital de Austria es Viena");
	.wait(500);
	chat("Dime cual es la capital de Austria");
	.wait(500);
	chat("DIALOGDONE");
	.wait(1000);
	chat("marc tiene los ojos negros y el pelo pelirrojo");
	.wait(1000);
	chat("Puedes decirme cual es tu email");
	.wait(500);
	chat("Puedes decirme cual es tu email");
	.wait(500);
	chat("Cual es el color de ojos de Andrew. Y cual es el color de pelo de Marc");
	.wait(500);
	chat("Cual es el color de pelo de marc");
	.wait(500);
	chat("marc tiene los ojos negros y el pelo pelirrojo");
	.wait(1000);
	chat("LATEST");
	.wait(1000);
	gui.creatingSetFileFor("peliculas.txt","jcBot");
	gui.writingOn("El retorno del Jedi","src/resources/bots/jcBot/sets/peliculas.txt");
	gui.writingOn("El Imperio contrataca","src/resources/bots/jcBot/sets/peliculas.txt");
	gui.creatingMapFileFor("imparte.txt","jcBot");
	gui.writingOn("jcmoreno : sistemas inteligentes","src/resources/bots/jcBot/maps/imparte.txt");	
	// este c贸digo envia un mensaje de correo electronico a la cuenta indicada 
	// de entrada se est谩 utilizando una cuenta fantasma para ello, pero a lo 
	// largo del desarrollo de la practica 2 se espera que se envie desde la
	// cuenta asociada al bot, para lo cual modificaremos los par谩metros de la 
	// funci贸n o crearemos una funci贸n nueva
	gui.mailing("jcmoreno@uvigo.es","Prueba","Se ha terminado la prueba de uso de <learn>")
		.println("Creando el conjunto asignaturas");
	gui.creatingSetFileFor("asignaturas.txt","jcBot");
	.println;
	gui.addValueOnSetFileFor("Sistemas Inteligentes","asignaturas.txt","jcBot");
	.println;
	
	.println("Creando el map imparte");
	gui.creatingMapFileFor("imparte.txt","jcBot");
	.println;
	gui.addRelOnMapFileFor("Juan Carlos Gonz谩lez Moreno","Sistemas Inteligentes","imparte.txt","jcBot");
	.println;
	
	//gui.writingOn("El retorno del Jedi","src/resources/bots/jcBot/sets/peliculas.txt");
	//gui.writingOn("El Imperio contrataca","src/resources/bots/jcBot/sets/peliculas.txt");
	//gui.creatingMapFileFor("imparte.txt","jcBot");
	//gui.writingOn("jcmoreno : sistemas inteligentes","src/resources/bots/jcBot/maps/imparte.txt");	
	// este c贸digo envia un mensaje de correo electronico a la cuenta indicada 
	// de entrada se est谩 utilizando una cuenta fantasma para ello, pero a lo 
	// largo del desarrollo de la practica 2 se espera que se envie desde la
	// cuenta asociada al bot, para lo cual modificaremos los par谩metros de la 
	// funci贸n o crearemos una funci贸n nueva
	
	gui.mailing("jcmoreno@uvigo.es","Prueba","Acabo de crear nuevos ficheros set y map.");
	.println;
	
	chat("sabias que hoy hay tutorias de SI");
	.wait(500);
	
	chat("Un jato es un gato y un home es un hombre");
	.wait(500);
	

*/
