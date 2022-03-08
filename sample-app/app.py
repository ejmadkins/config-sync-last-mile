import io
import os
import json
# Imports the Google Cloud client library
from google.cloud import vision
from flask import Flask, render_template
app = Flask(__name__)
bucket_name = os.environ['bucket']
blob_name = os.environ['blob']

def detect_labels_uri(bucket_name, blob_name):
    """Detects labels in the file located in Google Cloud Storage or on the
    Web."""
    client = vision.ImageAnnotatorClient()
    image = vision.Image()
    image.source.image_uri = 'gs://{}/{}'.format(bucket_name,blob_name)
    response = client.label_detection(image=image)
    labels = response.label_annotations
    return labels

def serving_url():
    serving_url = "https://storage.cloud.google.com/{}/{}".format(bucket_name,blob_name)
    return serving_url

# render the template for index.html
@app.route("/")
def label_image():
    # Get env vars
    labels = detect_labels_uri(bucket_name, blob_name)
    print(labels)
    return render_template('index.html',
                           uri_name=(serving_url()), labels=labels)

if __name__ == '__main__':
    # Run the app
    app.run(debug=True, host='0.0.0.0', port=8080)
