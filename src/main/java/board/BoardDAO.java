package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BoardDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BoardDAO() {
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
	
	 public String getDate() {//댓글을 작성할 때 현재 시간
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
		   String SQL = "SELECT boardID FROM BOARD ORDER BY boardID DESC";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL);
			   rs = pstmt.executeQuery();
			   if(rs.next()) {
				   System.out.println(rs.getInt(1));
				   return rs.getInt(1)+1; //반환
			   }
			   return 1; //첫 번째 댓글인 경우 
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	   }
	
		public int write(int bbsID, String boardContent, String userID){ //댓글 작성 기능
			   String SQL = "INSERT INTO BOARD VALUES(?, ?, ?, ?, ?, ?)";
			   try {
				   PreparedStatement pstmt = conn.prepareStatement(SQL); 
				   pstmt.setInt(1, getNext());
				   pstmt.setString(2, userID);
				   pstmt.setString(3, getDate());
				   pstmt.setString(4, boardContent); 
				   pstmt.setInt(5, 1);
				   pstmt.setInt(6, bbsID);
				   return pstmt.executeUpdate();
			   } catch(Exception e) {
				   e.printStackTrace();
			   }
			   return -1;
		   }
		
		public ArrayList<Board> getList(int bbsID,int pageNumber) {
			String SQL = "SELECT * FROM BOARD WHERE boardID < ? AND boardAvailable = 1 AND bbsID = ? ORDER BY boardID DESC LIMIT 10";
			ArrayList<Board> list = new ArrayList<Board>();  
			try {
				  PreparedStatement pstmt = conn.prepareStatement(SQL); //현재 연결되어있는 conn객체를 이용해서 SQL을 문장을 실행 준비단계로 만들어준다. 
				  pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
				  pstmt.setInt(2, bbsID);
				  rs = pstmt.executeQuery();
				  while (rs.next()) {
					  Board board = new Board(); 
					  board.setBoardID(rs.getInt(1));
					  board.setUserID(rs.getString(2));
					  board.setBoardDate(rs.getString(3));
					  board.setBoardContent(rs.getString(4));
					  board.setBoardAvailable(1);
					  board.setBbsID(bbsID);
					  list.add(board);
				  }
			  } catch(Exception e) {
				  e.printStackTrace();
			  }
			   return list;
		}
		
		public boolean nextPage(int pageNumber) {
			String SQL = "SELECT * FROM BOARD WHERE boardID < ? AND boardsAvailable = 1";
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
		
	public Board getBoard(int boardID) {
		String SQL = "SELECT * FROM BOARD WHERE boardID = ?";
		try {
			  PreparedStatement pstmt = conn.prepareStatement(SQL);
			  pstmt.setInt(1, boardID);
			  rs = pstmt.executeQuery();
			  if (rs.next()) {
				  Board board = new Board(); 
				  board.setBoardID(rs.getInt(1));
				  board.setUserID(rs.getString(2));
				  board.setBoardDate(rs.getString(3));
				  board.setBoardContent(rs.getString(4));
				  board.setBoardAvailable(1);
				  board.setBbsID(rs.getInt(5));
				  return board;
			  }
		  } catch(Exception e) {
			  e.printStackTrace();
		  }
		   return null;
	}
	
	public int update(int boardID, String boardContent) { //댓글 수정 기능
		   String SQL = "UPDATE BOARD SET boardContent = ? WHERE boardID = ?";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL); 
			   pstmt.setString(1, boardContent);
			   pstmt.setInt(2, boardID);
			   return pstmt.executeUpdate();
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	} 
	public int delete(int boardID) { //댓글 삭제 기능
		   String SQL = "UPDATE BOARD SET boardAvailable = 0 WHERE boardID = ?";
		   try {
			   PreparedStatement pstmt = conn.prepareStatement(SQL); 
			   pstmt.setInt(1, boardID);
			   return pstmt.executeUpdate();
		   } catch(Exception e) {
			   e.printStackTrace();
		   }
		   return -1;
	}

}
