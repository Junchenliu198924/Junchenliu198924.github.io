---
layout:     post
title:      "java-web项目问题小结(3)"
subtitle:   "java web功能实现笔记"
date:       2017-03-07
author:     "Supremeliu"
header-img: "img/2017-03-06.jpg"
tags:
    - spring
    - java
    - web
    - js
---



>* *今天还是继续折腾项目的前段基础页面，总算把登录和功能模块完成，并且确定以后写功能模块页面的展示架构。以下是我对于今天碰到问题的解决总结。*


---

### 目录

>*  1、[用jquery局部加载登录页面]()
>*  2、[用jquery的cookie插件来实现“记住密码” 功能](#build2)
>*  3、[quartz的定时任务的学习](#build3)



###  1、用jquery局部加载登录页面

*  主要思路就是运用jquery的局部onload的这个方法函数来实现对于主页面的特定div的重新加载，具体实现实现js如下：
		
		js：
		function loadConten(url) {
		//选取主要页面div对象重新加载新的页面地址
		    $("div.page-content").load(url);
		}







<p id="build2"></p>

### 2、用jquery的cookie插件来实现“记住密码” 功能


* 在登录加载如下js内容：

		jQuery(document).ready(function() {
		    Login.init();
		    //初始化页时验证是否记住密码
		    if ($.cookie("remember") == "true") {
		       /* $("input[name='remember']").attr("checked", true);
		        $("input[name='username']").val($.cookie("userName"));
		        $("input[name='password']").val($.cookie("passWord"));*/
		        $("#remember").attr("checked", true);
		        $("#realname").val($.cookie("userName"));
		        $("#realpassword").val($.cookie("passWord"));
		    }
		});
		
* 用jquery-cookie-js插件，在正常登陆后保存密码到cookie中去，实现的方法js如下：
	
		function saveUserInfo() {
		//$("").is(':checked')    选中的对象 如果type为checkbox，就可以用  jquery的is(':checked')	
			    if ($("#remember").is(':checked') == true) {
		        var userName = $("#realname").val();
		        var passWord = $("#realpassword").val();
		        $.cookie("remember", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
		        $.cookie("userName", userName, { expires: 7 }); // 存储一个带7天期限的 cookie
		        $.cookie("passWord", passWord, { expires: 7 }); // 存储一个带7天期限的 cookie
		    }
		    else {
		        $.cookie("rmbUser", "false", { expires: -1 });
		        $.cookie("userName", '', { expires: -1 });
		        $.cookie("passWord", '', { expires: -1 });
		    }
		}



<p id="build3"></p>

### 3、quartz的定时任务学习

*	根据官方文档 如果你的项目也是用maven ，按照下面配置即可。

		 <dependency>
		        <groupId>org.quartz-scheduler</groupId>
		        <artifactId>quartz</artifactId>
		        <version>2.2.1</version>
		    </dependency>
		    <dependency>
		        <groupId>org.quartz-scheduler</groupId>
		        <artifactId>quartz-jobs</artifactId>
		        <version>2.2.1</version>
	
	
*	记一次简单的quartz任务，主要实例化过程如下：


		public class SimpleExample {
		
		  public void run() throws Exception {
		    Logger log = LoggerFactory.getLogger(SimpleExample.class);
		
		    log.info("------- Initializing ----------------------");
		
		    // First we must get a reference to a scheduler
		    SchedulerFactory sf = new StdSchedulerFactory();
		    Scheduler sched = sf.getScheduler();
		
		    log.info("------- Initialization Complete -----------");
		
		    // computer a time that is on the next round minute
		    Date runTime = evenMinuteDate(new Date());
		
		    log.info("------- Scheduling Job  -------------------");
		
		    // define the job and tie it to our HelloJob class
		    JobDetail job = newJob(HelloJob.class).withIdentity("job1", "group1").build();
		
		    // Trigger the job to run on the next round minute
		    Trigger trigger = newTrigger().withIdentity("trigger1", "group1").startAt(runTime).build();
		
		    // Tell quartz to schedule the job using our trigger
		    sched.scheduleJob(job, trigger);
		    log.info(job.getKey() + " will run at: " + runTime);
		
		    // Start up the scheduler (nothing can actually run until the
		    // scheduler has been started)
		    sched.start();
		
		    log.info("------- Started Scheduler -----------------");
		
		    // wait long enough so that the scheduler as an opportunity to
		    // run the job!
		    log.info("------- Waiting 65 seconds... -------------");
		    try {
		      // wait 65 seconds to show job
		      Thread.sleep(65L * 1000L);
		      // executing...
		    } catch (Exception e) {
		      //
		    }
		
		    // shut down the scheduler
		    log.info("------- Shutting Down ---------------------");
		    sched.shutdown(true);
		    log.info("------- Shutdown Complete -----------------");
		  }
		
		  public static void main(String[] args) throws Exception {
		
		    SimpleExample example = new SimpleExample();
		    example.run();
	  }
	
	}




	    public HelloJob() {
	    }
	
	    /**
	     * <p>
	     * Called by the <code>{@link org.quartz.Scheduler}</code> when a
	     * <code>{@link org.quartz.Trigger}</code> fires that is associated with
	     * the <code>Job</code>.
	     * </p>
	     * 
	     * @throws JobExecutionException
	     *             if there is an exception while executing the job.
	     */
	    public void execute(JobExecutionContext context)
	        throws JobExecutionException {
	
	        // Say Hello to the World and display the date/time
	        _log.info("Hello World! - " + new Date());
	    }




### 小结

	js的jquery非常的好用，在我的项目中模块都需要和这个监控挂钩





