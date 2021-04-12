<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
<%--

    var ListGrid_resendExamStudents = isc.TrLG.create({
        ID: "ExamDoneOnlineGrid",
        //dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor: false,
        canExpandRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
&lt;%&ndash;        gridComponents: [DynamicForm_ExamDoneOnline,&ndash;%&gt;
&lt;%&ndash;            "header", "filterEditor", "body"],&ndash;%&gt;
&lt;%&ndash;        dataSource: RestDataSource_Class_ExamDoneOnline,&ndash;%&gt;
        fields: [


        ],

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "excelBtn") {
                let button = isc.ToolStripButtonExcel.create({
                    margin: 5,
                    click: function () {
                        makeExamExcelOutput(record, JSON.stringify(Object.values(record.users)));
                    }
                });
                return button;
            }
        }
    });


    var VLayout_Body_resendExamVLayout = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_resendExamStudents
        ]
    });--%>
