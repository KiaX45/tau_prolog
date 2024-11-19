// Importa Tau Prolog
const pl = require('tau-prolog');
require('tau-prolog/modules/core');

// Crea una nueva sesión
const session = pl.create(1000);

// Define un programa Prolog
const program = `
counter(Counter, Results) :-
  counter(Counter, [], Results).

counter(Counter, Acc, Results) :-
  Counter > 0,
  NewCounter is Counter - 1,
  counter(NewCounter, [Counter|Acc], Results).

counter(0, Acc, Acc).
`;

// Carga el programa en la sesión
session.consult(program, {
  success: function () {
    console.log("Programa cargado exitosamente!");
    // Realiza una consulta
    session.query("counter(5, X).", {
      success: function () {
        console.log("Consulta realizada exitosamente!");
        // Recupera las respuestas
        session.answers(x => {
          //console.log(pl.format_answer(x)); // Formatea y muestra las respuestas
          respuesta = pl.format_answer(x);
          depuracion(respuesta);
        });
      },
      error: function (err) {
        console.error("Error en la consulta:", err);
      }
    });
  },
  error: function (err) {
    console.error("Error al cargar el programa:", err);
  }
});


const depuracion = (respuesta) =>{
  
  if (respuesta.includes("[")){
    console.log(respuesta);
  }
    
}