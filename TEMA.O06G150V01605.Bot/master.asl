// Agent tester in project prueba.mas2j

/* Initial beliefs and rules */

service(Answer, mailing, "He enviado el mensaje como has pedido"):- //true.
	getValTag("<to>",Answer,To) &
	getValTag("<subject>",Answer,Subject) &
	getValTag("<msg>",Answer,Msg) &
	gui.mailing(To,Subject,Msg).
	

service(Answer, botprop, "He editado el archivo de propiedades"):- //true.
	getBotProp(Answer,Name,Val) &
	.concat(Name,":",Aux) &
	.concat(Aux,Val,Devuelta) &
	gui.writingOn(Devuelta,"src/resources/bots/mybot/config/properties.txt").
	
service(Answer,addset,"Archivo set actualizado"):-
	getSetProp(Answer,Value,File)&
	.concat(File,".txt",Path) &
	gui.addValueOnSetFileFor(Value,Path,"myBot").
	
service(Answer,addset,"Archivo set creado"):-
	not getValTag("<new>",Answer,Prop,Value) &
	.concat(Answer,".txt",Path) &
	gui.creatingSetFileFor(Path,"myBot").
	
service(Answer,addmap,"Archivo map actualizado") :-
	getMapProp(Answer,Prop,Value,File) &
	.concat(File,".txt",Path) &
	gui.addRelOnMapFileFor("Prop","Value","evaluacion.txt","myBot").
	
service(Answer,addmap,"Archivo map creado") :-
	not getMapProp(Answer,Prop,Value,File) &
	.concat(Answer,".txt",Path) &
	gui.creatingMapFileFor(Path,"myBot").
	
service(Answer,file,"Archivo creado") :-
	.concat("/",Answer,Path) &
	gui.creatingFile(Path).
	
service(Answer,addtxt,"Archivo Modificado") :-
	getTextProp(Answer,Text,File) & 
	gui.writingOn(Text,File).

getValTag(Tag,String,Val) :- 
	.substring(Tag,String,Fst) &
	.length(Tag,N) &
	.delete(0,Tag,RestTag) &
	.concat("</",RestTag,EndTag) &
	.substring(EndTag,String,End) &
	.substring(String,Val,Fst+N,End).	
	
getSetProp(Answer, Value, File) :-
	.substring("<new>",Answer,Fst) &
	.substring("</new>",Answer,Last) &
	.substring(Answer,Value,Fst+5,Last) &
	.delete(0,Last+6,Answer,File).
	
getMapProp(String,Prop,Value,File) :- 
	.substring("<new>",String,Fst) &
    .substring("</new>",String,End) &
    .substring(String,Cadena,Fst+5,End) &
    .substring(":",String,Del) & 
    .substring(String,Prop,Fst+5,Del) &
	.substring(String,Value,Del+1,End) &
	.delete(Fst,End+6,String,File).
	
getBotProp(String,Name,Val) :- 
	.length(String,M) &
	.substring("</name>",String,Poscname) &
	.delete(Poscname,M,String,Nombre1) &
    .substring("<name>",String,Posname) &
	.delete(0,Posname+6,Nombre1,Name) &
	.substring("</val>",String,Poscval) &
	.delete(Poscval,M,String,Valor1) &
    .substring("<val>",String,Posvale) &
	.delete(0,Posvale+5,Valor1,Val). 	
	
	
getTextProp(String,Name,Val) :- 
	.length(String,M) &
	.substring("</txt>",String,Poscname) &
	.delete(Poscname,M,String,Nombre1) &
    .substring("<txt>",String,Posname) &
	.delete(0,Posname+5,Nombre1,Name) &
	.substring("</file>",String,Poscval) &
	.delete(Poscval,M,String,Valor1) &
    .substring("<file>",String,Posvale) &
	.delete(0,Posvale+6,Valor1,Val) &
	.substring(String,To,Posname+5,Poscname) &
	.substring("to",To). 	
	
	
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
	.delete(L-N-2,L,Answer,MediaCadena) &
	.delete(0,N+1,MediaCadena,Msg).
	
/* Initial goals */


/* Plans */


+answer(Answer) : filter(Answer,"<mail>", Msg) & service(Msg,mailing,Respuesta) <- 
	.send(student, tell, answer(Respuesta)); 
	-answer(Answer);
	.wait(1000).
	
+answer(Answer) : filter(Answer,"<botprop>", Msg) & service(Msg,botprop,Respuesta) <- 
	.send(student, tell, answer(Respuesta)); 
	-answer(Answer);
	.wait(1000).
	
+answer(Answer) : filter(Answer,"<addset>", Msg) & service(Msg,addset,Respuesta) <- 
	.send(student, tell, answer(Respuesta)); 
	-answer(Answer);
	.wait(1000).
	
+answer(Answer) : filter(Answer,"<addmap>", Msg) & service(Msg,addmap,Respuesta) <- 
	.printf(Answer);
	.send(student, tell, answer(Respuesta)); 
	-answer(Answer);
	.wait(1000).	
	
+answer(Answer) : filter(Answer,"<file>", Msg) & service(Msg,file,Respuesta) <- 
	.send(student, tell, answer(Respuesta)); 
	.wait(1000);
	-answer(Answer).	
	
+answer(Answer) : filter(Answer,"<addtxt>", Msg) & service(Msg,addtxt,Respuesta) <- 
	.send(student, tell, answer(Respuesta)); 
	-answer(Answer);
	.wait(1000).	
	
	
+answer(Answer) :filter(Answer,Tag,Msg) & not filter(Answer,"<addtxt>", Msg1) & not filter(Answer,"<botprop>", Msg2)  & not filter(Answer,"<addset>", Msg3)
 & not filter(Answer,"<addmap>", Msg4)  & not filter(Answer,"<file>", Msg5)  & not filter(Answer,"<addtxt>", Msg6)<- 
	.send(student, tell, answer("No se hacer eso")); 
	-answer(Answer);
	.wait(1000).
	
+answer(Answer) : not filter(Answer, Tag, Msg) & numAnswer(N) <- -answer(Answer).	

