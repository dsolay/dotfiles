#!/bin/bash

# Comprobar que se hayan pasado los argumentos necesarios
if [ "$#" -ne 7 ]; then
  echo "Uso: $0 <input_directory> <output_directory> <width> <height> <quality> <offset_y> <gravity>"
  exit 1
fi

# Argumentos
INPUT_DIRECTORY=$1
OUTPUT_DIRECTORY=$2
WIDTH=$3
HEIGHT=$4
QUALITY=$5
OFFSET_Y=$6
GRAVITY=$7

# Procesar todas las imágenes en el directorio de entrada
for file in "$INPUT_DIRECTORY"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    # Redimensionar y recortar la imagen con ImageMagick
    convert "$file" -resize "x${HEIGHT}" -gravity "$GRAVITY" -crop "${WIDTH}x${HEIGHT}+0+$OFFSET_Y" +repage "$OUTPUT_DIRECTORY/$filename"
    # Convertir la imagen a WebP con cwebp
    cwebp -q "$QUALITY" "$OUTPUT_DIRECTORY/$filename" -o "$OUTPUT_DIRECTORY/${filename%.*}.webp"
    # Eliminar la imagen temporal
    rm "$OUTPUT_DIRECTORY/$filename"
  fi
done

echo "Imágenes convertidas y redimensionadas guardadas en $OUTPUT_DIRECTORY"
