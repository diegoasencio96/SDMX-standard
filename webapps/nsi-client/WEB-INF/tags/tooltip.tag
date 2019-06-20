<%@ tag body-content="empty" %>

<%@ attribute name="code" type="java.lang.String" required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<img id="tt-${code}" class="tooltip" title="<spring:message code="tooltip.${code}" htmlEscape="true" javaScriptEscape="true"/>"
     alt="tooltip" style="vertical-align:middle;" src="<c:url value="/image/help.gif"/>"/>
