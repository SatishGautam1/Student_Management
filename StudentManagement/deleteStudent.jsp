<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Delete Student - Dashboard</title>
    <!-- Linking external CSS files for styles -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <!-- Linking Font Awesome for icons -->
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        /* Custom styling for layout and messages */
        #layoutSidenav_content {
            margin-top: 70px;
            margin-left: 220px;
        }
        .message {
            margin-top: 20px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <!-- Navigation bar -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <a class="navbar-brand ps-3" href="student.jsp">Admin Dashboard</a>
        <!-- Navigation code (omitted for brevity) -->
    </nav>
    <div id="layoutSidenav">
        <!-- Sidebar code (omitted for brevity) -->
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Delete Student</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="student.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">Delete Student</li>
                    </ol>

                    <!-- Card for delete student functionality -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-trash me-1"></i>
                            Delete Student
                        </div>
                        <div class="card-body">
                            <%
                                // Retrieve student ID from request parameters
                                String studentId = request.getParameter("student_id");
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                                String USERNAME = "root";
                                String PASSWORD = "root";
                                boolean success = false;

                                try {
                                    // Load MariaDB JDBC driver
                                    Class.forName("org.mariadb.jdbc.Driver");
                                    // Establish database connection
                                    conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                    // SQL query to delete a student record
                                    String sql = "DELETE FROM Students WHERE student_id = ?";
                                    pstmt = conn.prepareStatement(sql);
                                    // Set student ID parameter for the SQL statement
                                    pstmt.setInt(1, Integer.parseInt(studentId));
                                    // Execute the delete query
                                    int rowsAffected = pstmt.executeUpdate();
                                    
                                    // Check if the student record was deleted successfully
                                    success = rowsAffected > 0;
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    // Close database resources
                                    if (pstmt != null) {
                                        try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    }
                                    if (conn != null) {
                                        try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    }
                                }
                            %>

                            <div class="message">
                                <%
                                    // Display success or failure message based on the result
                                    if (success) {
                                %>
                                <div class="alert alert-success" role="alert">
                                    Student has been successfully deleted.
                                </div>
                                <% 
                                    } else { 
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Failed to delete the student. Please try again.
                                </div>
                                <% 
                                    }
                                %>
                                <!-- Button to navigate back to the student list -->
                                <a href="viewstudents.jsp" class="btn btn-primary">Back to Student List</a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Footer section -->
    <footer class="py-4 bg-light mt-auto">
        <div class="container-fluid px-4">
            <div class="d-flex align-items-center justify-content-between small">
                <div class="text-muted">Copyright &copy; Your Website 2023</div>
                <div>
                    <a href="#">Privacy Policy</a>
                    &middot;
                    <a href="#">Terms &amp; Conditions</a>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- Linking external JavaScript files -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="assets/demo/chart-area-demo.js"></script>
    <script src="assets/demo/chart-bar-demo.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="js/datatables-simple-demo.js"></script>
</body>
</html>
