package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=Asia/Seoul";
			String dbID = "root";
			String dbPassword = "tooj0521^^";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	 public String getDate() {//게시판을 작성할 때 현재 시간
		   String SQL = "SELECT NOW()";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL);
			   rs = pstmt.executeQuery();
			   if(rs.next()) {
				   return rs.getString(1); //반환
			   }
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return "";
	   }

	
	public int getNext() { 
		   String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL);
			   rs = pstmt.executeQuery();
			   if(rs.next()) {
				   return rs.getInt(1)+1; //반환
			   }
			   return 1; //첫 번째 게시물인 경우 
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	   }
	
		public int write(String bbsTitle,String userID,String bbsContent){ //게시글 작성 기능
			   String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?)";
			   try {
				   PreparedStatement pstmt = conn.prepareStatement(SQL); 
				   pstmt.setInt(1, getNext());
				   pstmt.setString(2, bbsTitle);
				   pstmt.setString(3, userID);
				   pstmt.setString(4, getDate());
				   pstmt.setString(5, bbsContent);
				   pstmt.setInt(6, 1);// rs= pstmt.executeQuery(); insert는 자동으로 해줌 
				   return pstmt.executeUpdate();
			   } catch(Exception e) {
				   e.printStackTrace();
			   }
			   return -1;
		   }
		
		public ArrayList<Bbs> getList(int pageNumber) {
			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
			ArrayList<Bbs> list = new ArrayList<Bbs>();  
			try {
				  PreparedStatement pstmt = conn.prepareStatement(SQL); //현재 연결되어있는 conn객체를 이용해서 SQL을 문장을 실행 준비단계로 만들어준다. 
				  pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
				  rs = pstmt.executeQuery();
				  while (rs.next()) {
					  Bbs bbs = new Bbs(); 
					  bbs.setBbsID(rs.getInt(1));
					  bbs.setBbsTitle(rs.getString(2));
					  bbs.setUserID(rs.getString(3));
					  bbs.setBbsDate(rs.getString(4));
					  bbs.setBbsContent(rs.getString(5));
					  bbs.setBbsAvailable(rs.getInt(6));
					  list.add(bbs);
				  }
			  } catch(Exception e) {
				  e.printStackTrace();
			  }
			   return list;
		}
		
		public boolean nextPage(int pageNumber) {
			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
			try {
				  PreparedStatement pstmt = conn.prepareStatement(SQL);
				  pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
				  rs = pstmt.executeQuery();
				  if (rs.next()) {
					  return true;
				  }
			  } catch(Exception e) {
				  e.printStackTrace();
			  }
			   return false;
	}
		
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		try {
			  PreparedStatement pstmt = conn.prepareStatement(SQL);
			  pstmt.setInt(1, bbsID);
			  rs = pstmt.executeQuery();
			  if (rs.next()) {
				  Bbs bbs = new Bbs(); 
				  bbs.setBbsID(rs.getInt(1));
				  bbs.setBbsTitle(rs.getString(2));
				  bbs.setUserID(rs.getString(3));
				  bbs.setBbsDate(rs.getString(4));
				  bbs.setBbsContent(rs.getString(5));
				  bbs.setBbsAvailable(rs.getInt(6));
				  return bbs;
			  }
		  } catch(Exception e) {
			  e.printStackTrace();
		  }
		   return null;
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) { //게시글 수정 기능
		   String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL); 
			   pstmt.setString(1, bbsTitle);
			   pstmt.setString(2, bbsContent);
			   pstmt.setInt(3, bbsID);
			   return pstmt.executeUpdate();
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	} 
	public int delete(int bbsID) { //게시글 삭제 기능
		   String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL); 
			   pstmt.setInt(1, bbsID);
			   return pstmt.executeUpdate();
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	}
	
	public int getSrchCount (String srchKey, String srchText) { 
		String SQL = "select count(*) from bbs where bbsAvailable = 1 and " + srchKey + " like ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + srchText + "%");
			rs = pstmt.executeQuery();
			if (rs.next()) return rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 검색 결과 없음
	}
	
	public ArrayList<Bbs> getSrchList (String srchKey, String srchText, int pageNumber) {
		ArrayList<Bbs> searchList = new ArrayList<Bbs>();
		String SQL = "select * from bbs where bbsAvailable = 1 and " + srchKey + " like ? order by bbsID desc limit ?, 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + srchText + "%");
			pstmt.setInt(2, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				searchList.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return searchList;
	}
	
	public boolean srchNextPage(String srchKey, String srchText, int pageNumber) {
		String SQL = "select * from bbs where bbsAvailable = 1 and " + srchKey + " like ? order by bbsID desc limit ?, 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + srchText + "%");
			pstmt.setInt(2, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return false;
	}
	
	public ArrayList<Bbs> getBbsList(int pageNumber){
		String SQL = "select * from bbs where bbsAvailable = 1 order by bbsID desc limit ?, 10";
		ArrayList<Bbs> bbsList = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				bbsList.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}  
		return bbsList;
	}

	public ArrayList<Bbs> getMyBbsList(String userID, int pageNumber){
		String SQL = "select * from bbs where userID =? and bbsAvailable = 1 order by bbsID desc limit ?, 10";
		ArrayList<Bbs> myBbsList = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				myBbsList.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}  
		return myBbsList;
	}

	public int getMyCount (String userID) { 
		String SQL = "select count(*) from bbs where userID = ? and bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) return rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 검색 결과 없음
	}

	public boolean myNextPage(String userID, int pageNumber) {
		String SQL = "select * from bbs where userID = ? and bbsAvailable = 1 order by bbsID desc limit ?, 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID );
			pstmt.setInt(2, (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return false;
	}

}
