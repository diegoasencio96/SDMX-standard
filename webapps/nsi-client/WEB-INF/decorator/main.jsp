<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<%@ page import="org.estat.nsi.client.web.I18nSupport" %>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="java.util.Locale" %>

<c:set var="query" value="${sessionScope.sessionQuery}"/>

<html>

<head>
    <title><spring:message code="app.title"/></title>
    <meta name="description" content="<spring:message code="app.description"/>"/>

    <%-- common styles --%>
    <link href="<c:url value="/style/main.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/style/jquery-layout.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/jquery-ui-1.8.5.all/css/redmond/jquery-ui-1.8.5.custom.css"/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value="/style/jquery-ui-theme-fixes.css"/>" rel="stylesheet" type="text/css" />
    <%-- /common styles --%>

    <%-- common js --%>
    <script type="text/javascript" src="<c:url value="/jquery-1.4.2/jquery-1.4.2.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jquery-ui-1.8.5.all/js/jquery-ui-1.8.5.custom.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jquery.layout-1.3.0.rc29.9/jquery.layout-1.3.0.rc29.9.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jstree_pre1.0_stable/jquery.jstree.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jstree_pre1.0_stable/_lib/jquery.cookie.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jquery-blockui-2.35/jquery.blockUI.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/jquery.ui.tabs.paging-r9/ui.tabs.paging.js"/>"></script>
    <%-- /common js --%>

    <%-- custom scripting --%>
    <script type="text/javascript" src="<c:url value="/script/nsi-client.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/nsi-client-utils.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/nsi-client-dataflows.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/nsi-client-criteria.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/nsi-client-results.js"/>"></script>
    <%-- /custom scripting --%>

    <%-- NSI Client script initialization --%>
    <script type="text/javascript">
        <c:if test="${nsicClientInit}">
        nsicSetup({
            baseURL: "<c:url value="/"/>".replace(/;jsessionid.*/, ''),
            ajaxErrorMessage: "<spring:message code="error.ajax.generic" htmlEscape="false" javaScriptEscape="true"/>",
            currentDataflowElmId: "<tags:dataflow-id dataflow="${query.dataflow}" jqueryEscape="true"/>",
            clearCriteriaQuestionMessage: "<spring:message code="question.criteria.clear" htmlEscape="false" javaScriptEscape="true"/>",
            updateCriteriaQuestionMessage: "<spring:message code="question.criteria.update" htmlEscape="false" javaScriptEscape="true"/>",
            startWorkPageIdx: <c:out value="${startWorkPageIdx}"/>,
            startCriteriaComponentIdx: <c:out value="${startCriteriaComponentIdx}"/>,
            labelDownload: "<spring:message code="label.download" htmlEscape="false" javaScriptEscape="true"/>",
            labelCancel: "<spring:message code="label.cancel" htmlEscape="false" javaScriptEscape="true"/>",
            dragSingleSliceComponentError: "<spring:message code="error.drag.slice_component_single" htmlEscape="false" javaScriptEscape="true"/>",
            errorMessageText: "<spring:message code="no.data.found" htmlEscape="false" javaScriptEscape="true"/>"
        });
        </c:if>
    </script>

    <%-- --%>
    <decorator:head/>
</head>

<body>
    <%-- Some modal dialogs displayed by application. --%>
    <div id="dialog-wait" class="dialog-message" style="display:none"><spring:message code="text.wait"/></div>
    <jsp:include page="/WEB-INF/jsp/download_options.jsp"/>
    <%-- end dialogs --%>

    <%-- The element IDs must not be changed, as they are used by "nsi-client.js" file! --%>
    <div id="page-content">
        <div id="page-content-inner">
            <div id="page-header">
                <div id="page-header-left"></div>
                <div id="page-header-right"></div>
            </div>
            <div id="page-toolbar">
                <div id="page-toolbar-left"></div>
                <div id="page-toolbar-right">
                    <c:if test="${nsicClientInit}">
                    <form id="change-locale-form" action="<c:url value="/start.htm"/>" method="POST">
                        <%-- some hidden fields --%>
                        <input id="change-locale-work-page-idx" type="hidden" name="workPageIdx" value="-1"/>
                        <input id="change-locale-criteria-component-idx" type="hidden" name="criteriaComponentIdx" value="-1"/>
                        <input type="hidden" name="forceSessionValidation" value="true"/>
                        <%-- end hidden fields --%>
                        <% Locale currentLocale = RequestContextUtils.getLocale(request); %>
                        <select id="change-locale-combobox" name="locale" onchange="nsicOnLanguageChange()">
                            <%
                            	for (Locale locale : I18nSupport.getInstance().getAvailableLocales()) {
                            %>
                                <option value="<c:out value="<%=locale%>"/>"<c:if test="<%=currentLocale.equals(locale)%>"> selected="selected"</c:if>>
                                    <c:out value="<%=locale.getDisplayLanguage(locale).substring(0,1).toUpperCase() + locale.getDisplayLanguage(locale).substring(1) %>"/>
                                </option>
                            <%
                            	}
                            %>
                            
                        </select>
                    </form>
                    </c:if>
                </div>
            </div>
            <div id="page-body"><decorator:body/></div>
            <div id="page-footer">
                <div id="page-footer-copyright"><spring:message code="app.copyright"/></div>
                <div id="page-footer-version"><spring:message code="app.version"/></div>
            </div>
        </div>
    </div>
</body>
</html>
