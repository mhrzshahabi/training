<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>

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
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ],
        cacheAllData: true,
        fetchDataURL: viewPostUrl + "/iscList?_endRow=10000"
    });

    RestDataSource_Area = isc.TrDS.create({
        fields: [
            {
                name: "area",
                title: "<spring:message code='area'/>",
            }
        ]
    });

    //------------------------------------------------------Main Window--------------------------------------------------------------//

    // ToolStripButton_Export2EXcel_THNA = isc.ToolStripButtonExcel.create({
    //
    //     click: function () {
    //
    //         ListGrid_Training_Post.getOriginalData().localData = ListGrid_Training_Post.getOriginalData();
    //         ExportToFile.downloadExcelRestUrl(null, ListGrid_Training_Post, viewPostUrl + "/iscList?_endRow=10000", 0, null, "حوزه", "طراحی و برنامه ریزی - گزارش نیازسنجی براساس حوزه", null, null);
    //     }
    // });
    //
    // ToolStripButton_Refresh_THNA = isc.ToolStripButtonRefresh.create({
    //     click: function () {
    //
    //         ListGrid_Training_Post.invalidateCache();
    //     }
    // });

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
                                            message: "رکوردی انتخاب نشده است.",
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
        padding: 10,
        showRowNumbers: true,
        dataSource: RestDataSource_view_training_Post,
        selectionType: "single",
        autoFetchData: false,
        dataPageSize: 15,
        alternateRecordStyles: true,
        fields: [
            {name: "peopleType",
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
            {name: "competenceCount"},
            {name: "personnelCount"},
            {
                name: "enabled",
                filterOnKeypress: true,
                valueMap: {
                    // undefined : "فعال",
                    74 : "غیر فعال"
                }
            }
        ]
    });

    // ToolStrip_Actions_THNA = isc.ToolStrip.create({
    //     width: "100%",
    //     membersMargin: 5,
    //     members:
    //         [
    //             isc.ToolStrip.create({
    //                 width: "100%",
    //                 align: "left",
    //                 border: '0px',
    //                 members: [
    //                     ToolStripButton_Refresh_THNA,
    //                     ToolStripButton_Export2EXcel_THNA
    //                 ]
    //             })
    //         ]
    // });

    VLayout_THNA = isc.TrVLayout.create({
        members: [
            DynamicForm_Select_Hoze,
            ListGrid_Training_Post
        ]
    });

    VLayout_THNA = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [
            // ToolStrip_Actions_THNA,
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
            if (data.length) {
                ListGrid_Training_Post.setData(data);
            }
        });
    }

    function getAreaList() {

        isc.RPCManager.sendRequest(TrDSRequest(viewPostUrl + "/areaList", "GET", null, function (resp) {
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

    //</script>