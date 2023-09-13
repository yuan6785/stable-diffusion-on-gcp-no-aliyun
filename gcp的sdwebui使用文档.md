[toc]

##### 描述

gcp的sdwebui是部署在谷歌gke集群上面的，优势是比较节省使用成本, 缺点是部署和维护较难

##### 使用方法

和阿里云ecs以及云函数使用的方法差不多，下面只说差异部分

##### 用户申请

准备一个谷歌账号必须是@gmail.com结尾的账号

将需要的账号交给黄志鹏进行记录, 登记授权即可





首先看这个视频学习sd-web-ui的训练步骤

https://www.youtube.com/watch?v=hHG2AW2FCII

可以从5分钟这里开始看

##### 申请训练机

向中台组(袁潇)申请训练机器, 训练完成后告知中台组, 自动释放时间为12小时；

如果提前训练完成，请告知中台组，及时释放资源。

##### 样本上传和训练好的模型下载

目前开放了ftp上传模型的功能


ftp工具下载地址  
 https://filezilla-project.org/download.php?type=client

目前只给了上传和下载权限，删除权限没有给。怕误删，如果有上传错了需要删除的联系管理员即可。

只有公司网络可以使用ftp工具

下图是连接ftp和样本上传以及训练好的lora模型下载的方法

![image-20230323112128529](https://markdown-source.playnexx.net/f244ed1456c1474c953c707d0a0e80a9_1679541715.png)

##### 管理sd服务

浏览器打开网址”http://分配的ip:9001“      进入如下界面

只用操作第一行，第二行不要动

<img src="https://markdown-source.playnexx.net/2b65de9d563440499195913a9b280563_1682306187.png" alt="image-20230424111612004" style="zoom:33%;" />

##### 关于ftp连不上或者web页面登不上的问题

###### windows系统的处理

1. 首先打开公司的梯子软件v2ray

<img src="https://markdown-source.playnexx.net/a5f4d240f0e642149b398b50a783de52_1682303825.png" alt="image-20230424103026219" style="zoom: 33%;" />

2. 打开ftp工具filezilla，点击”编辑--->设置“

   <img src="https://markdown-source.playnexx.net/a62beea431174c15b23b2bf04cbc85dd_1682303831.png" alt="image-20230424103614157" style="zoom:33%;" />

3. 如果是web页面无法打开， 可以尝试使用全局代理试试

   ![企业微信截图_16823030935496](https://markdown-source.playnexx.net/5ef99a7d03b5480db89585f778224b70_1682303835.png)





###### mac系统的代理处理

1. 首先打开公司的梯子软件v2ray,   梯子记得选-->天天香港

​     <img src="https://markdown-source.playnexx.net/677354a8635d4ed1824103ba12b516cf_1682304346.png" alt="image-20230424104537564" style="zoom:33%;" />    

2. 打开ftp工具filezilla，点击”编辑--->设置“

   <img src="https://markdown-source.playnexx.net/9b6fa596c5b94427ad0dfb628729583f_1682304528.png" alt="image-20230424104837993" style="zoom:33%;" />

3. 如果是web页面无法打开， 可以尝试使用全局代理试试

   <img src="https://markdown-source.playnexx.net/d336b473110048b18084f920df666b6d_1682304680.png" alt="image-20230424105108396" style="zoom:33%;" />

##### 关于ftp用上传大量的小文件出现断线重连的情况处理



1.  当出现如下图所示，我们选择"续传"和下面三个勾选框即可

<img src="https://markdown-source.playnexx.net/00ca5757d400489fb0190623601ff8a3_1682573859.png" alt="企业微信截图_c76ded15-f8c7-452b-94ee-d50c1cde8c78" style="zoom: 25%;" />

2. 当传输失败的时候的处理(没有失败文件则跳过这一步)

   首先看最下面有没有传输失败的文件，然后右键这些文件， 选择"重新上传所选文件"， 这些文件将出现在下面的"等候的档案"中

   <img src="https://markdown-source.playnexx.net/44a65deab1ec4ff5a44512552d800f52_1682573904.png" alt="企业微信截图_af044997-040a-41ee-b6df-c855d301a709" style="zoom: 25%;" />



​     当做出上面的操作后， 在最下面"等候的档案"里面， 会出现上一步的失败的文件，右键"处理队列"，即可重新上传失败的文件

<img src="https://markdown-source.playnexx.net/66d60b6f3ba64cb592e31ab9681ce4e8_1682573990.png" alt="企业微信截图_07989d64-f88e-4743-be57-01456d5ab2d3" style="zoom:25%;" />

##### minio上传功能(如果不想使用filezilla，可以用这个)

目前开放了上传模型的功能

目前只给了上传和下载权限，删除权限没有给。怕误删，如果有上传错了需要删除的联系管理员即可。

只有公司网络可以使用minio上传

无需下载任何软件

谷歌浏览器访问:  <font color='red'> http://申请的ip:9003</font>;     用户名: ecsuser, 密码: ecsuserqwe

如下图:

<img src="https://markdown-source.playnexx.net/71b45e7b00b24712b22d90433a87eb46_1684134032.png" alt="image-20230515145857781" style="zoom:33%;" />

点击上面的"browse"进入目录管理，即可上传：

<img src="https://markdown-source.playnexx.net/512ad323205047cb8e94735a4b0b362b_1684134041.png" alt="image-20230515150000976" style="zoom:33%;" />

