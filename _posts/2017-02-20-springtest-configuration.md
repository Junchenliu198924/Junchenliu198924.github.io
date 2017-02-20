---
layout:     post
title:      "用junit测试单个服务调用"
subtitle:   "测试所用到的工具包导入，以及操作步骤"
date:       2017-02-20
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
    - 实用教程
    - java
---



>* *spring测试很费劲需要初始化bean才能进行测试， 这边介绍spring-test 配合junit来完成对应service的接口测试*


---

### 测试环境搭建过程

* 我本机环境是2014年 retina mac pro,编程工具为idea，项目中用的是maven，所以下面的介绍是基于maven的。


* 在maven中添加对应spring 的测试的依赖包
	
	    <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
        </dependency>

			 <dependency>
		            <groupId>org.springframework</groupId>
		            <artifactId>spring-test</artifactId>
		            <version>4.1.3.RELEASE</version>
		        </dependency>


* 找到测试类添加如下的注解注入bean

				@RunWith(SpringJUnit4ClassRunner.class)
				//加载配置文件
				@ContextConfiguration
				        ({"/spring/applicationContext.xml","/spring/applicationContext-mybatis.xml"})


	
* 在test的类里注射spring bean测试程序如下：

		
		@RunWith(SpringJUnit4ClassRunner.class)
		//加载配置文件
		@ContextConfiguration
		        ({"/spring/applicationContext.xml","/spring/applicationContext-mybatis.xml"})
		public class UserinfoServiceTest {
		    private   static  final ObjectMapper   MAPPER = new ObjectMapper()   ;
		    private   String  tojson   ;
		    @Resource
		    private   UserinfoService  userinfoService ;
		
		    @Before
		    public void setTojson() throws Exception {
		        //准备一条测试数据
		        this.tojson= MAPPER.writeValueAsString(
		                new Userinfo( new Long(109),"junchen-test222",  "1",  new Date(),
		                        "刘俊辰",  "大海", null, "1", "100000000", "310107", "本科", "计算机test"));
		    }
		    @Test
		    public void createUserinfo() throws Exception {
		        userinfoService.createUserinfo(tojson)  ;
		
		    }
		
		    @Test
		    public void updateUserinfo() throws Exception {
		
		         userinfoService.updateUserinfo(tojson);
		    }
		
		    @Test
		    public void queryByNickname() throws Exception {
		
		       /* 传统办法
		        ApplicationContext applicationContext = new ClassPathXmlApplicationContext(
		                "spring/applicationContext.xml","spring/applicationContext-mybatis.xml");
		        UserinfoService  userinfoService=
		                applicationContext.getBean("userinfoService",UserinfoService.class)  ;*/
		
		        Userinfo userinfo   =  userinfoService.queryByNickname(new Long(9));
		        System.out.println(userinfo.toString());
	
	    }
    
    
* 运行你想运行test的程序就行。

	![](https://cl.ly/2A3d0T1u2q1h/Image%202017-02-21%20at%2001.13.34.png)






