<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    //------------------------------------------- Variables

    var score_value_Eval = null;//بر اساس روش نمره دهی که از 100 یا 20 باشد مقدار 100 یا 20 داخل این متغیر قرار می گیرد
    var classRecord_acceptancelimit_Eval = null;
    var scoresState_value_Eval = null;
    var score_change_Eval = false;
    var failureReason_value_Eval = null;
    var failureReason_change_Eval = false;
    var scoringMethodPrint_Eval = null;
    var acceptancelimitPrint_Eval = null;
    var refresh_special = 0;
    var valence_value_Eval = null;
    var score_windows_dynamicForm_value_Eval = null;
    var valence_value_failureReason_Eval = null;
    var map_Eval = {"1": "ارزشی", "2": "نمره از صد", "3": "نمره از بیست", "4": "بدون نمره"};
    var myMap_Eval = new Map(Object.entries(map_Eval));
    var map1_Eval = {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"};
    var myMap1_Eval = new Map(Object.entries(map1_Eval));


    var classId_Eval = null;
    var classCode_Eval = null;
    var classStatus_Eval = null;
    var classScoringMethod_Eval = null;
    var classAcceptanceLimit_Eval = null;

    let isScoreDependent_Eval = true;

    //----------------------------------------------------Default Rest--------------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "scoreDependsOnEvaluation", "GET", null, function (resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            isScoreDependent_Eval = JSON.parse(resp.data);
        }
    }));
    //------------------------------------------------------------------------------------------------------------------

    //------------------------------------------- DataSource

    RestDataSource_ScoreState_JSPScores_Eval = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/317"
    });
    RestDataSource_FailureReason_JSPScores_Eval = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/318"
    });
    RestDataSource_ClassStudent_Eval = isc.TrDS.create({
        fields: [
            {name: "id", hidden: false},
            {name: "save", hidden: true},
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
                name: "evaluationStatusReaction",
                hidden:true
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

    //------------------------------------------- Layout

    ToolStripButton_Refresh_Eval = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Class_Student_Eval.invalidateCache();
        }
    });

    Button1_Eval = isc.IButton.create({
        disabled: true,
        title: "<spring:message code="change.all.to.pass.with.out.score"/>",
        width: "14%",
        click: function () {
            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setTotalStudentWithOutScore/" + classId_Eval, "PUT", null, "callback: setTotalStudentWithOutScore_Eval(rpcResponse)"));
            ListGrid_Class_Student_Eval.invalidateCache()
        }
    });
    Button3_Eval = isc.IButton.create({
        disabled: true,
        title: "مردود/غیبت غیر مجاز",
        width: "14%",
        click: function () {
            let rec = ListGrid_Class_Student_Eval.getSelectedRecord();
            if (rec == null || rec == "undefined") {
                createDialog("info", "<spring:message code="msg.not.selected.record"/>", "<spring:message code="message"/>")
            } else {
                var score_windows_Eval = isc.Window.create({
                    title: "ورود نمره",
                    autoSize: true,
                    width: 400,
                    // height:200,
                    items: [
                        isc.DynamicForm.create({
                            ID: "score_windows_dynamicForm_Eval",
                            numCols: 1,
                            padding: 10,
                            fields: [
                                {
                                    name: "cause",
                                    width: "100%",
                                    type: 'text',
                                    required: true,
                                    titleOrientation: "top",
                                    title: "لطفاً نمره  را در کادر زیر وارد کنید:",
                                    suppressBrowserClearIcon: true,
                                    iconWidth: 16,
                                    iconHeight: 16,
                                    change(form, item, value) {

                                        if (ListGrid_Class_Student_Eval.getSelectedRecord().scoringMethod == "2") {
                                            if (value > 100) {
                                                createDialog("info", "نمره باید کمتر از 100 باشد", "<spring:message code="message"/>");
                                                item.setValue()
                                            }
                                        } else if (ListGrid_Class_Student_Eval.getSelectedRecord().scoringMethod == "3") {
                                            if (value > 20) {
                                                createDialog("info", "<spring:message code="msg.less.score"/>", "<spring:message code="message"/>");
                                                item.setValue()
                                            }
                                        }
                                        score_windows_dynamicForm_value_Eval = value
                                    }

                                }
                            ]
                        }),
                        isc.TrHLayoutButtons.create({
                            members: [
                                isc.IButton.create({
                                    title: "تایید",
                                    click: function () {
                                        if(isScoreDependent_Eval) {

                                            if (!(rec.evaluationStatusReaction === null || rec.evaluationStatusReaction===1 || rec.evaluationStatusReaction===0)) {

                                                if (!score_windows_dynamicForm_Eval.validate()) {return;}
                                                if (validators_score_Eval(score_windows_dynamicForm_value_Eval)) {
                                                    rec.scoresStateId = 403;
                                                    rec.failureReasonId = 408;
                                                    rec.score = score_windows_dynamicForm_Eval.getItem("cause").getValue();
                                                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + rec.id, "PUT", JSON.stringify(rec), "callback: Edit_Cell_ScoreState_failureReason_Update_Eval(rpcResponse)"));
                                                    score_windows_Eval.close();
                                                } else {
                                                    simpleDialog("<spring:message code="message"/>", "گاربر گرامی نمره وارد شده صحیح نمی باشد", 6000, "stop");
                                                    score_windows_dynamicForm_Eval.getItem("cause").setValue();
                                                }

                                            } else {
                                                createDialog("info", "ارزیابی واکنشی دانشجوی مورد نظر ثبت نشده است");
                                            }
                                        } else {

                                            if (!score_windows_dynamicForm_Eval.validate()) {return;}
                                            if (validators_score_Eval(score_windows_dynamicForm_value_Eval)) {
                                                rec.scoresStateId = 403;
                                                rec.failureReasonId = 408;
                                                rec.score = score_windows_dynamicForm_Eval.getItem("cause").getValue();
                                                isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + rec.id, "PUT", JSON.stringify(rec), "callback: Edit_Cell_ScoreState_failureReason_Update_Eval(rpcResponse)"));
                                                score_windows_Eval.close();
                                            } else {
                                                simpleDialog("<spring:message code="message"/>", "گاربر گرامی نمره وارد شده صحیح نمی باشد", 6000, "stop");
                                                score_windows_dynamicForm_Eval.getItem("cause").setValue();
                                            }
                                        }
                                    }
                                }),
                                isc.IButton.create({
                                    title: "لغو",
                                    click: function () {
                                        score_windows_Eval.close();
                                    }
                                }),
                            ]
                        })
                    ]
                });
                score_windows_Eval.show();
            }

        }
    });
    Button2_Eval = isc.IButton.create({
        disabled: true,
        title: "<spring:message code="delete.scoreState.failureReason.score"/>",
        width: "20%",
        click: function () {
            var record = ListGrid_Class_Student_Eval.getSelectedRecord();
            if (record == null || record == "undefined") {
                createDialog("info", "<spring:message code="msg.not.selected.record"/>", "<spring:message code="message"/>");
            } else {
                failureReason_change_Eval = false;
                ListGrid_Remove_All_Cell_Eval(record);
            }
        }

    });
    print_score_Eval = isc.IButton.create({
        title: "<spring:message code="print"/>",
        width: "14%",
        click: function () {
            printScore_Eval();
        }
    });

    ToolStrip_Actions_Eval = isc.ToolStrip.create({
        width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores_Eval"
            }),
            <sec:authorize access="hasAuthority('Evaluation_Scores_Actions')">
            Button1_Eval,
            Button2_Eval,
            Button3_Eval,
            print_score_Eval,
            isc.ToolStripButtonExcel.create({
                click: function () {
                    if (classId_Eval !== null)
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_Class_Student_Eval, tclassStudentUrl + "/scores-iscList/" + classId_Eval, 0, ListGrid_class_Evaluation, '', "ارزیابی - ثبت نمرات", ListGrid_Class_Student_Eval.getCriteria(), null);
                }
            }),
            isc.Label.create({
                ID: "alarmFor_reaction_evaluation_e"
            }),
            </sec:authorize>
            isc.ToolStrip.create({
                width: "50%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Evaluation_Scores_R')">
                    ToolStripButton_Refresh_Eval
                    </sec:authorize>
                ]
            })
        ]
    });

    ListGrid_Class_Student_Eval = isc.TrLG.create({
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,
        canSelectCells: true,
        <sec:authorize access="hasAuthority('Evaluation_Scores_R')">
        dataSource: RestDataSource_ClassStudent_Eval,
        </sec:authorize>
        fields: [
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
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
                name: "evaluationStatusReaction",
                hidden:true
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
                canSort: false,
                type: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_ScoreState_JSPScores_Eval,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    }
                },
                changed: function (form, item, value) {

                    if (classScoringMethod_Eval == "4" && value == 400) {
                        createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی قبول با نمره است <br> شما  نمی توانید وضعیت قبول با نمره را ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student_Eval.invalidateCache();
                        return;
                    }
                    if (classScoringMethod_Eval == "1" && value == 401) {
                        createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی ارزشی است  <br>  شما  نمی توانید وضعیت قبول بدون نمره را ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student_Eval.invalidateCache();
                        return;
                    }

                     if( value === 401 && ListGrid_class_Evaluation.getSelectedRecord().evaluation ==2 ) {
                        createDialog("info", "کاربر گرامی بدلیل اینکه ارزیابی دوره یادگیری است  <br>  شما  نمی توانید وضعیت قبول بدون نمره را ثبت کنید", "<spring:message code="message"/>");
                        ListGrid_Class_Student_Eval.invalidateCache();
                    }

                    scoresState_value_Eval = value;
                    if (value === 403) {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student_Eval.completeFields[5].masterIndex);
                    } else if (value === 400 && !(classScoringMethod_Eval == "1")) {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student_Eval.completeFields[7].masterIndex);
                    } else if (value === 400 && classScoringMethod_Eval == "1") {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student_Eval.completeFields[6].masterIndex);
                    } else {
                        ListGrid_Cell_scoresState_Update_Eval(this.grid.getRecord(this.rowNum), value);
                    }
                }
            },
            {
                name: "failureReasonId",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains",
                canEdit: false,
                canSort: false,
                type: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_FailureReason_JSPScores_Eval,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    }
                },
                change: function (form, item, value) {
                    failureReason_change_Eval = true;
                },
                changed: function (form, item, value) {
                    failureReason_value_Eval = value;

                    if (isScoreDependent_Eval) {

                        if (ListGrid_class_Evaluation.getSelectedRecord().evaluation == 1) {

                            if (ListGrid_Class_Student_Eval.getSelectedRecord().evaluationStatusReaction === undefined
                                || ListGrid_Class_Student_Eval.getSelectedRecord().evaluationStatusReaction === null
                                || ListGrid_Class_Student_Eval.getSelectedRecord().evaluationStatusReaction === 1
                                || ListGrid_Class_Student_Eval.getSelectedRecord().evaluationStatusReaction === 0) {
                                if (value !== 796) {
                                    ListGrid_Class_Student_Eval.getSelectedRecord().failureReasonId = null;
                                    ListGrid_Class_Student_Eval.invalidateCache();
                                    createDialog("info", "کاربر گرامی با توجه به اینکه نمره وابسته به ارزیابی است </br>و ارزیابی واکنشی جواب داده نشده فقط وضعیت مردود </br>به علت عدم پر کردن ارزیابی واکنشی قابل انتخاب است ", "توجه!");
                                    return;
                                } else {
                                    return;
                                }
                            }
                        }
                    }

                    if ((scoresState_value_Eval === 403 && value === 453) || (this.grid.getRecord(this.rowNum).scoresStateId === 403 && value === 453) || value === 453) {
                        failureReason_value_Eval = null;
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_failurereason_Update_Eval(this.grid.getRecord(this.rowNum), value);
                        return;
                    }

                    if ((scoresState_value_Eval === 403 && value === 407) || (this.grid.getRecord(this.rowNum).scoresStateId === 403 && value === 407) || value === 407) {
                        failureReason_value_Eval = null;
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_failurereason_Update_Eval(this.grid.getRecord(this.rowNum), value);
                        return;
                    }

                    if ((value === 453 || value === 409 || value === 408 || value === 407) && this.grid.getRecord(this.rowNum).scoresStateId === 403 && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {

                        failureReason_value_Eval = null;
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_failurereason_Update_Eval(this.grid.getRecord(this.rowNum), value);
                        return
                    }

                    if ((value === 453 || value === 409 || value === 408 || value === 407) && scoresState_value_Eval === 403 && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {

                        failureReason_value_Eval = null;
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_failurereason_Update_Eval(this.grid.getRecord(this.rowNum), value);
                        return
                    } else if (classScoringMethod_Eval === "1") {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student_Eval.completeFields[6].masterIndex)
                    } else if (value === 409 || value === 408) {
                        failureReason_value_Eval = value;
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student_Eval.completeFields[7].masterIndex)
                    } else if (value === 407) {
                        failureReason_value_Eval = null;
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_failurereason_Update_Eval(this.grid.getRecord(this.rowNum), value);
                        return;
                    }

                    valence_value_failureReason_Eval = value
                }
            },
            {
                name: "valence",
                title: "نوع ارزشی",
                showIf: "false",
                filterOperator: "iContains",
                <sec:authorize access="hasAuthority('Evaluation_Scores_Actions')">
                canEdit: true,
                </sec:authorize>
                canSort: false,
                editorType: "SelectItem",
                valueMap: {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"},
                changed: function (form, item, value) {
                    valence_value_Eval = value;
                    if (failureReason_change_Eval == true && (value < classRecord_acceptancelimit_Eval)) {

                        if (valence_value_failureReason_Eval == 407) {
                            createDialog("info", "کاربر گرامی بدلیل اینکه روش نمره دهی ارزشی است <br>شما نمی توانید دلایل مردودی را غیبت در جلسه امتحان انتخاب کنید", "<spring:message code="message"/>");
                            failureReason_value_Eval = null;
                            failureReason_change_Eval = false;
                            scoresState_value_Eval = null;
                            valence_value_Eval = null;
                            valence_value_failureReason_Eval = null;
                            ListGrid_class_Evaluation.invalidateCache();
                            return;
                        }
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 3);

                    } else if (failureReason_change_Eval == true && (value >= classRecord_acceptancelimit_Eval)) {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 4);
                        return;
                    }
                    else if (scoresState_value_Eval == 400 && value >= classRecord_acceptancelimit_Eval) {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        failureReason_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 5);
                        return;
                    }
                    else if (value >= classRecord_acceptancelimit_Eval) {
                        failureReason_change_Eval = false;
                        failureReason_value_Eval = null;
                        scoresState_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 4);
                        return;
                    }
                    else if (value < classRecord_acceptancelimit_Eval) {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        failureReason_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 2);
                        return;
                    }
                    else if (this.grid.getRecord(this.rowNum).scoresStateId == 403 && (this.grid.getRecord(this.rowNum).failureReasonId == 409 || this.grid.getRecord(this.rowNum).failureReasonId == 408) && value < classRecord_acceptancelimit_Eval && typeof this.grid.getRecord(this.rowNum).valence != "undefined") {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        failureReason_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 6);
                        return;
                    }

                    else if (this.grid.getRecord(this.rowNum).scoresStateId != null && this.grid.getRecord(this.rowNum).failureReasonId != null) {
                        createDialog("info", "کاربر گرامی برای ویرایش , لطفا اطلاعات این رکورد را پاک کنید و دوباره وارد کنید", "<spring:message code="message"/>");
                    }

                },
                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {

                    if (failureReason_change_Eval == true && record.valence < classRecord_acceptancelimit_Eval && typeof record.valence != "undefined" && record.valence != null) {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        valence_value_Eval = null;
                        failureReason_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(record, record.valence, 3);
                        return;
                    }
                    if (failureReason_change_Eval == true && valence_value_Eval > classRecord_acceptancelimit_Eval && typeof record.valence != "undefined") {
                        failureReason_change_Eval = false;
                        scoresState_value_Eval = null;
                        valence_value_Eval = null;
                        failureReason_value_Eval = null;
                        ListGrid_Cell_valence_Update_Eval(this.grid.getRecord(this.rowNum), value, 4);
                        return;
                    }
                }

            },
            {
                name: "score",
                title: "<spring:message code="score"/>",
                filterOperator: "iContains",
                <sec:authorize access="hasAuthority('Evaluation_Scores_Actions')">
                canEdit: true,
                </sec:authorize>
                // canEdit: record.evaluationStatusReaction===1,
                canSort: false,
                validateOnChange: false,
                editEvent: "click",
                showHover: true,
                hoverHTML(record) {
                    if (ListGrid_class_Evaluation.getSelectedRecord().evaluation == 1) {

                        if (record.evaluationStatusReaction === undefined || record.evaluationStatusReaction === null || record.evaluationStatusReaction === 1 || record.evaluationStatusReaction === 0) {
                            return "بدلیل اینکه ارزیابی واکنشی پاسخ داده نشده امکان ثبت نمره برای این شخص وجود ندارد"
                        }
                    }
                    return null;
                },
                change: function (form, item, value) {

                    if (ListGrid_Class_Student_Eval.getSelectedRecord().scoringMethod == "2") {
                        if (value > 100) {
                            createDialog("info", "نمره باید کمتر از 100 باشد", "<spring:message code="message"/>");
                            item.setValue()
                        } else {
                            score_change_Eval = true
                        }
                    } else if (ListGrid_Class_Student_Eval.getSelectedRecord().scoringMethod == "3") {
                        if (value > 20) {
                            createDialog("info", "<spring:message code="msg.less.score"/>", "<spring:message code="message"/>");
                            item.setValue()
                        } else {
                            score_change_Eval = true
                        }
                    }
                },
                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid, item) {
                    // if (record.evaluationStatusReaction!==1){
                        if (newValue != null) {
                            if (validators_score_Eval(newValue)) {
                                if (parseFloat(newValue) >= classRecord_acceptancelimit_Eval && parseFloat(newValue) <= score_value_Eval) {
                                    ListGrid_Cell_score_Update_Eval(record, newValue, 1);
                                    return;


                                } else if ((parseFloat(newValue) >= 0 && parseFloat(newValue) < classRecord_acceptancelimit_Eval)) {

                                    if ((typeof record.scoresStateId === "undefined" || record.scoresStateId == null || typeof record.scoresStateId === undefined) && failureReason_change_Eval === false) {

                                        record.scoresStateId = null;
                                        record.failureReasonId = null;
                                        ListGrid_Cell_score_Update_Eval(record, newValue, 4);
                                        return
                                    } else if ((typeof record.failureReasonId === "undefined" || typeof record.failureReasonId === undefined) && record.scoresStateId === 410) {

                                        ListGrid_Cell_score_Update_Eval(record, newValue, 4);
                                        return
                                    }
                                    else if (failureReason_change_Eval === true) {

                                        failureReason_change_Eval = false;
                                        ListGrid_Cell_score_Update_Eval(record, newValue, 2);
                                        return;
                                    } else {

                                        failureReason_change_Eval = false;
                                        ListGrid_Cell_score_Update_Eval(record, newValue, 3);
                                        return;
                                    }
                                }

                            } else {
                                Remove_All_Cell_Action_Eval();
                                createDialog("info", "<spring:message code="enter.current.score"/>", "<spring:message code="message"/>");
                                return;
                            }
                        } else if ((typeof newValue === "undefined") && failureReason_change_Eval === true && record.scoresStateId === 403) {
                            // refresh_special = 1;
                            ListGrid_Cell_score_Update_Eval(record, record.score, 5);
                            return;
                        } else {
                            //  console.log('editorExit')
                            //ListGrid_Class_Student_Eval.invalidateCache()
                            return true;
                        }
                    // }else {
                    //     record.score = "";
                    //     ListGrid_Class_Student_Eval.refreshFields();
                    //     ListGrid_Class_Student_Eval.refreshCell;
                    //     ListGrid_Class_Student_Eval.dataChanged();
                    //     createDialog("info", "ارزیابی واکنشی دانشجوی مورد نظر ثبت نشده است");
                    // }


                }
            }
        ],
        sortChanged: function (sortField) {
            let arr = ["valence", "failureReasonId", "scoresStateId"];
            if (arr.includes(sortField[0].property)) {
                createDialog("info", "کاربر گرامی مرتب سازی اطلاعات بر اساس فیلد های وضعیت قبولی و دلایل مردودی و نوع ارزشی امکان پذیر نیست", "توجه!")
                return false
            }
            else
                ListGrid_Class_Student_Eval.invalidateCache()
        },
        dataArrived: function () {
            if (myMap_Eval.get(classScoringMethod_Eval) === "ارزشی") {
                totalsLabel_scores_Eval.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap_Eval.get(classScoringMethod_Eval) + "</b>" +
                    "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" + myMap1_Eval.get(classAcceptanceLimit_Eval) + "</b>");
                scoringMethodPrint_Eval = myMap_Eval.get(classScoringMethod_Eval);
                acceptancelimitPrint_Eval = myMap1_Eval.get(classAcceptanceLimit_Eval);
            } else if (myMap_Eval.get(classScoringMethod_Eval) === "نمره از صد" || myMap_Eval.get(classScoringMethod_Eval) === "نمره از بیست") {
                totalsLabel_scores_Eval.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap_Eval.get(classScoringMethod_Eval) + "</b>" +
                    "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" + (classAcceptanceLimit_Eval) + "</b>");
                scoringMethodPrint_Eval = myMap_Eval.get(classScoringMethod_Eval);
                acceptancelimitPrint_Eval = classAcceptanceLimit_Eval;
            } else {

                totalsLabel_scores_Eval.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap_Eval.get(classScoringMethod_Eval) + "</b>" +
                    "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" + "ندارد" + "</b>");
                scoringMethodPrint_Eval = myMap_Eval.get(classScoringMethod_Eval);
                acceptancelimitPrint_Eval = "ندارد";
            }
        },
        gridComponents: [ToolStrip_Actions_Eval, "filterEditor", "header", "body"],
        <sec:authorize access="hasAuthority('Evaluation_Scores_Actions')">
        canEditCell: function (rowNum, colNum) {

            var record = this.getRecord(rowNum);
            var fieldName = this.getFieldName(colNum);

            // if (fieldName === "scoresStateId") {
            //     return !(classRecord.scoringMethod == "1")
            // }

            if (fieldName === "valence") {
                if (failureReason_value_Eval != null && record.scoresStateId == 403) {
                    return true;
                }
                let arr = [448, 405, 449, 406, 404, 401, 450];
                return !(classScoringMethod_Eval == "2" || classScoringMethod_Eval == "3" || classScoringMethod_Eval == "4" || arr.includes(record.scoresStateId) || (record.scoresStateId === 403 && record.failureReasonId === 453) || (record.scoresStateId === 403 && record.failureReasonId === 407))
            }

            if (fieldName === "score") {
                if (isScoreDependent_Eval) {

                    if (record.evaluationStatusReaction === undefined || record.evaluationStatusReaction === null || record.evaluationStatusReaction===1 || record.evaluationStatusReaction===0) {
                        return false;
                    } else {
                        if (scoresState_value_Eval === 403 || scoresState_value_Eval === 400) {
                            return true;
                        }
                        if (failureReason_value_Eval != null && record.scoresStateId == 403) {
                            return true;
                        }
                        if (classScoringMethod_Eval == "1" || classScoringMethod_Eval == "4") {
                            return false;
                        }
                        if ((scoresState_value_Eval === 403 || scoresState_value_Eval === 400) && (failureReason_value_Eval != null)) {
                            return true;
                        }
                        let arr = [448, 405, 449, 406, 404, 401, 450];
                        return !((record.scoresStateId === 403 && record.failureReasonId === 407) || (record.scoresStateId === 403 && record.failureReasonId === 453) || arr.includes(record.scoresStateId));
                    }

                } else {

                    if (scoresState_value_Eval === 403 || scoresState_value_Eval === 400) {
                        return true;
                    }
                    if (failureReason_value_Eval != null && record.scoresStateId == 403) {
                        return true;
                    }
                    if (classScoringMethod_Eval == "1" || classScoringMethod_Eval == "4") {
                        return false;
                    }
                    if ((scoresState_value_Eval === 403 || scoresState_value_Eval === 400) && (failureReason_value_Eval != null)) {
                        return true;
                    }
                    let arr = [448, 405, 449, 406, 404, 401, 450];
                    return !((record.scoresStateId === 403 && record.failureReasonId === 407) || (record.scoresStateId === 403 && record.failureReasonId === 453) || arr.includes(record.scoresStateId));
                }
            }

            if (fieldName === "failureReasonId") {
                if (scoresState_value_Eval === 403)
                    return true;
                let arr = [448, 410, 405, 449, 406, 404, 401, 450];
                return !(arr.includes(record.scoresStateId));
            }

            if (fieldName === "student.firstName" || fieldName === "student.lastName" || fieldName === "student.nationalCode" || fieldName === "student.personnelNo") {
                return false;
            }
            return true;
        },
        </sec:authorize>
        getCellCSSText: function (record, rowNum, colNum) {
            if (record.save == true) {
                return "background-color:#98B334;font-size: 12px;";
            }
        }
    });

    isc.VLayout.create({
        width: "100%",
        members: [ListGrid_Class_Student_Eval]
    });

    //------------------------------------------- Functions

    function ListGrid_Cell_scoresState_Update_Eval(record, newValue) {
        record.scoresStateId = newValue;
        record.failureReasonId = null;
        record.score = null;
        record.valence = null;
        scoresState_value_Eval = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_scoresState_Update_Eval(rpcResponse)"));
    }

    function ListGrid_Cell_failurereason_Update_Eval(record, newValue) {
        record.failureReasonId = newValue;
        record.scoresStateId = 403;
        record.score = null;
        record.valence = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_failurereason_Update_Eval(rpcResponse)"));
    }

    function ListGrid_Cell_score_Update_Eval(record, newValue, a) {
        record.score = newValue;
        if (a == 1) {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        } else if (a == 2) {
            record.scoresStateId = 403;
            record.failureReasonId = failureReason_value_Eval;
        } else if (a == 3) {
            record.scoresStateId = 403;
            record.failureReasonId = 409;
            record.failureReasonId = record.failureReasonId;
        } else if (a == 4) {
            record.scoresStateId = 403;
            record.failureReasonId = 409;
        } else if (a == 5) {
            record.failureReasonId = failureReason_value_Eval
        }
        scoresState_value_Eval = null;
        failureReason_value_Eval = null;
        failureReason_change_Eval = false;

        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update_Eval(rpcResponse)"));
    }

    function ListGrid_Cell_valence_Update_Eval(record, newValue, a) {
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
            record.failureReasonId = valence_value_failureReason_Eval;
        }
        if (a == 4) {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        }
        if (a == 5) {
            record.scoresStateId = 400;
            record.failureReasonId = null;
        }
        valence_value_failureReason_Eval = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_valence_Update_Eval(rpcResponse)"));
    }

    function ListGrid_Remove_All_Cell_Eval(record) {
        record.scoresStateId = 410;
        record.failureReasonId = null;
        record.score = null;
        record.valence = null;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback:Remove_All_Cell_Action_Eval(rpcResponse)"));
    }

    function Remove_All_Cell_Action_Eval(rpcResponse) {
        ListGrid_Class_Student_Eval.refreshFields();
        ListGrid_Class_Student_Eval.refreshCell;
        ListGrid_Class_Student_Eval.dataChanged();
    }

    function Edit_Cell_scoresState_Update_Eval(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            // ListGrid_Class_Student_Eval.getSelectedRecord().save=true;
            ListGrid_Class_Student_Eval.endEditing();
            ListGrid_Class_Student_Eval.refreshFields();
            ListGrid_Class_Student_Eval.refreshCell;
            ListGrid_Class_Student_Eval.dataChanged();
        } else {
            let scores_wait = createDialog("wait", "در حال بروز رسانی اطلاعات", "<spring:message code="message"/>");
            setTimeout(function () {
                ListGrid_Class_Student_Eval.fetchData();
                ListGrid_Class_Student_Eval.invalidateCache();
                scores_wait.close();
            }, 3000);
            return;
        }
    }

    function Edit_Cell_valence_Update_Eval(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            //  ListGrid_Class_Student_Eval.getSelectedRecord().save=true;
            ListGrid_Class_Student_Eval.endEditing();
            ListGrid_Class_Student_Eval.refreshFields();
            ListGrid_Class_Student_Eval.dataChanged()
        } else {
            <%--let scores_wait=createDialog("wait", "در حال بروز رسانی اطلاعات", "<spring:message code="message"/>");--%>
            <%--setTimeout(function () {--%>
            <%--ListGrid_Class_Student_Eval.fetchData()--%>
            <%--ListGrid_Class_Student_Eval.invalidateCache()--%>
            <%--scores_wait.close()--%>
            <%--},3000);--%>
            <%--return;--%>
        }
    }

    function Edit_Cell_ScoreState_failureReason_Update_Eval() {
        ListGrid_Class_Student_Eval.invalidateCache();
    }

    function setTotalStudentWithOutScore_Eval(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Class_Student_Eval.invalidateCache()
        }
    }

    function Edit_Cell_failurereason_Update_Eval(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            // ListGrid_Class_Student_Eval.getSelectedRecord().save=true;
            ListGrid_Class_Student_Eval.endEditing();
            ListGrid_Class_Student_Eval.refreshFields();
            ListGrid_Class_Student_Eval.dataChanged();
        } else {
            let scores_wait = createDialog("wait", "در حال بروز رسانی اطلاعات", "<spring:message code="message"/>");
            setTimeout(function () {
                ListGrid_Class_Student_Eval.fetchData();
                ListGrid_Class_Student_Eval.invalidateCache();
                scores_wait.close();
            }, 3000);
            return;
        }
    }

    function Edit_Cell_score_Update_Eval(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Class_Student_Eval.endEditing()
            ListGrid_Class_Student_Eval.dataChanged()
            ListGrid_Class_Student_Eval.refreshFields()
            scoresState_value_Eval = null;
            failureReason_value_Eval = null;
            failureReason_change_Eval = false;
            // if (refresh_special == 1) {
            //     console.log('here')
            //     ListGrid_Class_Student_Eval.fetchData()
            //     ListGrid_Class_Student_Eval.invalidateCache()
            //     refresh_special = 0
            //     return
            // }

        } else {
            let scores_wait = createDialog("wait", "در حال بروز رسانی اطلاعات", "<spring:message code="message"/>");
            setTimeout(function () {
                ListGrid_Class_Student_Eval.fetchData();
                ListGrid_Class_Student_Eval.invalidateCache();
                scores_wait.close();
            }, 2000);
            return;
        }
    }

    function validators_score_Eval(value) {

        if (score_value_Eval == 20) {
            if (value.match(/^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/)) {
                return true
            } else {
                return false
            }
        } else if (score_value_Eval == 100) {
            if (value.match(/^(100|[1-9]?\d)$/)) {
                return true
            } else {
                return false
            }
        }
    }

    function printScore_Eval() {

        var Record = ListGrid_class_Evaluation.getSelectedRecord();
        var classObj = {
            code: Record.tclassCode,
            teacher: Record.teacherFullName,
            course: Record.courseTitleFa,
            endDate: Record.tclassEndDate,
            startDate: Record.tclassStartDate,
            scoringMethod: scoringMethodPrint_Eval,
            acceptancelimit: acceptancelimitPrint_Eval
        };

        var advancedCriteria = ListGrid_Class_Student_Eval.getCriteria();
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
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "sortBy", type: "hidden"}
                ]
        });

        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("class", JSON.stringify(classObj));
        criteriaForm.setValue("sortBy", JSON.stringify(ListGrid_Class_Student_Eval.getSort()[0]));
        criteriaForm.setValue("classId", JSON.stringify(Record.id));
        criteriaForm.setValue("token", "<%= accessToken %>");
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function loadPage_Scores_Eval() {

        classCode_Eval = ListGrid_class_Evaluation.getSelectedRecord().tclassCode;

        alarmFor_reaction_evaluation_e.setContents(" ");
        if (ListGrid_class_Evaluation.getSelectedRecord().evaluation == 1) {
            alarmFor_reaction_evaluation_e.setContents("غیر قابل ویرایش بودن برخی رکوردها بدلیل وابستگی ثبت نمرات به ارزیابی واکنشی است");
        }

        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getTClassDataForScoresInEval/" + classCode_Eval, "GET", null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let classData = JSON.parse(resp.httpResponseText);
                classId_Eval = classData.id;
                classCode_Eval = classData.code;
                classStatus_Eval = classData.classStatus;
                classScoringMethod_Eval = classData.scoringMethod;
                classAcceptanceLimit_Eval = classData.acceptancelimit;

                classRecord_acceptancelimit_Eval = parseFloat(classAcceptanceLimit_Eval);
                if (classScoringMethod_Eval == undefined) {
                    createDialog("info", "کاربر گرامی توجه کنید که روش نمره دهی برای این کلاس نامشخص (undefined)است  لطفا فبل از ثبت نمرات روش نمره دهی را مشخص کنید", "<spring:message code="message"/>")
                }
                RestDataSource_ClassStudent_Eval.fetchDataURL = tclassStudentUrl + "/scores-iscList/" + classId_Eval;
                if (classScoringMethod_Eval == "1") {
                    ListGrid_Class_Student_Eval.showField('valence');
                    ListGrid_Class_Student_Eval.hideField('score');
                    Button1_Eval.setDisabled(true);
                    Button2_Eval.setDisabled(false);
                    Button3_Eval.setDisabled(true);
                } else if (classScoringMethod_Eval == "3") {
                    score_value_Eval = 20;
                    ListGrid_Class_Student_Eval.hideField('valence');
                    ListGrid_Class_Student_Eval.showField('score');
                    Button1_Eval.setDisabled(true);
                    Button2_Eval.setDisabled(false);
                    Button3_Eval.setDisabled(false);
                } else if (classScoringMethod_Eval == "2") {
                    score_value_Eval = 100;
                    ListGrid_Class_Student_Eval.hideField('valence');
                    ListGrid_Class_Student_Eval.showField('score');
                    Button1_Eval.setDisabled(true);
                    Button2_Eval.setDisabled(false);
                    Button3_Eval.setDisabled(false);
                } else if (classScoringMethod_Eval == "4") {
                    ListGrid_Class_Student_Eval.hideField('score');
                    ListGrid_Class_Student_Eval.hideField('valence');
                    Button1_Eval.setDisabled(false);
                    Button2_Eval.setDisabled(true);
                    Button3_Eval.setDisabled(true);
                }

                ListGrid_Class_Student_Eval.invalidateCache();
                ListGrid_Class_Student_Eval.fetchData();

            } else {
                ListGrid_Class_Student_Eval.setData([]);
                return;
            }
        }));
    }

    // </script>
