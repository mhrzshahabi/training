<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    // <<========== Global - Variables ==========
    {
        var session_method = "POST";

    }
    // ============ Global - Variables ========>>

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        Menu_ListGrid_session = isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {
                        ListGrid_session.invalidateCache();
                    }
                },
                {
                    title: "<spring:message code="create"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        create_Session();
                    }
                },
                {
                    title: "<spring:message code="edit"/>",
                    icon: "<spring:url value="edit.png"/>",
                    click: function () {
                        show_SessionEditForm();
                    }
                },
                {
                    title: "<spring:message code="remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        remove_Session();
                    }
                },
                {
                    isSeparator: true
                },
                {
                    title: "<spring:message code="print.pdf"/>",
                    icon: "<spring:url value="pdf.png"/>",
                    click: function () {
                        print_SessionListGrid("pdf");
                    }
                },
                {
                    title: "<spring:message code="print.excel"/>",
                    icon: "<spring:url value="excel.png"/>",
                    click: function () {
                        print_SessionListGrid("excel");
                    }
                },
                {
                    title: "<spring:message code="print.html"/>",
                    icon: "<spring:url value="html.png"/>",
                    click: function () {
                        print_SessionListGrid("html");
                    }
                }
            ]
        })
    }
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_session = isc.TrDS.create({
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken %>"
                };
                return this.Super("transformRequest", arguments);
            },
            fields:
                [
                    {name: "id", primaryKey: true},
                    {name: "dayCode"},
                    {name: "dayName"},
                    {name: "sessionDate"},
                    {name: "sessionStartHour"},
                    {name: "sessionEndHour"},
                    {name: "sessionTypeId"},
                    {name: "sessionType"},
                    {name: "instituteId"},
                    {name: "institute.titleFa"},
                    {name: "trainingPlaceId"},
                    {name: "teacherId"},
                    {name: "teacher"},
                    {name: "sessionState"},
                    {name: "sessionStateFa"},
                    {name: "description"}
                ],
            dataFormat: "json",
            fetchDataURL: sessionServiceUrl + "spec-list"
        });

        var RestDataSource_ESessionType = isc.TrDS.create({
            fields: [{name: "id"}, {name: "titleFa"}
            ],
            fetchDataURL: enumUrl + "eSessionType/spec-list"
        });

        var RestDataSource_ESessionState = isc.TrDS.create({
            fields: [{name: "id"}, {name: "titleFa"}
            ],
            fetchDataURL: enumUrl + "eSessionState/spec-list"
        });

        var RestDataSource_ESessionTime = isc.TrDS.create({
            fields: [{name: "id"}, {name: "titleFa"}
            ],
            fetchDataURL: enumUrl + "eSessionTime/spec-list"
        });

        var ListGrid_session = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_session,
            contextMenu: Menu_ListGrid_session,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            sortField: 0,
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "dayCode",
                    title: "dayCode",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "dayName",
                    title: "dayName",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "sessionDate",
                    title: "sessionDate",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "sessionStartHour",
                    title: "sessionStartHour",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "sessionEndHour",
                    title: "sessionEndHour",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "sessionTypeId",
                    title: "sessionTypeId",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "sessionType",
                    title: "sessionType",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "instituteId",
                    title: "instituteId",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "institute.titleFa",
                    title: "institute",
                    align: "center",
                    filterOperator: "contains"
                },{
                    name: "trainingPlaceId",
                    title: "trainingPlaceId",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "teacherId",
                    title: "teacherId",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "teacher",
                    title: "teacher",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "sessionState",
                    title: "sessionState",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "sessionStateFa",
                    title: "sessionStateFa",
                    align: "center",
                    filterOperator: "contains"
                }, {
                    name: "description",
                    title: "description",
                    align: "center",
                    filterOperator: "contains"
                }
            ],
            doubleClick: function () {
                show_SessionEditForm();
            }
        });

        var RestDataSource_Institute_JspSession = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "نام موسسه"},
                {name: "manager.firstNameFa", title: "نام مدیر"},
                {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"},
                {name: "mobile", title: "موبایل"},
                {name: "restAddress", title: "آدرس"},
                {name: "phone", title: "تلفن"}
            ],
            fetchDataURL: instituteUrl + "spec-list"
        });

        var RestDataSource_TrainingPlace_JspSession = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "نام مکان"},
                {name: "capacity", title: "ظرفیت"}
            ],
            fetchDataURL: instituteUrl + "0/training-places"
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>


    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        var ToolStripButton_Refresh = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/refresh.png",
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_session.invalidateCache();
            }
        });

        var ToolStripButton_Add = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/add.png",
            title: "<spring:message code="create"/>",
            click: function () {
                create_Session();
            }
        });

        var ToolStripButton_Edit = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/edit.png",
            title: "<spring:message code="edit"/>",
            click: function () {
                show_SessionEditForm();
            }
        });

        var ToolStripButton_Remove = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/remove.png",
            title: "<spring:message code="remove"/>",
            click: function () {
                remove_Session();
            }
        });

        var ToolStripButton_Print = isc.ToolStripButton.create({
            icon: "[SKIN]/RichTextEditor/print.png",
            title: "<spring:message code="print"/>",
            click: function () {
                print_SessionListGrid("pdf");
            }
        });

        var ToolStrip_session = isc.ToolStrip.create({
            width: "100%",
            members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>


    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
        //*****create fields*****
        var DynamicForm_Session = isc.DynamicForm.create({
            numCols: 5,
            colWidths: ["10%", "30%", "10%", "10%", "30%"],
            padding: 10,
            isGroup: true,
            groupTitle: "اطلاعات جلسه",
            groupBorderCSS: "1px solid lightBlue",
            fields:
                [
                    {
                        name: "sessionDate",
                        title: "<spring:message code='date'/>",
                        ID: "sessionDate_jspSession",
                        required: true,
                        hint: "YYYY/MM/DD",
                        keyPressFilter: "[0-9/]",
                        showHintInField: true,
                        icons: [{
                            src: "<spring:url value="calendar.png"/>",
                            click: function (form) {
                                closeCalendarWindow();
                                displayDatePicker('sessionDate_jspSession', this, 'ymd', '/');
                            }
                        }],
                        textAlign: "center",
                        click: function (form) {

                        },
                        changed: function (form, item, value) {

                            if (checkDate(value) === false) {
                                form.addFieldErrors("sessionDate", "<spring:message code='msg.correct.date'/>", true);
                            } else {
                                form.clearFieldErrors("sessionDate", true);
                            }
                        }
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "instituteId",
                        editorType: "TrComboAutoRefresh",
                        title: "برگزار کننده",
                        autoFetchData: false,
                        optionDataSource: RestDataSource_Institute_JspSession,
                        displayField: "titleFa",
                        valueField: "id",
                        textAlign: "center",
                        filterFields: ["titleFa", "manager.firstNameFa", "manager.LastNameFa"],
                        required: true,
                        pickListFields: [
                            {name: "titleFa"},
                            {name: "manager.firstNameFa"},
                            {name: "manager.lastNameFa"}
                        ],
                        changed: function (form, item) {
                            form.clearValue("sessionTrainingPlace")
                        }
                    },
                    {
                        name: "trainingPlaceId",
                        editorType: "TrComboAutoRefresh",
                        title: "محل برگزاری:",
                        align: "center",
                        optionDataSource: RestDataSource_TrainingPlace_JspSession,
                        displayField: "titleFa",
                        valueField: "id",
                        filterFields: ["titleFa", "capacity"],
                        required: true,
                        textAlign: "center",
                        pickListFields: [
                            {name: "titleFa"},
                            {name: "capacity"}
                        ],
                        click: function (form, item) {
                            if (form.getValue("instituteId")) {
                                RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + form.getValue("instituteId") + "/training-places";
                                item.fetchData();
                            } else {
                                RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + "0/training-places";
                                item.fetchData();
                                isc.MyOkDialog.create({
                                    message: "ابتدا برگزار کننده را انتخاب کنید",
                                });
                            }
                        }
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "teacherId",
                        title: "<spring:message code='trainer'/>:",
                        textAlign: "center",
                        type: "ComboBoxItem",
                        multiple: false,
                        displayField: "fullNameFa",
                        valueField: "id",
                        autoFetchData: false,
                        required: true,
                        useClientFiltering: true,
                        optionDataSource: RestDataSource_Teacher_JspClass,
                        pickListFields: [
                            {name: "personality.lastNameFa", title: "نام خانوادگی", titleAlign: "center"},
                            {name: "personality.firstNameFa", title: "نام", titleAlign: "center"},
                            {name: "personality.nationalCode", title: "کد ملی", titleAlign: "center"}
                        ],
                        filterFields: [
                            "personality.lastNameFa",
                            "personality.firstNameFa",
                            "personality.nationalCode"
                        ],
                        click: function (form, item) {

                            if (ListGrid_Class_JspClass.getSelectedRecord() != null) {

                                let ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                                let courseId = ClassRecord.course.id;

                                RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + courseId;
                                item.fetchData();
                            } else {
                                RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/0";
                                item.fetchData();
                                let dialogTeacher = isc.MyOkDialog.create({
                                    message: "ابتدا کلاس را انتخاب کنید",
                                });
                                dialogTeacher.addProperties({
                                    buttonClick: function () {
                                        this.close();
                                    }
                                });
                            }
                        }
                    },
                    {
                        name: "sessionTypeId",
                        title: "نوع جلسه:",
                        type: "selectItem",
                        textAlign: "center",
                        required: true,
                        valueMap: {
                            "1": "آموزش",
                            "2": "آزمون"
                        },
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "sessionState",
                        title: "وضعیت جلسه:",
                        type: "selectItem",
                        textAlign: "center",
                        required: true,
                        valueMap: {
                            "1": "شروع نشده",
                            "2": "در حال اجرا",
                            "3": "پایان"
                        },
                    },
                    {
                        name: "sessionTime",
                        title: "ساعت جلسه :",
                        type: "selectItem",
                        textAlign: "center",
                        required: true,
                        valueMap: {
                            "1": "8-10",
                            "2": "10-12",
                            "3": "14-16"
                        },
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        textAlign: "center"
                    }
                ]
        });

        //*****create buttons*****
        var create_Buttons = isc.MyHLayoutButtons.create({
            members:
                [
                    isc.Button.create
                    ({
                        title: "<spring:message code="save"/> ",
                        click: function () {
                            if (session_method === "POST") {
                                save_Session();
                            } else {
                                edit_Session();
                            }
                        }
                    }),
                    isc.Button.create
                    ({
                        title: "<spring:message code="cancel"/>",
                        click: function () {
                            Window_Session.close();
                        }
                    })
                ]
        });

        //*****create insert/update window*****
        var Window_Session = isc.Window.create({
            title: "<spring:message code="create"/> ",
            width: "40%",
            minWidth: 500,
            visibility: "hidden",
            items:
                [
                    DynamicForm_Session, create_Buttons
                ]
        });
    }
    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>


    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        var HLayout_Actions_session = isc.HLayout.create({
            width: "100%",
            members: [ToolStrip_session]
        });

        var Hlayout_Grid_session = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_session]
        });

        var VLayout_Body_session = isc.TrVLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_session, Hlayout_Grid_session]
        });
    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>


    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****open insert window*****
        function create_Session() {
            session_method = "POST";
            DynamicForm_Session.clearValues();
            Window_Session.setTitle("<spring:message code="create"/>");
            Window_Session.show();
        }

        //*****insert function*****
        function save_Session() {

            if (!DynamicForm_Session.validate())
                return;

            let ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            let classId = ClassRecord.id;

            let sessionData = DynamicForm_Session.getValues();

            //**add new property to form values**
            sessionData["classId"] = classId;
            sessionData["sessionType"] = DynamicForm_Session.getItem("sessionTypeId").getDisplayValue();
            sessionData["sessionStateFa"] = DynamicForm_Session.getItem("sessionState").getDisplayValue();

            isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl, session_method, JSON.stringify(sessionData), show_SessionActionResult));
        }

        //*****open update window*****
        function show_SessionEditForm() {

            let record = ListGrid_session.getSelectedRecord();

            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.not.selected.record"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="course_Warning"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {

                session_method = "PUT";
                DynamicForm_Session.clearValues();
                DynamicForm_Session.editRecord(record);
                Window_Session.setTitle("<spring:message code="edit"/>");
                Window_Session.show();
            }
        }

        //*****update function*****
        function edit_Session() {
            let sessionData = DynamicForm_Session.getValues();
            let sessionEditUrl = sessionServiceUrl;
            if (session_method.localeCompare("PUT") === 0) {
                let selectedRecord = ListGrid_session.getSelectedRecord();
                sessionEditUrl += selectedRecord.id;
            }
            isc.RPCManager.sendRequest(TrDSRequest(sessionEditUrl, session_method, JSON.stringify(sessionData), show_SessionActionResult));
        }

        //*****delete function*****
        function remove_Session() {
            var record = ListGrid_session.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.not.selected.record"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="course_Warning"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                isc.MyYesNoDialog.create({
                    message: "<spring:message code="global.grid.record.remove.ask"/>",
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + record.id, "DELETE", null, show_SessionActionResult));
                        }
                    }
                });
            }

        }

        //*****show action result function*****
        var MyOkDialog_Session;

        function show_SessionActionResult(resp) {
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let responseID = JSON.parse(resp.data).id;
                let gridState = "[{id:" + responseID + "}]";

                ListGrid_session.invalidateCache();
                MyOkDialog_Session = isc.MyOkDialog.create({
                    message: "<spring:message code="global.form.request.successful"/>"
                });

                setTimeout(function () {
                    close_MyOkDialog_Session();
                    ListGrid_session.scrollToRow(ListGrid_session.getTotalRows(), 10);
                    ListGrid_session.setSelectedState(gridState);
                }, 1000);

                Window_Session.close();

            } else {
                let respText = resp.httpResponseText;
                if (resp.httpResponseCode === 406) {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: "<spring:message code="msg.record.duplicate"/>"
                    });

                    close_MyOkDialog_Session()

                } else {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: "<spring:message code="msg.operation.error"/>"
                    });

                    close_MyOkDialog_Session();
                }
            }
        }

        //*****close dialog*****
        function close_MyOkDialog_Session() {
            setTimeout(function () {
                MyOkDialog_Session.close();
            }, 3000);
        }

        //*****print*****
        function print_SessionListGrid(type) {
            var advancedCriteria_course = ListGrid_session.getCriteria();
            var criteriaForm_course = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/operational-unit/printWithCriteria/"/>" + type,
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"},
                        {name: "myToken", type: "hidden"}
                    ]
            });
            criteriaForm_course.setValue("CriteriaStr", JSON.stringify(advancedCriteria_course));
            criteriaForm_course.setValue("myToken", "<%=accessToken%>");
            criteriaForm_course.show();
            criteriaForm_course.submitForm();
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>


    //</script>