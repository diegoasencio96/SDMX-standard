<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<c:set var="query" value="${sessionScope.sessionQuery}"/>

<%-- page links --%>
<div class="page-links">
    [ <a href="<c:url value="/download/query.htm"/>"><spring:message code="label.query.download"/></a> ]
    [ <a href="javascript:nsicOnCriteriaClear()"><spring:message code="label.query.clear"/></a> ]
</div>

<%-- help messages --%>
<div class="help-message"><spring:message code="html.criteria.help.1" htmlEscape="false"/></div>
<div class="help-message"><spring:message code="html.criteria.help.2" htmlEscape="false"/></div>

<%-- list of existing criteria --%>

<div id="max-observations-count">
    <c:choose>
        <c:when test="${query.maxVisibleDataflowObsCount >= 0}">
            <c:set var="obsCount" value="${query.maxVisibleDataflowObsCount}"/>
        </c:when>
        <c:otherwise>
            <c:set var="obsCount"><spring:message code="label.not.available"/></c:set>
        </c:otherwise>
    </c:choose>
    <spring:message code="label.max.obs" arguments="${obsCount}" htmlEscape="false"/>
</div>

<div id="criteria-component-tabs" style="display:none">
    <ul>
        <c:forEach items="${query.components}" var="qc">
            <c:url var="url" value="/ajax/criteria/component.htm">
                <c:param name="concept" value="${qc.key}"/>
            </c:url>
            <li><a href="${url}">${qc.key}</a></li>
        </c:forEach>
    </ul>
</div>
