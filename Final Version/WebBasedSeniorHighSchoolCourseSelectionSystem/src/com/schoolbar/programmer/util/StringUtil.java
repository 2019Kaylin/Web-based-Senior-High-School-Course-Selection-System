package com.schoolbar.programmer.util;
/**
 * 
 * @author 86136
 *public methods of the String class
 */
public class StringUtil {
	public static boolean isEmpty(String str) {
		if(str == null || "".equals(str))return true;
		return false;
	}
}
