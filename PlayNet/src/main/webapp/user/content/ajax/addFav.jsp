<%@page import="playnet.user.UserMethods"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int fav = Integer.parseInt(request.getParameter("fav"));
int cdidx = Integer.parseInt(request.getParameter("cdidx"));
int midx = Integer.parseInt(request.getParameter("midx"));
int result = 0;


	UserMethods UM = new UserMethods();	
	if(fav == 1){
		result = UM.addFav(cdidx,midx);
	}else if(fav == 0){
		result = UM.delFav(cdidx,midx);
	}
	
	out.print(result);
	
%>