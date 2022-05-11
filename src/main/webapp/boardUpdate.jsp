<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Gowun+Dodum&display=swap" rel="stylesheet">
<style>
	body
	{
		font-family: 'Gowun Dodum', sans-serif;
	}
	
		.button 
	{
			background-color: #555555;
			color: white;
			font-size: 15px;
		  border: none;
		  padding: 4px 6px;
		  text-decoration: none;
		  display: inline-block;
		  margin: 1px 1px;
		  cursor: pointer;
		  border-top-left-radius: 5px;
		  border-bottom-left-radius: 5px;
		  border-top-right-radius: 5px;
		  border-bottom-right-radius: 5px;
	}
	
		.button3 
	{
			background-color: #e7e7e7;
			color: black;
			font-size: 15px;
		  border: none;
		  padding: 4px 6px;
		  text-decoration: none;
		  display: inline-block;
		  margin: 1px 1px;
		  cursor: pointer;
		  border-top-left-radius: 5px;
		  border-bottom-left-radius: 5px;
		  border-top-right-radius: 5px;
		  border-bottom-right-radius: 5px;
	}
	
</style>
<title>자격증 공부 게시판</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body style="background-color : lightgray;">
	<%
		Timestamp now = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		String strDate = format.format(now);
	%>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}		
		String boardContent = null;
		if(session.getAttribute("BoardContent") != null) {
			boardContent = (String) session.getAttribute("BoardContent");
		}
	    int boardID = 0;
	     if(request.getParameter("BoardID")!=null){
	        boardID = Integer.parseInt(request.getParameter("BoardID"));
	        }
	     int bbsID = 0;
	     if (request.getParameter("BbsID") != null) {
	        bbsID = Integer.parseInt(request.getParameter("BbsID"));
	       }
		int pageNumber=1;
		// pageNumber는 URL에서 가져온다.
		if(request.getParameter("pageNumber")!=null){
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		}
		
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);

		
	%>
	
	<nav class="navbar navbar-inverse">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" 
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">자격증 공부 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">HOME</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>

			<% 
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
						<li><a href="login.jsp">LOGIN</a></li>
						<li><a href="join.jsp">JOIN</a></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
						<li><a href="logoutAction.jsp">LOGOUT</a></li>
			</ul>
			<%
				}
			%>		
		</div>
	</nav>
	<div class="container">
		<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody style="background-color : white;">
						<tr>
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + ":" + bbs.getBbsDate().substring(14, 16) %></td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
					</tbody>
				</table>
		<form method="post" action="boardUpdateAction.jsp?BoardID=<%=boardID%>&BbsID=<%=bbsID%>">
			<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: center;">댓글 수정</th>
						</tr>
					</thead>
					<tbody style="background-color: white;">
					
						<%
							BoardDAO boardDAO=new BoardDAO();
							ArrayList<Board> list = boardDAO.getList(bbsID, pageNumber);

							{
							
						%>

						<td><textarea type="text" class="form-control"
								name="BoardContent" maxlength="2048" style= "background-color: white;"><%=request.getParameter("BoardContent")%></textarea></td>
						<td style=" text-align: left; "></td>
							
						<%
               				}
						%>
					</tbody>
				</table>
				<input type="submit" class="button3" value="저장">
				<br>
			</form>
   				
				<!-- 글쓰기 버튼 생성 -->
				<br>
				<a href="bbs.jsp" class="button">목록</a>
				<%
					if(userID != null && userID.equals(bbs.getUserID())) {
						
				%>
					<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
				<%
					}
				%>
				
				<input type="submit" class="button pull-right" value="글쓰기">
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>