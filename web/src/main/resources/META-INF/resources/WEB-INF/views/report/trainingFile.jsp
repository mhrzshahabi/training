<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>

    let userNationalCode="";
    var RestDataSource_Course_JspTrainingFile = isc.TrDS.create({
        transformResponse: function (dsResponse) {
            if (JSON.parse(dsResponse.httpResponseText).response.info) {
                userNationalCode="";
                if (JSON.parse(dsResponse.httpResponseText).response.info!=null && JSON.parse(dsResponse.httpResponseText).response.info.nationalCode!=null && JSON.parse(dsResponse.httpResponseText).response.info.nationalCode!==undefined)
                userNationalCode=JSON.parse(dsResponse.httpResponseText).response.info.nationalCode;
                DynamicForm_TrainingFile.setValue("fullName", " " + JSON.parse(dsResponse.httpResponseText).response.info.firstName + "  " + JSON.parse(dsResponse.httpResponseText).response.info.lastName);
            }
            return this.Super("transformResponse", arguments);
        },
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "classCode", title: "<spring:message code='class.code'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "courseCode", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "courseTitle", title: "<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "termTitleFa", title: "<spring:message code='term'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "startDate", title: "<spring:message code='start.date'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "endDate", title: "<spring:message code='end.date'/>", filterOperator: "iContains", autoFitWidth: false},
            {
                name: "classStatus", filterOperator: "equals", autoFitWidth: false,
                title: "<spring:message code='class.status'/>",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
            },
            {name: "score", title: "<spring:message code='score'/>", filterOperator: "iContains", autoFitWidth: false},
            {
                name: "scoresState", title: "<spring:message code="pass.mode"/>", autoFitWidth: false,
                valueField: "id",
                displayField: "title",
                filterOperator: "equals",
            },
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "teacher", title: "<spring:message code='teacher'/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "personnelCode", hidden: true, title: "<spring:message code="personnel.code"/>"},
            {name: "personType", hidden: true, title: "<spring:message code="personnel"/>"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "companyName", title: "<spring:message code="company"/>"},
            {name: "complex", title: "<spring:message code="complex"/>"},
            {name: "duration", title: "<spring:message code="duration"/>"},
            {name: "runType", title: "<spring:message code="course.run.type"/>"},
            {name: "postGradeTitle", title: "<spring:message code="post.grade"/>"},
            {name: "assistant", title: "<spring:message code="assistance"/>"},
            {name: "classId",hidden: true},
        ],
    });

    var DynamicForm_TrainingFile = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "left",
        fields: [
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "nationalCode",
                validators: [TrValidators.NationalCodeValidate],
                title: "<spring:message code='national.code'/>",
                keyPressFilter: "[0-9|/|.]| ",
                width: "*",
                length: 10,
                required: true
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspTrainingFile",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                startRow: false,
                endRow: false,
                click() {
                    DynamicForm_TrainingFile.validate();
                    if (!DynamicForm_TrainingFile.hasErrors()) {
                        RestDataSource_Course_JspTrainingFile.fetchDataURL = trainingFileUrl.concat("/").concat(DynamicForm_TrainingFile.getValue("nationalCode"));
                        ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
                        ListGrid_TrainingFile_TrainingFileJSP.fetchData();
                    }
                }
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "fullName",
                type: "staticText",
                title: "<spring:message code="full.name"/> : ",
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "certificateBtn",
                ID: "certificateBtnJspTrainingFile",
                title: "درخواست گواهی نامه آموزشی",
                type: "ButtonItem",
                startRow: false,
                endRow: false,
                click() {
                     let record = ListGrid_TrainingFile_TrainingFileJSP.getSelectedRecord();
                    if (record == null ){
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    }else {
                            if ((record.scoresStateNum==null || record.scoresStateNum==undefined) ||( record.scoresStateNum!==400 && record.scoresStateNum!==401)){
                                createDialog("info", "شما در این کلاس قبول نشده اید");
                        }
                        else if ((record.classStatusNum==null || record.classStatusNum==undefined) ||( record.classStatusNum!==3 && record.classStatusNum!==5)){
                            createDialog("info", "کلاس شما پایان یافته یا اختتام نشده است");
                        } else if (record.classId!=null && userNationalCode!==""){
                                    printCertificate(record.classId);
                                }
                       }


                }
            }


        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspTrainingFile.click(DynamicForm_TrainingFile);
            }
        }
    });

    var excelBtn = isc.ToolStripButtonExcel.create({
        click: function () {
            let detailFields = "courseTitle,courseCode,classCode,termTitleFa,duration,startDate,endDate,runType,classStatus,score,scoresState,teacher,"
                .concat("personnelCode,personType,companyName,complex,assistant,affairs,postTitle,postCode,postGradeTitle");
            let detailHeaders = '<spring:message code="course"/>,<spring:message code="course.code"/>,<spring:message code="class.code"/>,<spring:message code="term"/>,'
                .concat('<spring:message code="duration"/>,<spring:message code="start.date"/>,<spring:message code="end.date"/>,<spring:message code="course.run.type"/>,')
                .concat('<spring:message code="class.status"/>,<spring:message code="score"/>,<spring:message code="score.state"/>,<spring:message code="teacher"/>,<spring:message code="personnel.code"/>,')
                .concat('<spring:message code="personnel"/>,<spring:message code="company"/>,<spring:message code="complex"/>,<spring:message code="assistance"/>,<spring:message code="affairs"/>,')
                .concat('<spring:message code="post"/>,<spring:message code="post.code"/>,<spring:message code="post.grade"/>');

            let masterData = {};
            masterData['<spring:message code="full.name"/>'] = DynamicForm_TrainingFile.getItem('fullName').getValue();
            masterData['<spring:message code="national.code"/>'] = DynamicForm_TrainingFile.getItem('nationalCode').getValue();


            let title = '<spring:message code="training.file"/>';
            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/reportsToExcel/masterDetail",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "masterData", type: "hidden"},
                        {name: "detailFields", type: "hidden"},
                        {name: "detailHeaders", type: "hidden"},
                        {name: "detailDto", type: "hidden"},
                        {name: "title", type: "hidden"},
                        {name: "detailData", type: "hidden"},
                    ]
            });

            downloadForm.setValue("masterData", JSON.stringify(masterData));
            downloadForm.setValue("detailFields", detailFields);
            downloadForm.setValue("detailHeaders", detailHeaders);
            downloadForm.setValue("detailData", JSON.stringify(ListGrid_TrainingFile_TrainingFileJSP.getData().localData));
            downloadForm.setValue("title", title);
            downloadForm.setValue("detailDto", "com.nicico.training.dto.ViewTrainingFileDTO");
            downloadForm.show();
            downloadForm.submitForm();
        }
    });
    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        showFilterEditor: false,
        sortField: ["startDate"],
        sortDirection: "ascending",
        dataSource: RestDataSource_Course_JspTrainingFile,
        //filterOnKeypress: true,
        getCellCSSText: function (record) {
            if (record.personTypeNum == 1) {
                return null;
            } else if (record.personTypeNum == 2) {
                return "color:brown;font-size: 12px;";
            } else
                return "color:red;font-size: 12px;";

        },
        gridComponents: [DynamicForm_TrainingFile, isc.ToolStrip.create({
            members: [
                excelBtn
            ]
        }), "header", "filterEditor", "body"],
        fields: [
            {name: "courseTitle"},
            {name: "courseCode"},
            {name: "classCode", hidden: true},
            {name: "termTitleFa"},
            {name: "duration"},
            {
                name: "startDate",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "endDate",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "runType"},
            {name: "classStatus"},
            {name: "score", hidden: true},
            {name: "scoresState"},
            {name: "companyName"},
            {name: "complex"},
            {name: "assistant"},
            {name: "affairs"},
            {name: "postTitle"},
            {name: "postCode", hidden: true},
            {name: "personType", hidden: true},
            {name: "personnelCode", hidden: true},
            {name: "postGradeTitle"},
            {name: "teacher", hidden: true},
            {name: "classId", hidden: true}
        ]
    });

    var VLayout_Body_Training_File = isc.VLayout.create({
        members: [
            DynamicForm_TrainingFile,
            isc.VLayout.create({
                overflow: "auto",
                align: "top",
                members: [
                    ListGrid_TrainingFile_TrainingFileJSP
                ]
            })]
    });


    function printCertificate(cassId) {
        let criteriaForm = isc.DynamicForm.create({
            method: "Get",
            action: "<spring:url value="/anonymous/els/student/certification"/>",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "classId", type: "hidden"},
                    {name: "nationalCode", type: "hidden"}
                ]

        })
        criteriaForm.setValue("classId", cassId);
        criteriaForm.setValue("nationalCode", userNationalCode);
        criteriaForm.show();
        criteriaForm.submitForm();
    }


    //</script>