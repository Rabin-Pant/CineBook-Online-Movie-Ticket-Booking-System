package com.cinebook.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ContactMessageStore {

    public static class Reply {
        private final String text;
        private final String sentAt;

        public Reply(String text) {
            this.text   = text;
            this.sentAt = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("MMM dd, yyyy  hh:mm a"));
        }

        public String getText()   { return text; }
        public String getSentAt() { return sentAt; }
    }

    public static class ContactMessage {
        private final String id;
        private final String name;
        private final String email;
        private final String phone; 
        private final String subject;
        private final String message;
        private final String receivedAt;
        private final int    customerId;
        private final List<Reply> replies = new ArrayList<>();

        public ContactMessage(String name, String email, String phone, String subject,
                              String message, int customerId) {
            this.id          = String.valueOf(System.currentTimeMillis());
            this.name        = name;
            this.email       = email;
            this.subject     = subject;
            this.message     = message;
            this.customerId  = customerId;
            this.phone       = phone;
            this.receivedAt  = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("MMM dd, yyyy  hh:mm a"));
        }

        public String      getId()         { return id; }
        public String      getName()       { return name; }
        public String      getEmail()      { return email; }
        public String getPhone()      { return phone; }
        public String      getSubject()    { return subject; }
        public String      getMessage()    { return message; }
        public String      getReceivedAt() { return receivedAt; }
        public int         getCustomerId() { return customerId; }
        public List<Reply> getReplies()    { return replies; }
        public boolean     hasReplies()    { return !replies.isEmpty(); }

        public void addReply(String text) {
            replies.add(new Reply(text));
        }
    }

    private static final List<ContactMessage> messages =
        Collections.synchronizedList(new ArrayList<>());

    public static void add(String name, String email, String phone,
            String subject, String message, int customerId) {
messages.add(0, new ContactMessage(name, email, phone, subject, message, customerId));
}

    public static List<ContactMessage> getAll() {
        return new ArrayList<>(messages);
    }

    public static List<ContactMessage> getByCustomerId(int customerId) {
        List<ContactMessage> result = new ArrayList<>();
        for (ContactMessage m : messages) {
            if (m.getCustomerId() == customerId) result.add(m);
        }
        return result;
    }

    public static ContactMessage getById(String id) {
        for (ContactMessage m : messages) {
            if (m.getId().equals(id)) return m;
        }
        return null;
    }

    public static void addReply(String messageId, String replyText) {
        ContactMessage m = getById(messageId);
        if (m != null) m.addReply(replyText);
    }

    public static void clear() {
        messages.clear();
    }
}