<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Course Selection System | Administrator</title>
    <link rel="shortcut icon" href="favicon.ico"/>
	<link rel="bookmark" href="favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="easyui/css/default.css" />
    <link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="easyui/themes/icon.css" />
    <script type="text/javascript" src="easyui/jquery.min.js"></script>
    <script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src='easyui/js/outlook2.js'> </script>
    <script type="text/javascript">
	 var _menus = {"menus":[
						
						{"menuid":"2","icon":"","menuname":"Student",
							"menus":[
									{"menuid":"21","menuname":"Student List","icon":"icon-user-student","url":"StudentServlet?method=toStudentListView"},
								]
						},
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"4","icon":"","menuname":"Class",
							"menus":[
									{"menuid":"42","menuname":"Class List","icon":"icon-house","url":"ClazzServlet?method=toClazzListView"}
								]
						},
						</c:if>
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"3","icon":"","menuname":"Teacher",
							"menus":[
									{"menuid":"31","menuname":"Teacher List","icon":"icon-user-teacher","url":"TeacherServlet?method=toTeacherListView"},
								]
						},
						</c:if>
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"6","icon":"","menuname":"Course",
							"menus":[
									{"menuid":"61","menuname":"Course List","icon":"icon-book-open","url":"CourseServlet?method=toCourseListView"},
								]
						},
						</c:if>
						{"menuid":"7","icon":"","menuname":"Course Selection",
							"menus":[
									{"menuid":"71","menuname":"Course Selected List","icon":"icon-book-open","url":"SelectedCourseServlet?method=toSelectedCourseListView"},
								]
						},
						{"menuid":"5","icon":"","menuname":"System",
							"menus":[
							        {"menuid":"51","menuname":"Password Change","icon":"icon-set","url":"SystemServlet?method=toPersonalView"},
								]
						}
				]};


    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
	<noscript>
		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
		    <img src="images/noscript.gif" alt='Sorry, please enable script support!' />
		</div>
	</noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background: url(images/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, Microsoft YaHei,Boldface">
        <span style="float:right; padding-right:20px;" class="head"><span style="color:red; font-weight:bold;">${user.name}&nbsp;</span>Welcome&nbsp;&nbsp;&nbsp;<a href="LoginServlet?method=logout" id="loginOut">Logout</a></span>
        <span style="padding-left:10px; font-size: 16px; ">Senior High School Course Selection System</span>
    </div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        
    </div>
    <div region="west" hide="true" split="true" title="Navigation" style="width:180px;" id="west">
	<div id="nav" class="easyui-accordion" fit="true" border="false">
		<!--  NavigationContents -->
	</div>
	
    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
			<jsp:include page="welcome.jsp" />
		</div>
    </div>
	
	<iframe width=0 height=0 src="refresh.jsp"></iframe>
	
</body>
</html>