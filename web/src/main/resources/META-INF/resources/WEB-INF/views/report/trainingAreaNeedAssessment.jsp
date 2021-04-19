<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    var areas = [];

    //--------------------------------------------------------REST DataSources-----------------------------------------------------//
    var RestDataSource_view_training_Post = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true },
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "mojtameTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscListReport?_endRow=10000"
    });

    //------------------------------------------------------Main Window--------------------------------------------------------------//

    ToolStripButton_Export2EXcel_THNA = isc.ToolStripButtonExcel.create({

        click: function () {

            makeExcelOutput();
        }
    });

    ToolStripButton_Refresh_THNA = isc.ToolStripButtonRefresh.create({
        click: function () {

            ListGrid_Training_Post.invalidateCache();
        }
    });

    DynamicForm_Select_Hoze = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "selectArea",
                width: 100,
                colSpan: 1,
                wrapTitle: false,
                title: "<spring:message code='reports.need.assessment.select.complex'/>",
                type: "button",
                startRow: false,
                endRow: false,
                click: function() {
                    getAreaList();
                    Window_Area.show();
                }
            }
        ]
    });

    ListGrid_Area = isc.ListGrid.create({
        width: "100%",
        height: 470,
        showRowNumbers: true,
        canEdit: true,
        modalEditing: true,
        editEvent: "click",
        autoFetchData: false,
        alternateRecordStyles: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", hidden: true},
            {
                name: "selected",
                title: " ",
                type: "boolean"
            },
            {
                canEdit: false,
                name: "title",
                title: "<spring:message code='title'/>",
            }
        ]
    });

    VLayout_area = isc.TrVLayout.create({
        members: [
            ListGrid_Area,
            isc.IButtonSave.create({
                height: 30,
                title: "اجرای گزارش",
                align: "center",
                icon: "[SKIN]/actions/save.png",
                click: function () {
                    let records = ListGrid_Area.getData().filter(d => d.selected);
                    if (records === null || records.length < 1) {
                        isc.Dialog.create({
                            message: "رکوردی انتخاب نشده است",
                            icon: "[SKIN]ask.png",
                            title: "پیغام",
                            buttons: [isc.IButtonSave.create({title: "تائید"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                    } else {
                        fetchListGridData(records.map(a => a.code));
                        Window_Area.close();
                    }
                }
            })
        ]
    });

    Window_Area = isc.Window.create({
        title: "<spring:message code='complex'/>",
        width: 400,
        height: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.Super("closeClick", arguments)
        },
        items: [
            VLayout_area
        ]
    });

    var ListGrid_Training_Post = isc.TrLG.create({
        width: "100%",
        showRowNumbers: true,
        dataSource: RestDataSource_view_training_Post,
        selectionType: "single",
        autoFetchData: false,
        dataPageSize: 15,
        allowAdvancedCriteria: true,
        alternateRecordStyles: true,
        allowFilterOperators: true,
        showFilterEditor: true,
        fields: [
            {
                name: "peopleType",
                filterOnKeypress: true
            },
            {
                name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa"},
            {name: "jobTitleFa"},
            {name: "postGradeTitleFa"},
            {name: "mojtameTitle"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {
                name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "competenceCount"}
        ]
    });

    ToolStrip_Actions_THNA = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_THNA,
                        ToolStripButton_Export2EXcel_THNA
                    ]
                })
            ]
    });

    VLayout_THNA = isc.TrVLayout.create({
        members: [
            DynamicForm_Select_Hoze,
            ListGrid_Training_Post
        ]
    });

    VLayout_THNA = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [
            ToolStrip_Actions_THNA,
            VLayout_THNA
       ]
    });

    //-----------------------------------------------------------FUNCTIONS---------------------------------------------------------//

    function fetchListGridData(records) {

    let reportCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {
                    fieldName: "competenceCount",
                    operator: "equals",
                    value: 0
                },
                {
                    fieldName: "mojtameCode",
                    operator: "inSet",
                    value: records
                }
            ]
        };

        ListGrid_Training_Post.implicitCriteria = reportCriteria;
        ListGrid_Training_Post.invalidateCache();
        ListGrid_Training_Post.fetchData();
    }

    function getAreaList() {
        if (areas.length == 0)
            isc.RPCManager.sendRequest(TrDSRequest(departmentUrl + "/organ-segment-iscList/mojtame", "GET", null, function (resp) {
                if (generalGetResp(resp)) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                        let result = JSON.parse(resp.httpResponseText);
                        result.response.data.forEach(a => {
                            a.selected = false;
                            areas.push(a);
                        })
                        ListGrid_Area.setData(areas);
                    } else {
                        wait.close();
                        createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                    }
                } else {
                    wait.close();
                }
            }));
    }

    function makeExcelOutput() {

        let fieldNames = "peopleType,code,titleFa,mojtameTitle,assistance,affairs,section," +
            "unit,costCenterCode,costCenterTitleFa";

        let headerNames = '"<spring:message code="people.type"/>","<spring:message code="post.code"/>","<spring:message code="post.title"/>","<spring:message code="complex"/>",' +
                '"<spring:message code="assistance"/>","<spring:message code="affairs"/>","<spring:message code="section"/>","<spring:message code="unit"/>",' +
                '"<spring:message code="reward.cost.center.code"/>","<spring:message code="reward.cost.center.title"/>"';

        let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/reportsToExcel/areaNeedAssessment",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "fields", type: "hidden"},
                            {name: "headers", type: "hidden"},
                            {name: "areas", type: "hidden"}
                        ]
                });
                downloadForm.setValue("fields", fieldNames);
                downloadForm.setValue("headers", headerNames);
                downloadForm.setValue("areas", areas.filter(a=>a.selected).map(a => a.code));

                downloadForm.show();
                downloadForm.submitForm();
    }

//</script>