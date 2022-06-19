<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="playnet.admin.AdminMethods"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%

String realPath = request.getServletContext().getRealPath("images/poster");
File dir = new File(realPath);
if (!dir.exists()) {
	dir.mkdirs();
}
		
// 파일크기 제한 설정 (15mb)
int sizeLimit = 20 * 1024 * 1024;

// MultipartRequest 객체를 생성하면 파일 업로드 수행
MultipartRequest multi = new MultipartRequest(request, realPath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());

String poster1 = multi.getFilesystemName("poster1");
String poster2 = multi.getFilesystemName("poster2");
String poster3 = multi.getFilesystemName("poster3");
String poster4 = multi.getFilesystemName("poster4");
String poster5 = multi.getFilesystemName("poster5");

AdminMethods AM = new AdminMethods();

int cdidx = Integer.parseInt(multi.getParameter("cdIdx"));

int result = AM.PostersModify(cdidx,poster1,poster2,poster3,poster4,poster5);

JSONArray array = new JSONArray();
JSONObject obj = new JSONObject();
obj.put("result", result);
obj.put("poster1", poster1);
obj.put("poster2", poster2);
obj.put("poster3", poster3);
obj.put("poster4", poster4);
obj.put("poster5", poster5);
array.add(obj);

out.print(array.toJSONString());
%>
