<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    var score_value = null;//بر اساس روش نمره دهی که از 100 یا 20 باشد مقدار 100 یا 20 داخل این متغیر قرار می گیرد
    var classRecord_acceptancelimit = null;
    var scoresState_value = null;
    var score_change = false;
    var failureReason_value = null;
    var failureReason_change = false;
    var scoringMethodPrint = null;
    var acceptancelimitPrint = null;
    var refresh_special = 0;
    var valence_value = null;
    var valence_value_failureReason = null;
    var map = {"1": "ارزشی", "2": "نمره از صد", "3": "نمره از بیست", "4": "بدون نمره"};
    var myMap = new Map(Object.entries(map));
    var map1 = {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"};
    var myMap1 = new Map(Object.entries(map1));

    var RestDataSource_ScoreState_JSPScores = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/317"
    });

    let RestDataSource_FailureReason_JSPScores = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/318"
    });


    RestDataSource_ClassStudent = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "tclass.scoringMethod"},
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

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

            {name: "scoresState.tileFa", title: "<spring:message code="pass.mode"/>", filterOperator: "iContains"},
            {
                name: "failureReason.titleFa",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains"
            },
            {name: "valence", title: "<spring:message code="valence.mode"/>", filterOperator: "iContains"},
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains", canFilter: false}
        ]
    });
    //**********************************************************************************
    //ToolStripButton
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Class_Student.invalidateCache();
        }
    });
    <sec:authorize access="hasAnyAuthority('TclassScoresTab_changeAlltoPassWithOutScore','TclassScoresTab_classStatus')">
    var Button1 = isc.IButton.create({
        disabled: true,
        title: "<spring:message code="change.all.to.pass.with.out.score"/>",
        width: "14%",
        click: function () {
            var record = ListGrid_Class_JspClass.getSelectedRecord();
            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setTotalStudentWithOutScore/" + record.id, "PUT", null, "callback: setTotalStudentWithOutScore(rpcResponse)"));
            ListGrid_Class_Student.invalidateCache()

        }
    })
    </sec:authorize>

    <sec:authorize access="hasAnyAuthority('TclassScoresTab_deleteScoreStateFailureReasonScore','TclassScoresTab_classStatus')">
    var Button2 = isc.IButton.create({
        disabled: true,
        title: "<spring:message code="delete.scoreState.failureReason.score"/>",
        width: "20%",
        click: function () {
            var record = ListGrid_Class_Student.getSelectedRecord();
            if (record == null || record == "undefined") {
                createDialog("info", "<spring:message code="msg.not.selected.record"/>", "<spring:message code="message"/>")
            } else {

                ListGrid_Remove_All_Cell(record)

            }
        }

    })
    </sec:authorize>

    <sec:authorize access="hasAnyAuthority('TclassScoresTab_P','TclassScoresTab_classStatus')">
    var print_score = isc.IButton.create({
        title: "<spring:message code="print"/>",
        width: "14%",
        click: function () {
            printScore();
        }
    })
    </sec:authorize>

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores"
            }),
            <sec:authorize access="hasAnyAuthority('TclassScoresTab_changeAlltoPassWithOutScore','TclassScoresTab_classStatus')">
            Button1,
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassScoresTab_deleteScoreStateFailureReasonScore','TclassScoresTab_classStatus')">
            Button2,
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassScoresTab_P','TclassScoresTab_classStatus')">
            print_score,
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('TclassScoresTab_R','TclassScoresTab_classStatus')">
            isc.ToolStrip.create({
                width: "50%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh
                ]
            })
            </sec:authorize>

        ]
    });
    //**********************************************************************************
    var ListGrid_Class_Student = isc.TrLG.create({
        ID: "ListGrid_Class_Student1",
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,
        canSelectCells: true,
        initialSort: [
            {property: "student.firstName", direction: "descending", primarySort: true}
        ],
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
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },

            {
                name: "scoresStateId",
                title: "<spring:message code="pass.mode"/>",
                filterOperator: "iContains",
                canEdit: false,
                type: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_ScoreState_JSPScores,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    }
                },
                changed: function (form, item, value) {

                    if (classRecord.scoringMethod == "4" && value == 400) {
                        createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی قبول با نمره است <br> شما  نمی توانید وضعیت قبول با نمره را ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student.invalidateCache()
                        return
                    }
                    if (classRecord.scoringMethod == "1" && value == 401) {
                        createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی ارزشی است  <br>  شما  نمی توانید وضعیت قبول بدون نمره را ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student.invalidateCache()
                        return
                    }

                    scoresState_value = value;
                    if (value === 403) {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[5].masterIndex)
                    } else if (value === 400 && !(classRecord.scoringMethod == "1")) {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[7].masterIndex)
                    } else if (value === 400 && classRecord.scoringMethod == "1") {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[6].masterIndex)
                    } else {
                        ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);
                        ListGrid_Class_Student.endEditing();
                        ListGrid_Class_Student.refreshFields()
                    }
                }
            },
            {
                name: "failureReasonId",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains",
                canEdit: false,
                type: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_FailureReason_JSPScores,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    }
                },
                change: function (form, item, value) {
                    failureReason_change = true;

                },
                changed: function (form, item, value) {
                    failureReason_value = value
                    if ((scoresState_value === 403 && value === 453) || (this.grid.getRecord(this.rowNum).scoresStateId === 403 && value === 453) || value === 453) {
                        failureReason_value = null;
                        failureReason_change = false;
                        scoresState_value = null;
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value)
                        return;
                    }
                    if (((value === 407 && scoresState_value === 403) || (value === 407 && this.grid.getRecord(this.rowNum).scoresStateId === 403)) && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {
                        createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی قبول بدون نمره است <br> شما نمی توانید دلایل مردودی را 'غیبت در جلسه امتحان'  ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student.invalidateCache()
                        return
                    }

                    if ((value === 453 || value === 409 || value === 408) && this.grid.getRecord(this.rowNum).scoresStateId === 403 && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {
                        failureReason_value = null;
                        failureReason_change = false;
                        scoresState_value = null;
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                        return
                    }

                    if ((value === 453 || value === 409 || value === 408) && scoresState_value === 403 && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {
                        failureReason_value = null;
                        failureReason_change = false;
                        scoresState_value = null;
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);

                    } else if (classRecord.scoringMethod === "1") {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[6].masterIndex)
                    } else if (value === 409 || value === 408) {
                        failureReason_value = value;
                        scoresState_value = null;
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[7].masterIndex)
                    } else if (value === 407) {
                        failureReason_value = null;
                        failureReason_change = false;
                        scoresState_value = null;
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value)
                        return;
                    }
                    valence_value_failureReason = value
                }
            },
            {
                name: "valence",
                title: "نوع ارزشی",
                showIf: "false",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"},
                changed: function (form, item, value) {
                    valence_value = value;
                    if (failureReason_change == true && (value < classRecord_acceptancelimit)) {

                        if (valence_value_failureReason == 407) {
                            createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی ارزشی است <br>شما نمی توانید دلایل مردودی را غیبت در جلسه امتحان انتخاب کنید", "<spring:message code="message"/>");
                            ListGrid_Class_JspClass.invalidateCache()
                            return
                        }
                        failureReason_change == false
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value, 3);

                    } else if (failureReason_change == true && (value >=classRecord_acceptancelimit))
                    {

                        failureReason_change == false
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value, 4);
                    }
                        else if (scoresState_value == 400 && value>=classRecord_acceptancelimit)
                    {
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value, 5);
                        return
                    }
                    else if (this.grid.getRecord(this.rowNum).scoresStateId != null && this.grid.getRecord(this.rowNum).failureReasonId != null ) {
                        createDialog("info", "کاربر گرامی برای ویرایش , لطفا اطلاعات این رکورد را پاک کنید و دوباره وارد کنید", "<spring:message code="message"/>");
                    }

                },

                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {

                 }
            },

            {
                name: "score",
                ID: "score_id",
                title: "<spring:message code="score"/>",
                filterOperator: "iContains",
                canEdit: true,
                validateOnChange: false,
                editEvent: "click",
                change: function (form, item, value) {

                    if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod == "2") {
                        if (value > 100) {
                            createDialog("info", "نمره باید کمتر از 100 باشد", "<spring:message code="message"/>");
                            item.setValue()
                        } else {
                            score_change = true
                        }
                    } else if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod == "3") {
                        if (value > 20) {
                            createDialog("info", "<spring:message code="msg.less.score"/>", "<spring:message code="message"/>");
                            item.setValue()
                        } else {
                            score_change = true
                        }
                    }
                },

                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid, item) {

                    if (newValue != null) {
                        if (validators_score(newValue)) {
                            if (parseFloat(newValue) >= classRecord_acceptancelimit && parseFloat(newValue) <= score_value) {
                                ListGrid_Cell_score_Update(record, newValue, 1);
                                return;
                            } else if ((parseFloat(newValue) >= 0 && parseFloat(newValue) < classRecord.acceptancelimit)) {
                                if ((typeof record.scoresStateId === "undefined" || typeof record.scoresStateId === undefined) && failureReason_change === false) {
                                    ListGrid_Cell_score_Update(record, newValue, 4)
                                    return
                                } else if (failureReason_change === true) {
                                    failureReason_change = false

                                    ListGrid_Cell_score_Update(record, newValue, 2)
                                    return
                                } else {
                                    failureReason_change = false
                                    ListGrid_Cell_score_Update(record, newValue, 3)
                                    return
                                }
                            }
                        } else {
                            createDialog("info", "<spring:message code="enter.current.score"/>", "<spring:message code="message"/>");
                            return;
                        }
                    } else if ((typeof newValue === "undefined") && failureReason_change === true && record.scoresStateId === 403) {
                        refresh_special = 1;
                        ListGrid_Cell_score_Update(record, newValue, 5)
                        return
                    } else {
                        return true
                    }
                }
            }

        ],

        dataArrived: function () {
            var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            if (myMap.get(classRecord.scoringMethod) === "ارزشی") {
                totalsLabel_scores.setContents("<spring:message
        code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message
        code="acceptance.limit"/>" + ":&nbsp;<b>" + myMap1.get(classRecord.acceptancelimit) + "</b>");
                scoringMethodPrint = myMap.get(classRecord.scoringMethod);
                acceptancelimitPrint = myMap1.get(classRecord.acceptancelimit);
            } else if (myMap.get(classRecord.scoringMethod) === "نمره از صد" || myMap.get(classRecord.scoringMethod) === "نمره از بیست") {
                totalsLabel_scores.setContents("<spring:message
        code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message
        code="acceptance.limit"/>" + ":&nbsp;<b>" + (classRecord.acceptancelimit) + "</b>");
                scoringMethodPrint = myMap.get(classRecord.scoringMethod);
                acceptancelimitPrint = classRecord.acceptancelimit
            } else {

                totalsLabel_scores.setContents("<spring:message
        code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message
        code="acceptance.limit"/>" + ":&nbsp;<b>" + "ندارد" + "</b>");
                scoringMethodPrint = myMap.get(classRecord.scoringMethod);
                acceptancelimitPrint = "ندارد";
            }
        },
        gridComponents: [ToolStrip_Actions, "filterEditor", "header", "body"],

        canEditCell: function (rowNum, colNum) {
            var record = this.getRecord(rowNum);
            var fieldName = this.getFieldName(colNum);

            // if (fieldName === "scoresStateId") {
            //     return !(classRecord.scoringMethod == "1")
            // }

            if (fieldName === "valence") {
                let arr = [448, 410, 405, 449, 406, 404, 401, 450]
                return !(classRecord.scoringMethod == "2" || classRecord.scoringMethod == "3" || classRecord.scoringMethod == "4" || arr.includes(record.scoresStateId) || (record.scoresStateId === 403 && record.failureReasonId === 453))
            }

            if (fieldName === "score") {
                if (scoresState_value === 403 || scoresState_value === 400) {
                    return true
                }
                if (failureReason_value != null && record.scoresStateId == 403) {
                    return true
                } else if (classRecord.scoringMethod == "1" || classRecord.scoringMethod == "4") {
                    return false
                }
                let arr = [448, 410, 405, 449, 406, 404, 401, 450]
                return !((record.scoresStateId === 403 && record.failureReasonId === 407) || (record.scoresStateId === 403 && record.failureReasonId === 453) || arr.includes(record.scoresStateId))
            }

            if (fieldName === "failureReasonId") {
                // if (scoresState_value === 403)
                // return true
                let arr = [448, 410, 405, 449, 406, 404, 401, 450]
                return !(arr.includes(record.scoresStateId))
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
    });

    function ListGrid_Cell_scoresState_Update(record, newValue) {
        record.scoresStateId = newValue;
        record.failureReasonId = null;
        record.score = null
        record.valence = null
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_scoresState_Update(rpcResponse)"));

    }

    function ListGrid_Cell_failurereason_Update(record, newValue) {
        record.failureReasonId = newValue;
        record.scoresStateId = 403;
        record.score = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_failurereason_Update(rpcResponse)"));
    }

    function ListGrid_Cell_score_Update(record, newValue, a) {
        record.score = newValue;
        if (a == 1) {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        } else if (a == 2) {
            record.scoresStateId = 403;
            record.failureReasonId = failureReason_value;
        } else if (a == 3) {
            record.scoresStateId = 403;
            record.failureReasonId = record.failureReasonId;
        } else if (a == 4) {
            record.scoresStateId = 403;
            record.failureReasonId = 409;

        } else if (a == 5) {
            record.failureReasonId = failureReason_value
        }
        scoresState_value = null;
        failureReason_value = null;
        failureReason_change = false;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update(rpcResponse)"));


    }

    function ListGrid_Cell_valence_Update(record, newValue, a) {
        record.valence = newValue;
        if (a == 1) {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        }
        if (a == 2) {
            record.scoresStateId = 403;
            record.failureReasonId = 409;
        }
        if (a == 3) {
            record.scoresStateId = 403;
            record.failureReasonId = valence_value_failureReason;
        }
        if(a == 4)
        {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        }
        if(a == 5)
        {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        }
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_valence_Update(rpcResponse)"));
    }

    function ListGrid_Remove_All_Cell(record) {
        record.scoresStateId = null;
        record.failureReasonId = null;
        record.score = null;
        record.valence = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback:Remove_All_Cell_Action(rpcResponse)"));

    }

    function Remove_All_Cell_Action(rpcResponse) {
        ListGrid_Class_Student.refreshFields();
        ListGrid_Class_Student.refreshCell;
        ListGrid_Class_Student.dataChanged()

    }

    function Edit_Cell_scoresState_Update(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            ListGrid_Class_Student.endEditing();
            ListGrid_Class_Student.refreshFields();
            ListGrid_Class_Student.refreshCell;
            ListGrid_Class_Student.dataChanged()
        } else {
            createDialog("info", "کاربر گرامی بدلیل عدم اتصال به سرور<br> لطفا نمرات این فراگیر را دوباره وارد کنید", "<spring:message code="message"/>");
            ListGrid_Class_Student.fetchData()
            ListGrid_Class_Student.invalidateCache()
            return;
        }
    }

    function Edit_Cell_valence_Update(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_Class_Student.endEditing();
            ListGrid_Class_Student.refreshFields();
            ListGrid_Class_Student.refreshCell;
            ListGrid_Class_Student.dataChanged()
        } else {
            createDialog("info", "کاربر گرامی بدلیل عدم اتصال به سرور<br> لطفا نمرات این فراگیر را دوباره وارد کنید", "<spring:message code="message"/>");
            ListGrid_Class_Student.fetchData()
            ListGrid_Class_Student.invalidateCache()
            return;
        }

    }

    function setTotalStudentWithOutScore(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_Class_Student.invalidateCache()
        }
    }


    function Edit_Cell_failurereason_Update(resp) {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_Class_Student.endEditing();
            ListGrid_Class_Student.dataChanged()
        } else {
            createDialog("info", "کاربر گرامی بدلیل عدم اتصال به سرور<br> لطفا نمرات این فراگیر را دوباره وارد کنید", "<spring:message code="message"/>");
            ListGrid_Class_Student.fetchData()
            ListGrid_Class_Student.invalidateCache()
            return;
        }
    }

    function Edit_Cell_score_Update(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            // isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateLearningEvaluation" + "/" + ListGrid_Class_JspClass.getSelectedRecord().id +
            //     "/" + ListGrid_Class_JspClass.getSelectedRecord().scoringMethod,
            //     "GET", null, null));
            ListGrid_Class_Student.endEditing()
            ListGrid_Class_Student.refreshFields()
            ListGrid_Class_Student.redraw()
            ListGrid_Class_Student.dataChanged()
            ListGrid_Class_Student.refreshFields()
            ListGrid_Class_Student.refreshCell()
            ListGrid_Class_Student.redraw()
            if (refresh_special == 1) {
                ListGrid_Class_Student.fetchData()
                ListGrid_Class_Student.invalidateCache()
                refresh_special = 0
                return
            }

        } else {
            createDialog("info", "کاربر گرامی بدلیل عدم اتصال به سرور<br> لطفا نمرات این فراگیر را دوباره وارد کنید", "<spring:message code="message"/>");
            ListGrid_Class_Student.fetchData()
            ListGrid_Class_Student.invalidateCache()
            return;
        }
    }

    function validators_score(value) {

        if (score_value == 20) {
            if (value.match(/^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/)) {
                return true
            } else {
                return false
            }
        } else if (score_value == 100) {
            if (value.match(/^(100|[1-9]?\d)$/)) {
                return true
            } else {
                return false
            }
        }
    }


    function printScore() {
        var Record = ListGrid_Class_JspClass.getSelectedRecord();
        var classObj = {
            code: Record.code,
            teacher: Record.teacher,
            course: Record.course.titleFa,
            endDate: Record.endDate,
            startDate: Record.startDate,
            scoringMethod: scoringMethodPrint,
            acceptancelimit: acceptancelimitPrint
        };

        var advancedCriteria = ListGrid_Class_Student.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/score/print"/>",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "classId", type: "hidden"},
                    {name: "token", type: "hidden"},
                    {name: "class", type: "hidden"},
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("class", JSON.stringify(classObj));
        criteriaForm.setValue("classId", JSON.stringify(Record.id));
        criteriaForm.setValue("token", "<%= accessToken %>");
        criteriaForm.show();
        criteriaForm.submitForm();
    }


    function loadPage_Scores() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        classRecord_acceptancelimit = parseFloat(classRecord.acceptancelimit);
        if (typeof classRecord.scoringMethod === 'undefined' || classRecord.scoringMethod == undefined) {
            createDialog("info", "کاربر گرامی توجه کنید که روش نمره دهی برای این کلاس نامشخص (undefined)است  لطفا فبل از ثبت نمرات روش نمره دهی را مشخص کنید", "<spring:message code="message"/>")
        }
        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_ClassStudent.fetchDataURL = tclassStudentUrl + "/scores-iscList/" + classRecord.id;
            if (classRecord.scoringMethod == "1") {
                ListGrid_Class_Student.showField('valence');
                ListGrid_Class_Student.hideField('score');
                Button1.setDisabled(true);
                Button2.setDisabled(false);
            } else if (classRecord.scoringMethod == "3") {
                score_value = 20;
                ListGrid_Class_Student.hideField('valence');
                ListGrid_Class_Student.showField('score');
                Button1.setDisabled(true);
                Button2.setDisabled(false);
            } else if (classRecord.scoringMethod == "2") {
                score_value = 100;
                ListGrid_Class_Student.hideField('valence');
                ListGrid_Class_Student.showField('score');
                Button1.setDisabled(true);
                Button2.setDisabled(false);
            } else if (classRecord.scoringMethod == "4") {
                ListGrid_Class_Student.hideField('score');
                ListGrid_Class_Student.hideField('valence');
                Button1.setDisabled(false);
                Button2.setDisabled(true);
            }

            if (classRecord.classStatus === "3") {
                <sec:authorize access="hasAnyAuthority('TclassScoresTab_R','TclassScoresTab_P','TclassScoresTab_deleteScoreStateFailureReasonScore','TclassScoresTab_changeAlltoPassWithOutScore')">
                ToolStrip_Actions.setVisibility(false)
                </sec:authorize>
            } else {
                <sec:authorize access="hasAnyAuthority('TclassScoresTab_R','TclassScoresTab_P','TclassScoresTab_deleteScoreStateFailureReasonScore','TclassScoresTab_changeAlltoPassWithOutScore')">
                ToolStrip_Actions.setVisibility(true)
                </sec:authorize>
            }

            if (classRecord.classStatus === "3") {
                <sec:authorize access="hasAuthority('TclassScoresTab_classStatus')">
                ToolStrip_Actions.setVisibility(true)
                </sec:authorize>
            }

            ListGrid_Class_Student.invalidateCache();
            ListGrid_Class_Student.fetchData();
        } else {
            ListGrid_Class_Student.setData([]);
        }

    }
