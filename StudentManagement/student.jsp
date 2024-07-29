<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Dashboard - SB Admin</title>
    
    <!-- Link to CSS styles -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        #layoutSidenav_content {
            margin-top: 10px;
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
                    <div class="row">
                        
                        <!-- Total Students Card -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-primary text-white mb-4">
                                <div class="card-body">
                                    <% 
                                    int totalStudents = 0;
                                    String jdbcURL = "jdbc:mariadb://localhost:3306/Std_Mgmt_Sys";
                                    String dbUser = "root";
                                    String dbPassword = "root";

                                    try {
                                        Class.forName("org.mariadb.jdbc.Driver");
                                        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                        Statement statement = connection.createStatement();
                                        String sql = "SELECT COUNT(*) AS total FROM Students";
                                        ResultSet resultSet = statement.executeQuery(sql);

                                        if (resultSet.next()) {
                                            totalStudents = resultSet.getInt("total");
                                        }

                                        resultSet.close();
                                        statement.close();
                                        connection.close();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    %>
                                    Total Students: <%= totalStudents %>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="text-white stretched-link" href="viewstudents.jsp">View Details</a>
                                    <div class="small"><i class="fas fa-chevron-right"></i></div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Total Classes Card -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-warning text-white mb-4">
                                <div class="card-body">
                                    <% 
                                    int totalClasses = 0;

                                    try {
                                        Class.forName("org.mariadb.jdbc.Driver");
                                        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                        Statement statement = connection.createStatement();
                                        String sql = "SELECT COUNT(DISTINCT class) AS total FROM Students";
                                        ResultSet resultSet = statement.executeQuery(sql);

                                        if (resultSet.next()) {
                                            totalClasses = resultSet.getInt("total");
                                        }

                                        resultSet.close();
                                        statement.close();
                                        connection.close();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    %>
                                    Total Classes: <%= totalClasses %>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="text-white stretched-link" href="viewclasses.jsp">View Details</a>
                                    <div class="small"><i class="fas fa-chevron-right"></i></div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Male/Female Ratio Card -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-success text-white mb-4">
                                <div class="card-body">
                                    <% 
                                    int totalMales = 0;
                                    int totalFemales = 0;

                                    try {
                                      
                                        

                                        Class.forName("org.mariadb.jdbc.Driver");
                                        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                        Statement statement = connection.createStatement();
                                        String sql = "SELECT COUNT(*) AS total FROM Students WHERE gender = 'Male'";
                                        ResultSet resultSet = statement.executeQuery(sql);

                                        if (resultSet.next()) {
                                            totalMales = resultSet.getInt("total");
                                        }

                                        sql = "SELECT COUNT(*) AS total FROM Students WHERE gender = 'Female'";
                                        resultSet = statement.executeQuery(sql);

                                        if (resultSet.next()) {
                                            totalFemales = resultSet.getInt("total");
                                        }

                                        resultSet.close();
                                        statement.close();
                                        connection.close();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    %>
                                    Male/Female Ratio: <%= totalMales %> / <%= totalFemales %>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="text-white stretched-link" href="viewstudents.jsp">View Details</a>
                                    <div class="small"><i class="fas fa-chevron-right"></i></div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Upcoming Birthdays Card -->
                        <div class="col-xl-3 col-md-6">
                            <div class="card bg-info text-white mb-4">
                                <div class="card-body">
                                    <% 
                                    StringBuilder upcomingBirthdays = new StringBuilder();

                                    try {
                                        Class.forName("org.mariadb.jdbc.Driver");
                                        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                                        Statement statement = connection.createStatement();
                                        String sql = "SELECT name, DATE_FORMAT(birthdate, '%M %d') AS birthday FROM Students WHERE birthdate >= CURDATE() AND birthdate < CURDATE() + INTERVAL 1 MONTH ORDER BY birthdate";
                                        ResultSet resultSet = statement.executeQuery(sql);

                                        while (resultSet.next()) {
                                            String name = resultSet.getString("name");
                                            String birthday = resultSet.getString("birthday");
                                            upcomingBirthdays.append(name).append(" (").append(birthday).append(")<br>");
                                        }

                                        resultSet.close();
                                        statement.close();
                                        connection.close();
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                    %>
                                    Upcoming Birthdays: <br><%= upcomingBirthdays.toString() %>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="text-white stretched-link" href="viewbirthdays.jsp">View Details</a>
                                    <div class="small"><i class="fas fa-chevron-right"></i></div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Link to JavaScript files -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="js/datatables-simple-demo.js"></script>
</body>
</html>
