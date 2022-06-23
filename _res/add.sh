#! /bin/zsh
set -e
./generate_modify_top10.sh 
./generate_sidebar.sh
git add ../
echo 'git add 完毕！'
git commit -m $1
echo 'git commit $1 完毕！'
git push
echo 'git push 完毕！'