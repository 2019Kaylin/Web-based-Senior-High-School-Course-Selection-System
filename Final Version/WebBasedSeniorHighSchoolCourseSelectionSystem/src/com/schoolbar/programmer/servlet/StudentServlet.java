package com.schoolbar.programmer.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.schoolbar.programmer.dao.ClazzDao;
import com.schoolbar.programmer.dao.StudentDao;
import com.schoolbar.programmer.model.Clazz;
import com.schoolbar.programmer.model.Page;
import com.schoolbar.programmer.model.Student;
import com.schoolbar.programmer.util.SnGenerateUtil;
/**
 * 
 * @author 86136
 *StudentServlet
 */
public class StudentServlet extends HttpServlet {
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("toStudentListView".equals(method)){
			studentList(request,response);
		}else if("AddStudent".equals(method)){
			addStudent(request,response);
		}else if("StudentList".equals(method)){
			getStudentList(request,response);
		}else if("EditStudent".equals(method)){
			editStudent(request,response);
		}else if("DeleteStudent".equals(method)){
			deleteStudent(request,response);
		}
	}
	private void deleteStudent(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String[] ids = request.getParameterValues("ids[]");
		String idStr = "";
		for(String id : ids){
			idStr += id + ",";
		}
		idStr = idStr.substring(0, idStr.length()-1);
		StudentDao studentDao = new StudentDao();
		if(studentDao.deleteStudent(idStr)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				studentDao.closeCon();
			}
		}
	}
	private void editStudent(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name = request.getParameter("name");
		int id = Integer.parseInt(request.getParameter("id"));
		String gender = request.getParameter("gender");
		String mobile = request.getParameter("mobile");
		String grade = request.getParameter("grade");
		int clazzId = Integer.parseInt(request.getParameter("clazzid"));
		Student student = new Student();
		student.setClazzId(clazzId);
		student.setMobile(mobile);
		student.setName(name);
		student.setId(id);
		student.setGrade(grade);
		student.setGender(gender);
		StudentDao studentDao = new StudentDao();
		if(studentDao.editStudent(student)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				studentDao.closeCon();
			}
		}
	}
	private void getStudentList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name = request.getParameter("studentName");
		Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
		Integer pageSize = request.getParameter("rows") == null ? 999 : Integer.parseInt(request.getParameter("rows"));
		Integer clazz = request.getParameter("clazzid") == null ? 0 : Integer.parseInt(request.getParameter("clazzid"));
		//obtain the type of the current login user
		int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
		Student student = new Student();
		student.setName(name);
		student.setClazzId(clazz);
		if(userType == 2){
			//if the user is a student, he can only view his own information
			Student currentUser = (Student)request.getSession().getAttribute("user");
			student.setId(currentUser.getId());
		}
		StudentDao studentDao = new StudentDao();
		List<Student> clazzList = studentDao.getStudentList(student, new Page(currentPage, pageSize));
		int total = studentDao.getStudentListTotal(student);
		studentDao.closeCon();
		response.setCharacterEncoding("UTF-8");
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("total", total);
		ret.put("rows", clazzList);
		try {
			String from = request.getParameter("from");
			if("combox".equals(from)){
				response.getWriter().write(JSONArray.fromObject(clazzList).toString());
			}else{
				response.getWriter().write(JSONObject.fromObject(ret).toString());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void addStudent(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String gender = request.getParameter("gender");
		String mobile = request.getParameter("mobile");
		String grade = request.getParameter("grade");
		int clazzId = Integer.parseInt(request.getParameter("clazzid"));
		Student student = new Student();
		student.setClazzId(clazzId);
		student.setMobile(mobile);
		student.setName(name);
		student.setPassword(password);
		student.setGrade(grade);
		student.setGender(gender);
		student.setSn(SnGenerateUtil.generateSn(clazzId));
		StudentDao studentDao = new StudentDao();
		if(studentDao.addStudent(student)){
			try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				studentDao.closeCon();
			}
		}
	}
	private void studentList(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// TODO Auto-generated method stub
		try {
			request.getRequestDispatcher("view/studentList.jsp").forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
