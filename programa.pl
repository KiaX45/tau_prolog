:- dynamic(paso/1).  % Hacemos que 'paso' sea un predicado dinámico.
:- dynamic(temporada/1).  % Hacemos que 'temporada' sea un predicado dinámico.
:- dynamic(fuente/1).  % Hacemos que 'fuente' sea un predicado dinámico.

regla(Respuesta):- 
    % Si hay algún paso, mostramos un mensaje
    (paso(_) -> 
        fail
    ;
        % Si no hay pasos, asignamos la lista de pasos a Respuesta
        !,ListaPasos = ['PREGUNTA', 'Seleccione el procedimiento deseado', 'Preparacion', 'Referente a las pruebas previas que deben realizarse según el clima o temporada para determinar la dosis óptima de coagulante necesaria en la planta Centenario.',
        'Pruebas Previas', 'Contiene información acerca de los tipos de pruebas que se manejan en la planta Centenario para determinar la dosis necesaria de coagulante.',
        'Dosificacion en la planta', 'Consiste en los procesos disponibles para realizar la dosificación de coagulante al agua que está siendo tratada en la planta Centenario| dependiendo de si se cuenta con electricidad o no en el momento.',
        'Analisis posteriores', 'Referente a las pruebas que se pueden realizar para verificar que la dosis de coagulante aplicada al agua a tratar sea adecuada.'],
        Respuesta = ListaPasos,
        %borramos la lista de pasos
        retractall(paso(_)),
        assertz(paso('RegistrarPasoInicial'))
    ).

regla(Respuesta):-
    (paso('RegistrarPasoInicial') ->
        !,retractall(paso(_)),!,
        assertz(paso(Respuesta))
    ).

%R1
regla(Respuesta):-
    (paso('Preparacion') ->
        !,Respuesta = ['PREGUNTA', '¿En que temporada se encuentra?', 'Temporada Seca', 'Soleado sin lluvia', 'Temporada Lluviosa', 'Lluvioso'],
        retractall(paso(_)),
        assertz(paso('RegistrarTemporada'))
    ).

regla(Respuesta):-
    (paso('RegistrarTemporada') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Temporada')),
        assertz(temporada(Respuesta))
    ).



regla(Respuesta):-
    (paso('Comprobar Temporada'), temporada('Temporada Lluviosa') ->
        !,Respuesta = ['RESPUESTA', 'Se realiza el analisis de cargas por media hora', 'se realiza la prueba de jarras cada hora'],
        %es el final del arbol en esta rama por lo que nos devolvemos 
        retractall(paso(_)),
        retractall(temporada(_))
    ).

%R4
regla(Respuesta):-
    (paso('Comprobar Temporada'), temporada('Temporada Seca') ->
        !,Respuesta = ['PREGUNTA', '¿Que tipo de abastecimiento tiene actualmente?', 'Abastecimiento regular', 'El agua proviene del Río Pasto y de la Quebrada Lope', 'Abastecimiento regular y alterno', 'El agua proviene de Río Bobo y de la Quebrada Piedras'], 
        retractall(paso(_)),
        retractall(temporada(_)),
        assertz(paso('Comporbar Fuentes'))
    ).

%R5
regla(Respuesta):-
    (paso('Comporbar Fuentes') ->
        !,retractall(paso(_)),
        assertz(paso('Analizar Fuentes')),
        assertz(fuente(Respuesta))
    ).

%R6
regla(Respuesta):-
    (paso('Analizar Fuentes'), fuente('Abastecimiento regular y alterno') ->
        !,Respuesta = ['RESPUESTA', 'realizar prueba de jarras cada 8 horas'],
        retractall(paso(_)),
        retractall(fuente(_))
    ).

%R7
regla(Respuesta):-
    (paso('Analizar Fuentes'), fuente('Abastecimiento regular') ->
        !,Respuesta = ['PREGUNTA', 'selccione la opcion correspondiente','La turbiedad es menor a 10 y el color aparente es menor a 100', 'La turbiedad es mayor igual a 10 y el color aparente es mayor igual a 100', 'EXPLICAR', 'La turbiedad es la medida de la cantidad de particulas que impiden el paso de luz a través del agua, haciendo que a mayor turbiedad, el agua se vea más sucia.
                       El color aparente es el resultado de las sustancias suspendidas y disueltas en el agua, a mayor grado, es más visible.'],
        retractall(paso(_)),
        retractall(fuente(_)),
        assertz(paso('Registrar Estado'))
    ).

%R7.1
:- dynamic(estado/1).

regla(Respuesta):-
    (paso('Registrar Estado') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Estado')),
        assertz(estado(Respuesta))
    ).

%R8
regla(Respuesta):-
    (paso('Comprobar Estado'), estado('La turbiedad es menor a 10 y el color aparente es menor a 100') ->
        !,Respuesta = ['RESPUESTA', 'Dosis de coagulante entre 20 y 35 mg/L'],
        retractall(paso(_)),
        retractall(estado(_))
    ).

%R9
regla(Respuesta):-
    (paso('Comprobar Estado'), estado('La turbiedad es mayor igual a 10 y el color aparente es mayor igual a 100') ->
        !,Respuesta = ['RESPUESTA',  'Realizar prueba de jarras cada 8 horas'],
        retractall(paso(_)),
        retractall(estado(_))
    ).
%------------------------------------------------------------------------------------------------------------
%Pruebas previas
%R10
regla(Respuesta):-
    (paso('Pruebas Previas') ->
        !,Respuesta = ['PREGUNTA', 'Seleccione el procedimiento deseado','Prueba de jarras', 'Ensayo de laboratorio que simula coagulación| floculación y sedimentación| para determinar dosis de coagulante.', 'Analisis de cargas', 'Ensayo de laboratorio que permite determinar dosis de coagulante a partir de la neutralización de cargas eléctricas del agua.'],
        retractall(paso(_)),
        assertz(paso('RegistrarPrueba'))
    ).

:- dynamic(prueba/1).
%R11
regla(Respuesta):-
    (paso('RegistrarPrueba') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Prueba')),
        !,assertz(prueba(Respuesta))
    ).

%R12
regla(Respuesta):-
    (paso('Comprobar Prueba'), prueba('Prueba de jarras') ->
        !,Respuesta = ['PREGUNTA', 'Seleccione el procedimiento deseado', 'Dosis de coagulante', 'Referente a las dosis de coagulante seleccionadas para colocar en cada una de las jarras de la prueba.', 'Operacion de la maquina', 'Referente a los procesos de coagulación| floculación y sedimentación que son simulados en la prueba de jarras.'],
        retractall(paso(_)),
        retractall(prueba(_)),
        assertz(paso('RegistrarFase'))
    ).

%R13
:- dynamic(fase/1).
regla(Respuesta):-
    (paso('RegistrarFase') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Fase')),
        assertz(fase(Respuesta))
    ).

%R14
regla(Respuesta):-
    (paso('Comprobar Fase'), fase('Dosis de coagulante') ->
        !,Respuesta = ['PREGUNTA',  'Seleccione el procedimiento deseado','Medio de dosificacion', 'De qué forma se dosifica el coagulante en las jarras', 'Tipo de dosificador', 'Debe definirse el instrumento con el cual se dosifica las cantidades de coagulante correspondientes.', 'Dosis a probar', 'Rango de dosis a probar en las jarras.'],
        retractall(paso(_)),
        retractall(fase(_)),
        assertz(paso('Registrar Aspecto'))
    ).

%R15
:- dynamic(aspecto/1).
regla(Respuesta):-
    (paso('Registrar Aspecto') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Aspecto')),
        assertz(aspecto(Respuesta))
    ).

%R16
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Medio de dosificacion') ->
        !,Respuesta = ['PREGUNTA', '¿Que tipo de dosificacion se esta usando?','Dosificacion directa', 'Dosificación en jarras.', 'Dosificacion indirecta', 'Dosificación en algún medio externo para luego ser llevada la sustancia a las jarras.'],
        retractall(paso(_)),
        retractall(aspecto(_)),
        assertz(paso('Registrar Dosificacion'))
    ).

%R17
:- dynamic(dosificacion/1).
regla(Respuesta):-
    (paso('Registrar Dosificacion') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Dosificacion')),
        assertz(dosificacion(Respuesta))
    ).

%R18
regla(Respuesta):-
    (paso('Comprobar Dosificacion'), dosificacion('Dosificacion indirecta') ->
        !,Respuesta = ['RESPUESTA', 'Dosificar en círculos de caucho'],
        retractall(paso(_)),
        retractall(dosificacion(_))
    ).

%R19
regla(Respuesta):-
    (paso('Comprobar Dosificacion'), dosificacion('Dosificacion directa') ->
        !,Respuesta = ['RESPUESTA', 'Dosificar en jarras'],
        retractall(paso(_)),
        retractall(dosificacion(_))
    ).

%R20
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Tipo de dosificador') ->
        retractall(paso(_)),
        retractall(aspecto(_)),
        assertz(paso('Registrar Dosificador')),
        !,Respuesta = ['PREGUNTA', '¿Que tipo de dosificador se esta usando?', 'Micropipeteador', ' Dosificador electrónico automático que facilita la transferencia de muestras líquidas.', 'Jeringa', ' En caso de no contar con dosificador automático| puede usar jeringas para ello.']
    ).

%R21
:- dynamic(dosificador/1).
regla(Respuesta):-
    (paso('Registrar Dosificador') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Dosificador')),
        assertz(dosificador(Respuesta))
    ).

%R22
regla(Respuesta):-
    (paso('Comprobar Dosificador'), dosificador('Micropipeteador') ->
        !,Respuesta = ['RESPUESTA', 'Coagulante puro de densidad 1.325g/ml'],
        retractall(paso(_)),
        retractall(dosificador(_))
    ).

%R23
regla(Respuesta):-
    (paso('Comprobar Dosificador'), dosificador('Jeringa') ->
        !,Respuesta = ['RESPUESTA', 'Solubilizar el coagulante en agua destilada al 2% (2g/100mL)'],
        retractall(paso(_)),
        retractall(dosificador(_))
    ).

%R24
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Dosis a probar') ->
        !,Respuesta = ['RESPUESTA', 'Desde 20 hata 130 mg/L'],
        retractall(paso(_)),
        retractall(aspecto(_))
    ).

%R25

regla(Respuesta):-
    (paso('Comprobar Fase'), fase('Operacion de la maquina') ->
        !,Respuesta = ['PREGUNTA', '¿Que tipo de operacion se esta realizando?', 'Coagulacion', ' En prueba de jarras| coagulación hace referencia a la primera etapa de esta prueba| cuando el coagulante es mezclado con el agua.', 'Floculacion', ' En prueba de jarras| floculación hace referencia a la segunda etapa de esta prueba| cuando las paletas comienzan a girar a velocidades bajas para lograr la formación de floc.', 'Sedimentacion', ' En prueba de jarras| sedimentación hace referencia a la última etapa de esta prueba| cuando una vez formado el floc| se deja las jarras en reposo para que este caiga al fondo de cada contenedor.'],
        retractall(paso(_)),
        assertz(paso('Registrar Aspecto'))
    ).

%R26
%En este caso se hace uso de la regla 15

%R27
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Coagulacion') ->
        !,Respuesta = ['RESPUESTA', 'Realizar el proceso durante 10 segundos a 300rpm'],
        retractall(paso(_)),
        retractall(aspecto(_)),
        assertz(paso('Registrar Aspecto'))
    ).

%R28
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Floculacion') ->
        !,Respuesta = ['RESPUESTA', 'Realizar el proceso durante 10 minutos a 40rpm'],
        retractall(paso(_)),
        retractall(aspecto(_)),
        assertz(paso('Preguntar Formacion_de_floc'))
    ).  

%R28.1
regla(Respuesta):-
    (paso('Preguntar Formacion_de_floc') ->
        !,Respuesta = ['PREGUNTA', '¿Observa formacion de floc?', 'si', 'no', 'EXPLICAR',  'La unión de partículas microscópicas debido a la coagulación, permite que estas se vuelvan visibles al estar juntas, eso se conoce como floc.'],
        retractall(paso(_)),
        assertz(paso('Registrar Formacion_de_floc'))
    ).

%R29
:- dynamic(formacion_de_floc/1).
regla(Respuesta):-
    (paso('Registrar Formacion_de_floc') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Formacion_de_floc')),
        assertz(formacion_de_floc(Respuesta))
    ).

%R30
regla(Respuesta):-
    (paso('Comprobar Formacion_de_floc'), formacion_de_floc('si') ->
        !,Respuesta = ['PREGUNTA', '¿Cuantas jarras optimas observa?', 'solo 1', 'mas de 1', 'EXPLICAR', 'Hace referencia a aquellas donde puede observarse con mucho detalle la formación de floc.'],
        retractall(paso(_)),
        retractall(formacion_de_floc(_)),
        assertz(paso('Registrar Cantidad_de_jarras'))
    ).

%R31
:- dynamic(cantidad_de_jarras/1).
regla(Respuesta):-
    (paso('Registrar Cantidad_de_jarras') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Cantidad_de_jarras')),
        assertz(cantidad_de_jarras(Respuesta))
    ).

%R31.1
regla(Respuesta):-
    (paso('Comprobar Cantidad_de_jarras'), cantidad_de_jarras('solo 1') ->
        !,Respuesta = ['RESPUESTA', 'Cantidad de coagulante definitiva'],
        retractall(paso(_)),
        retractall(cantidad_de_jarras(_))
    ).

%R32
regla(Respuesta):-
    (paso('Comprobar Cantidad_de_jarras'), cantidad_de_jarras('mas de 1') ->
        !,Respuesta = ['RESPUESTA', 'Descarte el resto de las Jaras', 'Esperar a Sedimentacion'],
        retractall(paso(_)),
        retractall(cantidad_de_jarras(_))
    ).

%R33
regla(Respuesta):-
    (paso('Comprobar Formacion_de_floc'), formacion_de_floc('no') ->
        !,Respuesta = ['PREGUNTA', '¿Exite un aumento en la turbiedad?', 'Primeras Jarras', 'Ultimas Jarras', 'Ninguna', 'EXPLICAR', ' Medida de la cantidad de particulas que impiden el paso de luz a través del agua, haciendo que a mayor turbiedad, el agua se vea más sucia.'],
        retractall(paso(_)),
        retractall(formacion_de_floc(_)),
        assertz(paso('Registrar aumento_turbiedad'))
    ).

%R34
:- dynamic(aumento_turbiedad/1).
regla(Respuesta):-
    (paso('Registrar aumento_turbiedad') ->
        retractall(paso(_)),
        assertz(paso('Comprobar aumento_turbiedad')),
        assertz(aumento_turbiedad(Respuesta))
    ).

%R35
regla(Respuesta):-
    (paso('Comprobar aumento_turbiedad'), aumento_turbiedad('Primeras Jarras') ->
        !,Respuesta = ['RESPUESTA', 'Repita dosificacion en jarras con menos cantidad de coagulante, terminando por debajo de la dosis menor'],
        retractall(paso(_)),
        retractall(aumento_turbiedad(_))
    ).

%R36
regla(Respuesta):-
    (paso('Comprobar aumento_turbiedad'), aumento_turbiedad('Ultimas Jarras') ->
        !,Respuesta = ['RESPUESTA', 'Repita dosificacion en jarras con más cantidad de coagulante, comenzando por arriba de la dosis mayor'],
        retractall(paso(_)),
        retractall(aumento_turbiedad(_))
    ).

%R37
regla(Respuesta):-
    (paso('Comprobar aumento_turbiedad'), aumento_turbiedad('Ninguna') ->
        !,Respuesta = ['RESPUESTA', 'Realizar analisis de cargas', 'Repita prueba de jarras incluyendo la dosis encontrada'],
        retractall(paso(_)),
        retractall(aumento_turbiedad(_))
    ).

%R38
regla(Respuesta):-
    (paso('Comprobar Aspecto'), aspecto('Sedimentacion') ->
        !,Respuesta = ['RESPUESTA', '10 minutos a 0 rpm'],
        retractall(paso(_)),
        retractall(aspecto(_)),
        assertz(paso('Registrar agua_clara'))

    ).

%R39
:- dynamic(agua_clara/1).
regla(Respuesta):-
    (paso('Registrar agua_clara') ->
        !,Respuesta = ['PREGUNTA', '¿El agua es mas clara?', 'si', 'no', 'EXPLICAR', 'Agua más transparente, con turbiedad y color muy bajos.'],
        retractall(paso(_)),
        assertz(paso('Comprobar agua_clara')),
        assertz(agua_clara(Respuesta))
    ).

%R40
regla(Respuesta):-
    (paso('Comprobar agua_clara'), agua_clara('si') ->
        !,Respuesta = ['PREGUNTA', '¿Cual es la cantidad de jarras optimas?', 'solo 1', 'mas de 1', 'EXPLICAR', 'Jarras óptimas son aquellas jarras donde el agua es más clara'],    
        retractall(paso(_)),
        assertz(paso('Registrar Cantidad_de_jarras_optimas'))
    ).

%R41
:- dynamic(cantidad_de_jarras_optimas/1).
regla(Respuesta):-
    (paso('Registrar Cantidad_de_jarras_optimas') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Cantidad_de_jarras_optimas')),
        assertz(cantidad_de_jarras_optimas(Respuesta))
    ).

%R42
regla(Respuesta):-
    (paso('Comprobar Cantidad_de_jarras_optimas'), cantidad_de_jarras_optimas('solo 1') ->
        !,Respuesta = ['RESPUESTA', 'Cantidad de coagulante definitiva'],
        retractall(paso(_)),
        retractall(cantidad_de_jarras_optimas(_))
    ).

%R43
regla(Respuesta):-
    (paso('Comprobar Cantidad_de_jarras_optimas'), cantidad_de_jarras_optimas('mas de 1') ->
        !,Respuesta = ['RESPUESTA', 'Descarte el resto de las Jaras', 'Esperar a Sedimentacion'],
        retractall(paso(_)),
        retractall(cantidad_de_jarras_optimas(_))
    ).

%R44
%Agua no clara
regla(Respuesta):-
    (paso('Comprobar agua_clara'), agua_clara('no') ->
        !,Respuesta = ['PREGUNTA', '¿Observa color en alguna de las jarras?', 'si', 'no', 'EXPLICAR', ' Si observa que el agua tiene algún tinte en lugar de verse transparente, entonces es porque hay presencia de color.'],
        retractall(paso(_)),
        retractall(agua_clara(_)),
        assertz(paso('Registrar Color_Jarras'))  
    ).

%R45
:- dynamic(color_jarras/1).
regla(Respuesta):-
    (paso('Registrar Color_Jarras') ->
        retractall(paso(_)),
        assertz(paso('Comprobar Color_Jarras')),
        assertz(color_jarras(Respuesta))
    ).

%R46
regla(Respuesta):-
    (paso('Comprobar Color_Jarras'), color_jarras('no') ->
        !,Respuesta = ['RESPUESTA', 'Repita dosificacion en jarras con un rango mayor entre una dosis y otra'],
        retractall(paso(_)),
        retractall(color_jarras(_))
    ).

%R47
regla(Respuesta):-
    (paso('Comprobar Color_Jarras'), color_jarras('si') ->
        !,Respuesta = ['PREGUNTA', '¿Cual es el color del agua?', 'Rojizo', 'Plateado', 'EXPLICAR', ' Hace referencia al color que puede detectarse a simple vista en el agua.'],
        retractall(paso(_)),
        retractall(color_jarras(_)),
        assertz(paso('Registrar Coloracion'))
    ).

%R48
:- dynamic(coloracion/1).
regla(Respuesta):-
    (paso('Registrar Coloracion') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Coloracion')),
        assertz(coloracion(Respuesta))
    ).

%R49
regla(Respuesta):-
    (paso('Comprobar Coloracion'), coloracion('Rojizo') ->
        !,Respuesta = ['RESPUESTA', 'Repita dosificación en jarras con más cantidad de coagulante, comenzando por arriba de la dosis de la jarra en cuestión'],
        retractall(paso(_)),
        retractall(coloracion(_))
    ).

%R50
regla(Respuesta):-
    (paso('Comprobar Coloracion'), coloracion('Plateado') ->
        !,Respuesta = ['RESPUESTA', 'Repita dosificación en jarras con menos cantidad de coagulante, terminando por debajo de la dosis de la jarra en cuestión'],
        retractall(paso(_)),
        retractall(coloracion(_))
).

%R51
%comprobar tipo de prueba prueba analisis de cargas
regla(Respuesta):-
    (paso('Comprobar Prueba'), prueba('Analisis de cargas') ->
        !,Respuesta = ['PREGUNTA', 'Seleccione el tipo de analisis', 'Tipo de dosificador', ' Debe definirse el instrumento con el cual se dosifica las cantidades de coagulante correspondientes.', 'Operacion de la maquina', 'Referente al proceso de mezcla de coagulante con verificación de cargas.'],
        retractall(paso(_)),
        retractall(prueba(_)),
        assertz(paso('Registrar Capa'))
    ).

%R52
:- dynamic(capa/1).
regla(Respuesta):-
    (paso('Registrar Capa') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Capa')),
        assertz(capa(Respuesta))
    ).

%R53
regla(Respuesta):-
    (paso('Comprobar Capa'), capa('Tipo de dosificador') ->
        !,Respuesta = ['PREGUNTA', '¿Que tipo de dosificador se esta usando?', 'Micropipeteador', ' Dosificador electrónico automático que facilita la transferencia de muestras líquidas.', 'Jeringa', 'En caso de no contar con dosificador automático| puede usar jeringas para ello.'],
        retractall(paso(_)),
        retractall(capa(_)),
        assertz(paso('Registrar Elemento'))
    ).

%R54
:- dynamic(elemento/1).
regla(Respuesta):-
    (paso('Registrar Elemento') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Elemento')),
        assertz(elemento(Respuesta))
    ).

%R55
regla(Respuesta):-
    (paso('Comprobar Elemento'), elemento('Micropipeteador') ->
        !,Respuesta = ['RESPUESTA', 'Coagulante puro de densidad 1.325g/ml'],
        retractall(paso(_)),
        retractall(elemento(_))
    ).

%R56
regla(Respuesta):-
    (paso('Comprobar Elemento'), elemento('Jeringa') ->
        !,Respuesta = ['RESPUESTA', 'Solubilizar el coagulante en agua destilada al 2% (2g/100mL)'],
        retractall(paso(_)),
        retractall(elemento(_))
    ).

%R57
regla(Respuesta):-
    (paso('Comprobar Capa'), capa('Operacion de la maquina') ->
        !,Respuesta = ['RESPUESTA', 'Encienda el mezclador', 'Dosifique el coagulante', 'Carga se estabiliza en un Rango de aceptacion +1/-1'],
        retractall(paso(_)),
        assertz(paso('Preguntar Valor_Carga'))
    ).

%R58
regla(Respuesta):-
    (paso('Preguntar Valor_Carga') ->
        !,Respuesta = ['PREGUNTA', '¿El valor de carga llega al 0?', 'No', 'Si', 'Superior a 0', 'EXPLICAR', 'El analizador de cargas cuenta con una pantalla donde se presenta un número que puede ser positivo, negativo o cero, a medida que se agrega el coagulante dicho número va cambiando, al dosificar debe buscarse que dicho valor llegue a cero.'],
        retractall(paso(_)),
        assertz(paso('Registrar Valor_Carga'))
    ).

%R59
:- dynamic(valor_carga/1).
regla(Respuesta):-
    (paso('Registrar Valor_Carga') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Valor_Carga')),
        assertz(valor_carga(Respuesta))
    ).

%R60
regla(Respuesta):-
    (paso('Comprobar Valor_Carga'), valor_carga('No') ->
        !,Respuesta = ['RESPUESTA', 'Dosifique mas coagulante'],
        retractall(paso(_)),
        retractall(valor_carga(_))
    ).

%R61
regla(Respuesta):-
    (paso('Comprobar Valor_Carga'), valor_carga('Si') ->
        !,Respuesta = ['RESPUESTA', 'Dosis de coagulante definitiva'],
        retractall(paso(_)),
        retractall(valor_carga(_))
    ).

%R62
regla(Respuesta):-
    (paso('Comprobar Valor_Carga'), valor_carga('Superior a 0') ->
        !,Respuesta = ['RESPUESTA', 'Elegir dosis intermedia entre la última y penúltima dosis'],
        retractall(paso(_)),
        retractall(valor_carga(_))
    ).  

%------------------------------------------------------------------------------------------------------------
%3. Dosificacion en la planta
%R63
regla(Respuesta):-
    (paso('Dosificacion en la planta') ->
        !,Respuesta = ['RESPUESTA', ' Realice medición de caudal', 'Recuerde aplicar la dosis de acuerdo al caudal'],
        retractall(paso(_)),
        assertz(paso('Preguntar Electricidad'))
    ).

%R64
regla(Respuesta):-
    (paso('Preguntar Electricidad') ->
        !,Respuesta = ['PREGUNTA', '¿Hay electricidad?', 'Si', 'No', 'EXPLICAR', ' Si hay luz, o se encuentra activa la planta de energía.'],
        retractall(paso(_)),
        assertz(paso('Registrar Electricidad'))
    ).

%R65
:- dynamic(electricidad/1).
regla(Respuesta):-
    (paso('Registrar Electricidad') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Electricidad')),
        assertz(electricidad(Respuesta))
    ).

%R66
regla(Respuesta):-
    (paso('Comprobar Electricidad'), electricidad('Si') ->
        !,Respuesta = ['RESPUESTA', 'Ajuste el variador de frecuencia'],
        retractall(paso(_)),
        retractall(electricidad(_)),
        assertz(paso('Preguntar Dosis'))
    ).

%R67
%preguntar dosis
regla(Respuesta):-
    (paso('Preguntar Dosis') ->
        !,Respuesta = ['PREGUNTA', '¿Está aplicando la dosis adecuada?', 'si', 'no'],
        retractall(paso(_)),
        assertz(paso('Registrar Dosis'))
    ).

%R68
:- dynamic(dosis/1).
regla(Respuesta):-
    (paso('Registrar Dosis') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar Dosis')),
        assertz(dosis(Respuesta))
    ).

%R69
regla(Respuesta):-
    (paso('Comprobar Dosis'), dosis('si') ->
        !,Respuesta = ['RESPUESTA', 'Continúe con la dosis actual'],
        retractall(paso(_)),
        retractall(dosis(_))
    ).

%R70
regla(Respuesta):-
    (paso('Comprobar Dosis'), dosis('no') ->
        !,Respuesta = ['PREGUNTA', '¿Conoce la dosis actual de coagulante que se está dosificando?', 'si', 'no', 'EXPLICAR', 'Aforo: Cuando no se conoce la dosis actual en planta, es recomendable realizar una medición de cuánto coagulante está cayendo al agua por unidad de tiempo, esto es conocido también como un aforo.'],
        retractall(paso(_)),
        retractall(dosis(_)),
        assertz(paso('Registrar DosisActual'))
    ).

%R71
:- dynamic(dosis_actual/1).
regla(Respuesta):-
    (paso('Registrar DosisActual') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar DosisActual')),
        assertz(dosis_actual(Respuesta))
    ).

%R72
regla(Respuesta):-
    (paso('Comprobar DosisActual'), dosis_actual('si') ->
        !,Respuesta = ['RESPUESTA', 'Ajuste el variador de frecuencia'],
        retractall(paso(_)),
        retractall(dosis_actual(_))
    ).

%R73
regla(Respuesta):-
    (paso('Comprobar DosisActual'), dosis_actual('no') ->
        !,Respuesta = ['RESPUESTA', 'Realice un aforo', 'Ajuste el variador de frecuencia según resultado del aforo'],
        retractall(paso(_)),
        retractall(dosis_actual(_))
    ).

%R74
regla(Respuesta):-
    (paso('Comprobar Electricidad'), electricidad('No') ->
        !,Respuesta = ['RESPUESTA', 'Prepare material para aforo', 'Abra la válvula', 'Realice aforo'],
        retractall(paso(_)),
        retractall(electricidad(_)),
        assertz(paso('Preguntar DosisOptima'))
    ).

%R75
regla(Respuesta):-
    (paso('Preguntar DosisOptima') ->
        !,Respuesta = ['PREGUNTA', '¿Está aplicando la dosis óptima?', 'si', 'no'],
        retractall(paso(_)),
        assertz(paso('Registrar DosisOptima'))
    ).

%R76
:- dynamic(dosis_optima/1).
regla(Respuesta):-
    (paso('Registrar DosisOptima') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar DosisOptima')),
        assertz(dosis_optima(Respuesta))
    ).

%R77
regla(Respuesta):-
    (paso('Comprobar DosisOptima'), dosis_optima('si') ->
        !,Respuesta = ['RESPUESTA', 'Continúe con la dosis actual'],
        retractall(paso(_)),
        retractall(dosis_optima(_))
    ).

%R78
regla(Respuesta):-
    (paso('Comprobar DosisOptima'), dosis_optima('no') ->
        !,Respuesta = ['RESPUESTA', 'Ajustar la válvula', 'Realizar aforo', 'Repetir proceso hasta encontrar dosis óptima'],
        retractall(paso(_)),
        retractall(dosis_optima(_))
    ).

%------------------------------------------------------------------------------------------------
%4. Analisis posteriores

%R79
regla(Respuesta):-
    (paso('Analisis posteriores') ->
        !,Respuesta = ['RESPUESTA', 'Revisar sección de floculadores'],
        retractall(paso(_)),
        assertz(paso('Preguntar ColoracionFloculadores'))
    ).

%R80
regla(Respuesta):-
    (paso('Preguntar ColoracionFloculadores') ->
        !,Respuesta = ['PREGUNTA', '¿Observa color en el agua en la sección de floculadores?', 'Color Rojizo', 'Color Plateado',  'Sin color aparente', 'EXPLICAR', ' Hace referencia al color que puede detectarse a simple vista en el agua.'],
        retractall(paso(_)),
        assertz(paso('Registrar ColoracionFloculadores'))
    ).

%R81
:- dynamic(coloracion_floculadores/1).
regla(Respuesta):-
    (paso('Registrar ColoracionFloculadores') ->
        !,retractall(paso(_)),
        assertz(paso('Comprobar ColoracionFloculadores')),
        assertz(coloracion_floculadores(Respuesta))
    ).

%R82
regla(Respuesta):-
    (paso('Comprobar ColoracionFloculadores'), coloracion_floculadores('Color Rojizo') ->
        !,Respuesta = ['RESPUESTA', 'Necesita más coagulante'],
        retractall(paso(_)),
        retractall(coloracion_floculadores(_))
    ).

%R83
regla(Respuesta):-
    (paso('Comprobar ColoracionFloculadores'), coloracion_floculadores('Color Plateado') ->
        !,Respuesta = ['RESPUESTA', 'Necesita menos coagulante'],
        retractall(paso(_)),
        retractall(coloracion_floculadores(_))
    ).

%R84
regla(Respuesta):-
    (paso('Comprobar ColoracionFloculadores'), coloracion_floculadores('Sin color aparente') ->
        !,Respuesta = ['RESPUESTA', 'Continúe con la dosis actual'],
        retractall(paso(_)),
        retractall(coloracion_floculadores(_))
    ).

limpiar:-
    retractall(paso(_)),
    retractall(temporada(_)),
    retractall(fuente(_)),
    retractall(estado(_)),
    retractall(prueba(_)),
    retractall(fase(_)),
    retractall(aspecto(_)),
    retractall(dosificacion(_)),
    retractall(dosificador(_)),
    retractall(cantidad_de_jarras(_)),
    retractall(formacion_de_floc(_)),
    retractall(aumento_turbiedad(_)),
    retractall(agua_clara(_)),
    retractall(cantidad_de_jarras_optimas(_)),
    retractall(color_jarras(_)),
    retractall(coloracion(_)),
    retractall(capa(_)),
    retractall(elemento(_)),
    retractall(valor_carga(_)),
    retractall(electricidad(_)),
    retractall(dosis(_)),
    retractall(dosis_actual(_)),
    retractall(dosis_optima(_)),
    retractall(coloracion_floculadores(_)).
