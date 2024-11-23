class Prolog {
    static program = `
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
        retractall(paso(_)),!,
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
        assertz(paso('Comprobar Temporada')),
        assertz(temporada(Respuesta))
    ).



regla(Respuesta):-
    (paso('Comprobar Temporada'), temporada('Temporada Lluviosa') ->
        Respuesta = ['RESPUESTA', 'Se realiza el analisis de cargas por media hora', 'se realiza la prueba de jarras cada hora'],
        %es el final del arbol en esta rama por lo que nos devolvemos 
        retractall(paso(_)),
        retractall(temporada(_))
    ).

limpiar:-
    retractall(paso(_)).
    `;

    constructor(regla_para_consultar) {
        this.pl = require('tau-prolog');
        require('tau-prolog/modules/core.js');
        require('tau-prolog/modules/lists.js');
        this._regla_para_consultar = regla_para_consultar;
        this.session = this.pl.create();
    }

    consultar(regla) {
        return new Promise((resolve, reject) => {
            const session = this.session;
            const consultRule = regla || this._regla_para_consultar;
            let resultados = [];
            let terminado = false;

            // Intentamos cargar el programa Prolog
            session.consult(Prolog.program, {
                success: () => {
                    session.query(consultRule, {
                        success: () => {
                            session.answers(x => {
                                let respuesta = session.format_answer(x);
                                if (respuesta && (respuesta.includes("[")) || respuesta.includes("true")) {
                                    resultados.push(respuesta);
                                }
                            }, {
                                success: () => {
                                    terminado = true;
                                    resolve(resultados);
                                },
                                error: (err) => {
                                    terminado = true;
                                    reject(err);
                                }
                            });
                        },
                        error: (err) => {
                            terminado = true;
                            reject(err);
                        }
                    });

                    // Timeout para asegurar que siempre se devuelva algo
                    setTimeout(() => {
                        if (!terminado) {
                            resolve(resultados);
                        }
                    }, 1000);
                },
                error: (err) => {
                    reject(err);
                }
            });
        });
    }
}


//uso 
(async () => {
    const prolog = new Prolog();
    let resultado = await prolog.consultar("regla(Respuesta).");
    console.log(resultado);
    resultado = await prolog.consultar("regla('preparacion').");
    console.log(resultado);
    resultado = await prolog.consultar("regla(Respuesta).");
    console.log(resultado);
    resultado = await prolog.consultar("regla('Temporada Lluviosa').");
    console.log(resultado);
    resultado = await prolog.consultar("regla(Respuesta).");
    console.log(resultado);
})();



module.exports = Prolog;