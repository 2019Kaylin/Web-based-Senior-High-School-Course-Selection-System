package com.schoolbar.programmer.servlet;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schoolbar.programmer.dao.AdminDao;
import com.schoolbar.programmer.dao.StudentDao;
import com.schoolbar.programmer.dao.TeacherDao;
import com.schoolbar.programmer.model.Admin;
import com.schoolbar.programmer.model.Student;
import com.schoolbar.programmer.model.Teacher;
import com.schoolbar.programmer.util.StringUtil;

/**
 * 
 * @author 86136
 *Login Verification Servlet
 */
public class LoginServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5870852067427524781L;
	
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("logout".equals(method)){
			logout(request, response);
			return;
		}
		String vcode = request.getParameter("vcode");
		String name = request.getParameter("account");
		String password = request.getParameter("password");
		int type = Integer.parseInt(request.getParameter("type"));
		String loginCaptcha = request.getSession().getAttribute("loginCaptcha").toString();
		if(StringUtil.isEmpty(vcode)){
			response.getWriter().write("vcodeError");
			return;
		}
		if(!vcode.toUpperCase().equals(loginCaptcha.toUpperCase())){
			response.getWriter().write("vcodeError");
			return;
		}
		//The captcha is successfully verified. Check whether the user account and password are correct.
		String loginStatus = "loginFaild";
		switch (type) {
			case 1:{
				AdminDao adminDao = new AdminDao();
				Admin admin = adminDao.login(name, password);
				adminDao.closeCon();
				if(admin == null){
					response.getWriter().write("loginError");
					return;
				}
				HttpSession session = request.getSession();
				session.setAttribute("user", admin);
				session.setAttribute("userType", type);
				loginStatus = "loginSuccess";
				break;
			}
			case 2:{
				StudentDao studentDao = new StudentDao();
				Student student = studentDao.login(name, password);
				studentDao.closeCon();
				if(student == null){
					response.getWriter().write("loginError");
					return;
				}
				HttpSession session = request.getSession();
				session.setAttribute("user", student);
				session.setAttribute("userType", type);
				loginStatus = "loginSuccess";
				break;
			}
			case 3:{
				TeacherDao teahcerDao = new TeacherDao();
				Teacher teacher = teahcerDao.login(name, password);
				teahcerDao.closeCon();
				if(teacher == null){
					response.getWriter().write("loginError");
					return;
				}
				HttpSession session = request.getSession();
				session.setAttribute("user", teacher);
				session.setAttribute("userType", type);
				loginStatus = "loginSuccess";
				break;
			} 
			default:
				break;
			}
		response.getWriter().write(loginStatus);
		
	}
	
	private void logout(HttpServletRequest request,HttpServletResponse response) throws IOException{
		request.getSession().removeAttribute("user");
		request.getSession().removeAttribute("userType");
		response.sendRedirect("index.jsp");
	}
}