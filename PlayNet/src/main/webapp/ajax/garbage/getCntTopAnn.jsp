<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	
	AdminMethods AM = new AdminMethods();
	
	int cnt = AM.getCntTopAnn();
	
	out.print(cnt);
%>