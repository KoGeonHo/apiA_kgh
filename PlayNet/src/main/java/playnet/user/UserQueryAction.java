package playnet.user;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import playnet.Vo.MemberVo;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;


public class UserQueryAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	//user페이지에서 사용할 method들을 사용하기위 한 UserMethods 생성
	UserMethods UM = new UserMethods();
  
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//인코딩 설정
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		//전체 url 추출
		String uri = request.getRequestURI();
		//프로젝트이름 추출
		String pj = request.getContextPath();
		//프로젝트 이름을 제외한 나머지 가상경로 추출
		String command = uri.substring(pj.length());
		
		int result = 0;
		
		PrintWriter out = response.getWriter(); //인코딩 설정후에 PrintWriter 선언하기.
		HttpSession session  = request.getSession();
				
		//String prePage;
		String path = request.getContextPath();
		
		if(command.equals("/user/join.ok")) {					//회원가입 처리 	
			String mname = request.getParameter("mName");
			String email = request.getParameter("email");
			String pwd = request.getParameter("pwd");
			
			result = UM.joinOk(mname,email,pwd);
			
			if(result == 1) {
				out.println("<script>alert('정상 처리 되었습니다.'); location.href='"+path+"/user/Login.go';</script>");
			}else {
				out.println("<script>alert('가입실패'); history.back();</script>");
			}
		}else if(command.equals("/user/login.ok")) {			//로그인 처리 / 접속로그 기록
			String email = request.getParameter("email");
			String pwd = request.getParameter("pwd");
			
			MemberVo member = new MemberVo();
			member = UM.LoginOk(email, pwd);
			
			int midx = (int)member.getMidx();
			String isAdmin = (String)member.getIsAdmin();
			
			//midx가 0 : 입력한 이메일로 가입된 데이터가 없음
			// -1 : 비밀번호 불일치.
			// else : 0,-1 이외에는 midx값을 리턴하여 세션처리
			if(midx == 0) {
				out.println("<script>alert('가입되지 않은 이메일 주소 입니다.'); location.href='/PlayNet/user/Login.go';</script>");
			}else if(midx == -1) {
				out.println("<script>alert('비밀번호가 일치하지 않습니다.'); location.href='/PlayNet/user/Login.go';</script>");
			}else {
				session.setMaxInactiveInterval(60*60);
				session.setAttribute("midx",midx);
				session.setAttribute("isAdmin",isAdmin);
				//out.println("<script>alert('로그인 성공');</script>");
				//System.out.println(isAdmin);
				
				//isAdmin이 N이면 유저 Y면 admin
				if(isAdmin.equals("N")) {
					out.println("<script>location.href='"+path+"/user/index.go';</script>");
				}else {
					out.println("<script>location.href='"+path+"/admin/index.go';</script>");
				}
			}
		}else if(command.equals("/user/announceView.ok")) {
			int anidx = Integer.parseInt(request.getParameter("anidx"));
			//System.out.println(anidx);
			UM.cntHit(anidx);
			
			out.println("<script>location.href='"+path+"/user/announceView.go?anidx="+anidx+"';</script>");
		}else if(command.equals("/user/askInsert.ok")) {
			String title = request.getParameter("title");
			String attach = request.getParameter("attach");
			String content = request.getParameter("content");
			
			
			//System.out.println(title); 
			//System.out.println(attach);
			//System.out.println(content);
			
			result = UM.askInsert(title,(int)session.getAttribute("midx"),attach,content);
			
			//System.out.println(result);
			
			if(result == 1) {
				out.println("<script>alert('정상 처리되었습니다.'); location.href='"+path+"/user/ask.go';</script>");
			}else {
				out.println("<script>alert('입력 실패'); history.back();</script>");
			}
			
		}else if(command.equals("/user/logout.ok")) {
			session.invalidate();
			out.println("<script>location.href='"+path+"/user/Login.go';</script>");
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
