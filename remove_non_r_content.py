import re
import os

def remove_non_r_sections(file_path):
    """Remove all JMP, Python, SPSS, and Stata sections from a qmd file."""
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Pattern to match <details> blocks for JMP, Python, SPSS, STATA
    # This matches from <details> to </details> if the summary contains these keywords
    patterns = [
        r'<details>\s*<summary>JMP Instructions:</summary>.*?</details>',
        r'<details>\s*<summary>Python.*?</summary>.*?</details>',
        r'<details>\s*<summary>SPSS.*?</summary>.*?</details>',
        r'<details>\s*<summary>STATA.*?</summary>.*?</details>',
        r'<details>\s*<summary>Stata.*?</summary>.*?</details>',
    ]
    
    original_length = len(content)
    
    for pattern in patterns:
        content = re.sub(pattern, '', content, flags=re.DOTALL | re.IGNORECASE)
    
    # Clean up multiple consecutive blank lines
    content = re.sub(r'\n\n\n+', '\n\n', content)
    
    removed_chars = original_length - len(content)
    
    return content, removed_chars

def process_lecture_files(lectures_dir):
    """Process all lecture files in the directory."""
    
    lecture_files = [
        'graphing-your-data.qmd',
        'introduction-to-anova.qmd',
        'introduction-to-ancova.qmd',
        'introduction-to-two-way-anova.qmd',
        'introduction-to-repeated-measures-anova.qmd',
        'introduction-to-simple-linear-regression.qmd',
        'introduction-to-multiple-linear-regression.qmd',
        'introduction-to-logistic-regression.qmd',
        'QI_and_EBP.qmd'
    ]
    
    results = {}
    
    for filename in lecture_files:
        file_path = os.path.join(lectures_dir, filename)
        
        if not os.path.exists(file_path):
            print(f"Warning: {filename} not found")
            continue
        
        print(f"Processing {filename}...")
        cleaned_content, removed = remove_non_r_sections(file_path)
        
        # Create backup
        backup_path = file_path + '.backup'
        with open(backup_path, 'w', encoding='utf-8') as f:
            with open(file_path, 'r', encoding='utf-8') as original:
                f.write(original.read())
        
        # Write cleaned content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(cleaned_content)
        
        results[filename] = removed
        print(f"  Removed {removed} characters")
        print(f"  Backup saved to {backup_path}")
    
    return results

if __name__ == "__main__":
    lectures_dir = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Lectures"
    
    print("=" * 60)
    print("Removing non-R content from lecture files")
    print("=" * 60)
    
    results = process_lecture_files(lectures_dir)
    
    print("\n" + "=" * 60)
    print("Summary:")
    print("=" * 60)
    for filename, removed in results.items():
        print(f"{filename}: {removed} characters removed")
    
    print("\nDone! Backups created with .backup extension")
