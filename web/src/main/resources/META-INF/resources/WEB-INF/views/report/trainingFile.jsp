<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var RestDataSource_Student_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: studentUrl + "spec-list/"
    });
    var RestDataSource_Course_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "tclass.course.titleFa"},
            {name: "tclass.course.code"},
            {name: "score"},
            {name: "tclass.classStatus"},
        ],
        fetchDataURL: tclassStudentUrl + "classes-of-student/"
    });
    var ListGrid_StudentSearch_JspTrainingFile = isc.TrLG.create({
        dataSource: RestDataSource_Student_JspTrainingFile,
        allowAdvancedCriteria:true,
        canSelect:false,
        selectionType: "single",
        allowFilterExpressions: true,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"}
        ],
        autoFetchData:false,
        doubleClick: function () {
            console.log(this.getSelectedRecord().nationalCode)
            DynamicForm_TrainingFile.editRecord(this.getSelectedRecord());
            RestDataSource_Course_JspTrainingFile.fetchDataURL = tclassStudentUrl + "/classes-of-student/" + this.getSelectedRecord().nationalCode;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
            ListGrid_TrainingFile_TrainingFileJSP.fetchData();
            Window_StudentSearch_JspTrainingFile.close();

        }
    });
    var Window_StudentSearch_JspTrainingFile = isc.Window.create({
        autoSize:false,
        title:"<spring:message code="students.list"/>",
        width: "100%",
        placement:"fillPanel",
        height: 600,
        items:[
           ListGrid_StudentSearch_JspTrainingFile
        ]
    });
    var DynamicForm_TrainingFile = isc.DynamicForm.create({
        ID: "TrainingFileForm",
        numCols: 7,
        padding: 10,
        titleAlign:"left",
        // wrapItemTitles:true,
        // cellBorder:2,
        colWidths:[100,150,100,150,100,150,100],
        fields: [
            {
                name: "personnelNo2",
                title:"<spring:message code="personnel.no.6.digits"/>",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                name: "personnelNo",
                title:"<spring:message code="personnel.no"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                name: "nationalCode",
                title:"<spring:message code="national.code"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspTrainingFile",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width:"*",
                startRow:false,
                endRow:false,
                // labelAsTitle: true,
                click (form) {
                    var advancedCriteriaStudentJspTrainingFile = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: []
                    };
                    var items = form.getItems();
                    for (let i = 0; i < items.length; i++) {
                        if(items[i].getValue() != undefined){
                            advancedCriteriaStudentJspTrainingFile.criteria.add({fieldName: items[i].name, operator: "iContains", value: items[i].getValue()})
                        }
                    }
                    ListGrid_StudentSearch_JspTrainingFile.fetchData(advancedCriteriaStudentJspTrainingFile);
                    Window_StudentSearch_JspTrainingFile.show();
                }
            },
            {
                name: "firstName",
                title:"<spring:message code="firstName"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                name: "lastName",
                title:"<spring:message code="lastName"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                type: "SpacerItem"
            },
            {
                type: "SpacerItem"
            },
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width:"*",
                startRow:false,
                endRow:false,
                // labelAsTitle: true,
                click (form, item) {
                    form.clearValues();
                }
            },
        ],
        itemKeyPress: function(item, keyName) {
            if(keyName == "Enter"){
                searchBtnJspTrainingFile.click(DynamicForm_TrainingFile);
            }
        }
    });
    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        // confirmDiscardEdits: false,
        // allowFilterExpressions: true,
        // allowAdvancedCriteria: true,
        dataSource: RestDataSource_Course_JspTrainingFile,
        filterOnKeypress: true,
        gridComponents: [DynamicForm_TrainingFile, "header", "filterEditor", "body"],
        canHover:true,
        fields:[
            {name: "tclass.course.titleFa", title:"<spring:message code='course.title'/>"},
            {name: "tclass.course.code", title:"<spring:message code='course.code'/>"},
            {name: "tclass.code", title:"<spring:message code='class.code'/>"},
            {
                name: "tclass.classStatus",
                title:"<spring:message code='class.status'/>",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
            },
            {name: "score", title:"<spring:message code='score'/>"},
            {name: "student.postTitle", title:"<spring:message code="post"/>"},
        ]
        // optionDataSource: DataSource_SessionInOneDate,
        // autoFetchData:true,

    });
    var VLayout_Body_Training_File = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            // DynamicForm_TrainingFile,
            ListGrid_TrainingFile_TrainingFileJSP
        ]
    });

    function sessions_for_one_date(resp) {
        for (var i = 0; i < JSON.parse(resp.data).length; i++) {
            DataSource_SessionInOneDate.addData(JSON.parse(resp.data)[i]);
        }
        <%--if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
        <%--resp.data--%>
        <%--}--%>
        <%--else {--%>
        <%--isc.say("<spring:message code='error'/>");--%>
        <%--}--%>
    }

    function loadPage_TrainingFile() {
        // if(ListGrid_Class_JspClass.getSelectedRecord() === classGridRecordInTrainingFileJsp){
        //     return;
        // }
        if(TrainingFileGrid.getAllEditRows().length>0){
            createDialog("[SKIN]error","حضور و غیاب ذخیره نشده است.","یادآوری");
            return;
        }
        if(classGridRecordInTrainingFileJsp == ListGrid_Class_JspClass.getSelectedRecord()){
            ListGrid_TrainingFile_Refresh();
            return;
        }
        classGridRecordInTrainingFileJsp = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classGridRecordInTrainingFileJsp == null)) {
            // DynamicForm_TrainingFile.setValue("sessionDate", "");
            DynamicForm_TrainingFile.setValue("TrainingFileTitle", "کلاس " + classGridRecordInTrainingFileJsp.titleClass + " گروه " + classGridRecordInTrainingFileJsp.group);
            DynamicForm_TrainingFile.setValue("sessionDate","");
            DynamicForm_TrainingFile.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        }
        else{
            DynamicForm_TrainingFile.setValue("TrainingFileTitle", "");
            DynamicForm_TrainingFile.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        }
    }

    function ListGrid_TrainingFile_Refresh(form = TrainingFileForm) {
        let oldValue = form.getValue("sessionDate");
        form.getItem("filterType").changed(form, form.getItem("filterType"), form.getValue("filterType"));
        form.getItem("sessionDate").click(form, form.getItem("sessionDate"));
        if(form.getValue("filterType") == 2) {
            setTimeout(function () {
                for (let i = 0; i < sessionDateData.allRows.length; i++) {
                    if (sessionDateData.allRows[i].id == oldValue) {
                        form.setValue("sessionDate", oldValue);
                        form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                        return;
                    }
                }
            }, 500)
        }
        else{
            setTimeout(function () {
                for (let i = 0; i < sessionDateData.allRows.length; i++) {
                    if (sessionDateData.allRows[i].sessionDate == oldValue) {
                        form.setValue("sessionDate", oldValue);
                        form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                        return;
                    }
                }
            }, 500)
        }
    }

    // isc.confirm.addProperties({
    //     buttonClick: function (button, index) {
    //         this.close();
    //         if (index === 1) {
    //             console.log("save click shod")
    //         }
    //     }
    // });

    //</script>