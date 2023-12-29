# input="deploy/test.txt"
input="../docs/README.md"

while IFS= read -r line
do
  printf "%s<br>\n" "$line"
done < "$input"
