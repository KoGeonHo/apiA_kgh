package playnet.admin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;





public class AdminQueryAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	AdminMethods AM = new AdminMethods();
   
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
		
		
		PrintWriter out = response.getWriter(); //인코딩 설정후에 PrintWriter 선언하기.
		HttpSession session  = request.getSession();
		
		int result = 0;
		 //이전페이지의 URL을 가져온다
		
		//String prePage;
		String path = request.getContextPath();
		
		
		if(command.equals("/admin/cateInsert.ok")) {  //카테고리 입력
			
			String name = request.getParameter("name");
			int parent = Integer.parseInt(request.getParameter("cateParent"));
			String isUse = request.getParameter("isUse");
			


			result = AM.insertCate(name, parent, isUse);
			 
			if(result != 0) {
				 out.println("<script>alert('등록되었습니다.'); location.href='"+request.getContextPath()+"/admin/category.go';</script>"); 
			}else {
				out.println("<script>alert('등록 실패.');</script>");
			}
				 
						
		}else if(command.equals("/admin/cateModify.ok")) {  //카테고리 수정
			
			int cateIdx =  Integer.parseInt(request.getParameter("cateIdx"));
			String name = request.getParameter("name");
			int parent = Integer.parseInt(request.getParameter("cateParent"));
			String isUse = request.getParameter("isUse");
			
			
			result = AM.modifyCate(cateIdx,name, parent, isUse);
			 
			if(result != 0) {
				out.println("<script>alert('수정되었습니다.'); location.href='"+request.getContextPath()+"/admin/category.go';</script>"); 
			}else {
				out.println("<script>alert('수정 실패.');</script>");
			}
			
		}else if(command.equals("/admin/contentDetailInsert.ok")) {
			
			String realPath = request.getServletContext().getRealPath("images/poster");
			File dir = new File(realPath);
			if (!dir.exists()) {
				dir.mkdirs();
			}
					
			// 파일크기 제한 설정 (15mb)
			int sizeLimit = 20 * 1024 * 1024;

			// MultipartRequest 객체를 생성하면 파일 업로드 수행
			MultipartRequest multi = new MultipartRequest(request, realPath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());
			
			String title = multi.getParameter("title");
			int cate1 = Integer.parseInt(multi.getParameter("cate1"));
			int cate2 = Integer.parseInt(multi.getParameter("cate2"));
			String isRelease = multi.getParameter("isRelease");
			String isSeries = multi.getParameter("isSeries");
			String releaseSdate = multi.getParameter("rSdate");
			String releaseEdate = multi.getParameter("rEdate");
			String casting = multi.getParameter("casting");
			String key_word = multi.getParameter("key_word");
			
			String poster1 = multi.getFilesystemName("image1");
			String poster2 = multi.getFilesystemName("image2");
			String poster3 = multi.getFilesystemName("image3");
			String poster4 = multi.getFilesystemName("image4");
			String poster5 = multi.getFilesystemName("image5");
			
//			if(poster1 == null) { poster1 = ""; }
//			if(poster2 == null) { poster2 = ""; }
//			if(poster3 == null) { poster3 = ""; }
//			if(poster4 == null) { poster4 = ""; }
//			if(poster5 == null) { poster5 = ""; }
			
			String description = multi.getParameter("description");
			
			result = AM.insertConDetail(title, cate1, cate2, casting, key_word, poster1, poster2, poster3, poster4, poster5, description, isRelease, releaseSdate, releaseEdate,isSeries);
			
			if(result != 0) {
				//System.out.println("성공");
				out.println("<script>alert('입력되었습니다.'); location.href='"+request.getContextPath()+"/admin/contentDetailList.go';</script>"); 
			}else {
				//System.out.println("실패");
				out.println("<script>alert('입력 실패.'); history.back();</script>");
			}
			
		}else if(command.equals("/admin/contentDetailModify.ok")) {
			int cdidx = Integer.parseInt(request.getParameter("cdidx"));
			String title = request.getParameter("title");
			int cate1 = Integer.parseInt(request.getParameter("cate1"));
			int cate2 = Integer.parseInt(request.getParameter("cate2"));
			String isRelease = request.getParameter("isRelease");
			String isSeries = request.getParameter("isSeries");
			String releaseSdate = request.getParameter("rSdate");
			String releaseEdate = request.getParameter("rEdate");
			String casting = request.getParameter("casting");
			String key_word = request.getParameter("key_word");		
			String description = request.getParameter("description");
			
			result = AM.ModifyConDetail(cdidx, title, cate1, cate2, isRelease, releaseSdate, releaseEdate, casting, key_word, description, isSeries);
			
					
			//System.out.println(result);
			
			if(result != 0) {
				//System.out.println("성공");
				out.println("<script>alert('수정되었습니다.'); location.href='"+request.getContextPath()+"/admin/contentDetailView.go?CdIdx="+cdidx+"&tab=1';</script>"); 
			}else {
				//System.out.println("실패");
				out.println("<script>alert('수정 실패.'); history.back();</script>");
			}
			
		}else if(command.equals("/admin/contentsInsert.ok")) {
			
			String realPath = request.getServletContext().getRealPath("images/thumbNails");
			File dir = new File(realPath);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			
			// 파일크기 제한 설정 (15mb)
			int sizeLimit = 20 * 1024 * 1024;

			// MultipartRequest 객체를 생성하면 파일 업로드 수행
			MultipartRequest multi = new MultipartRequest(request, realPath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());
			
			// 업로드한 파일명 가져오기
			String thumbNail = multi.getFilesystemName("thumbNail");			
			
			int CdIdx = Integer.parseInt(multi.getParameter("CdIdx"));
			String title = multi.getParameter("title");
			int division = Integer.parseInt(multi.getParameter("division"));
			int season = Integer.parseInt(multi.getParameter("season"));
			int episode = Integer.parseInt(multi.getParameter("episode"));
			String releaseDate = multi.getParameter("releaseDate");
			String contentsUrl = multi.getParameter("contentsUrl");
			int runMin = Integer.parseInt(multi.getParameter("runMin"));
			int runSec = Integer.parseInt(multi.getParameter("runSec"));
			String description = multi.getParameter("description");
			
			result = AM.contentsInsert(CdIdx, title, division, season, episode, releaseDate, contentsUrl, runMin, runSec, description, thumbNail);
			
			if(result != 0) {
				//System.out.println("성공");
				out.println("<script>alert('입력되었습니다.'); location.href='"+request.getContextPath()+"/admin/contentDetailView.go?CdIdx="+CdIdx+"&tab=2';</script>"); 
			}else {
				//System.out.println("실패");
				out.println("<script>alert('입력 실패.'); history.back();</script>");
			}
			
		}else if(command.equals("/admin/contentsModify.ok")) {
			
			int cIdx = Integer.parseInt(request.getParameter("cIdx"));
			String title = request.getParameter("title");
			int division = Integer.parseInt(request.getParameter("division"));
			int season = Integer.parseInt(request.getParameter("season"));
			int episode = Integer.parseInt(request.getParameter("episode"));
			String releaseDate = request.getParameter("releaseDate");
			String contentsUrl = request.getParameter("contentsUrl");
			int runMin = Integer.parseInt(request.getParameter("runMin"));
			int runSec = Integer.parseInt(request.getParameter("runSec"));
			String description = request.getParameter("description");
			
						
			result = AM.contentsModify(cIdx, title, division, season, episode, contentsUrl, runMin, runSec, description, releaseDate);
			
			if(result != 0) {
				out.println("<script>alert('입력되었습니다.'); location.href='"+request.getContextPath()+"/admin/contentsView.go?cidx="+cIdx+"';</script>"); 
			}else {
				out.println("<script>alert('입력 실패.'); history.back();</script>");
			}
			
			
		}else if(command.equals("/admin/contentsDel.ok")) {
			int cIdx = Integer.parseInt(request.getParameter("CIdx"));
			int CdIdx = Integer.parseInt(request.getParameter("CdIdx"));
			//System.out.println(cIdx);
			result = AM.DelContents(cIdx);
			if(result != 0) {
				out.println("<script>alert('삭제되었습니다.'); location.href='"+request.getContextPath()+"/admin/contentDetailView.go?cidx="+cIdx+"&CdIdx="+CdIdx+"&tab=2';</script>"); 
			}else {
				out.println("<script>alert('삭제 실패.'); history.back();</script>");
			}
		}else if(command.equals("/admin/announceInsert.ok")) {
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int midx = (int)session.getAttribute("midx");
			String isTop = request.getParameter("isTop");
			
			if(isTop == null) {
				isTop = "N";
			}
			result = AM.announceInsert(title,content,midx,isTop);
			
			if(result != 0) {
				out.println("<script>alert('등록되었습니다.'); location.href='"+request.getContextPath()+"/admin/announce.go';</script>"); 
			}else {
				out.println("<script>alert('등록 실패.'); history.back();</script>");
			}
			
		}else if(command.equals("/admin/announceModify.ok")) {
			int anidx = Integer.parseInt(request.getParameter("anidx"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			String isTop = request.getParameter("isTop");
			
			result = AM.modAnnounce(anidx, title, content, isTop);
			
			if(result != 0) {
				out.println("<script>alert('수정되었습니다.'); location.href='"+request.getContextPath()+"/admin/announceView.go?anidx="+anidx+"';</script>"); 
			}else {
				out.println("<script>alert('수정 실패.'); history.back();</script>");
			}
		}else if(command.equals("/admin/answer.ok")) {
			int aidx = Integer.parseInt(request.getParameter("aidx"));
			int anspn = Integer.parseInt(request.getParameter("anspn"));
			String anscontent = request.getParameter("anscontent");
			int midx = (int)session.getAttribute("midx");
			
			result = AM.Answer(aidx,anspn,anscontent,midx);
			
			if(result == 1) {
				out.println("<script>alert('처리되었습니다.'); location.href='"+request.getContextPath()+"/admin/askView.go?aidx="+aidx+"';</script>");
			}else {
				out.println("<script>alert('처리 실패.'); history.back();</script>");
			}
		}else if(command.equals("/admin/logout.ok")) {
			session.invalidate();
			//System.out.println("1234a");
			out.println("<script>location.href='"+path+"/user/Login.go';</script>");
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
