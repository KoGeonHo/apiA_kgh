package playnet.user;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import playnet.common.DBConn;
import playnet.Vo.AskVo;
import playnet.Vo.ContentDetailVo;
import playnet.Vo.ContentsVo;
import playnet.Vo.MemberVo;
import playnet.Vo.PlayTimeVo;
import playnet.admin.Vo.CategoryVo;

public class UserMethods {
	
	private Connection conn = null; 
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private int val = 0;
	private int cnt = 0;
	private int page_num_idx = 10;
	private int indexNum = 10;

	String sql;
	
	
	//기본생성자에서 데이터 베이스 연결 설정.
	public UserMethods() {
		DBConn dbconn = new DBConn();
		conn = dbconn.getConnection();
	} 
	
	
	//한페이지 당 노출될 페이지의 갯수
	public int getPageNumIdx() {
		return page_num_idx;
	}
	
	//indexNum(화면에 표시할 item수) getter
	public int getIndexNum() {
		return indexNum;
	}
	
	
	//회원가입 처리
	public int joinOk(String mname,String email,String pwd) {
		
		sql = "insert into member(mName,mEmail,mPwd) values(?, ?, ?)";

			System.out.println(sql);
			System.out.println(mname);
			System.out.println(email);
			System.out.println(pwd);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,mname);
			pstmt.setString(2,email);
			pstmt.setString(3,pwd);
			//System.out.println(mname);
			//System.out.println(email);
			//System.out.println(pwd);
			
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		System.out.println(val);
		return val;
	}
	
	//회원가입시 이메일 가입 여부 체크
	public int EmailChk(String Email) {
		//System.out.println(Email);
		sql = "select * from member where mEmail = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, Email);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				val = 1;												//입력받은 이메일로 가입된 계정이 있다면 1을 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	
	//입력된 이메일 비밀번호를 이용하여 로그인처리
	public MemberVo LoginOk(String email,String pwd) {
		MemberVo member = new MemberVo();
		sql = "select midx, mPwd, isadmin from member where mEmail = ?";
		
		try{
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("mPwd").equals(pwd)) {
					InsertLog(rs.getInt("midx"));
					member.setMidx(rs.getInt("midx"));
					member.setIsAdmin(rs.getString("isadmin"));
				}else {
					System.out.println("비밀번호 불일치");
					member.setMidx(-1);
				}
			}else {
				System.out.println("존재하지 않는 아이디");
				member.setMidx(0);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return member;
	}
	
	
	//회원 로그인 기록을 남기기 위한 로그인 로그 처리
	public void InsertLog(int midx) {
		sql = "insert into login_log(midx,logIp) values(?,?)";
		
		try {
			String ip = InetAddress.getLocalHost().getHostAddress();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			pstmt.setString(2, ip);
			//System.out.println(ip);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//메인페이지 인기 콘텐츠 출력을 위한 정보 가져오기
	public ArrayList<ContentDetailVo> selContentDetailPopuler(){
		ArrayList<ContentDetailVo> PopuList = new ArrayList<>();
		
		sql = "select cdidx, poster1 from contentDetail a where isRelease = 'Y' and (now() between releaseSdate and date_add(releaseEdate, interval 1 day) ) and a.cateidx in (SELECT cateidx FROM con_category WHERE isuse = 'Y')";
		
		System.out.println(sql);
		System.out.println("123");
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ContentDetailVo CDV = new ContentDetailVo();
				CDV.setCdIdx(rs.getInt("cdidx"));
				CDV.setPoster1(rs.getString("poster1"));
				PopuList.add(CDV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return PopuList;
	}
	
	
	//콘텐츠 상세정보 가져오기
	public ContentDetailVo selConDetail(int cdidx) {
		ContentDetailVo CDV = new ContentDetailVo();
		
		sql = "select * from contentDetail where cdidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				CDV.setTitle(rs.getString("title"));
				CDV.setCate1(rs.getInt("cateIdx"));
				CDV.setPoster1(rs.getString("poster1"));
				CDV.setPoster2(rs.getString("poster2"));
				CDV.setPoster3(rs.getString("poster3"));
				CDV.setPoster4(rs.getString("poster4"));
				CDV.setPoster5(rs.getString("poster5"));
				CDV.setCasting(rs.getString("casting"));
				CDV.setDescription(rs.getString("description"));
				CDV.setKeyword(rs.getString("keyword"));				
				CDV.setIsSeries(rs.getString("isseries"));				
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return CDV;
	}
	
	
	//시즌별 에피소드 가져오기
	public ArrayList<ContentsVo> selEpisodes(int cdidx,int season){
		ArrayList<ContentsVo> epList = new ArrayList<>();
		
		sql = "select * from content where cdidx = ? and season = ? and division = 2 and isdel = 'N' and releaseDate < now()";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, season);
			rs = pstmt.executeQuery();
			while(rs.next()){
				ContentsVo CV = new ContentsVo();
				CV.setCIdx(rs.getInt("cidx"));
				CV.setTitle(rs.getString("title"));
				CV.setURL(rs.getString("URL"));
				CV.setThumbNail(rs.getString("thumbnail"));
				CV.setDescription(rs.getString("Description"));
				epList.add(CV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return epList;
	}
	
	//해당 콘텐츠에 등록된 모든 콘텐츠 정보 가져오기
	public ArrayList<ContentsVo> selConAll(int cdidx){
		ArrayList<ContentsVo> conList = new ArrayList<>();
		
		sql = "select * from content where cdidx = ? and division != ? and isdel = 'N' and releaseDate < now()";
		
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, 2);
			rs = pstmt.executeQuery();
			while(rs.next()){
				ContentsVo CV = new ContentsVo();
				CV.setCIdx(rs.getInt("cidx"));
				CV.setTitle(rs.getString("title"));
				CV.setURL(rs.getString("URL"));
				CV.setThumbNail(rs.getString("thumbnail"));
				CV.setDescription(rs.getString("Description"));
				conList.add(CV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return conList;
	}
	
	//콘텐츠 정보 가져오기
	public ContentsVo selCon(int cidx) {
		ContentsVo CV = new ContentsVo();
		
		sql = "select * from content where cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				CV.setCdIdx(rs.getInt("cdidx"));
				CV.setTitle(rs.getString("title"));
				CV.setURL(rs.getString("URL"));
				CV.setRunMin(rs.getInt("runMin"));
				CV.setRunSec(rs.getInt("runSec"));
				CV.setThumbNail(rs.getString("thumbnail"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return CV;
	}
	
	//시청 기록이 존재하는지 체크
	public int ViewLogChk(int cidx,int midx) {
		//PlayTimeVo PV = new PlayTimeVo();
		sql = "select count(*) as cnt from watching where midx = ? and cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			pstmt.setInt(2, cidx);
			rs = pstmt.executeQuery();
			if(rs.next()){
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cnt;
	}
	
	//뷰로그에 기록된 시청시간 가져오기
	public PlayTimeVo getPlayTime(int midx, int cidx) {
		PlayTimeVo PV = new PlayTimeVo();
		sql = "select bmMin,bmSec from watching where midx = ? and cidx = ?";
		
		//System.out.println("123");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			pstmt.setInt(2, cidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				PV.setMin(rs.getInt("bmMin"));
				PV.setSec(rs.getInt("bmSec"));
				//System.out.println("1234");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return PV;
	}
	
	//해당 콘텐츠의 시청기록이 없다면 insertViewLog 있다면 updateViewLog 호출	
	public int ViewLog(int cidx,int midx,int wMin, int wSec) {
		
		sql = "select COUNT(*) AS cnt from watching where midx = ? and cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			pstmt.setInt(2, cidx);
			rs = pstmt.executeQuery();
			if(rs.next()){
				if(rs.getInt("cnt") == 0) {
					val = insertViewLog(cidx, midx, wMin, wSec);
				}else {
					val = updateViewLog(cidx, midx, wMin, wSec);
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	
	//시청로그 저장
	public int insertViewLog(int cidx,int midx,int wMin, int wSec) {
		
		sql = "insert into watching(cidx,midx,bmmin,bmsec,wsdate,wedate) ";
		sql += "values(?,?,?,?,now(),now())";
				
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,cidx);
			pstmt.setInt(2,midx);
			pstmt.setInt(3,wMin);
			pstmt.setInt(4,wSec);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
		
	}
	
	//시청로그 업데이트
	public int updateViewLog(int cidx,int midx,int wMin, int wSec) {
		
		sql = "update watching set bmmin = ?, bmsec = ?, wedate = now() where cidx = ? and midx = ?";
		//System.out.println("123");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,wMin);
			pstmt.setInt(2,wSec);
			pstmt.setInt(3,cidx);
			pstmt.setInt(4,midx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
		
	}
	
	
	//contentdetail 검색
	public ArrayList<ContentDetailVo> searchCon(int cate1, String key_word){
		ArrayList<ContentDetailVo> conDetailList = new ArrayList<>();
		
		sql = "select ";
		sql += "cdidx,";
		sql += "title,";
		sql += "poster1,";
		sql += "cateidx,";
		sql += "cateidx2,";
		sql += "isrelease,";
		sql += "date_format(regDate,'%Y-%m-%d') as regDate,";
		sql += "date_format(releaseSdate,'%Y-%m-%d') as releaseSdate,";
		sql += "date_format(releaseEdate,'%Y-%m-%d') as releaseEdate";
		sql += " from contentDetail where 1 = 1";
		
		//카테고리 검색
		if(cate1 != 0) {
			sql += " and cateidx = " + cate1 + " ";
		}
		/*if(cate2 != 0) {
			sql += " and cateidx2 = " + cate2 + " ";
		}
		*/
		
		//제목 검색
		/*if(!title.equals("")) {
			sql += " and title like '%"+title+"%'";
		}*/
		
	
		
		//키워드 다중 검색 split("#")로 for문으로 반목하여 쿼리 추가.
		if(!key_word.equals("")) {
			if(key_word.contains("#")) {
				String[] keywords = key_word.trim().split("#");
				//System.out.println(keywords.length);
				int index = 1;
				if(keywords.length > 2) {
					for(String key : keywords) {
						if(index > 1) {
							if(index == 2) {
								sql += " and (keyword like '%"+key+"%' ";
							}else if(keywords.length == index){
								sql += " and keyword like '%"+key+"%')";
							}else {
								sql += " and keyword like '%"+key+"%'";
							}
						}
						index++;
					}
				}else {
					sql += " and keyword like '%"+keywords[1]+"%' ";
				}
			}else {
				sql += " and keyword like '%"+key_word+"%'";
			}
		}
		sql += " and (now() between releaseSdate and date_add(releaseEdate,interval 1 day))";
		sql += " and isRelease = 'Y'";
		sql += " order by cdidx desc";
		
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ContentDetailVo cdv = new ContentDetailVo();
				cdv.setCdIdx(rs.getInt("cdidx"));
				cdv.setTitle(rs.getString("title"));
				cdv.setPoster1(rs.getString("poster1"));
				cdv.setCate1(rs.getInt("cateIdx"));
				cdv.setCate2(rs.getInt("cateIdx2"));
				conDetailList.add(cdv);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return conDetailList;
	}
	
	//부모카테고리 select 
	public ArrayList<CategoryVo> selParentCate(){
		ArrayList<CategoryVo> cList = new ArrayList<>();
		
		sql = "select cateIdx, cateName, isUse from con_category where cateparent = 0 and isUse ='Y' order by cateIdx desc";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {	
				CategoryVo category = new CategoryVo();
				category.setCateIdx(rs.getInt("cateIdx"));
				category.setCateName(rs.getString("cateName"));
				cList.add(category);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cList;
		
	}
	
	
	//카테고리 이름 가져오기
	public CategoryVo GetCateName(int cateidx) {
		sql = "select cateName from con_category where cateidx = ?";
		CategoryVo category = new CategoryVo();
		//System.out.println(cateidx);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,cateidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {	
				category.setCateName(rs.getString("cateName"));
				//System.out.println("aa");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return category;
	}
	
	
	//시청 로그 기준으로 가장 마지막에 시청한 정보 가져오기
	public int getLastEpisode(int cdidx, int midx) {
		
		int cidx = 0;
		
		sql = "SELECT cidx FROM watching WHERE wedate = ";
		sql += "(SELECT MAX(wedate) FROM watching a, content b WHERE a.cidx = b.cidx AND b.cdidx = ? AND a.midx = ? AND b.division = 2)";
		
		/*System.out.println(sql);
		System.out.println(cdidx);
		System.out.println(midx);*/
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cidx = rs.getInt("cidx");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		if(cidx == 0) {
			
			sql = "SELECT isSeries FROM contentDetail WHERE cdidx = ? ";
			
			try {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cdidx);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("isSeries").equals("Y")) {
						sql = "SELECT cidx FROM content WHERE cdidx = ? AND division = 2 AND season = 1 AND EPISODE = 1";
						
					}else {
						sql ="SELECT cidx FROM content WHERE cdidx = ? AND division = 2 desc cidx desc";
					}
					try {
						pstmt = conn.prepareStatement(sql);
						pstmt.setInt(1, cdidx);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							cidx = rs.getInt("cidx");
						}
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return cidx;
	}
	
	
	//시리즈 콘텐츠의 시즌갯수 
	public int getSeason(int cdidx) {
		int seasons = 0;
		
		sql = "select max(season) as seasons from content where cdidx = ? and isdel ='N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				seasons = rs.getInt("seasons");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return seasons;
	}
	
	
	//조회수 증가
	public void cntHit(int anidx) {
		
		sql = "select hit from announce where anidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, anidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int hit =  rs.getInt("hit");
				sql = "update announce set hit = ? where anidx = ?";
				try {
					pstmt = conn.prepareStatement(sql);
					hit += 1;
					pstmt.setInt(1, hit);
					pstmt.setInt(2, anidx);
					rs = pstmt.executeQuery();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
	//문의하기 입력
	public int askInsert(String title, int midx, String attach, String content) {
		
		sql = "insert into ask(midx,title,content,askdate,attach) ";
		sql += " values(?,?,?,now(),?)";
		
//		System.out.println(title);
//		System.out.println(midx);
//		System.out.println(attach);
//		System.out.println(content);
//		System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			pstmt.setString(2, title);
			pstmt.setString(3, content);
			pstmt.setString(4, attach);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return val;
	}
	
	//문의하기 select all
	public ArrayList<AskVo> selAskAll(int midx){
		ArrayList<AskVo> aList = new ArrayList<>();
		
		//System.out.println(midx);
		
		sql = "select aidx,midx,title,content,date_format(askdate,'%Y-%m-%d') as askdate,anspn,anscontent,ansmidx,";
		sql += "date_format(ansdate,'%Y-%m-%d') as ansdate,attach from ask where midx = ? and isdel ='N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AskVo AskV = new AskVo();
				AskV.setAidx(rs.getInt("aidx"));
				AskV.setMidx(rs.getInt("midx"));
				AskV.setTitle(rs.getString("title"));
				AskV.setContent(rs.getString("content"));
				AskV.setAskdate(rs.getString("askdate"));
				AskV.setAnspn(rs.getInt("anspn"));
				AskV.setAnscontent(rs.getString("anscontent"));
				AskV.setAnsmidx(rs.getInt("ansmidx"));
				AskV.setAnsdate(rs.getString("ansdate"));
				AskV.setAttach(rs.getString("attach"));
				aList.add(AskV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return aList;
	}
	
	//문의하기 글 갯수 count
	public int cntAsk(int midx) {
		
		sql = "select count(*) as cnt from ask where midx = ? and isdel = 'N' ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cnt;
	}
	
	//문의하기 select
	public AskVo selAsk(int aidx) {
		AskVo AskV = new AskVo();
		
		sql = "select aidx,midx,title,content,date_format(askdate,'%Y-%m-%d') as askdate,anspn,anscontent,";
		sql += "(select mName from member b where b.midx = a.midx) as Writer,";
		sql += "(select mName from member b where b.midx = a.ansmidx) as ansWriter, ansmidx,";
		sql += "date_format(ansdate,'%Y-%m-%d') as ansdate,attach from ask a where a.aidx = ? and a.isdel ='N'";
		
		//System.out.println(sql);
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, aidx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AskV.setAidx(rs.getInt("aidx"));
				AskV.setMidx(rs.getInt("midx"));
				AskV.setTitle(rs.getString("title"));
				AskV.setContent(rs.getString("content"));
				AskV.setAskdate(rs.getString("askdate"));
				AskV.setAnspn(rs.getInt("anspn"));
				AskV.setAnscontent(rs.getString("anscontent"));
				AskV.setAnsmidx(rs.getInt("ansmidx"));
				AskV.setAnsdate(rs.getString("ansdate"));
				AskV.setAttach(rs.getString("attach"));
				AskV.setAnsWriter(rs.getString("ansWriter"));
				AskV.setWriter(rs.getString("Writer"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return AskV;
	}
	

	//좋아요 추가
	public int addLike(int cdidx, int midx) {
		
		sql = "insert into con_like(cdidx,midx) values(?,?)";
		//System.out.println(cdidx+","+midx);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();;
		}
		
		return val;
	}
	
	//좋아요 삭제
	public int delLike(int cdidx, int midx) {
		
		sql ="delete from con_like where cdidx = ? and midx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	//좋아요 체크
	public int chkLike(int cdidx,int midx) {		
		sql = "select * from con_like where cdidx = ? and midx = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				val = 1;
			}else {
				val = 0;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	//관심 콘텐츠 추가
	public int addFav(int cdidx, int midx) {
		
		sql = "insert into favorite(cdidx,midx) values(?,?)";
		//System.out.println(cdidx+","+midx);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();;
		}
		
		return val;
	}
	
	
	//관심 콘텐츠 제거
	public int delFav(int cdidx, int midx) {
		
		sql ="delete from favorite where cdidx = ? and midx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	
	//관심콘텐츠 체크
	public int chkFav(int cdidx,int midx) {		
		sql = "select * from favorite where cdidx = ? and midx = ?";
		//System.out.println(cdidx);
		//System.out.println(midx);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdidx);
			pstmt.setInt(2, midx);
			rs = pstmt.executeQuery();
			//System.out.println(val);
			//System.out.println(rs.next());
			if(rs.next()) {
				val = 1;
			}else {
				val = 0;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		//System.out.println(val);
		return val;
	}
	
	
	//좋아요 콘텐츠 관리 select
	public ArrayList<ContentDetailVo> mngLiked(int midx){
		ArrayList<ContentDetailVo> cdList = new ArrayList<>();
		sql = "select * from contentDetail a where cdidx in (select cdidx from con_like where midx = ?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return cdList;
		
	}
}






