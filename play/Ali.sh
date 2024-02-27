#!/bin/bash

# Kryptera strängen med nyckeln och visa den
encrypt_string() {
    local input_string=$1
    local key=$2
    echo "$input_string" | openssl enc -aes-256-cbc -pass pass:"$key" -base64
}

# Läs in strängen från användaren
read -p "Ange strängen att kryptera: " input_string

# Läs in nyckeln från användaren
read -p "Ange nyckeln för att kryptera: " key

# Kryptera strängen med nyckeln och visa den
encrypted_string=$(encrypt_string "$input_string" "$key")
echo "Den krypterade strängen är: $encrypted_string"


# chmod +x Ali.sh
# ./Ali.sh
