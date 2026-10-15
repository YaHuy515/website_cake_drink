<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="dal.DBContext" %>
<html>
<head>
    <title>Database Diagnosis</title>
</head>
<body>
<h2>Database Diagnosis</h2>
<%
    try {
        // Create an instance of a class that extends DBContext to borrow its connection
        class TestDAO extends dal.DBContext {
            public Connection getConn() {
                return this.connection;
            }
        }
        TestDAO dao = new TestDAO();
        Connection conn = dao.getConn();
        if (conn == null) {
            out.println("<p style='color:red;'>Connection is null!</p>");
        } else {
            out.println("<p style='color:green;'>Connected successfully to database!</p>");
            
            // Check if Vouchers table exists
            DatabaseMetaData dbm = conn.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "Vouchers", null);
            if (tables.next()) {
                out.println("<p style='color:green;'>Table 'Vouchers' exists.</p>");
                
                // Print columns
                out.println("<h3>Vouchers Table Structure:</h3><ul>");
                ResultSet columns = dbm.getColumns(null, null, "Vouchers", null);
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String datatype = columns.getString("TYPE_NAME");
                    int columnSize = columns.getInt("COLUMN_SIZE");
                    out.println("<li>" + columnName + " (" + datatype + ", size: " + columnSize + ")</li>");
                }
                out.println("</ul>");
            } else {
                out.println("<p style='color:red;'>Table 'Vouchers' DOES NOT exist!</p>");
            }
            
            // Check Orders table columns
            out.println("<h3>Orders Table Voucher Columns:</h3><ul>");
            ResultSet orderCols = dbm.getColumns(null, null, "Orders", null);
            boolean hasVoucherCode = false;
            boolean hasDiscountAmount = false;
            while (orderCols.next()) {
                String columnName = orderCols.getString("COLUMN_NAME");
                if ("voucher_code".equalsIgnoreCase(columnName)) hasVoucherCode = true;
                if ("discount_amount".equalsIgnoreCase(columnName)) hasDiscountAmount = true;
            }
            out.println("<li>voucher_code exists: " + (hasVoucherCode ? "<span style='color:green;'>YES</span>" : "<span style='color:red;'>NO</span>") + "</li>");
            out.println("<li>discount_amount exists: " + (hasDiscountAmount ? "<span style='color:green;'>YES</span>" : "<span style='color:red;'>NO</span>") + "</li>");
            out.println("</ul>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error occurred: " + e.getMessage() + "</p>");
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        out.println("<pre>" + sw.toString() + "</pre>");
    }
%>
</body>
</html>
