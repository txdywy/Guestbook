<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  <title>Welcome to yfox!</title>
  <script type="text/javascript" src="js/renren_js_sdk/renren.js"></script>
</head>
<body>
  <script type="text/javascript">
      top.location="http://graph.renren.com/oauth/authorize?client_id=${requestScope.appId}&response_type=token&display=page&redirect_uri=" + encodeURIComponent("http://apps.renren.com/yfoxyiest/home");
  </script>
  Hi, Welcome! yfox! 我是迷糊的小狐狸吗?!!
</body>
</html>