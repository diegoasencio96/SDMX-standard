<%@ tag body-content="empty" %>

<%@ attribute name="node" type="org.estat.nsi.client.web.CodesTreeNode" required="true" rtexprvalue="true" %>
<%@ attribute name="selectedCodesMap" type="java.util.Map" required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<%
    String cssClass = "";
    if (node.getChildren().size() > 0) {
        cssClass = "jstree-open";
    }
    if (selectedCodesMap.containsKey(node.getId())) {
        cssClass += " jstree-checked";
    }
%>

<li id="CLV_<spring:escapeBody javaScriptEscape="true">${node.id}</spring:escapeBody>" class="<%=cssClass%>">
    <a href="#">
        [<c:out value="${node.id}"/>] - <tags:nameable-artefact-text artefact="${node.code}"/>
    </a>
    <c:if test="${!empty node.children}">
        <ul>
            <c:forEach items="${node.children}" var="childNode">
                <tags:code-tree-node node="${childNode}" selectedCodesMap="${selectedCodesMap}"/>
            </c:forEach>
        </ul>
    </c:if>
</li>
