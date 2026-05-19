package com.cinebook.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {

    private static final String MOVIE_DIR   = "movie_posters";
    private static final String PROFILE_DIR = "profile_pictures";

    private static final String BASE_PATH   = System.getProperty("user.home")
                                            + File.separator + "cinebook_uploads";

    // ===== Save Movie Poster =====
    public static String saveUploadedFile(Part filePart,
                                          String uploadPath) throws IOException {
        String fileName       = Paths.get(filePart.getSubmittedFileName())
                                     .getFileName().toString();
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        String fullPath       = BASE_PATH + File.separator + MOVIE_DIR;

        File uploadDir = new File(fullPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(fullPath + File.separator + uniqueFileName);
        return MOVIE_DIR + "/" + uniqueFileName;
    }

    // ===== Save Profile Picture =====
    public static String saveProfilePicture(Part filePart,
                                             String uploadPath) throws IOException {
        String fileName       = Paths.get(filePart.getSubmittedFileName())
                                     .getFileName().toString();
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        String fullPath       = BASE_PATH + File.separator + PROFILE_DIR;

        System.out.println("=== PROFILE UPLOAD DEBUG ===");
        System.out.println("BASE_PATH: " + BASE_PATH);
        System.out.println("FULL_PATH: " + fullPath);
        System.out.println("FILE_NAME: " + uniqueFileName);
        System.out.println("FILE_SIZE: " + filePart.getSize());

        File uploadDir = new File(fullPath);
        System.out.println("DIR EXISTS: " + uploadDir.exists());

        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("DIR CREATED: " + created);
        }

        File destFile = new File(fullPath + File.separator + uniqueFileName);
        filePart.write(destFile.getAbsolutePath());
        System.out.println("FILE WRITTEN TO: " + destFile.getAbsolutePath());
        System.out.println("============================");

        return PROFILE_DIR + "/" + uniqueFileName;
    }

    // ===== Get Base Path (used by ImageServlet) =====
    public static String getBasePath() {
        return BASE_PATH;
    }
}