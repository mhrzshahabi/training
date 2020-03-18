<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>
    var score_value = null //بر اساس روش نمره دهی که از 100 یا 20 باشد مقدار 100 یا 20 داخل این متغیر قرار می گیرد
    var classRecord_acceptancelimit = null
    var scoresState_value = null
    var failureReason_value = null
    var valence_value = null
    var valence_value_failureReason = null
    var map = {"1": "ارزشی", "2": "نمره از صد", "3": "نمره از بیست", "4": "بدون نمره"}
    var myMap = new Map(Object.entries(map));
    var map1 = {"1001": "ضعیف", "1002": "متوسط", "1003": "خوب", "1004": "خیلی خوب"}
    var myMap1 = new Map(Object.entries(map1));
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

            {name: "scoresState", title: "<spring:message code="pass.mode"/>", filterOperator: "iContains"},
            {name: "failureReason", title: "<spring:message code="faild.reason"/>", filterOperator: "iContains"},
            {name: "valence", title: "<spring:message code="valence.mode"/>", filterOperator: "iContains"},
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains"},
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
        ID: "ToolStrip_Actions1",
        width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores"
            }),
            isc.IButton.create({
                name: "Button",
                ID: "Button1",
                disabled: true,
                title: "<spring:message code="change.all.to.pass.with.out.score"/>",
                width: "14%",
                click: function () {
                    var record = ListGrid_Class_JspClass.getSelectedRecord();
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setTotalStudentWithOutScore/" + record.id, "PUT", null, "callback: setTotalStudentWithOutScore(rpcResponse)"));
                    ListGrid_Class_Student.invalidateCache()
                }
            }),
            isc.IButton.create({
                name: "Button",
                ID: "Button2",
                disabled: true,
                title: "<spring:message code="delete.scoreState.failureReason.score"/>",
                width: "20%",
                click: function () {
                    var record = ListGrid_Class_Student.getSelectedRecord()
                    if (record == null || record =="undefined")
                    {
                      createDialog("info", "<spring:message code="msg.not.selected.record"/>", "<spring:message code="message"/>")
                    }
                    else
                    {
                        setTimeout(function () {
                        ListGrid_Remove_All_Cell(record)
                        }, 500);

                    }
                }

            }),

            isc.ToolStrip.create({
                width: "50%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            }),

        ]
    });
    //**********************************************************************************
    var ListGrid_Class_Student = isc.TrLG.create({
        ID: "ListGrid_Class_Student1",
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
//------------
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,

//------
        canSelectCells: true,
// sortField: 0,
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

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

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
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[5].masterIndex)
                    } else if (value === "قبول با نمره") {
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[7].masterIndex)
                    } else if (value === "قبول بدون نمره") {
                        ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value)
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
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
                    if (value === "غیبت بیش از حد مجاز" && scoresState_value === "مردود" && this.grid.getRecord(this.rowNum).tclass.scoringMethod === "4") {
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value)
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    }
                    else if (value === "غیبت در جلسه امتحان")
                    {
                        ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    }
                    else if(classRecord.scoringMethod == "1")
                        {
                         this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[6].masterIndex)
                        }
                     else {
                        failureReason_value = value
                        this.grid.startEditing(this.rowNum, ListGrid_Class_Student.completeFields[7].masterIndex)
                    }
                    valence_value_failureReason = value
                },
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
                    valence_value = value
                    if (parseFloat(value) >= classRecord_acceptancelimit) {
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value, 1)
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    } else if (parseFloat(value) < classRecord_acceptancelimit && valence_value_failureReason != null) {
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value, 2)
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    } else if (parseFloat(value) < classRecord_acceptancelimit && this.grid.getRecord(this.rowNum).scoresState == "مردود") {
                        ListGrid_Cell_valence_Update(this.grid.getRecord(this.rowNum), value)
                        this.grid.endEditing();
                        ListGrid_Class_Student.refreshFields();
                    } else {
                        createDialog("info", "<spring:message code="choose.failureReason"/>", "<spring:message code="message"/>")
                        ListGrid_Class_Student.refreshFields();
                    }
                },

                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {
                    if (record.valence != null && record.scoresState == "مردود" && valence_value_failureReason != null) {
                        newValue = record.valence
                        ListGrid_Cell_valence_Update(record, newValue, 3)
                        ListGrid_Class_Student.refreshFields();
                    }

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

                                   // createDialog("info", "<spring:message code="choose.failure.failureReason"/>", "<spring:message code="message"/>")
                                    ListGrid_Cell_score_Update(record, newValue, 2);
                                    ListGrid_Class_Student.invalidateCache();

                                }

                            } else if ((record.scoresState == "مردود" || record.scoresState == "قبول با نمره") && (newValue !== null || newValue != null) && (editCompletionEvent == "enter" || editCompletionEvent == "click_outside")) {

                            } else if (newValue === null && record.scoresState === undefined || record.scoresState == null || record.scoresState === "undefined" && record.failureReason === null) {

                                ListGrid_Class_Student.invalidateCache();
                                ListGrid_Class_Student.refreshFields();
                            }
                            ListGrid_Class_Student.refreshFields();

                        } else {
                            createDialog("info", "<spring:message code="enter.current.score"/>", "<spring:message code="message"/>")
                            return false;
                        }


                    } else {
                       return true
                    }
                },// end editor Exit


            },

        ],

        dataArrived: function () {
            var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        <%--    return (myMap.get(classRecord.scoringMethod) === "ارزشی") ? totalsLabel_scores.setContents("<spring:message--%>
        <%--code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message--%>
        <%--code="acceptance.limit"/>" + ":&nbsp;<b>" + myMap1.get(classRecord.acceptancelimit) + "</b>") : totalsLabel_scores.setContents("<spring:message--%>
        <%--code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message--%>
        <%--code="acceptance.limit"/>" + ":&nbsp;<b>" + (classRecord.acceptancelimit) + "</b>");--%>
      if( myMap.get(classRecord.scoringMethod) === "ارزشی")
        {
         totalsLabel_scores.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" + myMap1.get(classRecord.acceptancelimit) + "</b>")
        }
        else if ( myMap.get(classRecord.scoringMethod) === "نمره از صد"  ||  myMap.get(classRecord.scoringMethod) ==="نمره از بیست")
            {
              totalsLabel_scores.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" + (classRecord.acceptancelimit) + "</b>");
            }
            else {

              totalsLabel_scores.setContents("<spring:message code="scoring.Method"/>" + ":&nbsp;<b>" + myMap.get(classRecord.scoringMethod) + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + "<spring:message code="acceptance.limit"/>" + ":&nbsp;<b>" +  "ندارد" + "</b>");

            }





        },
        gridComponents: [ToolStrip_Actions, "filterEditor", "header", "body"],

        canEditCell: function (rowNum, colNum) {
// var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var record = this.getRecord(rowNum);
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "scoresState") {
                return !(classRecord.scoringMethod == "1")
            }

            if(fieldName ==="valence")
                {
                return !(classRecord.scoringMethod == "2" || classRecord.scoringMethod == "3" || classRecord.scoringMethod == "4")
                }



            if (fieldName === "score") {
                if (failureReason_value != null && record.scoresState == "مردود") {
                    return true
                }
                else if(classRecord.scoringMethod == "1" || classRecord.scoringMethod == "4")
                    {
                    return false
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
        record.failureReason = null
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
             record.scoresState = "مردود"
             record.failureReason = "عدم کسب حد نصاب نمره"
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

    function ListGrid_Cell_valence_Update(record, newValue, a) {
        record.valence = newValue
        if (a == 1) {
            record.scoresState = "قبول"
            record.failureReason = null
        }
        if (a == 2) {

            record.scoresState = "مردود"
            record.failureReason = valence_value_failureReason
        }

        if (a == 3) {

            record.failureReason = valence_value_failureReason
        }

        valence_value_failureReason == null
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_valence_Update(rpcResponse)"));
        ListGrid_Class_Student.refreshFields();
    }

    function ListGrid_Remove_All_Cell(record) {
        record.scoresState = null
        record.failureReason = null
        record.score = null
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + record.id, "PUT", JSON.stringify(record), "callback:Remove_All_Cell_Action(rpcResponse)"));

    }

    function Remove_All_Cell_Action(rpcResponse) {
    ListGrid_Class_Student.invalidateCache()
    }

    function Edit_Cell_scoresState_Update(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            ListGrid_Class_Student.refreshFields();
        }
    };

    function Edit_Cell_valence_Update(resp) {

    }

    function setTotalStudentWithOutScore() {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            ListGrid_Class_Student.refreshFields();
        }

    }


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

    function loadPage_Scores() {
           // isc.MyOkDialog.create({
            // message: "کاربر گرامي توجه کنيد اگر نمره بالاتر از حد قبولي باشد کافي است که فقط فيلد نمره را وارد کنيد در غير اين صورت<br/> اگر نمره کمتر از حد قبولي باشد ابتدا وضعيت قبولي و سپس دلايل مردودي و در نهايت نمره را وارد و Enter کنيد",
            // });
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        classRecord_acceptancelimit = parseFloat(classRecord.acceptancelimit)
        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_ClassStudent.fetchDataURL = tclassStudentUrl + "/scores-iscList/" + classRecord.id
//===========================================
            if (classRecord.scoringMethod == "1") {
                ListGrid_Class_Student.showField('valence')
                ListGrid_Class_Student.hideField('score')
                ListGrid_Class_Student.getField('scoresState').valueMap = ["مردود", "قبول"]
                ListGrid_Class_Student.getField('failureReason').valueMap = ["عدم کسب حد نصاب نمره", "غیبت در جلسات"]
                Button1.setDisabled(true)
                Button2.setDisabled(true)
            } else if (classRecord.scoringMethod == "3") {
                score_value = 20;
                ListGrid_Class_Student.hideField('valence')
                ListGrid_Class_Student.showField('score')
                ListGrid_Class_Student.getField('failureReason').valueMap = ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"]
                ListGrid_Class_Student.getField("scoresState").valueMap = ["قبول با نمره", "مردود"]
                Button1.setDisabled(true)
                Button2.setDisabled(false)
            } else if (classRecord.scoringMethod == "2") {
                score_value = 100;
                ListGrid_Class_Student.hideField('valence')
                ListGrid_Class_Student.showField('score')
                ListGrid_Class_Student.getField('failureReason').valueMap = ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"]
                ListGrid_Class_Student.getField("scoresState").valueMap = ["قبول با نمره", "مردود"]
                Button1.setDisabled(true)
                Button2.setDisabled(false)
            } else if (classRecord.scoringMethod == "4") {
                ListGrid_Class_Student.hideField('score')
                ListGrid_Class_Student.hideField('valence')
                ListGrid_Class_Student.getField('failureReason').valueMap = ["غیبت بیش از حد مجاز"]
                ListGrid_Class_Student.getField("scoresState").valueMap = ["قبول بدون نمره", "مردود"]
                Button1.setDisabled(false)
                Button2.setDisabled(true)
            }
//=================================================
            ListGrid_Class_Student.invalidateCache()
            ListGrid_Class_Student.fetchData()
        } else {
            ListGrid_Class_Student.setData([]);
        }
    }
