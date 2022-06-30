:<<EOF
根据笔记所在文件夹自动生成边侧目录
EOF

#! /bin/bash
set -e
base_dir='../'
target_catalog="JavaSE JavaEE JavaWeb Spring Database 计算机基础 运维 Tool 其他"
#最终输出
result=""
echo 开始生成目录...
print_dir(){
	#默认for...in会根据空格进行分割，导致文件名里面不能空格，这里ls输出的分割符为\n
    IFS=$'\n'
    depth=$((depth + 1))
	absolute_path=$1
	file=${absolute_path##*/}
	#md列表所需的空格数
	if [ $depth == 0 ]
	then
		space=""
	else
		space_of_number=$((depth*2+2))
		space=$(seq -s ' ' $space_of_number | sed 's/[0-9]//g')
	fi
	#如果是目录 且 不是img/image/assets/_开头的
    if [[ -d $1 && $file != *img* && $file != *asset* && $file != *.md && $file != _* ]]
	then
		#拼接目录
		result="$result$space- **$file**\n"
		#子文件递归调用
        for file in `ls $1`
        do
        #拼接相对路径 为了文件类型的超链接
	    relative_path="$relative_path/$file"
		print_dir $1"/"$file
		done
	#如果是md文件，且不以_开头
	elif [[ -n $file && $file == *.md && $file != _* && $file != README* && $file != *.sh ]]
	then
		#去除文件第一个/
		#final_path=${relative_path:1}
		final_path=${relative_path}
		#${file%.*}删除最后一个.及其右边内容
		result="$result$space- [${file%.*}]($final_path)\n"
	fi
	#删除最后一个/及其右边内容
	relative_path=${relative_path%/*}
    depth=$((depth - 1))
}
#按目标目录顺序调用
IFS_OLD=$IFS
for catalog in $target_catalog
do 
	depth=-1
	relative_path=$catalog
	print_dir ~/docs/$catalog
done
IFS=$IFS_OLD
echo "$result" > $base_dir'_sidebar.md'
echo 生成目录结束...
