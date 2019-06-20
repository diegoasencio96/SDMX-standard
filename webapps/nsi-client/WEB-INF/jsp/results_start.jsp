<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<div id="results-wait">
    <div class="help-message"><spring:message code="html.results.wait" htmlEscape="false"/></div>
    <img src="<c:url value="/image/wait_bar.gif"/>"/>
</div>

<div id="results-error" class="error-message" style="display:none">
    <spring:message code="error.results"/>
</div>

<div id="results-container"></div>
