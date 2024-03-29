package com.schoolbar.programmer.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadException;

import com.schoolbar.programmer.dao.StudentDao;
import com.schoolbar.programmer.dao.TeacherDao;
import com.schoolbar.programmer.model.Student;
import com.schoolbar.programmer.model.Teacher;
import com.lizhou.exception.FileFormatException;
import com.lizhou.exception.NullFileException;
import com.lizhou.exception.ProtocolException;
import com.lizhou.exception.SizeException;
import com.lizhou.fileload.FileUpload;

/**
 * 
 * @author 86136
 *PhotoServlet
 */
public class PhotoServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3274927179113071465L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("getPhoto".equals(method)){
			getPhoto(request,response);
		}else if("SetPhoto".equals(method)){
			uploadPhoto(request,response);
		}
		
	}
	private void uploadPhoto(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int sid = request.getParameter("sid") == null ? 0 : Integer.parseInt(request.getParameter("sid"));
		int tid = request.getParameter("tid") == null ? 0 : Integer.parseInt(request.getParameter("tid"));
		FileUpload fileUpload = new FileUpload(request);
		fileUpload.setFileFormat("jpg");
		fileUpload.setFileFormat("png");
		fileUpload.setFileFormat("jpeg");
		fileUpload.setFileFormat("gif");
		fileUpload.setFileSize(2048);
		response.setCharacterEncoding("UTF-8");
		try {
			InputStream uploadInputStream = fileUpload.getUploadInputStream();
			if(sid != 0){
				Student student = new Student();
				student.setId(sid);
				student.setPhoto(uploadInputStream);
				StudentDao studentDao = new StudentDao();
				if(studentDao.setStudentPhoto(student)){
					response.getWriter().write("<div id='message'>Upload Successfully!</div>");
				}else{
					response.getWriter().write("<div id='message'>Upload Failed!</div>");
				}
			}
			if(tid != 0){
				Teacher teacher = new Teacher();
				teacher.setId(tid);
				teacher.setPhoto(uploadInputStream);
				TeacherDao teacherDao = new TeacherDao();
				if(teacherDao.setTeacherPhoto(teacher)){
					response.getWriter().write("<div id='message'>Upload Successfully!</div>");
				}else{
					response.getWriter().write("<div id='message'>Upload Failed!</div>");
				}
			}
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			try {
				response.getWriter().write("<div id='message'>Upload Protocol Error!</div>");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}catch (NullFileException e1) {
			// TODO: handle exception
			try {
				response.getWriter().write("<div id='message'>The uploaded file is empty!</div>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			e1.printStackTrace();
		}
		catch (SizeException e2) {
			// TODO: handle exception
			try {
				response.getWriter().write("<div id='message'>The size of the uploaded file cannot exceed"+fileUpload.getFileSize()+"��</div>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			e2.printStackTrace();
		}
		catch (IOException e3) {
			// TODO: handle exception
			try {
				response.getWriter().write("<div id='message'>Error Reading File!</div>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			e3.printStackTrace();
		}
		catch (FileFormatException e4) {
			// TODO: handle exception
			try {
				response.getWriter().write("<div id='message'>Upload file format is not correct, please upload "+fileUpload.getFileFormat()+" format file!</div>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			e4.printStackTrace();
		}
		catch (FileUploadException e5) {
			// TODO: handle exception
			try {
				response.getWriter().write("<div id='message'>Failed to upload file!</div>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			e5.printStackTrace();
		}
	}
	private void getPhoto(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		//File file = new File();
		int sid = request.getParameter("sid") == null ? 0 : Integer.parseInt(request.getParameter("sid"));
		int tid = request.getParameter("tid") == null ? 0 : Integer.parseInt(request.getParameter("tid"));
		if(sid != 0){
			//student
			StudentDao studentDao = new StudentDao();
			Student student = studentDao.getStudent(sid);
			studentDao.closeCon();
			if(student != null){
				InputStream photo = student.getPhoto();
				if(photo != null){
					try {
						byte[] b = new byte[photo.available()];
						photo.read(b);
						response.getOutputStream().write(b,0,b.length);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return;
				}
			}
		}
		if(tid != 0){
			//teacher
			TeacherDao teacherDao = new TeacherDao();
			Teacher teacher = teacherDao.getTeacher(tid);
			teacherDao.closeCon();
			if(teacher != null){
				InputStream photo = teacher.getPhoto();
				if(photo != null){
					try {
						byte[] b = new byte[photo.available()];
						photo.read(b);
						response.getOutputStream().write(b,0,b.length);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return;
				}
			}
		}
		String path = request.getSession().getServletContext().getRealPath("");
		File file = new File(path+"\\file\\DefaultPhoto.jpg");
		try {
			FileInputStream fis = new FileInputStream(file);
			byte[] b = new byte[fis.available()];
			fis.read(b);
			response.getOutputStream().write(b,0,b.length);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
