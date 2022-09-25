const axios = require('axios');

const service = async () => {
    try {
        let hundredJokes = [];
        const response = await axios.get('http://bash.org.pl/text');
        let lib = response.data.split('%\n');
        for (let i = 0; i < 100; i++) {
            let temp = lib[i].split('\n');
            temp.shift();
            let joke = {
                number: i+1,
                content: ''
            };
            temp.forEach(line => joke.content = joke.content+line+'\n')
            joke.content = joke.content.substring(0, joke.content.length -2);
            hundredJokes.push(joke);
        }
        return hundredJokes;
    } catch (error) {
        return error.message
    }
}

module.exports = service;