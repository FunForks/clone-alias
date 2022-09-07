# echo $0
# echo $1
# echo $2

# echo $1
# echo "$(basename -- $1 .git)"

# git clone "$1"
# cd "$(basename -- $1 .git)"
# code -r .

git clone "$1"
&& cd "$(basename -- $1 .git)"
&& code -r .