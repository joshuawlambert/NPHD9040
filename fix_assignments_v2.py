
import os
import re

# --- Configuration ---
ASSIGNMENTS_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Assignments"
TEMPLATES_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Assignments\_templates"
# Path to the new RMD guide relative to Assignments folder
RMD_GUIDE_LINK = "../Other/working_with_rmd.qmd" 

# Map assignments to their datasets
HW_DATASETS = {
    "hw1": "Coffee Data.csv",
    "hw2": "anova_ex1.csv",
    "hw3": "Coffee Data.csv",
    "hw4": "rm_ex.csv",
    "hw5": ["slr_ex1.csv", "mlr_ex1.csv"]
}

def process_yaml_for_template(content):
    # Ensure author and date exist
    if "author:" not in content:
        content = re.sub(r'(---\n)', r'\1author: "Your Name Here"\n', content, count=1)
    if "date:" not in content:
        content = re.sub(r'(author:.*\n)', r'\1date: "Due Date"\n', content, count=1)
    
    # Remove CSS
    content = re.sub(r'^(\s*)css:.*\n', '', content, flags=re.MULTILINE)
    return content

def process_yaml_for_qmd(content):
    # Remove author and date
    content = re.sub(r'^(\s*)author:.*\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^(\s*)date:.*\n', '', content, flags=re.MULTILINE)
    # Ensure css exists (it might have been removed in previous script versions or if we blindly edit)
    if "css: ../styles.css" not in content:
         # Insert before format or end of yaml
         # Simple hack: duplicate title line replacement? No, let's look for ---
         pass # Assume it's there or user didn't ask to add it back if missing, just 'keep' it. 
         # But wait, original files have it.
    return content

def clean_content_for_template(content):
    # Remove the Downloads callout
    content = re.sub(r'::: \{\.callout-note icon=false\}\n## Downloads[\s\S]*?:::\n+', '', content)
    # Remove RMD Guide link callout if exists (to avoid duplication)
    content = re.sub(r'::: \{\.callout-tip icon=false\}\n## New to R Markdown\?[\s\S]*?:::\n+', '', content)
    return content

def update_assignments():
    print("Updating Assignments...")
    if not os.path.exists(TEMPLATES_DIR):
        os.makedirs(TEMPLATES_DIR)

    for filename in os.listdir(ASSIGNMENTS_DIR):
        if filename.startswith("hw") and filename.endswith(".qmd"):
            filepath = os.path.join(ASSIGNMENTS_DIR, filename)
            hw_key = filename.replace(".qmd", "") 
            
            with open(filepath, "r", encoding="utf-8") as f:
                original_content = f.read()

            # --- PREPARE TEMPLATE ---
            # 1. Start with original content (contains instructions, questions, yaml)
            # 2. Add author/date if missing, Remove CSS
            tpl_content = process_yaml_for_template(original_content)
            # 3. Clean out website buttons
            tpl_content = clean_content_for_template(tpl_content)

            # Write Template
            template_filename = filename.replace(".qmd", ".Rmd")
            template_filepath = os.path.join(TEMPLATES_DIR, template_filename)
            with open(template_filepath, "w", encoding="utf-8") as f:
                f.write(tpl_content)
            print(f"  Regenerated template {template_filename}")

            # --- PREPARE QMD ---
            # 1. Start with original content
            # 2. Remove author/date
            qmd_content = process_yaml_for_qmd(original_content)
            # 3. Remove old buttons (we will rebuild them)
            qmd_content = clean_content_for_template(qmd_content)

            # 4. Construct Buttons Block including new RMD Link
            data_links = ""
            if hw_key in HW_DATASETS:
                datasets = HW_DATASETS[hw_key]
                if isinstance(datasets, str):
                    datasets = [datasets]
                for ds in datasets:
                     data_links += f'\n[**Download Data: {ds}**](../course_data/{ds}){{ .btn .btn-success }}\n'

            template_link = f'\n[**Download Assignment Template**](_templates/{template_filename}){{ .btn .btn-primary }}\n'
            
            guide_link = f'\n::: {{.callout-tip icon=false}}\n## New to R Markdown?\n[**Click here for a guide on Getting Started with R Markdown**]({RMD_GUIDE_LINK})\n:::\n'

            downloads_block = "\n::: {.callout-note icon=false}\n## Downloads" + template_link + data_links + "\n:::\n"

            # Insert after YAML
            parts = qmd_content.split("---", 2)
            if len(parts) >= 3:
                 # YAML is parts[1]
                 # Body is parts[2]
                 # We put guide link first, then downloads
                 new_body = guide_link + downloads_block + parts[2]
                 new_content = "---" + parts[1] + "---" + new_body
                 
                 with open(filepath, "w", encoding="utf-8") as f:
                     f.write(new_content)
                 print(f"  Updated QMD {filename}")

if __name__ == "__main__":
    update_assignments()
