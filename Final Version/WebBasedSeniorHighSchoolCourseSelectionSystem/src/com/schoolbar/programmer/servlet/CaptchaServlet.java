package com.schoolbar.programmer.servlet;

import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.schoolbar.programmer.util.CaptchaUtil;
/**
 * 
 * @author 86136
 *Captcha Servlet
 */
public class CaptchaServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4919529414762301338L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
		doPost(request, response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String method = request.getParameter("method");
		if("loginCaptcha".equals(method)){
			generateLoginCpacha(request, response);
			return;
		}
		response.getWriter().write("error method");
	}
	private void generateLoginCpacha(HttpServletRequest request,HttpServletResponse response) throws IOException{
		CaptchaUtil cpachaUtil = new CaptchaUtil();
		String generatorVCode = cpachaUtil.generatorVCode();
		request.getSession().setAttribute("loginCaptcha", generatorVCode);
		BufferedImage generatorRotateVCodeImage = cpachaUtil.generatorRotateVCodeImage(generatorVCode, true);
		ImageIO.write(generatorRotateVCodeImage, "gif", response.getOutputStream());
	}
}
