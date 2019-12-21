<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
//
//
//<script>
var Row_Number=null
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
                    ListGrid_Cell_scoresState_Update(this.grid.getRecord(this.rowNum), value);
                     ListGrid_Class_Student.refreshFields();
                    if(value ==="قبول با نمره" || value === "مردود")
                    this.grid.startEditing(this.rowNum, this.colNum + 2)




                },
            },
            {
                name: "failurereason",
                title: "<spring:message code="faild.reason"/>",
                filterOperator: "iContains",
                canEdit: true,
                editorType: "SelectItem",
                valueMap: ["عدم کسب حد نصاب نمره", "غیبت بیش از حد مجاز", "غیبت در جلسه امتحان"],
                changed: function (form, item, value) {
                   if(value ===  "غیبت در جلسه امتحان")
                    {
                          ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);
                    }
                    else  {
                     ListGrid_Cell_failurereason_Update(this.grid.getRecord(this.rowNum), value);

                     this.grid.startEditing(this.rowNum, this.colNum + 1)
                     ListGrid_Class_Student.refreshFields();
                     }


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
                        ListGrid_Cell_failurereason_Update(record, null)
                           ListGrid_Class_Student.refreshFields();


                    } else if ((newValue >= 0 && newValue < 10) && (editCompletionEvent == "enter") && (newValue !== null || newValue != null)) {

                        ListGrid_Cell_score_Update(record, newValue);
                        ListGrid_Class_Student.refreshFields();
                    } else if ((record.scoresState == "مردود" || record.scoresState == "قبول با نمره") && (record.score === null || record.score == null) && (newValue == null || newValue === null) && (editCompletionEvent == "enter" )) {


                        ListGrid_Cell_scoresState_Update(record, null)
                        ListGrid_Class_Student.refreshFields();
                        ListGrid_Cell_score_Update(record, null);
                        ListGrid_Class_Student.refreshFields();
                        ListGrid_Cell_failurereason_Update(record, null)
                        ListGrid_Class_Student.refreshFields();
                    }
                    else if (newValue === null) {

                          ListGrid_Cell_score_Update(record, null);
                           ListGrid_Class_Student.refreshFields();

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

        var scoresState=JSON.parse(resp.data).scoresState;
          var failurereason= JSON.parse(resp.data).failurereason;
        var record = ListGrid_Class_Student.getSelectedRecord();


        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            if (scoresState ==="قبول بدون نمره")

                {
                ListGrid_Cell_score_Update(record, null);

               }

            else if(scoresState ==="قبول با نمره")

            {
            ListGrid_Cell_failurereason_Update(record, null);

            }
            else if(scoresState=== "مردود")
            {

           //  ListGrid_Cell_failurereason_Update(record, "عدم کسب حد نصاب نمره")
             ListGrid_Class_Student.refreshFields();
            }
        }

    };


    function Edit_Cell_failurereason_Update(resp) {
       var record = ListGrid_Class_Student.getSelectedRecord();
         var failurereason= JSON.parse(resp.data).failurereason;
        if ((resp.httpResponseCode == 200 || resp.httpResponseCode == 201))

        {

                if(failurereason === "غیبت در جلسه امتحان" )
               {
                   ListGrid_Cell_score_Update(record, null)
                   ListGrid_Cell_scoresState_Update(record,"مردود")
                   ListGrid_Class_Student.refreshFields()
               }
        }

    };

    function Edit_Cell_score_Update(resp) {
            var score = JSON.parse(resp.data).score;
              var failurereason= JSON.parse(resp.data).failurereason;
            var record = ListGrid_Class_Student.getSelectedRecord();
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            if(record.scoresState ==="قبول بدون نمره")
            {
             ListGrid_Cell_failurereason_Update(record, null)
              ListGrid_Class_Student.refreshFields();
            }


             else if(record.failurereason === "غیبت در جلسه امتحان" )
               {
                    ListGrid_Class_Student.refreshFields();
               }



          else if(score === null || score==="undefined" || score ==null)
            {

              ListGrid_Cell_scoresState_Update(record, null)
              ListGrid_Cell_failurereason_Update(record, null)
              ListGrid_Class_Student.refreshFields();
            }
           else if (score >= 10) {

                ListGrid_Cell_scoresState_Update(record, "قبول با نمره");

                ListGrid_Class_Student.refreshFields();
              }
              else if (score >= 0 && score < 10) {


                     ListGrid_Cell_scoresState_Update(record, "مردود")
                     ListGrid_Cell_failurereason_Update(record, "عدم کسب حد نصاب نمره")
                     ListGrid_Class_Student.refreshFields();
            }
        } else {
        ListGrid_Cell_score_Update(record, null)
        var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="warning"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 5000);

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