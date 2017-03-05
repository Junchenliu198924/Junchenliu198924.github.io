---
layout:     post
title:      "java-web项目问题小计(1)"
subtitle:   "java web功能实现笔记"
date:       2017-03-05
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
    - spring
    - java
    - web
---



>* *最近自己在做一个自己的一个项目的，今天基本把框架给打好了，因为是javaweb的应用所以我采用了主流的框架 springMVC + spring + mybatis的主流框架，今天在做的过程中碰到了不少问题，这边做下今天的总结*


---
#### 导航
>* 1、[关于spring-mvc 配置文件资源加载问题解决]()

>* 2、[jsp服务器端el和客户端js变量传递方法](#build2)
>* 3、[httpclient整合spring mvc框架](#build3)
>* 4、[封装对应的api service](#build4)


###  1、关于spring-mvc 配置文件资源加载问题解决

*  在项目中想要运用对应的@value注解来获取env.properties中的值：

		@Controller
		@RequestMapping("page")
		public class PageController {
		    @Value("${itmaintaince_SSO_URL}")
		    public   String  itmaintaintaince_SSO_UTL;
		    @RequestMapping(value = "{pagename}" , method = RequestMethod.GET)
		    public String topage(@PathVariable("pagename")String pagename, HttpServletResponse response) throws IOException {
		        String loginurl= itmaintaintaince_SSO_UTL+"/public/login.html" ;
		        if (pagename.equals("login")){
		            //转到对应的登录页面
		            response.sendRedirect(loginurl);
		            return null   ;
		        }
		
		        return  pagename  ;
		    }
		}
	
		
*  调试的过程发现没有取到itmaintaince_SSO_URL的值，但是在spring的启动文件里面已经配置了：

		 <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
		        <!-- 允许JVM参数覆盖 -->
		        <!-- java -Djdbc.url=123 -jar xxx.jar -->
		        <property name="systemPropertiesModeName" value="SYSTEM_PROPERTIES_MODE_OVERRIDE" />
		        <!-- 忽略没有找到的资源文件 -->
		        <property name="ignoreResourceNotFound" value="true" />
		        <!-- 配置资源文件 -->
		        <property name="locations">
		            <list>
		                <value>classpath:log4j.properties</value>
		                <value>classpath:jdbc.properties</value>
		                <value>classpath:env.properties</value>
		            </list>
		        </property>
		    </bean>		
		
		
* 查资料后，解决方案为在spring-mvc的启动配置文件里面再加载相同的配置文件即可调用该资源，不能加载的原因也和spring的父子容器有关，具体结论如下：

>* 1、spring容器初始化（所有的bean）之后，在当前的所在的容器中获取值，然后注入。
>* 2、spring容器与spring-mvc的为父子容器，子容器能够访问父容器的资源（bean）示例：controller可以注入service
>* 3、父容器不能访问子容器的资源（bean）




<p id="build2"></p>

### 2、记一次jsp服务器端el和客户端js变量传递方法

* 对应的js文件

		<script>
		    $(function () {
		        var aaa=new Array();
		        //这边循环的把对应el表达式中的值加入到客户端js申明的变量数组中去
		        <c:forEach items="${privelige}" var="mm">
		            aaa.push("${mm}");
		        </c:forEach>;
		
		//            var bb = aaa
		            MT.checkShow(aaa) ;
		    })
		</script>




