# MySQL事务

MySQL中，事务是最小的工作单元，事务能保证一个业务的完整性

```sql
update user set money=money-100 where name='a';

update user set money=money+100 where name='b';
```

实际的程序中，如果只有一条语句执行成功了，而另外一条没有成功，就会出现数据前后不一致的情况。

MySQL 默认情况下开启了一个自动提交的模式 autocommit，一条语句被回车执行后该语句便生效了，便会保存在 MySQL 的文件中，无法撤消。

默认开启自动提交当我们去执行一个SQL语句的时候，效果会立即体现出来，且不能回滚。

**事务回滚** : 撤销SQL语句执行效果

要想实现回滚就需要设置MySQL自动提交为False，这也是开启事务的一种方式

```sql
-- 0:OFF  1:ON
set autocommit=0; 
```

当使用`commit;`手动提交数据之后，再进行回滚，就不管用了，体现了事务的持久性，事务一旦提交，就不能再回滚，也就是说这个事务在提交的时候已经结束了

**手动开启一个事务**,事务给我们提供了一个返回的机会:回滚

```sql
set autocommit=0;
begin;
start transaction;
```

关于 autocommit 与事务，它们其实是这样的关系：

1. MySQL 每一步操作都可看成一个原子操作。默认情况下，autocommit 是开启状态，所以每一条语句都是执行后自动提交，语句产生的效果会被记录保存下来（这时候回滚是无效的）
2. 我们手动关闭autocommit 后，语句不会自动提交，这时需要手动调用 COMMIT 来让效果被持久化
3. 在默认情况下，（autocommit 处于开启状态时）我们也可通过 BEGIN 开启一个事务，此时 autocommit 被隐式地关闭了，因此事务操作过程中也是需要显式调用 COMMIT 来让效果永久生效。
4. BEGIN 开启一个事务后，使用 COMMIT 或 ROLLBACK 来结束该事务。事务结束后 ，autocommit 回到原有的状态。所以，autocommit 这个开关相当于一个记录事务的标记，它被关闭时，你一直处于一个可回滚的状态。而 BEGIN 开启的是一次临时事务，一旦 COMMIT 或 ROLLBACK 本次事务便结束了。

## 事务特性

1. 原子性（Atomicity）：事务开始后所有操作，要么全部做完，要么全部不做，不可能停滞在中间环节。事务执行过程中出错，会回滚到事务开始前的状态，所有的操作就像没有发生一样。也就是说事务是一个不可分割的整体，就像化学中学过的原子，是物质构成的基本单位。
2. 一致性（Consistency）：事务开始前和结束后，数据库的完整性约束没有被破坏 。比如A向B转账，不可能A扣了钱，B却没收到。
3. 隔离性（Isolation）：同一时间，a，不同的事务之间彼此没有任何干扰。比如A正在从一张银行卡中取钱，在A取钱的过程结束前，B不能向这张卡转账。
4. 持久性（Durability）：事务完成后，事务对数据库的所有更新将被保存到数据库，不能回滚。

## 数据库的四种隔离级别

**Read uncommitted**（脏读）

读未提交，顾名思义，就是一个事务可以读取另一个未提交事务的数据。

事例：老板要给程序员发工资，程序员的工资是3.6万/月。但是发工资时老板不小心按错了数字，按成3.9万/月，该钱已经打到程序员的户口，但是事务还没有提交，就在这时，程序员去查看自己这个月的工资，发现比往常多了3千元，以为涨工资了非常高兴。但是老板及时发现了不对，马上回滚差点就提交了的事务，将数字改成3.6万再提交。

分析：实际程序员这个月的工资还是3.6万，但是程序员看到的是3.9万。他看到的是老板还没提交事务时的数据。这就是脏读。

那怎么解决脏读呢？Read committed！读提交，能解决脏读问题。

**Read committed**

读提交，顾名思义，就是一个事务要等另一个事务提交后才能读取数据。

事例：程序员拿着信用卡去享受生活（卡里当然是只有3.6万），当他埋单时（程序员事务开启），收费系统事先检测到他的卡里有3.6万，就在这个时候！！程序员的妻子要把钱全部转出充当家用，并提交。当收费系统准备扣款时，再检测卡里的金额，发现已经没钱了（第二次检测金额当然要等待妻子转出金额事务提交完）。程序员就会很郁闷，明明卡里是有钱的…

分析：这就是读提交，若有事务对数据进行更新（UPDATE）操作时，读操作事务要等待这个更新操作事务提交后才能读取数据，可以解决脏读问题。但在这个事例中，出现了一个事务范围内两个相同的查询却返回了不同数据，这就是不可重复读。

那怎么解决可能的不可重复读问题？Repeatable read ！

**Repeatable read**

重复读，就是在开始读取数据（事务开启）时，不再允许修改操作

事例：程序员拿着信用卡去享受生活（卡里当然是只有3.6万），当他埋单时（事务开启，不允许其他事务的UPDATE修改操作），收费系统事先检测到他的卡里有3.6万。这个时候他的妻子不能转出金额了。接下来收费系统就可以扣款了。

分析：重复读可以解决不可重复读问题。写到这里，应该明白的一点就是，不可重复读对应的是修改，即UPDATE操作。但是可能还会有幻读问题。因为幻读问题对应的是插入INSERT操作，而不是UPDATE操作。

按照可重复读的定义，一个事务启动的时候，能够看到所有已经提交的事务结果。但是之后，这个事务执行期间，其他事务的更新对它不可见。

而且在A

**什么时候会出现幻读？**

事例：程序员某一天去消费，花了2千元，然后他的妻子去查看他今天的消费记录（全表扫描FTS，妻子事务开启），看到确实是花了2千元，就在这个时候，程序员花了1万买了一部电脑，即新增INSERT了一条消费记录，并提交。当妻子打印程序员的消费记录清单时（妻子事务提交），发现花了1.2万元，似乎出现了幻觉，这就是幻读。

在可重复读中，该sql第一次读取到数据后，就将这些数据加锁（悲观锁），其它事务无法修改这些数据，就可以实现可重复读了。但这种方法却无法锁住insert的数据，所以当事务A先前读取了数据，或者修改了全部数据，事务B还是可以insert数据提交，这时事务A就会发现莫名其妙多了一条之前没有的数据，这就是幻读，不能通过行锁来避免。

那怎么解决幻读问题？Serializable！

**Serializable 序列化**

Serializable 是最高的事务隔离级别，在该级别下，事务串行化顺序执行，可以避免脏读、不可重复读与幻读。但是这种事务隔离级别效率低下，比较耗数据库性能，一般不使用。

值得一提的是：大多数数据库默认的事务隔离级别是Read committed，比如Sql Server , Oracle。Mysql的默认隔离级别是Repeatable read

**查询数据库的隔离级别**

```
show variables like '%isolation%';
或
select @@tx_isolation;
```

**设置数据库的隔离级别**

- `set session transactionisolation level` 级别字符串
- 级别字符串：`read uncommitted`、`read committed`、`repeatable read`、`serializable`
- 例如：`set session transaction isolation level read uncommitted`

```
大话事务隔离级别
我，老婆(两个客户端)同时操作一个银行卡(家庭数据库中的一条记录，记录了我家银行卡号和余额)，如果该数据库是Read uncommitted级别，现在我想买电脑，我比较喜欢Thinkpad，看了一款，准备付款，老板扣了我银行卡12000(开启事务，update)，很巧，在家的老婆这时候，突然查询了我的银行卡余额(select)，发现我的余额少了12000，气急败坏等我回家(脏读)，然而我这时候又后悔了，我又想买Mac了，厚着脸皮找老板把钱退了(rollback)，然后回到家，突然被噼里啪啦一顿骂，没等我解释这就是脏读，一个键盘已经扔在我在面前...我决定把数据库的事务级别调整到Read committed，这样的话只有我确定走出店门(commit)，老婆才会查询到扣款记录，不至于冤枉我。第二天我还要去买Mac，我看好了准备付款(开启事务)，一看价格14000，我查了下(select)，余额还有15000，刚刚够，只是有点肝疼，我说付款前再让我看一眼，很巧，这时候老婆拿银行卡买了一个2000的包(update)，买完了(commit)，我也下定决心要付款了，结果店员查了下(select)，说我余额不够，只有14000。我：？？?我很郁闷，刚刚卡里明明有钱的？我明白了，这里又出现了不可重复读！这会导致我一次事务内查询出的余额不一样，我求老婆半天，她才决定向我的银行卡里充了1000元，我决定把事务级别调整到Repeatable read，第三天我又去买苹果电脑，我二话不说就是准备付款(开启事务)，在我一旦开始付款(update)，直到走出店门(commit)，老婆这个期间(开启事务)所有查询都是我付款前的余额，并且不能够再花一分钱，对于老婆来说，这就是可以重复读了，不会出现她一次事务中出现读取同一条数据不一致的重复读问题，老婆必须在我走出店门之后(我commit)，她再次开启事务，执行查询，才能看到这次的消费变化，终于，我买到了电脑。最后我想看下总家当还有多少，我开启事务，粗略看了一下，一共就有一张银行卡，余额0，谁知，在家的老婆这时候终于决定不再刷我的银行卡，她决定自己办一张银行卡(insert)，我刚查完余额，怀疑人生中，这时候，一股神秘力量让我的手指又按下了查询键，结果，居然出来了两张卡(count)，我怀疑自己是不是出现幻觉了(幻读）？？老婆居然自己办了银行卡？？这就是Repeatable read无法解决幻读问题，它能锁定一行数据的修改，但是其他人仍然可以随时执行insert操作！你在一个事务内仍然读出来的两次可能会不一样，要想避免出现这个，只能采取最高隔离等级，Serializable！读用读锁，写用写锁，这样可以避免所有问题，但是哈哈哈，我为啥要这样做呢。
```



注意：

事务的隔离级别解决的只是读问题，但是不能解决并发修改问题

并发的修改必须使用多线程去解决

可重复读并不是别人不能修改，只是锁定快照，别人还是可以进行修改的
