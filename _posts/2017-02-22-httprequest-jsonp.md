---
layout:     post
title:      "http请求跨域请求资源-JSONP原理解析"
subtitle:   "java web功能实现笔记"
date:       2017-02-23
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
	 - 原理解析
    - java
    - web
---



>* *最近一直在学习前段的一些基本变成技巧，对于http请求资源的解决方法比较普遍的两种一种就是今天分享的JSONP，还有另外一种就是通过服务器端httpclient工具包进行请求获取资源（明天的内容有了~）*


---


###  1、用js加载的方式来解决不能跨域请求资源

*  准备一个简单的jsp文件：

		<%@page language="java" contentType="text/html; charset=UTF-8"
		          pageEncoding="UTF-8"%>
		
		<%
		    out.print("{\"abc\":123}");
		%>
	返回为json字符串：

		{
		    "abc": 123
		}
		
*  新建一个html文件：

	 testforjsonp.htm:
		
		<!DOCTYPE html>
		<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <title>test</title>
		    <script type="text/javascript" src="/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		</head>
		
		
		<body>
		<script>
		    alert($)  ;
		    $.ajax({
		        type : "POST"  ,
		        dataType :  "json"   ,
		        url : "http://localhost:8081/json.jsp",
		        success :  function(data){
		            alert(data.abc )  ;  //能够正常返回json字符串
		        }
		
		    })
		</script>
		</body>
		</html>

* 浏览 本地地址 http://localhost:8081/testforjsonp.htm 资源都能被访问到（同域当然能够访问）


	![](https://cl.ly/01303s050J2S/Image%202017-02-24%20at%2001.04.36.png)
	![](https://cl.ly/3F3k1d3A3r0l/Image%202017-02-24%20at%2001.12.56.png)

* 把testforjsonp.htm中加载js的地址改下，放到另外的一个服务容器上面

	修改js用http地址来获取js：
	
		 <script type="text/javascript" src="http://localhost:8081/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		 
		 
		 
	结果JavaScript的js资源能够正常加载，但是htm因为跨域原因浏览器报错，如下：
	
	![](https://cl.ly/3B0y331d3x3s/Image%202017-02-24%20at%2001.23.25.png)
	
* 把对应的ajax请求放在script请求资源的标签中

		<!DOCTYPE html>
		<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <title>test</title>
		    <script type="text/javascript" src="http://localhost:8081/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		</head>
		
		
		<body>
		<script>
		    alert($)  ;
		</script>
		<script type="text/javascript" src="http://localhost:8081/json.jsp"></script>
		</body>
		</html>
		
	结果js加载资源能够正常的解析但由于json.jsp不是js的文本所欲报错
	
	![](https://cl.ly/3o2k313s0S44/Image%202017-02-24%20at%2001.32.42.png)
	
* 把对应的json.jsp包装成js的结构

		<%@page language="java" contentType="text/html; charset=UTF-8"
		          pageEncoding="UTF-8"%>
		
		<%
		    out.print("fun({\"abc\":123})");
		%>
		
	在对应的testforjsonp.htm中定义对应的function方法fun:
	
		<!DOCTYPE html>
		<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <title>test</title>
		    <script type="text/javascript" src="http://localhost:8081/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		</head>
		
		
		<body>
		<script>
		    alert($)  
		    function fun(data) {
		        alert(data.abc)
		    }
		</script>
		<script type="text/javascript" src="http://localhost:8081/json.jsp"></script>
		</body>
		</html>
		
	能够正常访问这个就是jsonp的原理！
	![](https://cl.ly/1z1Z0u3b3X36/Image%202017-02-24%20at%2001.41.21.png)
	
* 用call来传递回调函数，实现跨域访问

	将json.jsp改写：
	
		<%@page language="java" contentType="text/html; charset=UTF-8"
		          pageEncoding="UTF-8"%>
		
		<%
		    String callback= request.getParameter("callback");
		    if (callback ==null|| "".equals(callback)){
		        out.print("{\"abc\":123}");
		    }
		    else {
		        out.print(callback+"({\"abc\":123})");
		    }
		%>

	testforjsonp.htm修改请求加入callback的参数：
	
			<!DOCTYPE html>
		<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <title>test</title>
		    <script type="text/javascript" src="http://localhost:8081/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		</head>
		
		
		<body>
		<script>
		    alert($)
		    function fun(data) {
		        alert(data.abc)
		    }
		</script>
		<script type="text/javascript" src="http://localhost:8081/json.jsp?callback=fun"></script>
		</body>
		</html>

	
	![](https://cl.ly/1z1Z0u3b3X36/Image%202017-02-24%20at%2001.41.21.png)
	
* 在实际应用中使用JSONP

	很简单只需在用ajax提供请求把参数dataType改为jsonp即可
	
	testforjsonp.htm:
	
		<!DOCTYPE html>
		<html lang="en">
		<head>
		    <meta charset="UTF-8">
		    <title>test</title>
		    <script type="text/javascript" src="http://localhost:8081/js/jquery-easyui-1.4.1/jquery.min.js" ></script>
		</head>
		
		
		<body>
		<script>
		    alert($)  ;//前面的jquery加载正常
		    $.ajax({
		        type : "POST"  ,
		        dataType :  "jsonp"   ,
		        url : "http://localhost:8081/json.jsp",
		        success :  function(data){
		            alert(data.abc)  ;  //能够正常返回json字符串
		        }
		
		    })
		</script>
		</body>
		</html>
	
	![](https://cl.ly/1m313K0W3s3w/Image%202017-02-24%20at%2002.00.49.png)




