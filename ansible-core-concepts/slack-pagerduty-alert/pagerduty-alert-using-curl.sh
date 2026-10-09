curl -X POST \
  -H 'Content-Type: application/json' \
  -d '{
    "routing_key": "'"$PAGERDUTY_INTEGRATION_KEY"'",
    "event_action": "trigger",
    "dedup_key": "test-alert",
    "payload": {
      "summary": "Test alert from curl",
      "source": "curl command",
      "severity": "info"
    }
  }' \
  https://events.pagerduty.com/v2/enqueue