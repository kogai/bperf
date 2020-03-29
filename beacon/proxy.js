exports.handler = async ({ queryStringParameters: queryStringParameters_ }) => {
  const queryStringParameters = queryStringParameters_ || {};
  const sessionId = queryStringParameters.id;

  const eventType = queryStringParameters.type; // 'resource'
  const eventStartTime = queryStringParameters.start;
  const eventEndTime = queryStringParameters.end;
  const name = queryStringParameters.name;

  console.log([sessionId, eventType, name, eventEndTime - eventStartTime, eventStartTime, eventEndTime].join(" "));

  return {
    statusCode: 200
  };
};
