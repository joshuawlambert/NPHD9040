import re
import os

def transform_r_code_blocks(content):
    """Transform old HTML-style R code blocks to proper R code blocks."""
    
    # Pattern to match <details><summary>R Code Example:</summary>...<pre>...R code...</pre>...</details>
    # and replace with proper R code blocks
    
    # First, extract R code from HTML pre tags within R Code Example details
    def replace_r_details(match):
        details_content = match.group(0)
        
        # Extract code from <pre> tags
        code_matches = re.findall(r'<pre>(.*?)</pre>', details_content, re.DOTALL)
        
        if code_matches:
            # Clean up the code
            code = code_matches[0]
            code = code.strip()
            # Remove HTML entities
            code = code.replace('&lt;', '<').replace('&gt;', '>').replace('&amp;', '&')
            
            # Return as proper R code block
            return f"\n```{{r, eval=FALSE}}\n{code}\n```\n"
        
        return ""
    
    # Replace R Code Example details blocks
    content = re.sub(
        r'<details>\s*<summary>R Code Example:</summary>.*?</details>',
        replace_r_details,
        content,
        flags=re.DOTALL
    )
    
    return content

def add_code_fold_setting(content):
    """Update YAML header to set code-fold: false."""
    
    # Replace code-fold: true with code-fold: false
    content = re.sub(r'code-fold:\s*true', 'code-fold: false', content)
    
    # Fix css path if needed
    content = re.sub(r'css:\s*styles\.css', 'css: ../styles.css', content)
    
    return content

def process_lecture_file(file_path):
    """Process a single lecture file."""
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Transform R code blocks
    content = transform_r_code_blocks(content)
    
    # Update YAML settings
    content = add_code_fold_setting(content)
    
    # Clean up multiple consecutive blank lines
    content = re.sub(r'\n\n\n+', '\n\n', content)
    
    return content

def process_all_lectures(lectures_dir):
    """Process all lecture files."""
    
    lecture_files = [
        'graphing-your-data.qmd',
        'introduction-to-anova.qmd',
        'introduction-to-ancova.qmd',
        'introduction-to-two-way-anova.qmd',
        'introduction-to-repeated-measures-anova.qmd',
        'introduction-to-simple-linear-regression.qmd',
        'introduction-to-multiple-linear-regression.qmd',
        'introduction-to-logistic-regression.qmd',
    ]
    
    for filename in lecture_files:
        file_path = os.path.join(lectures_dir, filename)
        
        if not os.path.exists(file_path):
            print(f"Warning: {filename} not found")
            continue
        
        print(f"Processing {filename}...")
        transformed_content = process_lecture_file(file_path)
        
        # Write transformed content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(transformed_content)
        
        print(f"  ✓ Transformed")

if __name__ == "__main__":
    lectures_dir = r"c:\Users\sp4zt\Downloads\R workshop\NPHD9040\Lectures"
    
    print("=" * 60)
    print("Transforming R code blocks in lecture files")
    print("=" * 60)
    
    process_all_lectures(lectures_dir)
    
    print("\nDone!")
