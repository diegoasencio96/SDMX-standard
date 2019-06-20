<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<c:set var="codesTree" value="${queryComponent.availableCodesTree}"/>
<c:set var="codes" value="${queryComponent.availableCodes}"/>

<%-- this are used for passing data to "nsi-client.js" functions --%>
<div style="display:none">
    <div id="criteria-edit-form-type">codes</div>
    <div id="criteria-edit-concept"><c:out value="${queryComponent.concept}"/></div>
    <div id="criteria-update-warning"><c:out value="${warnOnUpdate}"/></div>
</div>

<%-- The name of component's concept --%>
<div class="main-label">
    <tags:concept id="${queryComponent.concept}" var="concept"/>
    <tags:nameable-artefact-text artefact="${concept}"/>
</div>

<%-- the help message --%>
<div class="help-message">
    <c:choose>
        <c:when test="${fn:length(codes.items) == 1}">
            <spring:message code="html.criteria.help.single.code" htmlEscape="false"/>
        </c:when>
        <c:otherwise>
            <spring:message code="html.criteria.help.codes" htmlEscape="false"/>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${fn:length(codes.items) > 1}">
    <div class="op-links">
        <a href="javascript:nsicCriteriaUpdateAllCodes(NSIC_OP_SELECT_ALL)"><spring:message code="label.select_all"/></a> -
        <a href="javascript:nsicCriteriaUpdateAllCodes(NSIC_OP_DESELECT_ALL)"><spring:message code="label.deselect_all"/></a> -
        <a href="javascript:nsicCriteriaUpdateAllCodes(NSIC_OP_INVERT_SELECTION)"><spring:message code="label.invert_selection"/></a>
    </div>
</c:if>

<div id="criteria-codes-tree" style="display:none">
    <ul>
        <c:forEach items="${codesTree.nodes}" var="node">
            <tags:code-tree-node node="${node}" selectedCodesMap="${queryComponent.codesAsMap}"/>
        </c:forEach>
    </ul>
</div>
