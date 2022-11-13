<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Competence_Request_Item = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "processInstanceId", hidden: true},
            {name: "requestNo", title: "شماره درخواست", filterOperator: "iContains"},
            {name: "applicant", title: "درخواست دهنده", filterOperator: "iContains"},
            {name: "requestDate", title: "تاریخ درخواست", filterOperator: "iContains"},
            {name: "requestType", title: "نوع درخواست", filterOperator: "iContains"},
            {name: "letterNumber", title: "شماره نامه کارگزینی", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "personnelNo2", title: "شماره پرسنلی قدیم", filterOperator: "iContains"},
            {name: "personnelNumber", title: "شماره پرسنلی جدید", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "educationLevel", title: "مدرک تحصیلی", filterOperator: "iContains"},
            {name: "educationMajor", title: "رشته", filterOperator: "iContains"},
            {name: "currentPostTitle", title: "پست فعلی", filterOperator: "iContains"},
            {name: "postTitle", title: "پست پیشنهادی", filterOperator: "iContains"},
            {name: "affairs", title: "امور", filterOperator: "iContains"},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "letterNumberSent", title: "شماره نامه ارسالی به کارگزینی", filterOperator: "iContains"},
            {name: "dateSent", title: "تاریخ ارسال به کارگزینی", filterOperator: "iContains"},
            {name: "competenceReqId", hidden: true}
        ],
        fetchDataURL: requestItemUrl + "/report-list"
    });
    RestDataSource_Request_Item_Process_History = isc.TrDS.create({
        fields: [
            {name: "name", title: "نام مرحله فرایند", filterOperator: "iContains"},
            {name: "timeComing", title: "زمان ورود به کارتابل", filterOperator: "iContains"},
            {name: "endTime", title: "زمان خروج از کارتابل", filterOperator: "iContains"},
            {name: "waitingTime", title: "زمان انتظار", filterOperator: "iContains"},
            {name: "assignee", title: "منتسب شده به", filterOperator: "iContains"},
            {name: "approved", title: "تایید شده", filterOperator: "iContains"}
        ]
    });

    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Refresh_Competence_Request_Item = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Competence_Request_Item.invalidateCache();
        }
    });
    ToolStripButton_Refresh_Competence_Request_Item = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Competence_Request_Item.invalidateCache();
        }
    });
    ToolStripButton_Excel_Competence_Request_Item = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Competence_Request_Item , requestItemUrl + "/report-list", 0, null, '', "گزارش مراحل تایید صلاحیت علمی و فنی", null, null, 0, true);
        }
    });
    ToolStrip_Actions_Competence_Request_Item = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Competence_Request_Item,
                    ToolStripButton_Excel_Competence_Request_Item
                ]
            })
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Competence_Request_Item = isc.TrLG.create({
        width: "100%",
        height: "100%",
        autoFetchData: true,
        showFilterEditor: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        dataSource: RestDataSource_Competence_Request_Item,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "requestNo",
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
                name: "requestType",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false
            },
            {
                name: "letterNumber",
                width: "10%",
                align: "center",
                canFilter: false,
                canSort: false
            },
            {
                name: "processInstanceId",
                hidden: true
            },
            {
                name: "nationalCode",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelNo2",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelNumber",
                width: "10%",
                align: "center"
            },
            {
                name: "post",
                width: "10%",
                align: "center"
            },
            {
                name: "letterNumberSent",
                width: "10%",
                align: "center"
            },
            {
                name: "dateSent",
                width: "10%",
                align: "center"
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
                canFilter: false
            }
        ],
        createRecordComponent: function (record, colNum) {

            let fieldName = this.getFieldName(colNum);
            if (fieldName === "showDetail") {
                let detailButton = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/help.png",
                    prompt: "مشاهده تاریخچه درخواست",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        ListGrid_Competence_Request_Item.selectSingleRecord(record);
                        let processInstanceId = ListGrid_Competence_Request_Item.getSelectedRecord().processInstanceId;
                        showRequestItemProcessHistory(processInstanceId);
                    }
                });
                return detailButton;
            } else {
                return null;
            }
        }
    });

    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Body_Competence_Request_Item = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_Competence_Request_Item,
            ListGrid_Competence_Request_Item
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------

    function showRequestItemProcessHistory(processInstanceId) {

        let ListGrid_Request_Item_Process_History = isc.TrLG.create({
            height: "90%",
            autoFetchData: false,
            filterOnKeypress: false,
            dataSource: RestDataSource_Request_Item_Process_History,
            gridComponents: ["header", "body"],
            initialSort: [
                {property: "timeComing", direction: "descending"}
            ],
            fields: [
                {
                    name: "name",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "timeComing",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "endTime",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "waitingTime",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "assignee",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "approved",
                    width: "10%",
                    align: "center",
                    valueMap: {
                        true: "بله",
                        false: "خیر",
                    }
                }
            ]
        });

        let IButton_Request_Item_Process_History_Exit = isc.IButtonCancel.create({
            title: "<spring:message code='close'/>",
            align: "center",
            click: function () {
                Window_Request_Item_Process_History.close();
            }
        });
        let HLayOut_Request_Item_Process_History_Exit = isc.HLayout.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            width: "100%",
            height: "10%",
            alignLayout: "center",
            align: "center",
            members: [
                IButton_Request_Item_Process_History_Exit
            ]
        });

        let Window_Request_Item_Process_History = isc.Window.create({
            title: "مشاهده تاریخچه درخواست",
            autoSize: false,
            width: "70%",
            height: "55%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                ListGrid_Request_Item_Process_History,
                HLayOut_Request_Item_Process_History_Exit
            ]
        });

        wait.show();
        RestDataSource_Request_Item_Process_History.fetchDataURL = requestItemBPMSUrl + "/processes/request-item/process-instance-history/" + processInstanceId;
        ListGrid_Request_Item_Process_History.fetchData(null, function (dsResponse, data, dsRequest) {
            wait.close();
            let gridData = JSON.parse(dsResponse.httpResponseText);
            ListGrid_Request_Item_Process_History.setData(gridData);
            Window_Request_Item_Process_History.show();
        });
    }

// </script>