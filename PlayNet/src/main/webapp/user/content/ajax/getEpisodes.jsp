
<%@page import="org.json.simple.*"%>
<%@page import="playnet.Vo.ContentsVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="playnet.user.UserMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	int cdidx = 0;
	int season = 0;	

	cdidx = Integer.parseInt(request.getParameter("cdidx"));
	season = Integer.parseInt(request.getParameter("season"));


	UserMethods UM = new UserMethods();
	
	ArrayList<ContentsVo> eList = UM.selEpisodes(cdidx,season);
	
	JSONArray array = new JSONArray();
	for(ContentsVo CV : eList){
		JSONObject obj = new JSONObject();
		obj.put("thumbNail",CV.getThumbNail());
		obj.put("cidx",CV.getCIdx());
		obj.put("title",CV.getTitle());
		obj.put("description",CV.getDescription());
		array.add(obj);
	}
	
	out.print(array.toJSONString());
%>