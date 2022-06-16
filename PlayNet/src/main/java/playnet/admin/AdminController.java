package playnet.admin;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class AdminController extends HttpServlet {
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
		
		if(command.equals("/admin/index.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/index.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/memberList.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/memMng/memberList.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/memberView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/memMng/memberView.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/category.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/category.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/contentDetailList.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/contentDetailList.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/contentDetailInsert.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/contentDetailInsert.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/contentDetailView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/contentDetailView.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/contentsInsert.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/contentsInsert.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/contentsView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/conMng/contentsView.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/announce.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/siteMng/announce.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/announceInsert.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/siteMng/announceInsert.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/announceView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/siteMng/announceView.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/ask.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/siteMng/ask.jsp");
			rd.forward(request,response);	
		}else if(command.equals("/admin/askView.go")) {
			RequestDispatcher rd = request.getRequestDispatcher("/admin/siteMng/askView.jsp");
			rd.forward(request,response);	
		}
		
//		else if(command.equals("/admin/contentsList.go")) {
//			RequestDispatcher rd = request.getRequestDispatcher("/admin/contentsList.jsp");
//			rd.forward(request,response);	
//		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
