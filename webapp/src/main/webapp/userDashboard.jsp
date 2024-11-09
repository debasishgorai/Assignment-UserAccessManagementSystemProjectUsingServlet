<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Dashboard</title>
</head>
<body>
    <h2>User Dashboard</h2>
    <p>Welcome, <%= session.getAttribute("username") %>!</p>
    <a href="requestAccess.jsp">Request Access</a> | <a href="logout.jsp">Logout</a>

    <h3>Your Access Requests</h3>
    <table border="1">
        <tr>
            <th>Request ID</th>
            <th>Software ID</th>
            <th>Access Type</th>
            <th>Reason</th>
            <th>Status</th>
        </tr>
        <%
            String username = (String) session.getAttribute("username");
            try (Connection conn = Database.getConnection()) {
                String sql = "SELECT * FROM access_requests WHERE username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int requestId = rs.getInt("id");
                    int softwareId = rs.getInt("software_id");
                    String accessType = rs.getString("access_type");
                    String reason = rs.getString("reason");
                    String status = rs.getString("status");
        %>
                    <tr>
                        <td><%= requestId %></td>
                        <td><%= softwareId %></td>
                        <td><%= accessType %></td>
                        <td><%= reason %></td>
                        <td><%= status == null ? "Pending" : status %></td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
                <tr>
                    <td colspan="5">Error fetching your requests</td>
                </tr>
        <%
            }
        %>
    </table>
</body>
</html>