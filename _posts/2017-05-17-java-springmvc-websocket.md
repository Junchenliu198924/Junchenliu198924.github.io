---
layout:     post
title:      "记一个springmvc整合websocket的例子"
subtitle:   "java-web项目问题(6)"
date:       2017-05-17
author:     "Supremeliu"
header-img: "img/2017-03-06.jpg"
tags:
    - spring
    - java
    - web
    - js
---



>* *好久没有更新自己的技术blog了，自己的项目碰到了瓶颈，自己这段时间也有点迷失，自己也在尽量的调整，自己的路该怎么走老实说以后的路我现在都没有的想好。感觉自己还是喜欢编程。自己总结了这段时间非常低效的症结究竟在哪儿，我想原因还是因为自己没有明确目标。*
>
>* *我觉得每天写点东西是非常的有意义的，至少回顾下自己做了些什么东西，所以今天开始我尽量也会让自己每天都写点东西记录下自己。希望自己能够逐步改善。现在自己的工作比较杂技术含量不是很高，但是自己还是觉得应该把它做好，但是自己有时还是觉得有点懈怠有点提不起劲的感觉，希望这种情绪明天起不要再有了，我希望自己能够踏实一步一步的向前进，我相信自己一定可以的。*
>
>* *这几天自己一直想把服务器上面的日志能够实时在web的页面输出，所以咨询了些做开发的朋友，朋友建议如果实时性要求比较高的可以用的 websocket ，马上上网查了下这个东西，类似于长连接，基于tcp协议，我自己理解websocket好处就是一旦建立了连接客户端服务器端不管哪一端都可以主动的推送信息给一方，和http一问一答的方式还是有它的优势后面几天我会把从服务器端读取的信息用websocket在页面实时的输出，下面是网上抄的一个列子（非常感谢作者分享），因为自己的项目运用的springmvc的架构这个列子正是整合了springmvc 的架构来做websocket的后台的处理*


---

### 目录

>*  1、[加入websocket整合springmvc所用到的maven依赖](#build1)
>*  2、[整合插件到项目中去](#build2)
>*  3、[前端页面代码运行效果](#build3)


<p id="build1"></p>


###  1、所用到的maven包

* 下面列出了websocket整合websocket所用到的依赖包

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-websocket</artifactId>
            <version>4.1.4.RELEASE</version>
        </dependency>


        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-messaging</artifactId>
            <version>4.3.8.RELEASE</version>
        </dependency>
        
        
<p id="build2"></p>

### 2、整合插件到项目中去

* springmvc服务器端每次握手前后触发事件类（tcp连接握手前后各在控制台输出一条信息）：

		package com.bocim.maintaince.websocketTest;
		
		/**
		 * Created by liujunchen on 2017/5/16.
		 */
		
		import java.util.Map;
		
		import org.springframework.http.server.ServerHttpRequest;
		import org.springframework.http.server.ServerHttpResponse;
		import org.springframework.web.socket.WebSocketHandler;
		import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;
		
		public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor{
		    @Override
		    public boolean beforeHandshake(ServerHttpRequest request,
		                                   ServerHttpResponse response, WebSocketHandler wsHandler,
		                                   Map<String, Object> attributes) throws Exception {
		        System.out.println("Before Handshake");
		        return super.beforeHandshake(request, response, wsHandler, attributes);
		    }
		    @Override
		    public void afterHandshake(ServerHttpRequest request,
		                               ServerHttpResponse response, WebSocketHandler wsHandler,
		                               Exception ex) {
		        System.out.println("After Handshake");
		        super.afterHandshake(request, response, wsHandler, ex);
		    }
		
		}


* 声明的对应的websocket请求处理类：

		package com.bocim.maintaince.websocketTest;
		/**
		 * Created by liujunchen on 2017/5/16.
		 */
		import org.springframework.web.socket.TextMessage;
		import org.springframework.web.socket.WebSocketSession;
		import org.springframework.web.socket.handler.TextWebSocketHandler;
		public class WebsocketEndPoint extends TextWebSocketHandler {
		    @Override
		    protected void handleTextMessage(WebSocketSession session,
		                                     TextMessage message) throws Exception {
		        super.handleTextMessage(session, message);
		        //编辑发送的内容
		        TextMessage returnMessage = new TextMessage(message.getPayload()+" received at server");
		        session.sendMessage(returnMessage);
		    }
		}

	![]()

*  配置一个springApplication配置文件用来的初始化处理bean，以及映射对应的处理地址
*  这边mapper进入springmvc后地址为 /websocket(并且加入过滤类为上面声明的HandshakeInterceptor过滤类)

		<beans xmlns="http://www.springframework.org/schema/beans"
		       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		       xmlns:websocket="http://www.springframework.org/schema/websocket"
		       xsi:schemaLocation="
		        http://www.springframework.org/schema/beans
		        http://www.springframework.org/schema/beans/spring-beans.xsd
		        http://www.springframework.org/schema/websocket
		        http://www.springframework.org/schema/websocket/spring-websocket.xsd">
		
		    <bean id="websocket" class="com.bocim.maintaince.websocketTest.WebsocketEndPoint"/>
		    <websocket:handlers>
		        <websocket:mapping path="/websocket" handler="websocket"/>
		        <websocket:handshake-interceptors>
		            <bean class="com.bocim.maintaince.websocketTest.HandshakeInterceptor"/>
		        </websocket:handshake-interceptors>
		    </websocket:handlers>
		</beans>
	
* 服务器端springmvc的websocket已经配置完成，接下来就是前端jsp页面

* 页面中核心发起websocket连接有两种一种是用传统的websocket连接，还有是用sockJS（一种封装了websocket更加上层的传输协议）关键代码如下：

		 ws = (url.indexOf('sockjs') != -1) ?
		                new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

* webSocketTest.jsp代码如下：

		<!DOCTYPE html>
		<html>
		<head>
		    <title>WebSocket/SockJS Echo Sample (Adapted from Tomcat's echo sample)</title>
		    <style type="text/css">
		        #connect-container {
		            float: left;
		            width: 400px
		        }
		
		        #connect-container div {
		            padding: 5px;
		        }
		
		        #console-container {
		            float: left;
		            margin-left: 15px;
		            width: 400px;
		        }
		
		        #console {
		            border: 1px solid #CCCCCC;
		            border-right-color: #999999;
		            border-bottom-color: #999999;
		            height: 170px;
		            overflow-y: scroll;
		            padding: 5px;
		            width: 100%;
		        }
		
		        #console p {
		            padding: 0;
		            margin: 0;
		        }
		    </style>
		
		    <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>
		
		    <script type="text/javascript">
		        var ws = null;
		        var url = null;
		        var transports = [];
		
		        function setConnected(connected) {
		            document.getElementById('connect').disabled = connected;
		            document.getElementById('disconnect').disabled = !connected;
		            document.getElementById('echo').disabled = !connected;
		        }
		
		        function connect() {
		            alert("url:"+url);
		            if (!url) {
		                alert('Select whether to use W3C WebSocket or SockJS');
		                return;
		            }
		
		            ws = (url.indexOf('sockjs') != -1) ?
		                new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);
		
		            ws.onopen = function () {
		                setConnected(true);
		                log('Info: connection opened.');
		            };
		            ws.onmessage = function (event) {
		                log('Received: ' + event.data);
		            };
		            ws.onclose = function (event) {
		                setConnected(false);
		                log('Info: connection closed.');
		                log(event);
		            };
		        }
		
		        function disconnect() {
		            if (ws != null) {
		                ws.close();
		                ws = null;
		            }
		            setConnected(false);
		        }
		
		        function echo() {
		            if (ws != null) {
		                var message = document.getElementById('message').value;
		                log('Sent: ' + message);
		                ws.send(message);
		            } else {
		                alert('connection not established, please connect.');
		            }
		        }
		
		        function updateUrl(urlPath) {
		            if (urlPath.indexOf('sockjs') != -1) {
		                url = urlPath;
		                document.getElementById('sockJsTransportSelect').style.visibility = 'visible';
		            }
		            else {
		                if (window.location.protocol == 'http:') {
		                    url = 'ws://' + window.location.host + urlPath;
		                } else {
		                    url = 'wss://' + window.location.host + urlPath;
		                }
		                document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';
		            }
		        }
		
		        function updateTransport(transport) {
		            alert(transport);
		            transports = (transport == 'all') ?  [] : [transport];
		        }
		
		        function log(message) {
		            var console = document.getElementById('console');
		            var p = document.createElement('p');
		            p.style.wordWrap = 'break-word';
		            p.appendChild(document.createTextNode(message));
		            console.appendChild(p);
		            while (console.childNodes.length > 25) {
		                console.removeChild(console.firstChild);
		            }
		            console.scrollTop = console.scrollHeight;
		        }
		    </script>
		</head>
		<body>
		<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets
		    rely on Javascript being enabled. Please enable
		    Javascript and reload this page!</h2></noscript>
		<div>
		    <div id="connect-container">
		        <input id="radio1" type="radio" name="group1" onclick="updateUrl('/service/websocket');">
		        <label for="radio1">W3C WebSocket</label>
		        <br>
		        <input id="radio2" type="radio" name="group1" onclick="updateUrl('/service/websocket');">
		        <label for="radio2">SockJS</label>
		        <div id="sockJsTransportSelect" style="visibility:hidden;">
		            <span>SockJS transport:</span>
		            <select onchange="updateTransport(this.value)">
		                <option value="all">all</option>
		                <option value="websocket">websocket</option>
		                <option value="xhr-polling">xhr-polling</option>
		                <option value="jsonp-polling">jsonp-polling</option>
		                <option value="xhr-streaming">xhr-streaming</option>
		                <option value="iframe-eventsource">iframe-eventsource</option>
		                <option value="iframe-htmlfile">iframe-htmlfile</option>
		            </select>
		        </div>
		        <div>
		            <button id="connect" onclick="connect();">Connect</button>
		            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
		        </div>
		        <div>
		            <textarea id="message" style="width: 350px">Here is a message!</textarea>
		        </div>
		        <div>
		            <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
		        </div>
		    </div>
		    <div id="console-container">
		        <div id="console"></div>
		    </div>
		</div>
		</body>
		</html>
	
	
<p id="build3"></p>

### 3、代码运行效果


* websocket 方式和 socketjs  方式  选择连接输出：

![](http://i1.piimg.com/588926/11dfc7e701ace24a.png)


![](http://i4.buimg.com/588926/13b33d3c5df85d23.png)
					
	
* 毫无疑问websocket的连接模式实时性更加好，当需求需要一些实时响应的时候我觉得应该采用这种连接方式来完成，接下来我会尝试用socket的连接的方式来完成日志实时输出到web客户端。








