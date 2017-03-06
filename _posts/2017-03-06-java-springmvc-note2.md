---
layout:     post
title:      "java-web项目问题小结(2)"
subtitle:   "java web功能实现笔记"
date:       2017-03-06
author:     "Supremeliu"
header-img: "img/2017-03-06.jpg"
tags:
    - spring
    - java
    - web
---



>* *今天在研究mybatis的数据映射文件mapper的写法，发现mybatis的映射非常的完善，也不是很难懂，因为可以自己写sql绑定自由度是非常高的，今天主要学习了下select的绑定。*


---
###  1、mybatis查询绑定内嵌对象注意要点

*  spring中mybatis的配置文件：

		<beans xmlns="http://www.springframework.org/schema/beans"
		       xmlns:context="http://www.springframework.org/schema/context" xmlns:p="http://www.springframework.org/schema/p"
		       xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
		       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
			http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
			http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.0.xsd
			http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util-4.0.xsd">
		
		    <bean class="org.mybatis.spring.SqlSessionFactoryBean">
		        <!-- 数据源 -->
		        <property name="dataSource" ref="dataSource"/>
		        <!-- 配置Mybatis的全局配置文件 -->
		        <property name="configLocation" value="classpath:mybatis/mybatis-config.xml"/>
		        <!-- 配置mapper.xml文件 -->
		         <property name="mapperLocations" value="classpath:mybatis/mapper/*.xml"/>
		        <!-- 别名包 -->
		        <property name="typeAliasesPackage" value="com.bocim.maintaince.pojo"/>
		    </bean>
		    <!-- mapper接口的扫描器 -->
		    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
		        <property name="basePackage" value="com.bocim.maintaince.mapper"/>
		    </bean>
		    <bean id="MUserDAO" class="com.bocim.maintaince.dao.MUserDAO"></bean>
		</beans>
	
	

		
*  创建对应的接口类后 (例如:MuserMapper)，接下来我们主要运用mapper将sql语句映射成java的对象，具体的用法请参考[spring官方文档](http://www.mybatis.org/mybatis-3/index.html),下面是我要映射的java pojo类。

		public class Muser {
		    @Id
		    @GeneratedValue(strategy = GenerationType.IDENTITY)
		    private  Long id  ;
		    private  String username    ;
		    private  String password  ;
		    private  String phone  ;
		    private  String email  ;
		    @JsonDeserialize(using = DateDeserializer.class)
		    private Date createTime;//创建时间
		    @JsonDeserialize(using = DateDeserializer.class)
		    private Date updateTime;//更新时间
		    private List<Userprivilege>   userprivileges  ;  //用户菜单权限
		    .........
* 在对应的mapper文件中绑定对应sql语句。

		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
		        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
		<mapper namespace="com.bocim.maintaince.mapper.MuserMapper">
		    <!--可以引用的sql变量模板-->
		    <!--<sql id="tableName">maintaince_user</sql>-->
		    <resultMap id="pojoResultMap2" type="Muser"  autoMapping="true">
		        <id column="id" property="id"/>
		        <result column="username" property="username"/>
		        <collection property="userprivileges"   ofType="Userprivilege" >
		            <id  property="moduleId" column="moduleid"/>
		            <result  property="moduleName"  column="modulename" />
		            <result property="moduleUser" column="moduleuser" />
		        </collection>
		    </resultMap>
	
	    <select id="queryUserPrivilegeByUsername" resultMap="pojoResultMap2">
	     select   a.id as id ,
	        a.username as username ,
	        a.password   ,
	        a.phone    ,
	        a.email,
	        a.created,
	        a.updated,
	        b.module_id as   moduleid ,
	        b.user_name as    moduleuser ,
	        c.module_name as modulename
	        from maintaince_user  a  LEFT JOIN   maintaince_privilege b ON a.username=b.user_name LEFT JOIN maintaince_module c on b.module_id=c.id
	        where  a.username=#{username}
	    </select>
		</mapper>
	
	
*  小结


	在用mybatis 绑定内嵌java查询对象，要搞清楚单挑sql中字段和java对象属性之间的n 对 n 的关系，并且关联对象往往就是主键或者是具有唯一性的字段，在mapper映射关系中要用<id>来配置。这一部分的编写还是要多多参考官方文档的写法，文档的例子都很实用，务必好好阅读收藏！对于有一定sql基础的人员来说很方便，





