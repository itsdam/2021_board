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
		String srchKey = null;
		if (request.getParameter("srchKey") != null) {
			srchKey = java.net.URLDecoder.decode(request.getParameter("srchKey"), "utf-8"); //디코딩해서 받기 시도 해봤으나 디코딩 해서 받아도 같은 현상 발생 그냥 디코딩 안하고 해도 됨
			//System.out.println(srchKey);
		}
		
		String srchText = null;	
		if (request.getParameter("srchText") != null) {
			srchText = java.net.URLDecoder.decode(request.getParameter("srchText"), "utf-8") ;
			//System.out.println(srchText);
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
		<div>
		<form method="post" class="pull-right" action="srchbbs.jsp">
			<fieldset>
                   <label>검색분류</label>
                       <select name = "srchKey">
                           <option ${(param.srchKey == "bbsTitle")? "selected" : ""} value = "bbsTitle">제목</option>
                           <option ${(param.srchKey == "bbsContent")? "selected" : ""} value = "bbsContent">내용</option>
                       </select>
                   <label>검색어</label>
                       <input type = "text" name = "srchText" value = "${param.srchText}"/>
                       <input type = "submit" class="button" value = "검색">                
               </fieldset>        
		</form>	
	</div>	
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
				<tbody style="background-color : white;">
					<tr>
						<%
							UserDAO userDAO = new UserDAO();
							BbsDAO bbsDAO = new BbsDAO();
							ArrayList<Bbs> searchList = bbsDAO.getSrchList(srchKey, srchText, pageNumber);
							int cnt = bbsDAO.getSrchCount(srchKey, srchText) - ((pageNumber - 1) * 10);
							for (int i=0; i<searchList.size(); i++) {
						%>
						<td><%= cnt %></td>
						<td><a href="view.jsp?bbsID=<%= searchList.get(i).getBbsID() %>">
							<%= searchList.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
						<td><a href="userbbs.jsp?userID=<%= searchList.get(i).getUserID() %>">
							<%= searchList.get(i).getUserID() %></a></td>
						
						<td><%= searchList.get(i).getBbsDate().substring(0, 11) + searchList.get(i).getBbsDate().substring(11, 13) + ":" + searchList.get(i).getBbsDate().substring(14, 16) %></td>
					</tr>
					<%
							cnt--;
							}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				int lastPage = 1;
				if (bbsDAO.getSrchCount(srchKey, srchText) > 0) {
					lastPage = (int) Math.ceil(bbsDAO.getSrchCount(srchKey, srchText)/10.0);
				}
			%>
			
			<%
				if (pageNumber != 1) {
			%>
				<a href="srchbbs.jsp?pageNumber=<%=pageNumber - 1 %>&srchKey=<%=srchKey %>&srchText=<%=srchText %>"
					class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if (bbsDAO.srchNextPage(srchKey, srchText, pageNumber + 1)) {
			%>
				<a href="srchbbs.jsp?pageNumber=<%=pageNumber + 1 %>&srchKey=<%=srchKey %>&srchText=<%=srchText %>"
					class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			
			<!-- 글쓰기 버튼 생성 -->
			<a href="write.jsp" class="button pull-right">글쓰기</a>

		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>