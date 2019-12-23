<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
//
//
//<script>
var Row_Numbers=null
flag1=null
    RestDataSource_ClassStudent = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "student.firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "student.lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains"
            },
            {name: "student.companyName", title: "<spring:message code="company"/>", filterOperator: "iContains"},
            {name: "student.personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains"},
            {name: "scoresState", title: "<spring:message code="pass.mode"/>", filterOperator: "iContains"},
            {name: "failurereason", title: "<spring:message code="faild.reason"/>", filterOperator: "iContains"},
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains"}
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
                align: "center"
            },
            {name: "student.lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains", autoFitWidth: true
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
                title: "<spring:message code="pass.mode"/>",
                filterOperator: "iContains",
                canEdit: false,
                editorType: "SelectItem",
                valueMap: ["قبول با نمره", "قبول بدون نمره", "مردود"],
                changed: function (form, item, value) {


                if(value ===  "قبول بدون نمره")
                {
                 ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);
                }
                else if(value === "مردود")
                {

                ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);
                ListGrid_Class_Student.refreshFields();
                this.grid.startEditing(this.rowNum, this.colNum + 1)
                }
                else if(value === "قبول با نمره")
                {
                     ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);
                     this.grid.startEditing(this.rowNum, this.colNum + 2)
                     ListGrid_Class_Student.refreshFields();
                }

                }
            },

            {
                name: "failurereason",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"],
                changed: function (form, item, value) {
                 if(value === "غیبت در جلسه امتحان" )
               {
                    ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);

               }
               else
                {
                     ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                         // if(this.grid.getRecord(this.rowNum).score !== null)
                         //  this.grid.startEditing(this.rowNum, this.colNum + 1)
                }
                 ListGrid_Class_Student.refreshFields();
                }
            },

            {
                name: "score",
                title: "<spring:message code="score"/>",
                filterOperator: "iContains",
                canEdit: true,
                shouldSaveValue: false,
                change:function(form,item,value)
                {
                if(value>20)
                {
                        createDialog("info","<spring:message code="msg.less.score"/>","<spring:message code="message"/>")
                        item.setValue()
                }


                },
                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {

                   if ((newValue >= 10 && newValue <= 20) && (editCompletionEvent === "enter") && (newValue !== null || newValue != null)) {

                        ListGrid_Cell_score_Update(record, newValue);
                        ListGrid_Cell_scoresState_Update(record, "قبول با نمره");
                        ListGrid_Class_Student.refreshFields();
                    } else if ((newValue >= 0 && newValue < 10) && (editCompletionEvent == "enter") && (newValue !== null || newValue != null)) {
                        {

                        if(record.scoresState ==  "مردود" && (record.failurereason =="عدم کسب حد نصاب نمره" || record.failurereason == "غیبت بیش از حد مجاز"))
                        {
                            ListGrid_Cell_score_Update(record, newValue);

                            ListGrid_Class_Student.refreshFields();
                        }  else
                            {

                             createDialog("info","لطفا وضعیت قبولی را مردود و همچنین دلیل مردودی راانتخاب کنید","<spring:message code="msg.less.score"/>")
                             ListGrid_Cell_scoresState_Update(record,null);
                                  ListGrid_Class_Student.invalidateCache();
                            }

                        }




                    }
                    //(record.scoresState == "مردود" || record.scoresState == "قبول با نمره") &&
                    else if ((record.score === null || record.score == null) && (newValue == null || newValue === null) && (editCompletionEvent == "enter" )) {

                        ListGrid_Cell_scoresState_Update(record, null)
                       // ListGrid_Class_Student.refreshFields();
                        ListGrid_Cell_score_Update(record, null);
                       // ListGrid_Class_Student.refreshFields();
                        ListGrid_Cell_failurereason_Update(record, null)
                        ListGrid_Class_Student.refreshFields();
                    }
                    else if ((newValue === null || newValue==="undefined" || newValue ==null || newValue === undefined)&& editCompletionEvent=="enter") {

                          ListGrid_Cell_score_Update(record, null);


                    }
                    ListGrid_Class_Student.refreshFields();

                },
                validators: {
                    type: "regexp",
                    errorMessage: "<spring:message code="msg.validate.score"/>",
                    expression: /^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/
                },
            }
        ],


        gridComponents: [ToolStrip_Actions, "filterEditor", "header", "body"],
        canEditCell: function (rowNum, colNum) {

            var record = this.getRecord(rowNum),
                fieldName = this.getFieldName(colNum);

            if (fieldName === "failurereason") {
                return !((record.scoresState === "قبول با نمره" && record.score >= 10) || record.scoresState==="قبول بدون نمره");
            }

           if(fieldName==="score")

            {return !((record.scoresState==="مردود" && record.failurereason=== "غیبت در جلسه امتحان") || record.scoresState==="قبول بدون نمره" )}

            if (fieldName === "score") {
                return record.scoresState !== "قبول بدون نمره";
            }

            if (fieldName === "scoresState") {
                return true;
            }
            return false;

        }


    });


    var vlayout = isc.VLayout.create({
        width: "100%",
        members: [ListGrid_Class_Student]
    })


    function ListGrid_Cell_scoresState_Update(record, newValue) {
        record.scoresState = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_scoresState_Update(rpcResponse)"));
    }

    function ListGrid_Cell_failurereason_Update(record, newValue) {
        record.failurereason = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_failurereason_Update(rpcResponse)"));
    }

    function ListGrid_Cell_score_Update(record, newValue) {

        record.score = newValue
        isc.RPCManager.sendRequest(TrDSRequest(classStudent + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update(rpcResponse)"));


    }


    function Edit_Cell_scoresState_Update(resp) {

            var scoreState=JSON.parse(resp.data).scoresState
            var record=ListGrid_Class_Student.getSelectedRecord();
            var failurereason=JSON.parse(resp.data).failurereason
           var score=JSON.parse(resp.data).score
         if ((resp.httpResponseCode == 200 || resp.httpResponseCode == 201))

        {
           if(scoreState === "قبول بدون نمره")
            {
                ListGrid_Cell_score_Update(record,null)

                    ListGrid_Class_Student.refreshFields();
            }
            if(failurereason === "غیبت در جلسه امتحان" && scoreState=== "مردود")
              {
              ListGrid_Cell_score_Update(record,null)
               ListGrid_Class_Student.refreshFields()
              }

            if(scoreState==null && score== null)
            {
             ListGrid_Cell_failurereason_Update(record,null)
             ListGrid_Class_Student.refreshFields();
            }

            if(score>=10 && scoreState==="قبول با نمره")
            {
            alert("okl")
                ListGrid_Cell_failurereason_Update(record,null)
                  ListGrid_Class_Student.refreshFields();
            }
        }


    };


    function Edit_Cell_failurereason_Update(resp) {
       var record = ListGrid_Class_Student.getSelectedRecord();
         var failurereason= JSON.parse(resp.data).failurereason;

        if ((resp.httpResponseCode == 200 || resp.httpResponseCode == 201))
        {
            if(failurereason=== "غیبت در جلسه امتحان")
                {

                  ListGrid_Cell_scoresState_Update(record,"مردود")

                }

        }

    };

    function Edit_Cell_score_Update(resp) {
            var stateScore = JSON.parse(resp.data).scoresState;
            var score=JSON.parse(resp.data).score;
            var record = ListGrid_Class_Student.getSelectedRecord();
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201 ) {

              if(score==null && stateScore !=="قبول بدون نمره")
                {
                  ListGrid_Cell_scoresState_Update(record,null)

                }

                if(stateScore ===  "قبول بدون نمره")
                {
                 ListGrid_Cell_failurereason_Update(record,null)
                   ListGrid_Class_Student.refreshFields();
                }
       }

    };

    function loadPage_Scores() {
        classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
// RestDataSource_ClassStudent.fetchDataURL = classStudent + "getStudent" + "/" + classRecord.id;
            RestDataSource_ClassStudent.fetchDataURL = classStudent + "iscList/" + classRecord.id;
            <%--ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + "<spring:message code='class.checkList.forms'/>" + "&nbsp;<b>" + classRecord.course.titleFa + "&nbsp;<b>" + "<spring:message code='class.code'/>" + "&nbsp;<b>" + classRecord.code});--%>
            ListGrid_Class_Student.fetchData();
            ListGrid_Class_Student.invalidateCache();
        } else {
            ListGrid_Class_Student.setData([]);
        }

    }