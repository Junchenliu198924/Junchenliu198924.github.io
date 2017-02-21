---
layout:     post
title:      "用KindEditor套件实现文件上传功能"
subtitle:   "java web功能实现笔记"
date:       2017-02-21
author:     "Supremeliu"
header-img: "img/ie_sifhay7o-john-cobb.jpg"
tags:
    - 实用教程
    - java
---



>* *本文记录使用KindEditor的web组件实现界面的头像文件上传服务器中，项目基本架构为 spring-mvc  +   spring  +   mybatis加上maven作为项目管理*


---



* ### 在项目工程中导入对应依赖上传工具包
>我这边使用的[阿里的maven远程中央库](http://maven.aliyun.com/nexus/#welcome) 

        <!--上传组件依赖-->
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>1.3.1</version>
        </dependency>  


* ### 在spring配置文件中注入对应的文件上传解析器

	    <!--文件上传解析器-->
	    <bean id="multipartResolver"
		class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
			        <!--最大上传文件大小为5MB-->
			        <property name="maxUploadSize" value="5242880"/>
		</bean>



* ### 创建bean Class PicUploadResult

		public class PicUploadResult {
		    private Integer error;
		    private String url;
		    private String width;
		    private String height;
		    public Integer getError() {
		        return error;
		    }
		    public void setError(Integer error) {
		        this.error = error;
		    }
		    public String getUrl() {
		        return url;
		    }
		    public void setUrl(String url) {
		        this.url = url;
		    }
		    public String getWidth() {
		        return width;
		    }
		    public void setWidth(String width) {
		        this.width = width;
		    }
		    public String getHeight() {
		        return height;
		    }
		    public void setHeight(String height) {
		        this.height = height;
		    }
		}


* ### 创建资源文件  imag_url.properties

		REPOSITORY_PATH=/Users/liujunchen/Developer/JavaProject/liujipuzi/ljpz-upload
		IMAGE_BASE_URL=http://localhost:8080
		LJPZ_WEB_URL=http://localhost:8082



* ### 创建controller Class  PicUploadController
		package com.ljpz.web.controller;
		
		import com.fasterxml.jackson.databind.ObjectMapper;
		import com.ljpz.common.bean.PicUploadResult;
		import com.ljpz.web.service.PropertieService;
		import org.apache.commons.lang3.RandomUtils;
		import org.apache.commons.lang3.StringUtils;
		import org.joda.time.DateTime;
		import org.slf4j.Logger;
		import org.slf4j.LoggerFactory;
		import org.springframework.beans.factory.annotation.Autowired;
		import org.springframework.http.MediaType;
		import org.springframework.stereotype.Controller;
		import org.springframework.web.bind.annotation.RequestMapping;
		import org.springframework.web.bind.annotation.RequestMethod;
		import org.springframework.web.bind.annotation.RequestParam;
		import org.springframework.web.bind.annotation.ResponseBody;
		import org.springframework.web.multipart.MultipartFile;
		import javax.imageio.ImageIO;
		import javax.servlet.http.HttpServletResponse;
		import java.awt.image.BufferedImage;
		import java.io.File;
		import java.io.IOException;
		import java.util.Date;
		
		/**
		 * 图片上传
		 */
		@Controller
		@RequestMapping("pic")
		public class PicUploadController {
		    @Autowired
		    private PropertieService propertieService  ;
		
		    private static final Logger LOGGER = LoggerFactory.getLogger(PicUploadController.class);
		
		    private static final ObjectMapper mapper = new ObjectMapper();
		
		    // 允许上传的格式
		    private static final String[] IMAGE_TYPE = new String[] { ".bmp", ".jpg", ".jpeg", ".gif", ".png",".JPG" };
		
		    /**
		     * 制定相应的类型
		     * @param uploadFile
		     * @param response
		     * @return
		     * @throws Exception
		     */
		    @RequestMapping(value = "/upload", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
		    @ResponseBody
		    public String  upload (@RequestParam("uploadFile") MultipartFile uploadFile , HttpServletResponse response) throws Exception {
		
		        // 校验图片格式
		        boolean isLegal = false;
		        for (String type : IMAGE_TYPE) {
		            if (StringUtils.endsWithIgnoreCase(uploadFile.getOriginalFilename(), type)) {
		                isLegal = true;
		                break;
		            }
		        }
		
		        // 封装Result对象，并且将文件的byte数组放置到result对象中
		        PicUploadResult fileUploadResult = new PicUploadResult();
		
		        // 状态
		        fileUploadResult.setError(isLegal ? 0 : 1);
		
		        // 文件新路径
		        String filePath = getFilePath(uploadFile.getOriginalFilename());
		
		        if (LOGGER.isDebugEnabled()) {
		            LOGGER.debug("Pic file upload .[{}] to [{}] .", uploadFile.getOriginalFilename(), filePath);
		        }
		
		        // 生成图片的绝对引用地址
		        String picUrl = StringUtils.replace(StringUtils.substringAfter(filePath, propertieService.REPOSITORY_PATH), "\\", "/");
		        fileUploadResult.setUrl(propertieService.IMAGE_BASE_URL + picUrl);
		
		        File newFile = new File(filePath);
		
		        // 写文件到磁盘
		        uploadFile.transferTo(newFile);
		
		        // 校验图片是否合法
		        isLegal = false;
		        try {
		            BufferedImage image = ImageIO.read(newFile);
		            if (image != null) {
		                fileUploadResult.setWidth(image.getWidth() + "");
		                fileUploadResult.setHeight(image.getHeight() + "");
		                isLegal = true;
		            }
		        } catch (IOException e) {
		        }
		
		        // 状态
		        fileUploadResult.setError(isLegal ? 0 : 1);
		
		        if (!isLegal) {
		            // 不合法，将磁盘上的文件删除
		            newFile.delete();
		        }
		
		        //将java对象序列化成Json字符串
		        return mapper.writeValueAsString(fileUploadResult);
		    }
		
		    private String getFilePath(String sourceFileName) {
		        String baseFolder = "/Users/liujunchen/Developer/JavaProject/liujipuzi/ljpz-upload" + File.separator + "images";
		        Date nowDate = new Date();
		        // yyyy/MM/dd
		        String fileFolder = baseFolder + File.separator + new DateTime(nowDate).toString("yyyy") + File.separator + new DateTime(nowDate).toString("MM") + File.separator
		                + new DateTime(nowDate).toString("dd");
		        File file = new File(fileFolder);
		        if (!file.isDirectory()) {
		            // 如果目录不存在，则创建目录
		            file.mkdirs();
		        }
		        // 生成新的文件名
		        String fileName = new DateTime(nowDate).toString("yyyyMMddhhmmssSSSS") + RandomUtils.nextInt(100, 9999) + "." + StringUtils.substringAfterLast(sourceFileName, ".");
		        return fileFolder + File.separator + fileName;
		    }
		
		}
		
		
		
		
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
	    
   
   
   
   
* ### 前端进行展示效果（未完待补）





