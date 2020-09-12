exports.handler = async (event) => {
    let s3FileName;
    try {
        s3FileName = event.Records[0].s3.object.key;
    } catch (err) {
        console.log('error on loading key', err);
        return makeResponse(500, `Problem with request. See logs for details! (${err.message})`);
    }

    const api = process.env.RESIZE_LAMBDA_API_GATEWAY_URL;
    if (!api) {
        return makeResponse(500, 'Lambda not configured. Missing RESIZE_LAMBDA_API_GATEWAY_URL');
    }
    const allowedDimensions = process.env.ALLOWED_DIMENSIONS;
    if (!allowedDimensions || allowedDimensions.length < 1) {
        return makeResponse(500, "No allowed ALLOWED_DIMENSIONS")
    }

    const match = s3FileName.match(/((\d+)x(\d+))\/(.*)/);
    if (match) {
        return makeResponse(400, `Bad request with extra parameters! (${s3FileName})`);
    }

    const promises = getPromisesForSizes(api,s3FileName, allowedDimensions.split(',').map((size) => size.trim()));

    return Promise.all(promises).then(() => {
        return makeResponse(200, "Upload done")
    }).catch(err => {
        console.log('ERROR', err)
        return makeResponse(500, "Problem with resizing. Check logs.")
    })
};

const makeResponse = (errorCode, message) => {
    return {errorCode, body: JSON.stringify(message)}
}

const getPromisesForSizes = (api,s3FileName, allowedDimensions) => {
    const path = process.env.IMAGE_PATH || '/default/image-resize';
    const r = require('request');
    const promises = [];
    /* Recommended sizes...
     // https://www.shutterstock.com/blog/common-aspect-ratios-photo-image-sizes
      '1920x1080',
      '1080x1080', // 1x1 big
      '128x128', // 1x1 small
      // Website specific
      '1800x1600', // Taken from homepage image
      '400x120', //max of a card
      '800x420', // max of card *2
      */

    for (let i = 0; i < allowedDimensions.length; i++) {
        const size = allowedDimensions[i];
        const promise = new Promise((res, rej) => {
            const query = `?key=${size}/${s3FileName}`;
            r(`${api}${path}${query}`, (error) => {
                if (error)
                    console.log(error) && rej(error)
                else console.log(`uploaded ${query}`) && res();
            });
        });
        promises.push(promise);
    }
    return promises;
}
