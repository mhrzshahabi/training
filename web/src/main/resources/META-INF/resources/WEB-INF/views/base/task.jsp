<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>
var dummy;
    var teacherMethod = "POST";
    var teacherWait;

    var responseID;
    var categoryList;
    var gridState;
    var attachName;
    var attachNameTemp;

    var codeMeliCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;

    var selectedRecordPersonalID = null;

    var photoDescription = "<spring:message code='file.size.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.dimension.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.format.hint'/>";

    var teacherCategoriesID = new Array();

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    // ------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Teacher_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"},
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });

    var RestDataSource_Egender_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eGender/spec-list"
    });

    var RestDataSource_Emilitary_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eMilitary/spec-list"
    });

    var RestDataSource_Category_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

     var RestDataSource_Education_Orientation_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ]
    });

    var RestDataSource_Home_City_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ]
    });


    var RestDataSource_Work_City_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ]
    });

    var RestDataSource_Work_State_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

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
                ListGrid_teacher_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                ListGrid_teacher_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                ListGrid_teacher_print("html");
            }
        }]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Teacher_JspTeacher = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Teacher_JspTeacher,
        contextMenu: Menu_ListGrid_Teacher_JspTeacher,
        doubleClick: function () {
            ListGrid_teacher_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "<spring:message code='code'/>", align: "center", filterOperator: "contains"},
            {
                name: "personality.fullName",
                title: "<spring:message code='firstName.lastName'/>",
                align: "center",
                filterOperator: "contains",
                formatCellValue: function (value, record) {
                    return record.personality.firstNameFa + " " + record.personality.lastNameFa;
                }
            },

            {
                name: "personality.educationLevel.titleFa",
                title: "<spring:message code='education.level'/>",
                align: "center",
                filterOperator: "contains"
            },


        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"

    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var vm = isc.ValuesManager.create({});

    var DynamicForm_ViewLoader_JspTeacher = isc.Label.create({
        height: "100%",
        width: "100%",
        align: "center",
        contents: photoDescription
    });

    var showAttachViewLoader = isc.ViewLoader.create({
        autoDraw: false,
        viewURL: "",
        overflow: "scroll",
        height: "140px",
        width: "130px",
        border: "1px solid red",
        scrollbarSize: 0,
        loadingMessage: "<spring:message code='msg.photo.loading.error'/>"
    });

    var VLayOut_ViewLoader_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "right",
        align: "right",
        padding: 10,
        membersMargin: 10,
        members: [showAttachViewLoader,
            DynamicForm_ViewLoader_JspTeacher]
    });

    var DynamicForm_BasicInfo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                type: 'text',
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                width: "*",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true
                , blur: function () {
                    var codeCheck;
                    codeCheck = checkCodeMeli(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    codeMeliCheck = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
                                                                        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true) {
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);
                        fillPersonalInfoFields(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    }
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                type: 'text',
                width: "*",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },

            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                type: 'text',
                width: "*",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },
            {
                name: "personality.fullNameEn",
                title: "<spring:message code='firstName.latin'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true
            },


            {
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                type: 'text',
                width: "*",
                disabled: true
            },




            {
                name: "personality.nationality",
                title: "<spring:message code='nationality'/>",
                type: 'text',
                width: "*",
                defaultValue: "<spring:message code='persian'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },




            {
                name: "personality.genderId",
                type: "IntegerItem",
                title: "<spring:message code='gender'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Egender_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },

            {
                name: "personality.militaryId",
                type: "IntegerItem",
                width: "*",
                title: "<spring:message code='military'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Emilitary_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {"true": "<spring:message code='enabled'/>", "false": "<spring:message code='disabled'/>"},
                vertical: false,
                defaultValue: "true"
            },


            {
                name: "personality.educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                hidden:true,
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "categoryList",
                type: "selectItem",
                textAlign: "center",
                hidden:true,
                width: "*",
                title: "<spring:message code='education.categories'/>",
                autoFetchData: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                pickListProperties: {
                    showFilterEditor: true,
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "<spring:message code='select.all'/>",
                                    click: function () {
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categoryList"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i]["id"];
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "<spring:message code='deselect.all'/>",
                                    click: function () {
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categoryList");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                }
            },


       ],
        itemChanged: function (item, newValue) {

        }
    });


    var DynamicForm_Photo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleSuffix: "",
        valuesManager: "vm",
        numCols: 2,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                ID: "attachPic",
                name: "attachPic",
                title: "",
                type: "file",
                titleWidth: "80",
                accept: ".png,.gif,.jpg, .jpeg",
                multiple: "",
                width: "100%",
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "attachPic") {
                showTempAttach();
                setTimeout(function () {
                    if (attachNameTemp === null || attachNameTemp === "") {
                        DynamicForm_Photo_JspTeacher.getField("attachPic").setValue(null);
                        showAttachViewLoader.setView();
                    }
                }, 300);
            }
        }
    });



    var IButton_Teacher_Save_JspTeacher = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        icon: "pieces/16/save.png",
        click: function () {
            if (codeMeliCheck == false || cellPhoneCheck == false || mailCheck == false || persianDateCheck == false) {
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
            if (teacherMethod.localeCompare("PUT") == 0) {
                var teacherRecord = ListGrid_Teacher_JspTeacher.getSelectedRecord();
                teacherSaveUrl += teacherRecord.id;
            }
            isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data), "callback: teacher_action_result(rpcResponse)"));
        }
    });

    var IButton_Teacher_Exit_JspTeacher = isc.IButton.create({
        title: "<spring:message code='cancel'/>",
        icon: "<spring:url value="remove.png"/>",
        prompt: "",
        width: 100,
        orientation: "vertical",
        click: function () {
            showAttachViewLoader.hide();
            Window_Teacher_JspTeacher.close();
        }
    });

    var HLayOut_TeacherSaveOrExit_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Teacher_Save_JspTeacher, IButton_Teacher_Exit_JspTeacher]
    });

    var TabSet_BasicInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "75%",
        tabs: [
            {
                title: "<spring:message code='basic.information'/>", canClose: false,
                pane: DynamicForm_BasicInfo_JspTeacher
            }
        ]
    });

    var VLayOut_Photo_JspTeacher = isc.VLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        defaultLayoutAlign: "center",
        padding: 10,
        membersMargin: 10,
        width: "95%",
        members: [VLayOut_ViewLoader_JspTeacher, DynamicForm_Photo_JspTeacher]
    });

    var TabSet_Photo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        width: "25%",
        alignLayout: "center",
        align: "center",
        tabs: [
            {
                title: "<spring:message code='personality.photo'/>", canClose: false,
                pane: VLayOut_Photo_JspTeacher
            }
        ]
    });

    var HLayOut_Temp_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        height: "55%",
        membersMargin: 10,
        members: [TabSet_BasicInfo_JspTeacher, TabSet_Photo_JspTeacher]
    });



    var Window_Teacher_JspTeacher = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        canDragResize: true,
        autoSize: true,
        align: "center",
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: true,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                HLayOut_Temp_JspTeacher,
                HLayOut_TeacherSaveOrExit_JspTeacher
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspTeacher = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_teacher_refresh();
        }
    });

    var ToolStripButton_Edit_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_teacher_edit();
        }
    });

    var ToolStripButton_Add_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_teacher_add();
        }
    });

    var ToolStripButton_Remove_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_teacher_remove();
        }
    });

    var ToolStripButton_Print_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_teacher_print("pdf");
        }
    });

    var ToolStrip_Actions_JspTeacher = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_JspTeacher,
            ToolStripButton_Add_JspTeacher,
            ToolStripButton_Edit_JspTeacher,
            ToolStripButton_Remove_JspTeacher,
            ToolStripButton_Print_JspTeacher
        ]
    });

    var HLayout_Grid_Teacher_JspTeacher = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Teacher_JspTeacher]
    });

    var HLayout_Actions_Teacher = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspTeacher]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Teacher,
            HLayout_Grid_Teacher_JspTeacher
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_teacher_refresh() {
        ListGrid_Teacher_JspTeacher.invalidateCache();
    };

    function showTeacherCategories(value) {
        teacherCategoriesID.add(value.id);
    };

    function ListGrid_teacher_edit() {
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.not.selected.record'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function () {
                    this.close();
                }
            });
        } else {
            showAttach(ListGrid_Teacher_JspTeacher.getSelectedRecord().personalityId);
            vm.clearValues();
            vm.clearErrors(true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

            DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);



            teacherMethod = "PUT";
            vm.editRecord(record);

            var eduMajorValue = record.personality.educationMajorId;
            var eduOrientationValue = record.personality.educationOrientationId;
            if (eduOrientationValue == undefined && eduMajorValue == undefined) {
                DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
            } else if (eduMajorValue != undefined) {
                RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationUrl + "major/spec-list-by-majorId/" + eduMajorValue;
                DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
                DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
            }

            var stateValue_home = undefined;
            var cityValue_home = undefined;
            var stateValue_work = undefined;
            var cityValue_work = undefined;

            if (record.personality.contactInfo != null && record.personality.contactInfo.homeAddress != null && record.personality.contactInfo.homeAddress.stateId != null)
                stateValue_home = record.personality.contactInfo.homeAddress.stateId;
            if (record.personality.contactInfo != null && record.personality.contactInfo.homeAddress != null && record.personality.contactInfo.homeAddress.cityId != null)
                cityValue_home = record.personality.contactInfo.homeAddress.cityId;

            if (stateValue_home != undefined) {
                RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_home;

            }

            if (record.personality.contactInfo != null && record.personality.contactInfo.workAddress != null && record.personality.contactInfo.workAddress.stateId != null)
                stateValue_work = record.personality.contactInfo.workAddress.stateId;
            if (record.personality.contactInfo != null && record.personality.contactInfo.workAddress != null && record.personality.contactInfo.workAddress.cityId != null)
                cityValue_work = record.personality.contactInfo.workAddress.cityId;
            if (cityValue_work == undefined) {

            }
            if (stateValue_work != undefined) {
                RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_work;

            }
            DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = true;
            showCategories();
            Window_Teacher_JspTeacher.show();
            Window_Teacher_JspTeacher.bringToFront();
        }
    };

    function ListGrid_teacher_add() {
        vm.clearValues();
        vm.clearErrors(true);
        showAttachViewLoader.show();
        showAttachViewLoader.setView();


        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);

        ;


        teacherMethod = "POST";
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = false;
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();
    };

    function ListGrid_teacher_remove() {
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.not.selected.record'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='msg.remove.title'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='yes'/>"}), isc.IButtonCancel.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        teacherWait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });

                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + record.id, "DELETE", null, "callback: teacher_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    };

    function ListGrid_teacher_print(type) {
        var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/teacher/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.submitForm();
    };

    function addCategories(teacherId, categoryIds) {
        var JSONObj = {"ids": categoryIds};
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "addCategories/" + teacherId, "POST", JSON.stringify(JSONObj), "callback: teacher_addCategories_result(rpcResponse)"));

    };

    function addAttach(personalId) {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);

        if (file != undefined) {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addAttach/" + personalId, "POST", personalInfo_addAttach_result);
        }

    };

    function personalInfo_addAttach_result(req) {
        attachName = req.response;
    }


    function showTempAttach() {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file != undefined) {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addTempAttach", "POST", personalInfo_showTempAttach_result);
        }
    };

    function personalInfo_showTempAttach_result(req) {
        attachNameTemp = req.response;
        showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getTempAttach/"/>" + attachNameTemp);
        showAttachViewLoader.show();
    }

    function showCategories() {
        teacherId = ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "getCategories/" + teacherId, "POST", null, "callback: teacher_getCategories_result(rpcResponse)"));
    };

    function teacher_delete_result(resp) {
        teacherWait.close();
        if (resp.httpResponseCode == 200) {
            ListGrid_Teacher_JspTeacher.invalidateCache();
            var OK = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.successful'/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code='msg.command.done'/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else if (resp.data == false) {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.teacher.remove.error'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        } else {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.failed'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };

    function teacher_action_result(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data == "") {
                var ERROR = isc.Dialog.create({
                    message: ("<spring:message code='msg.national.code.duplicate'/>"),
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            } else {
                responseID = JSON.parse(resp.data).id;
                gridState = "[{id:" + responseID + "}]";
                categoryList = DynamicForm_BasicInfo_JspTeacher.getField("categoryList").getValue();
                var OK = isc.Dialog.create({
                    message: "<spring:message code='msg.operation.successful'/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code='msg.command.done'/>"
                });
                setTimeout(function () {
                    OK.close();
                    ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
                }, 1000);
                if (DynamicForm_Photo_JspTeacher.getField("attachPic").getValue() != undefined)
                    addAttach(JSON.parse(resp.data).personalityId);
                setTimeout(function () {
                    if (categoryList != undefined)
                        addCategories(responseID, categoryList);
                }, 300);
                showAttachViewLoader.hide();
                ListGrid_Teacher_JspTeacher.invalidateCache();
                ListGrid_Teacher_JspTeacher.fetchData();
                Window_Teacher_JspTeacher.close();
            }
        } else {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='error'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };







    function checkCodeMeli(code) {
        if (code == "undefined" && code == null && code == "")
            return false;
        var L = code.length;

        if (L < 8 || parseFloat(code, 10) == 0) return false;
        code = ('0000' + code).substr(L + 4 - 10);
        if (parseFloat(code.substr(3, 6), 10) == 0) return false;
        var c = parseFloat(code.substr(9, 1), 10);
        var s = 0;
        for (var i = 0; i < 9; i++)
            s += parseFloat(code.substr(i, 1), 10) * (10 - i);
        s = s % 11;
        return (s < 2 && c == s) || (s >= 2 && c == (11 - s));
        return true;
    };






    function showAttach(pId) {
        selectedRecordPersonalID = pId;
        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "checkAttach/" + selectedRecordPersonalID, "GET", null, "callback: personalInfo_checkAttach_result(rpcResponse)"));
    };

    function personalInfo_checkAttach_result(resp) {
        if (resp.data == "true") {
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getAttach/"/>" + selectedRecordPersonalID);
            showAttachViewLoader.show();
        } else if (resp.data == "false") {
            showAttachViewLoader.setView();
            showAttachViewLoader.show();
        }
    };


