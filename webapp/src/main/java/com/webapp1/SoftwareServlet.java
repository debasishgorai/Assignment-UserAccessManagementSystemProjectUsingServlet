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

@WebServlet("/createSoftware")
public class SoftwareServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String softwareName = request.getParameter("softwareName");
        String description = request.getParameter("description");
        String[] accessLevels = request.getParameterValues("accessLevels");

        // Convert access levels array to a comma-separated string
        String accessLevelsString = (accessLevels != null) ? String.join(", ", accessLevels) : "";

        // Insert software details into the database
        try (Connection connection = Database.getConnection()) {
            String sql = "INSERT INTO software (name, description, access_levels) VALUES (?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, softwareName);
                statement.setString(2, description);
                statement.setString(3, accessLevelsString);
                statement.executeUpdate();
            }
            response.sendRedirect("success.jsp"); // Redirect to a success page
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle SQL exception
            request.setAttribute("errorMessage", "An error occurred while adding software. Please try again.");
            request.getRequestDispatcher("createSoftware.jsp").forward(request, response);
        }
    }

}
