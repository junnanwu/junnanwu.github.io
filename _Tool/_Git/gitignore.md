# gitignore

gitignore文件中记录了git应该忽略的文件，已经被git管理的文件则不受影响。

规范：

- 每一行代表一个匹配规则

- 所有空行或者以 `#` 开头的行都会被忽略。

- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中。

  所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。 星号（`*`）匹配零个或多个任意字符；`[abc]` 匹配任何一个列在方括号中的字符 （这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）； 问号（`?`）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符， 表示所有在这两个字符范围内的都可以匹配（比如 `[0-9]` 表示匹配所有 0 到 9 的数字）。 使用两个星号（`**`）表示匹配任意中间目录，比如 `a/**/z` 可以匹配 `a/z` 、 `a/b/z` 或 `a/b/c/z` 等。

- 匹配模式可以以（`/`）开头防止递归。

  `logs/`：**忽略当前路径下的logs目录**，包含logs下的所有子目录和文件

  `/logs.txt`：**忽略根目录下的logs.txt文件**，根目录指的是`.gitignore`文件所在的文件夹

- 匹配模式可以以（`/`）结尾指定目录。

- 要忽略指定模式以外的文件或目录，可以在模式前加上叹号（`!`）取反。

例如：

- `*.jar`

  排除整个文件夹中的所有`jar`文件

- `project`

  **所有目录下project文件及project文件夹下的东西**

- `project/`

  **所有目录下的projext文件夹及其里面的东西**

## java开发通用版本

```
# Compiled class file
*.class

# Eclipse
.project
.classpath
.settings/

# Intellij
*.ipr
*.iml
*.iws
.idea/

# Maven
target/

# Gradle
build
.gradle

# Log file
*.log
log/
logs/

#conf

# out
**/out/

# Mac
.DS_Store

# others
*.jar
*.war
*.zip
*.tar
*.tar.gz
*.pid
*.orig
temp/
```

## 强制添加

- 当你`git add`一个已经添加到`.gitignored`的文件的时候，提示如下：

  ```
  $ git add test_dir
  The following paths are ignored by one of your .gitignore files:
  test_dir
  hint: Use -f if you really want to add them.
  hint: Turn this message off by running
  hint: "git config advice.addIgnoredFile false"
  ```

- 当你想查看命中了哪一条规则的时候

  ```
  $ git check-ignore -v test_dir
  .gitignore:4:test_dir	test_dir
  ```

- 如果你还想强制添加

  ```
  $ git add -f test_dir
  ```

  注意：

  强制添加后的，如果修改了，还是会被跟踪的
