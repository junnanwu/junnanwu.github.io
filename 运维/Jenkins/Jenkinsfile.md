# Jenkinsfile

流水线支持两种语法：

- 声明式流水线
- 脚本式流水线

## 流水线示例

```
pipeline { 
    agent any 
    stages {
        stage('Build') { 
            steps { 
                sh 'make' 
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
}
```

- `sh`是一个执行给定shell命令的流水线step（由 Pipeline: Nodes and Processes plugin提供）
- `junit` 是另一个聚合测试报告的流水线step（由 JUnit plugin提供）

## References

1. https://www.jenkins.io/zh/doc/book/pipeline/