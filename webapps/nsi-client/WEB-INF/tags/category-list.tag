<%@ tag body-content="empty" %>

<%@ attribute name="category" type="org.estat.nsi.client.model.data.CategoryClient"
             required="true" rtexprvalue="true"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<li id="<tags:jstree-id/>" rel="category">
    <a href="#" onclick="javascript:nsicOnCategoryTreeNodeSelected(this)"><tags:artefact-text artefact="${category}"/></a>
    <ul>
        <c:forEach items="${category.clientCategories}" var="childCategory">
            <tags:category-list category="${childCategory}"/>
        </c:forEach>
    </ul>
    <c:if test="${!empty category.dataflows}">
        <ul>
            <c:forEach items="${category.dataflows}" var="dataflow">
                <tags:dataflow-list-item dataflow="${dataflow}"/>
            </c:forEach>
        </ul>
    </c:if>
</li>
