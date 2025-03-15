async function visitorCount() {
    let visitor = 0;
    const url =  "https://nr9aeqflql.execute-api.us-west-2.amazonaws.com/production/visitors";
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }

        const json = await response.json();
        console.log(json);
    } catch (error) {
        console.error(error.message);
    }
}