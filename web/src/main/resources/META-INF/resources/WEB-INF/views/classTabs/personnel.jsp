<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    PersonnelMenu_personnel = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPersonnelLG_personnel();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    PersonnelTS_personnel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonPrint.create({
                menu: isc.Menu.create({
                    data: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                                printPersonnelLG_personnel("pdf");
                            }
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {
                                printPersonnelLG_personnel("excel");
                            }
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {
                                printPersonnelLG_personnel("html");
                            }
                        },
                    ]
                })
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_personnel"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshPersonnelLG_personnel();
                        }
                    })
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PersonnelDS_personnel = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", detail: true,  autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "iscList"
    });

    PersonnelLG_personnel = isc.TrLG.create({
        width: "100%",
        dataSource: PersonnelDS_personnel,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "companyName"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
        ],
        autoFetchData: true,
        gridComponents: [PersonnelTS_personnel, "filterEditor", "header", "body"],
        contextMenu: PersonnelMenu_personnel,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_personnel.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_personnel.setContents("&nbsp;");
            }
        },
        selectionAppearance: "checkbox",
        canExpandRecords: true,
        expansionMode: "details",
        showDetailFields: true
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        width: "100%", height: "100%",
        members: [PersonnelLG_personnel],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPersonnelLG_personnel() {
        PersonnelLG_personnel.filterByEditor();
    }