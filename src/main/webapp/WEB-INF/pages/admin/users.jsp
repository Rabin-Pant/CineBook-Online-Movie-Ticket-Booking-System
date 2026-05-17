<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Manage Customers" />
<c:set var="extraCSS" value="admin.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/admin-navbar.jsp" %>

<div class="admin-wrapper">

    <%@ include file="/components/admin-sidebar.jsp" %>

    <main class="admin-main">

        <div class="admin-topbar">
            <h2>Manage Customers</h2>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">${param.success}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">${param.error}</div>
        </c:if>

        <div class="admin-card">
            <div class="admin-card-header">
                <h3>All Customers
                    (${not empty customers ? customers.size() : 0})
                </h3>
            </div>

            <c:choose>
                <c:when test="${not empty customers}">
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Joined</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="customer" items="${customers}">
                                    <tr>
                                        <td>${customer.customerId}</td>
                                        <td><strong>${customer.fullName}</strong></td>
                                        <td>${customer.email}</td>
                                        <td>${customer.phone}</td>
                                        <td>${customer.createdAt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${customer.active}">
                                                    <span class="badge badge-success">
                                                        Active
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">
                                                        Blocked
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <%-- Only Block/Unblock — no delete --%>
                                            <c:choose>
                                                <c:when test="${customer.active}">
                                                    <a href="${pageContext.request.contextPath}/admin/block-customer?customerId=${customer.customerId}&action=block"
                                                       class="btn-action btn-delete"
                                                       onclick="return confirm('Block ${customer.fullName}? They will not be able to login.')">
                                                        🔒 Block
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/block-customer?customerId=${customer.customerId}&action=unblock"
                                                       class="btn-action btn-edit"
                                                       onclick="return confirm('Unblock ${customer.fullName}?')">
                                                        🔓 Unblock
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No customers registered yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<%@ include file="/components/footer.jsp" %>