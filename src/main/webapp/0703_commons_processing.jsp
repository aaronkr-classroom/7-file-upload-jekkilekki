<!-- 0703_commons_processing.jsp -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload2.*" %>
<%@ page import="org.apache.commons.fileupload2.disk.*" %>
<%@ page import="org.apache.commons.fileupload2.javax.servlet.*" %>
<%@ page import="org.apache.commons.fileupload2.FileItem" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Data Printing</title>
</head>
<body>
<%
    String path = "C:\\upload";
    File uploadDir = new File(path);
    
    // Create the directory if it doesn't exist
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    // Check that we have a file upload request
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if (isMultipart) {
        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();
        
        // Set memory threshold
        factory.setSizeThreshold(4096);
        factory.setRepository(uploadDir); // Set repository for temp files

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(1000000); // Set maximum file size

        try {
            // Parse the request
            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String name = item.getFieldName();
                    String value = item.getString(StandardCharsets.UTF_8);
                    out.println(name + " = " + value + "<br>"); 
                } else {
                    String fileFieldName = item.getFieldName();
                    String fileName = item.getName();
                    String contentType = item.getContentType();

                    // Get the actual file name
                    fileName = new File(fileName).getName(); // Updated to use File

                    long fileSize = item.getSize();
                    File file = new File(uploadDir, fileName);
                    
                    // Save the file
                    item.write(file);
                    
                    out.println("-----------------------------------<br>");
                    out.println("요청 파라미터 이름: " + fileFieldName + "<br>");
                    out.println("저장 파일 이름: " + fileName + "<br>");
                    out.println("파일 콘텐츠 유형: " + contentType + "<br>");
                    out.println("파일 크기: " + fileSize);
                }
            }
        } catch (Exception e) {
            out.println("파일 업로드 중 오류가 발생했습니다: " + e.getMessage());
        }
    } else {
        out.println("업로드 요청이 아닙니다.");
    }
%>
</body>
</html>














