# Java时间相关

### 获取昨天时间的字符串

- 方法一：

  ```java
  SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
  Calendar calendar = Calendar.getInstance();
  calendar.add(Calendar.DATE, -1);
  yesterdayString = simpleDateFormat.format(calendar.getTime());
  System.out.println(yesterdayString);
  ```

- 方法二：

  ```java
  SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
  Date yesterday = new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000);
  String yesterdayString = simpleDateFormat.format(yesterday);
  System.out.println(yesterdayString);
  ```
