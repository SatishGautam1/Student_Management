<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Manage Student - Admin Dashboard</title>
    <!-- Linking external CSS files -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <!-- Linking Font Awesome for icons -->
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        /* Custom styles */
        #layoutSidenav_content {
            margin-top: 70px;
            margin-left: 220px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <!-- Top navigation bar -->
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
    <div id="layoutSidenav">
        <!-- Sidebar navigation -->
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

        <!-- Main content -->
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Manage Student</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="student.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">Manage Student</li>
                    </ol>

                    <!-- Card to show the form for editing student data -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-user-edit me-1"></i>
                            Edit Student Information
                        </div>
                        <div class="card-body">
                            <%
                                // Database connection variables
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                                String USERNAME = "root";
                                String PASSWORD = "root";
                                // Get the student ID from the request parameter
                                String studentId = request.getParameter("id");
                                // SQL query to fetch the student data
                                String sql = "SELECT * FROM Students WHERE student_id = ?";

                                if (studentId != null) {
                                    try {
                                        // Establish the database connection
                                        Class.forName("org.mariadb.jdbc.Driver");
                                        conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                        // Prepare the SQL statement with the student ID
                                        pstmt = conn.prepareStatement(sql);
                                        pstmt.setInt(1, Integer.parseInt(studentId));
                                        // Execute the query and get the result set
                                        rs = pstmt.executeQuery();
                                        if (rs.next()) {
                            %>
                            <!-- Form to update student data -->
                            <form action="updateStudent.jsp" method="post">
                                <!-- Hidden input to store student ID -->
                                <input type="hidden" name="student_id" value="<%= rs.getInt("student_id") %>" />
                                <div class="mb-3">
                                    <label for="firstName" class="form-label">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="first_name" value="<%= rs.getString("first_name") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="lastName" class="form-label">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="last_name" value="<%= rs.getString("last_name") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="date_of_birth" value="<%= rs.getDate("date_of_birth") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select id="gender" name="gender" class="form-select" required>
                                        <option value="Male" <%= "Male".equals(rs.getString("gender")) ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(rs.getString("gender")) ? "selected" : "" %>>Female</option>
                                        <option value="Other" <%= "Other".equals(rs.getString("gender")) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3" required><%= rs.getString("address") %></textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" id="phoneNumber" name="phone_number" value="<%= rs.getString("phone_number") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= rs.getString("email") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="enrollmentDate" class="form-label">Enrollment Date</label>
                                    <input type="date" class="form-control" id="enrollmentDate" name="enrollment_date" value="<%= rs.getDate("enrollment_date") %>" required />
                                </div>
                                <div class="mb-3">
                                    <label for="class" class="form-label">Class</label>
                                    <input type="text" class="form-control" id="class" name="class" value="<%= rs.getString("class") %>" required />
                                </div>
                                <!-- Submit button to update student data -->
                                <button type="submit" class="btn btn-primary">Update Student</button>
                            </form>
                            <% 
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        // Close resources
                                        if (rs != null) {
                                            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                        }
                                        if (pstmt != null) {
                                            try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                        }
                                        if (conn != null) {
                                            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                        }
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
