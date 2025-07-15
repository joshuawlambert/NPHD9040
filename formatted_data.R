# Function to get file extension
file_ext <- function(filename) {
  # Get the last index of "."
  last_dot <- max(regexpr("\\.", filename, fixed = TRUE))
  if (last_dot == -1) {
    # If no dot is found, return empty string
    return("")
  } else {
    # Extract and return the extension
    return(substr(filename, last_dot, nchar(filename)))
  }
}

# Function to format directory structure
format_directory <- function(root_folder, extensions) {
  # Get list of files and subdirectories recursively
  file_list <- list.files(path = root_folder, recursive = TRUE, full.names = TRUE)
  
  # Initialize empty data frame to store results
  result_df <- data.frame(Root_Folder_Name = character(),
                          File_Folder_Name = character(),
                          Path = character(),
                          stringsAsFactors = FALSE)
  
  # Loop through each file/folder
  for (file_path in file_list) {
    # Extract file/folder name
    file_name <- basename(file_path)
    
    # Extract folder name
    folder_name <- basename(dirname(file_path))
    
    # Check if the file has one of the specified extensions
    if (length(grep(pattern = paste(tolower(extensions),collapse="|"),x = file_name))!=0) {
      # Add entry to result data frame
      result_df <- rbind(result_df, data.frame(Root_Folder_Name = root_folder,
                                               File_Folder_Name = file_name,
                                               Path = file_path,
                                               stringsAsFactors = FALSE))
    }
  }
  
  # Return formatted data frame
  return(result_df)
}

# Example usage
root_folder <- "/home/josh/JoshResearch/NPHD9040_Course_Website/"
extensions <- c(".yml",".css", ".qmd", ".R")  # Specify desired file extensions
formatted_data <- format_directory(root_folder, extensions)
write.csv(x = formatted_data,file = "formatted_data.csv",row.names = FALSE)

