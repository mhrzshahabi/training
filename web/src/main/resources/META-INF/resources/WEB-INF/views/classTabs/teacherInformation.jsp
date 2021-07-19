<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

let classRecord;

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
         {name: "personality.firstNameFa"},
         {name: "personality.lastNameFa"},
         {name: "personality.nationalCode"},
         {name: "personality.contactInfo.mobile"},
         {name: "personality.contactInfo.homeAddress.state.name"},
         {name: "personality.contactInfo.homeAddress.city.name"},
         ]
    });

     var ListGrid_teacherInformation = isc.TrLG.create({
     dataSource: RestDataSource_teacherInformation,
     fields: [
     {
     name: "personality.firstNameFa",
     title: "<spring:message code="firstName"/>",
     align: "center",
     filterOperator: "iContains",
     sortNormalizer(record){
     return record.personality.firstNameFa
     },
     },
     {
     name: "personality.lastNameFa",
     title: "<spring:message code="lastName"/>",
     align: "center",
     filterOperator: "iContains",
     sortNormalizer(record){
     return record.personality.lastNameFa
     },
     },

     {
     name: "personality.contactInfo.mobile",
     title: "<spring:message code="mobile"/>",
     align: "center",
     filterOperator: "iContains",
     filterEditorProperties: {
     keyPressFilter: "[0-9]"
     },
     sortNormalizer(record){
         let tmp = record.personality?.contactInfo?.mobile;
         return tmp ? "" : tmp;
     },
     },
     {
     name: "personality.nationalCode",
     title: "<spring:message code="national.code"/>",
     align: "center",
     filterOperator: "iContains",
     filterEditorProperties: {
     keyPressFilter: "[0-9]"
     },
     sortNormalizer(record){
     return record.personality.nationalCode
     },
     },
     ],
     filterOnKeypress: false,
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

    var infoButton = isc.ToolStripButtonRefresh.create({
        ID: "infoButton",
        title:"",
        icon: "<spring:url value="help.png"/>",
        click : function() {
            isc.Dialog.create({
                title:"توضیحات",
                message : "این قسمت شامل لیست اساتید برگزارکننده دوره " + classRecord.course.titleFa +" می باشد" ,
                // icon:"[SKIN]ask.png",
                buttons : [
                    isc.Button.create({ title:"<spring:message code='close'/>" }),
                ],
                buttonClick : function (button, index) {
                    this.hide();
                }
            });
        },
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonExcel.create({
                        click: function () {
                            let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                            if (!(classRecord === undefined || classRecord == null)) {
                                ExportToFile.downloadExcelRestUrl(null, ListGrid_teacherInformation, teacherInformation +"/teacher-information-iscList" + "/"+classRecord.code.split('-')[0], 0, ListGrid_Class_JspClass, '', "کلاس - اساتيدي که اين دوره را تدريس کرده اند", ListGrid_teacherInformation.getCriteria(), null);
                            }
                        }
                    }),
                    isc.LayoutSpacer.create({width: "*"}),
                    infoButton,
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
    function  loadPage_teacherInformation(classRecord) {

        if (!(classRecord == undefined || classRecord == null)) {
        RestDataSource_teacherInformation.fetchDataURL=teacherInformation +"/teacher-information-iscList" + "/"+classRecord.course.id;
        ListGrid_teacherInformation.invalidateCache()
        ListGrid_teacherInformation.fetchData()
        }
        else {
        ListGrid_teacherInformation.setData([]);
        }
    }

