<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let parameterTypeMethod_parameter;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "ParameterTypeMenu_parameter",
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshParameterTypeLG_parameter();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "ParameterTypeTS_parameter",
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                click: function () {
                    createParameterType_parameter();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    editParameterType_parameter();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeParameterType_parameter();
                }
            }),
            isc.ToolStripButtonPrint.create({
                click: function () {
                    printParameterTypeLG_parameter("pdf");
                },
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
                        ID: "totalsLabel_parameter"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshParameterTypeLG_parameter();
                        }
                    }),
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    isc.TrDS.create({
        ID: "ParameterTypeDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterTypeUrl + "/iscList"
    });

    isc.TrLG.create({
        ID: "ParameterTypeLG_parameter",
        dataSource: ParameterTypeDS_parameter,
        fields: [
            {name: "title",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterTypeTS_parameter, "filterEditor", "header", "body"],
        contextMenu: ParameterTypeMenu_parameter,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_parameter.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_parameter.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    isc.DynamicForm.create({
        ID: "ParameterTypeDF_parameterType",
        fields: [
            {name: "id", hidden: true},
            {
                name: "title", title: "<spring:message code="title"/>",
                required: true, validators: [TrValidators.NotEmpty],
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
        ]
    });

    isc.Window.create({
        ID: "ParameterTypeWin_parameterType",
        width: 800,
        items: [ParameterTypeDF_parameterType, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    click: function () {
                        saveParameterType_parameterType();
                    }
                }),
                isc.IButtonCancel.create({
                    click: function () {
                        ParameterTypeWin_parameterType.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ParameterTypeLG_parameter],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshParameterTypeLG_parameter() {
        ParameterTypeLG_parameter.filterByEditor();
    }

    function createParameterType_parameter(type) {
        parameterTypeMethod_parameter = "POST";
        ParameterTypeDF_parameterType.clearValues();
        ParameterTypeWin_parameterType.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="parameter.type"/>");
        ParameterTypeWin_parameterType.show();
    }

    function editParameterType_parameter(type) {

    }

    function removeParameterType_parameter(type) {

    }

    function printParameterTypeLG_parameter(type) {
    }