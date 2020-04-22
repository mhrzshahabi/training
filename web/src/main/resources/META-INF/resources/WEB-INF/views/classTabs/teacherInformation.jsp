<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>



    //******************************
    //Menu
    //******************************
    Menu_ListGrid_teacherInformation = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_teacherInformation.invalidateCache();
                }
            },

           ]
    });
    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_teacherInformation = isc.TrDS.create({
        fields: [
            {name: "teacher.personality.firstNameFa"},
          //  {name: "teacher.personality.firstNameFa"},
        ]
    });

    var ListGrid_teacherInformation = isc.TrLG.create({
        dataSource: RestDataSource_teacherInformation,
        contextMenu: Menu_ListGrid_teacherInformation,
        autoFetchData: true,
        fields: [
            {name: "teacher.personality.firstNameFa", title: "<spring:message code="title"/>", align: "center", filterOperator: "iContains"}
            ],
        recordDoubleClick: function () {
         

        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,
        sortDirection: "descending",

    });
    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************

    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_teacherInformation.invalidateCache();
        }
    });



    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [

            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            })
        ]
    });
    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    var  HLayout_Grid_teacherInformation = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_teacherInformation]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Group
            , HLayout_Grid_teacherInformation
        ]
    });

    //************************************************************************************
    //function
    //************************************************************************************
            function  loadPage_teacherInformation() {
               // classRecord = ListGrid_Class_JspClass.getSelectedRecord();

                RestDataSource_teacherInformation.fetchDataURL=teacherInformation +"/teacher-information-iscList" + "/CO1C1M05";
                ListGrid_teacherInformation.invalidateCache()
                ListGrid_teacherInformation.fetchData()


                }
            // } else {
            // ListGrid_Class_Student.setData([]);
            // }

