<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

    // <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Request_Items = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "processInstanceId", hidden: true},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "letterNumber", title: "شماره نامه کارگزینی", filterOperator: "iContains"},
            {name: "requestNo", title: "شماره درخواست", filterOperator: "iContains"},
            {name: "requestDate", title: "تاریخ درخواست", filterOperator: "iContains"},
            {name: "applicant", title: "درخواست دهنده", filterOperator: "iContains", hidden: true},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "postTitle", title: "پست پیشنهادی", filterOperator: "iContains"},
            {name: "currentPostTitle", title: "پست فعلی", filterOperator: "iContains"},
            {name: "competenceReqId", hidden: true}
        ],
        fetchDataURL: requestItemUrl + "/ended-list"
    });
    RestDataSource_Request_Item_Courses_Detail = isc.TrDS.create({
        fields: [
            {name: "courseCode", title: "کد دوره", filterOperator: "iContains"},
            {name: "courseTitle", title: "نام دوره", filterOperator: "iContains"},
            {name: "priority", title: "اولویت", filterOperator: "iContains"},
            {name: "classCode", title: "کد کلاس", filterOperator: "iContains"},
            {name: "classTitle", title: "عنوان کلاس", filterOperator: "iContains"},
            {name: "score", title: "نمره", filterOperator: "iContains"},
            {name: "scoresStateId", title: "وضعیت قبولی", filterOperator: "iContains"}
        ]
    });
    RestDataSource_ScoreState_Ended_Certificaton = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/StudentScoreState"
    });

    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Send_Letter = isc.ToolStripButtonCreate.create({
        title: "ثبت نامه ارسالی به کارگزینی",
        click: function () {
            let records = ListGrid_Request_Items.getSelectedRecords();
            if (records === null || records.size() === 0) {
                isc.Dialog.create({
                    message: "رکوردی انتخاب نشده است",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                DynamicForm_Send_Letter.clearValues();
                Window_Send_Letter.show();
            }
        }
    });
    ToolStripButton_Refresh_Ended_Certification = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Request_Items.invalidateCache();
        }
    });

    ToolStrip_Actions_Ended_Certification = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Send_Letter,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Ended_Certification
                ]
            })
        ]
    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Send_Letter = isc.DynamicForm.create({
        colWidths: ["25%", "75%"],
        width: "100%",
        height: "85%",
        numCols: "2",
        autoFocus: "true",
        cellPadding: 5,
        fields: [
            {
                name: "letterNumberSent",
                title: "شماره نامه ارسالی به کارگزینی",
                required: true
            },
            {
                name: "dateSent",
                title: "تاریخ ارسال به کارگزینی",
                required: true,
                ID: "dateSent_userPortfolio",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('dateSent_userPortfolio', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            }
        ]
    });

    Save_Button_Send_Letter = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            sendLetterForAppointment();
        }
    });
    Cancel_Button_Send_Letter = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Send_Letter.close();
        }
    });
    HLayout_IButtons_Send_Letter = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Send_Letter,
            Cancel_Button_Send_Letter
        ]
    });

    Window_Send_Letter = isc.Window.create({
        title: "ثبت نامه ارسالی به کارگزینی",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Send_Letter,
            HLayout_IButtons_Send_Letter
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Request_Items = isc.TrLG.create({
        showFilterEditor: false,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Request_Items,
        autoFetchData: true,
        styleName: 'expandList',
        alternateRecordStyles: true,
        canExpandRecords: true,
        canExpandMultipleRecords: false,
        wrapCells: false,
        showRollOver: false,
        autoFitExpandField: true,
        virtualScrolling: true,
        loadOnExpand: true,
        loaded: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "processInstanceId",
                hidden: true
            },
            {
                name: "name",
                width: "10%",
                align: "center"
            },
            {
                name: "lastName",
                width: "10%",
                align: "center"
            },
            {
                name: "nationalCode",
                width: "10%",
                align: "center"
            },
            {
                name: "letterNumber",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false
            },
            {
                name: "requestNo",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false
            },
            {
                name: "requestDate",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false
            },
            {
                name: "applicant",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false,
                hidden: true
            },
            {
                name: "post",
                width: "10%",
                align: "center"
            },
            {
                name: "postTitle",
                width: "10%",
                align: "center"
            },
            {
                name: "currentPostTitle",
                width: "10%",
                align: "center",
            },
            {
                name: "competenceReqId",
                hidden: true
            },
            {
                name: "showDetail",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false,
                hidden: true
            }
        ],
        getExpansionComponent: function (record) {

            RestDataSource_Request_Item_Courses_Detail.fetchDataURL = requestItemUrl + "/appointment-courses-list/" + record.id;
            ListGrid_Request_Item_Courses_Detail.fetchData(null, function (dsResponse, data, dsRequest) {
                if (data.length == 0) {
                    ListGrid_Request_Item_Courses_Detail.setData([]);
                    ListGrid_Request_Item_Courses_Detail.show();
                } else {
                    ListGrid_Request_Item_Courses_Detail.setData(data);
                    ListGrid_Request_Item_Courses_Detail.setAutoFitMaxRecords(1);
                    ListGrid_Request_Item_Courses_Detail.show();
                }
            }, {operationId: "00"});

            let layoutCoursesDetail = isc.VLayout.create({
                styleName: "expand-layout",
                padding: 5,
                members: [
                    ListGrid_Request_Item_Courses_Detail,
                ]
            });
            return layoutCoursesDetail;
        }
    });
    ListGrid_Request_Item_Courses_Detail = isc.TrLG.create({
        autoFetchData: false,
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        styleName: "listgrid-child",
        height: 250,
        dataSource: RestDataSource_Request_Item_Courses_Detail,
        setAutoFitExtraRecords: true,
        fields: [
            {
                name: "courseCode",
                width: "10%",
                align: "center"
            },
            {
                name: "courseTitle",
                width: "10%",
                align: "center"
            },
            {
                name: "priority",
                width: "10%",
                align: "center"
            },
            {
                name: "classCode",
                width: "10%",
                align: "center"
            },
            {
                name: "classTitle",
                width: "10%",
                align: "center"
            },
            {
                name: "score",
                width: "10%",
                align: "center"
            },
            {
                name: "scoresStateId",
                width: "10%",
                align: "center",
                type: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_ScoreState_Ended_Certificaton
            }
        ]
    });

    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Request_Items = isc.VLayout.create({
        width: "100%",
        height: "1%",
        members: [
            ToolStrip_Actions_Ended_Certification,
            ListGrid_Request_Items
        ]
    });
    VLayout_Request_Item_Courses_Detail = isc.VLayout.create({
        width: "100%",
        members: [
            ListGrid_Request_Item_Courses_Detail
        ]
    });
    HLayout_Body_Ended_Certification = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        members: [
            isc.SectionStack.create({
                sections: [
                    {
                        title: "آیتم های درخواست ها",
                        items: VLayout_Request_Items,
                        showHeader: false,
                        expanded: true
                    },
                    {
                        title: "جزئیات دوره ها",
                        hidden: true,
                        items: VLayout_Request_Item_Courses_Detail,
                        expanded: false
                    }
                ]
            })
        ]
    });

    VLayout_Body_Ended_Certification = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Body_Ended_Certification,
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------

    function sendLetterForAppointment() {

        if (!DynamicForm_Send_Letter.validate())
            return;

        let ids = ListGrid_Request_Items.getSelectedRecords().map(item => item.id);
        let letterNumberSent = DynamicForm_Send_Letter.getValue("letterNumberSent");
        let dateSent = DynamicForm_Send_Letter.getValue("dateSent");
        let baseUrl = requestItemUrl;
        let url = "/send-letter";

        let sendLetterInfo = {
            letterNumberSent: letterNumberSent,
            dateSent: dateSent,
            ids: ids
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(sendLetterInfo), function (resp) {
            wait.close();
            createDialog("info", "<spring:message code="global.form.request.successful"/>");
            Window_Send_Letter.close();
            ToolStripButton_Refresh_Ended_Certification.click();
        }));
    }

    // </script>