<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.util.ArrayList" %>
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
	h1 {
		font-family: 'Do Hyeon', sans-serif;
	}
	a {
		font-family: 'Gowun Dodum', sans-serif;
	}
	p {
		font-family: 'Gowun Dodum', sans-serif;
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
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}

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
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
				</thead>
				<tbody>
					<tr>
						<%
							UserDAO userDAO = new UserDAO();
							BbsDAO bbsDAO = new BbsDAO();
							ArrayList<Bbs> MyBbsList = bbsDAO.getMyBbsList(userID, pageNumber);
							int cnt = bbsDAO.getMyCount(userID) - ((pageNumber - 1) * 10);
							for (int i=0; i<MyBbsList.size(); i++) {
						%>
						<td><%= cnt %></td>
						<td><a href="view.jsp?bbsID=<%= MyBbsList.get(i).getBbsID() %>">
							<%= MyBbsList.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
						<td><%= userDAO.getName(MyBbsList.get(i).getUserID()) %></td>
						<td><%= MyBbsList.get(i).getBbsDate().substring(0, 11) + MyBbsList.get(i).getBbsDate().substring(11, 13) + "시" + MyBbsList.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<%
							cnt--;
							}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				if (pageNumber != 1) {
			%>
				<a href="userbbs.jsp?pageNumber=<%=pageNumber - 1 %>&userID=<%=userID %>"
					class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if (bbsDAO.myNextPage(userID, pageNumber + 1)) {
			%>
				<a href="userbbs.jsp?pageNumber=<%=pageNumber + 1 %>&userID=<%=userID %>"
					class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			<!-- 글쓰기 버튼 생성 -->
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>

		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>