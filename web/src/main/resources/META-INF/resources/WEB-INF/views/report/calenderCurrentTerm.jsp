<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
 var RestDataSource_Class_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
// {name: "lastModifiedDate",hidden:true},
// {name: "createdBy",hidden:true},
// {name: "createdDate",hidden:true,type:d},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "term.titleFa"},
// {name: "teacher.personality.lastNameFa"},
// {name: "course.code"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {name: "teacher"},
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"}
        ],
        fetchDataURL: calenderCurrentTerm + "spec-list"
    });
    //******************************
    //Menu
    //******************************
    Menu_ListGrid_CurrentTerm = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_Term.invalidateCache();
                }
            }]
    });


    var ListGrid_CalculatorCurrentTerm = isc.TrLG.create({
        dataSource: RestDataSource_Class_CurrentTerm,
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_CurrentTerm,
        autoFetchData: true,

          fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleClass",
                title: "titleClass",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "term.titleFa",
                title: "term",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "iContains"},
            {
                name: "group",
                title: "<spring:message code='group'/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true
            },
            <%--{name: "reason", title: "<spring:message code='training.request'/>", align: "center"},--%>
            {name: "teacher", title: "<spring:message code='teacher'/>", align: "center", filterOperator: "iContains"},
            {
                name: "reason", title: "<spring:message code='training.request'/>", align: "center",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                },
            },
            {
                name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
            },
            {
                name: "topology", title: "<spring:message code='place.shape'/>", align: "center", valueMap: {
                    "1": "U شکل",
                    "2": "عادی",
                    "3": "مدور",
                    "4": "سالن"
                }
            },

            {
                name: "workflowEndingStatusCode",
                title: "workflowCode",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "workflowEndingStatus",
                title: "<spring:message code="ending.class.status"/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"}

        ],
        recordDoubleClick: function () {

        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",

    });
    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************

    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({

        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_CalculatorCurrentTerm.invalidateCache();
        }
    });


    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
         title: "<spring:message code="print"/>",
        click: function () {
            print_TermListGrid("pdf");

        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
             ToolStripButton_Print,
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

    var HLayout_Grid_CalculatorCurrentTerm = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_CalculatorCurrentTerm]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Group
            , HLayout_Grid_CalculatorCurrentTerm
        ]
    });

    //************************************************************************************
    //function
    //************************************************************************************
    //===================================================================================

   <%--function print_TermListGrid(type) {--%>

   <%--     var advancedCriteria = ListGrid_Term.getCriteria();--%>
   <%--     var criteriaForm = isc.DynamicForm.create({--%>
   <%--         method: "POST",--%>
   <%--         action: "<spring:url value="/term/printWithCriteria/"/>" + type,--%>
   <%--         target: "_Blank",--%>
   <%--         canSubmit: true,--%>
   <%--         fields:--%>
   <%--             [--%>
   <%--                 {name: "CriteriaStr", type: "hidden"},--%>
   <%--                 {name: "token", type: "hidden"}--%>
   <%--             ]--%>

   <%--     })--%>
   <%--     criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));--%>
   <%--     criteriaForm.setValue("token", "<%= accessToken %>")--%>
   <%--     criteriaForm.show();--%>
   <%--     criteriaForm.submitForm();--%>
   <%-- };--%>

