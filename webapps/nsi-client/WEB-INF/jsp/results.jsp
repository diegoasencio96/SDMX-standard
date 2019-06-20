<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<%@ page import="org.estat.nsi.client.web.DownloadType" %>
<%@ page import="org.estat.nsi.client.web.SessionQueryMgr" %>
<%@ page import="org.estat.nsi.client.web.SessionQuery" %>

<c:set var="query" value="${sessionScope.sessionQuery}"/>
<c:set var="datasetModel" value="${query.dataSetModel}"/>

<% SessionQuery query = SessionQueryMgr.getSessionQuery(request); %>

<%-- page links --%>
<div class="page-links">
    <spring:message code="label.download"/>:
    <c:forEach items="<%=DownloadType.values()%>" var="dlType">
        <c:set value="${fn:toLowerCase(dlType)}" var="type"/>
        <c:choose>
            <c:when test="${type != 'html'}">
                <spring:message var="title" code="title.dl.${type}" javaScriptEscape="true"/>
            </c:when>
            <c:otherwise>
                <c:set var="title" value=""/>
            </c:otherwise>
        </c:choose>
        [ <a href="javascript:nsicStartDownload('<spring:escapeBody javaScriptEscape="true">${type}</spring:escapeBody>', '${title}')"><spring:message code="label.${type}"/></a> ]
    </c:forEach>
</div>

<div class="help-message"><spring:message code="html.results.help.1" htmlEscape="false"/></div>

<c:if test="${!empty datasetModel.horizontalKeys or !empty datasetModel.verticalKeys}">
    <div class="help-message"><spring:message code="html.results.help.2" htmlEscape="false"/></div>
</c:if>

<div id="results-buttons">
    <span id="results-button-apply" class="button" onclick="nsicOnResultsApplyButtonClicked()">
        <spring:message code="label.apply"/>
    </span>
    <span id="results-button-cancel" class="button" onclick="nsicOnResultsCancelButtonClicked()">
        <spring:message code="label.cancel"/>
    </span>
    <c:if test="${!empty datasetModel.horizontalKeys or !empty datasetModel.verticalKeys}">
        <span class="button" onclick="nsicOnResultsResetDisplayModeClicked()">
            <spring:message code="label.reset_display_mode"/>
        </span>
    </c:if>
</div>

<table id="results-hdr" class="results-table" cellpadding="0" cellspacing="0">
    <tr id="results-axis-slice">
        <td colspan="2">
            <ul class="results-layout-axis">
                <li class="fixed"><spring:message code="label.axis.z"/></li>
                <c:forEach items="${datasetModel.sliceKeys}" var="key">
                    <tags:key-list-item key="${key}"/>
                </c:forEach>
            </ul>
        </td>
    </tr>
    <c:if test="${!empty datasetModel.sliceKeys}">
    <tr id="results-slice-filter">
        <td colspan="2">
            <table id="results-slice-keys" cellspacing="0" cellpadding="0">
                <c:forEach items="${datasetModel.sliceKeys}" var="key">
                    <tr>
                        <td class="key-name">
                            <tags:concept id="${key}" var="concept"/>
                            <tags:nameable-artefact-text artefact="${concept}" type="name"/>
                        </td>
                        <td class="key-value">
                            <tags:slice-key-value key="${key}"/>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </td>
    </tr>
    </c:if>
</table>

<br/>

<table id="results-body" class="results-table">
    <tr>
        <td width="1%">&nbsp;</td>
        <td width="100%" id="results-axis-horizontal">
            <ul class="results-layout-axis">
                <li class="fixed"><spring:message code="label.axis.x"/></li>
                <c:forEach items="${datasetModel.horizontalKeys}" var="key">
                    <tags:key-list-item key="${key}"/>
                </c:forEach>
            </ul>

        </td>
    </tr>

    <tr>
        <td id="results-axis-vertical">
            <ul class="results-layout-axis">
                <li class="fixed"><spring:message code="label.axis.y"/></li>
                <c:forEach items="${datasetModel.verticalKeys}" var="key">
                    <tags:key-list-item key="${key}"/>
                </c:forEach>
            </ul>
        </td>
        <td id="results-data">
             <%-- See http://www.brunildo.org/test/overscrollback.html for details --%>
            <div id="results-data-padding">
                <div id="results-data-padding-inner"></div>
                ${dataTable}
            </div>
        </td>
    </tr>
</table>
