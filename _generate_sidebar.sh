:<<EOF
根据笔记所在文件夹自动生成边侧目录
EOF

#! /bin/bash
depth=-1
result=""
relative_path=""

print_dir(){
    depth=$((depth + 1))
    for file in `ls $1`
    do
	relative_path="$relative_path/$file"
	if [ $depth == 0 ]
	then
		space=""
	else
		space_of_number=$((depth*2+2))
		space=$(seq -s ' ' $space_of_number | sed 's/[0-9]//g')
	fi
	#如果是目录 且 不是img/image/assets/_开头的
        if [[ -d $1"/"$file && $file != *img* && $file != *asset* && $file != *.md && $file != _* ]]
	then
		result="$result$space- $file\n"
		print_dir $1"/"$file
	#如果是md文件，且不以_开头
	elif [[ $file == *.md && $file != _* ]]
	then
		final_path=${relative_path:1}
		result="$result$space- [${file%.*}]($final_path)\n"
	fi
	relative_path=${relative_path%/*}
    done
    depth=$((depth - 1))
}

print_dir ~/docs
echo "$result" > _sidebar.md
