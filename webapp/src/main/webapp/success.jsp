<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Check if the user is logged in and has the role of Admin
    HttpSession userSession = request.getSession(false);
if (userSession == null ||
    (!"Employee".equals(userSession.getAttribute("role")) &&
     !"Admin".equals(userSession.getAttribute("role")))) {
    response.sendRedirect("login.jsp"); // Redirect to login if not an Employee or Admin
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Request Submitted</title>
</head>
<body>
    <h1>Access Request Submitted Successfully!</h1>
    <p>Your request for access has been submitted and is currently pending approval.</p>
    <a href="requestAccess.jsp">Request Access to Another Software</a>
</body>
</html>