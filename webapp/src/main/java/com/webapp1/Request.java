package com.webapp1;


public class Request {
    private int id; // Unique identifier for the request
    private int userId; // Identifier for the user making the request
    private int softwareId; // Identifier for the software requested
    private String accessType; // Type of access requested (e.g., Read, Write)
    private String reason; // Reason for the request
    private String status; // Status of the request (e.g., Pending, Approved, Rejected)

    // Constructor
    public Request() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getSoftwareId() {
        return softwareId;
    }

    public void setSoftwareId(int softwareId) {
        this.softwareId = softwareId;
    }

    public String getAccessType() {
        return accessType;
    }

    public void setAccessType(String accessType) {
        this.accessType = accessType;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
