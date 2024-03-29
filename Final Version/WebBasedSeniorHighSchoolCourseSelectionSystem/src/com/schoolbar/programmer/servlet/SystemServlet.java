package com.schoolbar.programmer.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.schoolbar.programmer.dao.AdminDao;
import com.schoolbar.programmer.dao.StudentDao;
import com.schoolbar.programmer.dao.TeacherDao;
import com.schoolbar.programmer.model.Admin;
import com.schoolbar.programmer.model.Student;
import com.schoolbar.programmer.model.Teacher;
/**
 * 
 * @author 86136
 *the interface after logging in
 */
public class SystemServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7258264317769166483L;
	
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("toPersonalView".equals(method)){
			personalView(request,response);
			return;
		}else if("EditPasswod".equals(method)){
			editPassword(request,response);
			return;
		}
		try {
			request.getRequestDispatcher("view/system.jsp").forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void editPassword(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String password = request.getParameter("password");
		String newPassword = request.getParameter("newpassword");
		response.setCharacterEncoding("UTF-8");
		int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
		if(userType == 1){
			//Administrator
			Admin admin = (Admin)request.getSession().getAttribute("user");
			if(!admin.getPassword().equals(password)){
				try {
					response.getWriter().write("The old password is wrong!");
					return;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			AdminDao adminDao = new AdminDao();
			if(adminDao.editPassword(admin, newPassword)){
				try {
					response.getWriter().write("success");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				finally{
					adminDao.closeCon();
				}
			}else{
				try {
					response.getWriter().write("Database modification error");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally{
					adminDao.closeCon();
				}
			}
		}
		if(userType == 2){
			//Student
			Student student = (Student)request.getSession().getAttribute("user");
			if(!student.getPassword().equals(password)){
				try {
					response.getWriter().write("The old password is wrong!");
					return;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			StudentDao studentDao = new StudentDao();
			if(studentDao.editPassword(student, newPassword)){
				try {
					response.getWriter().write("success");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				finally{
					studentDao.closeCon();
				}
			}else{
				try {
					response.getWriter().write("Database modification error");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally{
					studentDao.closeCon();
				}
			}
		}
		if(userType == 3){
			//Teacher
			Teacher teacher = (Teacher)request.getSession().getAttribute("user");
			if(!teacher.getPassword().equals(password)){
				try {
					response.getWriter().write("The old password is wrong!");
					return;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			TeacherDao teacherDao = new TeacherDao();
			if(teacherDao.editPassword(teacher, newPassword)){
				try {
					response.getWriter().write("success");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				finally{
					teacherDao.closeCon();
				}
			}else{
				try {
					response.getWriter().write("Database modification error");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally{
					teacherDao.closeCon();
				}
			}
		} 
	}
	private void personalView(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		try {
			request.getRequestDispatcher("view/personalView.jsp").forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}