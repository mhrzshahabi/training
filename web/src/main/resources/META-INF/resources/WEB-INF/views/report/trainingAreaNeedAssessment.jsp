<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    var area = null;

    //--------------------------------------------------------REST DataSources-----------------------------------------------------//

    RestDataSource_Department = isc.TrDS.create({
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "title",
                title: "<spring:message code='department'/>",
            },
            {
                name: "hozeTitle",
                title: "<spring:message code='area'/>",
            }
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/spec-list"
    });

    RestDataSource_view_training_Post = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true },
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        cacheAllData: true,
        fetchDataURL: viewTrainingPostUrl + "/iscList?_endRow=10000"
    });

    RestDataSource_Area = isc.TrDS.create({
        fields: [
            {
                name: "area",
                title: "<spring:message code='area'/>"
            }
        ]
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
                title: "<spring:message code='reports.need.assessment.select.hoze'/>",
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
        dataSource: RestDataSource_Area,
        showRowNumbers: true,
        selectionType: "single",
        autoFetchData: false,
        alternateRecordStyles: true,
        fields: [
            {
                name: "area",
                title: "<spring:message code='area'/>",
                type: "text"
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
                                    let record = ListGrid_Area.getSelectedRecord();
                                    if (record === null) {
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
                                        area = record.area;
                                        fetchListGridData(area);
                                        Window_Area.close();
                                        wait.show();
                                    }
                                }
            })
        ]
    });

    Window_Area = isc.Window.create({
        title: "<spring:message code='area'/>",
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

    ListGrid_Training_Post = isc.ListGrid.create({
        width: "100%",
        showRowNumbers: true,
        dataSource: RestDataSource_view_training_Post,
        selectionType: "single",
        autoFetchData: false,
        dataPageSize: 15,
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
            {name: "area"},
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

    function fetchListGridData(areaValue) {

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
                    fieldName: "area",
                    operator: "equals",
                    value: areaValue
                }
            ]
        };

    RestDataSource_view_training_Post.fetchData(reportCriteria, function (dsResponse, data, dsRequest) {
            wait.close();
            ListGrid_Training_Post.setCriteria(null);
            ListGrid_Training_Post.setImplicitCriteria({
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {
                    fieldName: "competenceCount",
                    operator: "equals",
                    value: 0
                },
                {
                    fieldName: "area",
                    operator: "equals",
                    value: areaValue
                }
            ]
        });
            if (data.length)
                ListGrid_Training_Post.setData(data);
            else
                ListGrid_Training_Post.setData([]);
        });
    }

    function getAreaList() {

        isc.RPCManager.sendRequest(TrDSRequest(viewTrainingPostUrl + "/areaList", "GET", null, function (resp) {
                            if (generalGetResp(resp)) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    let result = JSON.parse(resp.httpResponseText);
                                    let areaList = [];
                                    result.forEach(a =>
                                        areaList.add({area: a}));
                                    ListGrid_Area.setData(areaList);
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

        let fieldNames = "peopleType,code,titleFa,area,assistance,affairs,section," +
            "unit,costCenterCode,costCenterTitleFa";

        let headerNames = '"<spring:message code="people.type"/>","<spring:message code="post.code"/>","<spring:message code="post.title"/>","<spring:message code="area"/>",' +
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
                            {name: "area", type: "hidden"}
                        ]
                });
                downloadForm.setValue("fields", fieldNames);
                downloadForm.setValue("headers", headerNames);
                downloadForm.setValue("area", area);

                downloadForm.show();
                downloadForm.submitForm();
    }

//</script>