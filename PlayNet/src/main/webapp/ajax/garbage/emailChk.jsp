<%@page import="org.json.simple.*"%>
<%@page import="playnet.Vo.ContentsVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	String Email = "";
		
	if(request.getParameter("Email") != null){
		Email = request.getParameter("Email");
	}
	
	UserMethods UM = new UserMethods();
	
	int result = UM.EmailChk(Email);	
	
	JSONArray array = new JSONArray();
	JSONObject obj = new JSONObject();
	obj.put("emailChk",result);
	array.add(obj);
	
	out.print(array.toJSONString());
%>