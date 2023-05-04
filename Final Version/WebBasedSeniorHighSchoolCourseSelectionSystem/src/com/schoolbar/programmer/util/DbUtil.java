package com.schoolbar.programmer.util;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.management.loading.PrivateClassLoader;
/**
 * 
 * @author 86136
 *DatabaseUtil
 */
public class DbUtil {

	private String dbUrl = "jdbc:mysql://localhost:3306/db_course_selection_system?useUnicode=true&characterEncoding=utf8";
	private String dbUser = "root";
	private String dbPassword = "123456";
	private String jdbcName = "com.mysql.jdbc.Driver";
	private Connection connection = null;
	public Connection getConnection(){
		try {
			Class.forName(jdbcName);
			connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
			System.out.println("The database is connected successfully£¡");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("The database connection fails£¡");
			e.printStackTrace();
		}
		return connection;
	}
	
	public void closeCon(){
		if(connection != null)
			try {
				connection.close();
				System.out.println("The database connection has been closed£¡");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		DbUtil dbUtil = new DbUtil();
		dbUtil.getConnection();
	}

}
