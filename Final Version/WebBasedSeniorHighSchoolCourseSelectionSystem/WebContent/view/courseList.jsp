<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Course List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		//datagrid initialization
	    $('#dataList').datagrid({ 
	        title:'Course List', 
	        iconCls:'icon-more',
	        border: true, 
	        collapsible: false, 
	        fit: true,//automatic sizing
	        method: "post",
	        url:"CourseServlet?method=CourseList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: false,
	        pagination: true, 
	        rownumbers: true, 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'Course Name',width:200},
 		       	{field:'teacherId',title:'Course Teacher',width:200,
 		        	formatter: function(value,row,index){
 						if (row.teacherId){
 							var teacherList = $("#teacherList").combobox("getData");
 							for(var i=0;i<teacherList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.teacherId == teacherList[i].id)return teacherList[i].name;
 							}
 							return row.clazzId;
 						} else {
 							return 'not found';
 						}
 					}	
 		       	},
 		       	{field:'courseDate',title:'Course Time',width:200},
 		        {field:'selectedNum',title:'Current Students',width:200},
 		        {field:'maxNum',title:'Maximum Students',width:200},
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#teacherList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
		//preload teacher info
	    function preLoadClazz(){
	  		$("#teacherList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false,
		  		editable: false,
		  		method: "post",
		  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  			//load the students under the class
		  			//$('#dataList').datagrid("options").queryParams = {clazzid: newValue};
		  			//$('#dataList').datagrid("reload");
		  		}
		  	});
	  	}
		
	  //set paging control
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//number of records displayed per page (default is 10)
	        pageList: [10,20,30,50,100],
	    });
	   	
	    //set tool button
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	  //edit
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("message reminder", "Please select data to edit!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    
	  //set edit window of course
	  	$("#editDialog").dialog({
	  		title: "Edit Course Info",
	    	width: 450,
	    	height: 400,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Edit',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("message reminder","Please check the entered data!","warning");
							return;
						} else{
							var teacherid = $("#edit_teacherList").combobox("getValue");
							var id = $("#dataList").datagrid("getSelected").id;
							var name = $("#edit_name").textbox("getText");
							var courseDate = $("#edit_course_date").textbox("getText");
							var maxNum = $("#edit_max_num").numberbox("getValue");
							var info = $("#edit_info").val();
							var data = {id:id, teacherid:teacherid, name:name,courseDate:courseDate,info:info,maxnum:maxNum};
							
							$.ajax({
								type: "post",
								url: "CourseServlet?method=EditCourse",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("message reminder","Edit Successfully!","info");
										//close the window
										$("#editDialog").dialog("close");
										//clear the original table data
										$("#edit_name").textbox('setValue', "");
										$("#edit_course_date").textbox('setValue', "");
										$("#edit_info").val("");
										
										//refresh the page data
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("message reminder","Edition Fails!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#edit_name").textbox('setValue', "");
						$("#edit_mobile").textbox('setValue', "");
						$("#edit_age").textbox('setValue', "");
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//set value
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_course_date").textbox('setValue', selectRow.courseDate);
				$("#edit_max_num").numberbox('setValue', selectRow.maxNum);
				$("#edit_info").val(selectRow.info);
				//$("#edit-id").val(selectRow.id);
				var teacherId = selectRow.teacherId;
				setTimeout(function(){
					$("#edit_teacherList").combobox('setValue', teacherId);
				}, 100);
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_course_date").textbox('setValue', "");
				$("#edit_info").val("");
				//$("#edit-id").val('');
			}
	    });
	    
	    //delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelections");
        	if(selectRow == null){
            	$.messager.alert("message reminder", "Please select data to delete!", "warning");
            } else{
            	var ids = [];
            	$(selectRow).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("message reminder", "Sure to delete course information?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "CourseServlet?method=DeleteCourse",
							data: {ids: ids},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("message reminder","Deleted successfully!","info");
									//refresh table
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("message reminder","Deletion fails!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	
	  	//set add window of course
	    $("#addDialog").dialog({
	    	title: "Add Course",
	    	width: 450,
	    	height: 400,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Add',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("message reminder","Please check the entered data!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "CourseServlet?method=AddCourse",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("message reminder","Add successfully!","info");
										//close the window
										$("#addDialog").dialog("close");
										//clear the original table data
										$("#add_name").textbox('setValue', "");
										//refresh
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("message reminder","Addition fails!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-book-reset',
					handler:function(){
						$("#add_name").textbox('setValue', "");
					}
				},
			]
	    });
	  	
	  //drop-down box general properties
	  	$("#add_teacherList, #edit_teacherList,#teacherList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	//selection box for adding teacher information
	    $("#add_teacherList").combobox({
	  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//the first data is selected by default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  //selection box for editing teacher information
	    $("#edit_teacherList").combobox({
	  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//the first data is selected by default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	    //the search button listens for events
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			name: $('#courseName').val(),
	  			teacherid: $("#teacherList").combobox('getValue') == '' ? 0 : $("#teacherList").combobox('getValue')
	  		});
	  	});
	});
	</script>
</head>
<body>
	<!-- Data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- Toolbar -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="margin-top: 3px;">
			Course Name:<input id="courseName" class="easyui-textbox" name="clazzName" />
			Course Teacher:<input id="teacherList" class="easyui-textbox" name="clazz" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
		</div>
	</div>
	
	<!-- add window -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Course Name:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Course Teacher:</td>
	    			<td colspan="3">
	    				<input id="add_teacherList" style="width: 200px; height: 30px;" class="easyui-textbox" name="teacherid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Course Time:</td>
	    			<td><input id="add_course_date" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="course_date" data-options="required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Maximum Students:</td>
	    			<td><input id="add_max_num" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="maxnum" data-options="min:0,precision:0,required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td>course Introduction:</td>
	    			<td>
	    				<textarea id="info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Edit Window -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
    		<!-- <input type="hidden" name="id" id="edit-id"> -->
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Course Name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Course Teacher:</td>
	    			<td colspan="3">
	    				<input id="edit_teacherList" style="width: 200px; height: 30px;" class="easyui-textbox" name="teacherid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Course Time:</td>
	    			<td><input id="edit_course_date" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="course_date" data-options="required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Maximum Students:</td>
	    			<td><input id="edit_max_num" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="max_num" data-options="min:0,precision:0,required:true, missingMessage:'Cannot be null'" /></td>
	    		</tr>
	    		<tr>
	    			<td>course Introduction:</td>
	    			<td>
	    				<textarea id="edit_info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
</body>
</html>