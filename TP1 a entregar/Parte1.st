WAComponent subclass: #HeaderComponent	instanceVariableNames: ''	classVariableNames: ''	package: 'Parte1-UI'!!HeaderComponent methodsFor: 'rendering' stamp: 'tom 4/16/2020 20:18'!renderLogout:aCanvas
aCanvas section id: 'encabezado'; with:[
	aCanvas heading class: 'logo';with: 'CuOOra'.
aCanvas span class:'conectadocomo';with:[
	aCanvas break .
	aCanvas span class:'nombre';with:(self session user nombre),' '.
	aCanvas anchor class:'logout';callback:[self session user: nil .self answer ];with:'Log out'. 
	]
].
aCanvas section class: 'clearboth'.
aCanvas horizontalRule .! !!HeaderComponent methodsFor: 'initialization' stamp: 'Anonymous 5/4/2020 20:57'!initialize	super initialize.! !HeaderComponent subclass: #CrearPreguntasComponent	instanceVariableNames: 'titulo texto topicos pregunta topico error'	classVariableNames: ''	package: 'Parte1-UI'!!CrearPreguntasComponent methodsFor: 'hook' stamp: 'Anonymous 4/18/2020 17:59'!style	^ '
	
	*{
		font-family: Calibri;
	}
	
	.logo{
		display: inline;
		float: left;
	}
	
	.conectadocomo{
		float:right;
		font-size: 20px;
	}
	
	.nombre{
		font-weight: bold;
	}
	
	.clearboth{
		clear:both;
	}
	
	input{
		border: 1px solid gray;
		padding-left: 5px;
		height: 20px;
		border-radius: 6px;
		margin-left:10px;
		width: 50%;
	}
	
	button{
		border: 1px solid black;
		background-color: white;
		margin-left: 10px;
		padding: 5px;
	}
	
	.logout{
		color:white;
		background-color: #AA0000;
		padding: 5px;
		border: 1px solid black;
		text-decoration: none;
	}
	
	textarea{
		border: 1px solid gray;
		padding-left: 5px;
		height: 100px;;
		border-radius: 6px;
		margin-left:10px;
		width: 50%;
	}	.rojo{		color:red;	}
	'! !!CrearPreguntasComponent methodsFor: 'initialization' stamp: 'Anonymous 4/18/2020 17:58'!initialize	super initialize.	error := false.! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:01'!verificarError: canvas	error		ifTrue: [ canvas heading				level: 4;				with: 'Debe llenar todos los campos.'.			canvas heading				class: 'rojo';				level: 3;				with: 'DEBE COMPLETAR TODOS LOS CAMPOS PARA CONTINUAR!!' ]! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:02'!mostrarFormulario: canvas	canvas		form: [ canvas				paragraph: [ canvas label: 'Titulo'.					canvas textInput						on: #titulo of: self;						placeholder: 'Escriba aqui el titulo de su pregunta' ].			canvas				paragraph: [ canvas label: 'Desarrollo'.					canvas textArea						on: #texto of: self;						placeholder: 'Escriba aqui el desarrollo de su pregunta.' ].			canvas textInput				on: #topicos of: self;				placeholder: 'Ingrese topicos separados por coma.'.			canvas button				callback: [ self cancelar ];				with: 'Cancelar'.			canvas button				callback: [ self continuar ];				with: 'Guardar' ]! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:03'!renderContentOn: canvas	self renderLogout: canvas.	canvas heading: 'Nueva Pregunta'.	canvas horizontalRule.	self verificarError: canvas.	self mostrarFormulario: canvas.! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'Anonymous 5/4/2020 19:27'!continuar	titulo = '' | (topicos = '')		ifTrue: [ error:= true. ^ false ].	topicos := topicos splitOn: ','.	"Tenemos una Collection de nombres  de topicos."	topicos := topicos		collect: [ :ea | CuOOra soleInstance existeTopico: ea ].	"Le pedimos a CuOOra que nos dé solo los que existen"	topicos := topicos select: [ :ea | ea notNil ].	"Los nil no los queremos"	CuOOra soleInstance		agregarTituloPregunta: titulo		descripcion: texto		usuario: self session user		topicos: topicos.	self answer! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:59'!topicos:anObject 
topicos:= anObject! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 04:05'!cancelar
	titulo := nil.
	texto := nil.
	topicos := nil.
	pregunta := nil.
	self answer.! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!titulo: atitulo
titulo :=atitulo ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!texto 
^texto ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:56'!titulo 
^titulo ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!texto: atexto 
texto:=atexto ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:58'!topicos 
^topicos! !HeaderComponent subclass: #PreguntasRenderer	instanceVariableNames: 'preguntas'	classVariableNames: ''	package: 'Parte1-UI'!!PreguntasRenderer methodsFor: 'initialization' stamp: 'Anonymous 5/4/2020 21:20'!initialize	super initialize! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:43'!renderPregunta: aCanvas pregunta: pregunta	self mostrarTitulo: pregunta con: aCanvas.	self mostrarTopicos: pregunta con: aCanvas.	self mostrarVotos: pregunta con: aCanvas.	self mostrarReacciones: pregunta con: aCanvas.	aCanvas horizontalRule! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:34'!mostrarTopicos: preg con: aCanvas	aCanvas paragraph		class: 'topicos';		with: [ aCanvas				text: 'Topicos:';				space.			aCanvas				text: (', ' join: (preg topicos collect: [ :topi | topi nombre ])) ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:46'!renderRespuestas: canvas pregunta: pregunta	canvas		unorderedList: [ (CuOOra soleInstance obtenerRespuestasDePregunta: pregunta)				do: [ :rta | 					canvas strong: 'Respuesta de '.	" rta usuario nombre."					canvas anchor						class: 'preguntas';						callback: [ self verUsuario: rta usuario ];						with: rta usuario nombre.					canvas paragraph with: [ canvas text: rta texto ].					canvas paragraph						with: [ canvas								text: rta likes size asString;								text: ' likes | ';								text: rta dislikes size asString;								text: ' dislikes' ].					self mostrarReacciones: rta con: canvas.					canvas horizontalRule ] ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:23'!verPregunta: preg	self call: (DetallesPreguntaComponent pregunta: preg).	self session user ifNil: [ self answer ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:23'!verUsuario: user	self call: (PerfilUserComponent usuario: user).	self session user ifNil: [ self answer ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:36'!mostrarReacciones: preg con: aCanvas	aCanvas paragraph		with: [ aCanvas anchor				class: 'reaccionLike';				callback: [ CuOOra soleInstance darLikeA: preg usuario: self session user ];				with: 'like'.			aCanvas				space;				text: '|';				space.			aCanvas anchor				callback: [ CuOOra soleInstance darDisLikeA: preg usuario: self session user ];				class: 'reaccionDislike';				with: 'dislike' ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:33'!mostrarTitulo: preg con: aCanvas	aCanvas anchor		class: 'preguntas';		callback: [ self verPregunta: preg ];		with: preg titulo! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:36'!renderPreguntas: aCanvas preguntas: lasPreguntas	aCanvas		unorderedList: [ lasPreguntas				do: [ :preg | 					aCanvas						listItem: [ self mostrarTitulo: preg con: aCanvas.							self mostrarTopicos: preg con: aCanvas.							self mostrarVotos: preg con: aCanvas.							self mostrarReacciones: preg con: aCanvas.							aCanvas horizontalRule ] ] ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:35'!mostrarVotos: preg con: aCanvas	aCanvas paragraph		with: [ aCanvas text: 'Realizada por '.			aCanvas space.			aCanvas strong				with: [ aCanvas anchor						callback: [ self verUsuario: preg usuario ];						with: preg usuario nombre ].			aCanvas space.			aCanvas text: '|'.			aCanvas space.			aCanvas text: preg respuestas size asString , ' respuestas' ].	aCanvas paragraph		with: [ aCanvas				text: preg likes size asString;				space;				text: 'Likes';				space;				text: '|';				space;				text: preg dislikes size asString;				space;				text: 'Dislikes' ]! !PreguntasRenderer subclass: #DetallesPreguntaComponent	instanceVariableNames: 'pregunta'	classVariableNames: ''	package: 'Parte1-UI'!!DetallesPreguntaComponent methodsFor: 'hook' stamp: 'Anonymous 4/10/2020 21:21'!style
	^ '
	
	*{
		font-family: Calibri;
	}
	
	p{
		margin-top: 0px;
		margin-bottom: 3px;
	}
	
	.logo{
		display: inline;
		float: left;
	}
	
	.conectadocomo{
		float:right;
		font-size: 20px;
	}
	
	.nombre{
		font-weight: bold;
	}
	
	.clearboth{
		clear:both;
	}
	
	.reaccionLike{
		color: green;
		font-weight: bold;
		text-decoration:none;
	}
	
	.reaccionDislike{
		color: red;
		font-weight: bold;
		text-decoration: none;
	}
	.preguntas{
		color:black;
		font-style:oblique;
		text-decoration: none;
		font-size: 24px;
	}
	
	.agregarRespuesta{
		background-color: #3B3B3B;
		color:white;
		border: 1px solid black;
		padding: 5px;
		text-decoration:none;
	}
	
	.logout{
		color:white;
		background-color: #AA0000;
		padding: 5px;
		border: 1px solid black;
		text-decoration: none;
	}
	
	.plus{
		background: #037200;
		padding: 5px;
		margin: 5px;
	}
	'.! !!DetallesPreguntaComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:39'!renderContentOn: canvas	"asumimos que el encabezado y la pregunta con like y dislikes ya esta , ponemos las respuestas de la misma"	self renderLogout: canvas.	self renderPregunta: canvas pregunta:pregunta.	self renderRespuestas: canvas pregunta:pregunta.	canvas paragraph: 'No hay mas respuestas'.	self renderCrearRespuesta: canvas! !!DetallesPreguntaComponent methodsFor: 'rendering' stamp: 'Anonymous 4/10/2020 20:56'!renderCrearRespuesta: canvas
	canvas
		paragraph: [ canvas anchor class:'agregarRespuesta';
				callback: [ self crearRespuesta ];
				with:[
					canvas span class:'plus';with:'+'.
					canvas span:'Agregar Respuesta'.
					].
				].! !!DetallesPreguntaComponent methodsFor: 'initialization' stamp: 'tom 4/19/2020 14:48'!initialize	super initialize.! !!DetallesPreguntaComponent methodsFor: 'accessing' stamp: 'tom 4/8/2020 13:11'!pregunta: aObject
pregunta :=aObject ! !!DetallesPreguntaComponent methodsFor: 'accessing' stamp: 'tom 4/8/2020 13:11'!pregunta
^pregunta ! !!DetallesPreguntaComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:18'!logOut
self session user: nil.
self answer ! !!DetallesPreguntaComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:23'!crearRespuesta
self call: (ResponderPregComponent pregunta: pregunta ) .
(self session user  )ifNil: [self answer ]! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!DetallesPreguntaComponent class	instanceVariableNames: ''!!DetallesPreguntaComponent class methodsFor: 'accessing' stamp: 'tom 4/8/2020 13:12'!pregunta:aObjetc
^self new
pregunta: aObjetc ;yourself ! !PreguntasRenderer subclass: #InicioComponent	instanceVariableNames: 'cuoora'	classVariableNames: ''	package: 'Parte1-UI'!!InicioComponent methodsFor: 'hook' stamp: 'Anonymous 4/10/2020 21:18'!style
	^ '
	
	*{
		font-family: Calibri;
	}
	
	p{
		margin-bottom: 0px;
		margin-top: 0px;
	}
	
	.logo{
		display: inline;
		float: left;
		font-size: 36px;
	}
	
	.conectadocomo{
		float:right;
		font-size: 20px;
	}
	
	.nombre{
		font-weight: bold;
	}
	
	.clearboth{
		clear:both;
	}
	
	.reaccionLike{
		color: green;
		font-weight: bold;
		text-decoration:none;
	}
	
	.reaccionDislike{
		color: red;
		font-weight: bold;
		text-decoration: none;
	}
	.preguntas{
		color:black;
		font-style:oblique;
		font-size: 24px;
		text-decoration: none;
	}
	
	.crearPregunta{
		background-color: #3B3B3B;
		color:white;
		border: 1px solid black;
		padding: 5px;
		text-decoration:none;
	}
	
	.logout{
		color:white;
		background-color: #AA0000;
		padding: 5px;
		border: 1px solid black;
		text-decoration: none;
	}
	
	.plus{
		background: #037200;
		padding: 5px;
		margin: 5px;
	}
	
	.topicos{
		font-style: italic;
		color:gray;
	}
	
	
	'.! !!InicioComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:05'!crearPregunta: aCanvas	aCanvas		paragraph: [ aCanvas anchor				class: 'crearPregunta';				callback: [ self crearPregunta ];				with: [ aCanvas span						class: 'plus';						with: '+'.					aCanvas span: 'Crear nueva pregunta' ] ]! !!InicioComponent methodsFor: 'rendering' stamp: 'Anonymous 4/10/2020 21:06'!crearPregunta
	self call: CrearPreguntasComponent new.
	self session user ifNil: [ self answer  ]! !!InicioComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 11:19'!initialize 
super initialize ! !!InicioComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:26'!renderContentOn: aCanvas	self renderLogout: aCanvas.	self crearPregunta: aCanvas.	self renderPreguntas:aCanvas preguntas:(CuOOra soleInstance obtenerPreguntasRelevantesDe: self session user).! !!InicioComponent methodsFor: 'accesing' stamp: 'tom 4/7/2020 16:16'!cuoora
^ CuOOra soleInstance .! !PreguntasRenderer subclass: #PerfilUserComponent	instanceVariableNames: 'usuario'	classVariableNames: ''	package: 'Parte1-UI'!!PerfilUserComponent methodsFor: 'hooks' stamp: 'Anonymous 4/14/2020 01:55'!style 
^	'
	
	*{
		font-family: Calibri;
	}
	
	p{
		margin-bottom: 0px;
		margin-top: 0px;
	}
	
	.logo{
		display: inline;
		float: left;
		font-size: 36px;
	}
	
	.conectadocomo{
		float:right;
		font-size: 20px;
	}
	
	.nombre{
		font-weight: bold;
	}
	
	.clearboth{
		clear:both;
	}
	
	.reaccionLike{
		color: green;
		font-weight: bold;
		text-decoration:none;
	}
	
	.reaccionDislike{
		color: red;
		font-weight: bold;
		text-decoration: none;
	}
	.preguntas{
		color:black;
		font-style:oblique;
		font-size: 24px;
		text-decoration: none;
	}
	
	.logout{
		color:white;
		background-color: #AA0000;
		padding: 5px;
		border: 1px solid black;
		text-decoration: none;
	}
	
	.topicos{
		font-style: italic;
		color:gray;
	}
	
	.reaccionLike{
		color: green;
		font-weight: bold;
		text-decoration:none;
	}
	
	.reaccionDislike{
		color: red;
		font-weight: bold;
		text-decoration: none;
	}
	
	'.! !!PerfilUserComponent methodsFor: 'initialization' stamp: 'tom 4/19/2020 14:48'!initialize	super initialize.! !!PerfilUserComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 04:47'!usuario: auser
usuario :=auser ! !!PerfilUserComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:29'!renderContentOn: canvas	self renderLogout: canvas.	canvas paragraph		with: [ canvas heading with: 'Preguntas de ' , usuario nombre.			canvas space.			usuario = self session user				ifFalse: [ canvas anchor						callback: [ CuOOra soleInstance unUsuario: self session user sigueA: usuario ];						with: 'follow' ] ].	canvas break.	self renderPreguntas: canvas preguntas: (CuOOra soleInstance todasLasPreguntasDe: usuario).! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!PerfilUserComponent class	instanceVariableNames: ''!!PerfilUserComponent class methodsFor: 'accessing' stamp: 'tom 4/10/2020 04:47'!usuario:auser
^self new usuario: auser ;yourself ! !PreguntasRenderer subclass: #ResponderPregComponent	instanceVariableNames: 'pregunta texto'	classVariableNames: ''	package: 'Parte1-UI'!!ResponderPregComponent methodsFor: 'initialization' stamp: 'tom 4/19/2020 14:48'!initialize	super initialize.! !!ResponderPregComponent methodsFor: 'callbacks' stamp: 'tom 4/8/2020 19:51'!guardar 
CuOOra soleInstance agregarTextoRespuesta: texto  aLaPregunta: pregunta   usuario: self session user .
self answer ! !!ResponderPregComponent methodsFor: 'callbacks' stamp: 'tom 4/8/2020 19:51'!cancelar
texto :=nil.
self answer ! !!ResponderPregComponent methodsFor: 'hook' stamp: 'Anonymous 4/10/2020 21:01'!style
	^ '
	
	*{
		font-family: Calibri;
	}
	
	.logo{
		display: inline;
		float: left;
	}
	
	.conectadocomo{
		float:right;
		font-size: 20px;
	}
	
	.nombre{
		font-weight: bold;
	}
	
	.clearboth{
		clear:both;
	}

	textarea{
		height: 100px;
		width: 50%;
		border-radius: 5px;
		border: 1px solid gray;
	}
	
	button{
		background-color: #3B3B3B;
		margin-right:10px;
		padding: 7px;
		color:white;
	}
	
	.logout{
		color:white;
		background-color: #AA0000;
		padding: 5px;
		border: 1px solid black;
		text-decoration: none;
	}
	
	.reaccionLike{
		color: green;
		font-weight: bold;
		text-decoration:none;
	}
	
	.reaccionDislike{
		color: red;
		font-weight: bold;
		text-decoration: none;
	}
	'.! !!ResponderPregComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:38'!renderContentOn: canvas	self renderLogout: canvas.	self renderPregunta: canvas pregunta:pregunta.	canvas		form: [ canvas				paragraph: [ canvas label: 'RESPONDER '.					canvas textArea						on: #texto of: self;						placeholder: 'Escriba aqui el texto de su respuesta.' ].			canvas button				callback: [ self cancelar ];				with: 'Cancelar'.			canvas button				callback: [ self guardar ];				with: 'Guardar' ]! !!ResponderPregComponent methodsFor: 'accessing' stamp: 'tom 4/8/2020 19:42'!texto:atexto
texto:=atexto ! !!ResponderPregComponent methodsFor: 'accessing' stamp: 'tom 4/8/2020 19:36'!pregunta:aobjet
pregunta :=aobjet ! !!ResponderPregComponent methodsFor: 'accessing' stamp: 'tom 4/8/2020 19:42'!texto 
^texto! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!ResponderPregComponent class	instanceVariableNames: ''!!ResponderPregComponent class methodsFor: 'accessing' stamp: 'tom 4/8/2020 19:35'!pregunta: apregunta
^self new 
pregunta: apregunta! !WASession subclass: #SessionWithUser	instanceVariableNames: 'user'	classVariableNames: ''	package: 'Parte1-UI'!!SessionWithUser methodsFor: 'accessing' stamp: 'tom 4/16/2020 09:54'!user: objetUser
user:= objetUser ! !!SessionWithUser methodsFor: 'accessing' stamp: 'tom 4/16/2020 09:53'!user 
^user! !WAComponent subclass: #UiLoginComponent	instanceVariableNames: 'usuario contrasena'	classVariableNames: ''	package: 'Parte1-UI'!!UiLoginComponent commentStamp: 'Anonymous 4/18/2020 23:14' prior: 0!Para registrar la aplicación:app := WAAdmin register: UiLoginComponent asApplicationAt: 'cuoora'.app sessionClass: SessionWithUser.!!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/16/2020 09:58'!renderContentOn: aCanvas
aCanvas form class:'formulario';with: [
	aCanvas heading:'CuOOra'.
aCanvas paragraph: [ aCanvas label: 'Usuario:  '.
aCanvas textInput on:#usuario of:self].
aCanvas paragraph:  [aCanvas label: 'Contraseña: '.
aCanvas passwordInput on:#contrasena of:self].
aCanvas submitButton class:'btn-primary';callback: [ self iniciarSesion ];with: 'Iniciar Sesion'. 
]! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 10:28'!usuario: aUser
usuario :=aUser! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 10:27'!contrasena
^contrasena ! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 10:59'!proceder:aUser
self session user:aUser.
self call: InicioComponent new ! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 11:14'!modelo
^CuOOra soleInstance! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 10:28'!contrasena:aContra
contrasena :=aContra! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/10/2020 04:14'!iniciarSesion
(self modelo existeUsuario:usuario con:contrasena)
ifNotNil: [ :it| self proceder:it] .

usuario :=nil.
contrasena :=nil.
! !!UiLoginComponent methodsFor: 'rendering' stamp: 'tom 4/7/2020 10:27'!usuario
^usuario ! !!UiLoginComponent methodsFor: 'initialization' stamp: 'tom 4/7/2020 10:24'!initialize 
super initialize.! !!UiLoginComponent methodsFor: 'hooks' stamp: 'Anonymous 4/10/2020 20:30'!style 
	 ^ '
	*{
		font-family: calibri;
	}
	
	body{
	
		text-align: center;
	}

	.btn-primary{
		background-color: #007bff;
		padding: 10px;
		border: 0px;
		border-radius: 3px;
		color:white;
		height:auto;
	}
	
	.formulario{
		width: 70%;
		margin: 0 auto;
		height: auto;
		display:inline-block;
		padding: 20px;
	}

	input{
		border: 1px solid gray;
		padding-left: 5px;
		height: 20px;
		border-radius: 6px;
	}


'! !TestCase subclass: #CuOOraTest	instanceVariableNames: 'cuoora topicos1 general pregunta1 tomas jose alan pregunta2'	classVariableNames: ''	package: 'Parte1-Tests'!!CuOOraTest methodsFor: 'running' stamp: 'tom 5/9/2020 10:33'!testUnUsuarioSigueA	"usuarios creado en setUp"	cuoora unUsuario: jose sigueA: alan.	self assert: jose seguidos size equals: 1.	! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/4/2020 18:53'!testBorrarPregunta	pregunta1 borrarme.	"Tomas tenia una respuesta en la pregunta1, esa respuesta ya no deberia existir..."	self assert: tomas respuestas size equals: 0.	"usuario jose tenia dos preguntas, ahora tiene 1."	self assert: jose preguntas size equals: 1.	"El topicos scify tenia una pregunta, ahora tiene 0"	self assert: (cuoora existeTopico: 'scify') preguntas size equals: 0! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/4/2020 19:29'!testAgregarTextoRespuestaALaPreguntaUsuario	cuoora		agregarTextoRespuesta: 'Esa pregunta es ofensiva y va a ser borrada.'		aLaPregunta: pregunta2		usuario: alan.	self		assert: (cuoora obtenerRespuestasDePregunta: pregunta2) size		equals: 1! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 4/2/2020 15:06'!testObtenerRespuestasDePregunta
	"Se respondió en setUp"
	self assert: (pregunta1 respuestas size) equals: 1.! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 4/2/2020 15:10'!testTodasLasPreguntasDe
	^ jose preguntas .! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 16:50'!testObtenerPreguntasRelevantesDe	"Jose tiene un topico de Integeres: scify [seteado en setUp]"	self		assert: (cuoora obtenerPreguntasRelevantesDe: jose) size		equals: 1! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 4/18/2020 18:10'!testTodasLasRespuestasDe	self assert: tomas respuestas size equals: 1.! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/4/2020 19:27'!setUp	| scify respuesta1 topicos2 coronavirus |	cuoora := CuOOra new.	jose := cuoora crearUsuario: 'jose' contrasenha: '1234'.	tomas := cuoora crearUsuario: 'tomas' contrasenha: '4321'.	alan := cuoora crearUsuario: 'alan' contrasenha: 'alan2'.	scify := cuoora		agregarNombreTopico: 'scify'		descripcion: 'Ciencia ficcion.'.	general := cuoora		agregarNombreTopico: 'general'		descripcion: 'General.'.	coronavirus := cuoora		agregarNombreTopico: 'coronavirus'		descripcion: 'Everything about coronavirus.'.	topicos1 := OrderedCollection new.	topicos1 add: scify.	topicos1 add: general.	topicos2 := OrderedCollection new.	topicos2 add: general.	topicos2 add: coronavirus.	pregunta1 := cuoora		agregarTituloPregunta: 'Sobre aliens'		descripcion: 'Existen los aliens?'		usuario: jose		topicos: topicos1.	pregunta2 := cuoora		agregarTituloPregunta: 'La reina tiene coronavirus?'		descripcion: 'Yes or what?'		usuario: jose		topicos: topicos2.	respuesta1 := cuoora		agregarTextoRespuesta: 'Michael Jackson es un alien.'		aLaPregunta: pregunta1		usuario: tomas.	cuoora agregarTopicoFav: scify para: jose! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 4/2/2020 15:09'!testDarLikeAusuario
	"pregunta1 y usuario tomas crados en setUp"
	cuoora darLikeA: pregunta1 usuario: tomas.
	
	self assert: pregunta1 likes size equals:1.
	
	! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/4/2020 19:27'!testObtenerPuntajeDe
   | preguntaDeTomas topicosTomas| 
	"jose tiene 2 preguntas creadas en setUp. * 20"
	
	"+ 1 like   "
	cuoora darLikeA: pregunta1 usuario: tomas.
	
	topicosTomas := OrderedCollection new.
	topicosTomas add: general.
	
	preguntaDeTomas := cuoora agregarTituloPregunta: 'Pregunta de prueba' descripcion: '???' usuario: tomas topicos: topicosTomas.
	
	"+ 1 respuesta  *50 "
	cuoora agregarTextoRespuesta: 'Tal vez.' aLaPregunta: preguntaDeTomas  usuario: jose.
	
	self assert: jose calcularPuntaje equals: ( (2*20) + 1 + 50).
	! !!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 4/2/2020 15:09'!testDarDisLikeAusuario
	"preguntas y usuarios ya creados en setUp"
	cuoora darDisLikeA: pregunta2 usuario: alan.
	cuoora darDisLikeA: pregunta2 usuario: tomas.
	
	self assert: pregunta2 dislikes size equals: 2.! !!CuOOraTest methodsFor: 'running' stamp: 'tom 5/9/2020 10:37'!testObtenerPreguntasDe
	"topico creado en setUp"
	self assert: (cuoora obtenerPreguntasDe: general)size equals: 2.! !!CuOOraTest methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/4/2020 19:27'!testAgregarTituloPreguntaDescripcionUsuarioTopicos	cuoora		agregarTituloPregunta: 'Quien tiene una pregunta?'		descripcion: ''		usuario: jose		topicos: topicos1.	self assert: (cuoora obtenerPreguntasDe: jose) size equals: 3! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:32'!testAgregarNombreTopicoDescripcion	cuoora agregarNombreTopico: 'La vida' descripcion: ''.	"Sumando los topicos del initialize de CuOOra para la entrega"	self assert: cuoora topicos size equals: 7.! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:36'!testExisteUsuarioCon	self assert: (cuoora existeUsuario: 'jose' con: '1234') equals: jose! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:32'!testCrearUsuarioContrasenha	| carlos |	carlos := cuoora crearUsuario: 'Carlos' contrasenha: '1234'.	"3 del initialize para la entrega + 3 usuarios del test + Carlos nuevo usuario"	self assert: cuoora usuarios size equals: 7! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:24'!testAgregarTopicoFavPara	self assert: (jose topicosFavoritos) size equals: 1.! !TestCase subclass: #PreguntaTest	instanceVariableNames: 'pregunta usuario topicos'	classVariableNames: ''	package: 'Parte1-Tests'!!PreguntaTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:17'!setUp	usuario := Usuario nombreUsuario: 'prueba' contrasenha: ' '.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: '????'		descripcion: ' '		usuario: usuario		topicos: topicos! !!PreguntaTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:55'!testBorrarmeusuario agregarPregunta: pregunta .pregunta borrarme.self assert: usuario preguntas size equals: 0.! !!PreguntaTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:50'!testAgregarRespuesta 	pregunta		agregarRespuesta: (Respuesta texto: 'No.' respondePregunta: pregunta usuario: usuario).	self assert: pregunta respuestas size equals: 1! !TestCase subclass: #PublicacionTest	instanceVariableNames: 'pregunta'	classVariableNames: ''	package: 'Parte1-Tests'!!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 22:09'!testEliminarDislikeyAgregar	| usuario |	usuario := Usuario nombreUsuario: '' contrasenha: ''.	pregunta agregarDisLike: usuario.	pregunta eliminarDislikeyAgregar: usuario.	self assert: pregunta dislikes size equals: 0.	self assert: pregunta likes size equals: 1.! !!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 22:09'!testEliminarLikeyAgregar	| usuario |	usuario := Usuario nombreUsuario: '' contrasenha: ''.	pregunta agregarLike: usuario.	pregunta eliminarlikeyAgregar: usuario.	self assert: pregunta dislikes size equals: 1.	self assert: pregunta likes size equals: 0.! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:23'!testDioDislike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha:'123'."busca si tom dio dislike, como no dio retorna falso"self assert: (pregunta dioDisLike: tom) equals: false.pregunta agregarDisLike: tom."busca si tom dio dislike como si dio retorna true"self assert: (pregunta dioDisLike: tom) equals: true.! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 12:07'!testAgregarDislike|ausuario|ausuario := Usuario nombreUsuario: '' contrasenha: ''.pregunta agregarDisLike: ausuario .self assert: pregunta dislikes size equals:1.! !!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 22:12'!testDameReaccionDelUserDe	| usuario |	usuario := Usuario nombreUsuario: '' contrasenha: ''.	pregunta agregarLike: usuario.	self		deny: (pregunta dameReaccionDelUser: usuario de: pregunta likes)		equals: nil.! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 12:14'!testCalcularPuntaje"cuando la pregunta no tiene ni likes ni dislikes"self assert: pregunta calcularPuntaje equals: 0.pregunta agregarLike: (Usuario nombreUsuario: '' contrasenha:'' ).pregunta agregarLike: (Usuario nombreUsuario: '.' contrasenha:'.' ).pregunta agregarDisLike: (Usuario nombreUsuario: '..' contrasenha:'..' ).self assert: pregunta calcularPuntaje equals:1! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:25'!testDioLike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha:'123'."busca si tom dio dislike, como no dio retorna falso"self assert: (pregunta dioLike: tom) equals: false.pregunta agregarLike: tom."busca si tom dio dislike como si dio retorna true"self assert: (pregunta dioLike: tom) equals: true.! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 12:08'!testAgregarlike|ausuario|ausuario := Usuario nombreUsuario: '' contrasenha: ''.pregunta agregarLike: ausuario .self assert: pregunta likes size equals:1.! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:53'!testDarDisLike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha: '123'.self assert: (pregunta  darDisLike: tom) equals: true.self assert:(pregunta darDisLike: tom) equals: false.! !!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:17'!setUp	| usuario topicos |	usuario := Usuario nombreUsuario: '' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: ''		descripcion: ''		usuario: usuario		topicos: topicos! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:52'!testDarLike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha: '123'.self assert: (pregunta  darLike: tom) equals: true.self assert:(pregunta darLike: tom) equals: false.! !TestCase subclass: #RespuestaTest	instanceVariableNames: 'respuesta pregunta usuario'	classVariableNames: ''	package: 'Parte1-Tests'!!RespuestaTest methodsFor: 'running' stamp: 'tom 5/9/2020 11:45'!testEliminar"se elimina la respuesta "respuesta eliminar .self assert: usuario respuestas size equals: 0! !!RespuestaTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:17'!setUp	| topicos usuario2 |	"pepito responde a juan. pepito guarda la respuesta "	usuario := Usuario nombreUsuario: 'pepito' contrasenha: '123'.	usuario2 := Usuario nombreUsuario: 'juan' contrasenha: '321'.	topicos := OrderedCollection new.	topicos add: (Topico nombre: 'juegos' descripcion: 'arcade').	pregunta := Pregunta		titulo: '¿que son los juegos arcade?'		descripcion: '.'		usuario: usuario2		topicos: topicos.	respuesta := Respuesta		texto: 'pregunto lo mismo'		respondePregunta: pregunta		usuario: usuario.	usuario guardarRespuesta: respuesta! !TestCase subclass: #TopicoTest	instanceVariableNames: 'topico cuoora pregunta'	classVariableNames: ''	package: 'Parte1-Tests'!!TopicoTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:08'!testGuardar		topico guardar: pregunta.		self assert: topico preguntas size equals: 2.! !!TopicoTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:08'!testEliminar	topico eliminar: pregunta.	self assert: topico preguntas size equals: 0.! !!TopicoTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:18'!setUp	| usuario topicos |	cuoora := CuOOra new.	topico := Topico new.	usuario := Usuario nombreUsuario: '' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: '?????'		descripcion: ''		usuario: usuario		topicos: topicos.	topico guardar: pregunta! !TestCase subclass: #UsuarioTest	instanceVariableNames: 'usuario cuoora pregunta respuesta'	classVariableNames: ''	package: 'Parte1-Tests'!!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/15/2020 18:53'!testPreguntasRelevantes	| usuarioASeguir |	usuarioASeguir := Usuario new.	cuoora unUsuario: usuario sigueA: usuarioASeguir.	cuoora		agregarTituloPregunta: '??'		descripcion: ''		usuario: usuarioASeguir		topicos:			(OrderedCollection new				add: (Topico nombre: '' descripcion: '');				yourself).	self assert: usuario preguntasRelevantes size equals: 1.! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 20:25'!testEliminarPregunta	usuario agregarPregunta: pregunta.	usuario eliminarPregunta: pregunta.	self assert: usuario preguntas size equals: 0! !!UsuarioTest methodsFor: 'tests' stamp: 'tom 5/9/2020 14:04'!testAgregarTopicosFav|topico|topico:= Topico nombre: '' descripcion: ''.usuario agregarTopicosFav: topico.self assert: usuario topicosFavoritos  size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 20:18'!testAgregarPregunta	| topicos |	topicos := OrderedCollection new.	topicos add: (Topico nombre: 'scify' descripcion: '').	usuario		agregarPregunta:			(Pregunta				titulo: '?'				descripcion: ''				usuario: usuario				topicos: topicos).	self assert: usuario preguntas size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 20:28'!testEliminarRespuesta	| usuario2 |	usuario2 := Usuario nombreUsuario: '' contrasenha: ''.		respuesta := Respuesta		texto: ''		respondePregunta: pregunta		usuario: usuario2.	usuario2 guardarRespuesta: respuesta.	usuario2 eliminarRespuesta: respuesta.	self assert: usuario2 respuestas size equals: 0! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 20:31'!testGuardarRespuesta	| usuario2 |	usuario2 := Usuario nombreUsuario: '' contrasenha: ''.	respuesta := Respuesta		texto: ''		respondePregunta: pregunta		usuario: usuario2.	usuario2 guardarRespuesta: respuesta.	self assert: usuario2 respuestas size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 16:20'!testSeguir	| otrousuario |	otrousuario := Usuario nombreUsuario: 'otro' contrasenha: '.'.	usuario seguir: otrousuario.	self assert: usuario seguidos size equals: 1.	usuario seguir: otrousuario.	"No sigue al mismo usuario, si éste ya es seguido."	self assert: usuario seguidos size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 21:00'!testCalcularPuntaje	usuario agregarPregunta: pregunta.	self assert: usuario calcularPuntaje equals: 20! !!UsuarioTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:31'!setUp	| topicos |	cuoora := CuOOra new.	usuario := cuoora crearUsuario: 'usuario' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: 'scify' descripcion: '').	pregunta := Pregunta		titulo: '?'		descripcion: ''		usuario: usuario		topicos: topicos.! !Object subclass: #CuOOra	instanceVariableNames: 'usuarios topicos'	classVariableNames: ''	package: 'Parte1-model'!!CuOOra methodsFor: 'initialization' stamp: 'tom 4/16/2020 10:20'!obtenerPreguntasDe: topico
	"esto funciona si se elije de los topicos de CuOOra cuando en la pregunta se elije los topicos"

	"verificar que exista en caso de q me mande uno cualquiera "

	^ topico preguntas! !!CuOOra methodsFor: 'initialization' stamp: 'Anonymous 5/11/2020 16:18'!initialize	| topicos1 topicos2 oo1 pedro juan diego preguntaPedro preguntaDiego |	usuarios := OrderedCollection new.	topicos := OrderedCollection new.	"Instancia de prueba: "	pedro := self		crearUsuario: 'pedro@cuoora.com'		contrasenha: 'pedro@cuoora.com'.	diego := self		crearUsuario: 'diego@cuoora.com'		contrasenha: 'diego@cuoora.com'.	juan := self		crearUsuario: 'juan@cuoora.com'		contrasenha: 'juan@cuoora.com'.	"el metodo existeUsuario: con:   devuelve al usuario con usuario y clave. O nil si no existe."	self unUsuario: juan sigueA: diego.	self unUsuario: pedro sigueA: juan.	"Creamos una coleccion de topicos para la primera pregunta"	topicos1 := OrderedCollection new.	oo1 := self agregarNombreTopico: 'OO1' descripcion: ''.	topicos1 add: oo1.	topicos1		add: (self agregarNombreTopico: 'Test de Unidad' descripcion: '').	topicos2 := OrderedCollection new.	topicos2 add: oo1.	topicos2 add: (self agregarNombreTopico: 'Smalltalk' descripcion: '').	preguntaPedro := self		agregarTituloPregunta: '¿Para qué sirve el método setUp?'		descripcion: ''		usuario: pedro		topicos: topicos1.	preguntaDiego := self		agregarTituloPregunta: '¿Qué significa #messageNotUnderstood?'		descripcion: ''		usuario: diego		topicos: topicos2.	self		agregarTextoRespuesta:			'Sirve para instanciar los objetos que son evaluados por el test en un único método y que se ejecute siempre antes de cada test.'		aLaPregunta: preguntaPedro		usuario: diego.	self		agregarTextoRespuesta:			'Significa que el objeto que recibió el mensaje no encontró ningún método para ejecutar en respuesta.'		aLaPregunta: preguntaDiego		usuario: pedro! !!CuOOra methodsFor: 'private' stamp: 'Anonymous 5/15/2020 19:30'!getFirst: n from: aCollection	^ aCollection takeFirst: n! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:20'!todasLasPreguntasDe: unUsuario
	^ unUsuario preguntas! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:20'!todasLasRespuestasDe: unUsuario
	^ unUsuario respuestas! !!CuOOra methodsFor: 'public' stamp: 'tom 4/19/2020 14:55'!unUsuario: unUsuario sigueA: unUsuarioAseguir
	unUsuario = unUsuarioAseguir
		ifFalse: [ unUsuario seguir: unUsuarioAseguir ]! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:19'!crearUsuario: aNick contrasenha: aContrasenha
	| usuario |
	usuario := Usuario nombreUsuario: aNick contrasenha: aContrasenha.
	^ usuarios add: usuario! !!CuOOra methodsFor: 'public' stamp: 'tom 4/19/2020 14:45'!agregarTextoRespuesta: unTexto aLaPregunta: unaPregunta usuario: unUsuario
"crea una respuesta a una pregunta(unaPregunta) luego guarda la respuesta en la pregunta "
	| respuesta |
	respuesta := Respuesta
		texto: unTexto
		respondePregunta: unaPregunta
		usuario: unUsuario.
	unaPregunta agregarRespuesta: respuesta.
	unUsuario guardarRespuesta: respuesta.
	^ respuesta! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:19'!agregarTopicoFav: untopico para: unusuario
	unusuario agregarTopicosFav: untopico! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:20'!darDisLikeA: unPublicacion usuario: unUsuario
	"como ya tengo la publicacion entonces a esta(tiene una coleccion de likes que los elementos son reacciones) retorna true en caso de realizar la accion y false en caso de que no"

	unPublicacion darDisLike: unUsuario! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:19'!borrarPregunta: unaPregunta
	unaPregunta borrarme! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:20'!darLikeA: unPublicacion usuario: unUsuario
	"como ya tengo la publicacion entonces a esta(tiene una coleccion de likes que los elementos son reacciones) retorna true en caso de realizar la accion y false en caso de que no"

	unPublicacion darLike: unUsuario! !!CuOOra methodsFor: 'public' stamp: 'Anonymous 5/15/2020 19:31'!obtenerPreguntasRelevantesDe: unUsuario	^ self getFirst:5 from:(unUsuario preguntasRelevantes		asSortedCollection: [ :pregunta :pregunta2 | pregunta fecha > pregunta2 fecha ])! !!CuOOra methodsFor: 'public' stamp: 'Anonymous 5/11/2020 16:16'!agregarTituloPregunta: unTitulo descripcion: unaDescripcion usuario: unUsuario topicos: unaTopica	| nuevaPregunta |	nuevaPregunta := Pregunta		titulo: unTitulo		descripcion: unaDescripcion		usuario: unUsuario		topicos: unaTopica.	unUsuario agregarPregunta: nuevaPregunta.	^ nuevaPregunta! !!CuOOra methodsFor: 'public' stamp: 'tom 4/19/2020 14:35'!agregarNombreTopico: unNombre descripcion: unDescripcion
"crea al topico, lo agrega a la coleccion de topicos y lo retorna"
	| topico |
	topico := Topico nombre: unNombre descripcion: unDescripcion.
	^ topicos add: topico! !!CuOOra methodsFor: 'accessing' stamp: 'Anonymous 5/11/2020 16:18'!topicos	^ topicos! !!CuOOra methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 18:01'!usuarios
	^usuarios.! !!CuOOra methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/9/2020 16:53'!existeTopico:_nombreTopico
	^ topicos detect: [ :ea | ea nombre = _nombreTopico] ifNone:[ ^ self agregarNombreTopico: _nombreTopico descripcion: '' ].! !!CuOOra methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/6/2020 19:52'!existeUsuario:_nombre con:_contrasenha
	^ usuarios detect: [ :ea | ea nombre = _nombre & (ea contrasenha = _contrasenha)  ] ifNone: [ ^ nil ].! !!CuOOra methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/18/2020 16:02'!obtenerRespuestasDePregunta:_pregunta
^_pregunta respuestas asSortedCollection: [:r1 :r2 | r1 calcularPuntaje > r2 calcularPuntaje].! !!CuOOra methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/1/2020 16:37'!obtenerPuntajeDe:_usuario

^ _usuario calcularPuntaje.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!CuOOra class	instanceVariableNames: 'soleInstance'!!CuOOra class methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:43'!clearSoleInstance
	soleInstance := nil.! !!CuOOra class methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:43'!soleInstance
	^ soleInstance ifNil: [ soleInstance := self new ].! !Object subclass: #Publicacion	instanceVariableNames: 'likes dislikes fecha usuario'	classVariableNames: ''	package: 'Parte1-model'!!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 17:32'!fecha
	^ fecha! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/1/2020 16:26'!likes

^likes.! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 15:32'!usuario: anObject
	usuario := anObject! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/1/2020 16:26'!dislikes

^dislikes.! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 15:32'!usuario
	^ usuario! !!Publicacion methodsFor: 'initialization' stamp: 'tom 4/16/2020 10:18'!darLike: unUsuario
	"dioLike retorna true si dio like caso contrario da false"

	"dioDislike retorna true si dio dislike"

	"el mejor caso es q si dio like el usuario retorna falso que seria q no puede ralizar la accion, si no dio like entonces va tener que agregar y siempre retorna true"

	(self dioLike: unUsuario)
		ifTrue: [ ^ false ]
		ifFalse: [ (self dioDisLike: unUsuario)
				ifTrue: [ self eliminarDislikeyAgregar: unUsuario ]
				ifFalse: [ self agregarLike: unUsuario ] ].
	^ true! !!Publicacion methodsFor: 'initialization' stamp: 'tom 4/16/2020 10:18'!darDisLike: unUsuario
	"dioLike retorna true si dio like caso contrario da false"

	"dioDislike retorna true si dio dislike"

	"el mejor caso es q si dio like el usuario retorna falso que seria q no puede ralizar la accion, si no dio like entonces va tener que agregar y siempre retorna true"

	(self dioDisLike: unUsuario)
		ifTrue: [ ^ false ]
		ifFalse: [ (self dioLike: unUsuario)
				ifTrue: [ self eliminarlikeyAgregar: unUsuario ]
				ifFalse: [ self agregarDisLike: unUsuario ] ].
	^ true! !!Publicacion methodsFor: 'initialization' stamp: 'tom 4/16/2020 10:19'!initialize
	"like y dislike es una coleccion de reaccion para saber la cantidad de like solo debo llamar a like size "

	fecha := DateAndTime now.
	likes := OrderedCollection new.
	dislikes := OrderedCollection new! !!Publicacion methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/2/2020 16:09'!calcularPuntaje

^ ( (likes size) - (dislikes size) ).! !!Publicacion methodsFor: 'private' stamp: 'tom 4/16/2020 10:18'!dameReaccionDelUser: unUsuario de: adislikes
	^ adislikes detect: [ :reaccion | reaccion usuario = unUsuario ]! !!Publicacion methodsFor: 'private' stamp: 'tom 4/16/2020 10:16'!agregarLike: unUsuario
	| reaccion |
	reaccion := Reaccion usuario: unUsuario.
	likes add: reaccion! !!Publicacion methodsFor: 'private' stamp: 'Anonymous 4/18/2020 16:18'!dioLike: unUsuario
	^ (likes select: [ :ea | ea usuario = unUsuario ]) size > 0
	! !!Publicacion methodsFor: 'private' stamp: 'tom 4/16/2020 10:19'!eliminarDislikeyAgregar: unUsuario
	dislikes remove: (self dameReaccionDelUser: unUsuario de: dislikes).
	self agregarLike: unUsuario! !!Publicacion methodsFor: 'private' stamp: 'tom 4/16/2020 10:19'!eliminarlikeyAgregar: unUsuario
	likes remove: (self dameReaccionDelUser: unUsuario de: likes).
	self agregarDisLike: unUsuario! !!Publicacion methodsFor: 'private' stamp: 'tom 4/16/2020 10:16'!agregarDisLike: unUsuario
	| reaccion |
	reaccion := Reaccion usuario: unUsuario.
	dislikes add: reaccion! !!Publicacion methodsFor: 'private' stamp: 'Anonymous 4/18/2020 16:16'!dioDisLike: unUsuario
	^ (dislikes select: [ :ea | ea usuario = unUsuario ]) size > 0! !Publicacion subclass: #Pregunta	instanceVariableNames: 'titulo descripcion topicos respuestas'	classVariableNames: ''	package: 'Parte1-model'!!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 15:19'!topicos
	^ topicos.! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!descripcion: unaDesc
	descripcion := unaDesc! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!initialize
	super initialize.
	topicos := OrderedCollection new.
	respuestas := OrderedCollection new! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!titulo: unTitulo
	titulo := unTitulo! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/2/2020 13:06'!respuestas
^ respuestas.! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 18:14'!titulo
	^ titulo.! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!agregarRespuesta: unRespuesta
	respuestas add: unRespuesta! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!topico: unTopico
	topicos := unTopico.
	topicos do: [ :topico | topico guardar: self ]! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!borrarme
	"elimina todo rastro "

	"primero elimina la pregunta en los topicos"

	topicos do: [ :topico | topico eliminar: self ].
	self usuario eliminarPregunta: self.
	respuestas do: [ :respuesta | respuesta eliminar ]! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Pregunta class	instanceVariableNames: ''!!Pregunta class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!titulo: unTitulo descripcion: unaDescripcion usuario: unUsuario topico: unTopico
	^ self new
		titulo: unTitulo;
		descripcion: unaDescripcion;
		topico: unTopico;
		usuario: unUsuario;
		yourself! !!Pregunta class methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 16:15'!titulo: unTitulo descripcion: unaDescripcion usuario: unUsuario topicos: unTopico	^ self new		titulo: unTitulo;		descripcion: unaDescripcion;		topico: unTopico;		usuario: unUsuario;		yourself! !Object subclass: #Reaccion	instanceVariableNames: 'fecha usuario'	classVariableNames: ''	package: 'Parte1-model'!!Reaccion methodsFor: 'public' stamp: 'Anonymous 4/1/2020 16:54'!usuario:unUsuario

usuario := unUsuario.
! !!Reaccion methodsFor: 'public' stamp: 'tom 4/16/2020 10:15'!usuario
	^ usuario! !!Reaccion methodsFor: 'initialization' stamp: 'Anonymous 4/18/2020 18:04'!initialize
	fecha := DateAndTime now.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Reaccion class	instanceVariableNames: ''!!Reaccion class methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:11'!usuario: unUsuario
	^ self new usuario: unUsuario! !Publicacion subclass: #Respuesta	instanceVariableNames: 'preguntaResponde texto'	classVariableNames: ''	package: 'Parte1-model'!!Respuesta methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/2/2020 15:52'!pregunta
	^ preguntaResponde.! !!Respuesta methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/2/2020 15:53'!preguntaResponde
	^ preguntaResponde.! !!Respuesta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:15'!eliminar
	self usuario eliminarRespuesta: self! !!Respuesta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!texto: unTexto
	texto := unTexto! !!Respuesta methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 16:02'!texto
	^texto.! !!Respuesta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!preguntaResponde: unaPregunta
	preguntaResponde := unaPregunta! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Respuesta class	instanceVariableNames: ''!!Respuesta class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!texto: unTexto respondePregunta: unaPregunta usuario: unUsuario
	^ self new
		preguntaResponde: unaPregunta;
		texto: unTexto;
		usuario: unUsuario;
		yourself! !Object subclass: #Topico	instanceVariableNames: 'nombre descripcion preguntas'	classVariableNames: ''	package: 'Parte1-model'!!Topico methodsFor: 'accessing' stamp: 'Anonymous 4/9/2020 15:50'!nombre 
	^nombre.! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:14'!descripcion: unDescripcion
	descripcion := unDescripcion! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:15'!preguntas
	^ preguntas! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:14'!initialize
	preguntas := OrderedCollection new! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:14'!eliminar: unaPregunta
	"elimina una pregunta de la coleccion de preguntas"

	preguntas remove: unaPregunta! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:14'!nombre: unNombre
	nombre := unNombre! !!Topico methodsFor: 'public' stamp: 'tom 4/16/2020 10:14'!guardar: unPregunta
	preguntas add: unPregunta! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Topico class	instanceVariableNames: ''!!Topico class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!nombre: unNombre descripcion: unDescripcion
	^ self new
		nombre: unNombre;
		descripcion: unDescripcion;
		yourself! !Object subclass: #Usuario	instanceVariableNames: 'nombre contrasenha fecha seguidos preguntas respuestas topicoFavoritos'	classVariableNames: ''	package: 'Parte1-model'!!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!contrasenha: acontrasenha
	contrasenha := acontrasenha! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!agregarPregunta: unaPregunta
	preguntas add: unaPregunta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 4/2/2020 11:52'!nombre
	^nombre.! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!agregarTopicosFav: untopico
	topicoFavoritos add: untopico! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!preguntas
	^ preguntas! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!eliminarPregunta: apregunta
	preguntas remove: apregunta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:53'!contrasenha 	
	^ contrasenha.! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!nombre: aName
	nombre := aName! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!eliminarRespuesta: unaRespuesta
	respuestas remove: unaRespuesta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 5/11/2020 03:05'!seguir: unUsuarioAseguir	(seguidos anySatisfy: [ :u | u = unUsuarioAseguir ])		ifFalse: [ seguidos add: unUsuarioAseguir ]! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 5/11/2020 16:50'!preguntasRelevantes	| resultado |	resultado := Set new.	resultado		addAll: (topicoFavoritos flatCollect: [ :ea | ea preguntas ]).	resultado addAll: (seguidos flatCollect: [ :ea | ea preguntas ]).	^ resultado.! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:14'!seguidos
	^ seguidos! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!guardarRespuesta: unaRespuesta
	respuestas add: unaRespuesta! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!respuestas
	^ respuestas! !!Usuario methodsFor: 'initialization' stamp: 'Anonymous 5/11/2020 03:00'!initialize	fecha := DateAndTime now.	seguidos := OrderedCollection new.	preguntas := OrderedCollection new.	topicoFavoritos := OrderedCollection new.	respuestas := OrderedCollection new! !!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 20:59'!calcularPuntaje	| respuestasAOtroUsuario |	respuestasAOtroUsuario := respuestas		reject: [ :ea | ea preguntaResponde usuario == self ].	"Solo las respuestas de preguntas que no sean suyas."	^ preguntas size * 20 + (respuestasAOtroUsuario size * 50)		+ (self sumar: preguntas) + (self sumar: respuestas)! !!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 16:19'!topicosFavoritos	^ topicoFavoritos.! !!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 20:59'!sumar: aCollection	aCollection		ifNotEmpty: [ ^ aCollection sum: [ :item | item calcularPuntaje ] ].	^ 0! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Usuario class	instanceVariableNames: ''!!Usuario class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!nombreUsuario: aNombre contrasenha: acontrasenha
	^ self new
		nombre: aNombre;
		contrasenha: acontrasenha;
		yourself! !