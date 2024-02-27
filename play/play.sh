#!/bin/bash

# Fördefiniera den krypterade strängen
encrypted_string="vg+F14PlTxz4s6vHN0E+Rw=="

# Dekryptera strängen med nyckeln
decrypt_string() {
    local encrypted_string=$1
    local key=$2
    echo "$encrypted_string" | openssl enc -d -aes-256-cbc -pass pass:"$key" -base64
}

# Loop för att begära nyckeln och dekryptera strängen
attempts=5
while [ $attempts -gt 0 ]; do
    read -s -p "Lösenordet tillhör en omgivande person för att få den säg vem du är ? ($attempts försök kvar): " key
    decrypted_string=$(decrypt_string "$encrypted_string" "$key")
    if [ $? -eq 0 ]; then
        echo -e "\nDin lössenord är: $decrypted_string"
        exit 0
    else
        echo -e "\nFelaktig nyckel! Försök igen."
        ((attempts--))
    fi
done

echo "Inga fler försök kvar. Programmet avslutas."
