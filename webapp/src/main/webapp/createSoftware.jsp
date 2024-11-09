<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    HttpSession userSession = request.getSession(false);
    if (session == null || !"Admin".equals(userSession.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); // Redirect to login if not an Admin
        return;
    }
%>
<html>
<head>
    <title>Create Software</title>
</head>
<body>
    <h1>Create New Software</h1>
    <form action="createSoftware" method="post">
        <label for="softwareName">Software Name:</label>
        <input type="text" id="softwareName" name="softwareName" required>
        <br>
        <label for="description">Description:</label>
        <textarea id="description" name="description" required></textarea>
        <br>
        <label>Access Levels:</label><br>
        <input type="checkbox" name="accessLevels" value="Read"> Read<br>
        <input type="checkbox" name="accessLevels" value="Write"> Write<br>
        <input type="checkbox" name="accessLevels" value="Admin"> Admin<br>
        <br>
        <input type="submit" value="Add Software">
    </form>
    <!-- Logout Button -->
    <form action="logout" method="post" style="margin-top: 20px;">
        <input type="submit" value="Logout">
    </form>
</body>
</html>