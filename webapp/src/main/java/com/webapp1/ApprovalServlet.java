package com.webapp1;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/approveRequest")
public class ApprovalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in and is a Manager
        HttpSession session = request.getSession(false);
        if (session == null || !"Manager".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp"); // Redirect to login if not a Manager
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action"); // This will be either "approve" or "reject"

        // Update request status in the database
        try (Connection connection = Database.getConnection()) {
            String sql = "UPDATE requests SET status = ? WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                if ("Approve".equals(action)) {
                    statement.setString(1, "Approved");
                } else if ("Reject".equals(action)) {
                    statement.setString(1, "Rejected");
                }
                statement.setInt(2, requestId);
                statement.executeUpdate();
            }
            response.sendRedirect("pendingRequest.jsp"); // Redirect back to the pending requests page
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle SQL exception
            request.setAttribute("errorMessage", "An error occurred while processing the request. Please try again.");
            request.getRequestDispatcher("pendingRequests.jsp").forward(request, response);
        }
    }
}