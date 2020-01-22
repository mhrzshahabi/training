<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>
    // 1->قبول با نمره

    var Row_Numbers = null
    var flag1 = null
    var value_failurereason = null
    var score_value = null //بر اساس روش نمره دهی که از 100 یا 20 باشد مقدار 100 یا 20 داخل این متغیر قرار می گیرد
    var classRecord_acceptancelimit = null
    var scoresState_value = null
    var failureReason_value = null
    var map = {"1": "ارزشی", "2": "نمره از صد", "3": "نمره از بیست", "4": "بدون نمره"}
    var myMap = new Map(Object.entries(map));
    var map1 = {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"}
    var myMap1 = new Map(Object.entries(map1));
    RestDataSource_ClassStudent = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
// {name: "companyName", title: "<spring:message
        code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
// {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "scoresState", title: "<spring:message code="pass.mode"/>", filterOperator: "iContains"},
            {name: "failureReason", title: "<spring:message code="faild.reason"/>", filterOperator: "iContains"},
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains"},
            {name: "valence", title: "روش ارزشی", filterOperator: "iContains"},

        ],

    });

    //**********************************************************************************
    //ToolStripButton

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Class_Student.invalidateCache();
        }
    });
    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [

            isc.Label.create({
                ID: "totalsLabel_scores"
            }),

            isc.LayoutSpacer.create({
                width: "*"
            }),
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
    //**********************************************************************************
    var ListGrid_Class_Student = isc.TrLG.create({
        selectionType: "single",
        editOnFocus: true,
//------------
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,

//------
        canSelectCells: true,
        sortField: 0,
        dataSource: RestDataSource_ClassStudent,
        fields: [
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
// {name: "companyName", title: "<spring:message
        code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
// {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},


            {
                name: "scoresState",
                title: "<spring:message code="pass.mode"/>",
                filterOperator: "iContains",
                canEdit: false,
                editorType: "SelectItem",
                valueMap: ["قبول با نمره", "قبول بدون نمره", "مردود"],
                changed: function (form, item, value) {
                    scoresState_value = value
                    if (value === "مردود") {
                        this.grid.startEditing(this.rowNum, this.colNum + 1)
                    } else if (value === "قبول با نمره") {
                        this.grid.startEditing(this.rowNum, this.colNum + 2)
                    }

                },
            },
            {
                name: "failureReason",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains",
                canEdit: false,
                editorType: "SelectItem",
                valueMap: ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"],
                changed: function (form, item, value) {
                    if (value === "غیبت در جلسه امتحان") {
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    } else {
                        failureReason_value = value
                        this.grid.startEditing(this.rowNum, this.colNum + 1)

                    }

                },

            },

            {
                name: "score",
                title: "<spring:message code="score"/>",
                filterOperator: "iContains",
                canEdit: true,
                validateOnChange: false,
                editEvent: "click",
                change: function (form, item, value) {

                    if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod == "2") {
                        if (value > 100) {
                            createDialog("info", "نمره باید کمتر از 100 باشد", "<spring:message code="message"/>")
                            item.setValue()
                        }
                    } else if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod == "3") {
                        if (value > 20) {
                            createDialog("info", "<spring:message code="msg.less.score"/>", "<spring:message code="message"/>")
                            item.setValue()
                        }
                    }


                },

                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {

                    if ((record.scoresState == "مردود" || record.scoresState == "قبول با نمره") && (newValue !== null || newValue != null)) {

                    } else if ((record.scoresState == "مردود" || record.scoresState == "قبول با نمره") && (newValue == null)) {
                        createDialog("info", "لطفا نمره را وارد کنید", "<spring:message code="message"/>")
                        return false;
                    }

                    if (newValue != null) {
                        if (validators_score(newValue)) {

                            if (parseFloat(newValue) >= classRecord_acceptancelimit && parseFloat(newValue) <= score_value) {

                                ListGrid_Cell_score_Update(record, newValue, 1);
                                ListGrid_Class_Student.refreshFields();
                            } else if ((parseFloat(newValue) >= 0 && parseFloat(newValue) < classRecord.acceptancelimit)) {

                                if (record.scoresState == "مردود" && (record.failureReason == "عدم کسب حد نصاب نمره" || record.failureReason == "غیبت بیش از حد مجاز") && failureReason_value == null) {
                                    ListGrid_Cell_score_Update(record, newValue, 0);
                                    ListGrid_Class_Student.refreshFields();
                                } else if (scoresState_value == "مردود" && failureReason_value != null) {
                                    ListGrid_Cell_score_Update(record, newValue, 3);
                                    ListGrid_Class_Student.refreshFields();
                                } else if (failureReason_value != null && record.scoresState == "مردود") {
                                    ListGrid_Cell_score_Update(record, newValue, 4);
                                } else {

                                    createDialog("info", "لطفا وضعیت قبولی را مردود و همچنین دلیل مردودی راانتخاب کنید", "<spring:message code="message"/>")
                                    ListGrid_Cell_score_Update(record, null, 2);
                                    ListGrid_Class_Student.refreshFields();
                                }

                            } else if ((record.scoresState == "مردود" || record.scoresState == "قبول با نمره") && (newValue !== null || newValue != null) && (editCompletionEvent == "enter" || editCompletionEvent == "click_outside")) {

                            } else if (newValue === null && record.scoresState === undefined || record.scoresState == null || record.scoresState === "undefined" && record.failureReason === null) {

                                ListGrid_Class_Student.invalidateCache();
                                ListGrid_Class_Student.refreshFields();
                            }
                            ListGrid_Class_Student.refreshFields();

                        } else {
                            createDialog("info", "لطفا نمره راصحیح وارد کنید", "<spring:message code="message"/>")
                            return false;
                        }


                    }
                    else {
                               ListGrid_Class_Student.invalidateCache();
                               ListGrid_Class_Student.refreshFields();
                        }
                },// end editor Exit


            },
            {
                name: "valence",
                title: "نوع ارزشی",
                showIf: "false",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: ["ضعیف", "متوسط", "خوب", "خیلی خوب"],
            }
        ],

        dataArrived: function () {
            var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            return (myMap.get(classRecord.scoringMethod) === "ارزشی") ? totalsLabel_scores.setContents("روش نمره دهی" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "حد قبولی" + ":&nbsp;<b>" + myMap1.get(classRecord.acceptancelimit) + "</b>") : totalsLabel_scores.setContents("روش نمره دهی" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "حد قبولی" + ":&nbsp;<b>" + (classRecord.acceptancelimit) + "</b>");
        },
        gridComponents: [ToolStrip_Actions, "filterEditor", "header", "body"],

        canEditCell: function (rowNum, colNum) {
            var record = this.getRecord(rowNum);
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "failureReason") {
// return !(scoresState_value == null)
// return !(record.scoresState === "مردود" && record.failureReason === "غیبت در جلسه امتحان")
            }

            if (fieldName === "score") {
                if (failureReason_value != null && record.scoresState == "مردود") {
                    return true
                }
                return !(record.scoresState === "مردود" && record.failureReason === "غیبت در جلسه امتحان")
            }

            if (fieldName === "student.firstName" || fieldName === "student.lastName" || fieldName === "student.nationalCode" || fieldName === "student.personnelNo") {
                return false
            }
            return true;
        }
    });


    var vlayout = isc.VLayout.create({
        width: "100%",
        members: [ListGrid_Class_Student]
    })

    function ListGrid_Cell_scoresState_Update(record, newValue) {
        record.scoresState = newValue
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_scoresState_Update(rpcResponse)"));
    }

    function ListGrid_Cell_failurereason_Update(record, newValue) {
        record.failureReason = newValue
        record.scoresState = "مردود"
        record.score = null
        scoresState_value = null
        failureReason_value = null
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_failurereason_Update(rpcResponse)"));
        ListGrid_Class_Student.refreshFields();
    }

    function ListGrid_Cell_score_Update(record, newValue, a) {
        record.score = newValue
        if (a == 1) {
            record.scoresState = "قبول با نمره"
            record.failureReason = null
        } else if (a == 2) {
            record.scoresState = null
            record.failureReason = null
        } else if (a == 3) {
            record.scoresState = "مردود"
            record.failureReason = failureReason_value
            record.score = newValue
        } else if (a == 4) {
            record.failureReason = failureReason_value
        }
        scoresState_value = null
        failureReason_value = null
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update(rpcResponse)"));
        ListGrid_Class_Student.refreshFields();
    }


    function Edit_Cell_scoresState_Update(resp) {

    };


    function Edit_Cell_failurereason_Update(resp) {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            ListGrid_Class_Student.refreshFields();
        }

    };

    function Edit_Cell_score_Update(resp) {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            ListGrid_Class_Student.refreshFields();
        }
    };

    function validators_score(value) {

         if(score_value ==20)
             {
                 if (value.match(/^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/))
                       {
                            return true
                       }
                          else
                       {
                           return false
                       }
             }
             else if (score_value == 100)
                {
                 if (value.match(/^(100|[1-9]?\d)$/))
                       {
                            return true
                       }
                          else
                       {
                           return false
                       }

                }
    }

    function loadPage_Scores() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        classRecord_acceptancelimit = parseFloat(classRecord.acceptancelimit)
        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_ClassStudent.fetchDataURL = tclassStudentUrl + "/scores-iscList/" + classRecord.id
//===========================================
            if (classRecord.scoringMethod == "1") {
                ListGrid_Class_Student.showField('valence')
                ListGrid_Class_Student.hideField('score')
                ListGrid_Class_Student.getField("scoresState").valueMap = ["مردود", "قبول"]
            } else if (classRecord.scoringMethod == "3") {
                score_value = 20;
                ListGrid_Class_Student.hideField('valence')
                ListGrid_Class_Student.showField('score')
            } else if (classRecord.scoringMethod == "2") {
                score_value = 100;
                ListGrid_Class_Student.hideField('valence')
                ListGrid_Class_Student.showField('score')
               ListGrid_Class_Student.getField("scoresState").valueMap = ["قبول با نمره", "مردود"]
            }
//=================================================
            ListGrid_Class_Student.invalidateCache()
            ListGrid_Class_Student.fetchData()
        } else {
            ListGrid_Class_Student.setData([]);
        }
    }

