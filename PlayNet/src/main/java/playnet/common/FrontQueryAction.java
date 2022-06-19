package playnet.common;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import playnet.admin.AdminQueryAction;
import playnet.user.UserQueryAction;

import java.io.IOException;

public class FrontQueryAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//인코딩 설정
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String uri = request.getRequestURI();
		//프로젝트이름 추출
		String pj = request.getContextPath();
		//프로젝트 이름을 제외한 나머지 가상경로 추출
		String command = uri.substring(pj.length());
		
		String[] subPath = command.split("/");
		String location = subPath[1];// /user/join.Ok에서 user를 추출
		
				
		if(location.equals("user")) {			
			UserQueryAction UQA = new UserQueryAction();
			UQA.doGet(request,response);
		}else if(location.equals("admin")) {
			AdminQueryAction AQA = new AdminQueryAction();
			AQA.doGet(request,response);
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
