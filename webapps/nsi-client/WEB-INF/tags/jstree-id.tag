<% out = ((PageContext)jspContext).pushBody(); %>

<%@ tag body-content="empty" %>

<%@ attribute name="reset" type="java.lang.Boolean" required="false" rtexprvalue="true" %>
<%@ attribute name="output" type="java.lang.Boolean" required="false" rtexprvalue="true" %>

<%
    out = jspContext.popBody();

    Integer id = null;

    synchronized (this.getClass()) {
        if ((reset == null) || !reset) {
            id = (Integer) session.getAttribute("nsic.jstree.id");
        }

        if (id == null) {
            id = new Integer(1);
        }

        session.setAttribute("nsic.jstree.id", new Integer(id + 1));
    }

    if ((output == null) || output) {
        out.print("n_" + id);
    }
    
    return;
%>