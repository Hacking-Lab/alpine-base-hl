#!/command/with-contenv bash

set -euo pipefail

echo "================================="
echo "Password Routine"
echo "================================="

if [ -z "${HL_USER_PASSWORD:-}" ]; then
    echo "\$HL_USER_PASSWORD not set in environment variable"
    echo "will create a random HL user password"
    pwd1=$(openssl rand -base64 18)
else
    echo "\$HL_USER_PASSWORD is set in environment variable"
    echo "will use given password from environment variable"
    pwd1=$HL_USER_PASSWORD
fi

if [ -z "${HL_ROOT_PASSWORD:-}" ]; then
    echo "\$HL_ROOT_PASSWORD not set in environment variable"
    echo "will create a random root password"
    pwd2=$(openssl rand -base64 18)
else
    echo "\$HL_ROOT_PASSWORD is set in environment variable"
    echo "will use given root password from environment variable"
    pwd2=$HL_ROOT_PASSWORD
fi

if [ -z "${HL_USER_USERNAME:-}" ]; then
   echo "\$HL_USER_USERNAME not set in environment variable"
   echo "will use default username hacker"
   HL_USER_USERNAME=hacker
else
   echo "\$HL_USER_USERNAME is set in environment variable"
fi

echo "================================="
echo "$HL_USER_USERNAME"
echo "================================="

if [ "$HL_USER_USERNAME" = "root" ]; then
   echo "HL_USER_USERNAME=root"
   printf 'root:%s\n' "$pwd2" | chpasswd
else
   if ! [[ "$HL_USER_USERNAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
      echo "Invalid HL_USER_USERNAME: $HL_USER_USERNAME" >&2
      exit 1
   fi

   echo "\$HL_USER_USERNAME is set and not root"
   if ! id "$HL_USER_USERNAME" >/dev/null 2>&1; then
      adduser -D -u 2000 -s /bin/bash "$HL_USER_USERNAME"
   fi
   printf 'root:%s\n' "$pwd2" | chpasswd
   printf '%s:%s\n' "$HL_USER_USERNAME" "$pwd1" | chpasswd
fi

echo "
-------------------------------------
GID/UID
-------------------------------------
User uid:    $(id -u "$HL_USER_USERNAME")
User gid:    $(id -g "$HL_USER_USERNAME")
-------------------------------------
"

HL_USER_GROUPNAME=$(id -g -n "$HL_USER_USERNAME")

printf 'HL_USER_USERNAME=%s\n' "$HL_USER_USERNAME" > /etc/hluser
printf 'HL_USER_GROUPNAME=%s\n' "$HL_USER_GROUPNAME" >> /etc/hluser

printf '%s\n' "$HL_USER_USERNAME" > /run/s6/container_environment/S6_USER_USERNAME
printf '%s\n' "$HL_USER_GROUPNAME" > /run/s6/container_environment/S6_USER_GROUPNAME
