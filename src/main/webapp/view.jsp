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
<%@ page import="user.User" %>
<%@ page import="user.UserDAO" %>
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
	
	.button2 
	{
			background-color: #e7e7e7;
			color: black;
			font-size: 13px;
		  border: none;
		  padding: 5px 5px;
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
<title>????????? ?????? ?????????</title>
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
		int bbsID = 0;
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		
		
		int pageNumber=1;
		// pageNumber??? URL?????? ????????????.
		if(request.getParameter("pageNumber")!=null){
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		}
		
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('???????????? ?????? ????????????.')");
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
			<a class="navbar-brand" href="main.jsp">????????? ?????? ?????????</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">HOME</a></li>
				<li class="active"><a href="bbs.jsp">?????????</a></li>
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
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">????????? ??? ??????</th>
						</tr>
					</thead>
					<tbody style="background-color : white;">
						<tr>
							<td style="width: 20%;">??? ??????</td>
							<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
						<tr>
							<td>?????????</td>
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<td>????????????</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + ":" + bbs.getBbsDate().substring(14, 16) %></td>
						</tr>
						<tr>
							<td>??????</td>
							<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
						</tr>
					</tbody>
				</table>
		<form method="post" action="boardWriteAction.jsp?bbsID=<%= bbsID %>">
			<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<%-- ???,??? ??? ?????? --%>
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeee; text-align: center;">??????</th>
						</tr>
					</thead>
					<tbody style="background-color: white;">
					
						<%
							BoardDAO boardDAO=new BoardDAO();
							ArrayList<Board> list = boardDAO.getList(bbsID, pageNumber);
							for(int i=list.size()-1;i>=0;i--)

							{
							
						%>
						
						<tr>
							<td style="text-align: left; width: 60%"><%= list.get(i).getBoardContent() %></td>
							<td style="text-align: center; width: 20% "><%= list.get(i).getBoardDate() %></td>
							<td style="text-align: right; width: 20%"><%= list.get(i).getUserID() %>
						
						<%
               				if(userID != null && userID.equals(list.get(i).getUserID())) {
                  
            			%>
							
							<a href="boardUpdate.jsp?BbsID=<%=bbsID%>&BoardID=<%=list.get(i).getBoardID()%>&BoardContent=<%=list.get(i).getBoardContent()%>" class="button2">??????</a>
							<a onclick="return confirm('????????? ?????????????????????????')" href="boardDeleteAction.jsp?BoardID=<%=list.get(i).getBoardID()%>&BbsID=<%=bbsID%>"class="button2">??????</a>
							</td>
							
						<%
               				}
						%>
							</tr>
						<%
							}
						%>

						<td colspan = "3" style= "text-align: left;" ><textarea type="text" class="form-control"
								placeholder="????????? ???????????????." name="boardContent" maxlength="2048" style= "background-color: white;"></textarea></td>
						
				
					</tbody>
				</table>
				<input type="submit" class="button3" value="????????????">
			</form>
   
				<!-- ????????? ?????? ?????? -->
				<br>
				<a href="bbs.jsp" class="button">??????</a>
				<%
					if(userID != null && userID.equals(bbs.getUserID())) {
						
				%>
					<a href="update.jsp?bbsID=<%= bbsID %>" class="button">??????</a>
					<a onclick="return confirm('????????? ?????????????????????????')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="button">??????</a>
				<%
					}
				%>
				
				<input type="submit" class="button pull-right" value="?????????">
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>