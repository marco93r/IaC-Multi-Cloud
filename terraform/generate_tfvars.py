
import yaml
import json
import os

# Pfade
yaml_path = "environment.yaml"
environments_dir = "./environments"

# YAML laden
with open(yaml_path, "r") as f:
    config = yaml.safe_load(f)

cloud = config["cloud_provider"]
region = config["region"][cloud]
ssh_key = config["ssh_key"]

# VM-Counts: alle Rollen mit genau 1 Instanz
vm_count = {
    cloud: { role: 1 for role in config["vm_config"] }
}

# Instanztypen
instance_type = {
    cloud: {
        role: config["vm_config"][role][cloud]
        for role in config["vm_config"]
    }
}

# Extra Disks nur bei Storage, wenn vorhanden
extra_disks = {
    cloud: config["vm_config"].get("storage", {}).get("extra_disks", [])
}

# tfvars zusammenbauen
tfvars = {
    "cloud_provider": cloud,
    "region": {cloud: region},
    "ssh_key": ssh_key,
    "vm_count": vm_count,
    "instance_type": instance_type,
    "extra_disks": extra_disks
}

# Zielverzeichnis anlegen
os.makedirs(environments_dir, exist_ok=True)
tfvars_path = os.path.join(environments_dir, f"{cloud}.tfvars.json")

# Speichern
with open(tfvars_path, "w") as f:
    json.dump(tfvars, f, indent=2)

print(f"[✔] tfvars für '{cloud}' generiert: {tfvars_path}")
