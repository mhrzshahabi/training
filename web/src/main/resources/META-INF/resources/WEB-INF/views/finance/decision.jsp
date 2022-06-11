<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Decision_Header = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "complex", title: "مجتمع", filterOperator: "iContains"},
            {name: "itemFromDate", title: "تاریخ شروع", filterOperator: "iContains"},
            {name: "itemToDate", title: "تاریخ پایان", filterOperator: "iContains"},
        ],
        fetchDataURL: educationalDecisionHeaderRequestUrl + "/list"
    });

    let RestDataSource_decision_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Decision = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate",
                title: "تاریخ شروع هدر",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate",
                title: "تاریخ پایان هدر",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "complex",
                title: "مجتمع",
                required: true,
                optionDataSource: RestDataSource_decision_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "title",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            }
        ]
    });



    Save_Button_Add_Decision = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveDecisionHeader();
        }
    });

    Cancel_Button_Add_Decision = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_header_Decision.close();
        }
    });



    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Decision_Header = isc.ListGrid.create({
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Decision_Header,
        autoFetchData: true,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "complex",
                title: "مجتمع",
                width: "10%",
                align: "center"
            },
            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],

    });
    //----------------------------------------------------Actions --------------------------------------------------

    ToolStripButton_Add_Decision = isc.ToolStripButtonCreate.create({
        title: "افزودن هدر تصمیم گیری",
        click: function () {
            addHeaderDecision();
        }
    });

    ToolStripButton_Delete_Decision = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteDecisionHeader();
        }
    });

    ToolStripButton_Refresh_Decision = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Decision_Header.invalidateCache();
        }
    });


    //----------------------------------- layOut -----------------------------------------------------------------------

    HLayout_IButtons_Decision = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Decision,
            Cancel_Button_Add_Decision
        ]
    });
    Window_header_Decision = isc.Window.create({
        title: "افزودن هدر تصمیم گیری",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Decision,
            HLayout_IButtons_Decision
        ]
    });

    ToolStrip_Actions_Decision = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Decision,
            ToolStripButton_Delete_Decision,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Decision
                ]
            })
        ]
    });

    VLayout_Body_Decision = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Decision,
            ListGrid_Decision_Header
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function addHeaderDecision() {

        DynamicForm_Decision.clearValues();
        DynamicForm_Decision.clearErrors();
        Window_header_Decision.show();
    }
    function saveDecisionHeader() {

        if (!DynamicForm_Decision.validate())
            return;
        if(DynamicForm_Decision.getValue("itemToDate") < DynamicForm_Decision.getValue("itemFromDate")) {
            createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
            return;
        }
        let data = DynamicForm_Decision.getValues();

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_header_Decision.close();
                    ListGrid_Decision_Header.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));


    }

    function deleteDecisionHeader() {
        let record = ListGrid_Decision_Header.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_Request_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Decision_Header.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            });
        }
    }


    // </script>