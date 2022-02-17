# Chromedriver

WebDriver for Chrome，WebDriver是一个开源工具，用于在许多浏览器上自动测试webapps。它提供了导航到网页，用户输入，JavaScript执行等功能。ChromeDriver是一个独立的服务，它为 Chromium 实现 WebDriver 的 JsonWireProtocol 协议。

ChromeDriver 是 google 为网站开发人员提供的自动化测试接口，它是 **selenium2** 和 **chrome浏览器** 进行通信的桥梁。selenium 通过一套协议（JsonWireProtocol:[https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol](https://link.jianshu.com/?t=https%3A%2F%2Fgithub.com%2FSeleniumHQ%2Fselenium%2Fwiki%2FJsonWireProtocol)）和 ChromeDriver 进行通信，selenium 实质上是对这套协议的底层封装，同时提供外部 WebDriver 的上层调用类库。

## Selenium

Selenium 是 ThoughtWorks 提供的一个强大的基于浏览器的开源自动化测试工具。

Selenium 是一个用于 Web 应用程序测试的工具，测试直接自动运行在浏览器中，就像真正的用户在手工操作一样。支持的浏览器包括 IE、Chrome 和 Firefox 等。这个工具的主要功能包括：测试与浏览器的兼容性 - 测试您的应用程序看是否能够很好地工作在不同浏览器和操作系统之上；测试系统功能 - 创建回归测试检验软件功能和用户需求；支持自动录制动作，和自动生成 .NET、Perl、Python、Ruby 和 Java 等不同语言的测试脚本。

## Linux安装Chrome

- 下载rpm包

  ```
  $ sudo wget https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-92.0.4515.159-1.x86_64.rpm
  ```

- 离线安装

  ```
  $ sudo yum -y localinstall google-chrome-stable-92.0.4515.159-1.x86_64.rpm
  ```

- 验证

  ```
  $ google-chrome --version
  Google Chrome 92.0.4515.159
  ```

[点此查看Chrome版本](https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable)

## Mac安装ChromeDriver

如果Chrome是最新的，可以直接如下安装：

```
$ brew install chromedriver
```

注意：ChromeDriver和Chrome的版本需要对应，[在此查看](https://chromedriver.chromium.org/downloads/version-selection)

## Java测试

引入依赖：

```xml
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>3.7.1</version>
</dependency>
```

Demo

```java
public static void main(String[] args) throws InterruptedException {
    System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
    WebDriver driver = new ChromeDriver();
    driver.get("http://www.baidu.com/");

    Thread.sleep(3000);

    WebElement searchBox = driver.findElement(By.id("kw"));

    searchBox.sendKeys("ChromeDriver");
    searchBox.submit();

    Thread.sleep(3000);
    driver.quit();
}
```

上面代码将会：

- 打开Chrome
- 打开baidu.com
- 搜索ChromeDriver

注意：

当弹出：无法打开"chromedriver"，因为无法验证开发者的时候

需要执行如下：

```
$ xattr -d com.apple.quarantine /usr/local/bin/chromedriver
```

## 应用

## References

1. https://unix.stackexchange.com/questions/371981/how-to-download-and-install-chrome-browser-with-specific-version-in-terminal
2. https://www.jianshu.com/p/31c8c9de8fcd
3. https://timonweb.com/misc/fixing-error-chromedriver-cannot-be-opened-because-the-developer-cannot-be-verified-unable-to-launch-the-chrome-browser-on-mac-os/
4. https://chromedriver.chromium.org/downloads/version-selection