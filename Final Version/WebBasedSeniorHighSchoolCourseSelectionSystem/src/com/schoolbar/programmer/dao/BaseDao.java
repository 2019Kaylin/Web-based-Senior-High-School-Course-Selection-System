package com.schoolbar.programmer.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.schoolbar.programmer.util.DbUtil;

/**
 * 
 * @author 86136
 *BaseDao(Encapsulate the basic operations of the database)
 */
public class BaseDao {
	private DbUtil dbUtil = new DbUtil();
	
	/**
	 * Close the database connection to release resources
	 */
	public void closeCon(){
		dbUtil.closeCon();
	}
	
	/**
	 * Basic query and multiple query
	 */
	public ResultSet query(String sql){
		try {
			PreparedStatement prepareStatement = dbUtil.getConnection().prepareStatement(sql);
			return prepareStatement.executeQuery();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	} 
	/**
	 *Operations that change the contents of the database
	 */
	public boolean update(String sql){
		try {
			return dbUtil.getConnection().prepareStatement(sql).executeUpdate() > 0;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
	public Connection getConnection(){
		return dbUtil.getConnection();
	}
}
