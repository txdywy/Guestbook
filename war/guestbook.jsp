<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
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
	<script>
      function handler(response) {
        for (var i = 0; i < response.data.items.length; i++) {
          var item = response.data.items[i];
          // in production code, item.title should have the HTML entities escaped.
          document.getElementById("content1").innerHTML += "<li>" + item.title  + "             地点: " + item.placeName +"</li>";
        }
      }
    </script>
    <script>
      function handlerJB(response) {
        for (var i = 0; i < response.data.items.length; i++) {
          var item = response.data.items[i];
          // in production code, item.title should have the HTML entities escaped.
          document.getElementById("content2").innerHTML += "<li>" + item.title  + "             地点: " + item.placeName +"</li>";
        }
      }
    </script>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	  html { height: 100% }
	  body { height: 100%; margin: 0; padding: 0 }
	  #map_canvas { height: 100% }
	</style>
	<script type="text/javascript"
	    src="http://maps.googleapis.com/maps/api/js?sensor=true">
	</script>
	<script type="text/javascript">
	  function initialize() {
	    //var latlng = new google.maps.LatLng(-34.397, 150.644);
	    var initialLocation;
		var newyork = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
		var browserSupportFlag =  new Boolean();
		var infowindow = new google.maps.InfoWindow();
	    var myOptions = {
	      zoom: 18,
	      //center: latlng,
	      mapTypeId: google.maps.MapTypeId.SATELLITE
	    };
	    var map = new google.maps.Map(document.getElementById("map_canvas"),
	        myOptions);
	    
	    // Try W3C Geolocation (Preferred)
	    if(navigator.geolocation) {
	      browserSupportFlag = true;
	      navigator.geolocation.getCurrentPosition(function(position) {
	        initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
	        contentString = "您原来窝藏在这?!!<p></p><p>——小本记下了.</p>";
	        map.setCenter(initialLocation);
	        infowindow.setContent(contentString);
	        infowindow.setPosition(initialLocation);
	        infowindow.open(map);
	      }, function() {
	        handleNoGeolocation(browserSupportFlag);
	      });
	    } else {
	        browserSupportFlag = false;
	        handleNoGeolocation(browserSupportFlag);
	    }
	      
	    function handleNoGeolocation(errorFlag) {
	        if (errorFlag == true) {
	          alert("Geolocation service failed.");
	          initialLocation = newyork;
	        } else {
	          alert("Your browser doesn't support geolocation. We've placed you in Big Apple!");
	          initialLocation = newyork;
	        }
	        map.setCenter(initialLocation);
	    }
	  }
	
	</script>
  </head>

  <body onload="initialize()">
    
<%
    Random rand=new Random();
	double lat=rand.nextFloat()*20+ 30.99;
	double lon=rand.nextFloat()*30+ 101.37;
	int rad=(rand.nextInt(1000)+1)*10000;
	String que="新闻";
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

<blockquote>
<p>终于等到您了!</p>
<div id="map_canvas" style="width:70%; height:50%"></div>
</blockquote>

<blockquote>
<p>您的八卦30条</p>
<ul id="content1"></ul>
<script src="https://www.googleapis.com/buzz/v1/activities/<%= user.getEmail() %>/@public?alt=json&callback=handler&key=AIzaSyBwmogjo3IlL5jt_8vIfytvIESY0mYgE-A&max-results=30"></script>
</blockquote>


<blockquote>
<p>北京“新闻”30条<%= "(经:"+lat+",纬"+lon+"), 半径="+rad %></p>
<ul id="content2"></ul>
<script src="https://www.googleapis.com/buzz/v1/activities/search?alt=json&callback=handlerJB&key=AIzaSyBwmogjo3IlL5jt_8vIfytvIESY0mYgE-A&q=<%=que%>&lat=<%=lat%>&lon=<%=lon%>&radius=<%=rad%>&max-results=30"></script>
</blockquote>

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
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(200));
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
