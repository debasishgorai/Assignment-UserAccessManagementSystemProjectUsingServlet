<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
</head>
<body>
    <h2>Sign Up</h2>
    <form action="signup" method="post">
        <label for="username">Username:</label>
        <input type="text" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" name="password" required><br>
          <input type="hidden" name="role" value="Employee">
        <input type="submit" value="Sign Up">
    </form>
    <p style="color:red;">
        <c:if test="${not empty param.error}">${param.error}</c:if>
    </p>
    <p style="color:green;">
        <c:if test="${not empty param.success}">${param.success}</c:if>
    </p>
</body>
</html>