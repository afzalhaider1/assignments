#!/bin/bash

case $1 in
    adddir)
        if [ $# -lt 2 ]; then
            echo "Error: Directory name not provided."
            exit 1
        fi
        
        directory="$2"
	dirname="$3"
        if [ -d "$directory/$dirname" ]; then
    echo "Directory '$dirname' already exists in '$directory'"
  else
    mkdir "$directory/$dirname"
    echo "Created directory '$dirname' in '$directory'"
  fi
        ;;
    deldir)
        if [ $# -lt 2 ]; then
            echo "Error: Directory name not provided."
            exit 1
        fi
        
        directory="$2"
	dirname="$3"
        if [ -d "$directory/$dirname" ]; then
    rm -r "$directory/$dirname"
    echo "Deleted directory '$dirname' from '$directory'"
  else
    echo "Directory '$dirname' does not exist in '$directory'"
  fi
        ;;
   listall)
        if [ $# -lt 2 ]; then
            echo "Error: Directory name not provided."
            exit 1
        fi
        
        directory="$2"
        if [ -d "$directory" ]; then
   ls -al "$directory"
  else
    echo "Directory '$directory' does not exist"
  fi
        ;;
  listfiles)
        if [ $# -lt 2 ]; then
            echo "Error: Directory name not provided."
            exit 1
        fi
        
        directory="$2"
        if [ -d "$directory" ]; then
   ls -p "$directory" | grep -v /
  else
    echo "Directory '$directory' does not exist"
  fi
        ;;
 listdir)
        if [ $# -lt 2 ]; then
            echo "Error: Directory name not provided."
            exit 1
        fi
        
        directory="$2"
        if [ -d "$directory" ]; then
   ls -p "$directory" | grep '/$'
  else
    echo "Directory '$directory' does not exist"
  fi
        ;;
 addfile)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 addfile <directory> <filename> <content>"
            exit 1
        fi

        directory="$2"
        filename="$3"
		content="$4"
		filepath="$directory/$filename"
        
        if [ -f "$filepath" ]; then
            echo "File '$filename' already exists in '$directory'."
            echo "Appending content to the existing file."
            echo "$content" >> "$filepath"
        else
            echo "Creating file '$filename' in '$directory'."
            echo "$content" > "$filepath"
        fi
        ;;
 addcontenttofile)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 addcontenttofile <directory> <filename> <content>"
            exit 1
        fi

        directory="$2"
        filename="$3"
		content="$4"
		filepath="$directory/$filename"
        
        if [ -f "$filepath" ]; then
            echo "File '$filename' already exists in '$directory'."
            echo "Adding content to the existing file."
            echo "$content" >> "$filepath"
        else
            echo "Filename '$filename' does not exist."
        fi
        ;;
addcontenttofilebeginning)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 addcontenttofilebeginning <directory> <filename> <content>"
            exit 1
        fi

        directory="$2"
        filename="$3"
		content="$4"
		filepath="$directory/$filename"
        
        if [ -f "$filepath" ]; then
            tmpfile=$(mktemp) 
            echo "$content" > "$tmpfile" 
            cat "$filepath" >> "$tmpfile" 
            mv "$tmpfile" "$filepath" 
            echo "Added content to the beginning of '$filename' in '$directory'"
        else
            echo "Filename '$filename' does not exist."
        fi
        ;;
showfilebeginningcontent)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 showFileBeginningContent <directory> <filename> <lines>"
            exit 1
        fi

        directory="$2"
        filename="$3"
	lines="$4"
	filepath="$directory/$filename"
        
if [ -f "$filepath" ]; then
           echo "Top $lines lines of '$filename' in '$directory':"
            head -n "$lines" "$filepath"
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
showfileendcontent)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 showfileendcontent <directory> <filename> <lines>"
            exit 1
        fi

        directory="$2"
        filename="$3"
	lines="$4"
	filepath="$directory/$filename"

        if [ -f "$filepath" ]; then
           echo "Last $lines lines of '$filename' in '$directory':"
            tail -n "$lines" "$filepath"
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
showfilecontentatline)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 showfilecontentatline <directory> <filename> <lines>"
            exit 1
        fi

        directory="$2"
        filename="$3"
	lines="$4"
	filepath="$directory/$filename"
        
        if [ -f "$filepath" ]; then
           echo "content at line $lines of '$filename' in '$directory':"
            head -n "$lines" "$filepath" | tail -n 1
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
showfilecontentforlinerange)
        if [ $# -lt 4 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 showfilecontentforlinerange <directory> <filename> <lines>"
            exit 1
        fi

        directory="$2"
        filename="$3"
		start_line="$4"
        end_line="$5"
		filepath="$directory/$filename"

        if [ -f "$filepath" ]; then
            echo "Content for line range $start_line - $end_line of '$filename' in '$directory':"
            head -n "$end_line" "$filepath" | tail -n +"$start_line"
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
movefile)
        if [ $# -lt 3 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 movefile <source_filepath> <destination_filepath>"
            exit 1
        fi

        source_filepath="$2"
        destination_filepath="$3"
        
        if [ -f "$source_filepath" ]; then
            mv "$source_filepath" "$destination_filepath"
            echo "Moved file '$source_filepath' to '$destination_filepath'."
        else
            echo "Source file '$source_filepath' does not exist."
        fi
        ;;
copyfile)
        if [ $# -lt 3 ]; then
            echo "Error: Insufficient arguments."
            echo "Usage: $0 copyfile <source_filepath> <destination_filepath>"
            exit 1
        fi

        source_filepath="$2"
        destination_filepath="$3"
        
        if [ -f "$source_filepath" ]; then
            cp "$source_filepath" "$destination_filepath"
            echo "Copied file '$source_filepath' to '$destination_filepath'."
        else
            echo "Source file '$source_filepath' does not exist."
        fi
        ;;
clearfilecontent)
        if [ $# -lt 2 ]; then
       echo "Error: Insufficient arguments."
       echo "Usage: $0 clearfilecontent <directory> <filename>"
        exit 1
        fi

        directory="$2"
        filename="$3"
		filepath="$directory/$filename"
        
        if [ -f "$filepath" ]; then
           echo "" > "$filepath"
           echo "Cleared content of '$filename' in '$directory'."
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
deletefile)
       if [ $# -lt 2 ]; then
       echo "Error: Insufficient arguments."
       echo "Usage: $0 deletefile <directory> <filename>"
       exit 1
        fi

        directory="$2"
        filename="$3"
		filepath="$directory/$filename"
        
       if [ -f "$filepath" ]; then
            rm "$filepath"
            echo "Deleted file '$filename' from '$directory'."
        else
            echo "File '$filename' does not exist in '$directory'."
        fi
        ;;
    *)
        echo "Invalid action: $1"
        exit 1
        ;;
esac
