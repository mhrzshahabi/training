<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
// <script>
    var hasTeacherCategoriesChanged = false;
    var hasTeacherMajorCategoryChanged = false;
    //----------------------------------------------------Rest Data Source----------------------------------------------
    var RestDataSource_Category_Evaluation_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_Evaluation_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Categories_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategories_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //----------------------------------------------------Variables-----------------------------------------------------
    var showAttachViewLoader = isc.ViewLoader.create({
        viewURL: "",
        overflow: "scroll",
        height: "133px",
        width: "130px",
        border: "1px solid orange",
        scrollbarSize: 0,
        prompt: "سایز عکس باید کوچکتر از 30 مگا بایت باشد<br/>اندازه ی عکس باید بین 100*100 تا 500*500 پیکسل باشد",
        loadingMessage: "<spring:message code='msg.photo.loading.error'/>"
    });

    var upload_btn = isc.HTMLFlow.create({
        align: "center",
        contents: "<form class=\"uploadButton\" method=\"POST\" id=\"form\" action=\"\" enctype=\"multipart/form-data\"><label for=\"file-upload\" class=\"custom-file-upload\"><i class=\"fa fa-cloud-upload\"></i>آپلود تصویر</label><input id=\"file-upload\" type=\"file\" name=\"file[]\" name=\"attachPic\" onchange=\"upload()\" accept=\".png,.gif,.jpg, .jpeg\"/></form>"
    });

    //----------------------------------------------------Rest Data Sources---------------------------------------------
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
    //--------------------------------------------Dynamic Form----------------------------------------------------------
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
        styleName: "teacher-form",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "id", hidden: true},
            {name: "personality.id", hidden: true},
            {
                name: "personnelStatus",
                title: "<spring:message code='teacher.type'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {
                    "true": "<spring:message code='company.staff'/>",
                    "false": "<spring:message code='external.teacher'/>"
                },
                vertical: false,
                defaultValue: "false",
                changed: function () {
                    var personnelStatusTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personnelStatus");
                    vm.clearValues();
                    DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");
                    if (personnelStatusTemp == "true") {
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").enable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("true");
                    } else if (personnelStatusTemp == "false") {
                        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").enable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("false");
                    }

                }
            },
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true,
                blur: function () {
                    var codeCheck;
                    codeCheck = checkNationalCode(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    nationalCodeCheck = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true && DynamicForm_BasicInfo_JspTeacher.getValue("personnelStatus") == "false") {
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);
                        var nationalCodeTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode");
                        fillPersonalInfoFields(nationalCodeTemp);
                    }
                    if (codeCheck === true && DynamicForm_BasicInfo_JspTeacher.getValue("personnelStatus") == "true") {
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);
                        var nationalCodeTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode");
                        fillPersonalInfoByNationalCode(nationalCodeTemp);
                    }
                }
            },
            {
                name: "personnelCode",
                title: "<spring:message code='personnel.no'/>",
                disabled: true,
                keyPressFilter: "[0-9]",
                length: "10",
                blur: function () {
                    var personnelCodeTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personnelCode");
                    fillPersonalInfoByPersonnelNumber(personnelCodeTemp);
                }
            },
            {
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                canEdit: false,
                baseStyle: "teacher-code"
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                width: "*",
                colSpan: 2,
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
                required: true,
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
                    if (DynamicForm_BasicInfo_JspTeacher.getValue("personality.birthDate") == null ||
                        DynamicForm_BasicInfo_JspTeacher.getValue("personality.birthDate") == "")
                        dateCheck = true;
                    else
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
                required: true,
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
                optionDataSource: RestDataSource_Education_Level_ByID_JspTeacher,
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
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                autoFetchData: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_ByID_JspTeacher,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
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
                type: "SelectItem",
                textAlign: "center",
                required: true,
                optionDataSource: RestDataSource_Categories_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                changed: function () {
                    hasTeacherCategoriesChanged = true;
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
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategories_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                focus: function () {
                    if (hasTeacherCategoriesChanged) {
                        hasTeacherCategoriesChanged = false;
                        var ids = DynamicForm_BasicInfo_JspTeacher.getField("categories").getValue();
                        if (ids == []) {
                            RestDataSource_SubCategories_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategories_JspTeacher.implicitCriteria = {
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
                required: true,
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
                length: "50"
            },
            {
                name: "personality.description",
                title: "<spring:message code='description'/>",
                type: 'textArea',
                colSpan: 3
            },
            {
                name: "evaluation",
                title: "",
                canEdit: false,
                baseStyle: "eval-code"
            },
            {
                name: "majorCategoryId",
                title: "<spring:message code='related.category'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_Evaluation_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                filterFields: ["titleFa","titleFa"],
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                changed: function (form,item,value) {
                    hasTeacherMajorCategoryChanged = true;
                    DynamicForm_BasicInfo_JspTeacher.getField("majorSubCategoryId").clearValue();
                    if (value == null || value == undefined) {
                        DynamicForm_BasicInfo_JspTeacher.getField("majorSubCategoryId").disable();
                    } else{
                        DynamicForm_BasicInfo_JspTeacher.getField("majorSubCategoryId").enable();
                    }
                }
            },
            {
                name: "majorSubCategoryId",
                title: "<spring:message code='related.sub.category'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                disabled: true,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_SubCategory_Evaluation_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ],
                focus: function () {
                    if (hasTeacherMajorCategoryChanged) {
                        hasTeacherMajorCategoryChanged = false;
                        var id = DynamicForm_BasicInfo_JspTeacher.getField("majorCategoryId").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_Evaluation_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Evaluation_JspTeacher.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: id}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },

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
                    RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationOrientationUrl +
                        "spec-list-by-levelId-and-majorId/" + levelId + ":" + majorId;
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

    DynamicForm_BasicInfo_JspTeacher.getItem('teacherCode').setCellStyle('teacher-code-label');
    DynamicForm_BasicInfo_JspTeacher.getItem('teacherCode').titleStyle = 'teacher-code-title';

    DynamicForm_BasicInfo_JspTeacher.getItem('evaluation').setCellStyle('eval-code-label');

    //------------------------------------------ Functions -------------------------------------------------------------
    function upload() {
        var upload = document.getElementById('file-upload');
        var image = upload.files[0];
        console.log(image);
        showTempAttach();
        setTimeout(function () {
            if (attachNameTemp === null || attachNameTemp === "") {
                upload.value = "";
                showAttachViewLoader.setView();
            }
        }, 300);
    }
    // ------------------------------------------- Page UI -------------------------------------------------------------

    var HLayOut_ViewLoader_JspTeacher = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        styleName: "upload-hlayout",
        align: "top",
        height: "100",
        members: [showAttachViewLoader]
    });

    var HLayOut_Photo_JspTeacher = isc.TrHLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "top",
        layoutMargin: 5,
        members: [
            upload_btn]
    });

    var VLayOut_Photo_JspTeacher = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        height: "100%",
        width: "5%",
        align: "top",
        members: [HLayOut_ViewLoader_JspTeacher, HLayOut_Photo_JspTeacher]
    });

    var VLayOut_Basic_JspTeacher = isc.TrVLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        membersMargin: 10,
        width: "85%",
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
