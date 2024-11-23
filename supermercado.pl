% Reglas dinamicas
:- dynamic(se_va_llevar/1).
:- dynamic(paso/1).
:- dynamic(bolsa_en_turno/1).
:- dynamic(bolsa_tiene/2).
:- dynamic(esta_en/2).
:- dynamic(sugerencia/1).
:- dynamic(en_envase_plastico/1).

% Base de conocimiento
tamano(papas_fritas, grande).
tamano(gaseosa, grande).
tamano(yogurt, pequeno).
tamano(cereal, mediano).
tamano(helado, pequeno).

envase(papas_fritas, plastico).
envase(gaseosa, vidrio).
envase(yogurt, plastico).
envase(cereal, carton).
envase(helado, carton).

congelado(papas_fritas, no).
congelado(gaseosa, no).
congelado(yogurt, si).
congelado(cereal, no).
congelado(helado, si).

% Hechos 1-6
se_va_llevar(papas_fritas).
se_va_llevar(helado).
se_va_llevar(yogurt).
paso(verificar_pedido).
bolsa_en_turno(1).
bolsa_tiene(1, 0).
sugerencia(1).

% Reglas
% Regla 7
regla :-
    % Condiciones
    paso(verificar_pedido),
    se_va_llevar(papas_fritas),
    not(se_va_llevar(gaseosa)),
    sugerencia(1),
    % Eliminar
    retract(sugerencia(1)),
    % Adicionar
    asserta(sugerencia(2)),
    % Ejecutar
    write("Ya que usted lleva papas fritas, "),
    write("¿Desea llevar gaseosa? (s/n): "),
    read(Respuesta),
    (
    Respuesta == s ->
        asserta(se_va_llevar(gaseosa)),
        write("Se Anadio gaseosa"), nl
    ;
        write("No se anadio gaseosa"), nl
    ), regla.
    
% Regla 8
regla :-
    % Condiciones
    sugerencia(1),
    % Eliminar
    retract(sugerencia(1)),
    % Adicionar
    asserta(sugerencia(2)),
    % Ejecutar
    regla. 

% Regla 8
regla :-
    % Condiciones
    paso(verificar_pedido),
    se_va_llevar(yogurt),
    not(se_va_llevar(cereal)),
    sugerencia(2),
    % Eliminar
    retract(sugerencia(2)),
    retract(paso(verificar_pedido)),
    % Adicionar
    asserta(paso(empacar_productos_grandes)),
    % Ejecutar
    write("Ya que usted lleva yogurt, "),
    write("¿Desea llevar cereal? (s/n): "),
    read(Respuesta),
    (
    Respuesta == s ->
        asserta(se_va_llevar(cereal)),
        write("Se Anadio cereal"), nl
    ;
        write("No se anadio cereal"), nl
    ), regla.

% Regla 9
regla :-
    % Condiciones
    sugerencia(2),
    paso(verificar_pedido),
    % Eliminar
    retract(sugerencia(2)),
    retract(paso(verificar_pedido)),
    % Adicionar
    asserta(paso(empacar_productos_grandes)),
    % Ejecutar
    regla. 

% Regla 10
regla :-
    % Condiciones
    paso(empacar_productos_grandes),
    se_va_llevar(Producto),
    tamano(Producto, grande),
    envase(Producto, vidrio),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud < 6,
    % Eliminar
    retract(se_va_llevar(Producto)),
    retract(bolsa_tiene(Bolsa, Longitud)),
    % Adicionar
    asserta(esta_en(Producto, Bolsa)),
    NuevaLongitud is Longitud + 1,
    asserta(bolsa_tiene(Bolsa, NuevaLongitud)),
    % Ejecutar
    format(string(Res), "Se empaco ~w en la bolsa ~d~n", [Producto, Bolsa]),
    write(Res),
    regla. 
    

% Regla 11
regla :-
    % Condiciones
    paso(empacar_productos_grandes),
    se_va_llevar(Producto),
    tamano(Producto, grande),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud < 6,
    % Eliminar
    retract(se_va_llevar(Producto)),
    retract(bolsa_tiene(Bolsa, Longitud)),
    % Adicionar
    asserta(esta_en(Producto, Bolsa)),
    NuevaLongitud is Longitud + 1,
    asserta(bolsa_tiene(Bolsa, NuevaLongitud)),
    % Ejecutar
    format(string(Res), "Se empaco ~w en la bolsa ~d~n", [Producto, Bolsa]),
    write(Res),
    regla. 
    
% Regla 12
regla :-
    % Condiciones
    paso(empacar_productos_grandes),
    se_va_llevar(Producto),
    tamano(Producto, grande),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud == 6,
    % Eliminar
    retract(bolsa_en_turno(Bolsa)),
    % Adicionar
    NuevaBolsa is Bolsa + 1,
    asserta(bolsa_en_turno(NuevaBolsa)),
    asserta(bolsa_tiene(NuevaBolsa, 0)),
    % Ejecutar
    format(
        string(Res),
        "Se Cambio la bolsa ~d por la bolsa ~d~n",
        [Bolsa, NuevaBolsa]
    ),
    write(Res),
    regla.
    
% Regla 13
regla :-
    % Condiciones
    paso(empacar_productos_grandes),
    se_va_llevar(Producto),
    not(tamano(Producto, grande)),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud > 0,
    % Eliminar
    bolsa_en_turno(Bolsa),
    retract(bolsa_en_turno(Bolsa)),
    % Adicionar
    NuevaBolsa is Bolsa + 1,
    asserta(bolsa_en_turno(NuevaBolsa)),
    asserta(bolsa_tiene(NuevaBolsa, 0)),
    % Ejecutar
    format(
        string(Res),
        "Se Cambio la bolsa ~d por la bolsa ~d~n",
        [Bolsa, NuevaBolsa]
    ),
    write(Res),
    regla.

% Regla 14
regla :-
    % Condiciones
    paso(empacar_productos_grandes),
    se_va_llevar(Producto),
    not(tamano(Producto, grande)),
    % Eliminar
    retract(paso(empacar_productos_grandes)),
    % Adicionar
    asserta(paso(empacar_productos_medianos)),
    % Ejecutar
    regla.
    

% Regla 15
regla :-
    % Condiciones
    paso(empacar_productos_medianos),
    se_va_llevar(Producto),
    tamano(Producto, mediano),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud < 9,
    % Eliminar
    retract(se_va_llevar(Producto)),
    retract(bolsa_tiene(Bolsa, Longitud)),
    % Adicionar
    asserta(esta_en(Producto, Bolsa)),
    NuevaLongitud is Longitud + 1,
    asserta(bolsa_tiene(Bolsa, NuevaLongitud)),
    % Ejecutar
    format(string(Res), "Se empaco ~w en la bolsa ~d~n", [Producto, Bolsa]),
    write(Res),
    regla.

% Regla 16
regla :-
    % Condiciones
    paso(empacar_productos_medianos),
    se_va_llevar(Producto),
    tamano(Producto, mediano),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud == 9,
    % Eliminar
    retract(bolsa_en_turno(Bolsa)),
    % Adicionar
    NuevaBolsa is Bolsa + 1,
    asserta(bolsa_en_turno(NuevaBolsa)),
    asserta(bolsa_tiene(NuevaBolsa, 0)),
    % Ejecutar
    format(
        string(Res),
        "Se Cambio la bolsa ~d por la bolsa ~d~n",
        [Bolsa, NuevaBolsa]
    ),
    write(Res),
    regla.

% Regla 17
regla :-
    % Condiciones
    paso(empacar_productos_medianos),
    se_va_llevar(Producto),
    not(tamano(Producto, mediano)),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud > 0,
    % Eliminar
    bolsa_en_turno(Bolsa),
    retract(bolsa_en_turno(Bolsa)),
    % Adicionar
    NuevaBolsa is Bolsa + 1,
    asserta(bolsa_en_turno(NuevaBolsa)),
    asserta(bolsa_tiene(NuevaBolsa, 0)),
    % Ejecutar
    format(
        string(Res),
        "Se Cambio la bolsa ~d por la bolsa ~d~n",
        [Bolsa, NuevaBolsa]
    ),
    write(Res),
    regla.

% Regla 18
regla :-
    % Condiciones
    paso(empacar_productos_medianos),
    se_va_llevar(Producto),
    not(tamano(Producto, mediano)),
    % Eliminar
    retract(paso(empacar_productos_medianos)),
    % Adicionar
    asserta(paso(empacar_productos_pequenos)),
    % Ejecutar
    regla.

% Regla 19
regla :-
    % Condiciones
    paso(empacar_productos_pequenos),
    se_va_llevar(Producto),
    tamano(Producto, pequeno),
    congelado(Producto, si),
    not(envase(Producto, plastico)),
    not(en_envase_plastico(Producto)),
    % Eliminar
    % Adicionar
    asserta(en_envase_plastico(Producto)),
    % Ejecutar
    format(
        string(Res),
        "Se empaco ~w en envase plastico~n",
        [Producto]
    ),
    write(Res),
    regla.

% Regla 20
regla :-
    % Condiciones
    paso(empacar_productos_pequenos),
    se_va_llevar(Producto),
    tamano(Producto, pequeno),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud < 12,
    % Eliminar
    retract(se_va_llevar(Producto)),
    retract(bolsa_tiene(Bolsa, Longitud)),
    % Adicionar
    asserta(esta_en(Producto, Bolsa)),
    NuevaLongitud is Longitud + 1,
    asserta(bolsa_tiene(Bolsa, NuevaLongitud)),
    % Ejecutar
    format(string(Res), "Se empaco ~w en la bolsa ~d~n", [Producto, Bolsa]),
    write(Res),
    regla.

% Regla 21
regla :-
    % Condiciones
    paso(empacar_productos_pequenos),
    se_va_llevar(Producto),
    tamano(Producto, pequeno),
    bolsa_en_turno(Bolsa),
    bolsa_tiene(Bolsa, Longitud),
    Longitud == 12,
    % Eliminar
    retract(bolsa_en_turno(Bolsa)),
    % Adicionar
    NuevaBolsa is Bolsa + 1,
    asserta(bolsa_en_turno(NuevaBolsa)),
    asserta(bolsa_tiene(NuevaBolsa, 0)),
    % Ejecutar
    format(
        string(Res),
        "Se Cambio la bolsa ~d por la bolsa ~d~n",
        [Bolsa, NuevaBolsa]
    ),
    write(Res),
    regla.

% Regla 22
regla :-
    % Condiciones
    paso(empacar_productos_pequenos),
    se_va_llevar(Producto),
    not(tamano(Producto, pequeno)),
    % Eliminar
    retract(paso(empacar_productos_medianos)),
    % Adicionar
    % Ejecutar
    regla;
    true.

% Para ejecutarlos, escribir regla.
%
% ?- regla.
% Ya que usted lleva papas fritas, ¿Desea llevar gaseosa? (s/n): s.
% Se Anadio gaseosa
% Ya que usted lleva yogurt, ¿Desea llevar cereal? (s/n): |: n.
% No se anadio cereal
% Se empaco gaseosa en la bolsa 1
% Se empaco papas_fritas en la bolsa 1
% Se Cambio la bolsa 1 por la bolsa 2
% Se empaco helado en envase plastico
% Se empaco helado en la bolsa 2
% Se empaco yogurt en la bolsa 2
% true .
