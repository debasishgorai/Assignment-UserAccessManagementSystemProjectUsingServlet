<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.webapp1.Database" %> <!-- Adjust the package name accordingly -->
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    // Check if the user is logged in and has the role of Employee
HttpSession userSession = request.getSession(false);
if (userSession == null ||
    !"Employee".equals(userSession.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); // Redirect to login if not an Employee
    return;
}

// Continue with the rest of your logic for authorized users

    // Step 1: Initialize the software list and database connection
    List<String> softwareList = new ArrayList<>();
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        // Step 2: Establish database connection
        connection = Database.getConnection(); // Ensure Database class is correctly imported
        String sql = "SELECT name FROM software"; // Fetch software names
        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        // Step 3: Populate the softwareList with names from the database
        while (resultSet.next()) {
            softwareList.add(resultSet.getString("name"));
        }

        // Step 4: Set the softwareList as a request attribute
        request.setAttribute("softwareList", softwareList);
    } catch (SQLException e) {
        e.printStackTrace(); // Handle exceptions appropriately
    } finally {
        // Step 5: Close resources (resultSet, statement, connection) here
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Request Access</title>
</head>
<body>
    <h1>Request Access to Software</h1>
    <form action="requestAccess" method="post">
        <label for="software">Software Name:</label>
        <select name="softwareName" id="softwareName" required>
            <!-- Step 6: Use JSTL to iterate over the softwareList -->
            <c:forEach var="software" items="${softwareList}">
                <option value="${software}">${software}</option>
            </c:forEach>
        </select>
        <br><br>

        <label for="accessType">Access Type:</label>
        <select name="accessType" id="accessType" required>
            <option value="Read">Read</option>
            <option value="Write">Write</option>
            <option value="Admin">Admin</option>
        </select>
        <br><br>

        <label for="reason">Reason for Request:</label>
        <textarea name="reason" id="reason" required></textarea>
        <br><br>

        <input type="submit" value="Submit Request">
    </form>
    <form action="logout" method="post" style="margin-top: 20px;">
        <input type="submit" value="Logout">
    </form>
</body>
</html>