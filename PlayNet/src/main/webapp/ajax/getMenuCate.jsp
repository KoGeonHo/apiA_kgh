<%@page import="java.util.ArrayList"%>
<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="org.json.simple.*"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%

	UserMethods UM = new UserMethods();
	
	ArrayList<CategoryVo> cList = UM.selParentCate();
	
	JSONArray array = new JSONArray();
	for(CategoryVo CV : cList){
		JSONObject obj = new JSONObject();
		obj.put("cateIdx",CV.getCateIdx());
		obj.put("cateName",CV.getCateName());
		array.add(obj);
	}

	out.print(array.toJSONString());
%>