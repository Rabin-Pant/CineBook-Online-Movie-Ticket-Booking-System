package com.cinebook.dao;

import com.cinebook.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDAO {

    // ===== Inner classes =====

    public static class Reply {
        private final int    replyId;
        private final String text;
        private final String repliedAt;

        public Reply(int replyId, String text, String repliedAt) {
            this.replyId   = replyId;
            this.text      = text;
            this.repliedAt = repliedAt;
        }

        public int    getReplyId()   { return replyId; }
        public String getText()      { return text; }
        public String getRepliedAt() { return repliedAt; }
    }

    public static class ContactMessage {
        private final int          messageId;
        private final int          customerId;
        private final String       name;
        private final String       email;
        private final String       phone;
        private final String       subject;
        private final String       message;
        private final boolean      read;
        private final String       createdAt;
        private final List<Reply>  replies;
        

        public ContactMessage(int messageId, int customerId, String name, String email,
                              String phone, String subject, String message,
                              boolean read, String createdAt) {
            this.messageId  = messageId;
            this.customerId = customerId;
            this.name       = name;
            this.email      = email;
            this.phone      = phone;
            this.subject    = subject;
            this.message    = message;
            this.read       = read;
            this.createdAt  = createdAt;
            this.replies    = new ArrayList<>();
        }

        public int         getMessageId()  { return messageId; }
        public int         getCustomerId() { return customerId; }
        public String      getName()       { return name; }
        public String      getEmail()      { return email; }
        public String      getPhone()      { return phone; }
        public String      getSubject()    { return subject; }
        public String      getMessage()    { return message; }
        public boolean     isRead()        { return read; }
        public String      getCreatedAt()  { return createdAt; }
        public List<Reply> getReplies()    { return replies; }
        public boolean     hasReplies()    { return !replies.isEmpty(); }
        public String      getId()         { return String.valueOf(messageId); }

        // Alias for JSP compatibility
        public String getReceivedAt()      { return createdAt; }
    }

    // ===== Save new message =====
    public int saveMessage(String name, String email, String phone,
                           String subject, String message, int customerId) {
        String sql = "INSERT INTO contact_messages (customer_id, name, email, phone, subject, message) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerId);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, subject);
            ps.setString(6, message);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===== Get all messages with replies =====
    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ContactMessage msg = new ContactMessage(
                    rs.getInt("message_id"),
                    rs.getInt("customer_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getBoolean("is_read"),
                    rs.getString("created_at")
                );
                msg.getReplies().addAll(getRepliesForMessage(conn, msg.getMessageId()));
                list.add(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== Get messages by customer ID =====
    public List<ContactMessage> getMessagesByCustomerId(int customerId) {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages WHERE customer_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ContactMessage msg = new ContactMessage(
                    rs.getInt("message_id"),
                    rs.getInt("customer_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getBoolean("is_read"),
                    rs.getString("created_at")
                );
                msg.getReplies().addAll(getRepliesForMessage(conn, msg.getMessageId()));
                list.add(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===== Add reply =====
    public boolean addReply(int messageId, String replyText) {
        String sql = "INSERT INTO contact_replies (message_id, reply_text) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            ps.setString(2, replyText);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== Mark single message as read =====
    public boolean markAsRead(int messageId) {
        String sql = "UPDATE contact_messages SET is_read = TRUE WHERE message_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== Clear all messages =====
    public boolean clearAll() {
        String sql = "DELETE FROM contact_messages";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

 // ===== Count unread messages =====
    public int getUnreadCount() {
        // Updated query: Counts messages that are unread AND have no admin replies yet
        String sql = "SELECT COUNT(*) FROM contact_messages " +
                     "WHERE is_read = FALSE " +
                     "AND message_id NOT IN (SELECT DISTINCT message_id FROM contact_replies)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===== Private: get replies for a message =====
    private List<Reply> getRepliesForMessage(Connection conn, int messageId) throws Exception {
        List<Reply> replies = new ArrayList<>();
        String sql = "SELECT * FROM contact_replies WHERE message_id = ? ORDER BY replied_at ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                replies.add(new Reply(
                    rs.getInt("reply_id"),
                    rs.getString("reply_text"),
                    rs.getString("replied_at")
                ));
            }
        }
        return replies;
    }
}