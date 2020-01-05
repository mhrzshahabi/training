<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

var dummy;
// <script>
    var teacherMethod = "POST";
    var teacherWait;
    var responseID;
    var gridState;
    var attachName;
    var attachNameTemp;
    var nationalCodeCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;
    var selectedRecordPersonalID = null;
    var isTeacherCategoriesChanged = false;

    //----------------------------------------------------Rest Data Sources-------------------------------------------

    var RestDataSource_Teacher_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"},
            {name: "subCategories" },
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });

    // var RestDataSource_EAttachmentType_JpaTeacher = isc.TrDS.create({
    //     fields: [
    //         {name: "id"},
    //         {name: "titleFa"}],
    //     fetchDataURL: enumUrl + "eTeacherAttachmentType/spec-list"
    // });

    var RestDataSource_Egender_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: enumUrl + "eGender/spec-list"
    });

    var RestDataSource_Emarried_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: enumUrl + "eMarried/spec-list"
    });

    var RestDataSource_Emilitary_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: enumUrl + "eMilitary/spec-list"
    });

    var RestDataSource_Category_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Education_Level_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleEn"}, {name: "titleFa"}],
        fetchDataURL: educationUrl + "level/spec-list"
    });

    var RestDataSource_Education_Major_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleEn"}, {name: "titleFa"}],
        fetchDataURL: educationUrl + "major/spec-list"
    });

    var RestDataSource_Education_Orientation_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleEn"}, {name: "titleFa"}]
    });

    var RestDataSource_Home_City_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Home_State_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_Work_City_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Work_State_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });


    //----------------------------------------------------Menu-------------------------------------------------------

    var Menu_ListGrid_Teacher_JspTeacher = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_teacher_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_teacher_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_teacher_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_teacher_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                trPrintWithCriteria("<spring:url value="/teacher/printWithCriteria/"/>" + "pdf",
                    ListGrid_Teacher_JspTeacher.getCriteria());
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                trPrintWithCriteria("<spring:url value="/teacher/printWithCriteria/"/>" + "excel",
                    ListGrid_Teacher_JspTeacher.getCriteria());
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                trPrintWithCriteria("<spring:url value="/teacher/printWithCriteria/"/>" + "html",
                    ListGrid_Teacher_JspTeacher.getCriteria());
            },

        },
            {
                title: "<spring:message code='print.Detail'/>", icon: "<spring:url value="print.png"/>", click: function () {
                    var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
                    if (record == null || record.id == null) {
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                        return;
                    }
                    trPrintWithCriteria("<spring:url value="/teacher/printWithDetail/"/>" + record.id,null);
                }
            }
        ]
    });

    //----------------------------------------------------ListGrid---------------------------------------------------


    var ListGrid_Teacher_JspTeacher = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Teacher_JspTeacher,
        contextMenu: Menu_ListGrid_Teacher_JspTeacher,
        filterOperator: "iContains",
        rowDoubleClick: function () {
            ListGrid_teacher_edit();
        },
        selectionUpdated: function () {
            refreshSelectedTab_teacher(TabSet_Bottom_JspTeacher.getSelectedTab());
        },
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "teacherCode",
                title: "<spring:message code='code'/>",
                align: "center"
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.firstNameFa;
                }
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.lastNameFa;
                }
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                formatCellValue: function (value) {
                    if (value.length === 0)
                        return;
                    value.sort();
                    var cat = value[0].titleFa.toString();
                    for (var i = 1; i < value.length; i++) {
                        cat += "، " + value[i].titleFa;
                    }
                    return cat;
                },
                sortNormalizer: function (value) {
                    if (value.categories.length === 0)
                        return;
                    value.categories.sort();
                    var cat = value.categories[0].titleFa.toString();
                    for (var i = 1; i < value.categories.length; i++) {
                        cat += "، " + value.categories[i].titleFa;
                    }
                    return cat;
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='subcategory'/>",
                formatCellValue: function (value) {
                    if (value.length === 0)
                        return;
                    value.sort();
                    var subCat = value[0].titleFa.toString();
                    for (var i = 1; i < value.length; i++) {
                        subCat += "، " + value[i].titleFa;
                    }
                    return subCat;
                },
                sortNormalizer: function (value) {
                    if (value.subCategories.length === 0)
                        return;
                    value.subCategories.sort();
                    var subCat = value.subCategories[0].titleFa.toString();
                    for (var i = 1; i < value.subCategories.length; i++) {
                        subCat += "، " + value.subCategories[i].titleFa;
                    }
                    return subCat;
                }
            },
            {
                name: "personality.educationLevel.titleFa",
                title: "<spring:message code='education.level'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.educationLevel.titleFa;
                }
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.educationLevel.titleFa;
                }
            },
            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='mobile.connection'/>",
                align: "center",
                type: "phoneNumber",
                sortNormalizer: function (record) {
                    return record.personality.contactInfo.mobile;
                }
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                align: "center",
                type: "boolean",
                canFilter: false
            }
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    //-----------------------------------------------Save and Close Buttons--------------------------------------------
    IButton_Teacher_Save_And_Close_JspTeacher = isc.IButtonSave.create({
        top: 260,
        title: "<spring:message code="save.and.close"/>",
        click: function () {
            Teacher_Save_Button_Click_JspTeacher(false);
        }
    });

    IButton_Teacher_Save_JspTeacher = isc.IButtonSave.create({
        top: 260,
        click: function () {
            Teacher_Save_Button_Click_JspTeacher(true);
        }
    });

    IButton_Teacher_Exit_JspTeacher = isc.IButtonCancel.create({
        width: 100,
        orientation: "vertical",
        click: function () {
            ListGrid_teacher_refresh();
            showAttachViewLoader.hide();
            Window_Teacher_JspTeacher.close();
        }
    });

    //-----------------------------------------------LayOuts and Tabsets-Window--------------------------------------------
    var HLayOut_TeacherSaveOrExit_JspTeacher = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Teacher_Save_And_Close_JspTeacher,
            IButton_Teacher_Save_JspTeacher,
            IButton_Teacher_Exit_JspTeacher
        ]
    });
    var TabSet_BasicInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        width: "100%",
        height: "60%",
        tabs: [
            {
                ID: "teacherBasicInfo",
                title: "<spring:message code='basic.information'/>", canClose: false,
                // pane: HLayOut_Basic_JspTeacher
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teacherBasicInfo-tab"})
            }
        ]
    });
    // var HLayOut_Temp_JspTeacher = isc.TrHLayout.create({
    //     layoutMargin: 5,
    //     showEdges: false,
    //     edgeImage: "",
    //     alignLayout: "center",
    //     align: "center",
    //     padding: 10,
    //     height: "60%",
    //     membersMargin: 10,
    //     showResizeBar: true,
    //     members: [TabSet_BasicInfo_JspTeacher]
    // });

    var TabSet_Bottom_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "30%",
        tabs: [
            {
                ID: "accountInfo",
                title: "<spring:message code='account.information'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/accountInfo-tab"})
            },
            {
                ID: "addressInfo",
                title: "<spring:message code='address'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/addressInfo-tab"})
            },
            {
                ID: "jobInfo",
                title: "<spring:message code='work.place'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/jobInfo-tab"})
            },
            {
                ID: "employmentHistory",
                title: "<spring:message code='employmentHistory'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/employmentHistory-tab"})
            },
            {
                ID: "teachingHistory",
                title: "<spring:message code='teachingHistory'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teachingHistory-tab"})
            },
            {
                ID: "teacherCertification",
                title: "<spring:message code='teacherCertification'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teacherCertification-tab"})
            },
            {
                ID: "attachmentsTab",
                title: "<spring:message code="documents"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/attachments-tab"})
            },
            {
                ID: "foreignLangKnowledge",
                title: "<spring:message code="foreign.languages.knowledge"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/foreignLangKnowledge-tab"})
            },
            {
                ID: "publication",
                title: "<spring:message code="publication"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/publication-tab"})
            },
            {
                ID: "otherActivities",
                title: "<spring:message code="otherActivities"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/otherActivities-tab"})
            },
            {
                ID: "academicBK",
                title: "<spring:message code="academicBK"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/academicBK-tab"})
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab) {
            if (isc.Page.isLoaded())
                refreshSelectedTab_teacher(tab);
        }
    });

    var Window_Teacher_JspTeacher = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                TabSet_BasicInfo_JspTeacher,
                TabSet_Bottom_JspTeacher,
                HLayOut_TeacherSaveOrExit_JspTeacher
            ]
        })]
    });

    //----------------------------------------------ToolStrips and Layout-Grid----------------------------------------

    var ToolStripButton_Refresh_JspTeacher = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_teacher_refresh();
        }
    });

    var ToolStripButton_Edit_JspTeacher = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_teacher_edit();
        }
    });

    var ToolStripButton_Add_JspTeacher = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_teacher_add();
        }
    });

    var ToolStripButton_Remove_JspTeacher = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_teacher_remove();
        }
    });

    var ToolStripButton_Print_JspTeacher = isc.ToolStripButtonPrint.create({
        //icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            trPrintWithCriteria("<spring:url value="/teacher/printWithCriteria/"/>" + "pdf",
                ListGrid_Teacher_JspTeacher.getCriteria());
        }
    });

    var ToolStrip_Actions_JspTeacher = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_JspTeacher,
            ToolStripButton_Edit_JspTeacher,
            ToolStripButton_Remove_JspTeacher,
            ToolStripButton_Print_JspTeacher,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspTeacher
                ]
            })

        ]
    });

    var HLayout_Grid_Teacher_JspTeacher = isc.TrHLayout.create({
        members: [ListGrid_Teacher_JspTeacher]
    });

    var HLayout_Actions_Teacher = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspTeacher]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Teacher,
            HLayout_Grid_Teacher_JspTeacher
        ]
    });

    //-------------------------------------------------Functions------------------------------------------------
    function ListGrid_teacher_refresh() {
        refreshSelectedTab_teacher(TabSet_Bottom_JspTeacher.getSelectedTab());
        ListGrid_Teacher_JspTeacher.invalidateCache();
        ListGrid_Teacher_JspTeacher.filterByEditor();
    }

    function Teacher_Save_Button_Click_JspTeacher(isSaveButton) {
        if (nationalCodeCheck === false || cellPhoneCheck === false || mailCheck === false || persianDateCheck === false) {
            return;
        }
        vm.validate();
        if (vm.hasErrors()) {
            return;
        }
        var nCode = DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue();
        DynamicForm_BasicInfo_JspTeacher.getField("teacherCode").setValue(nCode);
        var data = vm.getValues();
        var teacherSaveUrl = teacherUrl;

        if (teacherMethod.localeCompare("PUT") === 0) {
            var teacherRecord = ListGrid_Teacher_JspTeacher.getSelectedRecord();
            teacherSaveUrl += teacherRecord.id;
        }

        if (teacherMethod.localeCompare("POST") === 0 && isSaveButton)
            isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data),
                "callback: teacher_save_action_result(rpcResponse)"));
        else
            isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data),
                "callback: teacher_action_result(rpcResponse)"));

        if (!isSaveButton) {
            Window_Teacher_JspTeacher.close();
        }
    }

    function ListGrid_teacher_edit() {

        gridState = ListGrid_Teacher_JspTeacher.getSelectedState();

        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }

        showAttach(ListGrid_Teacher_JspTeacher.getSelectedRecord().personalityId);

        vm.clearValues();
        vm.clearErrors(true);

        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
        DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

        DynamicForm_BasicInfo_JspTeacher.getField("personality.educationLevelId").fetchData();
        DynamicForm_BasicInfo_JspTeacher.getField("personality.educationMajorId").fetchData();
        DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.stateId").fetchData();
        DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.stateId").fetchData();

        teacherMethod = "PUT";
        vm.editRecord(record);

        var eduMajorValue = record.personality.educationMajorId;
        var eduOrientationValue = record.personality.educationOrientationId;

        if (eduOrientationValue === undefined && eduMajorValue === undefined) {
            DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        } else if (eduMajorValue !== undefined) {
            RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationUrl +
                "major/spec-list-by-majorId/" + eduMajorValue;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
        }

        var stateValue_home = undefined;
        var cityValue_home = undefined;
        var stateValue_work = undefined;
        var cityValue_work = undefined;

        var HAOCEnable = false;
        if (record.personality.contactInfo !== undefined) {
            if (record.personality.contactInfo.homeAddress !== undefined) {
                if (record.personality.contactInfo.homeAddress.stateId !== undefined)
                    stateValue_home = record.personality.contactInfo.homeAddress.stateId;
                if (record.personality.contactInfo.homeAddress.cityId !== undefined)
                    cityValue_home = record.personality.contactInfo.homeAddress.cityId;
                if (record.personality.contactInfo.homeAddress.otherCountry !== undefined)
                    HAOCEnable = record.personality.contactInfo.homeAddress.otherCountry;
            }
        }

        if (cityValue_home === undefined) {
            DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
        }
        if (stateValue_home !== undefined) {
            RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_home;
            DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
            DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
        }

        var WAOCEnable = false;
        if (record.personality.contactInfo !== undefined) {
            if (record.personality.contactInfo.workAddress !== undefined) {
                if (record.personality.contactInfo.workAddress.stateId !== undefined)
                    stateValue_work = record.personality.contactInfo.workAddress.stateId;
                if (record.personality.contactInfo.workAddress.cityId !== undefined)
                    cityValue_work = record.personality.contactInfo.workAddress.cityId;
                if (record.personality.contactInfo.workAddress.otherCountry !== undefined)
                    WAOCEnable = record.personality.contactInfo.workAddress.otherCountry;
            }
        }
        if (cityValue_work === undefined) {
            DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
        }
        if (stateValue_work !== undefined) {
            RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_work;
            DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
            DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
        }

        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.cityId", HAOCEnable);
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.stateId", HAOCEnable);

        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.cityId", WAOCEnable);
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.stateId", WAOCEnable);


        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = true;
        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disabled = true;
        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;


        var categoryIds = DynamicForm_BasicInfo_JspTeacher.getField("categories").getValue();
        var subCategoryIds = DynamicForm_BasicInfo_JspTeacher.getField("subCategories").getValue();
        if (categoryIds == null || categoryIds.length === 0)
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").disable();
        else {
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").enable();
            var catIds = [];
            for (var i = 0; i < categoryIds.length; i++)
                catIds.add(categoryIds[i].id);
            DynamicForm_BasicInfo_JspTeacher.getField("categories").setValue(catIds);
            isTeacherCategoriesChanged = true;
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").focus(null, null);
        }
        if (subCategoryIds != null && subCategoryIds.length > 0) {
            var subCatIds = [];
            for (var i = 0; i < subCategoryIds.length; i++)
                subCatIds.add(subCategoryIds[i].id);
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").setValue(subCatIds);
        }


        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();

        TabSet_Bottom_JspTeacher.selectTab(0);
        TabSet_Bottom_JspTeacher.enable();
        refreshSelectedTab_teacher(TabSet_Bottom_JspTeacher.getSelectedTab(), null);
    }

    function ListGrid_teacher_add() {
        vm.clearValues();
        vm.clearErrors(true);
        showAttachViewLoader.show();
        showAttachViewLoader.setView();
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").enable();
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").enable();
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").enable();
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").enable();

        teacherMethod = "POST";
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = false;
        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = false;
        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disabled = true;
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();

        TabSet_Bottom_JspTeacher.selectTab(0);
        clearTabs();
        TabSet_Bottom_JspTeacher.disable();
    }

    function ListGrid_teacher_remove() {
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        teacherWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + record.id, "DELETE", null,
                            "callback: teacher_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function addAttach(personalId) {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file !== undefined) {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addAttach/" + personalId, "POST", personalInfo_addAttach_result);
        }
    }

    function personalInfo_addAttach_result(req) {
        attachName = req.response;
    }


    function showTempAttach() {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file.size > 1024000) {
            createDialog("info", "<spring:message code="file.size.hint"/>", "<spring:message code='error'/>");
        } else {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addTempAttach", "POST", personalInfo_showTempAttach_result)
        }
    }

    function personalInfo_showTempAttach_result(req) {
        if (req.status === 200) {
            attachNameTemp = req.response;
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getTempAttach/"/>" + attachNameTemp);
            showAttachViewLoader.show();
        } else if (req.status === 406) {
            if (req.response.data === "wrong size")
                createDialog("info", "<spring:message code="file.size.hint"/>", "<spring:message code='error'/>");
            else if (req.response === "wrong dimension")
                createDialog("info", "<spring:message code="photo.dimension.hint"/>", "<spring:message code='error'/>");
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function teacher_delete_result(resp) {
        teacherWait.close();
        if (resp.httpResponseCode === 200) {
            ListGrid_teacher_refresh();
            var OK = createDialog("info", "<spring:message code='msg.record.remove.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            refreshSelectedTab_teacher(TabSet_Bottom_JspTeacher.getSelectedTab());
        } else if (resp.data === false) {
            createDialog("info", "<spring:message code='msg.teacher.remove.error'/>");
        } else {
            createDialog("info", "<spring:message code='msg.record.remove.failed'/>");
        }
    }

    function teacher_save_action_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            if (resp.data === "") {
                createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
            } else {
                responseID = JSON.parse(resp.data).id;
                vm.setValue("id", responseID);
                gridState = "[{id:" + responseID + "}]";
                var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                    "<spring:message code="msg.command.done"/>");
                setTimeout(function () {
                    OK.close();
                    ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
                }, 1000);
                addAttach(JSON.parse(resp.data).personality.id);
                showAttach(JSON.parse(resp.data).personality.id);
                setTimeout(function () {
                    ListGrid_Teacher_JspTeacher.invalidateCache();
                    ListGrid_Teacher_JspTeacher.fetchData();
                }, 300);
                refreshSelectedTab_teacher(TabSet_Bottom_JspTeacher.getSelectedTab(), responseID);
                TabSet_Bottom_JspTeacher.enable();
                teacherMethod = "PUT";
            }
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function teacher_action_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            if (resp.data === "") {
                createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
            } else {
                responseID = JSON.parse(resp.data).id;
                gridState = "[{id:" + responseID + "}]";
                var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                    "<spring:message code="msg.command.done"/>");
                setTimeout(function () {
                    ListGrid_Teacher_JspTeacher.invalidateCache();
                    ListGrid_Teacher_JspTeacher.fetchData();
                    ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
                    OK.close();
                }, 1000);
                addAttach(JSON.parse(resp.data).personality.id);
                showAttach(JSON.parse(resp.data).personality.id);
                showAttachViewLoader.hide();
            }
        } else {
        }
    }

    function checkEmail(email) {
        return !(email.indexOf("@") === -1 || email.indexOf(".") === -1 || email.lastIndexOf(".") < email.indexOf("@"));
    }

    function checkMobile(mobile) {
        return mobile[0] === "0" && mobile[1] === "9" && mobile.length === 11;
    }

    function fillPersonalInfoFields(nationalCode) {
        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "getOneByNationalCode/" + nationalCode, "GET", null,
            "callback: personalInfo_findOne_result(rpcResponse)"));
    }

    function fillPersonalInfoByPersonnelNumber(personnelCode){
        isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byPersonnelCode/" + personnelCode, "GET", null,
            "callback: personnel_findOne_result(rpcResponse)"));
    }

    function fillWorkAddressFields(postalCode) {
        if (postalCode !== undefined)
            isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,
                "callback: workAddress_findOne_result(rpcResponse)"));
    }

    function fillHomeAddressFields(postalCode) {
        if (postalCode !== undefined)
            isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,
                "callback: homeAddress_findOne_result(rpcResponse)"));
    }

    function showAttach(pId) {
        selectedRecordPersonalID = pId;
        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "checkAttach/" + selectedRecordPersonalID, "GET", null,
            "callback: personalInfo_checkAttach_result(rpcResponse)"));
    }

    function personalInfo_checkAttach_result(resp) {
        if (resp.data === "true") {
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getAttach/"/>" + selectedRecordPersonalID);
            showAttachViewLoader.show();
        } else if (resp.data === "false") {
            showAttachViewLoader.setView();
            showAttachViewLoader.show();
        }
    }

    function set_city_state(dForm, fItem, value) {
        if (value === true) {
            dForm.clearValue(fItem.toString());
            dForm.getItem(fItem.toString()).disable();
        } else {
            dForm.getItem(fItem.toString()).enable();
        }
    }

    function workAddress_findOne_result(resp) {
        if (resp === null || resp === undefined || resp.data === "") {
            return null;
        }
        setWorkAddressFields(JSON.parse(resp.data));
    }

    function homeAddress_findOne_result(resp) {
        if (resp === null || resp === undefined || resp.data === "") {
            return null;
        }
        setHomeAddressFields(JSON.parse(resp.data));
    }

    function setWorkAddressFields(workAddress) {
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.restAddr", workAddress.restAddr);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.postalCode", workAddress.postalCode);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.id", workAddress.id);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.phone", workAddress.phone);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.fax", workAddress.fax);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.webSite", workAddress.webSite);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.otherCountry", workAddress.otherCountry);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.stateId", workAddress.stateId);
        var OCEnable = (workAddress.otherCountry !== undefined) ? workAddress.otherCountry : false;
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.cityId", OCEnable);
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.stateId", OCEnable);
        if (workAddress.city !== undefined)
            DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.cityId", workAddress.cityId);
        else
            DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
    }

    function setHomeAddressFields(homeAddress) {
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.restAddr", homeAddress.restAddr);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.id", homeAddress.id);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.postalCode", homeAddress.postalCode);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.phone", homeAddress.phone);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.fax", homeAddress.fax);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.otherCountry", homeAddress.otherCountry);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.stateId", homeAddress.stateId);
        var OCEnable = (homeAddress.otherCountry !== undefined) ? homeAddress.otherCountry : false;
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.cityId", OCEnable);
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.stateId", OCEnable);
        if (homeAddress.city !== undefined)
            DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.cityId", homeAddress.cityId);
        else
            DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
    }

    function personnel_findOne_result(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            var personnel = JSON.parse(resp.data);
            if (personnel.firstName != undefined && personnel.firstName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personnel.firstName);
            if (personnel.lastName != undefined && personnel.lastName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameFa", personnel.lastName);
            if (personnel.nationalCode != undefined && personnel.nationalCode != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationalCode", personnel.nationalCode);
            if (personnel.fatherName != undefined && personnel.fatherName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.fatherName", personnel.fatherName);
            if (personnel.nationalCode != undefined && personnel.nationalCode != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("teacherCode", personnel.nationalCode);
            if (personnel.personnelNo != undefined && personnel.personnelNo != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personnelCode", personnel.personnelNo);
            if (personnel.birthDate != undefined && personnel.birthDate != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthDate", personnel.birthDate);
            if (personnel.birthCertificateNo != undefined && personnel.birthCertificateNo != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificate", personnel.birthCertificateNo);
            if (personnel.jobTitle != undefined && personnel.jobTitle != null)
                DynamicForm_JobInfo_JspTeacher.setValue("personality.jobTitle", personnel.jobTitle);
            if (personnel.gender != undefined && personnel.gender != null) {
                if (personnel.gender == "زن")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", 2);
                if (personnel.gender == "مرد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", 1);
            }
            if (personnel.militaryStatus != undefined && personnel.militaryStatus != null) {
                if (personnel.militaryStatus == "معاف")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 2);
                if (personnel.militaryStatus == "معافیت مازاد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 2);
                if (personnel.militaryStatus == "پایان خدمت")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 1);
            }
            if (personnel.maritalStatusTitle != undefined && personnel.maritalStatusTitle != null) {
                if (personnel.maritalStatusTitle == "متاهل")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", 1);
                if (personnel.maritalStatusTitle == "مجرد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", 2);
            }
            if(personnel.companyName != undefined && personnel.companyName != null)
                DynamicForm_JobInfo_JspTeacher.setValue("personality.jobLocation", personnel.companyName);
            var ccp_affairs = "";
            var ccp_section = "";
            var ccp_unit = "";
            if(personnel.ccpAffairs != undefined && personnel.ccpAffairs != null)
                ccp_affairs = personnel.ccpAffairs;
            if(personnel.ccpSection != undefined && personnel.ccpSection != null)
                ccp_section = personnel.ccpSection;
            if(personnel.ccpUnit != undefined && personnel.ccpUnit != null)
                ccp_unit = personnel.ccpUnit;
            var restAddress = ccp_affairs+","+ccp_section+","+ccp_unit;
            if(restAddress != "")
                DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.restAddr",restAddress);
        }
    }

    function personalInfo_findOne_result(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            var personality = JSON.parse(resp.data);
            showAttach(personality.id);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationalCode", personality.nationalCode);
            DynamicForm_BasicInfo_JspTeacher.setValue("teacherCode", personality.nationalCode);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.id", personality.id);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personality.firstNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameFa", personality.lastNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.fullNameEn", personality.fullNameEn);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personality.firstNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.fatherName", personality.fatherName);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthDate", personality.birthDate);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthLocation", personality.birthLocation);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificate", personality.birthCertificate);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificateLocation", personality.birthCertificateLocation);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationality", personality.nationality);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.description", personality.description);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", personality.genderId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", personality.marriedId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", personality.militaryId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationLevelId", personality.educationLevelId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationMajorId", personality.educationMajorId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationOrientationId", personality.educationOrientationId);
            DynamicForm_JobInfo_JspTeacher.setValue("personality.jobTitle", personality.jobTitle);
            DynamicForm_JobInfo_JspTeacher.setValue("personality.jobLocation", personality.jobLocation);


            if (personality.contactInfo !== null && personality.contactInfo !== undefined) {
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.contactInfo.mobile", personality.contactInfo.mobile);
                DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.email", personality.contactInfo.email);
                DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.personalWebSite", personality.contactInfo.personalWebSite);

                if (personality.contactInfo.workAddress !== null && personality.contactInfo.workAddress !== undefined) {
                    setWorkAddressFields(personality.contactInfo.workAddress);
                }
                if (personality.contactInfo.homeAddress !== null && personality.contactInfo.homeAddress !== undefined) {
                    setHomeAddressFields(personality.contactInfo.homeAddress);
                }
            }
            if (personality.accountInfo !== null && personality.accountInfo !== undefined) {
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.accountNumber", personality.accountInfo.accountNumber);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bank", personality.accountInfo.bank);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bankBranch", personality.accountInfo.bankBranch);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bankBranchCode", personality.accountInfo.bankBranchCode);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.cartNumber", personality.accountInfo.cartNumber);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.shabaNumber", personality.accountInfo.shabaNumber);
            }
        }
    }

    function refreshSelectedTab_teacher(tab, id) {
        var teacherId = (id !== null) ? id : ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        if (!(teacherId === undefined || teacherId === null)) {
            if (typeof loadPage_attachment !== "undefined")
                loadPage_attachment("Teacher", teacherId, "<spring:message code="document"/>", {1: "رزومه", 2: "مدرک تحصیلی", 3: "گواهینامه"});

            if (typeof loadPage_EmploymentHistory !== "undefined")
                loadPage_EmploymentHistory(teacherId);

            if (typeof loadPage_TeachingHistory !== "undefined")
                loadPage_TeachingHistory(teacherId);

            if (typeof loadPage_TeacherCertification !== "undefined")
                loadPage_TeacherCertification(teacherId);

            if (typeof loadPage_ForeignLangKnowledge !== "undefined")
                loadPage_ForeignLangKnowledge(teacherId);

            if (typeof loadPage_Publication !== "undefined")
                loadPage_Publication(teacherId);


            if (typeof loadPage_AcademicBK !== "undefined")
                loadPage_AcademicBK(teacherId);

        }
    }

    function clearTabs() {
        if (typeof clear_Attachments !== "undefined")
            clear_Attachments();

        if (typeof clear_EmploymentHistory !== "undefined")
            clear_EmploymentHistory();

        if (typeof clear_TeachingHistory !== "undefined")
            clear_TeachingHistory();

        if (typeof clear_TeacherCertification !== "undefined")
            clear_TeacherCertification();

        if (typeof clear_ForeignLangKnowledge !== "undefined")
            clear_ForeignLangKnowledge();

        if (typeof clear_AcademicBK() !== "undefined")
            clear_AcademicBK();
    }

    // </script>