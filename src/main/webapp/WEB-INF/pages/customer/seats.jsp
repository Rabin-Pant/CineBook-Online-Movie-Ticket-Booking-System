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

    <!-- Seat Map Form -->
    <form id="bookingForm"
          action="${pageContext.request.contextPath}/customer/esewa-payment"
          method="post">

        <input type="hidden" name="showtimeId" value="${showtime.showtimeId}" />
        <input type="hidden" name="totalAmount" id="totalAmountField" value="0" />

        <div class="seat-map">
            <c:forEach var="seat" items="${seats}">
                <c:choose>
                    <c:when test="${seat.booked}">
                        <%-- Booked seat - not clickable --%>
                        <div class="seat booked"
                             title="Seat ${seat.seatNumber} - Booked">
                            ${seat.seatNumber}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Available seat - clickable --%>
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
            <button type="button" class="btn btn-primary"
                    id="bookBtn" disabled
                    onclick="submitBooking()">
                Proceed to Payment
            </button>
        </div>

    </form>

</div>

<script>
    const pricePerSeat = parseFloat('${showtime.price}');
    let selectedSeats = [];

    function toggleSeat(seatId, seatNumber) {
        const seatDiv   = document.getElementById('seat-' + seatId);
        const checkbox  = document.getElementById('check-' + seatId);
        const index     = selectedSeats.indexOf(seatId);

        if (index === -1) {
            // Select seat
            selectedSeats.push(seatId);
            seatDiv.classList.remove('available');
            seatDiv.classList.add('selected');
            checkbox.checked = true;
        } else {
            // Deselect seat
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
        document.getElementById('bookBtn').disabled          = count === 0;
    }

    function submitBooking() {
        if (selectedSeats.length === 0) {
            alert('Please select at least one seat!');
            return;
        }

        const total = selectedSeats.length * pricePerSeat;
        document.getElementById('totalAmountField').value = total.toFixed(2);
        document.getElementById('bookingForm').submit();
    }
</script>

<%@ include file="/components/footer.jsp" %>