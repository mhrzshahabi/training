<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_SD = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "mobileNumber", title: "شماره موبایل", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "createDate", title: "تاریخ"},
        ],
        fetchDataURL: selfDeclarationUrl + "/list"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_ShowDetail_SD = isc.ToolStripButton.create({
        title: "نمایش جزییات",
        click: function () {
            let record = ListGrid_SD.getSelectedRecord();
            if (record == null)
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            else
                showDetailSelfDeclaration(record);
        }
    });
    ToolStripButton_Refresh_SD = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_SD.invalidateCache();
        }
    });
    ToolStrip_Actions_SD = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_ShowDetail_SD,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_SD,
                    ]
                })
            ]
    });

    ListGrid_SD = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: true,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_SD,
        fields: [
            {name: "id", hidden: true},
            {name: "mobileNumber"},
            {name: "nationalCode"},
            {
                name: "createDate",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            }
        ]
    });

    VLayout_Body_SD = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_SD,
            ListGrid_SD
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function showDetailSelfDeclaration(record) {

        let DynamicForm_Show_Detail_SD = isc.DynamicForm.create({
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
        let Window_Show_Detail_SD = isc.Window.create({
            width: 400,
            height: 120,
            numCols: 2,
            title: "نمایش جزییات",
            items: [
                DynamicForm_Show_Detail_SD,
                isc.MyHLayoutButtons.create({
                    members: [
                        isc.IButtonCancel.create({
                            title: "<spring:message code="close"/>",
                            click: function () {
                                Window_Show_Detail_SD.close();
                            }
                        })
                    ],
                })
            ]
        });

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(selfDeclarationUrl + "/detail/" + "?nationalCode=" + record.nationalCode, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200) {
                let res = JSON.parse(resp.httpResponseText);
                DynamicForm_Show_Detail_SD.setValue("name", res.name);
                DynamicForm_Show_Detail_SD.setValue("family", res.family);
                DynamicForm_Show_Detail_SD.setValue("personType", res.personType);
                Window_Show_Detail_SD.show();
            } else {
                createDialog("info", "پرسنل با این کدملی یافت نشد");
            }
        }));
    }

    // </script>