<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<div class="help-message">
    <c:url value="/" var="homeURL"/>
    <spring:message code="error.invalid.session" arguments="${homeURL}" htmlEscape="false"/>
</div>

<%-- This is required when the page is loaded into an IFRAME --%>
<script type="text/javascript">
    if (window != window.top) {
        window.top.location = "<c:url value="invalid-session.htm"/>";
    }
</script>
