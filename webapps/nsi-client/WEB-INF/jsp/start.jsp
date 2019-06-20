<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page import="org.estat.nsi.client.web.SessionQueryMgr" %>
<%@ page import="org.estat.nsi.client.web.SessionQuery" %>

<c:set var="query" value="${sessionScope.sessionQuery}"/>

<%-- The element IDs must not be changed, as they are used by "nsi-client.js" file! --%>
<div id="pb-content">
    <div id="pb-dataflows">
        <jsp:include page="/ajax/dataflows.htm"/>
    </div>
    <div id="pb-workarea">
        <div id="pb-workarea-pages">
            <ul>
                <li><a href="<c:url value="/ajax/criteria.htm"/>"><spring:message code="label.criteria"/></a></li>
                <li<c:if test="${!query.dataflowSet}"> class="ui-state-disabled"</c:if>><a href="<c:url value="/ajax/results/start.htm"/>"><spring:message code="label.view_results"/></a></li>
            </ul>
        </div>
    </div>
    <div id="error-area">
	    <c:if test="${query.errorMessage != null}">
	    	<script type="text/javascript">
	    	$(document).ready(function(){
	    		alert("<spring:message code="${query.errorMessage}" htmlEscape="false"/>");
	    	});
			<% SessionQuery query = SessionQueryMgr.getSessionQuery(request); 
			query.setErrorMessage(null); %>
	    	</script>
	    </c:if>
    </div>
</div>
