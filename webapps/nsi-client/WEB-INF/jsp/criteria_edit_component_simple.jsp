<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%-- this are used for passing data to "nsi-client.js" functions --%>
<div style="display:none">
    <div id="criteria-edit-form-type">simple</div>
    <div id="criteria-edit-concept"><c:out value="${queryComponent.concept}"/></div>
    <div id="criteria-update-warning"><c:out value="${warnOnUpdate}"/></div>
</div>

<%-- the help message --%>
<div class="help-message"><spring:message code="html.criteria.help.simple" htmlEscape="false"/></div>

<%-- the edit box for entering the value --%>
<c:set var="theValue" value=""/>
<c:if test="${!empty queryComponent.textValue}">
    <c:set var="theValue" value="${queryComponent.textValue}"/>
</c:if>
<input type="text" id="criteria-component-value" value="<c:out value="${theValue}"/>" size="40"/>

<div style="display:inline-block; position: relative; top: -1px;">
    <span class="button" onclick="$('#criteria-component-value').val(''); nsicOnCriteriaComponentChanged()">
        <spring:message code="label.clear"/>
    </span>
    <span class="button" onclick="nsicOnCriteriaComponentChanged()">
        <spring:message code="label.save"/>
    </span>
</div>