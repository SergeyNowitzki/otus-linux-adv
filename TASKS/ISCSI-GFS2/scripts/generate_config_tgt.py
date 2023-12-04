import json
import ruamel.yaml
import sys
import os

# create a json iscsi config file from a yaml config file
# Usage: python3 generate_config_tgt.py iscsi-target-saveconfig.yaml saveconfig.json
def yaml_to_json(yaml_file, json_file):
    with open(yaml_file, 'r') as f:
        data = ruamel.yaml.YAML().load(f)
    script_dir = os.path.dirname(os.path.abspath(os.curdir))
    print("Current directory is " + script_dir)
    os.chdir("../Ansible/templates")
    print("Saving file to " + os.path.abspath(os.curdir) + "/" + json_file)
    with open(f"{os.path.abspath(os.curdir)}/{json_file}", 'w') as f:
        json.dump(data, f, indent=4)
    return json_file

if __name__ == "__main__":
    yaml_file = sys.argv[1]
    json_file = sys.argv[2]
    yaml_to_json(yaml_file, json_file)