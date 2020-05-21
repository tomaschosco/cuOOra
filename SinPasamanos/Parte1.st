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
	'! !!CrearPreguntasComponent methodsFor: 'initialization' stamp: 'Anonymous 4/18/2020 17:58'!initialize	super initialize.	error := false.! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:01'!verificarError: canvas	error		ifTrue: [ canvas heading				level: 4;				with: 'Debe llenar todos los campos.'.			canvas heading				class: 'rojo';				level: 3;				with: 'DEBE COMPLETAR TODOS LOS CAMPOS PARA CONTINUAR!!' ]! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:02'!mostrarFormulario: canvas	canvas		form: [ canvas				paragraph: [ canvas label: 'Titulo'.					canvas textInput						on: #titulo of: self;						placeholder: 'Escriba aqui el titulo de su pregunta' ].			canvas				paragraph: [ canvas label: 'Desarrollo'.					canvas textArea						on: #texto of: self;						placeholder: 'Escriba aqui el desarrollo de su pregunta.' ].			canvas textInput				on: #topicos of: self;				placeholder: 'Ingrese topicos separados por coma.'.			canvas button				callback: [ self cancelar ];				with: 'Cancelar'.			canvas button				callback: [ self continuar ];				with: 'Guardar' ]! !!CrearPreguntasComponent methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:03'!renderContentOn: canvas	self renderLogout: canvas.	canvas heading: 'Nueva Pregunta'.	canvas horizontalRule.	self verificarError: canvas.	self mostrarFormulario: canvas.! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:59'!topicos:anObject 
topicos:= anObject! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'Anonymous 5/19/2020 22:43'!continuar	titulo = '' | (topicos = '')		ifTrue: [ error := true.			^ false ].	topicos := topicos splitOn: ','.	"Tenemos una Collection de nombres  de topicos."	topicos := topicos		collect: [ :ea | CuOOra soleInstance existeTopico: ea ].	"Le pedimos a CuOOra que nos dé solo los que existen"	topicos := topicos select: [ :ea | ea notNil ].	"Los nil no los queremos"	self session user		agregarPregunta:			(Pregunta				titulo: titulo				descripcion: texto				usuario: self session user				topico: topicos).	self answer! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 04:05'!cancelar
	titulo := nil.
	texto := nil.
	topicos := nil.
	pregunta := nil.
	self answer.! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!titulo: atitulo
titulo :=atitulo ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!texto 
^texto ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:56'!titulo 
^titulo ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:57'!texto: atexto 
texto:=atexto ! !!CrearPreguntasComponent methodsFor: 'accessing' stamp: 'tom 4/10/2020 03:58'!topicos 
^topicos! !HeaderComponent subclass: #PreguntasRenderer	instanceVariableNames: 'preguntas'	classVariableNames: ''	package: 'Parte1-UI'!!PreguntasRenderer methodsFor: 'initialization' stamp: 'Anonymous 5/4/2020 21:20'!initialize	super initialize! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:43'!renderPregunta: aCanvas pregunta: pregunta	self mostrarTitulo: pregunta con: aCanvas.	self mostrarTopicos: pregunta con: aCanvas.	self mostrarVotos: pregunta con: aCanvas.	self mostrarReacciones: pregunta con: aCanvas.	aCanvas horizontalRule! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:34'!mostrarTopicos: preg con: aCanvas	aCanvas paragraph		class: 'topicos';		with: [ aCanvas				text: 'Topicos:';				space.			aCanvas				text: (', ' join: (preg topicos collect: [ :topi | topi nombre ])) ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/19/2020 23:38'!renderRespuestas: canvas pregunta: pregunta	canvas		unorderedList: [ pregunta obtenerRespuestasOrdenadas				do: [ :rta | 					canvas strong: 'Respuesta de '.	" rta usuario nombre."					canvas anchor						class: 'preguntas';						callback: [ self verUsuario: rta usuario ];						with: rta usuario nombre.					canvas paragraph with: [ canvas text: rta texto ].					canvas paragraph						with: [ canvas								text: rta likes size asString;								text: ' likes | ';								text: rta dislikes size asString;								text: ' dislikes' ].					self mostrarReacciones: rta con: canvas.					canvas horizontalRule ] ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:23'!verPregunta: preg	self call: (DetallesPreguntaComponent pregunta: preg).	self session user ifNil: [ self answer ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/4/2020 21:23'!verUsuario: user	self call: (PerfilUserComponent usuario: user).	self session user ifNil: [ self answer ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:33'!mostrarTitulo: preg con: aCanvas	aCanvas anchor		class: 'preguntas';		callback: [ self verPregunta: preg ];		with: preg titulo! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/19/2020 21:39'!mostrarReacciones: preg con: aCanvas	aCanvas paragraph		with: [ aCanvas anchor				class: 'reaccionLike';				callback: [ preg darLike: self session user ];				with: 'like'.			aCanvas				space;				text: '|';				space.			aCanvas anchor				callback: [ preg darDisLike:self session user ];				class: 'reaccionDislike';				with: 'dislike' ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:36'!renderPreguntas: aCanvas preguntas: lasPreguntas	aCanvas		unorderedList: [ lasPreguntas				do: [ :preg | 					aCanvas						listItem: [ self mostrarTitulo: preg con: aCanvas.							self mostrarTopicos: preg con: aCanvas.							self mostrarVotos: preg con: aCanvas.							self mostrarReacciones: preg con: aCanvas.							aCanvas horizontalRule ] ] ]! !!PreguntasRenderer methodsFor: 'rendering' stamp: 'Anonymous 5/7/2020 15:35'!mostrarVotos: preg con: aCanvas	aCanvas paragraph		with: [ aCanvas text: 'Realizada por '.			aCanvas space.			aCanvas strong				with: [ aCanvas anchor						callback: [ self verUsuario: preg usuario ];						with: preg usuario nombre ].			aCanvas space.			aCanvas text: '|'.			aCanvas space.			aCanvas text: preg respuestas size asString , ' respuestas' ].	aCanvas paragraph		with: [ aCanvas				text: preg likes size asString;				space;				text: 'Likes';				space;				text: '|';				space;				text: preg dislikes size asString;				space;				text: 'Dislikes' ]! !PreguntasRenderer subclass: #DetallesPreguntaComponent	instanceVariableNames: 'pregunta'	classVariableNames: ''	package: 'Parte1-UI'!!DetallesPreguntaComponent methodsFor: 'hook' stamp: 'Anonymous 4/10/2020 21:21'!style
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
super initialize ! !!InicioComponent methodsFor: 'rendering' stamp: 'Anonymous 5/19/2020 23:33'!renderContentOn: aCanvas	self renderLogout: aCanvas.	self crearPregunta: aCanvas.	self		renderPreguntas: aCanvas		preguntas: (self session user preguntasRelevantes)! !!InicioComponent methodsFor: 'accesing' stamp: 'tom 4/7/2020 16:16'!cuoora
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
usuario :=auser ! !!PerfilUserComponent methodsFor: 'rendering' stamp: 'Anonymous 5/19/2020 21:34'!renderContentOn: canvas	self renderLogout: canvas.	canvas		paragraph: [ canvas heading: 'Preguntas de ' , usuario nombre.			canvas space.			usuario = self session user				ifFalse: [ canvas anchor						callback: [ self session user seguir: usuario ];						with: 'follow' ] ].	canvas break.	self		renderPreguntas: canvas		preguntas: (usuario preguntas)! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!PerfilUserComponent class	instanceVariableNames: ''!!PerfilUserComponent class methodsFor: 'accessing' stamp: 'tom 4/10/2020 04:47'!usuario:auser
^self new usuario: auser ;yourself ! !PreguntasRenderer subclass: #ResponderPregComponent	instanceVariableNames: 'pregunta texto'	classVariableNames: ''	package: 'Parte1-UI'!!ResponderPregComponent methodsFor: 'initialization' stamp: 'tom 4/19/2020 14:48'!initialize	super initialize.! !!ResponderPregComponent methodsFor: 'callbacks' stamp: 'tom 4/8/2020 19:51'!cancelar
texto :=nil.
self answer ! !!ResponderPregComponent methodsFor: 'callbacks' stamp: 'Anonymous 5/19/2020 21:42'!guardar	Respuesta texto: texto respondePregunta: pregunta usuario: self session user.	self answer! !!ResponderPregComponent methodsFor: 'hook' stamp: 'Anonymous 4/10/2020 21:01'!style
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


'! !TestCase subclass: #CuOOraTest	instanceVariableNames: 'cuoora topicos1 general pregunta1 tomas jose alan pregunta2'	classVariableNames: ''	package: 'Parte1-Tests'!!CuOOraTest methodsFor: 'running' stamp: 'Anonymous 5/19/2020 23:45'!setUp	| scify respuesta1 topicos2 coronavirus |	cuoora := CuOOra new.	jose := cuoora crearUsuario: 'jose' contrasenha: '1234'.	tomas := cuoora crearUsuario: 'tomas' contrasenha: '4321'.	alan := cuoora crearUsuario: 'alan' contrasenha: 'alan2'.	scify := cuoora		agregarNombreTopico: 'scify'		descripcion: 'Ciencia ficcion.'.	general := cuoora		agregarNombreTopico: 'general'		descripcion: 'General.'.	coronavirus := cuoora		agregarNombreTopico: 'coronavirus'		descripcion: 'Everything about coronavirus.'.	topicos1 := OrderedCollection new.	topicos1 add: scify.	topicos1 add: general.	topicos2 := OrderedCollection new.	topicos2 add: general.	topicos2 add: coronavirus.	pregunta1 := Pregunta		titulo: 'Sobre los aliens'		descripcion: 'Existen los aliens?'		usuario: jose		topico: topicos1.	pregunta2 := Pregunta		titulo: 'La reina tiene coronavirus?'		descripcion: 'Yes or what?'		usuario: jose		topico: topicos2.	respuesta1 := Respuesta		texto: 'Michael Jackson es un alien.'		respondePregunta: pregunta1		usuario: tomas.	jose agregarTopicosFav: scify! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:32'!testAgregarNombreTopicoDescripcion	cuoora agregarNombreTopico: 'La vida' descripcion: ''.	"Sumando los topicos del initialize de CuOOra para la entrega"	self assert: cuoora topicos size equals: 7.! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:32'!testCrearUsuarioContrasenha	| carlos |	carlos := cuoora crearUsuario: 'Carlos' contrasenha: '1234'.	"3 del initialize para la entrega + 3 usuarios del test + Carlos nuevo usuario"	self assert: cuoora usuarios size equals: 7! !!CuOOraTest methodsFor: 'tests' stamp: 'Anonymous 5/4/2020 19:36'!testExisteUsuarioCon	self assert: (cuoora existeUsuario: 'jose' con: '1234') equals: jose! !TestCase subclass: #PreguntaTest	instanceVariableNames: 'pregunta usuario topicos'	classVariableNames: ''	package: 'Parte1-Tests'!!PreguntaTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:17'!setUp	usuario := Usuario nombreUsuario: 'prueba' contrasenha: ' '.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: '????'		descripcion: ' '		usuario: usuario		topicos: topicos! !!PreguntaTest methodsFor: 'tests' stamp: 'Anonymous 5/19/2020 23:58'!testBorrarme	pregunta borrarme.	self assert: usuario preguntas size equals: 0! !!PreguntaTest methodsFor: 'tests' stamp: 'Anonymous 5/19/2020 23:57'!testAgregarRespuesta	pregunta		agregarRespuesta: (Respuesta new).	self assert: pregunta respuestas size equals: 1! !TestCase subclass: #PublicacionTest	instanceVariableNames: 'pregunta'	classVariableNames: ''	package: 'Parte1-Tests'!!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/20/2020 06:04'!testDameReaccionDelUserDe	| usuario |	usuario := Usuario new.	self		assert: (pregunta dameReaccionDelUser: usuario de: pregunta likes)		equals: nil! !!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/20/2020 06:15'!testCalcularPuntaje	"cuando la pregunta no tiene ni likes ni dislikes"	self assert: pregunta calcularPuntaje equals: 0.	pregunta darLike: (Usuario nombreUsuario: '' contrasenha: '').	pregunta darLike: (Usuario nombreUsuario: '.' contrasenha: '.').	pregunta		darDisLike: (Usuario nombreUsuario: '..' contrasenha: '..').	self assert: pregunta calcularPuntaje equals: 1! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:53'!testDarDisLike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha: '123'.self assert: (pregunta  darDisLike: tom) equals: true.self assert:(pregunta darDisLike: tom) equals: false.! !!PublicacionTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:17'!setUp	| usuario topicos |	usuario := Usuario nombreUsuario: '' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: ''		descripcion: ''		usuario: usuario		topicos: topicos! !!PublicacionTest methodsFor: 'running' stamp: 'tom 5/9/2020 13:52'!testDarLike|tom|tom:= Usuario nombreUsuario: 'tom' contrasenha: '123'.self assert: (pregunta  darLike: tom) equals: true.self assert:(pregunta darLike: tom) equals: false.! !TestCase subclass: #RespuestaTest	instanceVariableNames: 'respuesta pregunta usuario'	classVariableNames: ''	package: 'Parte1-Tests'!!RespuestaTest methodsFor: 'running' stamp: 'tom 5/9/2020 11:45'!testEliminar"se elimina la respuesta "respuesta eliminar .self assert: usuario respuestas size equals: 0! !!RespuestaTest methodsFor: 'running' stamp: 'Anonymous 5/19/2020 23:58'!setUp	| topicos usuario2 |	"pepito responde a juan. pepito guarda la respuesta "	usuario := Usuario nombreUsuario: 'pepito' contrasenha: '123'.	usuario2 := Usuario nombreUsuario: 'juan' contrasenha: '321'.	topicos := OrderedCollection new.	topicos add: (Topico nombre: 'juegos' descripcion: 'arcade').	pregunta := Pregunta		titulo: '¿que son los juegos arcade?'		descripcion: '.'		usuario: usuario2		topicos: topicos.	respuesta := Respuesta		texto: 'pregunto lo mismo'		respondePregunta: pregunta		usuario: usuario.! !TestCase subclass: #TopicoTest	instanceVariableNames: 'topico cuoora pregunta'	classVariableNames: ''	package: 'Parte1-Tests'!!TopicoTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:08'!testGuardar		topico guardar: pregunta.		self assert: topico preguntas size equals: 2.! !!TopicoTest methodsFor: 'tests' stamp: 'tom 5/9/2020 11:08'!testEliminar	topico eliminar: pregunta.	self assert: topico preguntas size equals: 0.! !!TopicoTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:18'!setUp	| usuario topicos |	cuoora := CuOOra new.	topico := Topico new.	usuario := Usuario nombreUsuario: '' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: '' descripcion: '').	pregunta := Pregunta		titulo: '?????'		descripcion: ''		usuario: usuario		topicos: topicos.	topico guardar: pregunta! !TestCase subclass: #UsuarioTest	instanceVariableNames: 'usuario cuoora pregunta respuesta'	classVariableNames: ''	package: 'Parte1-Tests'!!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/19/2020 21:07'!testPreguntasRelevantes	| usuarioASeguir |	usuarioASeguir := Usuario new.	usuario seguir: usuarioASeguir.	Pregunta titulo: '??' descripcion: '' usuario: usuarioASeguir topicos: (OrderedCollection new				add: (Topico nombre: '' descripcion: '');				yourself).	self assert: usuario preguntasRelevantes size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/20/2020 00:00'!testEliminarPregunta	usuario eliminarPregunta: pregunta.	self assert: usuario preguntas size equals: 0! !!UsuarioTest methodsFor: 'tests' stamp: 'tom 5/9/2020 14:04'!testAgregarTopicosFav|topico|topico:= Topico nombre: '' descripcion: ''.usuario agregarTopicosFav: topico.self assert: usuario topicosFavoritos  size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/19/2020 23:59'!testAgregarPregunta	self assert: usuario preguntas size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/20/2020 00:00'!testEliminarRespuesta	| usuario2 |	usuario2 := Usuario nombreUsuario: '' contrasenha: ''.	respuesta := Respuesta		texto: ''		respondePregunta: pregunta		usuario: usuario2.	usuario2 eliminarRespuesta: respuesta.	self assert: usuario2 respuestas size equals: 0! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/20/2020 00:00'!testGuardarRespuesta	| usuario2 |	usuario2 := Usuario nombreUsuario: '' contrasenha: ''.	respuesta := Respuesta		texto: ''		respondePregunta: pregunta		usuario: usuario2.	self assert: usuario2 respuestas size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/11/2020 16:20'!testSeguir	| otrousuario |	otrousuario := Usuario nombreUsuario: 'otro' contrasenha: '.'.	usuario seguir: otrousuario.	self assert: usuario seguidos size equals: 1.	usuario seguir: otrousuario.	"No sigue al mismo usuario, si éste ya es seguido."	self assert: usuario seguidos size equals: 1! !!UsuarioTest methodsFor: 'tests' stamp: 'Anonymous 5/19/2020 23:59'!testCalcularPuntaje	self assert: usuario calcularPuntaje equals: 20! !!UsuarioTest methodsFor: 'running' stamp: 'Anonymous 5/11/2020 20:31'!setUp	| topicos |	cuoora := CuOOra new.	usuario := cuoora crearUsuario: 'usuario' contrasenha: ''.	topicos := OrderedCollection new.	topicos add: (Topico nombre: 'scify' descripcion: '').	pregunta := Pregunta		titulo: '?'		descripcion: ''		usuario: usuario		topicos: topicos.! !Object subclass: #CuOOra	instanceVariableNames: 'usuarios topicos'	classVariableNames: ''	package: 'Parte1-model'!!CuOOra methodsFor: 'initialization' stamp: 'Anonymous 5/19/2020 23:56'!initialize	| topicos1 topicos2 oo1 pedro juan diego preguntaPedro preguntaDiego |	usuarios := OrderedCollection new.	topicos := OrderedCollection new.	"Instancia de prueba: "	pedro := self		crearUsuario: 'pedro@cuoora.com'		contrasenha: 'pedro@cuoora.com'.	diego := self		crearUsuario: 'diego@cuoora.com'		contrasenha: 'diego@cuoora.com'.	juan := self		crearUsuario: 'juan@cuoora.com'		contrasenha: 'juan@cuoora.com'.	"el metodo existeUsuario: con:   devuelve al usuario con usuario y clave. O nil si no existe."	juan seguir: diego.	pedro seguir: juan.	"Creamos una coleccion de topicos para la primera pregunta"	topicos1 := OrderedCollection new.	oo1 := self agregarNombreTopico: 'OO1' descripcion: ''.	topicos1 add: oo1.	topicos1		add: (self agregarNombreTopico: 'Test de Unidad' descripcion: '').	topicos2 := OrderedCollection new.	topicos2 add: oo1.	topicos2 add: (self agregarNombreTopico: 'Smalltalk' descripcion: '').	preguntaPedro := Pregunta titulo: '¿Para qué sirve el método setUp?' descripcion: '' usuario: pedro topico: topicos1.	preguntaDiego := Pregunta titulo: '¿Qué significa #messageNotUnderstood?' descripcion: '' usuario: diego topico: topicos2.	Respuesta texto: 'Sirve para instanciar los objetos que son evaluados por el test en un único método y que se ejecute siempre antes de cada test.' respondePregunta: preguntaPedro usuario: diego.	Respuesta texto: 'Significa que el objeto que recibió el mensaje no encontró ningún método para ejecutar en respuesta.' respondePregunta: preguntaDiego usuario: pedro.! !!CuOOra methodsFor: 'accessing' stamp: 'Anonymous 5/11/2020 16:18'!topicos	^ topicos! !!CuOOra methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 18:01'!usuarios
	^usuarios.! !!CuOOra methodsFor: 'public' stamp: 'tom 4/16/2020 10:19'!crearUsuario: aNick contrasenha: aContrasenha
	| usuario |
	usuario := Usuario nombreUsuario: aNick contrasenha: aContrasenha.
	^ usuarios add: usuario! !!CuOOra methodsFor: 'public' stamp: 'Anonymous 4/6/2020 19:52'!existeUsuario:_nombre con:_contrasenha
	^ usuarios detect: [ :ea | ea nombre = _nombre & (ea contrasenha = _contrasenha)  ] ifNone: [ ^ nil ].! !!CuOOra methodsFor: 'public' stamp: 'tom 4/19/2020 14:35'!agregarNombreTopico: unNombre descripcion: unDescripcion
"crea al topico, lo agrega a la coleccion de topicos y lo retorna"
	| topico |
	topico := Topico nombre: unNombre descripcion: unDescripcion.
	^ topicos add: topico! !!CuOOra methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/9/2020 16:53'!existeTopico:_nombreTopico
	^ topicos detect: [ :ea | ea nombre = _nombreTopico] ifNone:[ ^ self agregarNombreTopico: _nombreTopico descripcion: '' ].! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!CuOOra class	instanceVariableNames: 'soleInstance'!!CuOOra class methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:43'!clearSoleInstance
	soleInstance := nil.! !!CuOOra class methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:43'!soleInstance
	^ soleInstance ifNil: [ soleInstance := self new ].! !Object subclass: #Publicacion	instanceVariableNames: 'likes dislikes fecha usuario'	classVariableNames: ''	package: 'Parte1-model'!!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 17:32'!fecha
	^ fecha! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/1/2020 16:26'!likes

^likes.! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/1/2020 16:26'!dislikes

^dislikes.! !!Publicacion methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 15:32'!usuario
	^ usuario! !!Publicacion methodsFor: 'initialization' stamp: 'Anonymous 5/20/2020 06:17'!darLike: unUsuario	(self dameReaccionDelUser: unUsuario de: likes)		ifNotNil: [ :arg | ^ false ]		ifNil: [ (self dameReaccionDelUser: unUsuario de: dislikes)				ifNotNil: [ :arg | dislikes remove: (self dameReaccionDelUser: unUsuario de: dislikes) ] ].	likes add: (Reaccion usuario: unUsuario).	^ true! !!Publicacion methodsFor: 'initialization' stamp: 'tom 4/16/2020 10:19'!initialize
	"like y dislike es una coleccion de reaccion para saber la cantidad de like solo debo llamar a like size "

	fecha := DateAndTime now.
	likes := OrderedCollection new.
	dislikes := OrderedCollection new! !!Publicacion methodsFor: 'initialization' stamp: 'Anonymous 5/20/2020 06:17'!darDisLike: unUsuario	(self dameReaccionDelUser: unUsuario de: dislikes)		ifNotNil: [ :arg | ^ false ]		ifNil: [ (self dameReaccionDelUser: unUsuario de: likes)				ifNotNil: [ :arg | likes remove: (self dameReaccionDelUser: unUsuario de: likes) ] ].	dislikes add: (Reaccion usuario: unUsuario).	^ true! !!Publicacion methodsFor: 'as yet unclassified' stamp: 'Anonymous 4/2/2020 16:09'!calcularPuntaje

^ ( (likes size) - (dislikes size) ).! !!Publicacion methodsFor: 'private' stamp: 'Anonymous 5/20/2020 06:05'!dameReaccionDelUser: unUsuario de: adislikes	^ adislikes detect: [ :reaccion | reaccion usuario = unUsuario ]ifNone:[^nil].! !Publicacion subclass: #Pregunta	instanceVariableNames: 'titulo descripcion topicos respuestas'	classVariableNames: ''	package: 'Parte1-model'!!Pregunta methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/19/2020 23:38'!obtenerRespuestasOrdenadas	respuestas		asSortedCollection: [ :r1 :r2 | r1 calcularPuntaje > r2 calcularPuntaje ]! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!topico: unTopico
	topicos := unTopico.
	topicos do: [ :topico | topico guardar: self ]! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 18:14'!titulo
	^ titulo.! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!borrarme
	"elimina todo rastro "

	"primero elimina la pregunta en los topicos"

	topicos do: [ :topico | topico eliminar: self ].
	self usuario eliminarPregunta: self.
	respuestas do: [ :respuesta | respuesta eliminar ]! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 5/19/2020 23:44'!usuario: aUser	aUser agregarPregunta: self.	usuario := aUser.! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!initialize
	super initialize.
	topicos := OrderedCollection new.
	respuestas := OrderedCollection new! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 15:19'!topicos
	^ topicos.! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!agregarRespuesta: unRespuesta
	respuestas add: unRespuesta! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!descripcion: unaDesc
	descripcion := unaDesc! !!Pregunta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!titulo: unTitulo
	titulo := unTitulo! !!Pregunta methodsFor: 'accessing' stamp: 'Anonymous 4/2/2020 13:06'!respuestas
^ respuestas.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Pregunta class	instanceVariableNames: ''!!Pregunta class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!titulo: unTitulo descripcion: unaDescripcion usuario: unUsuario topico: unTopico
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
	^ preguntaResponde.! !!Respuesta methodsFor: 'accessing' stamp: 'Anonymous 5/19/2020 23:41'!preguntaResponde: unaPregunta	preguntaResponde := unaPregunta.	unaPregunta agregarRespuesta: self.! !!Respuesta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:15'!eliminar
	self usuario eliminarRespuesta: self! !!Respuesta methodsFor: 'accessing' stamp: 'Anonymous 5/19/2020 23:44'!usuario: aUser	aUser guardarRespuesta: self.	usuario := aUser.! !!Respuesta methodsFor: 'accessing' stamp: 'Anonymous 4/10/2020 16:02'!texto
	^texto.! !!Respuesta methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:16'!texto: unTexto
	texto := unTexto! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Respuesta class	instanceVariableNames: ''!!Respuesta class methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/19/2020 23:40'!texto: unTexto respondePregunta: unaPregunta usuario: unUsuario	^ self new		preguntaResponde: unaPregunta;		texto: unTexto;		usuario: unUsuario;		yourself! !Object subclass: #Topico	instanceVariableNames: 'nombre descripcion preguntas'	classVariableNames: ''	package: 'Parte1-model'!!Topico methodsFor: 'accessing' stamp: 'Anonymous 4/9/2020 15:50'!nombre 
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
		yourself! !Object subclass: #Usuario	instanceVariableNames: 'nombre contrasenha fecha seguidos preguntas respuestas topicoFavoritos'	classVariableNames: ''	package: 'Parte1-model'!!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 20:59'!calcularPuntaje	| respuestasAOtroUsuario |	respuestasAOtroUsuario := respuestas		reject: [ :ea | ea preguntaResponde usuario == self ].	"Solo las respuestas de preguntas que no sean suyas."	^ preguntas size * 20 + (respuestasAOtroUsuario size * 50)		+ (self sumar: preguntas) + (self sumar: respuestas)! !!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 16:19'!topicosFavoritos	^ topicoFavoritos.! !!Usuario methodsFor: 'as yet unclassified' stamp: 'Anonymous 5/11/2020 20:59'!sumar: aCollection	aCollection		ifNotEmpty: [ ^ aCollection sum: [ :item | item calcularPuntaje ] ].	^ 0! !!Usuario methodsFor: 'accessing - private' stamp: 'Anonymous 5/19/2020 23:34'!getFirst: n from: aCollection	^ aCollection takeFirst: n! !!Usuario methodsFor: 'initialization' stamp: 'Anonymous 5/11/2020 03:00'!initialize	fecha := DateAndTime now.	seguidos := OrderedCollection new.	preguntas := OrderedCollection new.	topicoFavoritos := OrderedCollection new.	respuestas := OrderedCollection new! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!contrasenha: acontrasenha
	contrasenha := acontrasenha! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!agregarPregunta: unaPregunta
	preguntas add: unaPregunta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 4/2/2020 11:52'!nombre
	^nombre.! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!agregarTopicosFav: untopico
	topicoFavoritos add: untopico! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!preguntas
	^ preguntas! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!eliminarPregunta: apregunta
	preguntas remove: apregunta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 4/6/2020 19:53'!contrasenha 	
	^ contrasenha.! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!nombre: aName
	nombre := aName! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:12'!eliminarRespuesta: unaRespuesta
	respuestas remove: unaRespuesta! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 5/19/2020 23:36'!preguntasRelevantes	| resultado |	resultado := Set new.	resultado		addAll: (topicoFavoritos flatCollect: [ :ea | ea preguntas ]).	resultado addAll: (seguidos flatCollect: [ :ea | ea preguntas ]).	^ self getFirst:5 from:(resultado		asSortedCollection: [ :p1 :p2 | p1 calcularPuntaje > p2 calcularPuntaje ])! !!Usuario methodsFor: 'accessing' stamp: 'Anonymous 5/20/2020 00:04'!seguir: unUsuarioAseguir	(seguidos anySatisfy: [ :u | u = unUsuarioAseguir ])		| (unUsuarioAseguir = self)		ifFalse: [ seguidos add: unUsuarioAseguir ]! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:14'!seguidos
	^ seguidos! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!guardarRespuesta: unaRespuesta
	respuestas add: unaRespuesta! !!Usuario methodsFor: 'accessing' stamp: 'tom 4/16/2020 10:13'!respuestas
	^ respuestas! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Usuario class	instanceVariableNames: ''!!Usuario class methodsFor: 'as yet unclassified' stamp: 'tom 4/16/2020 10:11'!nombreUsuario: aNombre contrasenha: acontrasenha
	^ self new
		nombre: aNombre;
		contrasenha: acontrasenha;
		yourself! !