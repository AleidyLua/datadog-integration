from flask import Flask
import requests
import datadog
from datetime import datetime
import json
import boto3

application = Flask(__name__)


@application.route('/')
def home():
    client = boto3.client('secretsmanager', region_name="us-east-2")
    secret = client.get_secret_value(SecretId="datadogkeys")
    secret_value = json.loads(secret['SecretString'])

    options = {
        "api_key": secret_value["api_key"],
        "app_key": secret_value["app_key"],
    }

    datadog.initialize(**options)

    try:
        # Measure API call duration
        start_time = datetime.now()
        response = requests.get(
            "https://api.thecatapi.com/v1/images/search",
            headers={"x-api-key": secret_value["cat_api_key"]}
        )
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()

        # Send custom metric for API call duration
        datadog.api.Metric.send(
            metric="third_party_api_call_duration",
            points=[duration],
            tags=["api_provider:external_service", "endpoint:/api/data"]
        )
        print(response.json())
    except Exception as e:
        # Send application error metric
        datadog.api.Metric.send(
            metric="application_error_count",
            points=1,
            tags=["error_type:api_request_failure", "endpoint:/api/data"]
        )
        print(f"Error occurred: {e}")

    return "Hello, Elastic Beanstalk!"


if __name__ == "__main__":
    application.run(host='0.0.0.0', port=5001)
