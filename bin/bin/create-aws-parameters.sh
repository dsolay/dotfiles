#!/bin/bash

# Verifica si jq está instalado
if ! command -v jq &>/dev/null; then
  echo "Error: jq no está instalado. Por favor, instálalo y vuelve a intentar."
  exit 1
fi

# Verifica si se pasó una ruta como argumento
if [ -z "$1" ]; then
  # Si no se proporciona argumento, usar el archivo parameters.json en la carpeta actual
  FILE="parameters.json"
else
  FILE="$1"
fi

# Verifica si se pasó el perfil como segundo argumento
if [ -z "$2" ]; then
  # Si no se proporciona un perfil, usar el perfil predeterminado
  PROFILE="default"
else
  PROFILE="$2"
fi

# Verifica si el archivo existe
if [ ! -f "$FILE" ]; then
  echo "Error: El archivo '$FILE' no existe."
  exit 1
fi

# Lee el archivo JSON y crea los parámetros en Parameter Store
for row in $(jq -c '.[]' "$FILE"); do
  name=$(echo "$row" | jq -r '.Name')
  value=$(echo "$row" | jq -r '.Value')
  type=$(echo "$row" | jq -r '.Type')

  echo "Creando/actualizando parámetro '$name' con el perfil '$PROFILE'..."

  # Crea el parámetro en Parameter Store
  aws ssm put-parameter --name "$name" --value "$value" --type "$type" --overwrite --profile "$PROFILE"
done

echo "Todos los parámetros han sido creados/actualizados."
