<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

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
                name: "groupBtn",
                ID: "groupBtn",
                title: "گزارش گروهی پرونده آموزشی",
                type: "ButtonItem",
                startRow: false,
                endRow: false,
                click() {
                    trainingFileInGroup();
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
    function printInGroup(data) {
        let criteriaObject = {};
        criteriaObject.fieldName = "nationalCodes";
        criteriaObject.operator = "inSet";
        criteriaObject.value = data;
         let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/export/excel/group/training-file",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "criteria", type: "hidden"},
                    {name: "myToken", type: "hidden"}
                ]
        });
        downloadForm.setValue("myToken", "<%=accessToken%>");
        downloadForm.setValue("criteria", JSON.stringify(criteriaObject));
        downloadForm.show();
        downloadForm.submitForm();


        <%--isc.RPCManager.sendRequest({--%>
        <%--    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
        <%--    useSimpleHttp: true,--%>
        <%--    contentType: "application/json; charset=utf-8",--%>
        <%--    actionURL: baseUrl + "/export/excel/group/training-file",--%>
        <%--    httpMethod: "POST",--%>
        <%--    data: JSON.stringify(data),--%>
        <%--    serverOutputAsString: false,--%>
        <%--    callback: function (resp) {--%>

        <%--    }--%>
        <%--});--%>
    }

    function trainingFileInGroup() {
        let TabSet_trainingFileInGroup_JspStudent = isc.TabSet.create({
            ID: "trainingFileleftTabSet",
            autoDraw: false,
            tabBarPosition: "top",
            width: "100%",
            height: 115,
            tabs: [
                {
                    title: "فایل اکسل", width: 200, overflow: "hidden",
                    pane: isc.DynamicForm.create({
                        height: "100%",
                        width: "100%",
                        numCols: 4,
                        colWidths: ["10%", "40%", "20%", "20%"],
                        fields: [
                            {
                                ID: "DynamicForm_GroupInsert_FileUploader_trainingFile",
                                name: "DynamicForm_GroupInsert_FileUploader_trainingFile",
                                type: "imageFile",
                                title: "مسیر فایل",
                            },
                            {
                                type: "button",
                                startRow: false,
                                title: "آپلود فايل",
                                click: function () {
                                    let address = DynamicForm_GroupInsert_FileUploader_trainingFile.getValue();

                                    if (address == null) {
                                        createDialog("info", "فايل خود را انتخاب نماييد.");
                                    } else {
                                        var ExcelToJSON = function () {

                                            this.parseExcel = function (file) {
                                                var reader = new FileReader();
                                                var records = [];

                                                reader.onload = function (e) {
                                                    var data = e.target.result;
                                                    var workbook = XLSX.read(data, {
                                                        type: 'binary'
                                                    });
                                                    var isEmpty = true;

                                                    workbook.SheetNames.forEach(function (sheetName) {
                                                        // Here is your object
                                                        var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                        //var json_object = JSON.stringify(XL_row_object);

                                                        for (let i = 0; i < XL_row_object.length; i++) {
                                                            if (isNaN(Object.values(XL_row_object[i])[0])) {
                                                                continue;
                                                            } else if (GroupSelectedPersonnelTrainingFileLG.data.filter(function (item) {
                                                                return item.nationalCode == Object.values(XL_row_object[i])[0];
                                                            }).length == 0) {
                                                                let current = {
                                                                    nationalCode: Object.values(XL_row_object[i])[0],
                                                                };
                                                                records.add(current);
                                                                isEmpty = false;

                                                                continue;
                                                            } else {
                                                                isEmpty = false;

                                                                continue;
                                                            }
                                                        }

                                                        DynamicForm_GroupInsert_FileUploader_trainingFile.setValue('');
                                                    });

                                                    if (records.length > 0) {

                                                        let uniqueRecords = [];

                                                        for (let i = 0; i < records.length; i++) {
                                                            if (uniqueRecords.filter(function (item) {
                                                                return item.nationalCode == records[i].nationalCode;
                                                            }).length == 0) {
                                                                uniqueRecords.push(records[i]);
                                                            }
                                                        }


                                                        GroupSelectedPersonnelTrainingFileLG.setData(GroupSelectedPersonnelTrainingFileLG.data.concat(uniqueRecords));
                                                        GroupSelectedPersonnelTrainingFileLG.invalidateCache();
                                                        GroupSelectedPersonnelTrainingFileLG.fetchData();


                                                        checkPersonnelRegisteredResponse(checkPersonnelNationalCodes, uniqueRecords.map(function (item) {
                                                            return item.nationalCode;
                                                        }), false);


                                                        createDialog("info", "فایل به لیست اضافه شد.");
                                                    } else {
                                                        if (isEmpty) {
                                                            createDialog("info", "خطا در محتویات فایل");
                                                        } else {
                                                            createDialog("info", "پرسنل جدیدی برای اضافه کردن وجود ندارد.");
                                                        }

                                                    }

                                                };

                                                reader.onerror = function (ex) {
                                                    createDialog("info", "خطا در باز کردن فایل");
                                                };

                                                reader.readAsBinaryString(file);
                                            };
                                        };
                                        let split = $('[name="DynamicForm_GroupInsert_FileUploader_trainingFile"]')[0].files[0].name.split('.');

                                        if (split[split.length - 1] == 'xls' || split[split.length - 1] == 'csv' || split[split.length - 1] == 'xlsx') {
                                            var xl2json = new ExcelToJSON();
                                            xl2json.parseExcel($('[name="DynamicForm_GroupInsert_FileUploader_trainingFile"]')[0].files[0]);
                                        } else {
                                            createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                        }

                                    }
                                }
                            },
                            {
                                type: "button",
                                title: "فرمت فايل ورودی",
                                click: function () {
                                    window.open("excel/personel-nationalCode.xlsx");
                                }
                            }
                        ]
                    })
                }
            ]
        });

        let Win_training_file_GroupInsert = isc.Window.create({
            ID: "Win_training_file_GroupInsert",

            width: 1450,
            height: 750,
            minWidth: 1450,
            minHeight: 500,
            autoSize: false,
            overflow: "hidden",
            title: "اضافه کردن گروهی",
            items: [isc.HLayout.create({
                width: 1450,
                height: "88%",
                autoDraw: false,
                overflow: "auto",
                align: "center",
                members: [
                    isc.TrLG.create({
                        ID: "GroupSelectedPersonnelTrainingFileLG",
                        showFilterEditor: false,
                        editEvent: "click",
                        //listEndEditAction: "next",
                        enterKeyEditAction: "nextRowStart",
                        canSort: false,
                        canEdit: true,
                        filterOnKeypress: true,
                        selectionType: "single",
                        fields: [
                            {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true, width: "10%"},
                            {name: "nationalCode", title: "<spring:message code="national.code"/>", canEdit: false, autoFithWidth: true},
                        ],
                        gridComponents: [TabSet_trainingFileInGroup_JspStudent, "header", "body"],
                        canRemoveRecords: true,
                        deferRemoval: true,
                        removeRecordClick: function (rowNum) {
                            GroupSelectedPersonnelTrainingFileLG.data.removeAt(rowNum);
                        }
                    })
                ]
            }),
                isc.TrHLayoutButtons.create({
                    members: [
                        isc.IButtonSave.create({
                            top: 260,
                            title: "گزارش اکسل",
                            align: "center",
                            icon: "[SKIN]/actions/excel.png",
                            click: function () {
                                let len = GroupSelectedPersonnelTrainingFileLG.data.length;
                                let list = GroupSelectedPersonnelTrainingFileLG.data;
                                let result = [];

                                for (let index = 0; index < len; index++) {
                                    if (list[index].nationalCode != "" && list[index].nationalCode != null && typeof (list[index].nationalCode) != "undefined") {
                                        if (result.filter(function (item) {
                                            return (item.nationalCode && item.nationalCode == GroupSelectedPersonnelTrainingFileLG.data[index].nationalCode);
                                        }).length == 0) {
                                            result.push(list[index].nationalCode)
                                        }
                                    }
                                }
                                if (len>0){
                                    printInGroup(result)
                                }else {
                                    createDialog("info", "فایل با کد ملی اضافه نشده است");

                                }


                            }
                        }), isc.IButtonCancel.create({
                            top: 260,
                            title: "<spring:message code='cancel'/>",
                            align: "center",
                            icon: "[SKIN]/actions/cancel.png",
                            click: function () {
                                Win_training_file_GroupInsert.close();
                            }
                        })
                    ]
                })
            ]
        });
        TabSet_trainingFileInGroup_JspStudent.selectTab(0);
        Win_training_file_GroupInsert.show();
    }





    //</script>