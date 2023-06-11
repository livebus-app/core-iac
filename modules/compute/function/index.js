import AWS from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';

const AWS_REGION = 'us-east-1';

export const handler = async (data) => {
  const dynamo = new AWS.DynamoDB.DocumentClient({ region: AWS_REGION });
  const rekognition = new AWS.Rekognition({ region: AWS_REGION });

  const bucketRecords = data?.Records;

  for (const record of bucketRecords) {
    const { s3: { bucket: { name }, object: { key } } } = record;
    
    const rekognitionParams = {
      Image: {
        S3Object: {
          Bucket: name,
          Name: key,
        },
      },
      MaxLabels: 100,
      MinConfidence: 90,
    };

    const { Labels: labels } = await rekognition.detectLabels(rekognitionParams).promise();

    const labelsNames = labels.map(({ Name }) => Name);

    const params = {
      TableName: "bucket_digest",
      Item: {
        id: uuidv4(),
        labelsNames,
      },
    }

    await dynamo.put(params).promise();
  }

  return bucketRecords;
}