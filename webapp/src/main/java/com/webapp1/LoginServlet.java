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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate credentials against the database
        try (Connection connection = Database.getConnection()) {
            String sql = "SELECT role FROM users WHERE username = ? AND password = ?"; // In a real application, hash the password
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.setString(2, password); // In a real application, hash the password

                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    String role = resultSet.getString("role");

                    // Create a session for the user
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    // Redirect based on user role
                    switch (role) {
                        case "Employee":
                            response.sendRedirect("requestAccess.jsp");
                            break;
                        case "Manager":
                            response.sendRedirect("pendingRequest.jsp");
                            break;
                        case "Admin":
                            response.sendRedirect("createSoftware.jsp");
                            break;
                        default:
                            response.sendRedirect("login.jsp");
                            break;
                    }
                } else {
                    // Invalid credentials
                    request.setAttribute("errorMessage", "Invalid username or password.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle SQL exception
            request.setAttribute("errorMessage", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}