import logging
import os
from flask import Flask, jsonify, request
import base64

app = Flask('webhook')
app.logger.addHandler(logging.StreamHandler())
app.logger.setLevel(logging.DEBUG)

#Health check
@app.route("/healthz", methods=['GET'])
def ping():
  return jsonify({'message': 'ok'})


ALLOWED_REGISTRIES = ['hub.docker.com/thirdsoul','registry.k8s.io']
REQUIRED_NAMESPACE_LABELS = ['workloads/escalable']

#Validation Response
def response(allowed, uid, message):
  return jsonify({
      "apiVersion": "admission.k8s.io/v1",
      "kind": "AdmissionReview",
      "response": {
        "allowed": allowed,
        "uid": uid,
        "status": {"message": message}
    }
  })

#Validation Response
def mutate(allowed, uid, message):
  return jsonify({
      "apiVersion": "admission.k8s.io/v1",
      "kind": "AdmissionReview",
      "response": {
        "allowed": allowed,
        "uid": uid,
        "status": {"message": message},
        "patchType": "JSONPatch",
        "patch": base64.encodebytes('[{"op": "add", "path": "/metadata/labels/mutated", "value": True}]')
    }
  })


@app.route('/validate', methods=['POST'])
def deployment_webhook():
    
    r = request.json
    
    try:
        request = r.get("request",{})
        
        if not request:
            response(False, '-', "Invalid, no payload")
        
        uid = request.get("uid", "")
        
        if not uid:
            response(False, '-', "Invalid, no uid")

        response(True,uid,"Correct validation")

    except Exception as e:
        return response(False, uid, f"Webhook exception: {e}")


@app.route('/mutate', methods=['POST'])
def validation_webhook():
    
    r = request.json
    
    try:
        request = r.get("request",{})
        
        if not request:
            response(False, '-', "Invalid, no payload")
        
        uid = request.get("uid", "")
        
        if not uid:
            response(False, '-', "Invalid, no uid")

        response(True,uid,"Correct validation")

    except Exception as e:
        return response(False, uid, f"Webhook exception: {e}")
    

@app.route('/mutate', methods=['POST'])
def mutation_webhook():
    
    r = request.json
    
    try:
        request = r.get("request",{})
        
        if not request:
            response(False, '-', "Invalid, no payload")
        
        uid = request.get("uid", "")
        
        if not uid:
            response(False, '-', "Invalid, no uid")

        mutate(True,uid,"Correct validation")

    except Exception as e:
        return response(False, uid, f"Webhook exception: {e}")



if __name__ == "__main__":
  ca_crt = '/etc/ssl/ca.crt'
  ca_key = '/etc/ssl/ca.key'
  app.run(ssl_context=(ca_crt, ca_key), port=5000, host='0.0.0.0', debug=True)