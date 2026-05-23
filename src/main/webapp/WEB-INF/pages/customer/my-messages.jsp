<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Messages" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container" style="max-width:850px; margin:0 auto; padding:40px 20px 60px;">

    <div style="margin-bottom:30px;">
        <h1 style="font-size:1.6rem; font-weight:800; color:#1a1a2e; margin-bottom:6px;">
            📬 My Messages
        </h1>
        <p style="font-size:0.88rem; color:#888;">
            Your support conversations with CineBook team.
        </p>
    </div>

    <c:choose>
        <c:when test="${empty myMessages}">
            <div style="text-align:center; padding:70px 20px; background:#fff; border-radius:20px; box-shadow:0 4px 20px rgba(0,0,0,0.05); border:1px solid #eee;">
                <p style="font-size:3rem; margin-bottom:14px;">📭</p>
                <h3 style="font-size:1.1rem; font-weight:700; color:#1a1a2e; margin-bottom:8px;">No messages yet</h3>
                <p style="font-size:0.88rem; color:#888; margin-bottom:24px;">
                    You haven't sent any support messages yet.
                </p>
                <a href="${pageContext.request.contextPath}/contact"
                   style="display:inline-block; padding:11px 28px; background:linear-gradient(135deg,#e94560,#c73e56); color:#fff; border-radius:50px; text-decoration:none; font-weight:600; font-size:0.88rem; box-shadow:0 4px 15px rgba(233,69,96,0.3);">
                    Contact Support
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display:flex; flex-direction:column; gap:20px;">
                <c:forEach var="msg" items="${myMessages}">
                    <div style="background:#fff; border-radius:16px; border:1px solid #eee; box-shadow:0 4px 15px rgba(0,0,0,0.05); overflow:hidden;">

                        <!-- Message Header -->
                        <div style="background:linear-gradient(135deg,#1a1a2e,#16213e); padding:16px 22px; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:10px;">
                            <div>
                                <div style="font-size:0.92rem; font-weight:700; color:#fff; margin-bottom:3px;">
                                    ${msg.subject}
                                </div>
                                <div style="font-size:0.75rem; color:rgba(255,255,255,0.45);">
                                    <i class="fas fa-clock"></i> Sent: ${msg.receivedAt}
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${msg.hasReplies()}">
                                    <span style="background:#d4edda; color:#155724; padding:4px 12px; border-radius:20px; font-size:0.73rem; font-weight:700;">
                                        ✅ Reply Received
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background:rgba(255,179,71,0.15); color:#ffb347; border:1px solid rgba(255,179,71,0.3); padding:4px 12px; border-radius:20px; font-size:0.73rem; font-weight:700;">
                                        ⏳ Awaiting Reply
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div style="padding:18px 22px;">

                            <!-- Your Message -->
                            <div style="margin-bottom:16px;">
                                <div style="font-size:0.75rem; font-weight:700; color:#aaa; text-transform:uppercase; letter-spacing:1px; margin-bottom:8px;">
                                    Your Message
                                </div>
                                <div style="background:#f8f9fa; border-radius:10px; padding:13px 16px; font-size:0.87rem; color:#444; line-height:1.7; border:1px solid #eee; white-space:pre-wrap; word-break:break-word;">
                                    ${msg.message}
                                </div>
                            </div>

                            <!-- Replies from Admin -->
                            <c:if test="${msg.hasReplies()}">
                                <div>
                                    <div style="font-size:0.75rem; font-weight:700; color:#aaa; text-transform:uppercase; letter-spacing:1px; margin-bottom:8px;">
                                        <i class="fas fa-headset"></i> CineBook Support
                                    </div>
                                    <c:forEach var="reply" items="${msg.replies}">
                                        <div style="background:linear-gradient(135deg,rgba(233,69,96,0.06),rgba(233,69,96,0.02)); border:1px solid rgba(233,69,96,0.15); border-left:3px solid #e94560; border-radius:10px; padding:13px 16px; margin-bottom:8px;">
                                            <div style="font-size:0.87rem; color:#1a1a2e; line-height:1.7; white-space:pre-wrap; word-break:break-word;">
                                                ${reply.text}
                                            </div>
                                            <div style="font-size:0.72rem; color:#aaa; margin-top:6px;">
                                                <i class="fas fa-clock"></i> ${reply.sentAt}
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <c:if test="${not msg.hasReplies()}">
                                <div style="text-align:center; padding:16px; background:#fffbf0; border-radius:10px; border:1px dashed #ffd700;">
                                    <p style="font-size:0.83rem; color:#888; margin:0;">
                                        ⏳ Our support team will reply within 24 hours.
                                    </p>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/components/footer.jsp" %>
