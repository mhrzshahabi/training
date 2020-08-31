<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>


    var selectedPerson_TrainingFile = null;
    var printUrl_TrainingFile = "<spring:url value="/web/print/class-student/"/>";

    var RestDataSource_Student_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: studentUrl + "spec-list/"
    });
    var RestDataSource_ScoreState_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/317"
    });
    var RestDataSource_Course_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "classCode", title:"<spring:message code='class.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitle", title:"<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "termTitleFa", title:"<spring:message code='term'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "startDate", title:"<spring:message code='start.date'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "endDate", title:"<spring:message code='end.date'/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "classStatus", filterOperator: "equals", autoFitWidth: true,
                title:"<spring:message code='class.status'/>",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
            },
            {name: "score", title:"<spring:message code='score'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "scoresState", title:"<spring:message code="pass.mode"/>", autoFitWidth: true,
                optionDataSource: RestDataSource_ScoreState_JspTrainingFile,
                valueField: "id",
                displayField: "title",
                filterOperator: "equals",

            },
            {name: "postTitle", title:"<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "teacher", title:"<spring:message code='teacher'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title:"<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title:"<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: trainingFileUrl + "/iscList"
    });

    var ListGrid_StudentSearch_JspTrainingFile = isc.TrLG.create({
        dataSource: RestDataSource_Student_JspTrainingFile,
        allowAdvancedCriteria:true,
        canSelect:false,
        selectionType: "single",
        allowFilterExpressions: true,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"}
        ],
        autoFetchData:false,
        rowDoubleClick: function () {
            DynamicForm_TrainingFile.editRecord(this.getSelectedRecord());
            selectedPerson_TrainingFile = this.getSelectedRecord();
            let cr = {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[
                    {fieldName:"nationalCode", operator:"equals", value: selectedPerson_TrainingFile.nationalCode},
                    // {fieldName:"empNo", operator:"equals", value: selectedPerson_TrainingFile.personnelNo2}
                ]
            };
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
            ListGrid_TrainingFile_TrainingFileJSP.setImplicitCriteria(cr);
            ListGrid_TrainingFile_TrainingFileJSP.fetchData();
            Window_StudentSearch_JspTrainingFile.close();
            excelBtn.setDisabled(false);
        }
    });

    var Window_StudentSearch_JspTrainingFile = isc.Window.create({
        autoSize:false,
        title:"<spring:message code="students.list"/>",
        width: "100%",
        placement:"fillPanel",
        keepInParentRect: true,
        height: 600,
        items:[
           ListGrid_StudentSearch_JspTrainingFile
        ]
    });
    var DynamicForm_TrainingFile = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        titleAlign:"left",
        colWidths:[100,250,100,250,100,150,100],
        fields: [
            {
                name: "personnelNo2",
                title:"<spring:message code="personnel.no.6.digits"/>",
                textAlign: "center",
                width: "*",
                keyPressFilter: "[0-9, ]",
                // supportsCutPasteEvents: true,
                // changeOnKeypress:true,
                changed (form, item, value){
                    let res = value.split(" ");
                    item.setValue(res.toString())
                }
            },
            {
                name: "personnelNo",
                title:"<spring:message code="personnel.no"/> ",
                textAlign: "center",
                width: "*",
                keyPressFilter: "[0-9, ]"
            },
            {
                name: "nationalCode",
                title:"<spring:message code="national.code"/> ",
                textAlign: "center",
                width: "*",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspTrainingFile",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width:"*",
                startRow:false,
                endRow:false,
                click (form) {
                    let advancedCriteriaStudentJspTrainingFile = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: []
                    };
                    let items = form.getItems();
                    for (let i = 0; i < items.length; i++) {
                        if(items[i].getValue() != undefined){
                            if(items[i].name == "personnelNo2"){
                                advancedCriteriaStudentJspTrainingFile.criteria.add({fieldName: items[i].name, operator: "inSet", value: items[i].getValue().split(',').toArray()})
                            }
                            else {
                                advancedCriteriaStudentJspTrainingFile.criteria.add({
                                    fieldName: items[i].name,
                                    operator: "iContains",
                                    value: items[i].getValue()
                                })
                            }
                        }
                    }
                    ListGrid_StudentSearch_JspTrainingFile.fetchData(advancedCriteriaStudentJspTrainingFile);
                    Window_StudentSearch_JspTrainingFile.show();
                }
            },
            {
                name: "firstName",
                title:"<spring:message code="firstName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "lastName",
                title:"<spring:message code="lastName"/> ",
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
                click (form, item) {
                    form.clearValues();
                    ListGrid_TrainingFile_TrainingFileJSP.setData([]);
                    excelBtn.setDisabled(true);
                }
            },
        ],
        itemKeyPress: function(item, keyName) {
            if(keyName == "Enter"){
                searchBtnJspTrainingFile.click(DynamicForm_TrainingFile);
            }
        }
    });

    var Menu_Courses_TrainingFileJSP = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="global.form.print.pdf"/>",
                click: function () {
                    print_Training_File();
                }
            }, {
                title: "<spring:message code="global.form.print.excel"/>",
                click: function () {
                    print_Training_File("excel");
                }
            }, {
                title: "<spring:message code="global.form.print.html"/>",
                click: function () {
                    print_Training_File("html");
                }
        }]
    });

    var excelBtn= isc.ToolStripButtonExcel.create({
        click: function() {
            let criteria = ListGrid_TrainingFile_TrainingFileJSP.getCriteria();

            if(typeof(criteria.operator)=='undefined'){
                criteria._constructor="AdvancedCriteria";
                criteria.operator="and";
            }

            if(typeof(criteria.criteria)=='undefined'){
                criteria.criteria=[];
            }
            criteria.criteria.push({fieldName:'student.nationalCode',operator:'equals',value:DynamicForm_TrainingFile.getField("nationalCode").getValue()});

            ExportToFile.showDialog(null, ListGrid_TrainingFile_TrainingFileJSP, 'trainingFile', 0, null, '',  "پرونده آموزشی", criteria, null);
        }
    });

    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        contextMenu: Menu_Courses_TrainingFileJSP,
        dataSource: RestDataSource_Course_JspTrainingFile,
        filterOnKeypress: true,
        gridComponents: [DynamicForm_TrainingFile,isc.ToolStrip.create({
            members: [
              excelBtn
            ]

        }), "header", "filterEditor", "body"],
        fields:[
            {name: "classCode"},
            {name: "courseCode"},
            {name: "courseTitle"},
            {name: "termTitleFa"},
            {name: "startDate",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "endDate",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "classStatus"},
            {name: "score"},
            {name: "scoresState"},
            {name: "postTitle"},
            {name: "postCode", hidden: true},
            {name: "affairs"},
            {name: "teacher"}
        ]
    });

    var VLayout_Body_Training_File = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [

            ListGrid_TrainingFile_TrainingFileJSP
        ]
    });

    //*************this function calls from studentPortal page**************
    function call_trainingFile(selected_person) {
        selectedPerson_TrainingFile = selected_person;
        DynamicForm_TrainingFile.hide();
        RestDataSource_Course_JspTrainingFile.fetchDataURL = studentPortalUrl + "/class-student/classes-of-student/" + selectedPerson_TrainingFile.nationalCode;
        printUrl_TrainingFile = "<spring:url value="/web/print/student-portal/"/>";
        ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        ListGrid_TrainingFile_TrainingFileJSP.fetchData();
    }

    function print_Training_File(type = "pdf") {
        if (selectedPerson_TrainingFile == null){
            createDialog("info", "<spring:message code='personnel.not.selected'/>");
            return;
        }
        let params = {};
        params.firstName = selectedPerson_TrainingFile.firstName;
        params.lastName = selectedPerson_TrainingFile.lastName;
        params.nationalCode = selectedPerson_TrainingFile.nationalCode;
        params.personnelNo = selectedPerson_TrainingFile.personnelNo;
        params.personnelNo2 = selectedPerson_TrainingFile.personnelNo2;
        params.companyName = selectedPerson_TrainingFile.companyName;
        
        let CriteriaForm_TrainingFile = isc.DynamicForm.create({
            method: "POST",
            action: printUrl_TrainingFile + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "myToken", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "formData", type: "hidden"},
                ]
        });
        CriteriaForm_TrainingFile.setValue("CriteriaStr", JSON.stringify(ListGrid_TrainingFile_TrainingFileJSP.getCriteria()));
        CriteriaForm_TrainingFile.setValue("formData", JSON.stringify(selectedPerson_TrainingFile.nationalCode));
        CriteriaForm_TrainingFile.setValue("myToken", "<%=accessToken%>");
        CriteriaForm_TrainingFile.setValue("params", JSON.stringify(params));
        CriteriaForm_TrainingFile.show();
        CriteriaForm_TrainingFile.submitForm();
    }

    excelBtn.setDisabled(true);

 //</script>