<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    let saveMethod = null;

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Competence_Request = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "applicant", title: "درخواست دهنده", filterOperator: "iContains"},
            {name: "requestDate", title: "تاریخ درخواست", filterOperator: "iContains"},
            {name: "requestType", title: "نوع درخواست", filterOperator: "iContains",
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تعویض پست"
                }
            },
            {name: "letterNumber", title: "شماره نامه کارگزینی", filterOperator: "iContains"}
        ],
        fetchDataURL: competenceRequestUrl + "/spec-list"
    });
    RestDataSource_Competence_Request_Item = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "personnelNumber", title: "شماره پرسنلی", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "affairs", title: "امور", filterOperator: "iContains"},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "workGroupCode", title: "گروه کاری", filterOperator: "iContains"},
            {name: "state", title: "وضعیت", filterOperator: "iContains"},
            {name: "competenceReqId", hidden: true}
        ],
        fetchDataURL: requestItemUrl + "/spec-list"
    });
    RestDataSource_Competence_Request_Category = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Add_Competence_Request = isc.ToolStripButtonCreate.create({
        title: "افزودن درخواست",
        click: function () {
            saveMethod = "POST";
            addCompetenceRequest();
        }
    });
    ToolStripButton_Edit_Competence_Request = isc.ToolStripButtonEdit.create({
        click: function () {
            saveMethod = "PUT";
            editCompetenceRequest();
        }
    });
    ToolStripButton_Delete_Competence_Request = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteCompetenceRequest();
        }
    });
    ToolStripButton_Excel_Competence_Request = isc.ToolStripButton.create({
        name: "excelTemplate",
        title: "دریافت فایل خام اکسل",
        icon: "<spring:url value="excel.png"/>",
        click: function () {

            let headers = ListGrid_Competence_Request_Items.getFields().slice(1, 6).map(q => q.title);
            let fieldNames = ListGrid_Competence_Request_Items.getFields().slice(1, 6).map(q => q.name);
            window.open("${contextPath}/training/reportsToExcel/export?headers=" + headers + "&fieldNames=" + fieldNames);
        }
    });
    ToolStripButton_Refresh_Competence_Request = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Competence_Request.invalidateCache();
        }
    });

    ToolStrip_Actions_Requests_Certification = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Competence_Request,
            ToolStripButton_Edit_Competence_Request,
            ToolStripButton_Delete_Competence_Request,
            ToolStripButton_Excel_Competence_Request,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [ToolStripButton_Refresh_Competence_Request]
            })
        ]
    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Competence_Request = isc.DynamicForm.create({
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
                name: "applicant",
                title: "درخواست دهنده",
                required: true,
                canEdit: false
            },
            {
                name: "requestDate",
                ID: "date_requestDate",
                title: "تاریخ درخواست",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_requestDate', this, 'ymd', '/');
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
                name: "requestType",
                title: "نوع درخواست",
                required: true,
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تعویض پست"
                }
            },
            {
                name: "letterNumber",
                title: "شماره نامه کارگزینی",
                required: true
            }
        ]
    });

    Save_Button_Add_Requests = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveCompetenceRequest();
        }
    });
    Cancel_Button_Add_Requests = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Competence_Request.close();
        }
    });
    HLayout_IButtons_Competence_Request = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Requests,
            Cancel_Button_Add_Requests
        ]
    });

    Window_Competence_Request = isc.Window.create({
        title: "افزودن درخواست",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Competence_Request,
            HLayout_IButtons_Competence_Request
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Competence_Request = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Competence_Request,
        // contextMenu: Menu_ListGrid_InvoiceSales,
        autoFetchData: true,
        styleName: 'expandList',
        alternateRecordStyles: true,
        canExpandRecords: true,
        canExpandMultipleRecords: false,
        wrapCells: false,
        showRollOver: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFitExpandField: true,
        virtualScrolling: true,
        loadOnExpand: true,
        loaded: false,
        initialSort: [
            {property: "id", direction: "ascending"}
        ],
        fields: [
            {
                name: "id",
                title: "شماره درخواست",
                primaryKey: true,
                canEdit: false,
                width: "10%",
                align: "center"
            },
            {
                name: "applicant",
                title: "درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "requestDate",
                title: "تاریخ درخواست",
                width: "10%",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            },
            {
                name: "requestType",
                title: "نوع درخواست",
                width: "10%",
                align: "center",
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تعویض پست"
                }
            },
            {
                name: "letterNumber",
                title: "شماره نامه کارگزینی",
                width: "10%",
                align: "center"
            }
        ],
        getExpansionComponent: function (record) {

            var criteriaReq = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "competenceReqId", operator: "equals", value: record.id}]
            };

            ListGrid_Competence_Request_Items.fetchData(criteriaReq, function (dsResponse, data, dsRequest) {
                if (data.length == 0) {
                    ListGrid_Competence_Request_Items.setData([]);
                    ListGrid_Competence_Request_Items.show();
                } else {
                    ListGrid_Competence_Request_Items.setData(data);
                    ListGrid_Competence_Request_Items.setAutoFitMaxRecords(1);
                    ListGrid_Competence_Request_Items.show();
                }
            }, {operationId: "00"});

            var ToolStrip_Actions_Import_Data = isc.HLayout.create({
                width: "100%",
                // membersMargin: 5,
                members: [
                    isc.DynamicForm.create({
                        width: "20%",
                        numCols: 8,
                        fields: [
                            {
                                name: "excelFile",
                                type: "file",
                                title: "انتخاب فایل",
                                endRow: false,
                                colSpan: 1,
                                titleColSpan: 1
                            },
                            {
                                name: "import",
                                title: "وارد کردن اطلاعات",
                                type: "ButtonItem",
                                width: 120,
                                startRow: false,
                                colSpan: 1,
                                click: function () {

                                    debugger;
                                    let fileBrowserId = document.getElementById(ToolStrip_Actions_Import_Data.members[0].getItem("excelFile").uploadItem.getElement().id);
                                    let fieldNames = ListGrid_Competence_Request_Items.getFields().slice(1, 8).map(q => q.name);

                                    let formData = new FormData();
                                    formData.append("file", fileBrowserId.files[0]);
                                    formData.append("fieldNames", fieldNames);

                                    let request = new XMLHttpRequest();
                                    request.open("POST", "${contextPath}/training/reportsToExcel/import-data");
                                    request.setRequestHeader("contentType", "application/json; charset=utf-8");
                                    request.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
                                    request.send(formData);

                                    request.onreadystatechange = function () {

                                        if (request.readyState === XMLHttpRequest.DONE) {
                                            if (request.status === 0)
                                                isc.warn("00");
                                            else if (request.status === 500)
                                                isc.warn("500");
                                            else if (request.status === 200 || request.status === 201) {
                                                isc.warn("200");
                                                let gridData = JSON.parse(request.response);
                                                for (let i = 0; i < gridData.length; i++) {

                                                    // let grid = inspectionReportTab.listGrid.weightElement;
                                                    // grid.startEditing(i);
                                                    // gridData[i].inventoryId = grid.getEditValue(i, 1);
                                                    // grid.setEditValues(i, gridData[i]);
                                                    // if (gridData[i].weighingType !== "WeighBridge" && gridData[i].weighingType !== "DraftSurvey") {
                                                    //
                                                    //     let colNum = grid.fields.indexOf(grid.fields.filter(q => q.name === "weighingType").first());
                                                    //     grid.setEditValue(i, colNum, "WeighBridge");
                                                    // }
                                                    // grid.endEditing();
                                                }
                                            }
                                        }
                                    };
                                }
                            }
                        ]
                    }),
                    isc.ToolStripButtonExcel.create({
                        align: "left",
                        click: function () {
                        }
                    })
                ]
            });

            var layoutCompetenceRequest = isc.VLayout.create({
                styleName: "expand-layout",
                padding: 5,
                // membersMargin: 10,
                members: [
                    ListGrid_Competence_Request_Items,
                    ToolStrip_Actions_Import_Data
                ]
            });

            return layoutCompetenceRequest;
        }
    });
    ListGrid_Competence_Request_Items = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        styleName: "listgrid-child",
        height: 180,
        dataSource: RestDataSource_Competence_Request_Item,
        // contextMenu: Menu_ListGrid_InvoiceSalesItem,
        setAutoFitExtraRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true
            },
            {
                name: "personnelNumber",
                width: "10%",
                align: "center"
            },
            {
                name: "name",
                // title: "نام",
                width: "10%",
                align: "center"
            },
            {
                name: "lastName",
                // title: "نام خانوادگی",
                width: "10%",
                align: "center"
            },
            {
                name: "affairs",
                // title: "امور",
                width: "10%",
                align: "center"
            },
            {
                name: "post",
                // title: "کدپست پیشنهادی",
                width: "10%",
                align: "center"
            },
            {
                name: "workGroupCode",
                // title: "گروه کاری",
                width: "10%",
                align: "center",
                autoFetchData: false,
                optionDataSource: RestDataSource_Competence_Request_Category,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "state",
                // title: "وضعیت",
                width: "10%",
                align: "center",
                valueMap: {
                    1: "بلامانع",
                    2: "نیاز به گذراندن دوره"
                }
            },
            {
                name: "competenceReqId",
                hidden: true
            },
            {
                name: "editIcon",
                width: "4%",
                align: "center",
                showTitle: false
            },
            {
                name: "removeIcon",
                width: "4%",
                align: "center",
                showTitle: false
            }
        ],
        autoFetchData: false,
        createRecordComponent: function (record, colNum) {

            var fieldName = this.getFieldName(colNum);
            var recordCanvas = isc.HLayout.create(
                {
                    height: 22,
                    width: "100%",
                    align: "center"
                });
            if (fieldName === "editIcon") {
                var editImg = isc.ImgButton.create(
                    {
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/edit.png",
                        prompt: "ویرایش",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            // ListGrid_InvoiceSalesItem.selectSingleRecord(record);
                            // ListGrid_InvoiceSalesItem_edit();
                        }
                    });
                return editImg;
            } else if (fieldName === "removeIcon") {
                var removeImg = isc.ImgButton.create(
                    {
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/remove.png",
                        prompt: "حذف",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            // ListGrid_InvoiceSalesItem.selectSingleRecord(record);
                            // ListGrid_InvoiceSalesItem_remove();
                        }
                    });
                return removeImg;
            } else {
                return null;
            }
        }
    });

    //--------------------------------------------------------Tab Set---------------------------------------------------

    ListGrid_Personnel_Job_History = isc.TrLG.create({
        width: "100%",
        height: 600,
        fields: [
            {name: "startDate", title: 'تاریخ شروع', width: "10%"},
            {name: "endDate", title: 'تاریخ پایان', width: "10%"},
            {name: "postTitle", title: "عنوان پست", width: "10%", align: "center"},
            {name: "postCode", title: "کد پست", width: "10%", align: "center"},
            {name: "affair", title: "امور", width: "10%", align: "center"},
            {name: "section", title: "قسمت", width: "10%", align: "center"},
            {name: "departmentTitle", title: "نام شرکت", width: "10%", align: "center"}
        ]
    });
    ListGrid_Post_History = isc.TrLG.create({
        width: "100%",
        height: 600,
        fields: [
            {name: "firstName", title: 'نام', width: "10%"},
            {name: "lastName", title: 'نام خانوادگی', width: "10%"},
            {name: "startDate", title: 'تاریخ شروع', width: "10%"},
            {name: "endDate", title: 'تاریخ پایان', width: "10%"},
            {name: "postTitle", title: "عنوان پست", width: "10%", align: "center"},
            {name: "postCode", title: "کد پست", width: "10%", align: "center"},
            {name: "affair", title: "امور", width: "10%", align: "center"},
            {name: "section", title: "قسمت", width: "10%", align: "center"},
            {name: "departmentTitle", title: "نام شرکت", width: "10%", align: "center"}
        ]
    });
    ListGrid_Personnel_Training_History = isc.TrLG.create({
        width: "100%",
        height: 600,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code",
                title: "<spring:message code="class.code"/>",
                align: "center"
            },
            {
                name: "courseTitle",
                title: "<spring:message code="course.title"/>",
                align: "center"
            },
            {
                name: "courseCode",
                title: "<spring:message code="course.code"/>",
                align: "center"
            },
            {
                name: "hduration",
                title: "<spring:message code="class.duration"/>",
                align: "center"
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center"
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                align: "center"
            },
            {
                name: "classStatus",
                title: "<spring:message code="class.status"/>",
                align: "center"
            },
            {
                name: "scoreState",
                title: "<spring:message code="score.state"/>",
                align: "center"
            },
            {
                name: "erunType",
                title: "<spring:message code="course_eruntype"/>",
                align: "center"
            }
        ]
    });

    Requests_Detail_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_Personnel_Job_History", title: "سوابق شغلی پرسنل", pane: ListGrid_Personnel_Job_History},
            {name: "TabPane_Post_History", title: "سوابق پست پیشنهادی", pane: ListGrid_Post_History},
            {
                name: "TabPane_Personnel_Training_History",
                title: "دوره های گذرانده فرد",
                pane: ListGrid_Personnel_Training_History
            }
        ],
        tabSelected: function () {
            // selectionUpdated_TrainingPost_Jsp();
        }
    });

    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Requests_Certification = isc.VLayout.create({
        width: "100%",
        height: "1%",
        members: [
            ToolStrip_Actions_Requests_Certification,
            ListGrid_Competence_Request
        ]
    });
    VLayout_Requests_Detail_Certification = isc.VLayout.create({
        width: "100%",
        members: [
            ListGrid_Competence_Request_Items
        ]
    });
    HLayout_Body_Certification_Jsp = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        members: [
            isc.SectionStack.create({
                sections: [
                    {
                        title: "درخواست های تاییدیه",
                        items: VLayout_Requests_Certification,
                        showHeader: false,
                        expanded: true
                    },
                    {
                        title: "جزئیات درخواست",
                        hidden: true,
                        items: VLayout_Requests_Detail_Certification,
                        expanded: false
                    }
                ]
            })
        ]
    });

    HLayout_Tabs_Certification = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [Requests_Detail_Tabs]
    });

    VLayout_Body_Certification_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Body_Certification_Jsp,
            HLayout_Tabs_Certification
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------

    function addCompetenceRequest() {

        DynamicForm_Competence_Request.clearValues();
        DynamicForm_Competence_Request.clearErrors();
        DynamicForm_Competence_Request.setValue("applicant", userUserName);
        Window_Competence_Request.show();
    }

    function editCompetenceRequest() {

        let record = ListGrid_Competence_Request.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            record.requestDate = new Date(record.requestDate).toLocaleDateString('fa-IR');
            DynamicForm_Competence_Request.editRecord(record);
            Window_Competence_Request.show();
        }
    }

    function saveCompetenceRequest() {

        if (!DynamicForm_Competence_Request.validate())
            return;

        if (saveMethod === "POST") {

            let data = DynamicForm_Competence_Request.getValues();
            data.requestDate = JalaliDate.jalaliToGregori(data.requestDate);

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Competence_Request.close();
                    ListGrid_Competence_Request.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else {

            debugger;
            let record = ListGrid_Competence_Request.getSelectedRecord();

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl + "/" + record.id, "PUT", JSON.stringify(record), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Competence_Request.close();
                    ListGrid_Competence_Request.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }

    }

    function deleteCompetenceRequest() {

        let record = ListGrid_Competence_Request.getSelectedRecord();
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
                        isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Competence_Request.invalidateCache();

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

    //---------------------------------------------------------Mock-----------------------------------------------------

    // ListGrid_Competence_Request.setData([
    //     {
    //         id: "1",
    //         requestNo: "4586648",
    //         requester: "زهرا احمدی کوثرریزی",
    //         requestDate: "1400/03/25",
    //         requestType: "انتصاب سمت",
    //         letterNo: "4108996"
    //     },
    //     {
    //         id: "2",
    //         requestNo: "3286650",
    //         requester: "سیستم انتصاب سمت",
    //         requestDate: "1400/03/31",
    //         requestType: "انتصاب سمت",
    //         letterNo: ""
    //     }
    // ]);
    // ListGrid_Competence_Request_Items.setData([
    //     {
    //         id: "1",
    //         personnelNo: "1409023295",
    //         personnelFirstName: "رضا",
    //         personnelLastName: "خراسانی دهوئی",
    //         affairs: "امور آب و بازیافت(سرچشمه)",
    //         postCode: "52023502/1",
    //         category: 8,
    //         status: 1,
    //         requestId: "1"
    //     },
    //     {
    //         id: "2",
    //         personnelNo: "3149096073",
    //         personnelFirstName: "منوچهر",
    //         personnelLastName: "ریاحی مدوار",
    //         affairs: "امور روابط عمومی و خدمات اجتماعی شهربابک",
    //         postCode: "7904780914/7",
    //         category: 5,
    //         status: 2,
    //         requestId: "1"
    //     }
    // ]);
    //
    // ListGrid_Personnel_Job_History.setData([
    //     {
    //         startDate: "1390/01/01",
    //         endDate: "1393/03/27",
    //         postTitle: "مسئول کارگاه جوشکاری و ساخت",
    //         postCode: "71221901/1",
    //         affair: "",
    //         section: "",
    //         departmentTitle: ""
    //     },
    //     {
    //         startDate: "1393/03/27",
    //         endDate: "1396/03/01",
    //         postTitle: "سرپرست شیفت",
    //         postCode: "61023901/2",
    //         affair: "",
    //         section: "",
    //         departmentTitle: ""
    //     }
    // ]);
    // ListGrid_Post_History.setData([
    //     {
    //         firstName: "",
    //         lastName: "",
    //         startDate: "1394/05/01",
    //         endDate: "1395/10/01",
    //         postTitle: "کارشناس برنامه ریزی",
    //         postCode: "52023502/1",
    //         affair: "",
    //         section: "",
    //         departmentTitle: ""
    //     },
    //     {
    //         firstName: "مهیار",
    //         lastName: "اسماعیلی",
    //         startDate: "1395/10/01",
    //         endDate: "1399/10/20",
    //         postTitle: "کارشناس برنامه ریزی",
    //         postCode: "52023502/1",
    //         affair: "",
    //         section: "",
    //         departmentTitle: ""
    //     }
    // ]);
    // ListGrid_Personnel_Training_History.setData([
    //     {
    //         id: "1",
    //         code: "SA1C4T02-1396-388",
    //         courseTitle: "ایمنی",
    //         courseCode: "SA1C4T02",
    //         hduration: "12",
    //         startDate: "1396/03/27",
    //         endDate: "1396/03/30",
    //         classStatus: "پایان یافته",
    //         scoreState: "(قبول با نمره) نمره: 15",
    //         erunType: "داخلي"
    //     },
    //     {
    //         id: "2",
    //         code: "SA1C4T04-1396-416",
    //         courseTitle: "حفاظت محیط زیست",
    //         courseCode: "SA1C4T04",
    //         hduration: "6",
    //         startDate: "1396/03/29",
    //         endDate: "1396/03/29",
    //         classStatus: "پایان یافته",
    //         scoreState: "(حذف دانشجو از کلاس به دلیل غیبت غیرمجاز)",
    //         erunType: "داخلي"
    //     },
    //     {
    //         id: "3",
    //         code: "SA1C4T03-1396-395",
    //         courseTitle: "بهداشت صنعتی",
    //         courseCode: "SA1C4T03",
    //         hduration: "6",
    //         startDate: "1396/03/28",
    //         endDate: "1396/03/28",
    //         classStatus: "پایان یافته",
    //         scoreState: "(قبول با نمره) نمره: 13",
    //         erunType: "داخلي"
    //     }
    // ]);

// </script>