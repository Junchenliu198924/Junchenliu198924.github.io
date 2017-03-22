---
layout:     post
title:      "表格展示控件datatable使用小结"
subtitle:   "java-web项目问题小结(5)"
date:       2017-03-22
author:     "Supremeliu"
header-img: "img/2017-03-06.jpg"
tags:
    - spring
    - java
    - web
    - js
---



>* *好久没有更新了 ，自己这10天也没有闲着因为看到市面上面的表格的控件基本用的都是easyui 的，那个界面个人不大喜欢的，自己项目用的ui模板里面使用了datatable这个jquery控件，觉得功能也很强大所以就拿来使用，非常感谢原作者。*


---

### 目录

>*  1、[datatable项目环境准备](#build1)
>*  2、[整合插件到项目中去](#build2)
>*  3、[datatable插件运用小结](#build3)



###  1、datatable项目环境准备

* 这个插件功能非常齐全，对于我这种小项目完全能够满足我的需求，[DataTables官方地址](https://datatables.net/) ,在官方的文档中当然先看Example中，然后再去找对应参数说明 这点很重要！

* 用到的插件可以官方下载：

		<link rel="stylesheet" type="text/css" href="/DataTables/datatables.css">
 
		<script type="text/javascript" charset="utf8" src="/DataTables/datatables.js"></script>


* 因为这次项目为后台cms系统 文档和例子大部分只要server-side服务器端配置即可！

	![](http://i1.piimg.com/567571/c5e8871120ecafce.png)

*  在example中找到服务器端的最基础处理表格的写法。

	![](http://i1.piimg.com/567571/186ab79a4903b417.png)
	
*  下面是表格的展示效果。

	![](http://i1.piimg.com/567571/a59175f9cc3a56cc.png)




<p id="build2"></p>

### 2、整合插件到项目中去



* 我自己选择了文档中的example-->Server-side --> Row details  的接触代码上面来编写自己的代码

* 对应的html代码 如下,这边模态弹出窗口代码省略了，如具体写法很简单 参考 bootstrap-->modal即可自定义：
					
					
		<table class="table table-striped table-bordered table-hover table-checkable order-column" id="sample_1">
		                        <thead>
		                        <tr>
		                            <th> 任务号 </th>
		                            <th> 任务名 </th>
		                            <th> 任务种类 </th>
		                            <th> 创建人 </th>
		                            <th> 创建时间 </th>
		                            <th> 操作 </th>
		                        </tr>
		                        </thead>
		 </table>


* 页面中自己加入了modal的弹出修改框，具体的js代码如下：

		<script>
				//初始化对应datatable
                $(document).ready(function() {
                  var dt=   $('#sample_1').DataTable( {
                            "processing": true,
                           "serverSide": true,
                        "ajax": {
                            "url": "/service/maintainceTask/dbtaskquery",
                            "data": function (d) {
                                d.createdBy = "${user.username}";
                                // d.custom = $('#myInput').val();
                                // etc
                            }},
                            "order": [[4, 'desc']],
                            "columns": [
                                {"data": "taskId"},
                                {"data": "taskName"},
                                {"data": "taskType"},
                                {"data": "createdBy"},
                                {"data": "created"},
                                {
                                     "class":      "details-control",
                                    "orderable": true   ,
                                    "data":null,
                                    "render": function ( data, type ) {
                                       // return '<a href="'+data+'">编辑|</a><a>查看|</a><a>删除</a>';
                                     return "<button type='button' class='btn green' data-toggle='modal' data-target='#myModal' >修改</button>" +
                                            "<button type='button' class='btn red'  data-toggle='modal' data-target='#myDeleteModal'  >删除</button>"  +
                                            "<button type='button' class='btn green' >查看</button>"
                                    }
                                }
                            ]
                    }
                     );
                    // Array to track the ids of the details displayed rows
                    var detailRows = [];
                    $('#sample_1 tbody').on( 'click', 'tr td.details-control', function () {
                        var tr = $(this).closest('tr');
                        var row = dt.row( tr );
                        var idx = $.inArray( tr.attr('id'), detailRows );

                        if ( row.child.isShown() ) {
                            tr.removeClass( 'details' );
                            row.child.hide();

                            // Remove from the 'open' array
                            detailRows.splice( idx, 1 );
                        }
                        else {
                            tr.addClass( 'details' );
                            row.child( format( row.data() ) ).show();

                            // Add to the 'open' array
                            if ( idx === -1 ) {
                                detailRows.push( tr.attr('id') );
                            }
                        }
                        //把对应对象信息传入到对应的modal中去
                        synModal(row.data());
                    } );

                    // On each draw, loop over the `detailRows` array and show any child rows
                    dt.on( 'draw', function () {
                        $.each( detailRows, function ( i, id ) {
                            $('#'+id+' td.details-control').trigger( 'click' );
                        } );
                    } );
                } );

                //把记录子信息输出到对应的子表单中
                function format ( d ) {
                    return  '数据库类型:'+d.dbConfig.dbType+'<br>'+
                            '数据库地址:'+d.dbConfig.dbIp+'<br>'+
                            '数据库端口:'+d.dbConfig.dbPort+'<br>'+
                            '数据库名称:'+d.dbConfig.dbName+'<br>'+
                            '数据库用户名:'+d.dbConfig.dbUsername;
                }
                
                 //向模态弹出框中框中传值。
                function synModal(f) {
                    //向模态框中传值
                    $('input[name="taskName"]').val(f.taskName);
                    $('input[name="dbConfig.dbType"]').val(f.dbConfig.dbType);
                    $('input[name="dbConfig.dbPort"]').val(f.dbConfig.dbPort);
                    $('input[name="dbConfig.dbName"]').val(f.dbConfig.dbName);
                    $('input[name="dbConfig.dbUsername"]').val(f.dbConfig.dbUsername);
                    $('input[name="dbConfig.dbPassword"]').val(f.dbConfig.dbPassword);
                    $('input[name="dbConfig.dbIp"]').val(f.dbConfig.dbIp);
                    $('#dbContent').val(f.dbContent);
                    $('input[name="taskId"]').val(f.taskId);
                    $('input[name="dbConfig.dbId"]').val(f.dbConfig.dbId);
                    $('input[name="taskType"]').val(f.taskType);
                    $("h4.modal-delete").html("确定要删除"+f.taskId+"?");
                    $('input[name="deleteId"]').val(f.taskId);
                }
	    </script>


* 查看文档的请求接口文档，弄清楚传递json字符串的格式，对应的文档在 [mannual](https://datatables.net/manual/server-side)  上面  有详尽的说明 分为  sendData  AND returnData，后端服务器按照要求接受返回具体的参数就行，这边就不详尽说明了。


* 效果展示：

	![](http://i4.buimg.com/567571/d53731d59f2eef04.png)
	
	
	![](http://i4.buimg.com/567571/9fb79bd0cff7892c.png)


	![](http://i4.buimg.com/567571/49efc4ac30b5f7d3.png)
	
	
<p  id ="build3"></p>

### 3、datatable插件运用小结
* 自己项目中用到了很多优秀的开源jquery插件 ，非常好并且很美观,自己如果从头开始是非常难得，开发站在巨人的肩膀上，对于大多数开发者来说用好工具读懂文档的能力尤为重要！

* 前端发展特别快速，语法也特别灵活，学习一定以实践为主， 在使用中学习并且不断的总结。








