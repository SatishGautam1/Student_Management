<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.DriverManager, java.sql.SQLException, javax.servlet.http.Cookie" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Login - SB Admin</title>
    <link href="css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="bg-primary">
    <div id="layoutAuthentication">
        <div id="layoutAuthentication_content">
            <main>
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-5">
                            <div class="card shadow-lg border-0 rounded-lg mt-5">
                                <div class="card-header"><h3 class="text-center font-weight-light my-4">Login</h3></div>
                                <div class="card-body">
                                    <form method="POST" action="login.jsp">
                                        <div class="form-floating mb-3">
                                            <input class="form-control" id="inputEmail" name="email" type="email" placeholder="name@example.com" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required />
                                            <label for="inputEmail">Email address</label>
                                        </div>
                                        <div class="form-floating mb-3">
                                            <input class="form-control" id="inputPassword" name="password" type="password" placeholder="Password" required />
                                            <label for="inputPassword">Password</label>
                                        </div>
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" id="inputRememberPassword" name="rememberMe" type="checkbox" />
                                            <label class="form-check-label" for="inputRememberPassword">Remember Me</label>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                                            <button class="btn btn-primary" type="submit">Login</button>
                                        </div>
                                        <%-- Display error message if login fails --%>
                                        <%
                                            String loginError = (String) request.getAttribute("loginError");
                                            if (loginError != null) {
                                        %>
                                            <div class="alert alert-danger mt-3" role="alert">
                                                <%= loginError %>
                                            </div>
                                        <%
                                            }
                                        %>
                                    </form>
                                </div>
                                <div class="card-footer text-center py-3">
                                    <div class="small"><a href="register.jsp">Need an account? Sign up!</a></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>

    <%-- Java code to process login form submission --%>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Retrieve form data
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String rememberMe = request.getParameter("rememberMe");

            // Database connection details
            String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
            String USERNAME = "root";
            String PASSWORD = "root";

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Load MariaDB driver
                Class.forName("org.mariadb.jdbc.Driver");

                // Establish connection
                con = DriverManager.getConnection(URL, USERNAME, PASSWORD);

                // SQL query to validate user
                String sql = "SELECT * FROM Login WHERE email = ? AND password = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, password);

                // Execute query
                rs = ps.executeQuery();
                if (rs.next()) {
                    // Successful login
                    if ("on".equals(rememberMe)) {
                        // Create a cookie to remember the user
                        Cookie userCookie = new Cookie("user", email);
                        userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                        response.addCookie(userCookie);
                    }

                    // Redirect to student.jsp
                    response.sendRedirect("student.jsp");
                } else {
                    // Login failed, set attribute for error message and email
                    request.setAttribute("loginError", "Invalid email or password. Please try again.");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } catch (ClassNotFoundException | SQLException e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (ps != null) {
                        ps.close();
                    }
                    if (con != null) {
                        con.close();
                    }
                } catch (SQLException e) {
                    out.println("<p>Error closing database connection: " + e.getMessage() + "</p>");
                }
            }
        } else {
            // Handle "Remember Me" cookie
            String email = "";
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("user".equals(cookie.getName())) {
                        email = cookie.getValue();
                        break;
                    }
                }
            }
            // Set email attribute if a cookie is found
            request.setAttribute("email", email);
        }
    %>
</body>
</html>
