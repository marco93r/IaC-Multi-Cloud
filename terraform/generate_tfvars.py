import yaml
import json

with open("environment.yaml", "r") as f:
    env = yaml.safe_load(f)

cloud_provider = env["cloud_provider"]

tfvars = {
    "cloud_provider": cloud_provider,
    "region": {
        cloud_provider: env["region"][cloud_provider]
    },
    "ssh_key": env["ssh_key"][cloud_provider],
    "ssh_key_path": env["ssh_key_path"][cloud_provider],
    "vm_count": {
        cloud_provider: env["vm_count"][cloud_provider]
    },
    "instance_type": {
        cloud_provider: env["instance_type"][cloud_provider]
    },
    "extra_disks": {
        cloud_provider: env.get("extra_disks", {}).get(cloud_provider, [])
    }
}

output_path = f"./environments/{cloud_provider}.tfvars.json"

with open(output_path, "w") as f:
    json.dump(tfvars, f, indent=2)

print(f"tfvars file generated at '{output_path}'")
