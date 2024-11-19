const express = require('express');
const cors = require('cors');
const Prolog = require('./prolog');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

const prolog = new Prolog();

app.get('/consulta', async (req, res) => {
    try {
        const { regla } = req.query;
        const resultado = await prolog.consultar(regla || "regla(Respuesta).");
        res.json(resultado);
    } catch (error) {
        res.status(500).json({ error: error.toString() });
    }
});

app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});