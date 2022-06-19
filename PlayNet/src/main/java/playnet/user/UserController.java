package playnet.user;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserController extends HttpServlet {
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
		String location = subPath[1];// /member/login.Ok에서 member를 추출		
		
		
		if(command.equals("/user/index.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/index.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/Login.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/Login.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/joinS1.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/join/joinS1.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/findPass.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/common/findPass.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/joinS2.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/join/joinS2.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/conSearch.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/content/conSearch.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/announce.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/announce/announce.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/announceView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/announce/announceView.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/ask.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/ask/ask.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/askInsert.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/ask/askInsert.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/askView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/ask/askView.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/myPage.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/common/myPage.jsp");
			rd.forward(request,response);		
		}else if(command.equals("/user/conViewDetails.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/content/conViewDetails.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/user/player.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/user/content/player.jsp");
			rd.forward(request,response);	
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
