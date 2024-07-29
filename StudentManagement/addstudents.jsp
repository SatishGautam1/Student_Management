<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Add Student - Admin Dashboard</title>
    
    <!-- Link to CSS styles -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        #layoutSidenav_content {
            margin-left: 220px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 16px;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    
    <!-- Navigation Bar -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        
        <!-- Navbar Brand -->
        <a class="navbar-brand ps-3" href="student.jsp">Admin Dashboard</a>
        
        <!-- Navbar Search -->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <div class="input-group">
                <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                <button class="btn btn-primary" id="btnNavbarSearch" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>
        
        <!-- User Dropdown -->
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
        
        <!-- Sidebar Navigation -->
        <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion" aria-label="Sidebar">
                <div class="sb-sidenav-content">
                    <div class="sb-sidenav-menu">
                        <div class="nav">
                            
                            <!-- Students Section -->
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
        
        <!-- Main Content -->
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Add Student</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="student.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">Add Student</li>
                    </ol>

                    <!-- Success message area -->
                    <%
                        String message = "";
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        String URL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                        String USERNAME = "root";
                        String PASSWORD = "root";
                        
                        try {
                            // Get form parameters
                            String firstName = request.getParameter("firstName");
                            String lastName = request.getParameter("lastName");
                            String dateOfBirth = request.getParameter("dateOfBirth");
                            String gender = request.getParameter("gender");
                            String address = request.getParameter("address");
                            String phoneNumber = request.getParameter("phoneNumber");
                            String email = request.getParameter("email");
                            String enrollmentDate = request.getParameter("enrollmentDate");
                            String className = request.getParameter("className");
                            
                            // Check if form is submitted
                            if (firstName != null && !firstName.isEmpty()) {
                                
                                // Load the MariaDB JDBC driver
                                Class.forName("org.mariadb.jdbc.Driver");
                                
                                // Establish connection
                                conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                                
                                // Prepare SQL statement
                                String sql = "INSERT INTO Students (first_name, last_name, date_of_birth, gender, address, phone_number, email, enrollment_date, class) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                pstmt = conn.prepareStatement(sql);
                                
                                // Set parameters
                                pstmt.setString(1, firstName);
                                pstmt.setString(2, lastName);
                                pstmt.setDate(3, java.sql.Date.valueOf(dateOfBirth));
                                pstmt.setString(4, gender);
                                pstmt.setString(5, address);
                                pstmt.setString(6, phoneNumber);
                                pstmt.setString(7, email);
                                pstmt.setDate(8, java.sql.Date.valueOf(enrollmentDate));
                                pstmt.setString(9, className);
                                
                                // Execute update
                                int rowsAffected = pstmt.executeUpdate();
                                
                                // Check if the insertion was successful
                                if (rowsAffected > 0) {
                                    message = "Student added successfully.";
                                } else {
                                    message = "Failed to add student.";
                                }
                            }
                        } catch (Exception e) {
                            // Handle exceptions
                            e.printStackTrace();
                            message = "An error occurred: " + e.getMessage();
                        } finally {
                            // Close resources
                            if (pstmt != null) {
                                try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                            }
                            if (conn != null) {
                                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                            }
                        }
                    %>
                    
                    <!-- Display the success message at the top -->
                    <% if (!message.isEmpty()) { %>
                        <div class="alert-success"><%= message %></div>
                    <% } %>
                    
                    <!-- Add Student Form -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-user-plus me-1"></i>
                            Add New Student
                        </div>
                        <div class="card-body">
                            <form method="post">
                                
                                <!-- First Name Field -->
                                <div class="mb-3">
                                    <label for="firstName" class="form-label">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                                </div>
                                
                                <!-- Last Name Field -->
                                <div class="mb-3">
                                    <label for="lastName" class="form-label">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                                </div>
                                
                                <!-- Date of Birth Field -->
                                <div class="mb-3">
                                    <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                </div>
                                
                                <!-- Gender Field -->
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                
                                <!-- Address Field -->
                                <div class="mb-3">
                                    <label for="address" class="form-label">Address</label>
                                    <input type="text" class="form-control" id="address" name="address" required>
                                </div>
                                
                                <!-- Phone Number Field -->
                                <div class="mb-3">
                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" required>
                                </div>
                                
                                <!-- Email Field -->
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                                
                                <!-- Enrollment Date Field -->
                                <div class="mb-3">
                                    <label for="enrollmentDate" class="form-label">Enrollment Date</label>
                                    <input type="date" class="form-control" id="enrollmentDate" name="enrollmentDate" required>
                                </div>
                                
                                <!-- Class Field -->
                                <div class="mb-3">
                                    <label for="className" class="form-label">Class</label>
                                    <input type="text" class="form-control" id="className" name="className" required>
                                </div>
                                
                                <!-- Submit Button -->
                                <button type="submit" class="btn btn-primary">Add Student</button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Bootstrap JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    
    <!-- Custom Scripts -->
    <script src="js/scripts.js"></script>
</body>
</html>
