<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Contact Messages" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:28px; flex-wrap:wrap; gap:14px;">
            <h1 style="font-size:1.5rem; font-weight:800; color:#1a1a2e;">
                📬 Contact Messages
                <c:if test="${not empty messages}">
                    <span style="font-size:0.8rem; background:#e94560; color:#fff; padding:3px 10px; border-radius:20px; font-weight:600; margin-left:8px; vertical-align:middle;">
                        ${messages.size()}
                    </span>
                </c:if>
            </h1>
            <c:if test="${not empty messages}">
                <form method="post" action="${pageContext.request.contextPath}/admin/contact-messages"
                      onsubmit="return confirm('Clear all messages? This cannot be undone.')">
                    <input type="hidden" name="action" value="clear" />
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> Clear All
                    </button>
                </form>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty messages}">
                <div style="text-align:center; padding:80px 20px; background:#fff; border-radius:20px; box-shadow:0 4px 20px rgba(0,0,0,0.05);">
                    <p style="font-size:3rem; margin-bottom:16px;">📭</p>
                    <h3 style="font-size:1.1rem; font-weight:700; color:#1a1a2e; margin-bottom:8px;">No messages yet</h3>
                    <p style="font-size:0.88rem; color:#888;">When customers submit the contact form, their messages will appear here.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display:flex; flex-direction:column; gap:20px;">
                    <c:forEach var="msg" items="${messages}">
                        <div style="background:#fff; border-radius:16px; padding:22px 24px; border:1px solid #eee; box-shadow:0 4px 15px rgba(0,0,0,0.05); border-left:4px solid #e94560;">

                            <!-- Header -->
                            <div style="display:flex; align-items:flex-start; justify-content:space-between; gap:16px; margin-bottom:14px; flex-wrap:wrap;">
                                <div style="display:flex; align-items:center; gap:14px;">
                                    <div style="width:42px; height:42px; background:linear-gradient(135deg,#e94560,#c73e56); border-radius:50%; display:flex; align-items:center; justify-content:center; color:#fff; font-size:1rem; font-weight:700; flex-shrink:0;">
                                        ${msg.name.substring(0,1).toUpperCase()}
                                    </div>
                                    <div>
                                        <div style="font-size:0.92rem; font-weight:700; color:#1a1a2e; margin-bottom:3px;">${msg.name}</div>
                                        <div style="font-size:0.78rem; color:#666; margin-bottom:2px;">
                                            <i class="fas fa-envelope" style="color:#e94560; margin-right:5px;"></i>
                                            <a href="mailto:${msg.email}" style="color:#e94560; text-decoration:none; font-weight:500;">${msg.email}</a>
                                        </div>
                                        <c:if test="${not empty msg.phone}">
                                            <div style="font-size:0.78rem; color:#666; margin-bottom:2px;">
                                                <i class="fas fa-phone" style="color:#e94560; margin-right:5px;"></i>
                                                ${msg.phone}
                                            </div>
                                        </c:if>
                                        <c:if test="${msg.customerId != -1}">
                                            <div style="font-size:0.72rem; color:#bbb; margin-top:2px;">
                                                Customer ID: ${msg.customerId}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <div style="display:flex; flex-direction:column; align-items:flex-end; gap:5px;">
                                    <span style="background:rgba(233,69,96,0.1); border:1px solid rgba(233,69,96,0.2); color:#e94560; padding:3px 12px; border-radius:20px; font-size:0.73rem; font-weight:600;">
                                        ${msg.subject}
                                    </span>
                                    <span style="font-size:0.73rem; color:#aaa;">
                                        <i class="fas fa-clock"></i> ${msg.receivedAt}
                                    </span>
                                    <c:if test="${msg.hasReplies()}">
                                        <span style="font-size:0.72rem; background:#d4edda; color:#155724; padding:2px 10px; border-radius:20px; font-weight:600;">
                                            ✅ Replied
                                        </span>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Customer Message -->
                            <div style="background:#f8f9fa; border-radius:10px; padding:14px 16px; font-size:0.87rem; color:#444; line-height:1.7; border:1px solid #eee; white-space:pre-wrap; word-break:break-word; margin-bottom:16px;">
                                ${msg.message}
                            </div>

                            <!-- Existing Replies -->
                            <c:if test="${msg.hasReplies()}">
                                <div style="margin-bottom:16px;">
                                    <div style="font-size:0.78rem; font-weight:700; color:#888; text-transform:uppercase; letter-spacing:1px; margin-bottom:10px;">
                                        <i class="fas fa-reply"></i> Your Replies
                                    </div>
                                    <c:forEach var="reply" items="${msg.replies}">
                                        <div style="background:linear-gradient(135deg,#1a1a2e,#16213e); border-radius:10px; padding:12px 16px; margin-bottom:8px;">
                                            <div style="font-size:0.86rem; color:rgba(255,255,255,0.9); line-height:1.7; white-space:pre-wrap; word-break:break-word;">
                                                ${reply.text}
                                            </div>
                                            <div style="font-size:0.72rem; color:rgba(255,255,255,0.4); margin-top:6px;">
                                                <i class="fas fa-clock"></i> ${reply.sentAt}
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Reply Form -->
                            <form method="post" action="${pageContext.request.contextPath}/admin/contact-messages">
                                <input type="hidden" name="action"    value="reply" />
                                <input type="hidden" name="messageId" value="${msg.id}" />
                                <div style="margin-bottom:10px;">
                                    <textarea name="replyText"
                                              placeholder="Type your reply to ${msg.name}..."
                                              required
                                              style="width:100%; padding:12px 14px; border:1.5px solid #e8e8e8; border-radius:10px; font-size:0.87rem; font-family:'Poppins',sans-serif; color:#1a1a2e; background:#fafafa; resize:vertical; min-height:90px; outline:none; transition:border-color 0.3s; box-sizing:border-box;"
                                              onfocus="this.style.borderColor='#e94560'"
                                              onblur="this.style.borderColor='#e8e8e8'"></textarea>
                                </div>
                                <button type="submit"
                                        style="display:inline-flex; align-items:center; gap:7px; padding:9px 22px; background:linear-gradient(135deg,#e94560,#c73e56); color:#fff; border:none; border-radius:20px; font-size:0.82rem; font-weight:600; cursor:pointer; font-family:'Poppins',sans-serif; box-shadow:0 3px 12px rgba(233,69,96,0.3); transition:all 0.3s;"
                                        onmouseover="this.style.transform='translateY(-2px)'"
                                        onmouseout="this.style.transform='translateY(0)'">
                                    <i class="fas fa-paper-plane"></i> Send Reply
                                </button>
                            </form>

                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>