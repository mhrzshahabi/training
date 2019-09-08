<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

//<script>

    let competenceMethod_competence;
    // ------------------------------------------- Menu -------------------------------------------
    CompetenceMenu_competence = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshCompetenceLG_competence();
                }
            },
            {
                title: "<spring:message code="create"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    createCompetence_competence();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                icon: "<spring:url value="edit.png"/>",
                click: function () {
                    editCompetence_competence();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    removeCompetence_competence();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    CompetenceTS_competence = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshCompetenceLG_competence();
                }
            }),
            isc.TrCreateBtn.create({
                click: function () {
                    createCompetence_competence();
                }
            }),
            isc.TrEditBtn.create({
                click: function () {
                    editCompetence_competence();
                }
            }),
            isc.TrRemoveBtn.create({
                click: function () {
                    removeCompetence_competence();
                }
            }),
            isc.TrPrintBtnCommon.create({
                click: function () {
                    printCompetence_competence();
                }
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    CompetenceDS_competence = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="competence.title"/>", filterOperator: "contains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "contains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "contains"},
        ],
        fetchDataURL: competenceUrl + "iscList"
    });

    CompetenceLG_competence = isc.TrLG.create({
        dataSource: CompetenceDS_competence,
        fields: [
            {name: "titleFa",},
            {name: "titleEn",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [CompetenceTS_competence, "header", "filterEditor", "body",],
        contextMenu: CompetenceMenu_competence,
        sortField: 0,
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------

    let CompetenceDF_competence = isc.TrDynamicForm.create({
        ID: "CompetenceDF_competence",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa", title: "<spring:message code="competence.title"/>",
                required: true, validators: [TrValidators.NotEmpty],
            },
            {
                name: "titleEn", title: "<spring:message code="title.en"/>",
                keyPressFilter: EnNumSpcFilter,
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
        ]
    });

    let CompetenceWin_competence = isc.TrWindow.create({
        width: 500,
        items: [CompetenceDF_competence, isc.TrHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                // icon: "pieces/16/save.png",
                click: function () {
                    // save_Job();
                }
            }), isc.MyButton.create({
                title: "لغو",
                // icon: "pieces/16/icon_delete.png",
                click: function () {
                    CompetenceWin_competence.close();
                }
            })],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [CompetenceTS_competence, CompetenceLG_competence],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshCompetenceLG_competence() {
        CompetenceLG_competence.invalidateCache();
    };

    function createCompetence_competence() {
        competenceMethod_competence = "POST";
        // CompetenceDF_competence.clearValues();
        // CompetenceWin_competence.setTitle("ایجاد شایستگی شغلی");
        CompetenceWin_competence.show();
    };