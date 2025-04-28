#!/bin/bash

print_help() {
  echo "Usage: $0 [OPTIONS] search_string filename"
  echo "Options:"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match (show lines that do NOT match)"
  echo "  --help    Display this help message"
  exit 0
}

# Check for --help
if [[ "$1" == "--help" ]]; then
  print_help
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" == -* ]]; do
  case "$1" in
    -n) show_line_numbers=true ;;
    -v) invert_match=true ;;
    -vn|-nv)
        show_line_numbers=true
        invert_match=true
        ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Now $1 should be the search string
search_string="$1"
file="$2"

# Validate arguments
if [[ -z "$search_string" || -z "$file" ]]; then
  echo "Error: Missing search string or filename."
  echo "Usage: $0 [OPTIONS] search_string filename"
  exit 1
fi

if [[ ! -f "$file" ]]; then
  echo "Error: File '$file' not found."
  exit 1
fi

# Read file and search
line_number=0
while IFS= read -r line; do
  ((line_number++))
  # Case-insensitive search
  echo "$line" | grep -qi "$search_string"
  match=$?

  if [[ $invert_match == true ]]; then
    match=$(( 1 - match ))  # invert match
  fi

  if [[ $match -eq 0 ]]; then
    if [[ $show_line_numbers == true ]]; then
      echo "${line_number}:$line"
    else
      echo "$line"
    fi
  fi
done < "$file"

