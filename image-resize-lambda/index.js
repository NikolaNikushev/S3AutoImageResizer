'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3({
    signatureVersion: 'v4',
});
const Sharp = require('sharp');

const BUCKET = process.env.BUCKET; // the S3 bucke to upload to
const URL = process.env.URL; // where the images are stored, used for re-direct after upload, example: https://cdn.yourwebsite.com
const ALLOWED_DIMENSIONS = new Set();

// example: 800x300,300x800,500x500,100x125
if (process.env.ALLOWED_DIMENSIONS) {
    const dimensions = process.env.ALLOWED_DIMENSIONS.split(',').map((el) => el.trim());
    dimensions.forEach((dimension) => ALLOWED_DIMENSIONS.add(dimension));
}

exports.handler = async function (event, context, callback) {
    const key = event.queryStringParameters.key;
    const match = key.match(/((\d+)x(\d+))\/(.*)/);
    const dimensions = match[1];
    const width = parseInt(match[2], 10);
    const height = parseInt(match[3], 10);
    const originalKey = match[4];

    if (ALLOWED_DIMENSIONS.size > 0 && !ALLOWED_DIMENSIONS.has(dimensions)) {
        callback(null, {
            statusCode: '403',
            headers: {},
            body: '',
        });
        return;
    }
    console.log(`Loading ${BUCKET}/${originalKey}`, width, height);
    // const fitformats = ['cover', 'contain', 'fill', 'inside', 'outside']
    try {
        const s3Respponse = await S3.getObject({Bucket: BUCKET, Key: originalKey}).promise()
        const body = s3Respponse.Body;
        await Sharp(body)
            .resize(width, height, {fit: 'contain'})
            .toFormat('png')
            .toBuffer()
            .then(buffer => S3.putObject({
                    Body: buffer,
                    Bucket: BUCKET,
                    ContentType: 'image/png',
                    Key: key,
                }).promise()
            )
    } catch (err) {
        console.error('Got an error...', err)
        return callback(err)
    }

    callback(null, {
            statusCode: '301',
            headers: {'location': `${URL}/${keyName}`},
            body: '',
        }
    )
}
