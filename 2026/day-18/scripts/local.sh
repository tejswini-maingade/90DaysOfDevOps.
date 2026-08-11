#!/bin/bash

# Define the greet function
greet(){
    name=$1
    echo "Hello, $name!"
}

# Define the add function
add(){
    num1=$1
    num2=$2
    sum=$(( num1 + num2 ))
    echo "The sum of $num1 and $num2 is: $sum"
}

# Call both functions
greet "Sanket"
add 2 3