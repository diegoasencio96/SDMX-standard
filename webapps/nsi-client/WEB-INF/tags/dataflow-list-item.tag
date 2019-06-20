<%@ tag body-content="empty" %>

<%@attribute name="dataflow" type="org.estat.nsi.client.model.data.DataflowClient"
             required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<c:if test="${dataflow.accesible}">
	<li id="<tags:dataflow-id dataflow="${dataflow}" javaScriptEscape="true"/>" class="dataflow-item" rel="dataflow">
	    <a href="#">
	        <div class="dataflow-agency"><c:out value="${dataflow.agencyId}"/></div>
	        <div class="dataflow-id"><c:out value="${dataflow.id}"/></div>
	        <div class="dataflow-version"><c:out value="${dataflow.version}"/></div>
	        -
	        <div class="dataflow-name"><tags:artefact-text artefact="${dataflow}"/></div>
	    </a>
	</li>
</c:if>

<c:if test="${!dataflow.accesible}">
	<li id="<tags:dataflow-id dataflow="${dataflow}" javaScriptEscape="true"/>" class="dataflow-item" rel="xs-dataflow">
	    <a href="#" title="${dataflow.annotationTitle}">
	        <div class="dataflow-agency"><c:out value="${dataflow.agencyId}"/></div>
	        <div class="dataflow-id"><c:out value="${dataflow.id}"/></div>
	        <div class="dataflow-version"><c:out value="${dataflow.version}"/></div>
	        -
	        <div class="dataflow-name"><tags:artefact-text artefact="${dataflow}"/></div>
	    </a>
	</li>
</c:if>
