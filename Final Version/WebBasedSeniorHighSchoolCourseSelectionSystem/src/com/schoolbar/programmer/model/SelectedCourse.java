package com.schoolbar.programmer.model;
/**
 * 
 * @author 86136
 *SelectedCourse Entity
 */
public class SelectedCourse {
	private int id;
	private int studentId;
	private int courseId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public int getCourseId() {
		return courseId;
	}
	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}
	
	
}
