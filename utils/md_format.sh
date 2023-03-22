#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

input_file="$1"
temp_file="$(mktemp)"

# Apply transformations to input_file and save the output to temp_file
sed -E 's/\\\\\\\\/{_TEMP_REPLACEMENT_DOUBLE_BACKSLASH_}/g' "$input_file" |
    sed -E 's/\\\\\{/{_TEMP_REPLACEMENT_LBRACE_}/g' |
    sed -E 's/\\\\\}/{_TEMP_REPLACEMENT_RBRACE_}/g' |
    sed -E 's/\\\\/\\\\\\\\/g' |
    sed -E 's/\\\{/\\\\{/g' |
    sed -E 's/\\\}/\\\\}/g' |
    sed -E 's/{_TEMP_REPLACEMENT_DOUBLE_BACKSLASH_}/\\\\\\\\/g' |
    sed -E 's/{_TEMP_REPLACEMENT_LBRACE_}/\\\\{/g' |
    sed -E 's/{_TEMP_REPLACEMENT_RBRACE_}/\\\\}/g' > "$temp_file"

# Replace the input_file with the modified temp_file
mv "$temp_file" "$input_file"
