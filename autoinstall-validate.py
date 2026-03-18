import json, yaml, jsonschema, sys
with open('autoinstall-schema.json') as s, open('autoinstall.yaml') as d:
    data = yaml.safe_load(d)
    if 'autoinstall' in data:
        data = data['autoinstall']
    jsonschema.validate(data, json.load(s))
    print('Valid!')
