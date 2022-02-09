<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    <%--<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>--%>
    var sumSyllabus;
    var methodGoal = "GET";
    var urlGoal = goalUrl;
    var methodSyllabus = "GET";
    var urlSyllabus = syllabusUrl;
    var selectedRecord = 0;

    var RestDataSourceGoalEDomainType = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: enumUrl + "eDomainType"
    });
    let RestDataSource_GoalAll = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: "true", hidden: "true"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "code"}, {name: "description"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        // fetchDataURL: courseUrl + "goal/" + courseRecord.id
    });
    let RestDataSource_Syllabus_JspGoal = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "سرفصل ها", align: "center", width: "60%"},
            {name: "edomainType.titleFa", title: "حیطه", align: "center", width: "20%"},
            {name: "practicalDuration", title: "مدت زمان عملی", type: "float", align: "center", width: "20%"},
            {name: "theoreticalDuration", title: "مدت زمان تئوری", type: "float", align: "center", width: "20%"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
    });

    let RestDataSource_category = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });

    let RestDataSourceSubCategory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });

    let DynamicForm_Goal = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                validators: [TrValidators.NotEmpty],
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                keyPressFilter: "[a-z|A-Z|0-9 ]",
            },
            {
                name: "categoryId",
                title: "گروه",
                displayField: "titleFa",
                textAlign: "center",
                valueField: "id",
                disabled: true,
                filterOperator: "equals",
                autoFitWidth: true,
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                pickListProperties:{
                    showFilterEditor: false
                },
                sortField: ["id"],
                changed: function (form, item, value) {
                    DynamicForm_Goal.getItem("subCategoryId").enable();
                    DynamicForm_Goal.getItem("subCategoryId").setValue([]);
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                    DynamicForm_Goal.getItem("subCategoryId").fetchData();
                },
                click: function (form, item) {
                    item.fetchData();
                }
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="course_subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                disabled: true,
                required: true,
                autoFetchData: false,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                filterFields: ["titleFa"],
                sortField: ["id"],
                pickListProperties:{
                    showFilterEditor: false
                }
            },
        ],
    });
    let DynamicForm_Syllabus = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "goalId",
                title: "شماره هدف",
                required: true,
                readonly: true,
                keyPressFilter: "[0-9]",
                hidden: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "code",
                title: "کد",
                required: true,
                hidden: true,
                length: "7"
            },
            {
                name: "titleFa",
                type: "TextAreaItem",
                title: "نام فارسی",
                required: true,
                height: "50",
                hint: "Persian/فارسی",
                showHintInField: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز حداکثر پانصد کاراکتر است"
                }]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                hint: "Latin",
                showHintInField: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 3,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "نام مجاز بين سه تا دویست کاراکتر است"
                }]
            },
            {
                name: "edomainTypeId",
                title: "حیطه",
                required: true,
                pickListWidth: 210,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceGoalEDomainType,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                // filterOnKeypress: true,
                // filterFields: "titleFa",
                sortField: "id",
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "titleFa", width: "30%"}],
            },
            {
                name: "practicalDuration",
                title: "مدت زمان عملی",
                editorType: "SpinnerItem",
                writeStackedIcons: false,
                defaultValue: 0,
                keyPressFilter: "^[0-9.]",
                // keyPressFilter: "^([+-]?\\d*\\.?\\d*)$",
                min: 0,
                max: 300,
                step: 0.5,
                // change: function (form, item, value) {
                //     if (methodSyllabus == "PUT") {
                //         sumSyllabus = (ListGrid_Syllabus_Goal.getGridSummaryData().get(0).practicalDuration) - (ListGrid_Syllabus_Goal.getSelectedRecord().practicalDuration) + value;
                //     } else {
                //         sumSyllabus = (ListGrid_Syllabus_Goal.getGridSummaryData().get(0).practicalDuration) + value;
                //     }
                //     // Window_Syllabus.setStatus("طول دوره " + (courseRecord.theoryDuration) + " ساعت" + " و جمع مدت زمان سرفصل ها " + sumSyllabus + " ساعت می باشد.");
                //     // Window_Syllabus.setStatus('<p   style="background-color:Tomato;margin: 0;padding: 0 10px;">Tomato</p  >');
                // },
            },
            {
                name: "theoreticalDuration",
                title: "مدت زمان تئوری",
                editorType: "SpinnerItem",
                writeStackedIcons: false,
                defaultValue: 0,
                keyPressFilter: "^[0-9.]",
                min: 0,
                max: 300,
                step: 0.5,
                // change: function (form, item, value) {
                //     if (methodSyllabus == "PUT") {
                //         sumSyllabus = (ListGrid_Syllabus_Goal.getGridSummaryData().get(0).practicalDuration) - (ListGrid_Syllabus_Goal.getSelectedRecord().practicalDuration) + (ListGrid_Syllabus_Goal.getSelectedRecord().theoreticalDuration) + value;
                //     } else {
                //         sumSyllabus = (ListGrid_Syllabus_Goal.getGridSummaryData().get(0).practicalDuration) + (ListGrid_Syllabus_Goal.getSelectedRecord().theoreticalDuration) + value;
                //     }
                //     // Window_Syllabus.setStatus("طول دوره " + (courseRecord.theoryDuration) + " ساعت" + " و جمع مدت زمان سرفصل ها " + sumSyllabus + " ساعت می باشد.");
                //     // Window_Syllabus.setStatus('<p   style="background-color:Tomato;margin: 0;padding: 0 10px;">Tomato</p  >');
                // },
            }],
        keyPress: function () {
            if (isc.EventHandler.getKey() == "Enter") {
                DynamicForm_Syllabus.focusInNextTabElement();
            }
        }
    });

    let pdfUrlForPrint="";
    let Window_Choose_print_type = isc.Window.create({
        width: 300,
        height: 100,
        numCols: 2,
        title: "انتخاب نوع چاپ فایل",
        items: [
            isc.MyHLayoutButtons.create({
                members: [
                    isc.IButtonSave.create({
                        title: "چاپ pdf",
                        click: function () {
                            Window_Choose_print_type.close()
                            trPrintWithCriteria(pdfUrlForPrint+"/pdf",null,null);
                        }
                    }),
                    isc.IButtonSave.create({
                        title: "آرسال به اکسل",
                        click: function () {
                            Window_Choose_print_type.close()
                            trPrintWithCriteria(pdfUrlForPrint+"/excel",null,null);

                        }
                    })]
            })]
    });


    let IButton_Goal_Save = isc.IButtonSave.create({
        click: function () {
            DynamicForm_Goal.validate();
            if (DynamicForm_Goal.hasErrors()) {
                return;
            }
            let data = DynamicForm_Goal.getValues();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(urlGoal, methodGoal, JSON.stringify(data), resp => {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let responseID = JSON.parse(resp.data).id;
                    let gridState = "[{id:" + responseID + "}]";
                    simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say");
                    ListGrid_Goal_refresh();
                    ListGrid_GoalAll.invalidateCache();
                    ListGrid_CourseGoal_Goal.invalidateCache();
                    setTimeout(function () {
                        ListGrid_Goal.setSelectedState(gridState);
                    }, 0);
                    Window_Goal.close();
                } else {
                    simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")
                }
            }));
        }
    });
    var IButton_Syllabus_Save = isc.IButtonSave.create({
        click: function () {
            if(DynamicForm_Syllabus.getValue("practicalDuration")==0 && DynamicForm_Syllabus.getValue("theoreticalDuration")==0){
                createDialog("info", "مدت زمان سرفصل نمیتواند صفر باشد.");
                return;
            }
            DynamicForm_Syllabus.validate();
            if (DynamicForm_Syllabus.hasErrors()) {
                return;
            }
            const titleFa = DynamicForm_Syllabus.getValue('titleFa');
            const titleEn = DynamicForm_Syllabus.getValue('titleEn');
            const goalId = DynamicForm_Syllabus.getValue('goalId');
            const practicalDuration = DynamicForm_Syllabus.getValue('practicalDuration');
            const theoreticalDuration = DynamicForm_Syllabus.getValue('theoreticalDuration');
            const eDomainType = DynamicForm_Syllabus.getValue('edomainTypeId');
            const data = {
                "titleFa": titleFa,
                "titleEn": titleEn,
                "goalId": goalId,
                "practicalDuration": practicalDuration,
                "theoreticalDuration": theoreticalDuration,
                "eDomainTypeId": eDomainType
            };
            // var data = DynamicForm_Syllabus.getValuesForm();
            wait.show()
            isc.RPCManager.sendRequest({
                actionURL: urlSyllabus,
                httpMethod: methodSyllabus,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    wait.close()
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var responseID = JSON.parse(resp.data).id;
                        evalDomain();
                        var gridState = "[{id:" + responseID + "}]";
                        simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say");
                        ListGrid_Syllabus_Goal.invalidateCache();
                        setTimeout(function () {
                            ListGrid_Syllabus_Goal.setSelectedState(gridState);
                        }, 900);
                        setTimeout(function () {
                            sumSyllabus = Math.ceil(ListGrid_Syllabus_Goal.getGridSummaryData().get(0).practicalDuration + ListGrid_Syllabus_Goal.getGridSummaryData().get(0).theoreticalDuration);
                            if (sumSyllabus !== (courseRecord.duration)) {
                                isc.Dialog.create({
                                    message: "مدت زمان اجرای دوره به " + sumSyllabus + " ساعت تغییر کند؟",
                                    icon: "[SKIN]ask.png",
                                    title: "سوال؟",
                                    buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({title: "خیر"})],
                                    buttonClick: function (button, index) {
                                        if (index) {
                                            this.close();
                                        } else {
                                            this.close();
                                            vm_JspCourse.getItem("duration").setValue(sumSyllabus);
                                            courseSaveBtn.click();
                                            // setTimeout(function () {
                                            //     courseSaveBtn.click();
                                            // }, 500)
                                        }
                                    },
                                });
                            }
                        }, 1500);
                        Window_Syllabus.close();

                    } else {
                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error");
                    }

                }
            });
        }
    });

    var Hlayout_Goal_SaveOrExit = isc.TrHLayoutButtons.create({
        members: [IButton_Goal_Save, isc.IButtonCancel.create({
            ID: "IButton_Goal_Exit",
            click: function () {
                DynamicForm_Goal.clearValues();
                Window_Goal.close();
            }
        })]
    });

    var Hlayout_Syllabus_SaveOrExit = isc.TrHLayoutButtons.create({
        // layoutMargin: 5,
        // showEdges: false,
        // edgeImage: "",
        // width: "100%",
        // align: "center",
        // padding: 10,
        // membersMargin: 10,
        members: [IButton_Syllabus_Save, isc.IButtonCancel.create({
            ID: "IButton_Syllabus_Exit",
            // orientation: "vertical",
            click: function () {
                Window_Syllabus.close();
            }
        })]
    });

    var Window_Syllabus = isc.Window.create({
        title: "سرفصل",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        showFooter: true,
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Syllabus, Hlayout_Syllabus_SaveOrExit]
        })],
        width: "400",
    });

    var Window_Goal = isc.Window.create({
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Goal, Hlayout_Goal_SaveOrExit]
        })],
        width: "400",
        height: "150",
        show(){
            DynamicForm_Goal.setValue("categoryId", courseRecord.category.id);
            DynamicForm_Goal.setValue("subCategoryId", courseRecord.subCategory.id);
            this.Super("show", arguments);
        }
    });

    var Menu_ListGrid_Syllabus_Goal = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات",
            <%--icon: "<spring:url value="refresh.png"/>", --%>
            click: function () {
                ListGrid_Syllabus_Goal_refresh();
            }
        }, {
            title: "ایجاد",
            <%--icon: "<spring:url value="create.png"/>",--%>
            click: function () {
                ListGrid_Syllabus_Goal_Add()
            }
        }, {
            title: "ویرایش",
            <%--icon: "<spring:url value="edit.png"/>", --%>
            click: function () {
                ListGrid_Syllabus_Goal_Edit();
            }
        }, {
            title: "حذف",
            click: function () {
                ListGrid_Syllabus_Goal_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf",
            click :function(){
                trPrintWithCriteria("<spring:url value="/syllabus/print-one-course/"/>" + courseRecord.id +"/pdf" ,null,null);
            }
        }, {
            title: "ارسال به Excel",
            click: function () {
                trPrintWithCriteria("<spring:url value="/syllabus/print-one-course/"/>" + courseRecord.id +"/excel" ,null,null);
            }
        }, {
            title: "ارسال به Html",
            click: function () {
                trPrintWithCriteria("<spring:url value="/syllabus/print-one-course/"/>" + courseRecord.id +"/html" ,null,null);
            }
        }]
    });
    var Menu_ListGrid_Goal = isc.Menu.create({
        width: 150,
        data: [
            {
                title: "بازخوانی اطلاعات",
                click: function () {
                    ListGrid_Goal_refresh();
                }
            },
            //     {
            //     title: "ایجاد",
            //     click: function () {
            //         ListGrid_Goal_Add();
            //     }
            // },
            //     {
            //         title: "ویرایش",
            //         click: function () {
            //             ListGrid_Goal_Edit();
            //         }
            //     },
            //     {
            //         title: "حذف",
            //         click: function () {
            //             ListGrid_Goal_Remove();
            //         }
            //     },
            {isSeparator: true}, {
                title: "ارسال به Pdf",
                click: function () {
                    trPrintWithCriteria("<spring:url value="goal/print-one-course/"/>" + courseRecord.id + "/pdf" ,null,null);
                }
            }, {
                title: "ارسال به Excel",
                click: function () {
                    trPrintWithCriteria("<spring:url value="/goal/print-one-course/"/>" + courseRecord.id + "/excel" ,null,null);
                }
            }, {
                title: "ارسال به Html",
                click: function () {
                    trPrintWithCriteria("<spring:url value="/goal/print-one-course/"/>" + courseRecord.id + "/html" ,null,null);
                }
            }]
    });

    var ListGrid_Goal = isc.TrLG.create({
        width: "*",
        height: "100%",
        dataSource: RestDataSource_CourseGoal,
        contextMenu: Menu_ListGrid_Goal,
        autoFitWidthApproach:"both",
        doubleClick: function () {
            ListGrid_Goal_Edit();
        },
        fields: [
            {name: "titleFa", title: "<spring:message code="goal.title.fa"/>", align: "center", autoFitWidth: true},
            {
                name: "categoryId",
                title: "گروه",
                optionDataSource: RestDataSource_category,
                displayField: "titleFa",
                valueField: "id",
                filterOperator: "equals",
                canFilter:"none",
                autoFitWidth: true,
            },
            {
                name: "subCategoryId",
                title: "زیر گروه",
                optionDataSource: RestDataSource_SubCategory,
                displayField: "titleFa",
                valueField: "id",
                filterOperator: "equals",
                autoFitWidth: true,
            },
        ],
        selectionType: "multiple",
        selectionChanged: function (record) {
            selectedRecord = record.id;
            ListGrid_Syllabus_Goal.invalidateCache();
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        filterOnKeypress: true,
    });
    var ListGrid_Syllabus_Goal = isc.TrLG.create({
        width: "*",
        height: "100%",
        // canHover:true,
        // autoFitWidthApproach:"both",
        dataSource: RestDataSource_Syllabus,
        showGridSummary: true,
        contextMenu: Menu_ListGrid_Syllabus_Goal,
        doubleClick: function () {
            ListGrid_Syllabus_Goal_Edit();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            if (ListGrid_Goal.getSelectedRecord() != null && record.goalId == selectedRecord) {
                return "color: brown;font-size: 14px;";
            } else {
                return "color:gray;font-size: 10px;";
            }
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد سرفصل", align: "center", hidden: true},
            {
                name: "titleFa", title: "نام فارسی سرفصل", align: "center",
                autoFitWidth: true,
            },
            {
                name: "titleEn", title: "نام لاتین سرفصل", align: "center",
            },
            {name: "edomainType.titleFa", title: "حیطه", align: "center", sortNormalizer(record){
                    return record.edomainType.titleFa;
                }},
            {
                name: "practicalDuration",
                title: "مدت زمان عملی",
                align: "center",
                summaryFunction: "sum",
                format: "0.00 ساعت"
            },
            {
                name: "theoreticalDuration",
                title: "مدت زمان تئوری",
                align: "center",
                summaryFunction: "sum",
                format: "0.00 ساعت"
            },
            {name: "version", title: "version", canEdit: false, hidden: true},
            {
                name: "goal.titleFa", hidden: true,
                autoFitWidth: true,
            }
        ],
        sortField: "goalId",
        sortDirection: "descending",
        // dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        allowAdvancedCriteria: true,
    });
    var ListGrid_GoalAll = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        showHeader: true,
        expansionFieldImageShowSelected: false,
        canExpandRecords: true,
        expansionMode: "related",
        detailDS: RestDataSource_Syllabus_JspGoal,
        expansionRelatedProperties: {
            border: "1px solid inherit",
            margin: 5
        },
        dataSource: RestDataSource_GoalAll,
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "كل اهداف", align: "center", width:"60%"},
            {
                name: "categoryId",
                title: "گروه",
                optionDataSource: RestDataSource_category,
                displayField: "titleFa",
                valueField: "id",
                canFilter: false,
                width:"20%"
            },
            {
                name: "subCategoryId",
                title: "زیر گروه",
                optionDataSource: RestDataSource_SubCategory,
                displayField: "titleFa",
                valueField: "id",
                canFilter: false,
                width:"20%"
            },
        ],
        selectionType: "multiple",
        selectionChanged: function (record, state) {
            RestDataSource_Syllabus_JspGoal.fetchDataURL = goalUrl + record.id + "/syllabus";
        },
        sortField: 2,
        sortDirection: "ascending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            removeAsListGrid();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            return record.categoryId === courseRecord.category.id ? "color:black": "color:red";
        }
    });
    var ListGrid_CourseGoal_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        alternateRecordStyles: true,
        expansionFieldImageShowSelected: false,
        canExpandRecords: true,
        expansionMode: "related",
        detailDS: RestDataSource_Syllabus_JspGoal,
        expansionRelatedProperties: {
            border: "1px solid inherit",
            margin: 5
        },
        dataSource: RestDataSource_CourseGoal,
        selectionChanged: function (record, state) {
            RestDataSource_Syllabus_JspGoal.fetchDataURL = goalUrl + record.id + "/syllabus";
        },
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "اهداف دوره", align: "center"},
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            addToListGrid()
        },
    });
    var ToolStripButton_Syllabus_Edit = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {
            ListGrid_Syllabus_Goal_Edit();
        }
    });
    var ToolStripButton_Syllabus_Add = isc.ToolStripButtonAdd.create({

        title: "ایجاد",
        click: function () {
            ListGrid_Syllabus_Goal_Add();
        }
    });
    var ToolStripButton_Syllabus_Remove = isc.ToolStripButtonRemove.create({

        title: "حذف",
        click: function () {
            ListGrid_Syllabus_Goal_Remove();
        }
    });
    var Menu_Print_GoalJsp = isc.Menu.create({
        ID: "menuPalette",
        autoDraw: false,
        showShadow: true,
        shadowDepth: 10
    });
    var ToolStripButton_Syllabus_Print = isc.ToolStripMenuButton.create({
        autoDraw: false,
        width: 100,
        title: " چاپ pdf / ارسال به اکسل",
        showMenuOnRollOver: true,
        menu: menuPalette,
        mouseMove: function () {
            if (ListGrid_Goal.getSelectedRecord() == null) {
                Menu_Print_GoalJsp.setData([
                    {
                        title: "اهداف دوره " + '"' + courseRecord.titleFa + '"',
                        click :function(){
                            pdfUrlForPrint="<spring:url value="goal/print-one-course/"/>" +courseRecord.id ;
                            Window_Choose_print_type.show()
                            <%--trPrintWithCriteria("<spring:url value="goal/print-one-course/"/>" +courseRecord.id + "/pdf" ,null,null);--%>
                        }
                    },
                    {isSeparator: true},
                    {
                        title: "سرفصل هاي دوره " + '"' + courseRecord.titleFa + '"',
                        click :function(){
                            pdfUrlForPrint="<spring:url value="syllabus/print-one-course/"/>" +courseRecord.id ;
                            Window_Choose_print_type.show()

                            <%--trPrintWithCriteria("<spring:url value="syllabus/print-one-course/"/>" +courseRecord.id + "/pdf" ,null,null);--%>
                        }
                    }
                ])
            } else {
                Menu_Print_GoalJsp.setData([
                    {
                        title: "اهداف دوره " + '"' + courseRecord.titleFa + '"',
                        click :function(){
                            pdfUrlForPrint="<spring:url value="goal/print-one-course/"/>" +courseRecord.id ;
                            Window_Choose_print_type.show()
                            <%--trPrintWithCriteria("<spring:url value="goal/print-one-course/"/>" +courseRecord.id + "/pdf" ,null,null);--%>
                        }
                    },
                    {isSeparator: true},
                    {
                        title: "سرفصل هاي دوره " + '"' + courseRecord.titleFa + '"',
                        click :function(){
                            pdfUrlForPrint="<spring:url value="syllabus/print-one-course/"/>" +courseRecord.id ;
                            Window_Choose_print_type.show()
                            <%--trPrintWithCriteria("<spring:url value="syllabus/print-one-course/"/>" +courseRecord.id + "/pdf" ,null,null);--%>
                        }
                    },
                    {
                        title: "سرفصل هاي هدف " + '"' + ListGrid_Goal.getSelectedRecord().titleFa + '"',
                        click :function(){
                            pdfUrlForPrint="<spring:url value="syllabus/print-one-goal/"/>" + ListGrid_Goal.getSelectedRecord().id;
                            Window_Choose_print_type.show()
                            <%--trPrintWithCriteria("<spring:url value="syllabus/print-one-goal/"/>" + ListGrid_Goal.getSelectedRecord().id+"/pdf" ,null,null);--%>
                        }
                    }])
            }
        }
    });
    var ToolStripButton_Goal_Refresh = isc.ToolStripButtonRefresh.create({
        title: "بازخوانی",
        click: function () {
            ListGrid_Goal_refresh();
            ListGrid_Syllabus_Goal_refresh();
        }
    });
    var ToolStripButton_Goal_Edit_WindowAllGoal = isc.ToolStripButtonEdit.create({
        title: "ویرایش",
        prompt: "اخطار<br/>ویرایش هدف در تمامی دوره های ارضا کننده هدف نیز اعمال خواهد شد.",
        hoverWidth: 320,
        click: function () {
            ListGrid_Goal_Edit(ListGrid_GoalAll);
        }
    });
    let ToolStripButton_Goal_Add = isc.ToolStripButtonAdd.create({
        title: "ایجاد",
        prompt: "تعریف هدف جدید برای دوره مذکور",
        hoverWidth: 160,
        click: function () {
            ListGrid_Goal_Add();
        }
    });

    var ToolStripButton_Goal_Remove = isc.ToolStripButtonRemove.create({
        title: "حذف",
        prompt: getFormulaMessage("اخطار","3","red","b") + "<br/>" + "هدف انتخاب شده از پایگاه داده حذف خواهد شد.",
        hoverWidth: 250,
        click: function () {
            ListGrid_Goal_Remove();
        }
    });
    var ToolStripButton_Goal_ADD = isc.ToolStripButtonAdd.create({
        //icon: "[SKIN]/actions/plus.png",
        prompt: "افزودن اهداف انتخاب شده به دوره مذکور و یا گرفتن اهداف انتخاب شده از دوره مذکور",
        hoverWidth: "12%",
        title: "افزودن",
        click: function () {
            Window_AddGoal.setTitle("افزودن هدف به دوره " + getFormulaMessage(courseRecord.titleFa, 2, "red", "b"));
            Window_AddGoal.show();
            ListGrid_CourseGoal_Goal.invalidateCache();
            ListGrid_CourseGoal_Goal.fetchData();
            RestDataSource_GoalAll.fetchDataURL = goalUrl + "spec-list";
            ListGrid_GoalAll.invalidateCache();
        }
    });
    var ToolStripButton_Add_Vertical = isc.IconButton.create({
        icon: "<spring:url value="double-arrow-left.png"/>",
        showButtonTitle:false,
        prompt: "افزودن اهداف انتخاب شده به اهداف دوره مذکور",
        click: function () {
            addToListGrid()
        }
    });
    var ToolStripButton_Remove_Vertical = isc.IconButton.create({
        // icon: "[SKIN]/TransferIcons/double-arrow-right.png",
        icon: "<spring:url value="double-arrow-right.png"/>",
        showButtonTitle:false,
        prompt: "حذف اهداف انتخاب شده از دوره مذکور",
        click: function () {
            removeAsListGrid();
        }
    });
    var ToolStrip_Actions_Goal = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Goal_ADD,
            "separator",
            ToolStripButton_Goal_Refresh,
        ]
    });
    var ToolStrip_Actions_Window_AddGoal = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Goal_Add,
            ToolStripButton_Goal_Edit_WindowAllGoal,
            ToolStripButton_Goal_Remove,
            isc.ToolStripButtonAdd.create({
                title: 'اضافه کردن گروهي',
                click: function () {
                    Goal_add_group();
                }
            })
        ]
    });
    var ToolStrip_Actions_Syllabus = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Syllabus_Add,
            ToolStripButton_Syllabus_Edit,
            ToolStripButton_Syllabus_Remove,
            "separator",
            ToolStripButton_Syllabus_Print
        ]
    });
    var ToolStrip_Vertical_Goals = isc.ToolStrip.create({
        width: "100%",
        height: "100%",
        align: "center",
        vertical: "center",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Vertical,
            ToolStripButton_Remove_Vertical]
    });

    var VLayout_Grid_GoalAll = isc.VLayout.create({
        width: "40%",
        height: "100%",
        members: [ListGrid_GoalAll]
    });
    var VLayout_Actions_Goals = isc.VLayout.create({
        width: "20",
        height: "100%",
        members: [ToolStrip_Vertical_Goals]
    });
    var VLayout_Grid_Goal_JspGoal = isc.VLayout.create({
        width: "40%",
        height: "100%",
        members: [ListGrid_CourseGoal_Goal]
    });
    var HLayOut_Goal_JspGoal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            VLayout_Grid_GoalAll,
            VLayout_Actions_Goals,
            VLayout_Grid_Goal_JspGoal
        ]
    });
    var Window_AddGoal = isc.Window.create({
        title: "افزودن هدف",
        width: "90%",
        height: "90%",
        canDragReposition: false,
        showShadow: true,
        shadowSoftness: 10,
        shadowOffset: 20,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoSize: false,
        animateMinimize: false,
        closeClick: function () {
            this.hide();
        },
        show(){
            let cr = {
                _constructor: "AdvancedCriteria",
                operator: "or",
                criteria: [
                    {
                        operator: "and",
                        criteria: [
                            {fieldName: "subCategoryId", operator: "equals", value: courseRecord.subCategory.id}
                        ]
                    },
                    {fieldName: "subCategoryId", operator: "isNull"}
                ]
            };
            ListGrid_GoalAll.setImplicitCriteria(cr);
            ListGrid_GoalAll.fetchData();
            this.Super("show",arguments);
        },
        items: [
            ToolStrip_Actions_Window_AddGoal,
            HLayOut_Goal_JspGoal
        ]
    });

    var HLayout_Action_Goal = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Goal]
    });
    var HLayout_Grid_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Goal]
    });
    var VLayout_Body_Goal = isc.VLayout.create({
        width: "*",
        height: "100%",
        members: [HLayout_Action_Goal, HLayout_Grid_Goal]
    });
    var HLayout_Action_Syllabus = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Syllabus]
    });
    var HLayout_Grid_Syllabus = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ListGrid_Syllabus_Goal]
    });
    var VLayout_Body_Syllabus = isc.VLayout.create({
        width: "70%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_Syllabus, HLayout_Grid_Syllabus]
    });
    var HLayout_Body_All_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_Goal, VLayout_Body_Syllabus]
    });

    function ListGrid_Goal_Remove() {
        let record = ListGrid_GoalAll.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "هدفی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
            return;
        }
        hasRelationWithCourse(record, ()=> {
            isc.Dialog.create({
                message: "هدف " + getFormulaMessage(record.titleFa, 2, "red", "b") + " حذف شود؟",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="verify.delete"/>",
                buttons: [
                    isc.IButtonSave.create({title: "بله"}),
                    isc.IButtonCancel.create({title: "خیر"})
                ],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(goalUrl + "delete/" + record.id, "DELETE", null, (resp) => {
                            wait.close();
                            if (resp.httpResponseCode == 200) {
                                ListGrid_GoalAll.invalidateCache();
                                simpleDialog("<spring:message code='msg.command.done'/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                            } else {
                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                            }
                        }));
                    }
                }
            });
        });
    }

    let hasRelationWithCourse = function (record, callBack) {
        let names = "";
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(goalUrl + "course/" + record.id, "GET", null, (resp) => {
            wait.close();
            let courses = JSON.parse(resp.data);
            if (courses.length > 0) {
                for (let i = 0; i < courses.length; i++) {
                    names = names + " و دوره " + getFormulaMessage(courses.get(i).titleFa, 2, "red", "b");
                }
                names = names.substr(2);
                createDialog('info', "هدف " + getFormulaMessage(record.titleFa, 2, "red", "b") + " با " + names + " در ارتباط است، ابتدا هدف را از دوره&#8201های مذکور جدا کنید.", "اخطار")
            }else{
                callBack();
            }
        }));
    }

    function ListGrid_Goal_Edit(LG = ListGrid_Goal) {
        let record = LG.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "هدفی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
            return;
        }
        hasRelationWithCourse(record, ()=>{
            methodGoal = "PUT";
            urlGoal = goalUrl + record.id;
            DynamicForm_Goal.clearValues();
            DynamicForm_Goal.editRecord(record);
            Window_Goal.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="goal"/>");
            Window_Goal.show();
        });
    }

    function ListGrid_Goal_refresh() {
        RestDataSource_CourseGoal.fetchDataURL = courseUrl + courseRecord.id + "/goal";
        ListGrid_Goal.invalidateCache();
        ListGrid_Goal.fetchData();
        RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseRecord.id;
        ListGrid_Syllabus_Goal.invalidateCache();
        ListGrid_Syllabus_Goal.fetchData();
    }
    function Goal_add_group() {
        if(numClasses>0){
            createDialog("warning", "بدلیل تشکیل کلاس برای دوره نمی توان برای این دوره هدف جدید ایجاد کرد.", "اخطار");
            return;
        }
        importFromExcel();
    }

    function importFromExcel(){
        TabSet_GroupInsert_JspGoal=isc.TabSet.create({
            ID:"leftTabSetGoal",
            autoDraw:false,
            tabBarPosition: "top",
            width: "100%",
            height: 115,
            tabs: [
                {title: "فایل اکسل", width:200, overflow:"hidden",
                    pane: isc.DynamicForm.create({
                        height: "100%",
                        width:"100%",
                        numCols: 4,
                        colWidths: ["10%","40%","20%","20%"],
                        fields: [
                            {
                                ID:"DynamicForm_GroupInsert_FileUploader_JspGoal",
                                name:"DynamicForm_GroupInsert_FileUploader_JspGoal",
                                type:"imageFile",
                                title:"مسیر فایل",
                            },
                            {
                                type: "button",
                                startRow:false,
                                title: "آپلود فايل",
                                click:function () {
                                    let address=DynamicForm_GroupInsert_FileUploader_JspGoal.getValue();
                                    if(address==null){
                                        createDialog("info", "فايل خود را انتخاب نماييد.");
                                    }else{
                                        var ExcelToJSON = function() {

                                            this.parseExcel = function(file) {
                                                var reader = new FileReader();
                                                var records = [];

                                                reader.onload = function(e) {
                                                    var data = e.target.result;
                                                    var workbook = XLSX.read(data, {
                                                        type: 'binary'
                                                    });
                                                    var isEmpty=true;
                                                    workbook.SheetNames.forEach(function(sheetName) {
                                                        var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                        for(let i=0;i<XL_row_object.length;i++){
                                                            if(GroupSelectedPersonnelsLG_Goal.data.filter(function (item) {
                                                                return item.titleEn==Object.values(XL_row_object[i])[0] && item.titleFa==Object.values(XL_row_object[i])[1];
                                                            }).length==0){
                                                                let current={titleEn:Object.values(XL_row_object[i])[0], titleFa:Object.values(XL_row_object[i])[1]};
                                                                records.add(current);
                                                                isEmpty=false;
                                                                continue;
                                                            }
                                                            else{
                                                                isEmpty=false;
                                                                continue;
                                                            }
                                                        }
                                                        DynamicForm_GroupInsert_FileUploader_JspGoal.setValue('');
                                                    });

                                                    if(records.length > 0){

                                                        let uniqueRecords = [];

                                                        for (let i=0; i < records.length; i++) {
                                                            if (uniqueRecords.filter(function (item) {return item.titleFa == records[i].titleFa && item.titleEn == records[i].titleEn;}).length==0) {
                                                                uniqueRecords.push(records[i]);
                                                            }
                                                        }
                                                        GroupSelectedPersonnelsLG_Goal.setData(GroupSelectedPersonnelsLG_Goal.data.concat(uniqueRecords));
                                                        GroupSelectedPersonnelsLG_Goal.invalidateCache();
                                                        GroupSelectedPersonnelsLG_Goal.fetchData();

                                                        createDialog("info", "فایل به لیست اضافه شد.");
                                                    }else{
                                                        if(isEmpty){
                                                            createDialog("info", "خطا در محتویات فایل");
                                                        }else{
                                                            createDialog("info", "هدف جدیدی برای اضافه کردن وجود ندارد.");
                                                        }
                                                    }
                                                };

                                                reader.onerror = function(ex) {
                                                    createDialog("info", "خطا در باز کردن فایل");
                                                };

                                                reader.readAsBinaryString(file);
                                            };
                                        };
                                        let split=$('[name="DynamicForm_GroupInsert_FileUploader_JspGoal"]')[0].files[0].name.split('.');

                                        if(split[split.length-1]=='xls'||split[split.length-1]=='csv'||split[split.length-1]=='xlsx'){
                                            var xl2json = new ExcelToJSON();
                                            xl2json.parseExcel($('[name="DynamicForm_GroupInsert_FileUploader_JspGoal"]')[0].files[0]);
                                        }else{
                                            createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                        }

                                    }
                                }
                            },
                            {
                                type: "button",
                                title: "فرمت فايل ورودی",
                                click:function () {
                                    window.open("excel/sample-excel-goal.xlsx");
                                }
                            },
                        ]
                    })
                }
            ]
        });

        ClassStudentWin_goal_GroupInsert = isc.Window.create({
            width: 1050,
            height: 750,
            minWidth: 700,
            minHeight: 500,
            autoSize: false,
            overflow:"hidden",
            title:"اضافه کردن گروهی",
            items: [
                isc.HLayout.create({
                    width:1050,
                    height: "88%",
                    autoDraw: false,
                    overflow:"auto",
                    align: "center",
                    members: [
                        isc.TrLG.create({
                            ID: "GroupSelectedPersonnelsLG_Goal",
                            showFilterEditor: false,
                            editEvent: "click",
                            //listEndEditAction: "next",
                            enterKeyEditAction: "nextRowStart",
                            canSort:false,
                            canEdit:true,
                            filterOnKeypress: true,
                            selectionType: "single",
                            fields: [
                                {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true,width:"10%"},
                                { name: "titleEn", title: "نام انگلیسی", canEdit: true ,autoFithWidth:true},
                                { name: "titleFa", title: "نام فارسی", canEdit: true ,autoFithWidth:true},
                            ],
                            gridComponents: [TabSet_GroupInsert_JspGoal, "header", "body"],
                            canRemoveRecords: true,
                            deferRemoval:true,
                            removeRecordClick:function (rowNum){
                                GroupSelectedPersonnelsLG_Goal.data.removeAt(rowNum);
                            }
                        })
                    ]
                }),
                isc.TrHLayoutButtons.create({
                    members: [
                        isc.IButtonSave.create({
                            top: 260,
                            title: "<spring:message code='save'/>",
                            align: "center",
                            icon: "[SKIN]/actions/save.png",
                            click: function () {

                                let list=GroupSelectedPersonnelsLG_Goal.data;
                                methodGoal = "POST";
                                let urlCreateGroupGoal = goalUrl + "create/list/" + courseRecord.id;
                                let goalData = list.map(function(item, index) {
                                    return {categoryId:courseRecord.category.id ,subCategoryId:courseRecord.subCategory.id ,titleFa: item.titleFa , titleEn: item.titleEn}
                                })
                                wait.show();
                                isc.RPCManager.sendRequest(TrDSRequest(urlCreateGroupGoal, methodGoal, JSON.stringify(goalData), resp => {

                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say");
                                        ListGrid_Goal_refresh();
                                        ListGrid_GoalAll.invalidateCache();
                                        ListGrid_CourseGoal_Goal.invalidateCache();
                                        ClassStudentWin_goal_GroupInsert.close();
                                    } else {
                                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")
                                    }
                                }))

                            }
                        }), isc.IButtonCancel.create({
                            top: 260,
                            title: "<spring:message code='cancel'/>",
                            align: "center",
                            icon: "[SKIN]/actions/cancel.png",
                            click: function () {
                                ClassStudentWin_goal_GroupInsert.close();
                            }
                        })
                    ]
                })
            ]
        });


        TabSet_GroupInsert_JspGoal.selectTab(0);
        GroupSelectedPersonnelsLG_Goal.discardAllEdits();
        GroupSelectedPersonnelsLG_Goal.data.clearAll();
        DynamicForm_GroupInsert_FileUploader_JspGoal.setValue('');
        ClassStudentWin_goal_GroupInsert.show();
    }


    function ListGrid_Goal_Add() {
        if(numClasses>0){
            createDialog("warning", "بدلیل تشکیل کلاس برای دوره نمی توان برای این دوره هدف جدید ایجاد کرد.", "اخطار");
            return;
        }
        DynamicForm_Goal.getItem("subCategoryId").disable();
        if (DynamicForm_course_MainTab.getValue("titleFa") == null) {
            isc.Dialog.create({
                message: "لطفاً ابتدا اطلاعات دوره را وارد کنید.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            methodGoal = "POST";
            urlGoal = goalUrl + "create/" + courseRecord.id;
            DynamicForm_Goal.clearValues();
            Window_Goal.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="goal"/>");
            Window_Goal.show();
        }
    }

    function ListGrid_Syllabus_Goal_Remove() {
        let record = ListGrid_Syllabus_Goal.getSelectedRecord();
        let goalRecord = ListGrid_Goal.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "سرفصلی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            if(goalRecord.id == record.goalId) {
                let Dialog_Delete = isc.Dialog.create({
                    message: "<spring:message code='msg.record.remove.ask'/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="verify.delete"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code='global.yes'/>"}), isc.IButtonCancel.create({
                        title: "<spring:message
        code='global.no'/>"
                    })],
                    buttonClick: function (button, index) {
                        this.close();
                        if (index == 0) {
                            <%--let goalWait = isc.Dialog.create({--%>
                            <%--message: "<spring:message code='global.form.do.operation'/>",--%>
                            <%--icon: "[SKIN]say.png",--%>
                            <%--title: "<spring:message code='global.message'/>"--%>
                            <%--});--%>
                            wait.show()
                            isc.RPCManager.sendRequest(TrDSRequest(goalUrl + "course/" + record.goalId, "GET", null,(resp)=>{
                                let courses = JSON.parse(resp.data);
                                let courseList = "";
                                if(courses.length>1){
                                    courses.forEach(function (currentValue, index, array) {
                                        courseList += getFormulaMessage(currentValue.titleFa, "2", "green", "b");
                                        courseList += '<br>';
                                    });
                                    let dialog_Accept = createDialog("ask","سرفصل " + getFormulaMessage(record.titleFa, "2", "red", "b") + " به هدف " + getFormulaMessage(record.goal.titleFa, "2", "red", "b") + " متصل می باشد که <br>" + "هدف مورد نظر نیز به دور ه های<br>" + courseList + "متصل می باشند " + "حذف این گزینه باعث می شود که سرفصل مورد نظر از دوره های ذکر شده نیز حذف گردد،<br>آیا از انتخاب خود مطمئن هستید ؟", "توجه");
                                    dialog_Accept.addProperties({
                                        buttonClick: function (button, index) {
                                            this.close();
                                            if(index === 0)
                                                deleteGoal(record.id);
                                            else
                                                wait.close();
                                        }
                                    });
                                }else
                                    deleteGoal(record.id);
                            }));
                        }
                    }
                });
            }
        }
    }

    function ListGrid_Syllabus_Goal_Add() {
        let gRecord = ListGrid_Goal.getSelectedRecord();
        if (gRecord == null || gRecord.id == null) {
            isc.Dialog.create({
                message: "هدف مرتبط انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            methodSyllabus = "POST";
            urlSyllabus = syllabusUrl;
            DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.getItem("goalId").setValue(gRecord.id);
            Window_Syllabus.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="syllabus"/>");
            Window_Syllabus.show();
        }
    }

    function ListGrid_Syllabus_Goal_Edit() {
        let sRecord = ListGrid_Syllabus_Goal.getSelectedRecord();
        if (sRecord == null || sRecord.id == null) {
            isc.Dialog.create({
                message: "سرفصلی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            methodSyllabus = "PUT";
            urlSyllabus = syllabusUrl + sRecord.id;
            DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.editRecord(sRecord);
            Window_Syllabus.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="syllabus"/>");
            Window_Syllabus.show();
        }
    }

    function ListGrid_Syllabus_Goal_refresh() {
        RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseRecord.id;
        ListGrid_Syllabus_Goal.invalidateCache();
        ListGrid_Syllabus_Goal.fetchData();
        evalDomain();
    }

    let addToListGrid = function() {
        if (courseRecord == null || courseRecord.id == null) {
            isc.Dialog.create({
                message: "دوره اي انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            let goalRecords = ListGrid_GoalAll.getSelectedRecords();
            if (goalRecords.length === 0) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>")
            }else if(numClasses>0) {
                createDialog("warning","از این دوره در "+ numClasses +" کلاس استفاده شده است.", "اخطار");
                return;
            } else {
                let goalList = [];
                let subCategoryIDs = [];
                for (let i = 0; i < goalRecords.length; i++) {
                    goalList.add(goalRecords[i].id);
                    subCategoryIDs=[...subCategoryIDs,goalRecords[i].subCategoryId];
                }
                if (subCategoryIDs.find(x=>x!==courseRecord.subCategory.id) || subCategoryIDs.some(x=>!x)){
                    simpleDialog("<spring:message code="message"/>",
                        "<spring:message code="goal.problem.add1"/>" + "<br/>" + "<spring:message code="goal.problem.add2"/>", 10000, "stop");
                    return;
                }
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + courseRecord.id + "/" + goalList.toString(), "GET", null, (resp => {
                    isChangeable();
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_GoalAll.invalidateCache();
                        ListGrid_CourseGoal_Goal.invalidateCache();
                        ListGrid_CourseGoal_Goal.fetchData();
                        ListGrid_Goal.invalidateCache();
                        ListGrid_Syllabus_Goal.invalidateCache();
                        evalDomain();
                    } else {
                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 3000, "stop");
                    }
                })));
            }
        }
    }

    let removeAsListGrid = function() {
        if (courseRecord == null || courseRecord.id == null) {
            isc.Dialog.create({
                message: "دوره اي انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            let goalRecord = ListGrid_CourseGoal_Goal.getSelectedRecords();
            if (goalRecord.length == 0) {
                isc.Dialog.create({
                    message: "هدفي انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.IButtonSave.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else if(numClasses>0) {
                createDialog("warning","از این دوره در کلاس استفاده شده است.", "اخطار");
                return;
            } else {
                let arrayRecord = [];
                for (let i = 0; i < goalRecord.length; i++) {
                    arrayRecord.add(goalRecord[i].id)
                }

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "remove/" + courseRecord.id + "/" + arrayRecord.toString(), "GET", null ,(resp)=>{
                    isChangeable();
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_GoalAll.invalidateCache();
                        ListGrid_CourseGoal_Goal.invalidateCache();
                        ListGrid_Goal.invalidateCache();
                        ListGrid_Syllabus_Goal.invalidateCache();
                        evalDomain();
                    } else {
                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                    }
                }));
            }
        }
    }

    function deleteGoal(id) {
        isc.RPCManager.sendRequest(TrDSRequest(syllabusUrl + id, "DELETE", null, (resp)=>{
            wait.close();
            if (resp.httpResponseCode == 200) {
                ListGrid_Syllabus_Goal.invalidateCache();
                evalDomain();
                var OK = isc.Dialog.create({
                    message: "<spring:message code='global.form.request.successful'/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code='global.form.command.done'/>"
                });
                setTimeout(function () {
                    OK.close();
                }, 3000);
            } else {
                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
            }
        }))
    }

    // </script>
