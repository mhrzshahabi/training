<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>


    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        Menu_ListGrid_operationalUnit = isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="create"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="edit"/>",
                    icon: "<spring:url value="edit.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {

                    }
                },
                {
                    isSeparator: true
                },
                {
                    title: "<spring:message code="print.pdf"/>",
                    icon: "<spring:url value="pdf.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="print.excel"/>",
                    icon: "<spring:url value="excel.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="print.html"/>",
                    icon: "<spring:url value="html.png"/>",
                    click: function () {

                    }
                }
            ]
        })
    }
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>


    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        var ToolStripButton_Refresh = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/refresh.png",
            title: "<spring:message code="refresh"/>",
            click: function () {

            }
        });

        var ToolStripButton_Add = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/add.png",
            title: "<spring:message code="create"/>",
            click: function () {

            }
        });

        var ToolStripButton_Edit = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/edit.png",
            title: "<spring:message code="edit"/>",
            click: function () {

            }
        });

        var ToolStripButton_Remove = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/remove.png",
            title: "<spring:message code="remove"/>",
            click: function () {

            }
        });

        var ToolStripButton_Print = isc.ToolStripButton.create({
            icon: "[SKIN]/RichTextEditor/print.png",
            title: "<spring:message code="print"/>",
            click: function () {

            }
        });

        var ToolStrip_Operational = isc.ToolStrip.create({
            width: "100%",
            members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>


    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        var HLayout_Actions_Operational = isc.HLayout.create({
            width: "100%",
            members: [ToolStrip_Operational]
        });

        var VLayout_Body_Operational = isc.VLayout.create({
            width: "100%",
            height:"100%",
            members: [HLayout_Actions_Operational]
        });
    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>

    //</script>