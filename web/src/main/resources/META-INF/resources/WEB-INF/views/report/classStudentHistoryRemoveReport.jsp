<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
      let record = ListGrid_Class_JspClass.getSelectedRecord();

    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_History_class_student_REFR = isc.TrDS.create({
         fields: [

             {name: "createdBy", autoFitWidth: true},

              {name: "code", autoFitWidth: true},
              {name: "student", autoFitWidth: true},

         ],
        fetchDataURL:classStudentHistoryUrl+record.id ,

    });

    //----------------------------------------------------Criteria Form------------------------------------------------




    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_History_class_student_REFR = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_History_class_student_REFR,
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
                name: "createdBy",
                title: "حذف کننده",
                align: "center",
                autoFitWidth: true,
                filterOperator: "equals",
            },
            {
                name: "student",
                title: "فراگیر",
                align: "center",
                filterOperator: "iContains",
            },


        ]
    });
    var VLayout_Body_History_class_student_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_History_class_student_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
     // </script>