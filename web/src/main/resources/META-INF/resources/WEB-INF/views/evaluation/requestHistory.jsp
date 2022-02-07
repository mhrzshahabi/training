<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
      let record = ListGrid_Request.getSelectedRecord();

    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
     RestDataSource_RequestHistory_REFR = isc.TrDS.create({
         fields: [
              {name: "status",autoFitWidth: true},
             {name: "response",autoFitWidth: true},
             {name: "name", autoFitWidth: true},
             {name: "createdDate", autoFitWidth: true},
             {name: "lastModifiedBy", autoFitWidth: true},
             {name: "lastModifiedDate", autoFitWidth: true},
         ],
        fetchDataURL:requestAuditUrl+record.id ,

    });

    //----------------------------------------------------Criteria Form------------------------------------------------




    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_RequestHistory_REFR = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_RequestHistory_REFR,
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
                name: "name",
                title: "درخواست کننده",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "createdDate",
                title: "تاریخ درخواست",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "status",
                title: "وضعیت درخواست",
                valueMap: {
                    "1": "ACTIVE",
                    "2": "PROGRESSING",
                    "3": "PENDING",
                    "4": "CLOSED"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
            },
            {
                name: "response",
                title: "پاسخ درخواست",
                align: "center",
                filterOperator: "iContains",
             },



              {
                name: "lastModifiedBy",
                title: "ویرایش کننده",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },{
                name: "lastModifiedDate",
                title: "تاریخ ویرایش",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },

        ]
    });
    var VLayout_Body_Comment_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_RequestHistory_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
     // </script>