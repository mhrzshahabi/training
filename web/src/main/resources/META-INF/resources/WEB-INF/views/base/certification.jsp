<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Certification_category = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Add_Requests_Certification = isc.ToolStripButton.create({
        name: "addRequest",
        title: "افزودن درخواست",
        click: function () {
            Window_Add_Request_Certification.show();
        }
    });
    ToolStripButton_Excel_Requests_Certification = isc.ToolStripButton.create({
        name: "addRequest",
        title: "دریافت فایل خام اکسل",
        icon: "<spring:url value="excel.png"/>",
        click: function () {
        }
    });
    ToolStripButton_Refresh_Requests_Certification = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Requests_Certification.invalidateCache();
        }
    });

    ToolStrip_Actions_Requests_Certification = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Requests_Certification,
            ToolStripButton_Excel_Requests_Certification,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [ToolStripButton_Refresh_Requests_Certification]
            })
        ]
    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Add_Requests_Certification = isc.DynamicForm.create({
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
                name: "requestNo",
                title: "شماره درخواست"
            },
            {
                name: "requester",
                title: "درخواست دهنده"
            },
            {
                name: "requestDate",
                title: "تاریخ درخواست"
            },
            {
                name: "requestType",
                title: "نوع درخواست"
            },
            {
                name: "letterNo",
                title: "شماره نامه کارگزینی"
            }
        ]
    });

    Save_Button_Add_Requests = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
        }
    });
    Cancel_Button_Add_Requests = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Add_Request_Certification.close();
        }
    });
    HLayout_IButtons_Requests_Certification = isc.HLayout.create({
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

    Window_Add_Request_Certification = isc.Window.create({
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
            DynamicForm_Add_Requests_Certification,
            HLayout_IButtons_Requests_Certification
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Requests_Certification = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        // dataSource: RestDataSource_invoiceSales,
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
        sortField: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "requestNo",
                title: "شماره درخواست",
                width: "10%",
                align: "center"
            },
            {
                name: "requester",
                title: "درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "requestDate",
                title: "تاریخ درخواست",
                width: "10%",
                align: "center"
            },
            {
                name: "requestType",
                title: "نوع درخواست",
                width: "10%",
                align: "center"
            },
            {
                name: "letterNo",
                title: "شماره نامه کارگزینی",
                width: "10%",
                align: "center"
            }
        ],
        getExpansionComponent: function (record) {

            var criteria1 = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "requestId", operator: "equals", value: record.id}]
            };

            // ListGrid_InvoiceSalesItem.fetchData(criteria1, function (dsResponse, data, dsRequest) {
            // if (data.length == 0) {
            // recordNotFound.show();
            // ListGrid_InvoiceSalesItem.hide()
            // } else {
            // recordNotFound.hide();
            // ListGrid_InvoiceSalesItem.setData(data);
            // ListGrid_InvoiceSalesItem.setAutoFitMaxRecords(1);
            // ListGrid_InvoiceSalesItem.show();
            // }
            // }, {operationId: "00"});

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
                                colSpan: 1
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

            var layoutInvoiceSales = isc.VLayout.create({
                styleName: "expand-layout",
                padding: 5,
                // membersMargin: 10,
                members: [
                    ListGrid_Requests_Detail_Certification,
                    ToolStrip_Actions_Import_Data
                    // recordNotFound,
                ]
            });

            return layoutInvoiceSales;
        }
    });
    ListGrid_Requests_Detail_Certification = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        styleName: "listgrid-child",
        height: 180,
        // dataSource: RestDataSource_invoiceSalesItem,
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
                name: "personnelNo",
                title: "شماره پرسنل",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelFirstName",
                title: "نام",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelLastName",
                title: "نام خانوادگی",
                width: "10%",
                align: "center"
            },
            {
                name: "affairs",
                title: "امور",
                width: "10%",
                align: "center"
            },
            {
                name: "postCode",
                title: "کدپست پیشنهادی",
                width: "10%",
                align: "center"
            },
            {
                name: "category",
                title: "گروه کاری",
                width: "10%",
                align: "center",
                autoFetchData: false,
                optionDataSource: RestDataSource_Certification_category,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "status",
                title: "وضعیت",
                width: "10%",
                align: "center",
                valueMap: {
                    1: "بلامانع",
                    2: "نیاز به گذراندن دوره"
                }
            },
            {
                name: "requestId",
                width: "10%",
                align: "center",
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
            {name: "TabPane_Personnel_Training_History", title: "دوره های گذرانده فرد", pane: ListGrid_Personnel_Training_History}
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
            ListGrid_Requests_Certification
        ]
    });
    VLayout_Requests_Detail_Certification = isc.VLayout.create({
        width: "100%",
        members: [
            // ToolStrip_Actions_Requests_Detail_Certification,
            ListGrid_Requests_Detail_Certification
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


    //---------------------------------------------------------Mock-----------------------------------------------------

    ListGrid_Requests_Certification.setData([
        {
            id: "1",
            requestNo: "4586648",
            requester: "زهرا احمدی کوثرریزی",
            requestDate: "1400/03/25",
            requestType: "انتصاب سمت",
            letterNo: "4108996"
        },
        {
            id: "2",
            requestNo: "3286650",
            requester: "سیستم انتصاب سمت",
            requestDate: "1400/03/31",
            requestType: "انتصاب سمت",
            letterNo: ""
        }
    ]);
    ListGrid_Requests_Detail_Certification.setData([
        {
            id: "1",
            personnelNo: "1409023295",
            personnelFirstName: "رضا",
            personnelLastName: "خراسانی دهوئی",
            affairs: "امور آب و بازیافت(سرچشمه)",
            postCode: "52023502/1",
            category: 8,
            status: 1,
            requestId: "1"
        },
        {
            id: "2",
            personnelNo: "3149096073",
            personnelFirstName: "منوچهر",
            personnelLastName: "ریاحی مدوار",
            affairs: "امور روابط عمومی و خدمات اجتماعی شهربابک",
            postCode: "7904780914/7",
            category: 5,
            status: 2,
            requestId: "1"
        }
    ]);

    ListGrid_Personnel_Job_History.setData([
        {
            startDate: "1390/01/01",
            endDate: "1393/03/27",
            postTitle: "مسئول کارگاه جوشکاری و ساخت",
            postCode: "71221901/1",
            affair: "",
            section: "",
            departmentTitle: ""
        },
        {
            startDate: "1393/03/27",
            endDate: "1396/03/01",
            postTitle: "سرپرست شیفت",
            postCode: "61023901/2",
            affair: "",
            section: "",
            departmentTitle: ""
        }
    ]);
    ListGrid_Post_History.setData([
        {
            firstName: "",
            lastName: "",
            startDate: "1394/05/01",
            endDate: "1395/10/01",
            postTitle: "کارشناس برنامه ریزی",
            postCode: "52023502/1",
            affair: "",
            section: "",
            departmentTitle: ""
        },
        {
            firstName: "مهیار",
            lastName: "اسماعیلی",
            startDate: "1395/10/01",
            endDate: "1399/10/20",
            postTitle: "کارشناس برنامه ریزی",
            postCode: "52023502/1",
            affair: "",
            section: "",
            departmentTitle: ""
        }
    ]);
    ListGrid_Personnel_Training_History.setData([
        {
            id: "1",
            code: "SA1C4T02-1396-388",
            courseTitle: "ایمنی",
            courseCode: "SA1C4T02",
            hduration: "12",
            startDate: "1396/03/27",
            endDate: "1396/03/30",
            classStatus: "پایان یافته",
            scoreState: "(قبول با نمره) نمره: 15",
            erunType: "داخلي"
        },
        {
            id: "2",
            code: "SA1C4T04-1396-416",
            courseTitle: "حفاظت محیط زیست",
            courseCode: "SA1C4T04",
            hduration: "6",
            startDate: "1396/03/29",
            endDate: "1396/03/29",
            classStatus: "پایان یافته",
            scoreState: "(حذف دانشجو از کلاس به دلیل غیبت غیرمجاز)",
            erunType: "داخلي"
        },
        {
            id: "3",
            code: "SA1C4T03-1396-395",
            courseTitle: "بهداشت صنعتی",
            courseCode: "SA1C4T03",
            hduration: "6",
            startDate: "1396/03/28",
            endDate: "1396/03/28",
            classStatus: "پایان یافته",
            scoreState: "(قبول با نمره) نمره: 13",
            erunType: "داخلي"
        }
    ]);

    // </script>