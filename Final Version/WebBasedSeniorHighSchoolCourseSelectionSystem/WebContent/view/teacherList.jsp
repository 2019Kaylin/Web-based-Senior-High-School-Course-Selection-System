<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Teacher List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		var table;
		
		//datagrid initialization
	    $('#dataList').datagrid({ 
	        title:'Teacher List', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible:false, 
	        fit: true,//automatic sizing
	        method: "post",
	        url:"TeacherServlet?method=TeacherList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,
	        pagination:true,
	        rownumbers:true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'sn',title:'Teacher Number',width:150, sortable: true},    
 		        {field:'name',title:'Teacher Name',width:150},
 		        {field:'gender',title:'Gender',width:100},
 		        {field:'mobile',title:'Mobil',width:150},
 		        {field:'age',title:'Age',width:150},
 		       	{field:'clazz_id',title:'Class',width:150, 
 		        	formatter: function(value,row,index){
 						if (row.clazzId){
 							var clazzList = $("#clazzList").combobox("getData");
 							for(var i=0;i<clazzList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.clazzId == clazzList[i].id)return clazzList[i].name;
 							}
 							return row.clazzId;
 						} else {
 							return 'not found';
 						}
 					}
				}
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#clazzList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
	    //set paging control
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//number of records displayed per page (default is 10)
	        pageList: [10,20,30,50,100],
	    }); 
	    //set tool button
	    $("#add").click(function(){
	    	table = $("#addTable");
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
	    //delete
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("message reminder", "Please select data to delete!", "warning");
            } else{
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("message reminder", "Sure to delete teacher information?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "TeacherServlet?method=DeleteTeacher",
							data: {ids: ids},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("message reminder","Deleted successfully!","info");
									//refresh table
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
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
	    
	    function preLoadClazz(){
	  		$("#clazzList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false,
		  		editable: false,
		  		method: "post",
		  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  			//load the students under the class
		  			//$('#dataList').datagrid("options").queryParams = {clazzid: newValue};
		  			//$('#dataList').datagrid("reload");
		  		}
		  	});
	  	}
	    
	  	//set add window of teacher
	    $("#addDialog").dialog({
	    	title: "Add Teacher",
	    	width: 850,
	    	height: 550,
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
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("message reminder","Please check the entered data!","warning");
							return;
						} else{
							var clazzid = $("#add_clazzList").combobox("getValue");
							var name = $("#add_name").textbox("getText");
							var gender = $("#add_gender").textbox("getText");
							var mobile = $("#add_mobile").textbox("getText");
							var age = $("#add_age").textbox("getText");
							var password = $("#add_password").textbox("getText");
							var data = {clazzid:clazzid, name:name,gender:gender,mobile:mobile,age:age,password:password};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=AddTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("message reminder","Add successfully!","info");
										//close the window
										$("#addDialog").dialog("close");
										//clear the original table data
										$("#add_number").textbox('setValue', "");
										$("#add_name").textbox('setValue', "");
										$("#add_gender").textbox('setValue', "male");
										$("#add_mobile").textbox('setValue', "");
										$("#add_age").textbox('setValue', "");
										$(table).find(".chooseTr").remove();
										
										//refresh the page data
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
					iconCls:'icon-reload',
					handler:function(){
						$("#add_number").textbox('setValue', "");
						$("#add_name").textbox('setValue', "");
						$("#add_mobile").textbox('setValue', "");
						$("#add_age").textbox('setValue', "");
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onClose: function(){
				$("#add_number").textbox('setValue', "");
				$("#add_name").textbox('setValue', "");
				$("#add_mobile").textbox('setValue', "");
				$("#add_age").textbox('setValue', "");
				
				$(table).find(".chooseTr").remove();
			}
	    });
	  	
	  	
	  	
	  //drop-down box general properties
	  	$("#edit_clazzList, #add_clazzList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	
	  	
	  	
	  	$("#add_clazzList").combobox({
	  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//the first data is selected by default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	  	$("#edit_clazzList").combobox({
	  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
			onLoadSuccess: function(){
				//the first data is selected by default
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	  	//set edit window of teacher
	  	$("#editDialog").dialog({
	  		title: "Edit Teacher",
	    	width: 850,
	    	height: 550,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'edit',
					plain: true,
					iconCls:'icon-user_add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("message reminder","Please check the entered data!","warning");
							return;
						} else{
							var clazzid = $("#edit_clazzList").combobox("getValue");
							var id = $("#dataList").datagrid("getSelected").id;
							var name = $("#edit_name").textbox("getText");
							var gender = $("#edit_gender").textbox("getText");
							var mobile = $("#edit_mobile").textbox("getText");
							var age = $("#edit_age").textbox("getText");
							var data = {id:id, clazzid:clazzid, name:name,gender:gender,mobile:mobile,age:age};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=EditTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("message reminder","Edit Successfully!","info");
										//close the window
										$("#editDialog").dialog("close");
										//clear the original table data
										$("#edit_name").textbox('setValue', "");
										$("#edit_gender").textbox('setValue', "male");
										$("#edit_mobile").textbox('setValue', "");
										$("#edit_age").textbox('setValue', "");
										
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
				$("#edit_gender").textbox('setValue', selectRow.gender);
				$("#edit_mobile").textbox('setValue', selectRow.mobile);
				$("#edit_age").textbox('setValue', selectRow.age);
				$("#edit_photo").attr("src", "PhotoServlet?method=getPhoto&type=2&tid="+selectRow.id);
				$("#set-photo-id").val(selectRow.id);
				var clazzid = selectRow.clazzId;
				setTimeout(function(){
					$("#edit_clazzList").combobox('setValue', clazzid);
				}, 100);
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_mobile").textbox('setValue', "");
				$("#edit_age").textbox('setValue', "");
			}
	    });
	   	
	  	 //the search button listens for events
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			teacherName: $('#search_student_name').val(),
	  			clazzid: $("#clazzList").combobox('getValue') == '' ? 0 : $("#clazzList").combobox('getValue')
	  		});
	  	});
	});
	
	//upload photo button event
	$("#upload-photo-btn").click(function(){
		
	});
	function uploadPhoto(){
		var action = $("#uploadForm").attr('action');
		var pos = action.indexOf('tid');
		if(pos != -1){
			action = action.substring(0,pos-1);
		}
		$("#uploadForm").attr('action',action+'&tid='+$("#set-photo-id").val());
		$("#uploadForm").submit();
		setTimeout(function(){
			var message =  $(window.frames["photo_target"].document).find("#message").text();
			$.messager.alert("message reminder",message,"info");
			
			$("#edit_photo").attr("src", "PhotoServlet?method=getPhoto&tid="+$("#set-photo-id").val());
		}, 1500)
	}
	</script>
</head>
<body>
	<!-- Data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- Toolbar -->
	<div id="toolbar">
		<c:if test="${userType == 1}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${userType == 1}">
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		</c:if>
		<div style="float: left;margin-top:4px;" class="datagrid-btn-separator" >&nbsp;&nbsp;Name:<input id="search_student_name" class="easyui-textbox" name="search_student_name" /></div>
		<div style="margin-left: 10px;margin-top:4px;" >Class:<input id="clazzList" class="easyui-textbox" name="clazz" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
		</div>		
	</div>
	
	<!-- add window -->
	<div id="addDialog" style="padding: 10px;">  
   		<div style=" position: absolute; margin-left: 560px; width: 200px; border: 1px solid #EEF4FF" id="photo">
    		<img alt="Photo" style="max-width: 200px; max-height: 400px;" title="Photo" src="PhotoServlet?method=getPhoto" />
	    </div> 
   		<form id="addForm" method="post">
	    	<table id="addTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:40px">Class:</td>
	    			<td colspan="3">
	    				<input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Name:</td>
	    			<td colspan="4"><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Password:</td>
	    			<td colspan="4"><input id="add_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" name="password" data-options="required:true, missingMessage:'Please enter password'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Gender:</td>
	    			<td colspan="4"><select id="add_gender" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="gender"><option value="male">male</option><option value="female">female</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>Mobile:</td>
	    			<td colspan="4"><input id="add_mobile" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="mobile" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>Age:</td>
	    			<td colspan="4"><input id="add_age" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="age" validType="number" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	
	<!-- edit window -->
	<div id="editDialog" style="padding: 10px">
		<div style=" position: absolute; margin-left: 560px; width: 200px; border: 1px solid #EEF4FF">
	    	<img id="edit_photo" alt="Photo" style="max-width: 200px; max-height: 400px;" title="Photo" src="" />
	    	<form id="uploadForm" method="post" enctype="multipart/form-data" action="PhotoServlet?method=SetPhoto" target="photo_target">
	    		<!-- StudentServlet?method=SetPhoto -->
	    		<input type="hidden" name="tid" id="set-photo-id">
		    	<input class="easyui-filebox" name="photo" data-options="prompt:'Select Photo'" style="width:200px;">
		    	<input id="upload-photo-btn" onClick="uploadPhoto()" class="easyui-linkbutton" style="width: 50px; height: 24px;" type="button" value="Upload"/>
		    </form>
	    </div>   
    	<form id="editForm" method="post">
	    	<table id="editTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:40px">Class:</td>
	    			<td colspan="3">
	    				<input id="edit_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Gender:</td>
	    			<td><select id="edit_gender" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="gender"><option value="male">male</option><option value="female">female</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>Mobile:</td>
	    			<td><input id="edit_mobile" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="mobile" validType="mobile" /></td>
	    		</tr>
	    		<tr>
	    			<td>Age:</td>
	    			<td colspan="4"><input id="edit_age" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="age" validType="number" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
<iframe id="photo_target" name="photo_target"></iframe>  	
</body>
</html>