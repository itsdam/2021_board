<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자격증 공부 게시판</title>
</head>
<body>
	<%	
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	    int boardID = 0;
	     if(request.getParameter("BoardID")!=null){
	        boardID = Integer.parseInt(request.getParameter("BoardID"));
	        }
	     int bbsID = 0;
	     if (request.getParameter("BbsID") != null) {
	        bbsID = Integer.parseInt(request.getParameter("BbsID"));
	       }
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		 else {
				if (boardID == 0) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('유효하지 않은 글입니다.')");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
				Board board = new BoardDAO().getBoard(boardID);
				if (!userID.equals(board.getUserID())) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('권한이 없습니다.')");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				} else {
						BoardDAO boardDAO = new BoardDAO();
						int result = boardDAO.delete(boardID);
						if (result == -1) {
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('댓글 삭제에 실패했습니다.')");
							script.println("history.back()");
							script.println("</script>");
						} 
						else {
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('댓글이 삭제되었습니다.')");
							String url="view.jsp?bbsID="+bbsID;
							script.println("location.href='"+url+"'");
							script.println("</script>");
							
						}
					}
				 }
	%>
	
</body>
</html>