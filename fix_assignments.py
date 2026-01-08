
import os
import re

# --- Configuration ---
LECTURES_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Lectures"
ASSIGNMENTS_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Assignments"
TEMPLATES_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Assignments\_templates"

# Map assignments to their datasets
HW_DATASETS = {
    "hw1": "Coffee Data.csv",
    "hw2": "anova_ex1.csv",
    "hw3": "Coffee Data.csv",
    "hw4": "rm_ex.csv",
    "hw5": ["slr_ex1.csv", "mlr_ex1.csv"]
}

def clean_content(content):
    # Remove theme: cosmo
    content = re.sub(r'^\s*theme:\s*cosmo\s*\n', '', content, flags=re.MULTILINE)
    # Remove existing "Downloads" callout if any (so we can regenerate it fresh)
    content = re.sub(r'::: \{\.callout-note icon=false\}\n## Downloads[\s\S]*?:::\n+', '', content)
    return content

def generate_template_content(content):
    # Template should not have the Downloads callout (already removed by clean_content called before this?)
    # But clean_content is called on the 'working' content.
    # We want the template to be the clean content.
    return content

def update_assignments():
    print("Updating Assignments...")
    if not os.path.exists(TEMPLATES_DIR):
        os.makedirs(TEMPLATES_DIR)

    for filename in os.listdir(ASSIGNMENTS_DIR):
        if filename.startswith("hw") and filename.endswith(".qmd"):
            filepath = os.path.join(ASSIGNMENTS_DIR, filename)
            hw_key = filename.replace(".qmd", "") # e.g., hw1
            
            with open(filepath, "r", encoding="utf-8") as f:
                original_content = f.read()

            # Clean content (remove old buttons, remove cosmo theme)
            clean = clean_content(original_content)
            
            # Save Template (.Rmd)
            # The template is just the clean content (instructions + questions)
            template_filename = filename.replace(".qmd", ".Rmd")
            template_filepath = os.path.join(TEMPLATES_DIR, template_filename)
            with open(template_filepath, "w", encoding="utf-8") as f:
                f.write(clean)
            print(f"  Regenerated template {template_filename}")

            # Prepare Buttons
            data_links = ""
            if hw_key in HW_DATASETS:
                datasets = HW_DATASETS[hw_key]
                if isinstance(datasets, str):
                    datasets = [datasets]
                
                for ds in datasets:
                     data_links += f'\n[**Download Data: {ds}**](../course_data/{ds}){{ .btn .btn-success }}\n'

            template_link = f'\n[**Download Assignment Template**](_templates/{template_filename}){{ .btn .btn-primary }}\n'
            
            # Add Buttons to QMD
            # Insert after YAML
            parts = clean.split("---", 2)
            if len(parts) >= 3:
                 new_buttons = "\n::: {.callout-note icon=false}\n## Downloads" + template_link + data_links + "\n:::\n"
                 new_content = "---" + parts[1] + "---" + new_buttons + parts[2]
                 
                 with open(filepath, "w", encoding="utf-8") as f:
                     f.write(new_content)
                 print(f"  Updated QMD {filename} with new buttons and cleaned theme")

if __name__ == "__main__":
    update_assignments()
