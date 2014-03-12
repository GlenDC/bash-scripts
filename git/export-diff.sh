line=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$1")
filename=${line##*[/|\\]}
filename=${filename%.*}
if (( $# == 3 )); then
  path=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$3")
  id=$(echo $(git blame HEAD $line -L $2,+1) | cut -d " " -f 1)
  git diff $id $line > "$path/${filename%.*}.diff"
elif (( $# == 2 )); then
  path=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$2")
  ids=$(git log -n 2 --pretty=format:%h -- $line)
  git diff $(echo $ids | cut -d " " -f 1):$line $(echo $ids | cut -d " " -f 2):$line > "$path/${filename%.*}.diff"
else
  echo "export-diff: You have given an illegal amount of parameters."
fi