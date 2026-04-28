#!/bin/bash

# Check if the input file path is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_360_image.png>"
    exit 1
fi

INPUT_IMAGE="$1"
OUTPUT_PREFIX="${INPUT_IMAGE%.*}_skybox"

echo "Splitting 360 image: $INPUT_IMAGE"

# Get the width of the source image
WIDTH=$(identify -format %w "$INPUT_IMAGE")
# Calculate the size of a single cube face (Width divided by 4)
FACE_SIZE=$((WIDTH / 4))

echo "Face size will be ${FACE_SIZE}x${FACE_SIZE} pixels."

# Use ImageMagick 'convert' with the -crop and -distort commands for projection conversion

# Front face (+Z)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+0+0" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_front.png"

# Back face (-Z)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+${FACE_SIZE}+0" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_back.png"

# Right face (+X)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+${FACE_SIZE}+0" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_right.png"

# Left face (-X)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+0+0" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_left.png"

# Up face (+Y)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+0+${FACE_SIZE}" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_up.png"

# Down face (-Y)
convert "$INPUT_IMAGE" -gravity center -crop "${FACE_SIZE}x${FACE_SIZE}+${FACE_SIZE}+${FACE_SIZE}" -resize "${FACE_SIZE}x${FACE_SIZE}" "${OUTPUT_PREFIX}_down.png"

echo "Finished splitting image. Saved six files with prefix: $OUTPUT_PREFIX"
