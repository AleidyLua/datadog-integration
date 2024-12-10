from flask import Flask, jsonify
import time

application = Flask(__name__)


@application.route('/')
def home():
    return "Hello, Elastic Beanstalk with Datadog APM!"


@application.route('/slow')
def slow():
    time.sleep(5)
    return jsonify(message="This endpoint is slow!")


@application.route('/error')
def error():
    raise ValueError("This is a test error!")


if __name__ == '__main__':
    application.run(host='0.0.0.0', port=5000)
