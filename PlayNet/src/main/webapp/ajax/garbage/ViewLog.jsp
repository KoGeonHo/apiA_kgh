<%@page import="playnet.user.UserMethods"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int cidx = Integer.parseInt(request.getParameter("cidx"));
int midx = Integer.parseInt(request.getParameter("midx"));
int min = Integer.parseInt(request.getParameter("min"));
int sec = Integer.parseInt(request.getParameter("sec"));


	UserMethods UM = new UserMethods();	
	
	int result = UM.ViewLog(cidx, midx, min, sec);
	
	out.print(result);
	
%>