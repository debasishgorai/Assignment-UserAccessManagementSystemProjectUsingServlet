package com.webapp1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.ResultSet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/requestAccess")
public class RequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in and is an Employee
        HttpSession session = request.getSession(false);
        if (session == null || !"Employee".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp"); // Redirect to login if not an Employee
            return;
        }

        String userName = request.getParameter("username");
        System.out.println(userName);
        String softwareName = request.getParameter("softwareName");
        String accessType = request.getParameter("accessType");
        String reason = request.getParameter("reason");
        int softwareId = 0;
        int userId = 0;

        // Insert request details into the database
        try (Connection connection = Database.getConnection()) {
            // SQL to get software ID
            String sql1 = "SELECT id FROM software WHERE name = ?";
            // SQL to get user ID
            String sql2 = "SELECT id FROM users WHERE username = ?"; // Assuming 'id' is the correct column name

            // Get software ID
            try (PreparedStatement statement1 = connection.prepareStatement(sql1)) {
                statement1.setString(1, softwareName);
                try (ResultSet rs = statement1.executeQuery()) {
                    if (rs.next()) {
                        softwareId = rs.getInt("id");
                    } else {
                        throw new SQLException("Software not found: " + softwareName);
                    }
                }
            }

            // Get user ID
            try (PreparedStatement statement2 = connection.prepareStatement(sql2)) {
                statement2.setString(1, userName);
                try (ResultSet rs = statement2.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id"); // Use the correct column name here
                    } else {
                        throw new SQLException("User  not found: " + userName); // Corrected error message
                    }
                }
            }

            // Insert request
            String sql = "INSERT INTO requests (user_id, software_id, access_type, reason, status) VALUES (?, ?, ?, ?, 'Pending')";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, userId);
                statement.setInt(2, softwareId);
                statement.setString(3, accessType);
                statement.setString(4, reason);
                statement.executeUpdate();
            }
            response.sendRedirect("success.jsp"); // Redirect to a success page
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle SQL exception
            request.setAttribute("errorMessage", "An error occurred while submitting your request. Please try again.");
            request.getRequestDispatcher("requestAccess.jsp").forward(request, response);
        }
    }
}