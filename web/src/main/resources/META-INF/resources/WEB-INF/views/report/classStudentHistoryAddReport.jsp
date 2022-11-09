<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let record;

    if (this.ListGrid_class_Evaluation != undefined && this.eval_Flag_Tab_HistoryAdded == 1) {
        this.eval_Flag_Tab_HistoryAdded = null;
        record = this.ListGrid_class_Evaluation.getSelectedRecord();
    } else {
        if (this.ListGrid_Class_JspClass != undefined &&  this.eval_Flag_Tab_HistoryAdded == null) {
            record = this.ListGrid_Class_JspClass.getSelectedRecord();
        }
    }

    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_History_Add_class_student_REFR = isc.TrDS.create({
         fields: [

             {name: "createdBy"},
             {name: "id", primaryKey: true, hidden: true},
              {name: "code"},
              {name: "student"},
             {
                 name: "createdDate",
                 title: "<spring:message code="create.date"/>",
                 filterOperator: "iContains", autoFitWidth: true
             }

         ],
        fetchDataURL:classStudentAddHistoryUrl+record.id ,

    });

    //----------------------------------------------------Criteria Form------------------------------------------------




    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_History_ADD_class_student_REFR = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_History_Add_class_student_REFR,
        dataPageSize: 100,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: true,
        initialSort: [
            {property: "id", direction: "descending", primarySort: true}
        ],
        fields: [
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
             },
            {
                name: "createdBy",
                title: "ایجاد کننده",
                align: "center",
                filterOperator: "equals",
            },
            {
                name: "student",
                title: "فراگیر",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "createdDate",
                width: "10%",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            },


        ]
    });
    var VLayout_Body_History_Add_class_student_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_History_ADD_class_student_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
     // </script>