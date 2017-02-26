---
layout:     post
title:      "java-web跨域请求解决方案-httpclient"
subtitle:   "java web功能实现笔记"
date:       2017-02-26
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
    - 实用教程
    - java
    - web
---



>* *最近一直在学习前段的一些基本前端编程技巧，对于http请求资源的解决方法比较普遍的两种，一种是JSONP，还有另外一种就是今天要介绍的httpclient工具，httpclient是apach基金协会的一个顶级的开源项目*


---


###  1、httpclient工具发送请求（get/post）

*  在maven中添加httpclient所用的到的对应工具包：

		<dependency>
	  		<groupId>org.apache.httpcomponents</groupId>
	  		<artifactId>httpclient</artifactId>
	  		<version>4.3.5</version>
	  	</dependency>
	
		
*  httpclient发送get请求：

		package cn.itcast.httpclient;
		
		import java.net.URI;
		
		import org.apache.http.client.methods.CloseableHttpResponse;
		import org.apache.http.client.methods.HttpGet;
		import org.apache.http.client.utils.URIBuilder;
		import org.apache.http.impl.client.CloseableHttpClient;
		import org.apache.http.impl.client.HttpClients;
		import org.apache.http.util.EntityUtils;
		
		public class DoGETParam {
		
		    public static void main(String[] args) throws Exception {
		
		        // 创建Httpclient对象
		        CloseableHttpClient httpclient = HttpClients.createDefault();
		
		        // 定义请求的参数
		        URI uri = new URIBuilder("http://www.baidu.com/s").setParameter("wd", "java").build();
		
		        System.out.println(uri);
		
		        // 创建http GET请求
		        HttpGet httpGet = new HttpGet(uri);
		
		        CloseableHttpResponse response = null;
		        try {
		            // 执行请求
		            response = httpclient.execute(httpGet);
		            // 判断返回状态是否为200
		            if (response.getStatusLine().getStatusCode() == 200) {
		                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
		                System.out.println(content);
		            }
		        } finally {
		            if (response != null) {
		                response.close();
		            }
		            httpclient.close();
		        }
		
		    }
		
		}

* httpclient发送post请求：

		package cn.itcast.httpclient;
		import java.util.ArrayList;
		import java.util.List;
		
		import org.apache.http.NameValuePair;
		import org.apache.http.client.entity.UrlEncodedFormEntity;
		import org.apache.http.client.methods.CloseableHttpResponse;
		import org.apache.http.client.methods.HttpPost;
		import org.apache.http.impl.client.CloseableHttpClient;
		import org.apache.http.impl.client.HttpClients;
		import org.apache.http.message.BasicNameValuePair;
		import org.apache.http.util.EntityUtils;
		
		public class DoPOSTParam {
		public static void main(String[] args) throws Exception {
		        // 创建Httpclient对象
		        CloseableHttpClient httpclient = HttpClients.createDefault();
		        // 创建http POST请求
		        HttpPost httpPost = new HttpPost("http://www.oschina.net/search");
		        // 设置2个post参数，一个是scope、一个是q
		        List<NameValuePair> parameters = new ArrayList<NameValuePair>(0);
		        parameters.add(new BasicNameValuePair("scope", "project"));
		        parameters.add(new BasicNameValuePair("q", "java"));
		        // 构造一个form表单式的实体
		        UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(parameters);
		        // 将请求实体设置到httpPost对象中
		        httpPost.setEntity(formEntity);
		        CloseableHttpResponse response = null;
		        try {
		            // 执行请求
		            response = httpclient.execute(httpPost);
		            // 判断返回状态是否为200
		            if (response.getStatusLine().getStatusCode() == 200) {
		                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
		                System.out.println(content);
		            }
		        } finally {
		            if (response != null) {
		                response.close();
		            }
		            httpclient.close();
		        }
		
		    }
		
		}
		
* 建立httpclient的连接池

	public class HttpConnectManager {
	
	    public static void main(String[] args) throws Exception {
	        PoolingHttpClientConnectionManager cm = new PoolingHttpClientConnectionManager();
	        // 设置最大连接数
	        cm.setMaxTotal(200);
	        // 设置每个主机地址的并发数
	        cm.setDefaultMaxPerRoute(20);
	        doGet(cm);
	        doGet(cm);
	    }
	
	    public static void doGet(HttpClientConnectionManager cm) throws Exception {
	        //从连接池中哪一个对应的连接
	        CloseableHttpClient httpClient = HttpClients.custom().setConnectionManager(cm).build();
	        // 创建http GET请求
	        HttpGet httpGet = new HttpGet("http://www.baidu.com/");
	
	        CloseableHttpResponse response = null;
	        try {
	            // 执行请求
	            response = httpClient.execute(httpGet);
	            // 判断返回状态是否为200
	            if (response.getStatusLine().getStatusCode() == 200) {
	                String content = EntityUtils.toString(response.getEntity(), "UTF-8");
	                System.out.println("内容长度：" + content.length());
	            }
	        } finally {
	            if (response != null) {
	                response.close();
	            }
	            // 此处不能关闭httpClient，如果关闭httpClient，连接池也会销毁
	            // httpClient.close();
	        }
	    }
		}
	
	
* 建立一个自动校验的类型
		
		package cn.itcast.httpclient;
		
		import org.apache.http.conn.HttpClientConnectionManager;
		import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
		
		/**
		 * 单独请求对应的方法来关闭对应的请求连接
		 *
		 *
		 */
		public class ClientEvictExpiredConnections {
		
		    public static void main(String[] args) throws Exception {
		        PoolingHttpClientConnectionManager cm = new PoolingHttpClientConnectionManager();
		        // 设置最大连接数
		        cm.setMaxTotal(200);
		        // 设置每个主机地址的并发数
		        cm.setDefaultMaxPerRoute(20);
		
		        new IdleConnectionEvictor(cm).start();
		    }
		
		    public static class IdleConnectionEvictor extends Thread {
		
		        private final HttpClientConnectionManager connMgr;
		
		        private volatile boolean shutdown;
		
		        public IdleConnectionEvictor(HttpClientConnectionManager connMgr) {
		            this.connMgr = connMgr;
		        }
		
		        @Override
		        public void run() {
		            try {
		                while (!shutdown) {
		                    synchronized (this) {
		                        wait(5000);
		                        // 关闭失效的连接
		                        connMgr.closeExpiredConnections();
		                    }
		                }
		            } catch (InterruptedException ex) {
		                // 结束
		            }
		        }
		
		        public void shutdown() {
		            shutdown = true;
		            synchronized (this) {
		                notifyAll();
		            }
		        }
	    }
		}


### 工具包整合httpclient



	


