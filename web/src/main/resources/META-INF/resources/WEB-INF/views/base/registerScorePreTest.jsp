<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    var change_value_registerScorePreTest;
    var wait_registerScorePreTest;
    var classID_registerScorePreTest;
    var scoringMethod_registerScorePreTest;

    var RestDataSource_ClassStudent_registerScorePreTest = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true, primaryKey: true},
            {name: "tclass.scoringMethod"},
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",

            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",

            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",

            },

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",

            },
            {name:"preTestScore", title: "<spring:message code="score"/>", filterOperator: "iContains"},
        ],
    });

    var ListGrid_Class_Student_RegisterScorePreTest = isc.TrLG.create({
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        canHover:true,
        canSelectCells: true,
        autoFetchData: false,
        dataSource: RestDataSource_ClassStudent_registerScorePreTest,
        fields: [

            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",

            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",

            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "preTestScore",
                title: "نمره پيش آزمون",
                filterOperator: "iContains",
                canEdit: true,
                validateOnChange: false,
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                },
                editEvent: "click",
                change: function (form, item, value, oldValue) {

                    if (value != null && value != '' && typeof (value) != 'undefined' && !value.match(/^(([1-9]\d{0,1})|100|0)$/)) {
                        item.setValue(value.substring(0, value.length - 1));
                    } else {
                        item.setValue(value);
                    }

                    if (value == null || typeof (value) == 'undefined') {
                        item.setValue('');
                    }


                    if (oldValue == null || typeof (oldValue) == 'undefined') {
                        oldValue = '';
                    }


                    if (item.getValue() != oldValue) {
                        change_value_registerScorePreTest = true;
                    }
                },
                editorExit: function (editCompletionEvent, record, newValue) {

                    if (change_value_registerScorePreTest) {
                        wait_registerScorePreTest = createDialog("wait");
                        if (newValue != null && newValue != '' && typeof (newValue) != 'undefined') {

                            ListGrid_Cell_ScorePreTest_Update(record, newValue);

                        } else {
                            ListGrid_Cell_ScorePreTest_Update(record, null);
                        }
                    }
                    change_value_registerScorePreTest = false;
                },
                hoverHTML: function (record, rowNum, colNum, grid) {
                    return "نمره پیش آزمون بین 0 تا 100 می باشد"
                }
            },

        ],

    });

    var Body_RegisterScorePreTest = isc.HLayout.create({
        members: [ListGrid_Class_Student_RegisterScorePreTest]
    });

    function ListGrid_Cell_ScorePreTest_Update(record, newValue) {
        record.preTestScore = newValue;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/score-pre-test" + "/" + record.id,
            "PUT", JSON.stringify(record), "callback: Edit_score_Update(rpcResponse)"));
    }

    function Edit_score_Update(resp) {
            wait_registerScorePreTest.close();
    }

    function validators_ScorePreTest(value) {

        if (value.match(/^(100|[1-9]?\d)$/)) {
            return true
        } else {
            return false
        }
    }

    function call_registerScorePreTest(classId,scoringMethod) {
        classID_registerScorePreTest = classId;
        scoringMethod_registerScorePreTest = scoringMethod;
        RestDataSource_ClassStudent_registerScorePreTest.fetchDataURL = tclassStudentUrl + "/pre-test-score-iscList/" + classId;
        ListGrid_Class_Student_RegisterScorePreTest.invalidateCache();
        ListGrid_Class_Student_RegisterScorePreTest.fetchData();
    }














