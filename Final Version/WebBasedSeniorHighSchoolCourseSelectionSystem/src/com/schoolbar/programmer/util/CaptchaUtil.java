package com.schoolbar.programmer.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

/**
 * Captcha Generator
 * 
 * @author 86136
 */
public class CaptchaUtil {
	
	/**
	 * Captcha Source
	 */
	final private char[] code = {
		'2', '3', '4', '5', '6', '7', '8', '9',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
		'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 
		'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F',
		'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R',
		'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
	};
	/**
	 * Font
	 */
	final private String[] fontNames = new String[]{
			"Boldface", "SimSun", "Courier", "Arial", 
			"Verdana", "Times", "Tahoma", "Georgia"};
	/**
	 * Font Style
	 */
	final private int[] fontStyles = new int[]{
			Font.BOLD, Font.ITALIC|Font.BOLD
	};
	
	/**
	 * Captcha Length
	 * Default 4 Characters
	 */
	private int vcodeLen = 4;
	/**
	 * Font Size
	 * Default 17
	 */
	private int fontsize = 21;
	/**
	 * Captcha Image Width
	 */
	private int width = (fontsize+1)*vcodeLen+10;
	/**
	 * Captcha Image Height
	 */
	private int height = fontsize+12;
	/**
	 * Disturbance Lines
	 * Default 3
	 */
	private int disturbline = 3;
	
	
	public CaptchaUtil(){}
	
	/**
	 * Specify Captcha Length
	 * @param vcodeLen (Captcha Length)
	 */
	public CaptchaUtil(int vcodeLen) {
		this.vcodeLen = vcodeLen;
		this.width = (fontsize+1)*vcodeLen+10;
	}
	
	/**
	 * Generate Captcha Image
	 * @param vcode (The captcha to draw)
	 * @param drawline (Whether to draw disturbance lines)
	 * @return
	 */
	public BufferedImage generatorVCodeImage(String vcode, boolean drawline){
		//Generate Captcha Image
		BufferedImage vcodeImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics g = vcodeImage.getGraphics();
		//Fill Background Color
		g.setColor(new Color(246, 240, 250));
		g.fillRect(0, 0, width, height);
		if(drawline){
			drawDisturbLine(g);
		}
		//Used to generate pseudorandom numbers
		Random ran = new Random();
		//Draw captcha on the image
		for(int i = 0;i < vcode.length();i++){
			//Set Font
			g.setFont(new Font(fontNames[ran.nextInt(fontNames.length)], fontStyles[ran.nextInt(fontStyles.length)], fontsize));
			//Generate Random Color
			g.setColor(getRandomColor());
			//Draw Captcha
			g.drawString(vcode.charAt(i)+"", i*fontsize+10, fontsize+5);
		}
		//Release Resources
		g.dispose();
		
		return vcodeImage;
	}
	/**
	 * Get the captcha image for the rotated font
	 * @param vcode
	 * @param drawline (Whether to draw disturbance lines)
	 * @return
	 */
	public BufferedImage generatorRotateVCodeImage(String vcode, boolean drawline){
		//Generate Captcha Image
		BufferedImage rotateVcodeImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics2D g2d = rotateVcodeImage.createGraphics();
		//Fill Background Color
		g2d.setColor(new Color(246, 240, 250));
		g2d.fillRect(0, 0, width, height);
		if(drawline){
			drawDisturbLine(g2d);
		}
		//Draw Captcha
		for(int i = 0;i < vcode.length();i++){
			BufferedImage rotateImage = getRotateImage(vcode.charAt(i));
			g2d.drawImage(rotateImage, null, (int) (this.height * 0.7) * i, 0);
		}
		g2d.dispose();
		return rotateVcodeImage;
	}
	/**
	 * Generate Captcha
	 * @return Captcha
	 */
	public String generatorVCode(){
		int len = code.length;
		Random ran = new Random();
		StringBuffer sb = new StringBuffer();
		for(int i = 0;i < vcodeLen;i++){
			int index = ran.nextInt(len);
			sb.append(code[index]);
		}
		return sb.toString();
	}
	/**
	 * Draw some disturbance lines for the captcha image
	 * @param g 
	 */
	private void drawDisturbLine(Graphics g){
		Random ran = new Random();
		for(int i = 0;i < disturbline;i++){
			int x1 = ran.nextInt(width);
			int y1 = ran.nextInt(height);
			int x2 = ran.nextInt(width);
			int y2 = ran.nextInt(height);
			g.setColor(getRandomColor());
			//Draw disturbance lines
			g.drawLine(x1, y1, x2, y2);
		}
	}
	/**
	 * Get a rotated image
	 * @param c (The character to draw)
	 * @return
	 */
	private BufferedImage getRotateImage(char c){
		BufferedImage rotateImage = new BufferedImage(height, height, BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2d = rotateImage.createGraphics();
		//Set transparency to 0
		g2d.setColor(new Color(255, 255, 255, 0));
		g2d.fillRect(0, 0, height, height);
		Random ran = new Random();
		g2d.setFont(new Font(fontNames[ran.nextInt(fontNames.length)], fontStyles[ran.nextInt(fontStyles.length)], fontsize));
		g2d.setColor(getRandomColor());
		double theta = getTheta();
		//Rotate image
		g2d.rotate(theta, height/2, height/2);
		g2d.drawString(Character.toString(c), (height-fontsize)/2, fontsize+5);
		g2d.dispose();
		
		return rotateImage;
	}
	/**
	 * @return a random color
	 */
	private Color getRandomColor(){
		Random ran = new Random();
		return new Color(ran.nextInt(220), ran.nextInt(220), ran.nextInt(220)); 
	}
	/**
	 * @return angle
	 */
	private double getTheta(){
		return ((int) (Math.random()*1000) % 2 == 0 ? -1 : 1)*Math.random();
	}

	/**
	 * @return the number of characters in captcha
	 */
	public int getVcodeLen() {
		return vcodeLen;
	}
	/**
	 * Set the number of characters in captcha
	 * @param vcodeLen
	 */
	public void setVcodeLen(int vcodeLen) {
		this.width = (fontsize+3)*vcodeLen+10;
		this.vcodeLen = vcodeLen;
	}
	/**
	 * @return font size
	 */
	public int getFontsize() {
		return fontsize;
	}
	/**
	 * Set font size
	 * @param fontsize
	 */
	public void setFontsize(int fontsize) {
		this.width = (fontsize+3)*vcodeLen+10;
		this.height = fontsize+15;
		this.fontsize = fontsize;
	}
	/**
	 * @return image width
	 */
	public int getWidth() {
		return width;
	}
	/**
	 * Set image width
	 * @param width
	 */
	public void setWidth(int width) {
		this.width = width;
	}
	/**
	 * @return image height
	 */
	public int getHeight() {
		return height;
	}
	/**
	 * Set image height
	 * @param height 
	 */
	public void setHeight(int height) {
		this.height = height;
	}
	/**
	 * @return number of disturbance lines
	 */
	public int getDisturbline() {
		return disturbline;
	}
	/**
	 * set number of disturbance lines
	 * @param disturbline
	 */
	public void setDisturbline(int disturbline) {
		this.disturbline = disturbline;
	}
	
}