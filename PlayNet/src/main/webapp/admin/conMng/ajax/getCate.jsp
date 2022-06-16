<%@page import="playnet.admin.Vo.CategoryVo"%>
<%@page import="org.json.simple.*"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int cateIdx = Integer.parseInt(request.getParameter("cateIdx"));

	AdminMethods AM = new AdminMethods();
	
	CategoryVo hm = AM.getCateInfo(cateIdx);
	
	JSONArray array = new JSONArray();
	JSONObject obj = new JSONObject();
	obj.put("cateIdx",hm.getCateIdx());
	obj.put("cateName",hm.getCateName());
	obj.put("cateParent",hm.getCateParent());
	obj.put("isUse",hm.getIsUse());
	array.add(obj);

	out.print(array.toJSONString());
%>