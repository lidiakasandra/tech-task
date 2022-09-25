const express = require('express');
const service = require('./service');
const app = express();
const port = process.env.PORT || 3000;

app.get('/100jokes', async (req, res) => {
    let data = await service();
    res.json(data);
});

app.listen(port, () => console.log(`Application started on port ${port}`));