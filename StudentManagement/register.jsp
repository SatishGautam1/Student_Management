    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.DriverManager, java.sql.SQLException" %>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Register - SB Admin</title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="bg-primary">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-7">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">Create Account</h3></div>
                                    <div class="card-body">
                                        <form method="POST" action="register.jsp">
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="inputFirstName" name="firstName" type="text" placeholder="Enter your first name" required />
                                                        <label for="inputFirstName">First name</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating">
                                                        <input class="form-control" id="inputLastName" name="lastName" type="text" placeholder="Enter your last name" required />
                                                        <label for="inputLastName">Last name</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="inputEmail" name="email" type="email" placeholder="name@example.com" required />
                                                <label for="inputEmail">Email address</label>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="inputPassword" name="password" type="password" placeholder="Create a password" required />
                                                        <label for="inputPassword">Password</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="inputPasswordConfirm" name="confirmPassword" type="password" placeholder="Confirm password" required />
                                                        <label for="inputPasswordConfirm">Confirm Password</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mt-4 mb-0">
                                                <div class="d-grid"><button class="btn btn-primary btn-block" type="submit">Create Account</button></div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small"><a href="login.jsp">Have an account? Go to login</a></div>
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
    </body>
    </html>

    <%-- Java code to process registration form submission --%>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Retrieve form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // Check if passwords match
            if (!password.equals(confirmPassword)) {
                out.println("<p style='text-align: center; color: red;'>Passwords do not match. Please try again.</p>");
            } else {
                // Database connection details
                String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                String USERNAME = "root";
                String PASSWORD = "root";

                Connection con = null;
                PreparedStatement psRegister = null;
                PreparedStatement psLogin = null;

                try {
                    // Load MariaDB driver
                    Class.forName("org.mariadb.jdbc.Driver");

                    // Establish connection
                    con = DriverManager.getConnection(URL, USERNAME, PASSWORD);

                    // SQL query to insert user data into Register table
                    String sqlRegister = "INSERT INTO Register (firstname, lastname, email, password, confirm_password) VALUES (?, ?, ?, ?, ?)";
                    psRegister = con.prepareStatement(sqlRegister);
                    psRegister.setString(1, firstName);
                    psRegister.setString(2, lastName);
                    psRegister.setString(3, email);
                    psRegister.setString(4, password);
                    psRegister.setString(5, confirmPassword);

                    // Execute insert query for Register table
                    int rowsInsertedRegister = psRegister.executeUpdate();

                    // SQL query to insert user data into Login table
                    String sqlLogin = "INSERT INTO Login (email, password) VALUES (?, ?)";
                    psLogin = con.prepareStatement(sqlLogin);
                    psLogin.setString(1, email);
                    psLogin.setString(2, password);

                    // Execute insert query for Login table
                    int rowsInsertedLogin = psLogin.executeUpdate();

                    if (rowsInsertedRegister > 0 && rowsInsertedLogin > 0) {
                        // Successful insertion, redirect to login.jsp with success message
                        response.sendRedirect("login.jsp?success=1");
                    } else {
                        // Insertion failed
                        out.println("<p style='text-align: center; color: red;'>Failed to register. Please try again.</p>");
                    }
                } catch (ClassNotFoundException | SQLException e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Close resources
                    try {
                        if (psRegister != null) {
                            psRegister.close();
                        }
                        if (psLogin != null) {
                            psLogin.close();
                        }
                        if (con != null) {
                            con.close();
                        }
                    } catch (SQLException e) {
                        out.println("<p>Error closing database connection: " + e.getMessage() + "</p>");
                    }
                }
            }
        }
    %>
