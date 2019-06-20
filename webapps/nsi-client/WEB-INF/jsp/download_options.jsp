<%@ page import="org.estat.nsi.client.renderer.PageSize" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<iframe name="dl-frame" height="1" width="1" frameborder="0" style="display:none">
    <%-- nothing --%>
</iframe>

<tags:download-form type="html">
    <%-- this must not be removed even if empty, because it renders the form used for sending
    the request to server --%>
</tags:download-form>

<tags:download-form type="xml">
    <table cellpadding="1" cellspacing="0">
        <tr>
            <td><input id="dl-xml-data" type="radio" name="type" value="data" checked="checked"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xml-data"><spring:message code="label.dl.xml.data"/></label>
                <tags:tooltip code="dl.xml.data"/>
            </td>
        </tr>
        <tr>
            <td><input id="dl-xml-structure" type="radio" name="type" value="structure"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xml-structure"><spring:message code="label.dl.xml.structure"/></label>
                <tags:tooltip code="dl.xml.structure"/>
            </td>
        </tr>
        <tr>
            <td><input id="dl-xml-all" type="radio" name="type" value="complete"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xml-all"><spring:message code="label.dl.xml.complete"/></label>
                <tags:tooltip code="dl.xml.complete"/>
            </td>
        </tr>
    </table>
</tags:download-form>

<tags:download-form type="xls">
    <table cellpadding="1" cellspacing="0">
        <tr>
            <td><input id="dl-xls-html" type="radio" name="type" value="html" checked="checked"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xls-html"><spring:message code="label.dl.xls.html"/></label>
                <tags:tooltip code="dl.xls.html"/>
            </td>
        </tr>
        <tr>
            <td><input id="dl-xls-csv-layout" type="radio" name="type" value="csv-layout"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xls-csv-layout"><spring:message code="label.dl.xls.csv.layout"/></label>
                <tags:tooltip code="dl.xls.csv.layout"/>
            </td>
        </tr>
        <tr>
            <td><input id="dl-xls-csv-tabular" type="radio" name="type" value="csv-tabular"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xls-csv-tabular"><spring:message code="label.dl.xls.csv.tabular"/></label>
                <tags:tooltip code="dl.xls.csv.tabular"/>
            </td>
        </tr>
        <tr>
            <td><input id="dl-xls-separator" type="text" name="separator" value="," size="1" maxlength="1"/></td>
            <td style="white-space: nowrap">
                <label for="dl-xls-separator"><spring:message code="label.dl.xls.separator"/></label>
                <tags:tooltip code="dl.xls.separator"/>
            </td>
        </tr>
    </table>
</tags:download-form>

<tags:download-form type="pdf">
    <table cellpadding="1" cellspacing="0">
        <tr>
            <td><label for="dl-pdf-page-size"><spring:message code="label.dl.pdf.page_size"/></label></td>
            <td style="white-space: nowrap">
                <select id="dl-pdf-page-size" name="pageSize">
                    <c:forEach items="<%=PageSize.getStandardPageSizes().values()%>" var="size">
                        <option value="${size.name}"<c:if test="${size.name == 'A4'}">selected="selected"</c:if>><c:out value="${size}"/></option>
                    </c:forEach>
                </select>
                <tags:tooltip code="dl.pdf.page_size"/>
            </td>
        </tr>
        <tr>
            <td><label for="dl-pdf-page-orientation"><spring:message code="label.dl.pdf.page_orientation"/></label></td>
            <td style="white-space: nowrap">
                <select id="dl-pdf-page-orientation" name="landscape">
                    <option value="false"><spring:message code="label.portrait"/></option>
                    <option value="true"><spring:message code="label.landscape"/></option>
                </select>
                <tags:tooltip code="dl.pdf.page_orientation"/>
            </td>
        </tr>
    </table>
</tags:download-form>
