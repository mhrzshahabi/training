<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken1 = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    // <<========== Global - Variables ==========
        var session_method = "POST";
        var deleteRecord=false;

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
        Menu_ListGrid_session = isc.Menu.create({
            data: [
                <sec:authorize access="hasAuthority('TclassSessionsTab_R')">
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {
                        ListGrid_session.invalidateCache();
                    }
                },
                </sec:authorize>


                <sec:authorize access="hasAuthority('TclassSessionsTab_C')">
                {
                    title: "<spring:message code="create"/>",
                    // title: "<spring:message code="create"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        create_Session();
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('TclassSessionsTab_U')">
                {
                    title: "<spring:message code="edit"/>",
                    icon: "<spring:url value="edit.png"/>",
                    click: function () {
                        show_SessionEditForm();
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('TclassSessionsTab_D')">
                {
                    title: "<spring:message code="remove.and.group.remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        remove_Session();
                    }
                },
                </sec:authorize>


                {
                    isSeparator: true
                },

                <sec:authorize access="hasAuthority('TclassSessionsTab_P')">
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
                </sec:authorize>
            ]
        });

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
        var RestDataSource_session = isc.TrDS.create({
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken1 %>"
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
                    {name: "trainingPlace.titleFa"},
                    {name: "teacherId"},
                    {name: "teacher"},
                    {name: "sessionState"},
                    {name: "sessionStateFa"},
                    {name: "description"}
                ],
            fetchDataURL: sessionServiceUrl + "spec-list"
        });

        var ListGrid_session = isc.TrLG.create({
            width: "100%",
            height: "100%",

            <sec:authorize access="hasAnyAuthority('TclassSessionsTab_R','TclassSessionsTab_classStatus')">
            dataSource: RestDataSource_session,
            </sec:authorize>
            // contextMenu: Menu_ListGrid_session,
            canAddFormulaFields: false,
            // autoFetchData: true,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            selectionType: "multiple",
            filterOnKeypress: true,
            initialSort: [
                {property: "sessionDate", direction: "ascending"},
                {property: "sessionStartHour", direction: "ascending"}
            ],
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "dayCode",
                    title: "dayCode",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "dayName",
                    title: "<spring:message code="week.day"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionDate",
                    title: "<spring:message code="date"/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
                },
                {
                    name: "sessionStartHour",
                    title: "<spring:message code="start.time"/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "sessionEndHour",
                    title: "<spring:message code="end.time"/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "sessionTypeId",
                    title: "sessionTypeId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "sessionType",
                    title: "<spring:message code="session.type"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "instituteId",
                    title: "instituteId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code="presenter"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "trainingPlaceId",
                    title: "trainingPlaceId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "trainingPlace.titleFa",
                    title: "<spring:message code="present.location"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "teacherId",
                    title: "teacherId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "teacher",
                    title: "<spring:message code="trainer"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                /*{
                    name: "sessionState",
                    title: "sessionState",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "sessionStateFa",
                    title: "<spring:message code="session.state"/>",
                    align: "center",
                    filterOperator: "iContains"
                },*/
                {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionContent",
                    title: "محتوای جلسه",
                    align: "center",
                    canFilter: false
                }
            ],
            doubleClick: function () {
                show_SessionEditForm();
            },
            getCellCSSText: function (record, rowNum, colNum) {
                let result="background-color : ";
                let blackColor="; color:black";

                if (this.isSelected(record)) {
                    return "background-color: #fe9d2a;";
                }

                switch (record.dayCode) {
                    case 'Sat':
                        result+="#989899";
                        break;

                    case 'Sun':
                        result+="#ffd1f2"+blackColor;
                        break;

                    case 'Mon':
                        result+="#FFFAF0"+blackColor;
                        break;

                    case 'Tue':
                        result+="#cdb7a3"+blackColor;
                        break;

                    case 'Wed':
                        result+="#80cd86";
                        break;

                    case 'Thu':
                        result+="#ffff77"+blackColor;
                        break;

                    case 'Fri':
                        result+="#bedae6"+blackColor;
                        break;
                }//end switch-case
                return result;
            },
            createRecordComponent: function (record, colNum) {

                var fieldName = this.getFieldName(colNum);
                if (record == null || fieldName != "sessionContent")
                    return null;

                return isc.IButton.create({
                    layoutAlign: "center",
                    title: "محتوای جلسه",
                    width: "120",
                    margin: 3,
                    click: function () {
                        getSessionContent(record.id);
                    }
                });
            }
        });

        var RestDataSource_Institute_JspSession = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "<spring:message code="institution.name"/>"},
                {name: "manager.firstNameFa", title: "<spring:message code="manager.name"/>"},
                {name: "manager.lastNameFa", title: "<spring:message code="manager.family"/>"},
                <%--{name: "mobile", title: "<spring:message code="mobile"/>"},--%>
                <%--{name: "restAddress", title: "<spring:message code="address"/>"},--%>
                <%--{name: "phone", title: "<spring:message code="telephone"/>"}--%>
            ],
            fetchDataURL: instituteUrl + "iscSessionTupleList"
        });

        var RestDataSource_TrainingPlace_JspSession = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "<spring:message code="location.name"/>"},
                {name: "capacity", title: "<spring:message code="capacity"/>"}
            ],
            fetchDataURL: instituteUrl + "0/trainingPlaces"
        });

    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
        <sec:authorize access="hasAnyAuthority('TclassSessionsTab_R','TclassSessionsTab_classStatus')">
        var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
            click: function () {
                ListGrid_session.invalidateCache();
            }
        })
        </sec:authorize>

        <sec:authorize access="hasAnyAuthority('TclassSessionsTab_C','TclassSessionsTab_classStatus')">
        var ToolStripButton_Add = isc.ToolStripButtonAdd.create({
            title: "<spring:message code="create" />",
            click:
                function () {
                    create_Session();
                }
        })
        </sec:authorize>

        <sec:authorize access="hasAnyAuthority('TclassSessionsTab_U','TclassSessionsTab_classStatus')">
        var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
            click: function () {
                show_SessionEditForm();
            }
        })
        </sec:authorize>

        <sec:authorize access="hasAnyAuthority('TclassSessionsTab_D','TclassSessionsTab_classStatus')">
        var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
            title: "<spring:message code="remove.and.group.remove" />",
            click: function () {
                remove_Session();
            }
        })
        </sec:authorize>

        <sec:authorize access="hasAnyAuthority('TclassSessionsTab_P','TclassSessionsTab_classStatus')">
        var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
            click: function () {
                print_SessionListGrid("pdf");
            }
        });

        var ToolStrip_Excel_JspClass = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        if (!(classRecord === undefined || classRecord == null)) {
                            ExportToFile.downloadExcelRestUrl(null, ListGrid_session, sessionServiceUrl + "iscList/" + classRecord.id, 0, ListGrid_Class_JspClass, '', "کلاس - جلسات", ListGrid_session.getCriteria(), null);
                        }
                    }
                })]
        });
        </sec:authorize>

        var ToolStrip_session = isc.ToolStrip.create({
            width: "100%",
            members: [

                ToolStripButton_Add,
                ToolStripButton_Edit,
                ToolStripButton_Remove,



                ToolStripButton_Print,
                ToolStrip_Excel_JspClass,



                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh
                    ]
                })

            ]
        });

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------

        //*****create fields*****
        var DynamicForm_Session = isc.DynamicForm.create({
            numCols: 5,
            colWidths: ["10%", "30%", "10%", "10%", "30%"],
            padding: 10,
            isGroup: true,
            groupTitle: "<spring:message code="session.information"/>",
            groupBorderCSS: "1px solid lightBlue",
            fields:
                [
                    {
                        name: "sessionDate",
                        title: "<spring:message code='date'/>",
                        ID: "sessionDate_jspSession",
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        hint: "----/--/--",
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
                        blur: function () {
                            check_valid_date();
                        },
                        editorExit:function(){
                            let result=reformat(DynamicForm_Session.getValue("sessionDate"));
                            if (result){
                                DynamicForm_Session.getItem("sessionDate").setValue(result);
                                DynamicForm_Session.clearFieldErrors("sessionDate", true);
                                check_valid_date();
                            }
                        },
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "sessionStartHour",
                        title: "<spring:message code="session.start.hour"/>",
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        hint: "--:--",
                        keyPressFilter: "[0-9:]",
                        showHintInField: true,
                        textAlign: "center",
                        validateOnChange: true,
                        editorExit:function(){
                            DynamicForm_Session.setValue("sessionStartHour",arrangeDate(DynamicForm_Session.getValue("sessionStartHour")));
                            let val=DynamicForm_Session.getValue("sessionStartHour");
                            if(val===null || val==='' || typeof (val) === 'undefined'|| !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)){
                                DynamicForm_Session.addFieldErrors("sessionStartHour", "<spring:message code="session.hour.invalid"/>", true);
                            }else{
                                DynamicForm_Session.clearFieldErrors("sessionStartHour", true);
                            }
                        }
                    },
                    {
                        name: "sessionTypeId",
                        title: "<spring:message code="session.type"/>",
                        type: "selectItem",
                        textAlign: "center",
                        required: true,
                        useClientFiltering: false,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        valueMap: {
                            "1": "آموزش",
                            "2": "آزمون"
                        },
                        pickListProperties: {
                            showFilterEditor: false
                        },
                        defaultValue: "1"
                    },
                    {
                        type: "SpacerItem"
                    },
                    /*{
                        name: "sessionState",
                        title: "<spring:message code="session.state"/>",
                        type: "selectItem",
                        textAlign: "center",
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        valueMap: {
                            "1": "شروع نشده",
                            "2": "در حال اجرا",
                            "3": "پایان"
                        },
                        defaultValue: "1",
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },*/
                    {
                        name: "sessionEndHour",
                        title: "<spring:message code="session.end.hour"/>",
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        hint: "--:--",
                        keyPressFilter: "[0-9:]",
                        showHintInField: true,
                        textAlign: "center",
                        validateOnChange: true,
                        editorExit:function(){
                            DynamicForm_Session.setValue("sessionEndHour",arrangeDate(DynamicForm_Session.getValue("sessionEndHour")));
                            let val=DynamicForm_Session.getValue("sessionEndHour");
                            if(val===null || val==='' || typeof (val) === 'undefined'|| !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)){
                                DynamicForm_Session.addFieldErrors("sessionEndHour", "<spring:message code="session.hour.invalid"/>", true);
                            }else{
                                DynamicForm_Session.clearFieldErrors("sessionEndHour", true);
                            }
                        }
                    },
                    {
                        name: "instituteId",
                        colSpan: 5,
                        // editorType: "TrComboAutoRefresh",
                        type: "ComboBoxItem",
                        multiple: false,
                        title: "<spring:message code="training.place"/>",
                        autoFetchData: false,
                        useClientFiltering: true,
                        optionDataSource: RestDataSource_Institute_JspSession,
                        displayField: "titleFa",
                        valueField: "id",
                        textAlign: "center",
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        pickListFields: [
                            {name: "titleFa", filterOperator: "iContains"},
                            {name: "manager.firstNameFa", filterOperator: "iContains"},
                            {name: "manager.lastNameFa", filterOperator: "iContains"}
                        ],
                        filterFields: ["titleFa", "manager.firstNameFa", "manager.lastNameFa"]
                    },
                    {
                        name: "teacherId",
                        colSpan: 5,
                        title: "<spring:message code='trainer'/>",
                        textAlign: "center",
                        type: "ComboBoxItem",
                        multiple: false,
                        displayField: "fullNameFa",
                        valueField: "id",
                        autoFetchData: false,
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        useClientFiltering: true,
                        optionDataSource: RestDataSource_Teacher_JspClass,
                        pickListFields: [
                            {
                                name: "personality.lastNameFa",
                                title: "<spring:message code="lastName"/>",
                                titleAlign: "center",
                                filterOperator: "iContains"
                            },
                            {
                                name: "personality.firstNameFa",
                                title: "<spring:message code="firstName"/>",
                                titleAlign: "center",
                                filterOperator: "iContains"
                            },
                            {
                                name: "personality.nationalCode",
                                title: "<spring:message code="national.code"/>",
                                titleAlign: "center",
                                filterOperator: "iContains"
                            }
                        ],
                        filterFields: [
                            "personality.lastNameFa",
                            "personality.firstNameFa",
                            "personality.nationalCode"
                        ],
                        click: function (form, item) {

                            if (ListGrid_Class_JspClass.getSelectedRecord() !== null) {

                                let ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                                let courseId = ClassRecord.course.id;

                                RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + courseId+"/0";
                                RestDataSource_Teacher_JspClass.invalidateCache();
                                item.fetchData();
                            } else {
                                RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/0/0";
                                RestDataSource_Teacher_JspClass.invalidateCache();
                                item.fetchData();
                                let dialogTeacher = isc.MyOkDialog.create({
                                    message: "<spring:message code="msg.record.select.class.ask"/>",
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
                        name: "trainingPlaceId",
                        editorType: "TrComboAutoRefresh",
                        title: "<spring:message code="training.location"/>",
                        align: "center",
                        optionDataSource: RestDataSource_TrainingPlace_JspSession,
                        displayField: "titleFa",
                        valueField: "id",
                        filterFields: ["titleFa", "capacity"],
                        required: true,
                        requiredMessage: "<spring:message code="msg.field.is.required"/>",
                        textAlign: "center",
                        pickListFields: [
                            {name: "titleFa"},
                            {name: "capacity"}
                        ],
                        click: function (form, item) {
                            if (form.getValue("instituteId")) {
                                RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + form.getValue("instituteId") + "/trainingPlaces";
                                item.fetchData();
                            } else {
                                RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + "0/trainingPlaces";
                                item.fetchData();
                                isc.MyOkDialog.create({
                                    message: "<spring:message code="chose.presenter"/>",
                                });
                            }
                        }
                    },
                    {
                        type: "SpacerItem"
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        textAlign: "center"
                    }
                ]
        });

        //*****create buttons*****
        var create_Buttons = isc.MyHLayoutButtons.create({
            members:
                [
                    isc.IButtonSave.create
                    ({
                        title: "<spring:message code="save"/> ",
                        icon: "[SKIN]/actions/save.png",
                        click: function () {
                            if (session_method === "POST") {
                                save_Session();
                            } else {
                                edit_Session();
                            }
                        }
                    }),
                    isc.IButtonCancel.create
                    ({
                        title: "<spring:message code="cancel"/>",
                        icon: "[SKIN]/actions/cancel.png",
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

    // <<-------------------------------------- Create - Session Content ---------------------------------
    var RestDataSource_Session_Content = isc.TrDS.create({
        fields: [
            {name: "context", title: "context"},
            {name: "groupId", title: "groupId"},
            {name: "deleted", title: "deleted"},
            {name: "title", title: "title", filterOperator: "iContains"}
        ]
    });

    var ListGrid_Session_Content = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Session_Content,
        showFilterEditor: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {
                name: "title",
                title: "نام فایل",
                align: "center"
            },
            {
                name: "download",
                title: "دریافت فایل",
                align: "center",
                canFilter: false
            }
        ],
        createRecordComponent: function (record, colNum) {

            var fieldName = this.getFieldName(colNum);
            if (record == null || fieldName != "download")
                return null;

            return isc.ToolStripButton.create({
                icon: "[SKIN]actions/download.png",
                width: "25",
                click: function () {

                    if (record == null) {return;}
                    downloadContentFile(record.groupId, record.context, record.title);
                }
            });
        }
    });

    var Window_Session_Content = isc.Window.create({
        title: "نمایش محتوای جلسه",
        width: "20%",
        height: "40%",
        autoSize: false,
        items: [ListGrid_Session_Content]
    });

    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
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

    // <<----------------------------------------------- Functions -----------------------------------------
        //*****check date is valid*****
        function check_valid_date() {

            DynamicForm_Session.getField("sessionStartHour").editorExit()
            DynamicForm_Session.getField("sessionEndHour").editorExit();

            DynamicForm_Session.clearFieldErrors("sessionDate", true);

            if (DynamicForm_Session.getValue("sessionDate") === undefined || !checkDate(DynamicForm_Session.getValue("sessionDate"))) {
                DynamicForm_Session.addFieldErrors("sessionDate", "<spring:message code='msg.correct.date'/>", true);
            } else {
                let class_startDate = ListGrid_Class_JspClass.getSelectedRecord().startDate;
                let class_endDate = ListGrid_Class_JspClass.getSelectedRecord().endDate;
                let class_sessionDate = DynamicForm_Session.getValue("sessionDate");

                if (class_sessionDate < class_startDate)
                    DynamicForm_Session.addFieldErrors("sessionDate", "<spring:message code="session.date.before.class.start.date"/>", true);
                else if (class_sessionDate > class_endDate)
                    DynamicForm_Session.addFieldErrors("sessionDate", "<spring:message code="session.date.after.class.end.date"/>", true);
                else
                    DynamicForm_Session.clearFieldErrors("sessionDate", true);
            }
        }

        //*****open insert window*****
        function create_Session() {
            if (ListGrid_Class_JspClass.getSelectedRecord() === null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.record.select.class.ask"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="course_Warning"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                if (ListGrid_Class_JspClass.getSelectedRecord().classStatus !== "3") {
                    let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                    const {trainingPlaceIds,teacherId,instituteId,teachingType,...record}=classRecord;
                    const essentialRecord={instituteId,trainingPlaceId:trainingPlaceIds[0],teacherId};

                    DynamicForm_Session.clearValues();

                    const teachingTypes=[ "غیر حضوری", "مجازی"];
                    let checkInstitute=false;

                    if (teachingTypes.includes(teachingType)){
                        changeStatusInstituteId(!checkInstitute);
                    }
                    else {
                        changeStatusInstituteId(checkInstitute);
                        checkInstitute=!checkInstitute;
                    }

                    if (checkInstitute && instituteId!=0) {
                        DynamicForm_Session.getField("instituteId").fetchData();
                        RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + instituteId + "/trainingPlaces";
                    }

                    RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + classRecord.courseId+"/"+teacherId;
                    RestDataSource_Teacher_JspClass.invalidateCache();

                    DynamicForm_Session.editRecord(essentialRecord);
                    session_method = "POST";
                    Window_Session.setTitle("<spring:message code="session"/>");
                    Window_Session.show();

                } else {
                    simpleDialog("<spring:message code="message"/>", "<spring:message code="the.class.is.over"/>", 3000, "stop");
                }
            }
        }

        function changeStatusInstituteId(status){
            DynamicForm_Session.getItem("instituteId").setDisabled(status);
            DynamicForm_Session.getItem("instituteId").setRequired(!status);

            DynamicForm_Session.getItem("trainingPlaceId").setDisabled(status);
            DynamicForm_Session.getItem("trainingPlaceId").setRequired(!status);
        }

        //*****insert function*****
        function save_Session() {

            DynamicForm_Session.validate();

            check_valid_date();

            if (DynamicForm_Session.hasErrors()){
                let errs = Object.keys(DynamicForm_Session.getErrors());
                let msg = "";
                errs.forEach(k=>msg = msg.concat(DynamicForm_Session.getErrors()[k]).concat("\n"))
                simpleDialog("<spring:message code="message"/>",msg , "0", "error");
                return;
            }
            let ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            let classId = ClassRecord.id;

            let sessionData = DynamicForm_Session.getValues();

            //**add new property to form values**
            sessionData["classId"] = classId;
            sessionData["sessionType"] = DynamicForm_Session.getItem("sessionTypeId").getDisplayValue();

            deleteRecord=false;

            wait.show();

            isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl, session_method, JSON.stringify(sessionData), show_SessionActionResult));
        }

        //*****open update window*****
        function show_SessionEditForm() {
            let record = ListGrid_session.getSelectedRecord();

            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                if (ListGrid_Class_JspClass.getSelectedRecord().classStatus !== "3") {
                    let ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                    let courseId = ClassRecord.course.id;
                    let teacherId =ClassRecord.teacherId;

                    const teachingTypes=[ "غیر حضوری", "مجازی"];
                    let checkInstitute=false;

                    if (teachingTypes.includes(ClassRecord.teachingType)){
                        changeStatusInstituteId(!checkInstitute);
                        record.instituteId=null;
                        record.trainingPlaceId=null;
                    }
                    else {
                        changeStatusInstituteId(checkInstitute);
                    }

                    let startHour_ = record.sessionStartHour.split(':')[0].trim();
                    record["sessionTime"] = (startHour_ === "08" ? "1" : startHour_ === "10" ? "2" : startHour_ === "14" ? "3" : "");

                    DynamicForm_Session.getField("instituteId").fetchData();
                    RestDataSource_TrainingPlace_JspSession.fetchDataURL = instituteUrl + record.instituteId + "/trainingPlaces";
                    RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + courseId+"/"+teacherId;
                    RestDataSource_Teacher_JspClass.invalidateCache();

                    session_method = "PUT";
                    DynamicForm_Session.clearValues();
                    DynamicForm_Session.editRecord(record);
                    Window_Session.setTitle("<spring:message code="session"/>");
                    Window_Session.show();
                } else {
                    simpleDialog("<spring:message code="message"/>", "<spring:message code="the.class.is.over"/>", 3000, "stop");
                }
            }
        }

        //*****update function*****
        function edit_Session() {

            DynamicForm_Session.validate();

            deleteRecord=false;

            check_valid_date();

            if (DynamicForm_Session.hasErrors()){
                let errs = Object.keys(DynamicForm_Session.getErrors());
                let msg = "";
                errs.forEach(k=>msg = msg.concat(DynamicForm_Session.getErrors()[k]).concat("\n"))
                simpleDialog("<spring:message code="message"/>",msg , "0", "error");
                return;
            }
            let sessionData = DynamicForm_Session.getValues();
            let sessionEditUrl = sessionServiceUrl;
            if (session_method.localeCompare("PUT") === 0) {
                let selectedRecord = ListGrid_session.getSelectedRecord();
                sessionEditUrl += selectedRecord.id;
            }

            sessionData["sessionType"] = DynamicForm_Session.getItem("sessionTypeId").getDisplayValue();
            //sessionData["sessionStateFa"] = DynamicForm_Session.getItem("sessionState").getDisplayValue();

            wait.show();

            isc.RPCManager.sendRequest(TrDSRequest(sessionEditUrl, session_method, JSON.stringify(sessionData), show_SessionActionResult));
        }

        //*****delete function*****
        function remove_Session() {
            let sessionIds=[];
            let records = ListGrid_session.getSelectedRecords();
            deleteRecord=true;

            if (records.length == 0) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                if (ListGrid_Class_JspClass.getSelectedRecord().classStatus !== "3") {
                    isc.MyYesNoDialog.create({
                        message: "<spring:message code="msg.record.removes.ask"/>",
                        title: "<spring:message code="verify.delete"/>",
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {

                                wait.show();
                                records.forEach(item=> sessionIds=[...sessionIds,parseInt(item.id)]);
                                isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + "deleteSessions/cId" + ListGrid_Class_JspClass.getSelectedRecord().id + "/sIds" + sessionIds , "DELETE", null, show_SessionActionResult));
                            }
                        }
                    });
                } else {
                    simpleDialog("<spring:message code="message"/>", "<spring:message code="the.class.is.over"/>", 3000, "stop");
                }
            }
        }

        //*****show action result function*****
        var MyOkDialog_Session;

        function show_SessionActionResult(resp) {
            wait.close();
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {
                loadPage_session();
                let responseID = JSON.parse(resp.data).id;
                let gridState = "[{id:" + responseID + "}]";

                let dataTemp=JSON.parse(resp.data);
                let success=parseInt(dataTemp.sucesses);
                let totalSizes=parseInt(dataTemp.totalSizes);
                let failures = totalSizes-success;

                if (deleteRecord) {
                    if (success != 0 && failures != 0) {
                        MyOkDialog_Session = isc.Dialog.create({
                            message: getFormulaMessage(failures.toString() + " ", 2, "red", "B") + "<spring:message code="attendance.meeting.none.nums"/>" + "<br/>" +
                                getFormulaMessage(success.toString() + " ", 2, "green", "B") + "<spring:message code="attendance.meeting.ok.nums"/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code="warning"/>",
                        });
                    } else if (success != 0) {
                        MyOkDialog_Session = isc.Dialog.create({
                            message: getFormulaMessage(success.toString() + " ", 2, "green", "B") + "<spring:message code="attendance.meeting.ok.nums"/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code="warning"/>",
                        });
                    }
                    else {
                        if (failures == 1) { //bug fix
                            MyOkDialog_Session = isc.Dialog.create({
                                message: "<spring:message code="attendance.meeting.none.nums"/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code="warning"/>",
                            });
                        }else{
                            MyOkDialog_Session = isc.Dialog.create({
                                message: getFormulaMessage(failures.toString() + " ", 2, "red", "B") + "<spring:message code="attendance.meeting.none.nums"/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code="warning"/>",
                            });
                        }

                    }
                } else {
                    MyOkDialog_Session = isc.Dialog.create({
                        message: "<spring:message code="global.form.request.successful"/>",
                        icon: "[SKIN]say.png",
                        title: "<spring:message code="ok"/>",
                    });
                }

                setTimeout(function () {

                    close_MyOkDialog_Session();

                },6000);

                Window_Session.close();

            } else {

                let respText = JSON.parse(resp.httpResponseText);

                if (resp.httpResponseCode === 409) {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: respText.message
                    });

                    close_MyOkDialog_Session()

                } else if (resp.httpResponseCode === 406) {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: respText.message
                    });

                    close_MyOkDialog_Session()

                } else if (resp.httpResponseCode === 503) {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: respText.message,
                        icon: "[SKIN]stop.png"
                    });

                }
                else if (resp.httpResponseCode === 428) {

                    MyOkDialog_Session = isc.MyOkDialog.create({
                        message: "<spring:message code="global.no.change.happend"/>"+ " " + "<spring:message code="check.attendance"/>",
                        icon: "[SKIN]stop.png"
                    });

                }
                else {
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
            }, 2000);
        }

        //*****print*****
        function print_SessionListGrid(type) {

            var record = ListGrid_session.getTotalRows();
            if (record === 0) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.for.print"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {

                var advancedCriteria_session = ListGrid_session.getCriteria();
                var criteriaForm_session = isc.DynamicForm.create({
                    method: "POST",
                    action: "<spring:url
        value="/class-session/printWithCriteria/"/>" + type + "/" + ListGrid_Class_JspClass.getSelectedRecord().id,
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"},
                            {name: "myToken", type: "hidden"}
                        ]
                });
                criteriaForm_session.setValue("CriteriaStr", JSON.stringify(advancedCriteria_session));
                criteriaForm_session.setValue("myToken", "<%=accessToken1%>");
                criteriaForm_session.show();
                criteriaForm_session.submitForm();

            }


        }

        function loadPage_session() {
            let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            if (!(classRecord == undefined || classRecord == null)) {
                //RestDataSource_session.fetchDataURL = sessionServiceUrl + "load-sessions" + "/" + ListGrid_Class_JspClass.getSelectedRecord().id;
                RestDataSource_session.fetchDataURL = sessionServiceUrl + "iscList/" + classRecord.id;

                if(classRecord.classStatus === "3")
                {
                    <sec:authorize access="hasAnyAuthority('TclassSessionsTab_R','TclassSessionsTab_C','TclassSessionsTab_U','TclassSessionsTab_D','TclassSessionsTab_P')">
                    ToolStrip_session.setVisibility(false)
                    </sec:authorize>
                }
                else
                {
                    <sec:authorize access="hasAnyAuthority('TclassSessionsTab_R','TclassSessionsTab_C','TclassSessionsTab_U','TclassSessionsTab_D','TclassSessionsTab_P')">
                    ToolStrip_session.setVisibility(true)
                    </sec:authorize>
                }

                if (classRecord.classStatus === "3")
                {
                    <sec:authorize access="hasAuthority('TclassSessionsTab_classStatus')">
                    ToolStrip_session.setVisibility(true)
                    </sec:authorize>
                }

                ListGrid_session.invalidateCache();
                ListGrid_session.fetchData();
            }
        }

        function getSessionContent(sessionId) {

            isc.RPCManager.sendRequest(TrDSRequest(attachmentUrl + "/findAll/" + sessionId, "GET", null, function (resp) {
                if(resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let content = JSON.parse(resp.httpResponseText);
                    ListGrid_Session_Content.setData(content);
                    Window_Session_Content.show();
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
        }

        function downloadContentFile(groupId, key, fileName) {

            let downloadForm = isc.DynamicForm.create({
                method: "GET",
                action: "minIo/downloadFile/" + groupId + "/" + key + "/" + fileName,
                target: "_Blank",
                canSubmit: true,
                fields: [
                    {name: "token", type: "hidden"}
                ]
            });
            downloadForm.setValue("token", "<%=accessToken1%>");
            downloadForm.show();
            downloadForm.submitForm();
        }

// </script>