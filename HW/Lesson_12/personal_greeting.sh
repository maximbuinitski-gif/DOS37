!#/bin/bash

#We are requesting the name
read -p "Enter your name - " username

#We check that the name is not empty
if [ -z $username ]; then
	echo "Error: the name cannot be empty!"
	exit 1
fi

echo "Hello, $username! Welcome!"
