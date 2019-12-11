<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
//
// <script>

    var x;
    RestDataSource_ClassStudent = isc.TrDS.create({
        fields: [],
    });
    var ListGrid_ClassStudent = isc.ListGrid.create({
        width: "100%",
//------------
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,

//------
        sortField: 0,
        dataSource: RestDataSource_ClassStudent,
        filterOperator: "iContains",
        filterOnKeypress: true,
        fields: [
            {name: "id", hidden: true},
            {name: "student.firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "student.lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.companyName",
                title: "<spring:message code="company"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "student.personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains"},
            {
                name: "scoresState",
                title: "وضعیت قبولی",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: ["قبول با نمره", "قبول بدون نمره", "مردود"],
                change: function (form, item, value) {

                    ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);

                }
            },
            {
                name: "failurereason",
                title: "دلایل مردودی",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"],
                change: function (form, item, value) {
                    ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                }
            },

            {
                name: "score", title: "نمره", filterOperator: "iContains", canEdit: true, shouldSaveValue: false,
                editorType: "Float",

                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {
                    if (newValue >= 10) {
                        ListGrid_Cell_scoresState_Update(record, "قبول با نمره");
                        ListGrid_Cell_failurereason_Update(record, "")
                        ListGrid_Cell_score_Update(record, newValue);
                    } else {
                        ListGrid_Cell_score_Update(record, newValue);
                    }

                    if (0 <= newValue && newValue < 10 && newValue != null) {

                        ListGrid_Cell_scoresState_Update(record, "مردود")
                        ListGrid_Cell_score_Update(record, newValue);
                        createDialog("info", "دلایل مردود به صورت پیش فرض 'عدم کسب حد نصاب نمره' لحاظ شده است ")
                        ListGrid_Cell_failurereason_Update(record, "عدم کسب حد نصاب نمره")
                    }

                    if (newValue == null) {
                        ListGrid_Cell_score_Update(record, newValue);
                        ListGrid_Cell_failurereason_Update(record, null)
                        ListGrid_Cell_scoresState_Update(record, null)
                        ListGrid_ClassStudent.refreshFields();
                    }

                }

            }

        ],
        canEditCell: function (rowNum, colNum) {
            var record = this.getRecord(rowNum),
                fieldName = this.getFieldName(colNum);
            if (fieldName === "failurereason") {
                return !(record.scoresState === "قبول با نمره" || record.scoresState === "قبول بدون نمره" || record.score >= 10);
            }
            if (fieldName === "score") {
                return record.scoresState !== "قبول بدون نمره";
            }

            if (fieldName === "scoresState") {
                return true;
            }
           return false;

            },


    });


    var vlayout = isc.VLayout.create({
        width: "100%",
        members: [ListGrid_ClassStudent]
    })


    function ListGrid_Cell_scoresState_Update(record, newValue) {
        record.scoresState = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Result_NASB(rpcResponse)"));
    }

    function ListGrid_Cell_failurereason_Update(record, newValue) {
        record.failurereason = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Result_NASB(rpcResponse)"));
    }

    function ListGrid_Cell_score_Update(record, newValue) {
        record.score = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Result_NASB(rpcResponse)"));
    }


    function loadPage_Scores() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_ClassStudent.fetchDataURL = classStudent + "getStudent" + "/" + classRecord.id;
            <%--ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + "<spring:message code='class.checkList.forms'/>" + "&nbsp;<b>" + classRecord.course.titleFa + "&nbsp;<b>" + "<spring:message code='class.code'/>" + "&nbsp;<b>" + classRecord.code});--%>
            ListGrid_ClassStudent.fetchData();
            ListGrid_ClassStudent.invalidateCache();
        } else {
// ListGrid_Scores.setFieldProperties(1, {title: " "});
            ListGrid_ClassStudent.setData([]);
        }

    }