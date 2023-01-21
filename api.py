from flask import Flask, request, Response
import json
import xmltodict

app = Flask(__name__)


@app.route("/json-to-xml/", methods=["POST"])
def json_to_xml():
    json_data = json.loads(request.get_data())
    xml_data = xmltodict.unparse({'root': json_data}, pretty=True)
    return Response(response=xml_data, status=200, mimetype="application/xml")


if __name__ == '__main__':
    app.run(debug=True)
