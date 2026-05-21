<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Select Seats" />
<c:set var="extraCSS" value="seats.css" />

<%@ include file="/components/header.jsp" %>
<%@ include file="/components/navbar.jsp" %>

<div class="container">

    <a href="${pageContext.request.contextPath}/customer/showtimes?movieId=${showtime.movieId}"
       class="back-link">← Back to Showtimes</a>

    <h1 class="page-title">Select Your Seats</h1>

    <!-- Showtime Info Bar -->
    <div class="showtime-info-bar">
        <span>📅 ${showtime.showDate}</span>
        <span>🕐 ${showtime.showTime}</span>
        <span>🎭 ${showtime.hall}</span>
        <span>💰 Rs. ${showtime.price} per seat</span>
    </div>

    <c:if test="${not empty param.error}">
        <div class="alert alert-error">${param.error}</div>
    </c:if>

    <!-- Screen -->
    <div class="screen-wrapper">
        <div class="screen">SCREEN</div>
    </div>

    <!-- Seat Legend -->
    <div class="seat-legend">
        <div class="legend-item">
            <div class="seat-demo available"></div><span>Available</span>
        </div>
        <div class="legend-item">
            <div class="seat-demo selected"></div><span>Selected</span>
        </div>
        <div class="legend-item">
            <div class="seat-demo booked"></div><span>Booked</span>
        </div>
    </div>

    <!-- Seat Map Form — action set dynamically by submitBooking() -->
    <form id="bookingForm" action="" method="post">

        <input type="hidden" name="showtimeId" value="${showtime.showtimeId}" />
        <input type="hidden" name="totalAmount" id="totalAmountField" value="0" />

        <div class="seat-map">
            <c:forEach var="seat" items="${seats}">
                <c:choose>
                    <c:when test="${seat.booked}">
                        <div class="seat booked"
                             title="Seat ${seat.seatNumber} - Booked">
                            ${seat.seatNumber}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="seat available"
                             id="seat-${seat.seatId}"
                             title="Seat ${seat.seatNumber} - Available"
                             onclick="toggleSeat(${seat.seatId}, '${seat.seatNumber}')">
                            ${seat.seatNumber}
                            <input type="checkbox"
                                   name="seats"
                                   id="check-${seat.seatId}"
                                   value="${seat.seatId}"
                                   style="display:none;" />
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <!-- Booking Summary -->
        <div class="booking-summary">
            <div class="summary-info">
                <span>Selected: <strong id="selectedCount">0</strong> seat(s)</span>
                <span>Price per seat: <strong>Rs. ${showtime.price}</strong></span>
                <span>Total: <strong id="totalPrice">Rs. 0</strong></span>
            </div>

            <!-- Payment method buttons — shown only when at least 1 seat is selected -->
            <div id="paymentButtons" style="display:none; flex-direction:column; align-items:center; gap:10px; margin-top:12px;">
                <div style="display:flex; gap:12px; flex-wrap:wrap; justify-content:center;">
                    <button type="button" class="btn btn-primary"
                            id="khaltiBtn" disabled
                            onclick="submitBooking('khalti')"
                            style="background:#5C2D91; border-color:#5C2D91;">
                        💜 Pay with Khalti
                    </button>
                    <button type="button" class="btn btn-primary"
                            id="esewaBtn" disabled
                            onclick="submitBooking('esewa')"
                            style="background:#60bb46; border-color:#60bb46;">
                        💚 Pay with eSewa
                    </button>
                </div>
                <p style="font-size:0.82rem; color:#888; margin:0; text-align:center;">
                    ⚠️ If one payment method is unavailable, please try the other.
                </p>
            </div>

        </div>

    </form>

</div>

<script>
    const pricePerSeat = parseFloat('${showtime.price}');
    const contextPath  = '${pageContext.request.contextPath}';
    let selectedSeats  = [];

    function toggleSeat(seatId, seatNumber) {
        const seatDiv  = document.getElementById('seat-' + seatId);
        const checkbox = document.getElementById('check-' + seatId);
        const index    = selectedSeats.indexOf(seatId);

        if (index === -1) {
            selectedSeats.push(seatId);
            seatDiv.classList.remove('available');
            seatDiv.classList.add('selected');
            checkbox.checked = true;
        } else {
            selectedSeats.splice(index, 1);
            seatDiv.classList.remove('selected');
            seatDiv.classList.add('available');
            checkbox.checked = false;
        }

        updateSummary();
    }

    function updateSummary() {
        const count = selectedSeats.length;
        const total = count * pricePerSeat;

        document.getElementById('selectedCount').textContent = count;
        document.getElementById('totalPrice').textContent    = 'Rs. ' + total.toFixed(2);
        document.getElementById('totalAmountField').value    = total.toFixed(2);

        const hasSeats = count > 0;
        document.getElementById('paymentButtons').style.display = hasSeats ? 'flex' : 'none';
        document.getElementById('esewaBtn').disabled  = !hasSeats;
        document.getElementById('khaltiBtn').disabled = !hasSeats;
    }

    function submitBooking(gateway) {
        if (selectedSeats.length === 0) {
            alert('Please select at least one seat!');
            return;
        }

        const total = selectedSeats.length * pricePerSeat;
        document.getElementById('totalAmountField').value = total.toFixed(2);

        // Point the form to the chosen payment gateway
        const form = document.getElementById('bookingForm');
        if (gateway === 'khalti') {
            form.action = contextPath + '/customer/khalti-payment';
        } else {
            form.action = contextPath + '/customer/esewa-payment';
        }

        form.submit();
    }
</script>

<%@ include file="/components/footer.jsp" %>
