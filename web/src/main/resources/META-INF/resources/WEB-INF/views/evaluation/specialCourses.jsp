<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Course_SC = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "scoringMethod"},
            {name: "acceptancelimit"},
            {name: "startEvaluation"},
            {
                name: "code",
                title: "<spring:message code="course.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
            {name: "theoryDuration"},
            {name: "categoryId"},
            {name: "subCategoryId"},
        ],
        fetchDataURL: courseUrl + "add-permission/spec-list?type=combo"
    });

    let RestDataSource_Category_SC = isc.TrDS.create({
        ID: "specialCourseCategoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    let RestDataSource_SubCategory_SC = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list"
    });

    let RestDataSource_Special_Courses = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "category", title: "<spring:message code="category"/>"},
            {name: "subCategory", title: "<spring:message code="subcategory"/>"}
        ],
        fetchDataURL: courseUrl + "special-course"
    });
    //----------------------------------- Dynamic Form -----------------------------------------------------------------
    let DynamicForm_Course = isc.DynamicForm.create({
        overflow: "hidden",
        fields: [
            {name: "id", hidden: true},
            {
                name: "courseId",
                title: "<spring:message code="course.title"/>",
                required: true,
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Course_SC,
                sortField: ["id"],
                filterFields: ["id"],
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='course.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "category.titleFa",
                        title: "<spring:message code='category'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "subCategory.titleFa",
                        title: "<spring:message code='subcategory'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                // pickListWidth: "600",
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false,
                click(form, item) {
                    let criteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {fieldName: "evaluation", operator: "inSet", value: ["2", "3", "4"]}]
                    };
                    item.pickListCriteria = criteria;
                    item.fetchData();
                }
            }
        ]
    });
    //----------------------------------- window -----------------------------------------------------------------------
    let Window_Select_Course = isc.Window.create({
        title: "<spring:message code="course.select"/>",
        width: "40%",
        height: "15%",
        overflow: "hidden",
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        items: [
            DynamicForm_Course,
            isc.TrHLayoutButtons.create({
                members: [
                    isc.TrSaveBtn.create({
                        title: "<spring:message code="add"/>",
                        click: function () {
                            if (!DynamicForm_Course.validate()) {
                                return;
                            }
                            let courseId = DynamicForm_Course.getField("courseId").getValue();
                            updateSpecialCourses(courseId, true);
                            DynamicForm_Course.clearValues();
                            Window_Select_Course.close();
                        }
                    }),
                    isc.TrCancelBtn.create({
                        click: function () {
                            Window_Select_Course.close();
                        }
                    })
                ]
            })]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    let ToolStripButton_Add_SC = isc.ToolStripButtonCreate.create({
        title: "افزودن به دوره های خاص",
        click: function () {
            Window_Select_Course.show();
        }
    });

    let ToolStripButton_Refresh_SC = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_SC.invalidateCache();
        }
    });

    let ToolStrip_Actions_SC = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_SC,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_SC
                    ]
                })
            ]
    });

    let ListGrid_SC = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: true,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Special_Courses,
        canRemoveRecords: true,
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "category.titleFa", title: "<spring:message code="category"/>"},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>"}
        ],
        removeRecordClick: function (rowNum) {
            let record = this.getRecord(rowNum);
            updateSpecialCourses(record.id, false);
        }
    });

    let VLayout_Body_SC = isc.TrVLayout.create({
        padding: 5,
        members: [
            ToolStrip_Actions_SC,
            ListGrid_SC
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function updateSpecialCourses(courseId, isSpecial) {
        let url = courseUrl + "update/is-special?id=" + courseId + "&is-special=" + isSpecial;
        isc.RPCManager.sendRequest(TrDSRequest(url, "PUT", null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                createDialog("info", "عملیات با موفقیت انجام شد");
            } else {
                createDialog("warning", "عملیات ناموفق", "خطا");
            }
        }));

        setTimeout(function () {
            ListGrid_SC.invalidateCache();
        }, 1000);
    }

    // </script>