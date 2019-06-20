<%@ tag body-content="empty" %>

<%@attribute name="key" type="java.lang.String" required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<%@ tag import="org.sdmxsource.sdmx.api.model.beans.codelist.CodelistBean" %>
<%@ tag import="org.apache.commons.lang.StringUtils" %>
<%@ tag import="org.estat.nsi.client.util.Utils" %>
<%@ tag import="org.estat.nsi.client.renderer.DataSetModel" %>
<%@ tag import="org.estat.nsi.client.web.SessionQuery" %>
<%@ tag import="org.estat.nsi.client.web.SessionQueryMgr" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>

<%
    SessionQuery query = SessionQueryMgr.getSessionQuery(session);
    DataSetModel model = query.getDataSetModel();
    CodelistBean codelist = Utils.findCodeList(query.getStructure(), key); // this may be NULL
    String currentValue = model.getSliceKeyValue(key);
    String language = RequestContextUtils.getLocale(request).getLanguage();
%>

<c:choose>
    <c:when test="<%=model.getSliceKeyValidValues(key).size() == 1%>">
        <% String text = codelist != null ? Utils.getTextForCode(codelist, currentValue, language) : null; %>
        <c:choose>
            <c:when test="<%=text != null%>">
                [<c:out value="<%=currentValue%>"/>] <c:out value="<%=text%>"/>
            </c:when>
            <c:otherwise>
                <c:out value="<%=currentValue%>"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <select id="SKV_<spring:escapeBody htmlEscape="false" javaScriptEscape="true"><%=key%></spring:escapeBody>" onchange="nsicOnSliceKeyValueChanged(this)">
            <c:forEach items="<%=model.getSliceKeyValidValues(key)%>" var="val">
                <% String val = (String)jspContext.getAttribute("val"); %>
                <% String text = codelist != null ? Utils.getTextForCode(codelist, val, language) : null; %>
                <option <c:if test="<%=StringUtils.equals(currentValue, val)%>">selected="selected"</c:if> value="<spring:escapeBody htmlEscape="false" javaScriptEscape="true">${val}</spring:escapeBody>">
                    <c:choose>
                        <c:when test="<%=text != null%>">
                            [<c:out value="${val}"/>] <c:out value="<%=text%>"/>
                        </c:when>
                        <c:otherwise>
                            <c:out value="${val}"/>
                        </c:otherwise>
                    </c:choose>
                </option>
            </c:forEach>
        </select>
    </c:otherwise>
</c:choose>
