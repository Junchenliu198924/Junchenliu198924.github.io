---
layout:     post
title:      "用Jekyll来搭建个人博客以及所涉及的工具介绍"
subtitle:   "搭建过程、实用工具汇总"
date:       2017-02-16
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
    - 实用教程
    - Jekyll
---

>* *今天这是我2017年的第一篇技术博客，以后争取一天一更记录自己一天下来的收获或者分享一些自己有用的内容，今天借用了github和jekyll搭建了个人blog，我也是刚刚开始学习前端，接下来是我今天的分享*

## 导航
[下载安装jekyll构建自己的demoblog](#build1)


[问题小结](#build2)






---
## 下载安装jekyll构建自己的demoblog

### 构建本机环境

我本机环境是2014年 retina mac pro,根据官方网站的指引因为之前已经安装过了ruby的环境，是以前的安装的所以步骤这边就暂时省略，以后如果再安装再把具体的步骤补上。

[jekyll中文主页](http://jekyll.com.cn/)

* 进入“快速指南”按照步骤在本机的命令界面下操作如下命令:
	
		$gem install jekyll
		$jekyll new myblog
		$cd myblog
		~/myblog $ jekyll serve
		=> Now browse to http://localhost:4000

* 构建生产的模板网站主要用到以下两个命令（更多命令请查看官方文档）

		$jekyll build
		=> 当前文件夹中的内容将会生成到 ./site 文件夹中。
		$jekyll serve
		=> 一个开发服务器将会运行在 http://localhost:4000/
	
* 因为官方文档的网页不够美观我也参考的对应几个jekyll网站最后决定fork[黄玄项目jekyll](https://github.com/Huxpro) 的模板，通过git下载到本地。

		--clone到本地文件夹
		$git clone git@github.com:Huxpro/huxblog-boilerplate.git
		--几个重要文件|文件夹说明
		_site文件夹存放 jekyll build生成的静态源码文件
		_post文件夹存放你的blog的内容（markdown）
		
		_config.xml文件用来配置个人信息参数
		具体的配置信息我在这里不再赘述请查看模板项目说明即可
		
		*这边需要注意的是 
		baseurl: "/supremeliuBlog"如果配置的话在本地运行的时候需要输入
		jekyll serve --baseurl '' 
		请确定在 --baseurl 的选项之后存在空串，这样的话你就可以在 localhost:4000 看到你
		的站点（站点根地址不存在 /project-name）。
		
* 在[github](https://github.com/) 上新建个人主页的repository


	![](https://cl.ly/200y0L1M2m2Z/[1b3064c16c95bec58954dab68391f609]_Image%25202017-02-17%2520at%252000.05.00.png)
	
	
	按照github 个人网站主要的按照规则命名  junchenliu198924.github.io
	
	
	![](https://cl.ly/2K2f3M1V1c2l/Image%202017-02-17%20at%2000.11.17.png)	
	
* git clone 本项目的到本地，把刚才修改好的模板文件拷贝到github的主页工程中。

		 git clone https://github.com/Junchenliu198924/Junchenliu198924.github.io.git
		 cp -r *  ../../Junchenliu198924.github.io/
		 git add .
		 git commit "2017-02-16"
		 --把本地代码提交到github
		 git push origin master

* 输入网址验证是否部署成功。

	![](https://cl.ly/2F2n351B3M2x/Image%202017-02-17%20at%2000.32.35.png)
	
	
	
<p id="build2"></p>


---

## 问题小结

今天安装总体来说还是蛮顺利的，jekyll文档中文支持也很好，基本按照操作文档执行就可以完成基础安装任务，文档后续的更新我使用markdown 工具[MacDown的软件](http://macdown.uranusjr.com/)，因为markdown截图需要链接所以我选择了Cloudapp的这款工具，但是遇到截图比较大保存起来就会缓慢影响体验（微博的那个工具貌似用不了），如果你有什么好截图上传共享地址的软件可以在评论留言告知笔者，非常感谢！





