import { Firehose } from '@aws-sdk/client-firehose'

function buildReport (json, sourceIp, userAgent) {
  const cspReport = json['csp-report'] || {}
  const now = new Date()

  // using snake casing for easier usage in AWS Glue
  return {
    time: now.toISOString(),
    document_uri: normaliseInputString(cspReport['document-uri']),
    referrer: normaliseInputString(cspReport.referrer),
    blocked_uri: normaliseInputString(cspReport['blocked-uri']),
    effective_directive: normaliseInputString(cspReport['effective-directive']),
    violated_directive: normaliseInputString(cspReport['violated-directive']),
    disposition: normaliseInputString(cspReport.disposition),
    sample: normaliseInputString(cspReport['script-sample']),
    line_number: normaliseInteger(cspReport['line-number']),
    status_code: normaliseInteger(cspReport['status-code']),
    source_ip: normaliseInputString(sourceIp),
    user_agent: normaliseInputString(userAgent)
  }
}

function normaliseInputString (input) {
  if (!input) return null

  const string = String(input)

  if (string.length > 4000) {
    // lets not store anything suspiciously long
    return string.slice(0, 4000)
  } else {
    return string
  }
}

function normaliseInteger (input) {
  return Number.isInteger(input) ? input : null
}

// we seem to get base64 submitted, not sure if this is something API gateway
// can resolve
function parseBody (body) {
  // Try decode base64
  try {
    const buffer = Buffer.from(body, 'base64')
    return JSON.parse(buffer.toString())
  } catch {
    // otherwise try regular body
    return JSON.parse(body)
  }
}

async function sendReportToFirehose (report) {
  const client = new Firehose()
  await client.putRecord({ DeliveryStreamName: process.env.FIREHOSE_DELIVERY_STREAM, Record: { Data: Buffer.from(JSON.stringify(report)) } })
}

export const handler = async (event) => {
  // Not sure whether the case of this is dependent on the client or API Gateway
  const contentType = event.headers['Content-Type'] || event.headers['content-type']

  if (!['application/csp-report', 'application/json'].includes(contentType)) {
    console.log(`Client error: content type '${contentType}' wasn't application/csp-report or appliation/json`)
    return { statusCode: 415 }
  }

  let json

  try {
    json = parseBody(event.body)
  } catch {
    console.log('Client error: failed to parse body')
    return { statusCode: 400 }
  }

  // These identity variables are present if API Gateway proxies to this
  const report = buildReport(json, event.requestContext?.http?.sourceIp, event.requestContext?.http?.userAgent)

  // if we have no data lets not bother sending
  if (!report.blocked_uri) {
    console.log('Client error: no blocked-uri, not logging report')
    return { statusCode: 400 }
  // TODO: filter out common browser extensions
  } else {
    await sendReportToFirehose(report)
    console.log('Report logged with firehose')
    return { statusCode: 201 }
  }
}
