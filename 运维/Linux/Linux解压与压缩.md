# Linux解压与压缩

## tar

Unix和Linux上最广泛使用的归档工具，tar命令最开始是用来将文件写到磁带设备上归档的，然而它也能把输出写到文件里，这种用法在Linux上已经普遍用来归档数据了，这是Linux中分发开源程序源码文件所采用的普遍方法。

参数：

- `-x` 解压

- `-c` 

  `-create` 创建一个新的tar归档文件

- `-v` 处理时显示文件

- `-f` file 输出结果到文件

- `-z` 将输出重定向给gzip命令来压缩内容

打包（这个不叫压缩）

```
$ tar -cvf FileName.tar DirName
```

解包

```
$ tar -xvf FileName.tar
```

打包多个文件

```
$ tar -czvf bak.tar.gz users/ config.xml jobs/ plugins/
```

解压`tar.gz`/`tgz`

这些是gzip压缩过的tar文件

```
$ tar -zxvf filename.tgz
```

压缩

```
$ tar -zcvf FileName.tar.gz DirName
```

解压到指定目录

将文件解压到test目录下：

```
$ tar zxvf test.tar.gz -C test
```

## gz

GNU压缩工具，用Lempel-Ziv编码，属于无损压缩（lossless compression）

压缩

```
$ gzip FileName
```

解压

```
$ gunzip FileName.gz 
$ gzip -d FileName.gz 
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

  

