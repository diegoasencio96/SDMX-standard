<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<c:set var="query" value="${sessionScope.sessionQuery}"/>

<%--//TODO: to add a warning message when there are no categories or no dataflows--%>

<tags:jstree-id reset="true" output="false"/>

<c:if test="${!empty query.categorySchemes}">
    <p><spring:message code="html.dataflows.help" htmlEscape="false"/></p>

    <div class="dataflow-links">
        <a href="javascript:nsicOnDataflowsExpandAllClicked()"><spring:message code="label.expand.all"/></a> -
        <a href="javascript:nsicOnDataflowsExpandCategoriesClicked()"><spring:message code="label.expand.categories"/></a> -
        <a href="javascript:nsicOnDataflowsCollapseAllClicked()"><spring:message code="label.collapse.all"/></a>
    </div>

    <div id="dataflows-tree">
        <ul>
            <c:forEach items="${query.categorySchemes}" var="scheme">
                <li id="<tags:jstree-id/>" rel="category-scheme">
                    <a href="#" onclick="javascript:nsicOnCategoryTreeNodeSelected(this)"><tags:artefact-text artefact="${scheme}"/></a>
                    <ul>
                        <c:forEach items="${scheme.clientCategories}" var="category">
                            <tags:category-list category="${category}"/>
                        </c:forEach>
                    </ul>
                </li>
            </c:forEach>
            <c:if test="${!empty query.uncategorizedDataflows}">
                <li id="<tags:jstree-id/>" rel="category-scheme">
                    <a href="#"><spring:message code="text.dataflows.uncategorized"/></a>
                    <ul>
                        <c:forEach items="${query.uncategorizedDataflows}" var="dataflow">
                            <tags:dataflow-list-item dataflow="${dataflow}"/>
                        </c:forEach>
                    </ul>
                </li>
            </c:if>
        </ul>
    </div>
</c:if>
