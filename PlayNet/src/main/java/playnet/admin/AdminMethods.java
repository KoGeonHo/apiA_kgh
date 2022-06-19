package playnet.admin;

import java.sql.*;
import java.util.ArrayList;

import playnet.common.DBConn;
import playnet.Vo.*;
import playnet.admin.Vo.*;

public class AdminMethods {

	//상수 선언.
	private Connection conn = null; 
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private int val = 0;
	private String sql;
	private int indexNum = 10; //한페이지에 노출할 item의 갯수
	private int con_indexNum = 16; //contentDetailList의 페이지당 노출할 item갯수
	private int page_num_idx = 10; //한페이지에 노출할 페이지 번호의 갯수
	private int cnt = 0;
	
	//기본 생성자 데이터베이스 연결(DBConn)설정
	public AdminMethods() {
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
	
	//memberVo에 회원정보 저장하여 리턴
	public ArrayList<MemberVo> MemberList(String mName,String mEmail,String jDate1,String jDate2,int pageNum,String isadmin){

		ArrayList<MemberVo> memberList = new ArrayList<>();
		
		sql = "select midx,mName,mEmail,DATE_FORMAT(jDate, '%Y-%m-%d') as jDate,isadmin from member ";
		sql += "where isDel = 'N' ";
		
		
		if(!mName.equals("")) {
			sql += " and LOWER(mName) like '%"+mName.toLowerCase()+"%' ";
		}
		
		if(!mEmail.equals("")) {
			sql += " and LOWER(mEmail) like '%"+mEmail.toLowerCase()+"%' ";
		}
		
		if(!jDate1.equals("") && !jDate2.equals("")) {
			sql += " and jDate between '"+jDate1+"' and DATE_ADD(DATE_FORMAT('"+jDate2+"','%Y-%m-%d'),INTERVAL 1 day) ";
		}else if(!jDate1.equals("") && jDate2.equals("")) {
			sql += " and jDate  > '"+jDate1+"' ";
		}else if(jDate1.equals("") && !jDate2.equals("")) {			
			sql += " and jDate  < DATE_ADD(DATE_FORMAT('"+jDate2+"','%Y-%m-%d'),INTERVAL 1 day) ";
		}
		
		if(!isadmin.equals("")) {
			sql += " and isadmin = '"+isadmin+"'";
		}


		sql += "order by midx desc limit ?,?";
		
		
		//System.out.println(sql);
		//System.out.println((pageNum-1)*indexNum);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ((pageNum-1)*indexNum));
			pstmt.setInt(2, indexNum);
			//System.out.println(((pageNum-1)*indexNum)+indexNum);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				MemberVo memList = new MemberVo();
				memList.setMidx(rs.getInt("midx"));
				memList.setmName(rs.getString("mName"));
				memList.setmEmail(rs.getString("mEmail"));
				memList.setjDate(rs.getString("jDate"));
				memList.setIsAdmin(rs.getString("isadmin"));
				memberList.add(memList);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return memberList;
		
	}
	
	
	public MemberVo selMember(int midx) {
		MemberVo MV = new MemberVo();
		
		sql ="select midx,mEmail,mName,DATE_FORMAT(jdate,'%Y-%m-%d') as jDate, isadmin from member where midx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, midx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				MV.setMidx(rs.getInt("midx"));
				MV.setmName(rs.getString("mName"));
				MV.setmEmail(rs.getString("mEmail"));
				MV.setjDate(rs.getString("jDate"));
				MV.setIsAdmin(rs.getString("isadmin"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return MV;
	}
	
	
	
	//총 회원수 COUNT
	public int CountMemberList(String mName,String mEmail,String jDate1,String jDate2,String isadmin) {

		int cnt = 0;
		
		sql = " select count(*) as cntMem from member ";
		sql += " where isDel = 'N' ";
		
		if(!mName.equals("")) {
			sql += " and LOWER(mName) like '%"+mName.toLowerCase()+"%' ";
		}
		
		if(!mEmail.equals("")) {
			sql += " and LOWER(mEmail) like '%"+mEmail.toLowerCase()+"%' ";
		}
		
		if(!jDate1.equals("") && !jDate2.equals("")) {
			sql += " and jDate between '"+jDate1+"' and DATE_ADD(DATE_FORMAT('"+jDate2+"','%Y-%m-%d'),INTERVAL 1 day) ";
		}else if(!jDate1.equals("") && jDate2.equals("")) {
			sql += " and jDate  > '"+jDate1+"' ";
		}else if(jDate1.equals("") && !jDate2.equals("")) {			
			sql += " and jDate  < DATE_ADD(DATE_FORMAT('"+jDate2+"','%Y-%m-%d'),INTERVAL 1 day) ";
		}
		
		if(!isadmin.equals("")) {
			sql += " and isadmin = '"+isadmin+"'";
		}
		
		//System.out.println(sql);
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cntMem");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cnt;
		
	}
	
	
	
	//카테고리 테이블 insert
	public int insertCate(String name, int parentIdx, String isUse) {
		
		sql = "insert into con_category(cateName,CateParent,isUse) values(?,?,?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, parentIdx);
			pstmt.setString(3, isUse);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}		
		
		return val;
	}
	
	//부모카테고리 select 
	public ArrayList<CategoryVo> selParentCate(){
		ArrayList<CategoryVo> cList = new ArrayList<>();
		
		sql = "select cateIdx, cateName, isUse from con_category where cateparent = 0 ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {	
				CategoryVo category = new CategoryVo();
				category.setCateIdx(rs.getInt("cateIdx"));
				category.setCateName(rs.getString("cateName"));
				category.setIsUse(rs.getString("isUse"));
				cList.add(category);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cList;
		
	}
	
	//자식카테고리 select 
	public ArrayList<CategoryVo> selChildCate(int cateIdx){
		ArrayList<CategoryVo> cList = new ArrayList<>();
		
		sql = "select cateIdx, cateName, isUse from con_category where cateparent = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cateIdx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CategoryVo category = new CategoryVo(); 
				category.setCateIdx(rs.getInt("cateIdx"));
				category.setCateName(rs.getString("cateName"));
				category.setIsUse(rs.getString("isUse"));
				cList.add(category);				
			}			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cList;
		
	}
	
	//카테고리 수정시 카테고리 번호(cateIdx)를 넘겨받아 카테고리 정보 리턴
	public CategoryVo getCateInfo(int cateIdx){
		CategoryVo category = new CategoryVo();
		
		sql = "select * from con_category where cateIdx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cateIdx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				category.setCateIdx(rs.getInt("cateIdx"));
				category.setCateName(rs.getString("cateName"));
				category.setCateParent(rs.getInt("cateParent"));
				category.setIsUse(rs.getString("isUse"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return category;
	}
	
	//카테고리 수정 
	public int modifyCate(int cateIdx,String name, int parentIdx, String isUse) {
		
		sql = "update con_category set cateName = ?, cateParent = ?, isUse = ? where cateIdx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, parentIdx);
			pstmt.setString(3, isUse);
			pstmt.setInt(4, cateIdx);
			
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}		
		
		return val;
	}
	
	//contentDetail insert
	public int insertConDetail(String title, int cateidx1, int cateidx2, String casting, String key_word, String poster1,
			String poster2, String poster3, String poster4, String poster5, String description, String isRelease,
			String releaseSdate, String releaseEdate,String isSeries) {

		sql = "insert into contentDetail(";
		sql += "title,";
		sql += "cateidx,";
		sql += "cateidx2,";
		sql += "casting,";
		sql += "keyword,";
		sql += "description,";
		sql += "poster1,";
		sql += "poster2,";
		sql += "poster3,";
		sql += "poster4,";
		sql += "poster5,";
		sql += "isrelease,";
		sql += "releaseSdate,";
		sql += "releaseEdate, ";
		sql += "isSeries)";
		sql += " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		//System.out.println(sql);
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,title);
			pstmt.setInt(2,cateidx1);
			pstmt.setInt(3,cateidx2);
			pstmt.setString(4,casting);
			pstmt.setString(5,key_word);
			pstmt.setString(6,description);
			pstmt.setString(7,poster1);
			pstmt.setString(8,poster2);
			pstmt.setString(9,poster3);
			pstmt.setString(10,poster4);
			pstmt.setString(11,poster5);
			pstmt.setString(12,isRelease);
			pstmt.setString(13,releaseSdate);
			pstmt.setString(14,releaseEdate);
			pstmt.setString(15,isSeries);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		//System.out.println(val);
		return val;
	}
	
	public int getConIndexNum() {
		return con_indexNum;
	}
	
	//검색 키워드를 입력, 키워드 값이 없으면 전체를, 있다면 검색하여 해당 키워드를 가진 데이터를 검색.
	public ArrayList<ContentDetailVo> selContentDetailAll(int pageNum,int cate1, int cate2,String title,String sDate,String eDate,String key_word,String isRelease){
		ArrayList<ContentDetailVo> conDetailList = new ArrayList<>();
		
		sql = "select ";
		sql += "cdidx,";
		sql += "title,";
		sql += "poster1,";
		sql += "cateidx,";
		sql += "cateidx2,";
		sql += "isrelease,";
		sql += "date_format(regDate,'%Y-%m-%d') as istDate,";
		sql += "date_format(releaseSdate,'%Y-%m-%d') as releaseSdate,";
		sql += "date_format(releaseEdate,'%Y-%m-%d') as releaseEdate";
		sql += " from contentDetail where 1 = 1";
		
		//카테고리 검색
		if(cate1 != 0) {
			sql += " and cateidx = " + cate1 + " ";
		}
		if(cate2 != 0) {
			sql += " and cateidx2 = " + cate2 + " ";
		}
		
		
		//제목 검색
		if(!title.equals("")) {
			sql += " and title like '%"+title+"%'";
		}
		
		//등록일 검색
		if(!sDate.equals("") && !eDate.equals("")) {
			sql += " and regDate between '"+sDate+"' and DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), iterval 1 day)";
		}else if(!sDate.equals("") && eDate.equals("")) {
			sql += " and regDate > '"+sDate+"'";
		}else if(sDate.equals("") && !eDate.equals("")) {
			sql += " and regDate < DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), iterval 1 day)";
		}
		
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
		
		//공개여부 검색
		//System.out.println(isRelease);
		if(!isRelease.equals("")) {
			sql += " and isRelease = '"+isRelease+"'";
		}
		
		sql += " order by cdidx desc limit ?,?";
		
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ((pageNum-1)*con_indexNum));
			pstmt.setInt(2, con_indexNum);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ContentDetailVo cdv = new ContentDetailVo();
				cdv.setCdIdx(rs.getInt("cdidx"));
				cdv.setTitle(rs.getString("title"));
				cdv.setPoster1(rs.getString("poster1"));
				cdv.setCate1(rs.getInt("cateIdx"));
				cdv.setCate2(rs.getInt("cateIdx2"));
				cdv.setIstDate(rs.getString("istDate"));
				cdv.setIsRelease(rs.getString("isRelease"));
				cdv.setrSdate(rs.getString("releaseSdate"));
				cdv.setrEdate(rs.getString("releaseEdate"));
				conDetailList.add(cdv);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return conDetailList;
	}
	
	
	//CdIdx를 입력받아 해당 CdIdx를 가진 contentDetail 정보를 불러옴.
	public ContentDetailVo selContentDetail(int CdIdx) {
		ContentDetailVo cdv = new ContentDetailVo();
		
		sql = "select title, cateidx, cateidx2, isRelease, isSeries, date_format(releaseSdate,'%Y-%m-%d') as rSdate,";
		sql += " date_format(releaseEdate,'%Y-%m-%d') as rEdate, casting, keyword, poster1, poster2, poster3, poster4, poster5, description ";
		sql += " from contentDetail where cdidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, CdIdx);
			rs = pstmt.executeQuery();
			
			//System.out.println(CdIdx);
			if(rs.next()) {
				cdv.setTitle(rs.getString("title"));
				cdv.setCate1(rs.getInt("cateidx"));
				cdv.setCate2(rs.getInt("cateidx2"));
				cdv.setIsRelease(rs.getString("isRelease"));
				cdv.setIsSeries(rs.getString("isSeries"));
				cdv.setrSdate(rs.getString("rSdate"));
				cdv.setrEdate(rs.getString("rEdate"));
				cdv.setCasting(rs.getString("casting"));
				cdv.setKeyword(rs.getString("keyword"));
				cdv.setPoster1(rs.getString("poster1"));
				cdv.setPoster2(rs.getString("poster2"));
				cdv.setPoster3(rs.getString("poster3"));
				cdv.setPoster4(rs.getString("poster4"));
				cdv.setPoster5(rs.getString("poster5"));
				cdv.setDescription(rs.getString("description"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cdv;
	}
	
	
	//ContentDetail count
	public int CntContentDetail(int cate1, int cate2,String title,String sDate,String eDate,String key_word,String isRelease) {
		
		sql = "select count(*) as count from contentDetail where 1 = 1 ";
		
		//카테고리 검색
		if(cate1 != 0) {
			sql += " and cateidx = " + cate1 + " ";
		}
		if(cate2 != 0) {
			sql += " and cateidx2 = " + cate2 + " ";
		}
		//제목 검색
		if(!title.equals("")) {
			sql += " and title like '%"+title+"%'";
		}
		
		//등록일 검색
		if(!sDate.equals("") && !eDate.equals("")) {
			sql += " and regDate between '"+sDate+"' and DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}else if(!sDate.equals("") && eDate.equals("")) {
			sql += " and regDate > '"+sDate+"'";
		}else if(sDate.equals("") && !eDate.equals("")) {
			sql += " and regDate < DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}
		
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
		
		//공개여부 검색
		if(!isRelease.equals("")) {
			sql += " and isRelease = '"+isRelease+"'";
		}
		
		
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("count");
				//System.out.println(cnt);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cnt;
	}
	
	//ContentDetail 수정
	public int ModifyConDetail(int CdIdx, String title, int cate1, int cate2, String isRelease, String rSdate, String rEdate, String casting, String keyword, String description,String isSeries) {
		
		sql = "update contentDetail set ";
		
		sql += "title = ? ,";
		sql += "cateIdx = ? ,";
		sql += "cateIdx2 = ? ,";
		sql += "isrelease = ? ,";
		sql += "releaseSdate = ? ,";
		sql += "releaseEdate = ? ,";
		sql += "casting = ? ,";
		sql += "keyword = ? ,";
		sql += "description = ? ,";
		sql += "isSeries = ?";
		
		sql += " where cdidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setInt(2, cate1);
			pstmt.setInt(3, cate2);
			pstmt.setString(4, isRelease);
			pstmt.setString(5, rSdate);
			pstmt.setString(6, rEdate);
			pstmt.setString(7, casting);
			pstmt.setString(8, keyword);
			pstmt.setString(9, description);
			pstmt.setString(10, isSeries);
			pstmt.setInt(11, CdIdx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return val;
	}
	
	//content Insert
	public int contentsInsert(int CdIdx,String title,int division, int season, int episode,String releaseDate, String contentsUrl, int runMin, int runSec, String description, String ThumbNail) {
		
		sql = "insert into content(";
		sql += "cdidx, ";
		sql += "title, ";
		sql += "division, ";
		sql += "season, ";
		sql += "episode, ";
		sql += "releasedate, ";
		sql += "URL, ";
		sql += "runmin, ";
		sql += "runsec,";
		sql += "description, ";
		sql += "thumbNail)";
		sql += " values(?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, CdIdx);
			pstmt.setString(2,title);
			pstmt.setInt(3, division);
			pstmt.setInt(4, season);
			pstmt.setInt(5, episode);
			pstmt.setString(6, releaseDate);
			pstmt.setString(7, contentsUrl);
			pstmt.setInt(8, runMin);
			pstmt.setInt(9, runSec);
			pstmt.setString(10, description);
			pstmt.setString(11, ThumbNail);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	//해당 cdidx를 가진 콘텐츠를 가져옴
	public ArrayList<ContentsVo> selContentsAll(int CdIdx){
		ArrayList<ContentsVo> conList = new ArrayList<>();
		
		sql = "select CIDX, CDIDX, TITLE, DIVISION, SEASON, EPISODE, URL, RUNMIN, RUNSEC, THUMBNAIL, DESCRIPTION,";
		sql += " date_format(releaseDate,'%Y-%m-%d') as releaseDate from content";
		
		/* 조건문 들어갈 자리.(예비) */
		
		sql += " where CdIdx = ? and isDel = 'N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, CdIdx);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ContentsVo CV = new ContentsVo();
				CV.setCIdx(rs.getInt("cIdx"));
				CV.setCdIdx(rs.getInt("CdIdx"));
				CV.setTitle(rs.getString("title"));
				CV.setDivision(rs.getInt("division"));
				CV.setSeason(rs.getInt("season"));
				CV.setEpisode(rs.getInt("episode"));
				CV.setURL(rs.getString("URL"));
				CV.setRunMin(rs.getInt("runMin"));
				CV.setRunSec(rs.getInt("runSec"));
				CV.setThumbNail(rs.getString("Thumbnail"));
				CV.setDescription(rs.getString("description"));
				CV.setReleaseDate(rs.getString("releaseDate"));
				conList.add(CV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return conList;
	}
	
	//콘텐츠 개수 구하기
	public int CountContents(int CdIdx) {

		sql = "select count(*) as cnt from content ";
		sql += " where CdIdx = ? and isdel = 'N'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, CdIdx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cnt;
	}
	
	//content 정보 추출
	public ContentsVo selContents(int Cidx) {
		ContentsVo CV = new ContentsVo();
		
		sql = "select CIdx,";
		sql += " CdIdx,";
		sql += " title,";
		sql += " division,";
		sql += " season,";
		sql += " episode,";
		sql += " URL,";
		sql += " runMin,";
		sql += " runSec,";		
		sql += " description,";
		sql += " date_format(releaseDate,'%Y-%m-%d') as releaseDate,";
		sql += " Thumbnail ";
		sql += "from content where cidx = ?";
		
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Cidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				CV.setCIdx(rs.getInt("CIdx"));
				CV.setCdIdx(rs.getInt("CdIdx"));
				CV.setTitle(rs.getString("title"));
				CV.setDivision(rs.getInt("division"));
				CV.setSeason(rs.getInt("season"));
				CV.setEpisode(rs.getInt("episode"));
				CV.setURL(rs.getString("URL"));
				CV.setRunMin(rs.getInt("runMin"));
				CV.setRunSec(rs.getInt("runSec"));
				CV.setThumbNail(rs.getString("Thumbnail"));
				CV.setDescription(rs.getString("description"));
				CV.setReleaseDate(rs.getString("releaseDate"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return CV;
		
	}
	
	
	//content 수정
	public int contentsModify(int cIdx,String title,int division,int season,int episode,String URL,int runMin,int runSec,String description,String releaseDate) {
		
		sql = "update content set ";
		sql += " title = ?,";
		sql += " division = ?,";
		sql += " season = ?,";
		sql += " episode = ?,";
		sql += " URL = ?,";
		sql += " runmin = ?,";
		sql += " runsec = ?,";
		sql += " description = ?,";
		sql += " releaseDate = ?";
		sql += " where cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setInt(2, division);
			pstmt.setInt(3, season);
			pstmt.setInt(4, episode);
			pstmt.setString(5, URL);
			pstmt.setInt(6, runMin);
			pstmt.setInt(7, runSec);
			pstmt.setString(8, description);
			pstmt.setString(9, releaseDate);
			pstmt.setInt(10, cIdx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	//content 삭제
	public int DelContents(int cIdx) {
		
		sql = "update content set isDel = 'Y' where cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cIdx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	
	//content 썸네일 수정
	public int ThumbNailModify(int cIdx, String ThumbNail) {
		
		sql = "update content set thumbnail = ? where cidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, ThumbNail);
			pstmt.setInt(2, cIdx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return val;
	}
	
	
	//ContentDetial 포스터 수정
	public int PostersModify(int cdIdx, String poster1, String poster2, String poster3, String poster4, String poster5) {
		
	
		sql = "update contentDetail set ";
		if(poster1!=null) {
			sql += " poster1 = '" + poster1 + "'";
			cnt++;
		}
		if(poster2!=null) {
			if(cnt > 0) {
				sql += " , ";
			}
			sql += " poster2 = '" + poster2 + "'";
			cnt++;
		}
		if(poster3!=null) {
			if(cnt > 0) {
				sql += " , ";
			}
			sql += " poster3 = '" + poster3 + "'";
			cnt++;
		}
		if(poster4!=null) {
			if(cnt > 0) {
				sql += " , ";
			}
			sql += " poster4 = '" + poster4 + "'";
			cnt++;
		}
		if(poster5!=null) {
			if(cnt > 0) {
				sql += " , ";
			}
			sql += " poster5 = '" + poster5 + "'";
			cnt++;
		}
	
		sql += " where cdidx = ?";
		//System.out.println(cdIdx);
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cdIdx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return val;
	}
	
	
	//공지사항 insert
	public int announceInsert(String title,String content,int midx,String isTop) {
		
		sql = "insert into announce(title,content,midx,isTop) values(?,?,?,?)";
		
		if(isTop == null) {
			isTop = "N";
		}
		
		System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setInt(3, midx);
			pstmt.setString(4, isTop);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return val;		
		
	}
	
	//공지사항 selectAll
	public ArrayList<AnnounceVo> selAnnounceAll(String title,String content,String sDate,String eDate,int pageNum){
		ArrayList<AnnounceVo> aList = new ArrayList<>();
		
		sql = "select anidx,midx,(select mname from member b where b.midx = a.midx) as writer,title,content,istop,DATE_FORMAT(wdate,'%Y-%m-%d') as wDate,hit from announce a where isdel = 'N' ";
		
		
		if(!title.equals("")) {
			sql += " and title like '%"+title+"%' ";
		}
		
		if(!content.equals("")) {
			sql += " and content like '%"+content+"%' ";
		}
		
		if(!sDate.equals("") && !eDate.equals("")) {
			sql += " and wDate between '"+sDate+"' and DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}else if(!sDate.equals("") && eDate.equals("")) {
			sql += " and wDate > '"+sDate+"'";
		}else if(sDate.equals("") && !eDate.equals("")) {
			sql += " and wDate < DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}
		
		sql +=" order by anidx desc limit ?,?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (pageNum-1)*indexNum);
			pstmt.setInt(2, indexNum);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AnnounceVo AnV = new AnnounceVo();
				AnV.setAnidx(rs.getInt("anidx"));
				AnV.setMidx(rs.getInt("midx"));
				AnV.setTitle(rs.getString("title"));
				AnV.setContent(rs.getString("content"));
				AnV.setIsTop(rs.getString("istop"));
				AnV.setwDate(rs.getString("wDate"));
				AnV.setHit(rs.getInt("hit"));
				AnV.setWriter(rs.getString("writer"));
				aList.add(AnV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return aList;
		
	}
	
	//공지사항 count
	public int cntAnnounce(String title,String content,String sDate,String eDate) {
		
		sql = "select count(*) as cnt from announce where isDel = 'N' ";
		
		if(!title.equals("")) {
			sql += " and title like '%"+title+"%' ";
		}
		
		if(!content.equals("")) {
			sql += " and content like '%"+content+"%' ";
		}
		
		if(!sDate.equals("") && !eDate.equals("")) {
			sql += " and wDate between '"+sDate+"' and DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}else if(!sDate.equals("") && eDate.equals("")) {
			sql += " and wDate > '"+sDate+"'";
		}else if(sDate.equals("") && !eDate.equals("")) {
			sql += " and wDate < DATE_ADD(date_format('"+eDate+"','%Y-%m-%d'), interval 1 day)";
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cnt;
		
	}
	
	
	//상단 공지 글 가져오기
	public ArrayList<AnnounceVo> selAnnTop() {
		ArrayList<AnnounceVo> aList = new ArrayList<>();
		
		sql = "select anidx,midx,(select mname from member b where b.midx = a.midx) as writer,title,content,istop,date_format(wdate,'%Y-%m-%d') as wDate,hit from announce a where isdel = 'N' and isTop = 'Y'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				AnnounceVo AnV = new AnnounceVo();
				AnV.setAnidx(rs.getInt("anidx"));
				AnV.setMidx(rs.getInt("midx"));
				AnV.setTitle(rs.getString("title"));
				AnV.setContent(rs.getString("content"));
				AnV.setIsTop(rs.getString("istop"));
				AnV.setwDate(rs.getString("wDate"));
				AnV.setHit(rs.getInt("hit"));
				AnV.setWriter(rs.getString("writer"));
				aList.add(AnV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return aList;
	}
	
	
	//상단 고정 공지 갯수
	public int getCntTopAnn() {
		int cnt = 0;
		
		sql = "select count(*) as cnt from announce where isdel = 'N' and isTop = 'Y'";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			
		}
		
		return cnt;
	}
	
	//해당 anidx를 가진 공지사항을 select.
	public AnnounceVo selAnnounce(int anidx){

		AnnounceVo AnV = new AnnounceVo();
		
		sql = "select midx,title,content,(select mname from member b where b.midx = a.midx) as writer,date_format(wDate,'%Y-%m-%d'),istop,date_format(wdate,'%Y-%m-%d') as wDate, hit from announce a where anidx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, anidx);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				AnV.setMidx(rs.getInt("midx"));
				AnV.setTitle(rs.getString("title"));
				AnV.setContent(rs.getString("content"));
				AnV.setWriter(rs.getString("writer"));
				AnV.setIsTop(rs.getString("istop"));
				AnV.setwDate(rs.getString("wDate"));
				AnV.setHit(rs.getInt("hit"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return AnV;
		
	}
	
	
	//공지사항 수정
	public int modAnnounce(int anidx, String title,String content,String isTop) {
		
		sql = "update announce set title = ?,content = ? ,isTop = ?  where anidx = ?";
		
		if(isTop == null) {
			isTop = "N";
		}
		//System.out.println(sql);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setString(3, isTop);
			pstmt.setInt(4, anidx);
			val = pstmt.executeUpdate();			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	
	//index 페이지에 출력할 contentDetail 리스트
	public ArrayList<ContentDetailVo> selContentDetailPopuler(){
		ArrayList<ContentDetailVo> PopuList = new ArrayList<>();
		
		sql = "select cdidx, poster1 from contentDetail where isRelease = 'Y' ";
		
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
	
	
	//문의글 전체 select
	public ArrayList<AskVo> selAskAll(String writer,String wdate1,String wdate2,String title,String content) {
		ArrayList<AskVo> aList = new ArrayList<>();
		
		sql = "select aidx,midx,title,content,date_format(askdate,'%Y-%m-%d') as askdate,anspn,anscontent,";
		sql += "(select mName from member b where b.midx = a.midx) as Writer,";
		sql += "(select mName from member b where b.midx = a.ansmidx) as ansWriter, ansmidx,";
		sql += "date_format(ansdate,'%Y-%m-%d') as ansdate,attach from ask a where a.isdel ='N'";
		
		if(!writer.equals("")) {
			sql +=" and (select mName from member b where b.midx = a.midx) like '%"+writer+"%'";
		}
		
		if(!title.equals("")) {
			sql +=" and title like '%"+title+"%'";
		}

		if(!content.equals("")) {
			sql +=" and content like '%"+content+"%'";
		}

		if(!wdate1.equals("") && !wdate2.equals("")) {
			sql += " and askdate between '"+wdate1+"' and date_add(date_format('"+wdate2+"','%Y-%m-%d'),interval 1 day)";
		}else if(!wdate1.equals("") && wdate2.equals("")) {
			sql += " and askdate > '"+wdate2+"'";
		}else if(wdate1.equals("") && !wdate2.equals("")) {
			sql += " and askdate < date_add(date_format('"+wdate2+"','%Y-%m-%d'),interval 1 day)";
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
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
				AskV.setAnsWriter(rs.getString("ansWriter"));
				AskV.setWriter(rs.getString("Writer"));
				aList.add(AskV);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return aList;
	}
	
	
	//문의글 총 갯수
	public int cntAsk(String writer,String wdate1,String wdate2,String title,String content) {
		
		sql = "select count(*) as cnt from ask a where isdel = 'N' ";
		
		if(!writer.equals("")) {
			sql +=" and (select mName from member b where b.midx = a.midx) like '%"+writer+"%'";
		}
		
		if(!title.equals("")) {
			sql +=" and title like '%"+title+"%'";
		}
		
		if(!content.equals("")) {
			sql +=" and content like '%"+content+"%'";
		}

		if(!wdate1.equals("") && !wdate2.equals("")) {
			sql += " and askdate between '"+wdate1+"' and date_add(date_format('"+wdate2+"','%Y-%m-%d'), interval 1 day)";
		}else if(!wdate1.equals("") && wdate2.equals("")) {
			sql += " and askdate > '"+wdate2+"'";
		}else if(wdate1.equals("") && !wdate2.equals("")) {
			sql += " and askdate < date_add(date_format('"+wdate2+"','%Y-%m-%d'), interval 1 day)";
		}
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("cnt");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return cnt;

	}		
	
	
	//문의글 조회
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
	
	//문의 답변
	public int Answer(int aidx,int anspn,String anscontent,int midx) {
		
		sql = "update ask set anspn = ?, anscontent = ?, ansmidx = ? where aidx = ? ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, anspn);
			pstmt.setString(2, anscontent);
			pstmt.setInt(3, midx);
			pstmt.setInt(4, aidx);
			val = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
	
	//유저 권한 변겅	
	public int toggleUserAdmin(int midx,String isAdmin) {
		
		sql = "update member set isAdmin = ? where midx = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, isAdmin);
			pstmt.setInt(2,midx);
			val = pstmt.executeUpdate();			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return val;
	}
}















