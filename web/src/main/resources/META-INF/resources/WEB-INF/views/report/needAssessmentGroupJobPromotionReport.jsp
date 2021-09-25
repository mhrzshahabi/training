<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
//<script>

    var tempPersonnelId;
    var tempPersonnelNo;
    var tempPersonnelFirstName;
    var tempPersonnelLastName;
    var tempPersonnelNationalCode;
    var tempPostId;
    var tempPostTitle;
    var tempPostCode;

    const needsAssessmentReportsUrl = rootUrl + "/needsAssessment-reports";

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    PersonnelDS_NeedAssesmentGroupreport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "postCode",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "ccpArea",
                title: "<spring:message code="reward.cost.center.area"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "ccpAssistant",
                title: "<spring:message code="reward.cost.center.assistant"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code="reward.cost.center.affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "ccpSection",
                title: "<spring:message code="reward.cost.center.section"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "ccpUnit",
                title: "<spring:message code="reward.cost.center.unit"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
        ],
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "active", operator: "equals", value: 1}, {
                fieldName: "deleted",
                operator: "equals",
                value: 0
            }]
        },
    });

    PostDS_needAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {
                name: "postGradeTitleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains"
            },
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    needAssessmentGroupResultDataSource = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "excelReference", hidden: true},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>"},
            {name: "createDate", title: "<spring:message code="create.date"/>"},
        ],
        fetchDataURL: needsAssessmentReportsUrl + "/getGroupJobPromotionsList"
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refresh_needAssessment_results() {
        needAssessmentGroupResultGrid.invalidateCache();
    };

    // ------------------------------------------- ToolStrip -------------------------------------------
    NeedAssessmentResultTS = isc.ToolStrip.create({
        members: [
            isc.TrRefreshBtn.create({
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_needAssessment_results();
                }
            }),
        ]
    });

    //----------------------------------------------------Main Form------------------------------------------------
    var initialLayoutStyle = "vertical";
    var DynamicForm_needAssessment_MainReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%", "5%", "25%"],
        fields: [
            {
                name: "personnelCode",
                title: "<spring:message code='personnel.no'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                autoFetchData: false,
                displayField: "personnelNo",
                valueField: "id",
                optionDataSource: PersonnelDS_NeedAssesmentGroupreport,
                filterFields: ["firstName", "lastName", "nationalCode", "personnelNo2", "personnelNo"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: true,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {name: "firstName"},
                    {name: "lastName"},
                    {
                        name: "nationalCode",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "personnelNo",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "personnelNo2",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    }
                ],
                changed: function (form, item, value) {

                    var record = DynamicForm_needAssessment_MainReport.getField("personnelCode").getSelectedRecord();
                    tempPersonnelId = null;
                    tempPersonnelNo = null;
                    tempPersonnelFirstName = null;
                    tempPersonnelLastName = null;
                    tempPersonnelNationalCode = null;

                    tempPersonnelId = record.id;
                    tempPersonnelNo = record.personnelNo;
                    tempPersonnelFirstName = record.firstName;
                    tempPersonnelLastName = record.lastName;
                    tempPersonnelNationalCode = record.nationalCode;
                    console.log("tempPersonnelId," +
                        "tempPersonnelCode, " +
                        "tempPersonnelFirstName , " +
                        "tempPersonnelLastName", tempPersonnelId,
                        tempPersonnelNo,
                        tempPersonnelFirstName,
                        tempPersonnelLastName);
                }
            },
            {
                name: "postId",
                title: "<spring:message code="post"/>",
                editorType: "ComboBoxItem",
                optionDataSource: PostDS_needAssessment,
                valueField: "id",
                displayField: "titleFa",
                sortField: "titleFa",
                pickListFields: [{name: "code"}, {name: "titleFa"}, {name: "jobTitleFa"}, {name: "postGradeTitleFa"}],
                filterFields: [{name: "titleFa"},],
                changed: function (form, item, value) {
                    var record1 = DynamicForm_needAssessment_MainReport.getField("postId").getSelectedRecord();
                    tempPostId = null;
                    tempPostTitle = null;
                    tempPostCode = null;

                    tempPostId = record1.id;
                    tempPostTitle = record1.titleFa;
                    tempPostCode = record1.code;
                }
            },
        ]
    });

    // var DynamicForm_SelectPeople_needAssessmentGroupReport = isc.DynamicForm.create({
    //     align: "center",
    //     titleWidth: 0,
    //     titleAlign: "center",
    //     width: 500,
    //     height: 300,
    //     fields: [
    //         {
    //             name: "people.code",
    //             align: "center",
    //             title: "",
    //             editorType: "ComboBoxItem",
    //             multiple: true,
    //             defaultValue: null,
    //             changeOnKeypress: true,
    //             hint: "پرسنل مورد نظر را انتخاب کنید",
    //             showHintInField: true,
    //             pickListFields: [
    //                 {name: "firstName"},
    //                 {name: "lastName"},
    //                 {
    //                     name: "nationalCode",
    //                     filterEditorProperties: {
    //                         keyPressFilter: "[0-9]"
    //                     }
    //                 },
    //                 {
    //                     name: "personnelNo",
    //                     filterEditorProperties: {
    //                         keyPressFilter: "[0-9]"
    //                     }
    //                 },
    //                 {
    //                     name: "personnelNo2",
    //                     filterEditorProperties: {
    //                         keyPressFilter: "[0-9]"
    //                     }
    //                 }
    //             ],
    //             displayField: "personnelNo",
    //             comboBoxWidth: 500,
    //             valueField: "id",
    //             layoutStyle: initialLayoutStyle,
    //             optionDataSource: PersonnelDS_NeedAssesmentGroupreport
    //         },
    //     ],
    //
    // });

    // var gridLable = isc.Label.create({
    //     contents: "پرسنل انتخاب شده",
    //     top: 280,
    //     width: "90%",
    //     height: 25,
    //     autoDraw: true,
    //     baseStyle: "exampleSeparator"
    // });


    // ---------------------------------Grid1--------------------------------------

    var needAssessmentGrid1 = isc.TrLG.create({
        top: 250,
        width: "1070",
        height: 250,
        canEdit: true,
        canRemoveRecords: true,
        autoDraw: false,
        ID: "orderListGrid",
        modalEditing: true,
        autoFetchData: false,
        showFilterEditor: false,
        fields: [
            {name: "personnelId", canEdit: false, hidden: true},
            {
                name: "personnelPersonnelNo",
                title: "<spring:message code="personnel.no"/>",
                autoFitWidth: true,
                canEdit: false
            },
            {
                name: "personnelNationalCode",
                title: "<spring:message code="national.code"/>",
                autoFitWidth: true,
                canEdit: false
            },
            {
                name: "personnelFirstName",
                title: "<spring:message code="firstName"/>",
                autoFitWidth: true,
                canEdit: false
            },
            {name: "personnelLastName", title: "<spring:message code="lastName"/>", autoFitWidth: true, canEdit: false},
            {name: "postId", canEdit: false, hidden: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", canEdit: false},
            {name: "postTitle", title: "<spring:message code="post.title"/>", canEdit: false},
        ]
    });

    var IButton_NeedAssessment_add2_Report = isc.IButtonSave.create({
        top: 200,
        autoFit: true,
        title: "اضافه کردن به لیست",
        click: function () {
            if (DynamicForm_needAssessment_MainReport.getValue("personnelCode") == null || DynamicForm_needAssessment_MainReport.getValue("personnelCode") == undefined) {
                createDialog("info", " پرسنلی انتخاب نشده.");
                return;
            }
            if (DynamicForm_needAssessment_MainReport.getValue("postId") == null || DynamicForm_needAssessment_MainReport.getValue("postId") == undefined) {
                createDialog("info", " پستی انتخاب نشده.");
                return;
            }
            needAssessmentGrid1.addData({
                'personnelId': tempPersonnelId,
                'personnelPersonnelNo': tempPersonnelNo,
                'personnelFirstName': tempPersonnelFirstName,
                'personnelLastName': tempPersonnelLastName,
                'personnelNationalCode': tempPersonnelNationalCode,
                'postId': tempPostId,
                'postCode': tempPostCode,
                'postTitle': tempPostTitle
            });
            DynamicForm_needAssessment_MainReport.getField("personnelCode").setValue(null);

            // this.addData({'id': dropRecords[i].id, 'title': dropRecords[i].title});

        }
    });

    function print_OperationalUnitListGrid2(ref, name) {

        fetch("/training/api/needsAssessment-reports/getGroupJobPromotionsResult/" + ref, {
            method: 'GET', // *GET, POST, PUT, DELETE, etc.
            headers: {
                'Content-Type': 'application/json',
                "Authorization": "Bearer <%= accessToken %>"
            }
        }).then(res => res.blob())
            .then(blob => {
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = name + ".xlsx";
                document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
                a.click();
                a.remove();  //afterwards we remove the element again
            });

    }

    // ---------------------------------Grid3--------------------------------------
    var needAssessmentGroupResultGrid = isc.TrLG.create({
        top: 400,
        width: "740",
        height: 300,
        autoDraw: true,
        showFilterEditor: false,
        filterOnKeypress: false,
        ID: "resultListGrid",
        autoFetchData: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        sortField: "createDate",
        sortDirection: "descending",
        dataSource: needAssessmentGroupResultDataSource,
        gridComponents: [NeedAssessmentResultTS, "filterEditor", "header", "body",],
        fields: [
            {name: "id", canEdit: false, hidden: true},
            {name: "excelReference", canEdit: false, hidden: true},
            {
                name: "createdBy",
                width: 150,
                canEdit: false
            },
            {
                name: "createDate",
                width: 400,
                canEdit: false
            },
            {name: "excelBtn", title: " ", width: 130},
        ],
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "excelBtn") {
                let button = isc.ToolStripButtonExcel.create({
                    margin: 5,
                    click: function () {
                        console.log("USERnAME............", "${username}");
                        console.log("record", record, record.excelReference);
                        print_OperationalUnitListGrid2(record.excelReference,
                            record.createDate + "گزارش_انتصاب_سمت_گروهی_مورخ_");
                    }
                });
                return button;
            }
        }
    });


    // ---------------------------------Grid2--------------------------------------

    var needAssessmentGrid = isc.TrLG.create({
        top: 200,
        width: "1070",
        height: 200,
        canEdit: true,
        autoDraw: false,
        ID: "orderList",
        modalEditing: true,
        autoFetchData: false,
        showFilterEditor: false,

        fields: [
            {
                name: "personnelId",
                title: "<spring:message code='personnel.no'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: 500,
                changeOnKeypress: true,
                autoFetchData: false,
                displayField: "personnelNo",
                valueField: "id",
                optionDataSource: PersonnelDS_NeedAssesmentGroupreport,
                filterFields: ["firstName", "lastName", "nationalCode", "personnelNo2", "personnelNo"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListWidth: 500,
                // required: true,
                // errorMessage: "فیلد اجباری است",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {name: "firstName"},
                    {name: "lastName"},
                    {
                        name: "nationalCode",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "personnelNo",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "personnelNo2",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    }
                ]
            },
            {
                name: "postId",
                title: "<spring:message code="post"/>",
                editorType: "ComboBoxItem",
                width: 500,
                optionDataSource: PostDS_needAssessment,
                valueField: "id",
                pickListWidth: 500,
                displayField: "titleFa",
                sortField: "titleFa",
                pickListFields: [{name: "code"}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}],
                filterFields: [{name: "titleFa"},],
                // required: true,
            }
        ]
    });


    // var IButton_NeedAssessment_add_Report = isc.IButtonSave.create({
    //     top: 300,
    //     autoFit: true,
    //     title: "اضافه کردن ردیف",
    //     click: "orderList.startEditingNew()"
    // });
    // var IButton_NeedAssessment_delete_Report = isc.IButtonCancel.create({
    //     top: 535,
    //     autoFit: true,
    //     title: "پاک کردن ردیف",
    //     // click: "needAssessmentGrid.data.removeAt(selectedRecord.rowNum);"
    //     click: function () {
    //         if (needAssessmentGrid1.getSelectedRecord()) {
    //             needAssessmentGrid1.removeData(needAssessmentGrid1.getSelectedRecord())
    //         }
    //     }
    // });

    IButton_NeedAssessment_Excel_Report = isc.IButton.create({
baseStyle: 'MSG-btn-orange',
icon: "<spring:url value="excel.png"/>",
top: 260,
        title: "درخواست گزارش اکسل",
        width: 300,
        click: function () {
            if (needAssessmentGrid.getData() == null || needAssessmentGrid1.getData().length == 0) {
                createDialog("info", "لیست خالی است", "<spring:message code="message"/>");
                return;
            } else {

                let gridData = needAssessmentGrid1.getData();
                var needAssessmentGroupJobPromotionDtos = [];

                for (let i = 0; i < gridData.length; i++) {
                    if (gridData[i] != null && gridData[i].personnelId !== null && gridData[i].personnelId !== "" && gridData[i].personnelId !== undefined &&
                        gridData[i].postId !== null && gridData[i].postId !== "" && gridData[i].postId !== undefined) {
                        let needAssessmentGroupJobPromotionDto = {
                            personnelId: gridData[i].personnelId,
                            postId: gridData[i].postId
                        }
                        needAssessmentGroupJobPromotionDtos.add(needAssessmentGroupJobPromotionDto);
                    } else {
                        createDialog("info", "لیست شامل فیلد خالی است", "<spring:message code="message"/>");
                        return;
                    }
                }
                var requestDto = {
                    needAssessmentGroupJobPromotionDtos: needAssessmentGroupJobPromotionDtos,
                    userName: "${username}"
                };
                console.log("requestDto", requestDto);


                wait.show();
                isc.RPCManager.sendRequest({
                    actionURL: needsAssessmentReportsUrl + "/getGroupJobPromotions",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    willHandleError: true,
                    httpMethod: "POST",
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    data: JSON.stringify(requestDto),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        wait.close();
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            var OK = isc.Dialog.create({
                                message: "عملیات ارسال با موفقیت انجام شد. فایل خروجی مورد نظر تا دقایقی دیگر به لیست خروجی های گزارش اضافه می شود",
                                icon: "[SKIN]say.png",
                                title: "انجام شد"
                            });
                            IButton_NeedAssessment_Excel_Report.setDisabled(true)
                        } else {
                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                        }
                    }
                });

            }
        }
    });


    //----------------------------------- layOut -----------------------------------------------------------------------


    var HLayOut_Confirm_excel_report = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 3,
        members: [
            IButton_NeedAssessment_Excel_Report
        ]
    });
    // var HLayOut_grid_buttons_report = isc.TrHLayoutButtons.create({
    //     layoutMargin: 5,
    //     showEdges: false,
    //     edgeImage: "",
    //     width: "70%",
    //     height: "1%",
    //     alignLayout: "center",
    //     padding: 4,
    //     members: [
    //         IButton_NeedAssessment_delete_Report,
    //     ]
    // });
    var HLayOut_grid_add_buttons_report = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "1%",
        alignLayout: "center",
        padding: 4,
        members: [
            IButton_NeedAssessment_add2_Report,
        ]
    });
    var HLayOut_inputs_report = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "60%",
        height: "1%",
        alignLayout: "center",
        padding: 4,
        members: [
            DynamicForm_needAssessment_MainReport
        ]
    });

    var VLayout_Body_NeedAssessment_Report = isc.TrVLayout.create({
        members: [
            HLayOut_inputs_report,
            // needAssessmentGrid,
            HLayOut_grid_add_buttons_report,
            needAssessmentGrid1,
            // HLayOut_grid_buttons_report,
            HLayOut_Confirm_excel_report,
            needAssessmentGroupResultGrid
        ]
    });


//</script>