<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int cateIdx = Integer.parseInt(request.getParameter("cateIdx"));
	
	AdminMethods AM = new AdminMethods();
	
	ArrayList<CategoryVo> childCateList = AM.selChildCate(cateIdx);
	
	JSONArray array = new JSONArray();
	for(CategoryVo category : childCateList){
		JSONObject obj = new JSONObject();
		obj.put("cateIdx",category.getCateIdx());
		obj.put("cateName",category.getCateName());
		obj.put("cateParent",category.getCateParent());
		obj.put("isUse",category.getIsUse());
		array.add(obj);
	}
	
	
	out.print(array.toJSONString());
%>