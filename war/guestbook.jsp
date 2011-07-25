<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<html>
  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
    <script type="text/javascript">
		function handleResponse(profile) {
			document.getElementsByTagName('img')[0].src = profile.data.thumbnailUrl;
		}
	</script>
  </head>

  <body>

<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Hello, <%= user.getNickname() %>! ([<%= user.getEmail() %>][<%= user.getAuthDomain() %>][<%= user.getUserId() %>])这里是《有客书局》(You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<img src="" alt=""/>
<script src="https://www.googleapis.com/buzz/v1/people/<%= user.getEmail() %>/@self?alt=json&pp=1&key=AIzaSyBwmogjo3IlL5jt_8vIfytvIESY0mYgE-A&callback=handleResponse"></script>

<a href="https://twitter.com/txdywy" class="twitter-follow-button">Follow @txdywy</a>
<script src="http://platform.twitter.com/widgets.js" type="text/javascript"></script>

<g:plusone></g:plusone>

<a title="Post to Google Buzz" class="google-buzz-button" href="http://www.google.com/buzz/post" data-button-style="normal-count"></a>
<script type="text/javascript" src="http://www.google.com/buzz/api/button.js"></script>

<a target="_blank" title="Follow on Google Buzz" class="google-buzz-button" href="https://plus.google.com/106394440825588483659/posts" data-button-style="follow">Follow on Buzz</a>

<%
    } else {
%>
<p>Hello! 这里是《有客书局》
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
    if (greetings.isEmpty()) {
        %>
        <p>Guestbook '<%= guestbookName %>' has no messages.</p>
        <%
    } else {
        %>
        <p>Messages in Guestbook '<%= guestbookName %>'.</p>
        <%
        for (Entity greeting : greetings) {
            if (greeting.getProperty("user") == null) {
                %>
                <p>An anonymous person wrote:</p>
                <%
            } else {
                %>
                <p><b><%= ((User) greeting.getProperty("user")).getNickname() %></b> wrote:</p>
                <img src="" alt=""/>
				<script src="https://www.googleapis.com/buzz/v1/people/<%= user.getEmail() %>/@self?alt=json&pp=1&key=AIzaSyBwmogjo3IlL5jt_8vIfytvIESY0mYgE-A&callback=handleResponse"></script>
                <%
            }
            %>
            <blockquote><%= greeting.getProperty("content") %></blockquote>
            <%
        }
    }
%>

    <form action="/sign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Greeting" /></div>
      <input type="hidden" name="guestbookName" value="<%= guestbookName %>"/>
    </form>

  </body>
</html>
