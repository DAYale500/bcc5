import json
import csv
import os

# Converts a folder of JSON lessons into a single CSV index
# Also lets you update lesson titles/descriptions from a CSV 
# back into the JSON files

def json_to_csv(input_folder, output_csv):
    index = []
    for file_name in os.listdir(input_folder):
        if file_name.endswith(".json") and not file_name.startswith("index"):
            with open(os.path.join(input_folder, file_name)) as f:
                data = json.load(f)
                id = data.get("id", "")
                title = data.get("title", "")
                description = data.get("content", [{}])[0].get("content", "")
                index.append({"id": id, "title": title, "description": description})
    with open(output_csv, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["id", "title", "description"])
        writer.writeheader()
        writer.writerows(index)

def csv_to_json(input_csv, json_template_folder, output_folder):
    with open(input_csv, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            json_path = os.path.join(json_template_folder, f"{row['id']}.json")
            if not os.path.exists(json_path):
                continue
            with open(json_path) as jf:
                data = json.load(jf)
            data["title"] = row["title"]
            if data.get("content"):
                data["content"][0]["content"] = row["description"]
            with open(os.path.join(output_folder, f"{row['id']}.json"), "w") as out_f:
                json.dump(data, out_f, indent=2)

# Example usage:
# json_to_csv("json/lessons/docking", "output.csv")
# csv_to_json("output.csv", "json/lessons/docking", "json/lessons/docking_updated")








