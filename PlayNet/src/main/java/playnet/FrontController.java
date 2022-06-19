package playnet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import playnet.admin.AdminController;
import playnet.user.UserController;

import java.io.IOException;


public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String uri = request.getRequestURI();
		//프로젝트이름 추출
		String pj = request.getContextPath();
		//프로젝트 이름을 제외한 나머지 가상경로 추출
		String command = uri.substring(pj.length());
		
		String[] subPath = command.split("/");
		String location = subPath[1];// /member/login.Ok에서 member를 추출
		
		request.setAttribute("path", request.getContextPath());
		
		if(location.equals("user")) {
			UserController UC = new UserController();
			UC.doGet(request,response);
		}else if(location.equals("admin")) {
			AdminController AC = new AdminController();
			AC.doGet(request,response);
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
