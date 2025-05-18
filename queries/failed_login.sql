-- Athena Query: Detect Failed IAM Console Logins in the last 7 days

SELECT eventTime, userIdentity.userName, sourceIPAddress
FROM cloudtrail_logs
WHERE eventName = 'ConsoleLogin'
  AND responseElements.ConsoleLogin = 'Failure'
  AND from_iso8601_timestamp(eventTime) > current_timestamp - interval '7' day;
