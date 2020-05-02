<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    Menu_ClassContract = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshLG(ContractLG_ClassContract);
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    TS_ClassContract = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshLG(ContractLG_ClassContract);
                        }
                    })
                ]
            })

        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ContractDS_ClassContract = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "contractNumber", title: "شماره", filterOperator: "iContains", autoFitWidth: true},
            {name: "date", title: "تاریخ", filterOperator: "iContains", autoFitWidth: true},
            {name: "categoryId", title: "گروه", filterOperator: "iContains", autoFitWidth: true},
            {name: "subCategoryId", title: "زیر گروه", filterOperator: "iContains", autoFitWidth: true},
            {name: "isSigned", title: "امضا شده", filterOperator: "iContains", autoFitWidth: true},
            {name: "accountable", title: "امضا کننده", filterOperator: "iContains", autoFitWidth: true},




            {name: "secondPartyCompany.titleFa", title: "نام موسسه آموزشی", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyCompany", title: "تاریخ", filterOperator: "iContains", autoFitWidth: true},
            {name: "contractNumber", title: "شماره", filterOperator: "iContains", autoFitWidth: true},
            {name: "date", title: "تاریخ", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: classContractUrl + "/iscList"
    });

    ContractLG_ClassContract = isc.TrLG.create({
        dataSource: ContractDS_ClassContract,
        gridComponents: [TS_ClassContract, "filterEditor", "header", "body",],
        contextMenu: Menu_ClassContract,
        autoFetchData: true,
        fields: [
            {name: "contractNumber"},
            {name: "date"},
            {name: "categoryId"},
            {name: "subCategoryId"},
            {name: "isSigned"},
        ],
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ContractLG_ClassContract],
    });

    // ------------------------------------------- Functions -------------------------------------------

    // </script>