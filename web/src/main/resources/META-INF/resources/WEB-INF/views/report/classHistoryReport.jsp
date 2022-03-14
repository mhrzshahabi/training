<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
      let record = ListGrid_Class_JspClass.getSelectedRecord();

    //----------------------------------------------------Rest DataSource-----------------------------------------------
     RestDataSource_History_REFR = isc.TrDS.create({
         fields: [
             {name: "group"},
             {name: "classCancelReasonId"},

             {name: "titleClass"},
             {name: "createdBy", autoFitWidth: true},
             {name: "modifiedBy", autoFitWidth: true},
             {name: "modifiedDate", autoFitWidth: true},

             {name: "startDate", autoFitWidth: true},
             {name: "endDate", autoFitWidth: true},
              {name: "code", autoFitWidth: true},
             {name: "courseId", autoFitWidth: true},
              {name: "plannerId", autoFitWidth: true},
             {name: "acceptancelimit", autoFitWidth: true},
             {name: "teacher", autoFitWidth: true},

             {name: "reason" , autoFitWidth: true},
             {name: "classStatus" , autoFitWidth: true},
             {name: "topology"},
              {name: "complexId"},
             {name: "assistantId"},
             {name: "affairsId"},
             {name: "minCapacity"},
             {name: "maxCapacity"},
         ],
        fetchDataURL:classAuditUrl+record.id,
    });

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
        initialSort: [
            {property: "modifiedDate", direction: "descending"}
        ],
        fields: [
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
             },
            {
                name: "titleClass",
                title: "عنوان کلاس",
                align: "center",
                filterOperator: "iContains"},
            {
                name: "minCapacity",
                title: "حداقل ظرفیت",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "maxCapacity",
                title: "حداکثر ظرفیت",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },   {
                name: "complexId",
                title: "شناسه مجتمع",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "assistantId",
                title: "شناسه معاونت",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "affairsId",
                title: "شناسه امور",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "plannerId",
                title: "شناسه برنامه ریز",
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
                title: "مدرس",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },  {
                name: "acceptancelimit",
                title: "حد قبولی کلاس",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },

            {
                name: "reason", title: "<spring:message code='training.request'/>", align: "center",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
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
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام",
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
                    "1": "U شکل",
                    "2": "عادی",
                    "3": "مدور",
                    "4": "سالن"
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
                title: "ایجاد کننده",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },
            {
                name: "modifiedBy",
                title: "ویرایش کننده",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },
            {
                name: "modifiedDate",
                title: "تاریخ ویرایش",
                hidden: true
            }
        ]
    });
    var VLayout_Body_Comment_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_History_REFR
        ]
    });

     // </script>