
import os
import re

# --- Configuration ---
LECTURES_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Lectures"
ASSIGNMENTS_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Assignments"
COURSE_DATA_DIR = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\course_data"

# Map assignments to their datasets
HW_DATASETS = {
    "hw1": "Coffee Data.csv",
    "hw2": "anova_ex1.csv",
    "hw3": "Coffee Data.csv",
    "hw4": "rm_ex.csv",
    "hw5": ["slr_ex1.csv", "mlr_ex1.csv"]
}

def extract_r_code(content):
    code_lines = []
    in_chunk = False
    for line in content.splitlines():
        if line.strip().startswith("```{r"):
            in_chunk = True
            code_lines.append("\n" + "#" + "-"*30)
            code_lines.append(f"# {line.strip()}")
            code_lines.append("#" + "-"*30 + "\n")
            continue
        if line.strip().startswith("```") and in_chunk:
            in_chunk = False
            continue
        if in_chunk:
            code_lines.append(line)
    return "\n".join(code_lines)

def process_lectures():
    print("Processing Lectures...")
    for filename in os.listdir(LECTURES_DIR):
        if filename.endswith(".qmd") and not filename.endswith(".backup"):
            filepath = os.path.join(LECTURES_DIR, filename)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()

            # Extract Code
            r_code = extract_r_code(content)
            r_filename = filename.replace(".qmd", ".R")
            r_filepath = os.path.join(LECTURES_DIR, "code", r_filename)
            
            with open(r_filepath, "w", encoding="utf-8") as f:
                f.write(f"# R Code for {filename}\n")
                f.write(r_code)
            
            print(f"  Generated code for {filename}")

            # Add Download Link
            # We look for the end of the YAML header
            if "Download R Code" not in content:
                link_text = f'\n\n[**Download R Code for this Lecture**](code/{r_filename}){{ .btn .btn-primary }}\n\n'
                
                parts = content.split("---", 2)
                if len(parts) >= 3:
                     # parts[0] is empty (before first ---)
                     # parts[1] is yaml
                     # parts[2] is body
                     new_content = "---" + parts[1] + "---" + link_text + parts[2]
                     
                     with open(filepath, "w", encoding="utf-8") as f:
                         f.write(new_content)
                     print(f"  Added link to {filename}")

def process_assignments():
    print("Processing Assignments...")
    for filename in os.listdir(ASSIGNMENTS_DIR):
        if filename.startswith("hw") and filename.endswith(".qmd"):
            filepath = os.path.join(ASSIGNMENTS_DIR, filename)
            hw_key = filename.replace(".qmd", "") # e.g., hw1
            
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()

            # 1. Create Template (.Rmd)
            # The current qmd content is suitable for a template, maybe strip the yaml title to generic?
            # actually users usually want the full file. Let's just copy it.
            template_filename = filename.replace(".qmd", ".Rmd")
            template_filepath = os.path.join(ASSIGNMENTS_DIR, "templates", template_filename)
            
            with open(template_filepath, "w", encoding="utf-8") as f:
                f.write(content)
            print(f"  Created template for {filename}")

            # 2. Add Links to QMD
            # Construct Data Link
            data_links = ""
            if hw_key in HW_DATASETS:
                datasets = HW_DATASETS[hw_key]
                if isinstance(datasets, str):
                    datasets = [datasets]
                
                for ds in datasets:
                     # Check if exists in course_data, if not warn (or logic to create?)
                     # We assume existence based on previous steps
                     data_links += f'\n[**Download Data: {ds}**](../course_data/{ds}){{ .btn .btn-success }}\n'

            template_link = f'\n[**Download Assignment Template**](templates/{template_filename}){{ .btn .btn-primary }}\n'
            
            # Inject after YAML
            if "Download Assignment Template" not in content:
                parts = content.split("---", 2)
                if len(parts) >= 3:
                     new_buttons = "\n::: {.callout-note icon=false}\n## Downloads" + template_link + data_links + "\n:::\n"
                     new_content = "---" + parts[1] + "---" + new_buttons + parts[2]
                     
                     with open(filepath, "w", encoding="utf-8") as f:
                         f.write(new_content)
                     print(f"  Added links to {filename}")

if __name__ == "__main__":
    process_lectures()
    process_assignments()
