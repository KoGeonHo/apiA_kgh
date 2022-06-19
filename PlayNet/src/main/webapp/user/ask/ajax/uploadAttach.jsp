<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%

String realPath = request.getServletContext().getRealPath("images/askAttach");
File dir = new File(realPath);
if (!dir.exists()) {
	dir.mkdirs();
}
		
// 파일크기 제한 설정 (15mb)
int sizeLimit = 20 * 1024 * 1024;

// MultipartRequest 객체를 생성하면 파일 업로드 수행
MultipartRequest multi = new MultipartRequest(request, realPath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());

String attach = multi.getFilesystemName("attach");

//out.print(attach);

JSONArray array = new JSONArray();
JSONObject obj = new JSONObject();;
obj.put("attach",attach);
array.add(obj);

out.print(array.toJSONString());
%>
