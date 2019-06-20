<%@ tag body-content="empty" %>

<%@attribute name="key" type="java.lang.String" required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ tag import="org.sdmxsource.sdmx.api.model.beans.conceptscheme.ConceptBean" %>
<%@ tag import="org.estat.nsi.client.util.Utils" %>
<%@ tag import="org.estat.nsi.client.web.SessionQueryMgr" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag import="org.estat.nsi.client.web.SessionQuery" %>
<%@ tag import="org.estat.nsi.client.renderer.DataSetModel" %>

<%
    SessionQuery query = SessionQueryMgr.getSessionQuery(session);
    ConceptBean concept = Utils.findConcept(query.getStructure(), key);
    String language = RequestContextUtils.getLocale(request).getLanguage();
    String title = Utils.getDisplayText(concept.getNames(), concept.getDescriptions(), language);

    DataSetModel datasetModel = query.getDataSetModel();
    boolean isSliceKey = datasetModel.getSliceKeys().contains(key);
    boolean hasMultipleValues = isSliceKey ? datasetModel.getSliceKeyValidValues(key).size() > 1
            : datasetModel.hasMultipleValues(key, true);

    String countSuffix = (hasMultipleValues ? "-multiple" : "-single");
    String axisClass = isSliceKey ? "component-slice" : datasetModel.getHorizontalKeys().contains(key) ?
            "component-horizontal" : "component-vertical";

    String css = "component component" + countSuffix + " " + axisClass
            + " " + axisClass + countSuffix;
%>

<li class="<%=css%>">
    <div id="KEY_<spring:escapeBody htmlEscape="false" javaScriptEscape="true">${key}</spring:escapeBody>"
            class="<%=css%>" title="<spring:escapeBody javaScriptEscape="true" htmlEscape="false"><%=title%></spring:escapeBody>">
        <c:out value="${key}"/>
    </div>
</li>
