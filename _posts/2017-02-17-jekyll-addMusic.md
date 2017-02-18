---
layout:     post
title:      "Jekyll在博客页面中添加网易云音乐播放"
subtitle:   "在博客中添加音乐播放以及今天踩到的一些前端的坑~"
date:       2017-02-17
author:     "Supremeliu"
header-img: "img/2017-02-17-Iverson.jpg"
music-id: 34930257
tags:
    - 实用教程
    - Jekyll
---



>* *正好这几天公司上午没有什么事情，完善一下自己刚刚发布的blog，以后自己还会持续对我的网站进行改动。*

## 导航
[在博客页面中添加网易云音乐播放](#build1)


[今日问题小结](#build2)






---
##  在博客页面中添加网易云音乐播放

网易云音乐是是我自己的平时听歌用你的软件，无论是移动端还是网页端，界面设计感我觉得是比较不错的今天偶然发现了一个生成外部链接的地方，

![](https://cl.ly/1d320F2J0Z1X/Image%202017-02-18%20at%2001.57.50.png)



想着以后回看的时候还能听听当时听的歌儿，感觉应该会不错吧应该。添加配置很简单具体如下：


* 复制要在blog上面播放的曲目 iframe地址比如：
`<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=450 src="//music.163.com/outchain/player?type=1&id=34930257&auto=1&height=430"></iframe>`

* 把这段代码加入到对应的{项目文件夹}/_layout/page.html模板文件，添加的代码如下：

<!--网易云音乐变量为page.music-id  变量为播放歌曲的序列号-->

                {% if page.music-id %}
               <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=298 height=52 src="//music.163.com/outchain/player?type=1&id={{page.music-id}}&auto=1&height=32"></iframe>
                {% endif %}



* 在对应的更新上面配置网易music ID就行，这篇blog的歌曲是冰冰推荐的《成都》，现在貌似很火，也是蛮好听的。


				---
				layout:     post
				title:      "用Jekyll在博客页面中添加网易云音乐播放"
				subtitle:   "在博客中添加音乐播放和今天才到的一些前段的坑~"
				date:       2017-02-17
				author:     "Supremeliu"
				header-img: "img/ie_sifhay7o-john-cobb.jpg"
				music-id: 34930257
				tags:
				    - 实用教程
				    - Jekyll
				---
           

* 调整好以后就可以重新运行jekyll build   和 jekyll serve,测试好完成上传github，具体步骤可以参考 2017-02-16 的jekyll 部署。




	
	
<p id="build2"></p>


---

## 问题小结

今天工作比较空闲，我上午添加了my blog对于流媒体的布局，下午在开发一个老项目，碰到不少坑啊，我也刚刚学习前端，所以碰到很多问题都是很奇怪。


* 下午的时候想给老的页面加一个运用bootstrap的弹出框，但是试了半天都是javascript报错，自己查了好久，最后看了下jquery，问题是因为老的页面jquery的1.2.*版本不支持应用对应函数 ，最后换成传统的事件函数写法即可，浪费了我不少时间。








>*-----周末愉快！*





