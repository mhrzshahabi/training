<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var teacherMethod = "POST";
    var teacherWait;
    var responseID;
    var categoryList;
    var gridState;
    var attachName;
    var attachNameTemp;
    var nationalCodeCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;
    var selectedRecordPersonalID = null;
    var teacherCategoriesID = [];
var dummy;
    //----------------------------------------------------Rest Data Sources-------------------------------------------

    var RestDataSource_Teacher_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"},
            {name: "personality.contactInfo.homeAddress.id"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });

    var RestDataSource_EAttachmentType_JpaTeacher = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"}],
        fetchDataURL: enumUrl + "eTeacherAttachmentType/spec-list"
    });

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
            }
        }]
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
                name: "category",
                title: "<spring:message code='education.categories'/>",
                align: "center",
                formatCellValue: function (value, record) {
                    if (record.categories.length === 0)
                        return;
                    record.categories.sort();
                    var cat = record.categories[0].titleFa.toString();
                    for (var i = 1; i < record.categories.length; i++) {
                        cat += "، " + record.categories[i].titleFa;
                    }
                    return cat;
                },
                sortNormalizer: function (record) {
                    if (record.categories.length === 0)
                        return;
                    record.categories.sort();
                    var cat = record.categories[0].titleFa.toString();
                    for (var i = 1; i < record.categories.length; i++) {
                        cat += "، " + record.categories[i].titleFa;
                    }
                    return cat;
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

    //--------------------------------------------View Loader-----------------------------------------------------
    var showAttachViewLoader = isc.ViewLoader.create({
        viewURL: "",
        overflow: "scroll",
        height: "133px",
        width: "130px",
        border: "1px solid orange",
        scrollbarSize: 0,
        loadingMessage: "<spring:message code='msg.photo.loading.error'/>"
    });

    //--------------------------------------------Dynamic Form-----------------------------------------------------
    var vm = isc.ValuesManager.create({});

    var DynamicForm_BasicInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        titleAlign: "left",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "id", hidden: true},
            {name: "personality.id", hidden: true},
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true,
                changed: function () {
                    var codeCheck;
                    codeCheck = checkNationalCode(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    nationalCodeCheck = codeCheck;
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
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                disabled: true
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
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },

            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },

            {
                name: "personality.fatherName",
                title: "<spring:message code='father.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "personality.firstNameEn",
                title: "<spring:message code='firstName.latin'/>",
                keyPressFilter: "[a-z|A-Z |]"
            },

            {
                name: "personality.lastNameEn",
                title: "<spring:message code='lastName.latin'/>",
                keyPressFilter: "[a-z|A-Z |]"
            },

            {
                name: "personality.birthDate",
                title: "<spring:message code='birth.date'/>",
                ID: "birthDate_jspTeacher",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('birthDate_jspTeacher', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                    var dateCheck;
                    dateCheck = checkBirthDate(DynamicForm_BasicInfo_JspTeacher.getValue("personality.birthDate"));
                    persianDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.birthDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                    else if (dateCheck === true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.birthDate", true);
                }
            },

            {
                name: "personality.birthLocation",
                title: "<spring:message code='birth.location'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },
            {
                name: "personality.birthCertificate",
                title: "<spring:message code='birth.certificate'/>",
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "personality.birthCertificateLocation",
                title: "<spring:message code='birth.certificate.location'/>",
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
                name: "personality.marriedId",
                type: "IntegerItem",
                title: "<spring:message code='marital.status'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Emarried_JspTeacher,
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
                name: "personality.educationLevelId",
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Education_Level_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },

            {
                name: "personality.educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTeacher,
                autoFetchData: true,
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
                name: "personality.educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
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
                required: true,
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

            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='cellPhone'/>",
                keyPressFilter: "[0-9]",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                errorMessage: "<spring:message code='msg.mobile.validation'/>"
                , changed: function () {
                    var mobileCheck;
                    mobileCheck = checkMobile(DynamicForm_BasicInfo_JspTeacher.getValue("personality.contactInfo.mobile"));
                    cellPhoneCheck = mobileCheck;
                    if (mobileCheck === false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.contactInfo.mobile", "<spring:message
                                                                           code='msg.mobile.validation'/>", true);
                    if (mobileCheck === true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
                }
            },

            {
                name: "personality.nationality",
                title: "<spring:message code='nationality'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "personality.description",
                title: "<spring:message code='description'/>",
                type: 'textArea',
                colSpan: 3
            }

        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.nationalCode")
                this.getItem("teacherCode").setValue(item.getValue());
            else if (item.name === "personality.educationLevelId" || item.name === "personality.educationMajorId") {
                var levelId = DynamicForm_BasicInfo_JspTeacher.getField("personality.educationLevelId").getValue();
                var majorId = DynamicForm_BasicInfo_JspTeacher.getField("personality.educationMajorId").getValue();
                if (newValue === undefined) {
                    DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
                } else if (levelId !== undefined && majorId !== undefined) {
                    DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
                    RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationUrl +
                        "orientation/spec-list-by-levelId-and-majorId/" + levelId + ":" + majorId;
                    DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource =
                        RestDataSource_Education_Orientation_JspTeacher;
                    DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
                }
            } else if (item.name === "attachPic") {
                showTempAttach();
            } else if (item.name === "enableStatus") {
                if (newValue === "false") {
                    var ask = createDialog("confirm", "<spring:message code='msg.teacher.enable.status.change.confirm'/>");
                    ask.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 1) {
                                DynamicForm_BasicInfo_JspTeacher.getField("enableStatus").setValue("true");
                            }
                        }
                    });
                }
            }
        }
    });

    var DynamicForm_Photo_JspTeacher = isc.DynamicForm.create({
        align: "center",
        canSubmit: true,
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 2,
        titleAlign: "left",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                ID: "attachPic",
                name: "attachPic",
                title: "",
                type: "imageFile",
                showFileInline: "true",
                accept: ".png,.gif,.jpg, .jpeg",
                multiple: ""
            }
        ],
        itemChanged: function (item) {
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

    var DynamicForm_JobInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.jobLocation",
                title: "<spring:message code='job'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.jobTitle",
                title: "<spring:message code='work.place'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.contactInfo.workAddress.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10"
            },
            {
                name: "personality.contactInfo.workAddress.webSite",
                title: "<spring:message code='website'/>",
                length: "30"
            },

            {
                name: "personality.contactInfo.workAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                width: "*",
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Work_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.cityId",
                title: "<spring:message code='city'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                width: "*",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                width: "*",
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true
            },
            {
                name: "personality.contactInfo.workAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                type: "textArea",
                length: "255"
            },
            {
                name: "personality.contactInfo.workAddress.phone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },
            {
                name: "personality.contactInfo.workAddress.fax",
                title: "<spring:message code='telefax'/>"
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.workAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                } else {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                    RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
                }
            } else if (item.name === "personality.contactInfo.workAddress.otherCountry") {
                DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.stateId");
                if (newValue === true) {
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").disable();
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").disable();
                } else {
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").enable();
                    DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").enable();
                }
            } else if (item.name === "personality.contactInfo.workAddress.postalCode") {
                if (newValue < 1e9)
                    DynamicForm_JobInfo_JspTeacher.addFieldErrors("personality.contactInfo.workAddress.postalCode",
                        "<spring:message code='msg.postal.code.validation'/>", true);
                else {
                    DynamicForm_JobInfo_JspTeacher.clearFieldErrors("personality.contactInfo.workAddress.postalCode", true);
                    fillWorkAddressFields(DynamicForm_JobInfo_JspTeacher.getValue("personality.contactInfo.workAddress.postalCode"));
                }
            }
        }

    });

    var DynamicForm_AccountInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.accountInfo.bank",
                title: "<spring:message code='bank'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "personality.accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "personality.accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "personality.accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "personality.accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "economicalCode",
                title: "<spring:message code='economical.code'/>",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "economicalRecordNumber",
                title: "<spring:message code='economical.record.number'/>",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            }
        ]
    });

    var DynamicForm_AddressInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        titleAlign: "left",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {name: "personality.contactInfo.homeAddress.id", hidden: true},
            {
                name: "personality.contactInfo.homeAddress.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10"
            },
            {
                name: "personality.contactInfo.homeAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Home_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.cityId",
                title: "<spring:message code='city'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true
            },
            {
                name: "personality.contactInfo.homeAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                type: "textArea",
                length: "255"
            },
            {
                name: "personality.contactInfo.homeAddress.phone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },


            {
                name: "personality.contactInfo.homeAddress.fax",
                title: "<spring:message code='telefax'/>"
            },

            {
                name: "personality.contactInfo.email",
                title: "<spring:message code='email'/>",
                showHintInField: true,
                length: "30"
                , changed: function () {
                    var emailCheck;
                    emailCheck = checkEmail(DynamicForm_AddressInfo_JspTeacher.getValue("personality.contactInfo.email"));
                    mailCheck = emailCheck;
                    if (emailCheck === false)
                        DynamicForm_AddressInfo_JspTeacher.addFieldErrors("personality.contactInfo.email",
                            "<spring:message code='msg.email.validation'/>", true);
                    if (emailCheck === true)
                        DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
                }
            },


            {
                name: "personality.contactInfo.personalWebSite",
                title: "<spring:message code='personal.website'/>",
                stopOnError: true
            }

        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.homeAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                } else {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                    RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
                    DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
                }
            } else if (item.name === "personality.contactInfo.homeAddress.otherCountry") {
                DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.stateId");
                if (newValue === true) {
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").disable();
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").disable();
                } else {
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").enable();
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").enable();
                }
            } else if (item.name === "personality.contactInfo.homeAddress.postalCode") {
                if (newValue < 1e9)
                    DynamicForm_AddressInfo_JspTeacher.addFieldErrors("personality.contactInfo.homeAddress.postalCode",
                        "<spring:message code='msg.postal.code.validation'/>", true);
                else {
                    DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.homeAddress.postalCode", true);
                    fillHomeAddressFields(DynamicForm_AddressInfo_JspTeacher.getValue("personality.contactInfo.homeAddress.postalCode"));
                }
            }
        }
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

    var HLayOut_ViewLoader_JspTeacher = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        align: "center",
        members: [showAttachViewLoader]
    });

    var HLayOut_Photo_JspTeacher = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        membersMargin: 10,
        members: [DynamicForm_Photo_JspTeacher]
    });

    var VLayOut_Photo_JspTeacher = isc.TrVLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        membersMargin: 10,
        width: "15%",
        align: "center",
        members: [HLayOut_ViewLoader_JspTeacher, HLayOut_Photo_JspTeacher]
    });

    var VLayOut_Basic_JspTeacher = isc.TrVLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        membersMargin: 10,
        width: "75%",
        members: DynamicForm_BasicInfo_JspTeacher
    });

    var HLayOut_Basic_JspTeacher = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        membersMargin: 10,
        width: "100%",
        members: [VLayOut_Basic_JspTeacher, VLayOut_Photo_JspTeacher]
    });

    var TabSet_BasicInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        width: "100%",
        tabs: [
            {
                title: "<spring:message code='basic.information'/>", canClose: false,
                pane: HLayOut_Basic_JspTeacher
            }
        ]
    });


    var HLayOut_Temp_JspTeacher = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        height: "60%",
        membersMargin: 10,
        showResizeBar: true,
        members: [TabSet_BasicInfo_JspTeacher]
    });

    var TabSet_Bottom_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "30%",
        tabs: [
            {
                title: "<spring:message code='account.information'/>", canClose: false,
                pane: DynamicForm_AccountInfo_JspTeacher
            },
            {
                title: "<spring:message code='address'/>", canClose: false,
                pane: DynamicForm_AddressInfo_JspTeacher
            },
            {
                title: "<spring:message code='work.place'/>", canClose: false,
                pane: DynamicForm_JobInfo_JspTeacher
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
                HLayOut_Temp_JspTeacher,
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

    function showTeacherCategories(value) {
        teacherCategoriesID.add(value.id);
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
        showCategories();
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
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();

        // TabSet_Bottom_JspTeacher.getTab("attachmentsTab").disable();
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

    function addCategories(teacherId, categoryIds) {
        var JSONObj = {"ids": categoryIds};
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "addCategories/" + teacherId, "POST", JSON.stringify(JSONObj),
            "callback: teacher_addCategories_result(rpcResponse)"));
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

    function showCategories() {
        teacherId = ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "getCategories/" + teacherId, "POST", null,
            "callback: teacher_getCategories_result(rpcResponse)"));
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
                categoryList = DynamicForm_BasicInfo_JspTeacher.getField("categoryList").getValue();
                var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                    "<spring:message code="msg.command.done"/>");
                setTimeout(function () {
                    OK.close();
                    ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
                }, 1000);
                addAttach(JSON.parse(resp.data).personality.id);
                showAttach(JSON.parse(resp.data).personality.id);
                setTimeout(function () {
                    if (categoryList !== undefined)
                        addCategories(responseID, categoryList);
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
                categoryList = DynamicForm_BasicInfo_JspTeacher.getField("categoryList").getValue();
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
                setTimeout(function () {
                    if (categoryList !== undefined)
                        addCategories(responseID, categoryList);
                }, 300);
                showAttachViewLoader.hide();
            }
        } else {
        }
    }

    function teacher_addCategories_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function teacher_getCategories_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            DynamicForm_BasicInfo_JspTeacher.getField("categoryList").setValue(JSON.parse(resp.data));
        } else {
            createDialog("info", "<spring:message code='error'/>");
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

    function personalInfo_findOne_result(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            var personality = JSON.parse(resp.data);
            showAttach(personality.id);
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
                loadPage_attachment("Teacher", teacherId, "<spring:message code="document"/>", RestDataSource_EAttachmentType_JpaTeacher);

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

            if (typeof loadPage_OtherActivities !== "undefined")
                loadPage_OtherActivities(teacherId);

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

        if (typeof clear_Publication !== "undefined")
            clear_Publication();

        if (typeof clear_OtherActivities !== "undefined")
            clear_OtherActivities();
    }

    // </script>