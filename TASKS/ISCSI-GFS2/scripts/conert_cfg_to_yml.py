import json

import ruamel.yaml
import sys

from pprint import pprint

# create a yaml config file from a iscsi target json file
# Usage: python3 conert_cfg_to_yml.py iscsi-target-saveconfig.json iscsi-target-saveconfig.yaml

def json_to_yaml(json_file, yaml_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    with open(yaml_file, 'w') as f:
        yaml = ruamel.yaml.YAML()
        yaml.dump(data, f)
    return yaml_file

if __name__ == "__main__":
    json_file = sys.argv[1]
    yaml_file = sys.argv[2]
    json_to_yaml(json_file, yaml_file)
