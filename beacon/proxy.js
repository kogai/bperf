exports.handler = async ({ queryStringParameters } = {}) => {
  const sessionId = queryStringParameters.id;
  const sessionStart = queryStringParameters.timeOrigin;

  const eventType = queryStringParameters.e; // 'resource'
  const eventStartTime = queryStringParameters.start;
  const eventEndTime = queryStringParameters.end;
  const name = queryStringParameters.name;

  console.log([eventType, name, eventStartTime, eventEndTime].join(" "));

  return {
    statusCode: 200
  };
};
