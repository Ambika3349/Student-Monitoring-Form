package com.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

    // ================= GET =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	response.sendRedirect("StudentForm.jsp");
    }

    // ================= POST =================
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        PrintWriter out = response.getWriter();

        try {
            con = DBConnection.getConnection();

            if (con == null) {
                out.println("<h3 style='color:red;'>Database connection failed!</h3>");
                return;
            }
         // ================= DELETE FIRST =================
            if ("Delete".equals(action)) {

                long slno = Long.parseLong(request.getParameter("slno"));

                ps = con.prepareStatement("DELETE FROM STUDENT_DETAILS WHERE SLNO=?");
                ps.setLong(1, slno);
                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Deleted");
                return;
            }

            // ================= GET FORM DATA =================
            String perFrom = request.getParameter("perform");
            String perUpto = request.getParameter("perupto");

            // ================= DATE VALIDATION =================
         // From Date mandatory
            if (perFrom == null || perFrom.isEmpty()) {
            	request.setAttribute("error", "From Date is required");
            	request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
            	return;  
            }

            // To Date optional but if given must be >= From Date
            if (perUpto != null && !perUpto.isEmpty() &&
                    perFrom.compareTo(perUpto) > 0) {

            	request.setAttribute("error", "From Date cannot be greater than To Date");
            	request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
            	return;	
            }
            
            String pincode = request.getParameter("pincode");
            String phone = request.getParameter("phno");
            String aadhaar = request.getParameter("aadhaar");

            // Pincode validation
            if(pincode != null && !pincode.matches("\\d{6}")){
                request.setAttribute("error", "Pincode must be 6 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request,response);
                return;
            }

            // Phone validation
            if(phone != null && !phone.matches("\\d{10}")){
                request.setAttribute("error", "Phone number must be 10 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request,response);
                return;
            }

            // Aadhaar validation
            if(aadhaar != null && !aadhaar.matches("\\d{12}")){
                request.setAttribute("error", "Aadhaar number must be 12 digits");
                request.getRequestDispatcher("StudentForm.jsp").forward(request,response);
                return;
            }

            // ================= SAVE =================
            if ("Save".equals(action)) {

                // Generate SLNO (YYYYMMNNN)
                String yearMonth = perFrom.substring(0,7).replace("-", ""); // 2026-12 -> 202612
                long baseNumber = Long.parseLong(yearMonth) * 1000;

                PreparedStatement psSeq = con.prepareStatement(
                    "SELECT NVL(MAX(SLNO),0) FROM STUDENT_DETAILS WHERE SLNO BETWEEN ? AND ?"
                );

                psSeq.setLong(1, baseNumber);
                psSeq.setLong(2, baseNumber + 999);

                ResultSet rsSeq = psSeq.executeQuery();

                long slno = baseNumber + 1;

                if(rsSeq.next() && rsSeq.getLong(1) > 0){
                    slno = rsSeq.getLong(1) + 1;
                }
                rsSeq.close();
                psSeq.close();

                // Auto COLUMN_NO generation
                int columnNo = 1;
                ps = con.prepareStatement("SELECT NVL(MAX(COLUMN_NO),0)+1 FROM STUDENT_DETAILS");
                rs = ps.executeQuery();
                if (rs.next()) {
                    columnNo = rs.getInt(1);
                }
                ps.close();

                String sql = "INSERT INTO STUDENT_DETAILS "
                        + "(SLNO,COLUMN_NO,F_V2PERSNO,F_V2NAME,F_V2QUALF,F_V2BRANCH,F_V2STREET,"
                        + "F_V2DISTRICT,F_V2STATE,PINCODE,F_V2UNIVERSITY,"
                        + "F_V2GUIDE,F_V2SECTION,F_V2DIR,PROJECTNAME,COLLEGE,"
                        + "DOCUMENTATION,F_V2PHNO,F_V2AADHAARNO,PERFROM,PERUPTO) "
                        + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                ps = con.prepareStatement(sql);

                ps.setLong(1, slno);
                ps.setInt(2, columnNo);

                setValues(ps, request, perFrom, perUpto, 3);

                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Saved");
            }

            // ================= UPDATE =================
            else if ("Update".equals(action)) {

                long slno = Long.parseLong(request.getParameter("slno"));

                String sql = "UPDATE STUDENT_DETAILS SET "
                        + "F_V2PERSNO=?,F_V2NAME=?,F_V2QUALF=?,F_V2BRANCH=?,"
                        + "F_V2STREET=?,F_V2DISTRICT=?,F_V2STATE=?,PINCODE=?,"
                        + "F_V2UNIVERSITY=?,F_V2GUIDE=?,F_V2SECTION=?,F_V2DIR=?,"
                        + "PROJECTNAME=?,COLLEGE=?,DOCUMENTATION=?,F_V2PHNO=?,"
                        + "F_V2AADHAARNO=?,PERFROM=?,PERUPTO=? "
                        + "WHERE SLNO=?";

                ps = con.prepareStatement(sql);
                setValues(ps, request, perFrom, perUpto, 1);
                ps.setLong(20, slno);
                ps.executeUpdate();

                response.sendRedirect("StudentForm.jsp?msg=Updated");
            }
 
        }catch (Exception e) {

                String message = "Something went wrong while saving data";

                if (e.getMessage().contains("PINCODE")) {
                    message = "Pincode should not exceed 10 digits";
                }
                else if (e.getMessage().contains("F_V2PHNO")) {
                    message = "Phone number is too long";
                }
                else if (e.getMessage().contains("F_V2AADHAARNO")) {
                    message = "Aadhaar number should be 12 digits only";
                }

                request.setAttribute("error", message);
                request.getRequestDispatcher("StudentForm.jsp").forward(request, response);
            }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                if(con!=null) con.close();
            }catch(Exception e){}
        } 
        }
    
    // ================= SET VALUES =================
    private void setValues(PreparedStatement ps, HttpServletRequest request,
                           String perFrom, String perUpto, int startIndex) throws Exception {

        ps.setString(startIndex++, request.getParameter("persno"));
        ps.setString(startIndex++, request.getParameter("name"));
        ps.setString(startIndex++, request.getParameter("qualf"));
        ps.setString(startIndex++, request.getParameter("branch"));
        ps.setString(startIndex++, request.getParameter("street"));
        ps.setString(startIndex++, request.getParameter("district"));
        ps.setString(startIndex++, request.getParameter("state"));
        ps.setString(startIndex++, request.getParameter("pincode"));
        ps.setString(startIndex++, request.getParameter("university"));
        ps.setString(startIndex++, request.getParameter("guide"));
        ps.setString(startIndex++, request.getParameter("section"));
        ps.setString(startIndex++, request.getParameter("dir"));
        ps.setString(startIndex++, request.getParameter("project"));
        ps.setString(startIndex++, request.getParameter("college"));
        ps.setString(startIndex++, request.getParameter("doc"));
        ps.setString(startIndex++, request.getParameter("phno"));
        ps.setString(startIndex++, request.getParameter("aadhaar"));

        if (perFrom != null && !perFrom.isEmpty())
            ps.setDate(startIndex++, Date.valueOf(perFrom));
        else
            ps.setNull(startIndex++, Types.DATE);

        if (perUpto != null && !perUpto.isEmpty())
            ps.setDate(startIndex++, Date.valueOf(perUpto));
        else
            ps.setNull(startIndex++, Types.DATE);
    }
}