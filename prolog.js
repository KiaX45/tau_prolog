class Prolog {
    static program = `
:- dynamic(paso/1).
:- dynamic(temporada/1).

regla(Respuesta):- 
    (paso(_) -> 
        fail
    ;
        !,ListaPasos = ['PREGUNTA',  'preparacion', 'pruebasPrevias', 'Dosificacion en la planta', 'Analisis posteriores'],
        Respuesta = ListaPasos,
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
        Respuesta = ['RESPUESTA', 'Se realiza el analisis de cargas por media hora', 'se realiza la prueba de jarras cada hora'],
        retractall(paso(_))
    ).
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
                                if (respuesta) {
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



module.exports = Prolog;