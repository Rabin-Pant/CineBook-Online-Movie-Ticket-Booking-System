<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Redirecting to eSewa...</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e, #0f3460);
            color: #fff;
            text-align: center;
        }
        .redirect-card {
            background: rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 40px;
            max-width: 400px;
        }
        .esewa-logo { font-size: 3rem; margin-bottom: 16px; }
        h2 { margin-bottom: 8px; }
        p  { color: #bbb; margin-bottom: 24px; }
        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top-color: #60bb46;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
<div class="redirect-card">
    <div class="esewa-logo">💚</div>
    <h2>Redirecting to eSewa</h2>
    <p>Please wait while we redirect you to eSewa secure payment...</p>
    <div class="spinner"></div>

    <form id="esewaForm" action="${esewaUrl}" method="POST" style="display:none;">
        <input type="hidden" name="amount"                    value="${amount}"/>
        <input type="hidden" name="tax_amount"                value="0"/>
        <input type="hidden" name="total_amount"              value="${totalAmount}"/>
        <input type="hidden" name="transaction_uuid"          value="${transactionUUID}"/>
        <input type="hidden" name="product_code"              value="${merchantCode}"/>
        <input type="hidden" name="product_service_charge"    value="0"/>
        <input type="hidden" name="product_delivery_charge"   value="0"/>
        <input type="hidden" name="success_url"               value="${successUrl}"/>
        <input type="hidden" name="failure_url"               value="${failureUrl}"/>
        <input type="hidden" name="signed_field_names"        value="total_amount,transaction_uuid,product_code"/>
        <input type="hidden" name="signature"                 value="${signature}"/>
    </form>
</div>

<script>
    setTimeout(function() {
        document.getElementById('esewaForm').submit();
    }, 1500);
</script>
</body>
</html>