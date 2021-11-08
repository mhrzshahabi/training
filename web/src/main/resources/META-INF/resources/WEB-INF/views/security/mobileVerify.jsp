<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_MV = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "mobileNumber", title: "شماره موبایل", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "verify", title: "وضعیت تایید", valueMap: {false: "تایید نشده", true: "تایید شده"}},
            {name: "createDate", title: "تاریخ"},
            {name: "verifiedBy", title: "تایید شده توسط"},
        ],
        fetchDataURL: mobileVerifyUrl + "/list"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_ShowDetail_MV = isc.ToolStripButton.create({
        title: "نمایش جزییات",
        click: function () {
            let record = ListGrid_MV.getSelectedRecord();
            if (record == null)
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            else
                showDetail(record);
        }
    });
    ToolStripButton_VerifyMobile_MV = isc.ToolStripButton.create({
        title: "تایید شماره موبایل",
        click: function () {
            let record = ListGrid_MV.getSelectedRecord();
            if (record == null)
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            else if (record.verify)
                createDialog("info", "شماره موبایل تایید شده است");
            else
                verifyMobileNumber(record);
        }
    });
    ToolStripButton_Excel_MV = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_MV = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_MV.clearFilterValues();
            ListGrid_MV.invalidateCache();
        }
    });
    ToolStrip_Actions_MV = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_ShowDetail_MV,
                ToolStripButton_VerifyMobile_MV,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_MV,
                        // ToolStripButton_Excel_MV
                    ]
                })
            ]
    });

    ListGrid_MV = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: true,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_MV,
        fields: [
            {name: "id", hidden: true},
            {name: "mobileNumber"},
            {name: "nationalCode"},
            {name: "verify", valueMap: {false: "تایید نشده", true: "تایید شده"}},
            {
                name: "createDate",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }},
            {name: "verifiedBy"},
        ],
        getCellCSSText: function (record) {
            if (record.verify)
                return "background:" + "#6cab7c";
        }
    });

    VLayout_Body_MV = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_MV,
            ListGrid_MV
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function verifyMobileNumber(record) {

        isc.Dialog.create({
            message: "آیا از تایید شماره موبایل اطمینان دارید؟",
            icon: "[SKIN]ask.png",
            title: "تایید",
            buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                title: "<spring:message code='no'/>"
            })],
            buttonClick: function (button, index) {
                this.close();
                if (index == 0) {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(mobileVerifyUrl + "/change/status" + "?nationalCode=" + record.nationalCode + "&number=" + record.mobileNumber + "&status=true", "PUT", null, function (resp) {
                        wait.close();
                        createDialog("info", "تایید شماره موبایل با موفقیت انجام شد");
                        ListGrid_MV.clearFilterValues();
                        ListGrid_MV.invalidateCache();
                    }));
                }
            }
        });
    }

    function showDetail(record) {

        let DynamicForm_Show_Detail = isc.DynamicForm.create({
            width: 400,
            height: 80,
            padding: 6,
            titleAlign: "center",
            numCols: 2,
            fields: [
                {
                    name: "name",
                    title: "نام",
                    width: "100%",
                    colSpan: 1,
                    editorType: 'staticText'
                },
                {
                    name: "family",
                    title: "نام خانوادگی",
                    width: "100%",
                    colSpan: 1,
                    editorType: 'staticText'
                },
                {
                    name: "personType",
                    title: "نوع",
                    width: "100%",
                    colSpan: 2,
                    editorType: 'staticText',
                    valueMap: {
                        "TEACHER": "استاد",
                        "PERSON": "پرسنل شرکتی",
                        "PERSON_REGISTER": "افراد متفرقه"
                    }
                },
            ]
        });
        let Window_Show_Detail = isc.Window.create({
            width: 400,
            height: 120,
            numCols: 2,
            title: "نمایش جزییات",
            items: [
                DynamicForm_Show_Detail,
                isc.MyHLayoutButtons.create({
                    members: [
                        isc.IButtonCancel.create({
                            title: "<spring:message code="close"/>",
                            click: function () {
                                Window_Show_Detail.close();
                            }
                        })
                    ],
                })
            ]
        });

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(mobileVerifyUrl + "/detail/" + "?nationalCode=" + record.nationalCode, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200) {
                let res = JSON.parse(resp.httpResponseText);
                DynamicForm_Show_Detail.setValue("name", res.name);
                DynamicForm_Show_Detail.setValue("family", res.family);
                DynamicForm_Show_Detail.setValue("personType", res.personType);
                Window_Show_Detail.show();
            } else {
                createDialog("info", "پرسنل با این کدملی یافت نشد");
            }
        }));
    }

    function makeExcelOutput() {

        if (ListGrid_MV.getData().localData.length === 0)
            createDialog("info", "داده ای برای خروجی اکسل وجود ندارد");
        else
        ExportToFile.downloadExcelRestUrl(null, ListGrid_MV, mobileVerifyUrl + "/list", 0, null, '',"گزارش شماره موبایل های تایید نشده"  , null, null);
    }

    // </script>