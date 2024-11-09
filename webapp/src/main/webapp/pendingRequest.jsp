<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.webapp1.Request" %>
<%@ page import="com.webapp1.Database" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    List<Request> pendingRequests = new ArrayList<>();
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        connection = Database.getConnection();
        // SQL query to retrieve pending requests along with user and software names
        String sql = "SELECT r.id, r.user_id, r.software_id, u.username AS employee_name, s.name AS software_name, " +
                     "r.access_type, r.reason, r.status " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "WHERE r.status = 'Pending'";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            Request pendingRequest = new Request();
            pendingRequest.setId(resultSet.getInt("id"));
            pendingRequest.setUserId(resultSet.getInt("user_id")); // Store user_id if needed
            pendingRequest.setSoftwareId(resultSet.getInt("software_id")); // Store software_id if needed
            pendingRequest.setAccessType(resultSet.getString("access_type"));
            pendingRequest.setReason(resultSet.getString("reason"));
            pendingRequest.setStatus(resultSet.getString("status"));
            pendingRequests.add(pendingRequest);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pending Access Requests</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Pending Access Requests</h1>
    <table>
        <tr>
            <th>Employee Name</th>
            <th>Software Name</th>
            <th>Access Type</th>
            <th>Reason</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <%
            for (Request pendingRequest : pendingRequests) {
        %>
        <tr>
            <td><%= pendingRequest.getUserId() %></td>
            <td><%= pendingRequest.getSoftwareId() %></td>
            <td><%= pendingRequest.getAccessType() %></td>
            <td><%= pendingRequest.getReason() %></td>
            <td><%= pendingRequest.getStatus() %></td>
            <td>
                <form action="approveRequest" method="post">
                    <input type="hidden" name="requestId" value="<%= pendingRequest.getId() %>">
                    <input type="submit" name="action" value="Approve">
                    <input type="submit" name="action" value="Reject">
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <!-- Logout Button -->
    <form action="logout" method="post" style="margin-top: 20px;">
        <input type="submit" value="Logout">
    </form>
</body>
</html>