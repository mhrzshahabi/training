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
        ],
        fetchDataURL: mobileVerifyUrl + "/list"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Excel_MV = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_MV = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_MV.invalidateCache();
        }
    });
    ToolStrip_Actions_MV = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_MV,
                        ToolStripButton_Excel_MV
                    ]
                })
            ]
    });

    ListGrid_MV = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: true,
        showFilterEditor: true,
        autoFetchData: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_MV,
        fields: [
            {name: "id", hidden: true},
            {name: "mobileNumber"},
            {name: "nationalCode"},
            {name: "verify", valueMap: {false: "تایید نشده", true: "تایید شده"}},
            {name: "verifyMobileNumber", canFilter: false, title: "تایید شماره موبایل", width: "145"},
        ],
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName === "verifyMobileNumber") {
                let verifyBtn = isc.IButton.create({
                    layoutAlign: "center",
                    title: "تایید شماره موبایل",
                    width: "145",
                    margin: 3,
                    click: function () {
                        verifyMobileNumber(record);
                    }
                });
                return verifyBtn;
            } else {
                return null;
            }
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

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            isc.Dialog.create({
                message: "آیا از تایید شماره موبایل فراگیر اطمینان دارید؟",
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
                           ListGrid_MV.invalidateCache();
                        }));
                    }
                }
            });
        }
    }

    function makeExcelOutput() {

        if (ListGrid_MV.getData().localData.length === 0)
            createDialog("info", "داده ای برای خروجی اکسل وجود ندارد");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_MV, mobileVerifyUrl + "/list", 0, null, '',"گزارش شماره موبایل های تایید نشده"  , null, null);
    }

    // </script>