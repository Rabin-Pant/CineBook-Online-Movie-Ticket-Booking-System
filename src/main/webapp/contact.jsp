<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Contact Us" />
<c:set var="extraCSS" value="contact.css" />

<%@ include file="components/header.jsp" %>
<%@ include file="components/navbar.jsp" %>

<!-- ===== HERO BANNER ===== -->
<div class="contact-hero">
    <div class="contact-hero-inner">
        <div class="contact-hero-badge">
            <i class="fas fa-headset"></i>
            <span>We're Here to Help</span>
        </div>
        <h1>Get in <span>Touch</span> With Us</h1>
        <p>Have a question about your booking, a payment issue, or just want to say hello?
           We'd love to hear from you. Our team responds within 24 hours.</p>
    </div>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="contact-wrapper">

    <!-- LEFT: Info Panel -->
    <div class="contact-info-panel">

        <div>
            <h2 class="contact-info-title">Contact Information</h2>
            <p class="contact-info-subtitle">
                Reach out through any of the channels below,
                or fill in the form and we'll get back to you promptly.
            </p>
        </div>

        <div class="info-card">
            <div class="info-card-icon"><i class="fas fa-envelope"></i></div>
            <div class="info-card-body">
                <h4>Email Us</h4>
                <a href="mailto:support@cinebook.com">support@cinebook.com</a>
            </div>
        </div>

        <div class="info-card">
            <div class="info-card-icon"><i class="fas fa-phone"></i></div>
            <div class="info-card-body">
                <h4>Call Us</h4>
                <p>+977-9800000000</p>
            </div>
        </div>

        <div class="info-card">
            <div class="info-card-icon"><i class="fas fa-map-marker-alt"></i></div>
            <div class="info-card-body">
                <h4>Location</h4>
                <p>Kathmandu, Nepal</p>
            </div>
        </div>

        <div class="info-card">
            <div class="info-card-icon"><i class="fas fa-clock"></i></div>
            <div class="info-card-body">
                <h4>Support Hours</h4>
                <p>Sun – Fri &nbsp;|&nbsp; 9:00 AM – 6:00 PM</p>
            </div>
        </div>

        <div class="response-badge">
            <div class="response-dot"></div>
            Average response time: under 24 hours
        </div>

    </div>

    <!-- MIDDLE: Form Panel -->
    <div class="contact-form-panel">

       <div id="contactFormSection">
    <h2 class="form-title">Send Us a Message</h2>
    <p class="form-subtitle">Fill in the details below and we'll be in touch shortly.</p>

   <div class="form-row">
    <div class="form-group">
        <label>Full Name <span>*</span></label>
        <input type="text" id="contactName" placeholder="Your full name" maxlength="60"
               value="${not empty sessionScope.loggedInCustomer ? sessionScope.loggedInCustomer.fullName : ''}" />
    </div>
    <div class="form-group">
        <label>Email Address <span>*</span></label>
        <input type="email" id="contactEmail" placeholder="you@example.com"
               value="${not empty sessionScope.loggedInCustomer ? sessionScope.loggedInCustomer.email : ''}" />
    </div>
</div>

<div class="form-row">
    <div class="form-group">
        <label>Phone Number <span>*</span></label>
        <input type="tel" id="contactPhone" placeholder="+977-98XXXXXXXX" maxlength="20"
               value="${not empty sessionScope.loggedInCustomer ? sessionScope.loggedInCustomer.phone : ''}" />
    </div>
    <div class="form-group">
        <label>Subject <span>*</span></label>
        <select id="contactSubject">
            <option value="" disabled selected>Select a subject...</option>
            <option value="Booking Issue">🎟️ Booking Issue</option>
            <option value="Payment Problem">💳 Payment Problem</option>
            <option value="Refund / Cancellation">💰 Refund / Cancellation</option>
            <option value="Account Help">👤 Account Help</option>
            <option value="Technical Error">🔧 Technical Error</option>
            <option value="General Feedback">💬 General Feedback</option>
            <option value="Other">📌 Other</option>
        </select>
    </div>
</div>

    <div class="form-group full">
        <label>Message <span>*</span></label>
        <textarea id="contactMessage" placeholder="Describe your issue or question in detail..." maxlength="500"></textarea>
        <div class="char-counter" id="charCounter">0 / 500</div>
    </div>

    <button class="btn-submit" id="submitBtn" onclick="submitContactForm()">
        <i class="fas fa-paper-plane"></i>
        <span id="submitBtnText">Send Message</span>
    </button>
</div>

<!-- Success State -->
<div class="success-state" id="successState">
    <div class="success-icon"><i class="fas fa-check"></i></div>
    <h3>Message Sent!</h3>
    <p>Thank you for reaching out. We've received your message and
       will get back to you within 24 hours.</p>
    <button class="btn-back" onclick="resetForm()">
        <i class="fas fa-arrow-left"></i>
        Send Another Message
    </button>
</div>

    </div>

</div>

<!-- ===== FAQ STRIP ===== -->
<div class="faq-strip">
    <div class="faq-inner">
        <div class="faq-header">
            <h2>🎬 Frequently Asked Questions</h2>
            <p>Quick answers to the most common questions</p>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                My payment went through but I didn't get a booking confirmation. What should I do?
                <span class="faq-icon"><i class="fas fa-plus"></i></span>
            </button>
            <div class="faq-answer">
                Don't worry — this sometimes happens due to a brief delay between payment and booking
                confirmation. Check your Booking History page first. If your booking isn't there within
                10 minutes, contact us with your transaction ID and we'll sort it out immediately.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How long does a refund take after I cancel a booking?
                <span class="faq-icon"><i class="fas fa-plus"></i></span>
            </button>
            <div class="faq-answer">
                Refunds are processed within 24 hours of cancellation and credited back to your original
                payment method (eSewa or Khalti wallet). Please note that an 8% cancellation fee is
                deducted from the refund amount as per our cancellation policy.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Can I change my selected seats after booking?
                <span class="faq-icon"><i class="fas fa-plus"></i></span>
            </button>
            <div class="faq-answer">
                Seat changes are not currently supported after a booking is confirmed. You would need to
                cancel the existing booking (subject to the 8% cancellation fee) and make a new one
                with your preferred seats.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Which payment methods are accepted?
                <span class="faq-icon"><i class="fas fa-plus"></i></span>
            </button>
            <div class="faq-answer">
                CineBook currently accepts payments via Khalti and eSewa digital wallets. If one gateway
                is temporarily unavailable, you can use the other.
            </div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do I download my ticket as a PDF?
                <span class="faq-icon"><i class="fas fa-plus"></i></span>
            </button>
            <div class="faq-answer">
                After your booking is confirmed, go to Booking History in your dashboard. Find your
                booking and click the Print Ticket button. Your ticket will be generated as a PDF
                that you can save or print.
            </div>
        </div>

    </div>
</div>

<!-- ===== MY MESSAGES - FLOATING BUTTON & PANEL ===== -->
<c:if test="${not empty sessionScope.loggedInCustomer}">
    
    <!-- Floating Toggle Button -->
    <button class="msg-toggle-btn" id="msgToggleBtn" onclick="toggleMsgPanel()" title="My Messages">
        <i class="fas fa-comments"></i>
        <c:if test="${not empty myMessages}">
            <span class="msg-badge">${myMessages.size()}</span>
        </c:if>
    </button>
    
    <!-- Sliding Panel -->
    <div id="msgPanel" class="msg-sliding-panel">
        <div class="msg-panel-content">
            
            <!-- Panel Header -->
            <div class="msg-panel-header">
                <div>
                    <h4>📨 My Messages</h4>
                    <p>Your support conversations</p>
                </div>
                <button class="close-panel-btn" onclick="toggleMsgPanel()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <!-- Messages Scroll Area -->
            <div class="msg-scroll-area">
                
                <c:choose>
                    <c:when test="${empty myMessages}">
                        <div class="empty-messages">
                            <div class="empty-icon">📭</div>
                            <p class="empty-text">No messages yet.<br>Send us a message!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="msg" items="${myMessages}">
                            <div class="msg-card">
                                
                                <div class="msg-card-header">
                                    <div class="msg-subject">${msg.subject}</div>
                                    <c:choose>
                                        <c:when test="${msg.hasReplies()}">
                                            <span class="status-badge status-replied">✅ Replied</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">⏳ Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="msg-card-body">
                                    
                                    <!-- Message preview -->
                                    <div class="msg-preview">${msg.message}</div>
                                    
                                    <!-- Admin replies -->
                                    <c:if test="${msg.hasReplies()}">
                                        <c:forEach var="reply" items="${msg.replies}">
                                            <div class="admin-reply">
                                                <div class="reply-header">
                                                    <i class="fas fa-headset"></i> CineBook Support
                                                </div>
                                                <div class="reply-text">${reply.text}</div>
                                                <div class="reply-time">
                                                    <i class="fas fa-clock"></i> ${reply.repliedAt}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                    
                                    <c:if test="${not msg.hasReplies()}">
                                        <div class="pending-notice">
                                            ⏳ Awaiting reply within 24 hours
                                        </div>
                                    </c:if>
                                    
                                    <div class="msg-time">
                                       <i class="fas fa-clock"></i> ${msg.createdAt}
                                    </div>
                                    
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </div>
    </div>
    
</c:if>

<script>
const msgArea   = document.getElementById('contactMessage');
const charCount = document.getElementById('charCounter');

if (msgArea) {
    msgArea.addEventListener('input', function() {
        const len = this.value.length;
        charCount.textContent = len + ' / 500';
        charCount.classList.toggle('warn', len > 420);
    });
}

function submitContactForm() {
    const name    = document.getElementById('contactName').value.trim();
    const email   = document.getElementById('contactEmail').value.trim();
    const subject = document.getElementById('contactSubject').value;
    const message = document.getElementById('contactMessage').value.trim();
    const phone   = document.getElementById('contactPhone').value.trim();

    if (!name)                         { shake('contactName');    return; }
    if (!email || !email.includes('@')) { shake('contactEmail');   return; }
    if (!phone)                        { shake('contactPhone');   return; }
    if (!subject)                      { shake('contactSubject'); return; }
    if (message.length < 10)           { shake('contactMessage'); return; }

    const btn     = document.getElementById('submitBtn');
    const btnText = document.getElementById('submitBtnText');
    btn.classList.add('loading');
    btnText.textContent = 'Sending...';
    btn.querySelector('i').className = 'fas fa-spinner fa-spin';

    const params = new URLSearchParams();
    params.append('name',    name);
    params.append('email',   email);
    params.append('phone',   phone);
    params.append('subject', subject);
    params.append('message', message);

    fetch('${pageContext.request.contextPath}/contact', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    })
    .then(res => {
        if (res.ok) {
            document.getElementById('contactFormSection').style.display = 'none';
            document.getElementById('successState').classList.add('show');
        } else {
            btnText.textContent = 'Try Again';
            btn.querySelector('i').className = 'fas fa-paper-plane';
            btn.classList.remove('loading');
        }
    })
    .catch(() => {
        btnText.textContent = 'Try Again';
        btn.querySelector('i').className = 'fas fa-paper-plane';
        btn.classList.remove('loading');
    });
}

function shake(fieldId) {
    const el = document.getElementById(fieldId);
    if (!el) return;
    el.style.borderColor = '#e94560';
    el.style.animation   = 'shake 0.4s ease';
    el.focus();
    setTimeout(() => { el.style.animation = ''; }, 400);
}

function resetForm() {
    if (document.getElementById('contactSubject'))
        document.getElementById('contactSubject').value = '';
    if (document.getElementById('contactMessage'))
        document.getElementById('contactMessage').value = '';
    if (charCount) {
        charCount.textContent = '0 / 500';
        charCount.classList.remove('warn');
    }
    const btn     = document.getElementById('submitBtn');
    const btnText = document.getElementById('submitBtnText');
    btn.classList.remove('loading');
    btnText.textContent = 'Send Message';
    btn.querySelector('i').className = 'fas fa-paper-plane';
    document.getElementById('successState').classList.remove('show');
    document.getElementById('contactFormSection').style.display = 'block';
}

function toggleFaq(btn) {
    const item   = btn.closest('.faq-item');
    const isOpen = item.classList.contains('open');
    document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
    if (!isOpen) item.classList.add('open');
}

// ===== MY MESSAGES SLIDE PANEL =====
let msgPanelOpen = false;

function toggleMsgPanel() {
    const panel = document.getElementById('msgPanel');
    const btn = document.getElementById('msgToggleBtn');
    if (!panel || !btn) return;

    msgPanelOpen = !msgPanelOpen;

    if (msgPanelOpen) {
        panel.classList.add('open');
        btn.style.background = 'linear-gradient(135deg, #c73e56, #a0293f)';
        btn.querySelector('i').className = 'fas fa-times';
    } else {
        panel.classList.remove('open');
        btn.style.background = 'linear-gradient(135deg, #e94560, #c73e56)';
        btn.querySelector('i').className = 'fas fa-comments';
    }
}

// Close panel when clicking outside (optional)
document.addEventListener('click', function(event) {
    const panel = document.getElementById('msgPanel');
    const btn = document.getElementById('msgToggleBtn');
    
    if (msgPanelOpen && panel && btn) {
        const isClickInside = panel.contains(event.target) || btn.contains(event.target);
        if (!isClickInside) {
            toggleMsgPanel();
        }
    }
});

const style = document.createElement('style');
style.textContent = '@keyframes shake { 0%,100%{transform:translateX(0)} 20%,60%{transform:translateX(-6px)} 40%,80%{transform:translateX(6px)} }';
document.head.appendChild(style);
</script>

<%@ include file="components/footer.jsp" %>