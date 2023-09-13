[toc]

##### 描述

gcp的sdwebui是部署在谷歌gke集群上面的，

优势: 

​         比较节省使用成本;

​         不用准备多个域名;

​         不像云函数那样重启比较困难，重启和训练都和单台服务器一样;

缺点: 

​            部署和维护较难;

​            抢占式实例有一定的不稳定因素;

##### 使用方法

和阿里云ecs以及云函数使用的方法差不多，下面只说差异部分

##### 用户申请

准备一个谷歌账号必须是@gmail.com结尾的账号

将需要的账号交给黄志鹏进行记录真实用户对应的谁, 进行登记；黄志鹏将名单给袁潇进行后端授权即可

##### 访问

用谷歌浏览器访问网页   https://sd.agones.playdayy.cn 然后用上面的谷歌账号登录即可

```
保活:      理论上只要sd一直在用, 服务器会一直存在, 当sd没有使用大概15分钟左右，服务器则会关闭，下次打开则是一台新的服务器

训练和推理: 理论上训练和推理都支持，但存在 抢占式实例有可能被中途被回收的可能，导致训练中断
```



##### 管理sd服务

浏览器打开网址  https://sd.agones.playdayy.cn/psuperfaa/    <font color='red'>注意最后需要带上/</font> ,   进入如下界面

只用操作第二行，第一行不要动

![image-20230913140744950](https://markdown-source.playnexx.net/81ab002a584a41c6a8f6099a7aa6272b_1694586114.png)



##### minio上传功能(如果不想使用filezilla，可以用这个)

目前开放了上传模型的功能

目前只给了上传和下载权限，删除权限没有给。怕误删，如果有上传错了需要删除的联系管理员即可。

无需下载任何软件

谷歌浏览器访问:  <font color='red'> minio-web.agones.playdayy.cn</font>;     用户名: ecsuser, 密码: ecsuserqwe

如下图:

<img src="https://markdown-source.playnexx.net/cfdee559d84544a2846901527f845966_1694586124.png" alt="image-20230515145857781" style="zoom:33%;" />

点击上面的"browse"进入目录管理，即可上传：

<img src="https://markdown-source.playnexx.net/d06b8a8359e04fbe97a288df7b460006_1694586134.png" alt="image-20230515150000976" style="zoom:33%;" />

