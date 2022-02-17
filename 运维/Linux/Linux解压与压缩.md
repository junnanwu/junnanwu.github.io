# Linux解压与压缩

## tar

Unix和Linux上最广泛使用的归档工具，tar命令最开始是用来将文件写到磁带设备上归档的，然而它也能把输出写到文件里，这种用法在Linux上已经普遍用来归档数据了，这是Linux中分发开源程序源码文件所采用的普遍方法。

tar也与gzip等压缩工具结合了在一起。

格式：

```
tar [选项...] [FILE]...
```

参数：

- `-x` 解压
- `-c` 创建一个新的tar归档文件
- `-t` 查看打包文件的内容包含哪些文件名
- `-v` 显示正在处理的文件
- `-f file` 输出结果到文件
- `-z` 将输出重定向给gzip命令来压缩内容，此时文件名最好为 `*.tar.gz`
- `-j` 采用bzip2进行压缩，文件名最好为`*.tar.bz2`
- `-p` 保留备份数据的原本权限与属性
- `-P` 使用绝对路径，带上`/ `(危险，解压的时候，容易覆盖现有文件)
- `-C dir` 解压缩到特定的目录
- `--exclude` 排除某些文件

例如：

- 打包（这个不叫压缩）

  ```
  $ tar -cvf FileName.tar DirName
  ```

- 解包

  ```
  $ tar -xvf FileName.tar
  ```

- 打包多个文件

  ```
  $ tar -czvf bak.tar.gz users/ config.xml jobs/ plugins/
  ```

- 解压`tar.gz`/`tgz`

  这些是gzip压缩过的tar文件

  ```
  $ tar -zxvf filename.tgz
  ```

- 压缩

  ```
  $ tar -zcvf FileName.tar.gz DirName
  ```

- 解压到指定目录

  将文件解压到test目录下：

  ```
  $ tar zxvf test.tar.gz -C test
  ```

  

## gzip

GNU压缩工具gzip压缩的文件，为了取代 compress 并提供更好的压缩比而成立。

格式：

```
gzip [-cdtv#] 文件名
```

- `-c` 将压缩的数据输出到屏幕上
- `-d` 解压缩
- `-v` 显示压缩比等信息

注意：

- 压缩后原文件会消失，使用gzip压缩的文件在Windows系统中，可以被WinRAR这个软件解压缩。
- gzip提供了1~9个压缩等级，使用默认的6就够了
- 想要从文字压缩文件当中找数据的话，可以通过 egrep 来搜寻

例如：

- 压缩

  ```
  $ gzip FileName
  ```

- 解压

  ```
  $ gunzip FileName.gz 
  $ gzip -d FileName.gz 
  ```

- 查看压缩文件内容：

  ```
  $ zcat xxx.gz
  ```

- 使用最高压缩等级并保存原文件（将压缩后的数据重定向）

  ```
  gzip -9 -c data_record.sql > data_record.sql.gz
  ```

  

关于压缩比率

我的实际测试如下（数据库数据文件，不同文件会有差异）：

```
-rw-r--r--  1 root       root        11G 11月  2 21:48 data_pro.gz.tar
-rw-r--r--  1 root       root        18G 11月  2 21:17 data_pro.tar
```

gz压缩要比tar直接打包慢的多，需要20分钟左右，tar只需2分钟左右。

注意：

tar解压的时候，如果遇到同名的文件将会覆盖

## zip

Windows上PKZIP工具的Unix实现

压缩：

```
$ zip FileName.zip DirName 
```

批量将文件解压到对应的目录

```
$ unzip -d /app tomcat-all.zip
```

解压错怎么办？

列出该压缩文件中的文件列表，根据文件列表来删除文件

- unzip

  ```
  $ zipinfo -1 ./ShareWAF.zip(误解压文件) | xargs rm -rf
  ```

- tar

  ```
  $ tar -tf 误解压文件 | xargs rm -rf
  ```

## jar

格式：

```
jar {ctxui}[vfmn0PMe] [jar-file] [manifest-file] [entry-point] [-C dir] files ...
```

解压：

- 使用unzip可以指定目录

  ```
  $ unzip test.jar -d dest/
  ```

### 最佳实践

#### Jar包相关

- 解压Jar包

  ```
  $ unzip test.jar -d dest/
  ```

- 删除解压后的某个文件夹并重新打包

  ```
  $ cd dest/
  $ rm application.properties
  $ jar cvf ../data_upload-1.0-SNAPSHOT.jar *
  ```

- 查看某个Jar中是否包含某个文件

  ```
  $ target jar tf data_upload-1.0-SNAPSHOT.jar|grep DataRecordDOMapper.xml 
  ```


## References

1. 鸟哥Linux私房菜
