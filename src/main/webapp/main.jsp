<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="C:\Users\User\eclipse-workspace\BBS\src\css\custom.css">
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
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
<title>자격증 공부 게시판</title>
</head>
<body style="background-color : lightgray;">
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
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
				<li class="active"><a href="main.jsp">HOME</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
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
		<img src="jagyuk.png" style= "margin-right: 300px; margin-top: 50px;" align="right" width="15%" height="15%" border="10"/>
	<div class="container">
		<div class="jumbotron">
			<div class="container">
				<h1>자격증 공부 게시판</h1>
				<p> 자격증을 공부하면서 생기는 모든 궁금증을 해결하세요!</p>
				<p><a class="button" href="http://www.q-net.or.kr/man001.do?gSite=Q">국가자격증에 대한 기본 정보</a></p>
			</div>
		</div>
	</div>
	<div class="container">
	  <div id="myCarousel" class="carousel slide" data-ride="carousel">
	      <ol class="carousel-indicators">
	       <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
	       <li data-target="#myCarousel" data-slide-to="1"></li>
	       <li data-target="#myCarousel" data-slide-to="2"></li>
	       <li data-target="#myCarousel" data-slide-to="3"></li>
	     </ol>
	 <div class="carousel-inner">
	    <div class="item active"> 
	     	<img src="result.PNG">
	    </div>
	    <div class="item">
	     	<img src="jong1.PNG">
	    </div>
	    <div class="item">
	     	<img src="jong2.PNG">
	    </div>
	    <div class="item">
	     	<img src="want.PNG">
	    </div>
	    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
	     	<span class="glyphicon glyphicon-chevron-left"></span>
	    </a>
	   	<a class="right carousel-control" href="#myCarousel" data-slide="next">
	     	<span class="glyphicon glyphicon-chevron-right"></span>
	    </a>
	   </div>
	  </div>
	 </div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>