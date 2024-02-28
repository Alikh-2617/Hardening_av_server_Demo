#!/bin/bash

# Fördefiniera den krypterade strängen
encrypted_string="U2FsdGVkX1+pf2Flze2cpJCHdFIuKxkaU3VYSaUDwDAXJwlRLUBJ2klDPvFsusxr"

# Dekryptera strängen med nyckeln
decrypt_string() {
    local encrypted_string=$1
    local key=$2
    echo "$encrypted_string" | openssl enc -d -aes-256-cbc -pass pass:"$key" -base64 2>/dev/null
}

# Loop för att begära nyckeln och dekryptera strängen
attempts=5
while [ $attempts -gt 0 ]; do
    read -s -p "Lösenordet tillhör en omgivande person för att få den säg vem du är ? ($attempts försök kvar): " key
    decrypted_string=$(decrypt_string "$encrypted_string" "$key")
    if [ $? -eq 0 ]; then
        echo -e "\n\n\tHej $key !\n\tDin användare namn är : $key \n\tDin lösenord är: $decrypted_string"
        exit 0
    else
        echo -e "\nFelaktig nyckel! Försök igen."
        ((attempts--))
    fi
done

echo "Inga fler försök kvar. Programmet avslutas."
