
:<<EOF
生成最近修改的文件top10
此脚本需要mac安装GNU-find和GNU-sed命令
EOF

#! /bin/zsh
set -e
alias sed='gsed'
BASE_DIR='../'
READ_DIR=$BASE_DIR'README.md'
echo '删除已有排行...'
start_line=$[`gsed -n '/^## 最近新增\/修改$/=' $READ_DIR`+1]
end_line=$[($start_line + 10)]
gsed -i "${start_line},${end_line}d" $READ_DIR
echo '已删除旧排行'
echo '获取最近修改的前十个文件...'
top10=""
index=1
IFS_OLD=$IFS 
IFS=$'\n' 
for line in `gfind $BASE_DIR -name '*.md' -printf "\n%AD %AT %p %f" |grep -v 'README\|sidebar\| _\|sh'| sort -t' ' -k1.7,1.8nr -k1.1,1.2rn -k1.4,1.5rn -k2.1,2.2rn -k2.4,2.5rn|head`
do
	file0=$(echo $line | cut -d' ' -f4)_
	file=${file0%.*}
	file_path0=$(echo $line | cut -d' ' -f3)
	file_path=${file_path0#*/}
	top10="$top10$index. [$file]($file_path)\n"
	index=$[$index+1]
done
IFS=$IFS_OLD
echo $top10 >> $READ_DIR
echo '新增完毕!'

