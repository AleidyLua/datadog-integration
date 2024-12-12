from flask import Flask, request, jsonify
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

        # Get the current request path
        request_path = request.path

        # Send custom metric for API call duration
        datadog.api.Metric.send(
            metric="application_request_duration",
            points=[duration],
            tags=[f"endpoint:{request_path}"]
        )

        # Send custom metric for HTTP status code
        datadog.api.Metric.send(
            metric="application_request_code",
            points=[response.status_code],
            tags=[f"endpoint:{request_path}"]
        )

        print(response.json())
    except Exception as e:
        # Send application error metric
        request_path = request.path
        datadog.api.Metric.send(
            metric="application_error_count",
            points=1,
            tags=["error_type:api_request_failure", f"endpoint:{request_path}"]
        )
        print(f"Error occurred: {e}")

    return "Hello, Elastic Beanstalk!"

@application.route('/cat')
def cat_route():
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

        # Get the current request path
        request_path = request.path

        # Send custom metric for API call duration
        datadog.api.Metric.send(
            metric="third_party_request_duration",
            points=[(datetime.now(), duration)],
            tags=[f"parent_endpoint:{request_path}","endpoint:GET v1/images", "outcome:success", "host:https://api.thecatapi.com", f"status_code:{response.status_code}", "third_party_service:TheCatApi"]
        )
        datadog.api.Metric.send(
            metric="third_party_request_count",
            points=[(datetime.now(), 1)],
            tags=[f"parent_endpoint:{request_path}","endpoint:GET v1/images", "outcome:success", "host:https://api.thecatapi.com", f"status_code:{response.status_code}", "third_party_service:TheCatApi"]
        )

        print(f"Request Path: {request_path}")

        return json.dumps(response, indent=4, sort_keys=True, default=str)

    except Exception as e:
        # Send application error metric
        # request_path = request.path
        # datadog.api.Metric.send(
        #     metric="third_party_request_count",
        #     points=[(time.time(), 1)],
        #     tags=[f"parent_endpoint:{request_path}", "endpoint:GET v1/images", "outcome:success",
        #           "host:https://api.thecatapi.com",
        #           "third_party_service:TheCatApi"]
        # )
        print(f"Error occurred: {e}")


if __name__ == "__main__":
    application.run(host='0.0.0.0', port=5001)
