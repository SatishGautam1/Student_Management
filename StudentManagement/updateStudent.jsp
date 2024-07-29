<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Update Student - Admin Dashboard</title>
    <!-- Linking external CSS files for styles -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <!-- Linking Font Awesome for icons -->
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        /* Custom styling for layout */
        #layoutSidenav_content {
            margin-top: 70px;
            margin-left: 220px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <!-- Navigation bar -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <a class="navbar-brand ps-3" href="student.jsp">Admin Dashboard</a>
        <!-- Search form -->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <div class="input-group">
                <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                <button class="btn btn-primary" id="btnNavbarSearch" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>
        <!-- User menu -->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user fa-fw"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li><a class="dropdown-item" href="#!">Settings</a></li>
                    <li><a class="dropdown-item" href="#!">Activity Log</a></li>
                    <li><hr class="dropdown-divider" /></li>
                    <li><a class="dropdown-item" href="login.jsp">Logout</a></li>
                </ul>
            </li>
        </ul>
    </nav>
    
    <!-- Side navigation bar -->
    <div id="layoutSidenav">
        <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion" aria-label="Sidebar">
                <div class="sb-sidenav-content">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
                            <div class="sb-sidenav-menu-heading">Core</div>
                            <!-- Links for adding and viewing students -->
                            <a class="nav-link" href="addstudents.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                Add Student
                            </a>
                            <a class="nav-link" href="viewstudents.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                View Student
                            </a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>

        <!-- Main content area -->
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Update Student</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="student.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">Update Student</li>
                    </ol>

                    <!-- Card for showing update status -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-user-edit me-1"></i>
                            Student Update Status
                        </div>
                        <div class="card-body">
                            <%
                                // Initialize database connection and SQL statement objects
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                                String USERNAME = "root";
                                String PASSWORD = "root";

                                // Retrieve student information from request parameters
                                String studentId = request.getParameter("student_id");
                                String firstName = request.getParameter("first_name");
                                String lastName = request.getParameter("last_name");
                                String dateOfBirth = request.getParameter("date_of_birth");
                                String gender = request.getParameter("gender");
                                String address = request.getParameter("address");
                                String phoneNumber = request.getParameter("phone_number");
                                String email = request.getParameter("email");
                                String enrollmentDate = request.getParameter("enrollment_date");
                                String studentClass = request.getParameter("class");

                                // SQL query to update student details
                                String updateSQL = "UPDATE Students SET first_name = ?, last_name = ?, date_of_birth = ?, gender = ?, address = ?, phone_number = ?, email = ?, enrollment_date = ?, class = ? WHERE student_id = ?";

                                try {
                                    // Load MariaDB JDBC driver
                                    Class.forName("org.mariadb.jdbc.Driver");
                                    // Establish database connection
                                    conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                    // Prepare the SQL statement
                                    pstmt = conn.prepareStatement(updateSQL);
                                    // Set parameters for the SQL statement
                                    pstmt.setString(1, firstName);
                                    pstmt.setString(2, lastName);
                                    pstmt.setDate(3, java.sql.Date.valueOf(dateOfBirth));
                                    pstmt.setString(4, gender);
                                    pstmt.setString(5, address);
                                    pstmt.setString(6, phoneNumber);
                                    pstmt.setString(7, email);
                                    pstmt.setDate(8, java.sql.Date.valueOf(enrollmentDate));
                                    pstmt.setString(9, studentClass);
                                    pstmt.setInt(10, Integer.parseInt(studentId));

                                    // Execute the update query
                                    int rowsUpdated = pstmt.executeUpdate();
                                    if (rowsUpdated > 0) {
                            %>
                            <!-- Success message if update is successful -->
                            <div class="alert alert-success" role="alert">
                                Student information updated successfully!
                            </div>
                            <% 
                                    } else {
                            %>
                            
                            <!-- Error message if no rows are updated -->
                            <div class="alert alert-danger" role="alert">
                                Error updating student information. Please try again.
                            </div>
                            <% 
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                            %>
                            <!-- Display any exception that occurs -->
                            <div class="alert alert-danger" role="alert">
                                Error: <%= e.getMessage() %>
                            </div>
                            <% 
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
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Linking external JavaScript files -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>
</body>
</html>
