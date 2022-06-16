<%@page import="playnet.user.UserMethods"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int liked = Integer.parseInt(request.getParameter("liked"));
int cdidx = Integer.parseInt(request.getParameter("cdidx"));
int midx = Integer.parseInt(request.getParameter("midx"));
int result = 0;


	UserMethods UM = new UserMethods();	
	if(liked == 1){
		result = UM.addLike(cdidx,midx);
	}else if(liked == 0){
		result = UM.delLike(cdidx,midx);
	}
	
	out.print(result);
	
%>