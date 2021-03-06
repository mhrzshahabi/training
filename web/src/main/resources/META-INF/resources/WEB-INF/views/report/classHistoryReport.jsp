<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
      let record = ListGrid_Class_JspClass.getSelectedRecord();

    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
     RestDataSource_History_REFR = isc.TrDS.create({
         fields: [
              {name: "group"},
             {name: "classCancelReasonId"},

             {name: "titleClass"},
             {name: "createdBy", autoFitWidth: true},
             {name: "modifiedBy", autoFitWidth: true},


             {name: "startDate", autoFitWidth: true},
             {name: "endDate", autoFitWidth: true},
              {name: "code", autoFitWidth: true},
             {name: "courseId", autoFitWidth: true},
              {name: "plannerId", autoFitWidth: true},
             {name: "acceptancelimit", autoFitWidth: true},
             {
                 name: "teacher",
                 autoFitWidth: true
             },

             {name: "reason" , autoFitWidth: true},
             {name: "classStatus" , autoFitWidth: true},
             {name: "topology"},
              {name: "complexId"},
             {name: "assistantId"},
             {name: "affairsId"},
             {name: "minCapacity"},
             {name: "maxCapacity"},
         ],
        fetchDataURL:classAuditUrl+record.id ,

    });

    //----------------------------------------------------Criteria Form------------------------------------------------




    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_History_REFR = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_History_REFR,
        dataPageSize: 100,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: true,
        fields: [
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
             },
            {
                name: "titleClass",
                title: "?????????? ????????",
                align: "center",
                filterOperator: "iContains"},
            {
                name: "minCapacity",
                title: "?????????? ??????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "maxCapacity",
                title: "???????????? ??????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },   {
                name: "complexId",
                title: "?????????? ??????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "assistantId",
                title: "?????????? ????????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "affairsId",
                title: "?????????? ????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "plannerId",
                title: "?????????? ???????????? ??????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },

            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
            },

            {
                name: "group",
                title: "<spring:message code='group'/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },
            {
                name: "teacher",
                title: "????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },  {
                name: "acceptancelimit",
                title: "???? ?????????? ????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },

            {
                name: "reason", title: "<spring:message code='training.request'/>", align: "center",
                valueMap: {
                    "1": "????????????????",
                    "2": "?????????????? ????????",
                    "3": "???????? ??????????",
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
            },
            {
                name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                valueMap: {
                    "1": "???????????? ????????",
                    "2": "???? ?????? ????????",
                    "3": "?????????? ??????????",
                    "4": "?????? ??????",
                    "5": "????????????",
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
                width: 100,
                showHover: true,
                hoverWidth: 150
            },
            {
                name: "topology", title: "<spring:message code='place.shape'/>", align: "center", valueMap: {
                    "1": "U ??????",
                    "2": "????????",
                    "3": "????????",
                    "4": "????????"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
                hidden: false,
                autoFitWidth: true
            },
            {
                name: "createdBy",
                title: "?????????? ??????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },
            {
                name: "modifiedBy",
                title: "???????????? ??????????",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },

        ]
    });
    var VLayout_Body_Comment_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_History_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
     // </script>