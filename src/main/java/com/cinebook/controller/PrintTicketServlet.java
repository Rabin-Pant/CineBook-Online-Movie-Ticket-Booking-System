package com.cinebook.controller;

import com.cinebook.dao.BookingDAO;
import com.cinebook.model.Booking;
import com.cinebook.model.Customer;
import com.cinebook.utils.SessionUtil;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import com.itextpdf.text.pdf.draw.LineSeparator;

@WebServlet("/customer/print-ticket")
public class PrintTicketServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int bookingId     = Integer.parseInt(request.getParameter("bookingId"));
            Customer customer = SessionUtil.getLoggedInCustomer(request);
            Booking booking   = bookingDAO.getBookingById(bookingId);

            // Security check
            if (booking == null ||
                booking.getCustomerId() != customer.getCustomerId()) {
                response.sendRedirect(request.getContextPath() +
                    "/customer/bookings");
                return;
            }

            // Set PDF response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                "attachment; filename=CineBook-Ticket-" + bookingId + ".pdf");

            // Generate PDF
            OutputStream out = response.getOutputStream();
            generateTicketPDF(booking, customer, out);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/customer/bookings");
        }
    }

    private void generateTicketPDF(Booking booking, Customer customer,
                                   OutputStream out) throws Exception {

        Document document = new Document(PageSize.A5, 40, 40, 40, 40);
        PdfWriter.getInstance(document, out);
        document.open();

        // ===== FONTS =====
        Font titleFont    = new Font(Font.FontFamily.HELVETICA, 24,
                                     Font.BOLD, new BaseColor(233, 69, 96));
        Font headingFont  = new Font(Font.FontFamily.HELVETICA, 13,
                                     Font.BOLD, new BaseColor(26, 26, 46));
        Font labelFont    = new Font(Font.FontFamily.HELVETICA, 10,
                                     Font.BOLD, new BaseColor(136, 136, 136));
        Font valueFont    = new Font(Font.FontFamily.HELVETICA, 11,
                                     Font.NORMAL, new BaseColor(51, 51, 51));
        Font smallFont    = new Font(Font.FontFamily.HELVETICA, 9,
                                     Font.NORMAL, new BaseColor(136, 136, 136));
        Font successFont  = new Font(Font.FontFamily.HELVETICA, 10,
                                     Font.BOLD, new BaseColor(40, 167, 69));
        Font whiteFont    = new Font(Font.FontFamily.HELVETICA, 20,
                                     Font.BOLD, BaseColor.WHITE);
        Font whiteSm      = new Font(Font.FontFamily.HELVETICA, 10,
                                     Font.NORMAL, BaseColor.WHITE);

        // ===== HEADER BANNER =====
        PdfPTable headerTable = new PdfPTable(1);
        headerTable.setWidthPercentage(100);

        PdfPCell headerCell = new PdfPCell();
        headerCell.setBackgroundColor(new BaseColor(26, 26, 46));
        headerCell.setPadding(20);
        headerCell.setBorder(Rectangle.NO_BORDER);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph brandName = new Paragraph("🎬 CineBook", whiteFont);
        brandName.setAlignment(Element.ALIGN_CENTER);
        headerCell.addElement(brandName);

        Paragraph tagline = new Paragraph("Online Movie Ticket Booking", whiteSm);
        tagline.setAlignment(Element.ALIGN_CENTER);
        headerCell.addElement(tagline);

        headerTable.addCell(headerCell);
        document.add(headerTable);

        document.add(Chunk.NEWLINE);

        // ===== CONFIRMED BADGE =====
        PdfPTable badgeTable = new PdfPTable(1);
        badgeTable.setWidthPercentage(50);
        badgeTable.setHorizontalAlignment(Element.ALIGN_CENTER);

        PdfPCell badgeCell = new PdfPCell(
            new Phrase("✅ BOOKING CONFIRMED",
                new Font(Font.FontFamily.HELVETICA, 11,
                         Font.BOLD, BaseColor.WHITE)));
        badgeCell.setBackgroundColor(new BaseColor(40, 167, 69));
        badgeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        badgeCell.setPadding(8);
        badgeCell.setBorder(Rectangle.NO_BORDER);
        badgeTable.addCell(badgeCell);
        document.add(badgeTable);

        document.add(Chunk.NEWLINE);

        // ===== MOVIE TITLE =====
        Paragraph movieTitle = new Paragraph(booking.getMovieTitle(), titleFont);
        movieTitle.setAlignment(Element.ALIGN_CENTER);
        document.add(movieTitle);

        document.add(Chunk.NEWLINE);

        // ===== DIVIDER =====
        LineSeparator line = new LineSeparator();
        line.setLineColor(new BaseColor(233, 69, 96));
        line.setLineWidth(1.5f);
        document.add(new Chunk(line));

        document.add(Chunk.NEWLINE);

        // ===== BOOKING DETAILS TABLE =====
        PdfPTable detailsTable = new PdfPTable(2);
        detailsTable.setWidthPercentage(100);
        detailsTable.setWidths(new float[]{1f, 1f});
        detailsTable.setSpacingBefore(10);

        addDetailRow(detailsTable, "Booking ID",
            "#" + booking.getBookingId(), labelFont, valueFont);
        addDetailRow(detailsTable, "Customer",
            customer.getFullName(), labelFont, valueFont);
        addDetailRow(detailsTable, "Show Date",
            String.valueOf(booking.getShowDate()), labelFont, valueFont);
        addDetailRow(detailsTable, "Show Time",
            String.valueOf(booking.getShowTime()), labelFont, valueFont);
        addDetailRow(detailsTable, "Hall",
            booking.getHall(), labelFont, valueFont);
        addDetailRow(detailsTable, "Seats",
            booking.getSeatNumbers(), labelFont, valueFont);

        document.add(detailsTable);

        document.add(Chunk.NEWLINE);

        // ===== DIVIDER =====
        LineSeparator line2 = new LineSeparator();
        line2.setLineColor(new BaseColor(220, 220, 220));
        line2.setLineWidth(1f);
        document.add(new Chunk(line2));

        document.add(Chunk.NEWLINE);

        // ===== PAYMENT DETAILS =====
        PdfPTable paymentTable = new PdfPTable(2);
        paymentTable.setWidthPercentage(100);
        paymentTable.setWidths(new float[]{1f, 1f});

        addDetailRow(paymentTable, "Payment Method",
            booking.getPaymentMethod() != null
                ? booking.getPaymentMethod().toUpperCase() : "N/A",
            labelFont, valueFont);
        addDetailRow(paymentTable, "Payment Status",
            booking.getPaymentStatus() != null
                ? booking.getPaymentStatus().toUpperCase() : "N/A",
            labelFont, valueFont);

        document.add(paymentTable);

        document.add(Chunk.NEWLINE);

        // ===== TOTAL AMOUNT =====
        PdfPTable totalTable = new PdfPTable(1);
        totalTable.setWidthPercentage(100);

        PdfPCell totalCell = new PdfPCell();
        totalCell.setBackgroundColor(new BaseColor(248, 249, 250));
        totalCell.setPadding(14);
        totalCell.setBorderColor(new BaseColor(233, 69, 96));
        totalCell.setBorderWidth(1.5f);

        Paragraph totalLabel = new Paragraph("Total Amount Paid",
            new Font(Font.FontFamily.HELVETICA, 10,
                     Font.NORMAL, new BaseColor(136, 136, 136)));
        totalLabel.setAlignment(Element.ALIGN_CENTER);
        totalCell.addElement(totalLabel);

        Paragraph totalAmount = new Paragraph(
            "Rs. " + booking.getTotalAmount(),
            new Font(Font.FontFamily.HELVETICA, 20,
                     Font.BOLD, new BaseColor(233, 69, 96)));
        totalAmount.setAlignment(Element.ALIGN_CENTER);
        totalCell.addElement(totalAmount);

        totalTable.addCell(totalCell);
        document.add(totalTable);

        document.add(Chunk.NEWLINE);

        // ===== BOOKING DATE =====
        Paragraph bookedAt = new Paragraph(
            "Booked on: " + booking.getBookedAt(), smallFont);
        bookedAt.setAlignment(Element.ALIGN_CENTER);
        document.add(bookedAt);

        document.add(Chunk.NEWLINE);

        // ===== FOOTER =====
        LineSeparator footerLine = new LineSeparator();
        footerLine.setLineColor(new BaseColor(220, 220, 220));
        document.add(new Chunk(footerLine));

        document.add(Chunk.NEWLINE);

        Paragraph footer = new Paragraph(
            "Thank you for booking with CineBook!\n" +
            "Please arrive 15 minutes before showtime.\n" +
            "This is your official ticket — keep it safe.",
            smallFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.add(Chunk.NEWLINE);

        Paragraph support = new Paragraph(
            "Support: support@cinebook.com | +977-9800000000",
            smallFont);
        support.setAlignment(Element.ALIGN_CENTER);
        document.add(support);

        document.close();
    }

    private void addDetailRow(PdfPTable table, String label,
                               String value, Font labelFont, Font valueFont) {
        // Label cell
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        labelCell.setBorder(Rectangle.BOTTOM);
        labelCell.setBorderColor(new BaseColor(240, 240, 240));
        labelCell.setPadding(10);
        labelCell.setPaddingLeft(4);
        table.addCell(labelCell);

        // Value cell
        PdfPCell valueCell = new PdfPCell(new Phrase(value != null ? value : "-",
                                                      valueFont));
        valueCell.setBorder(Rectangle.BOTTOM);
        valueCell.setBorderColor(new BaseColor(240, 240, 240));
        valueCell.setPadding(10);
        table.addCell(valueCell);
    }
}