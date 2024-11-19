:- dynamic(paso/1).  % Hacemos que 'paso' sea un predicado dinámico.
:- dynamic(temporada/1).  % Hacemos que 'temporada' sea un predicado dinámico.

regla(Respuesta):- 
    % Si hay algún paso, mostramos un mensaje
    (paso(_) -> 
        fail
    ;
        % Si no hay pasos, asignamos la lista de pasos a Respuesta
        !,ListaPasos = ['PREGUNTA',  'preparacion', 'pruebasPrevias', 'Dosificacion en la planta', 'Analisis posteriores'],
        Respuesta = ListaPasos,
        %borramos la lista de pasos
        retractall(paso(_)),
        assertz(paso('RegistrarPasoInicial'))
    ).

regla(Respuesta):-
    (paso('RegistrarPasoInicial') ->
        retractall(paso(_)),
        assertz(paso(Respuesta))
    ).

regla(Respuesta):-
    (paso('preparacion') ->
        !,Preguntas = ['PREGUNTA', 'Temporada Seca', 'Temporada Lluviosa'],
        Respuesta = Preguntas,
        retractall(paso(_)),
        assertz(paso('RegistrarTemporada'))
    ).

regla(Respuesta):-
    (paso('RegistrarTemporada') ->
        retractall(paso(_)),
        assertz(paso(Respuesta))
    ).


regla(Respuesta):-
    (paso('Temporada lluviosa') ->
        Respuesta = ['RESPUESTA', 'Se realiza el analizis de cargas por media hora', 'se realiza la prueba de jarras cada hora'],
        %es el final del arbol en esta rama por lo que nos devolvemos 
        retractall(paso(_))
    ).
