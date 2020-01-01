<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
// <script>
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
                name: "personnelCode",
                title: "<spring:message code='personnel.no'/>",
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
                name: "personnelStatus",
                title: "<spring:message code='teacher.type'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {"true": "<spring:message code='company.staff'/>", "false": "<spring:message code='external.teacher'/>"},
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
                name: "categories",
                title: "<spring:message code='education.categories'/>",
                type: "selectItem",
                textAlign: "center",
                required: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
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
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categories"),
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
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categories");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function () {
                    isTeacherCategoriesChanged = true;
                    var subCategoryField = DynamicForm_BasicInfo_JspTeacher.getField("subCategories");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='sub.education.categories'/>",
                type: "selectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
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
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("subCategories"),
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
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("subCategories");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                focus: function () {
                    if (isTeacherCategoriesChanged) {
                        isTeacherCategoriesChanged = false;
                        var ids = DynamicForm_BasicInfo_JspTeacher.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
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

    <%--</script>--%>
