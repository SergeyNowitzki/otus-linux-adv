import math
import yaml
import json
import sys
from jinja2 import Environment, FileSystemLoader
from rich.console import Console


console = Console()

env = Environment(loader=FileSystemLoader("templates"), trim_blocks=True, lstrip_blocks=True)
template = env.get_template('CEPH_config.j2')
#CEPH_params.yaml description
#  size - Number of replicas the pool will have
#  osd - Number of OSDs which this Pool will have PGs in. Typically, this is the entire Cluster OSD count, but could be less based on CRUSH rules. (e.g. Separate SSD and SATA disk sets)
#  data - This value represents the approximate percentage of data which will be contained in this pool for that specific OSD set.
#  tgt_pgs_per_osd - This value should be populated based on the following guidance:
#     100 - If the cluster OSD count is not expected to increase in the foreseeable future.
#     200 - If the cluster OSD count is expected to increase (up to double the size) in the foreseeable future.


#pg is placement group which is calculated by the formula:
def pg_calculation(OSD, RF):
    n = OSD * 100 / RF
    result = 2**_nearest_higher_power_power_two(n)
    return result

def pg_per_pool(OSD, RF, pool_count,TGT_OSD,DATA):
    n = OSD * TGT_OSD * DATA / RF
    result = 2**_nearest_higher_power_power_two(n)
    return result

def _nearest_higher_power_power_two(n):
    return int(math.ceil(math.log2(n)))

def build_config_from_j2(dict_config):
    with open("ceph.cfg",'w') as f:
        f.write(template.render(dict_config))


if __name__ == '__main__':
    try:
        list_dict_result={"config":[]}
        with open('CEPH_params.yml') as f:
            templates = yaml.safe_load(f)
        NUM_POOLS = len(templates['Ceph']['params']['pools'])
        for pool in templates['Ceph']['params']['pools']:
            POOL_NAME=pool['pool_name']
            OSD = pool['osd']
            RF = pool['size']
            TGT_OSD = pool['tgt_pgs_per_osd']
            DATA = pool['data']/100

            console.log(f"Pool Name [bold red]{POOL_NAME}")
            #Total number of PG's
            print("total number of PG's ", pg_calculation(OSD, RF))

            #Total PGs per pool Calculation
            PG_PER_POOL = pg_per_pool(OSD, RF, NUM_POOLS,TGT_OSD,DATA)
            print("Total PGs per pool Calculation ", PG_PER_POOL ,end="\n\n")

            dict_result = {"pool_name": POOL_NAME, "pg_per_pool": PG_PER_POOL, "size": RF}
            list_dict_result["config"].append(dict_result)

        #Total number of pools:
        print("total number of pools ", NUM_POOLS)

        #build config file
        build_config_from_j2(list_dict_result)
        console.log(f"[bold green]Ceph config file generated successfully!")


    except KeyboardInterrupt:
        console.log(f"[bold red]Exiting...")
        sys.exit(1)