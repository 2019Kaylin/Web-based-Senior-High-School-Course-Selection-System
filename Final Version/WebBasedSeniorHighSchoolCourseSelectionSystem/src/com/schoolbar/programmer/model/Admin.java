package com.schoolbar.programmer.model;
/**
 * 
 * @author 86136
 *Admin Entity
 */
public class Admin {
	private int id;
	private String name;
	private String password;
	private int status = 1; //The default is 1, indicating that the status is available
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
}