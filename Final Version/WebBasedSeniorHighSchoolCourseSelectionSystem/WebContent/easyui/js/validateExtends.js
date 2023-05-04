/**
 * easyui extension form validation
 */

$.extend($.fn.validatebox.defaults.rules, {
    //verification Chinese character
    CHS: {
        validator: function (value) {
            return /^[\u0391-\uFFE5]+$/.test(value);
        },
        message: 'Input Chinese characters only'
    },
    //mobile phone number verification
    mobile: {//value indicates the value in the text box
        validator: function (value) {
            var reg = /^1[3|4|5|8|9]\d{9}$/;
            return reg.test(value);
        },
        message: 'An 11-digit mobile phone number starting with 13/14/15/18/19'
    },
  	//only numbers
    number: {//value indicates the value in the text box
        validator: function (value) {
            var reg = /^[0-9]*$/;
            return reg.test(value);
        },
        message: 'Only be in numeric format'
    },
	//verification: the account must be unique
	repeat: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "SystemServlet?method=AllAccount&t="+new Date().getTime(),
				success: function(data){//load the data into the validation function and determine the input value when it is loaded
					var account = $.parseJSON(data);
		            for(var i=0;i < account.length;i++){
		            	if(value == account[i]){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'The user already exists'
	},
	
	//verification: the course cannot be repeated
	repeat_course: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "CourseServlet?method=CourseList&t="+new Date().getTime(),
				success: function(data){//load the data into the validation function and determine the input value when it is loaded
					var course = $.parseJSON(data);
		            for(var i=0;i < course.length;i++){
		            	if(value == course[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'The course name already exists'
	},
	
	//verification: the grade cannot be repeated
	repeat_grade: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "GradeServlet?method=GradeList&t="+new Date().getTime(),
				success: function(data){//load the data into the validation function and determine the input value when it is loaded
					var grade = $.parseJSON(data);
		            for(var i=0;i < grade.length;i++){
		            	if(value == grade[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'The grade name already exists'
	},
	
	//verification: the class cannot be repeated
	repeat_clazz: {
		validator: function (value, param) {
			var gradeid = $(param[0]).combobox("getValue");
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				data: {gradeid: gradeid},
				url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
				success: function(data){//load the data into the validation function and determine the input value when it is loaded
					var clazz = $.parseJSON(data);
		            for(var i=0;i < clazz.length;i++){
		            	if(value == clazz[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'The class name already exists'
	},
	
	//verify that the two values are the same
	equals: {//the value of param is the value in []
        validator: function (value, param) {
        	if($(param[0]).val() != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Two passwords are different'
    },
    
    //password rule
    password: {
        validator: function (value) {
        	var reg = /^[a-zA-Z0-9]{6,16}$/;
        	return reg.test(value);
            
        }, message: 'The password contains 6 to 16 characters and can only contain letters and numbers'
    },
    
    //verify that the entered password is correct
    oldPassword: {
        validator: function (value, param) {
        	if(param != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Password is incorrect'
    },
    
    //zipcode verification
    zipcode: {
        validator: function (value) {
            var reg = /^[1-9]\d{5}$/;
            return reg.test(value);
        },
        message: 'The zip code must be 6 digits starting with non-zero'
    },
    //User account verification (underscores, digits, and letters only)
    account: {//the value of param is the value in []
        validator: function (value, param) {
            if (value.length < param[0] || value.length > param[1]) {
                $.fn.validatebox.defaults.rules.account.message = 'The length of the user name must be in' + param[0] + 'to' + param[1] + 'arrange';
                return false;
            } else {
                if (!/^[\w]+$/.test(value)) {
                    $.fn.validatebox.defaults.rules.account.message = 'The user name can contain only digits, letters, and underscores.';
                    return false;
                } else {
                    return true;
                }
            }
        }, message: ''
    }
}) 
