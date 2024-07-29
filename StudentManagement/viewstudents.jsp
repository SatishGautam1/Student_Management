<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Dashboard - SB Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        /* Style adjustments for the content layout */
        #layoutSidenav_content {
            margin-left: 220px;
        }
        .table {
            margin-top: 20px;
        }
        .form-inline {
            margin-bottom: 20px;
        }
        .action-buttons a {
            margin-right: 10px;
        }
        .card .mb-4 {
            width: fit-content;
        } 
    </style>
    <script>
        /* Function to filter the table based on the selected class */
        function filterTable() {
            var select = document.getElementById("classFilter");
            var filter = select.value.toUpperCase();
            var table = document.getElementById("studentsTable");
            var tr = table.getElementsByTagName("tr");
            
            for (var i = 1; i < tr.length; i++) { // Skip header row
                var td = tr[i].getElementsByTagName("td")[9]; // Index of class column
                if (td) {
                    var textValue = td.textContent || td.innerText;
                    if (textValue.toUpperCase().indexOf(filter) > -1 || filter === "") {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }

        /* Function to confirm deletion of a student */
        function confirmDelete(studentId) {
            return confirm('Are you sure you want to delete this student?');
        }
    </script>
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
        <!-- User account dropdown -->
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
                            <!-- Navigation links for student management -->
                            <div class="sb-sidenav-menu-heading">Students</div>
                            <a class="nav-link" href="addstudents.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-user-plus"></i></div>
                                Add Student
                            </a>
                            <a class="nav-link" href="viewstudents.jsp">
                                <div class="sb-nav-link-icon"><i class="fas fa-user-graduate"></i></div>
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
                    <h1 class="mt-4">Dashboard</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="student.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">View Students</li>
                    </ol>

                    <!-- Card containing the students table -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-table me-1"></i>
                            Students List
                        </div>
                        <div class="card-body">
                            <!-- Dropdown for filtering by class -->
                            <div class="form-inline mb-3">
                                <label for="classFilter" class="form-label me-2">Select Class:</label>
                                <select id="classFilter" class="form-select" onchange="filterTable()">
                                    <option value="">All Classes</option>
                                    <% 
                                        Connection conn = null;
                                        Statement stmt = null;
                                        ResultSet rsClasses = null;
                                        String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                                        String USERNAME = "root";
                                        String PASSWORD = "root";

                                        try {
                                            // Connect to the database and fetch distinct class names
                                            Class.forName("org.mariadb.jdbc.Driver");
                                            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                            stmt = conn.createStatement();
                                            String sqlClasses = "SELECT DISTINCT class FROM Students";
                                            rsClasses = stmt.executeQuery(sqlClasses);
                                            while (rsClasses.next()) {
                                                String className = rsClasses.getString("class");
                                    %>
                                    <option value="<%= className %>"><%= className %></option>
                                    <% 
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsClasses != null) {
                                                try { rsClasses.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                            if (stmt != null) {
                                                try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                            if (conn != null) {
                                                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <!-- Table displaying student details -->
                            <table id="studentsTable" class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>First Name</th>
                                        <th>Last Name</th>
                                        <th>Date of Birth</th>
                                        <th>Gender</th>
                                        <th>Address</th>
                                        <th>Phone Number</th>
                                        <th>Email</th>
                                        <th>Enrollment Date</th>
                                        <th>Class</th>
                                        <th>Manage</th>
                                        <th>Delete</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        Connection conn2 = null;
                                        Statement stmt2 = null;
                                        ResultSet rs2 = null;
                                        String sql2 = "SELECT * FROM Students";

                                        try {
                                            // Connect to the database and fetch student data
                                            Class.forName("org.mariadb.jdbc.Driver");
                                            conn2 = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                            stmt2 = conn2.createStatement();
                                            rs2 = stmt2.executeQuery(sql2);
                                            while (rs2.next()) {
                                                int id = rs2.getInt("student_id"); // Adjusted column name to 'student_id'
                                                String firstName = rs2.getString("first_name");
                                                String lastName = rs2.getString("last_name");
                                                java.sql.Date dateOfBirth = rs2.getDate("date_of_birth");
                                                String gender = rs2.getString("gender");
                                                String address = rs2.getString("address");
                                                String phoneNumber = rs2.getString("phone_number");
                                                String email = rs2.getString("email");
                                                java.sql.Date enrollmentDate = rs2.getDate("enrollment_date");
                                                String className = rs2.getString("class");
                                    %>
                                    <tr>
                                        <td><%= id %></td>
                                        <td><%= firstName %></td>
                                        <td><%= lastName %></td>
                                        <td><%= dateOfBirth %></td>
                                        <td><%= gender %></td>
                                        <td><%= address %></td>
                                        <td><%= phoneNumber %></td>
                                        <td><%= email %></td>
                                        <td><%= enrollmentDate %></td>
                                        <td><%= className %></td>
                                        <td class="action-buttons">
                                            <a href="managestudents.jsp?id=<%= id %>" class="btn btn-primary btn-sm">Manage</a>
                                        </td>
                                        <td class="action-buttons">
                                            <form action="deleteStudent.jsp" method="post" onsubmit="return confirmDelete(<%= id %>);">
                                                <input type="hidden" name="student_id" value="<%= id %>" />
                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rs2 != null) {
                                                try { rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                            if (stmt2 != null) {
                                                try { stmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                            if (conn2 != null) {
                                                try { conn2.close(); } catch (SQLException e) { e.printStackTrace(); }
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- External JavaScript libraries and scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="assets/demo/chart-area-demo.js"></script>
    <script src="assets/demo/chart-bar-demo.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="js/datatables-simple-demo.js"></script>
</body>
</html>
