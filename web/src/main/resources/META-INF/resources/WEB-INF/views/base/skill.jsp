<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var skill_Level_Symbol = "";
    var skill_Method = "GET";
    var skill_SkillHomeUrl = rootUrl + "/skill";
    var skill_CategoryHomeUrl = rootUrl + "/category";
    var skill_ActionUrl = rootUrl + "/skill";
    var skill_CategoryUrl = rootUrl + "/category/spec-list";
    var skill_SkillLevelUrl = rootUrl + "/skill-level/spec-list";
    var skill_selectedSkillId = -1;

    // Start Block Of Combo And List Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill_Level = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "version", filterOperator: "iContains"}
        ],
        fetchDataURL: skill_SkillLevelUrl
    });

    var RestDataSource_Skill_Category = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code", filterOperator: "iContains"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "description", filterOperator: "iContains"}
        ],
        fetchDataURL: skill_CategoryUrl
    });

    var RestDataSource_Skill_SubCategory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code", filterOperator: "iContains"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "description", filterOperator: "iContains"},
        ]
    });

    var RestDataSource_Course_JspSkill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name:"scoringMethod"},
            {name:"acceptancelimit"},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name:"createdBy",title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
            {name: "theoryDuration"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });


    //End Block Of Combo And List Data Sources ----------------------------------------------------------


    // Start Block Of Main And Detail Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "code", filterOperator: "iContains"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "category.titleFa", filterOperator: "iContains"},
            {name: "subCategory.titleFa", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", filterOperator: "iContains"},
            {name: "description", filterOperator: "iContains"},
            {name: "courseId"},
            // {name: "course.titleFa", filterOperator: "iContains"},
            {name: "course.code", filterOperator: "iContains"},
        ],
        fetchDataURL: skill_SkillHomeUrl + "/spec-list"
    });

    var RestDataSource_Skill_Attached_SkillGroups = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"}
        ],
        fetchDataURL: skill_SkillHomeUrl + "/skill-group-dummy"
    });

    var RestDataSource_Skill_UnAttached_SkillGroups = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"}
        ],
        fetchDataURL: skill_SkillHomeUrl + "/skill-group-dummy"
    });


    var RestDataSource_Skill_Need_Assessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "post.titleFa", title: "<spring:message code="post"/>", filterOperator: "iContains"},
            {name: "competence.titleFa", title: "<spring:message code="competence"/>", filterOperator: "iContains"},
            {
                name: "edomainType.titleFa",
                title: "<spring:message code="domain"/>",
                filterOperator: "iContains"
            },
            {
                name: "eneedAssessmentPriority.titleFa",
                title: "<spring:message code="priority"/>",
                filterOperator: "iContains"
            },
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: skill_SkillHomeUrl + "/0/need-assessment"
    });


    //End Block Of Main And Detail Data Sources ----------------------------------------------------------

    var DynamicForm_Skill_Skill = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
// showInlineErrors: true,
        numCols: "4",
// showErrorText: true,
// showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "left",

        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                colSpan: 2,
                title: "<spring:message code="skill.code"/>",
                length: 10,
                type: 'staticText',
                required: false,
                keyPressFilter: "^[A-Z|0-9 ]",
                width: "300"
            },
            {
                name: "titleFa",
                title: "<spring:message code='title'/>",
                required: true,
// hint: " عنوان فارسی",
                showHintInField: true,
                type: 'text',
                default: "125",
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255",
                width: "300",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "titleEn",
                title: "<spring:message code='title.en'/>",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
// hint: "<spring:message code='title.en'/>",
                showHintInField: true,
                length: "255",
                width: "300",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "skillLevelId",
                title: "<spring:message code="skill.level"/>",
// hint: "<spring:message code="skill.level"/>",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                // editorType: "ComboBoxItem",
                pickListWidth: 300,
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Skill_Level,
                autoFetchData: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                // pickListProperties: {
                //     showFilterEditor: true
                // },
                <%--pickListFields: [--%>
                    <%--{--%>
                        <%--name: "titleFa",--%>
                        <%--title: "<spring:message code="title"/>",--%>
                        <%--width: "30%",--%>
                        <%--filterOperator: "iContains"--%>
                    <%--}--%>
                <%--],--%>
                changed: function (form, item, value) {
                    switch (value) {
                        case 1:
                            skill_Level_Symbol = "A";
                            break;
                        case 2:
                            skill_Level_Symbol = "B";
                            break;
                        case 3:
                            skill_Level_Symbol = "C";
                            break;
                    }

                }
            },
            {
                name: "categoryId",
                title: "<spring:message code="skill.group"/>",
// hint:"<spring:message code="skill.group"/>",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                // editorType: "ComboBoxItem",
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true, pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Category,
                autoFetchData: true,
                // filterFields: ["titleFa"],
                sortField: ["id"],
                // textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                // pickListProperties: {
                //     showFilterEditor: true
                // },
                // pickListFields: [
                //     {
                //         name: "titleFa",
                //         width: "30%",
                //         filterOperator: "iContains"
                //     }
                // ],
                changed: function (form, item, value) {
                    if (value == null || value.length == 0) {

                    } else {
                        RestDataSource_Skill_SubCategory.fetchDataURL = skill_CategoryHomeUrl + "/" + value + "/sub-categories";
                        form.getItem("subCategoryId").fetchData();
                        form.getItem("subCategoryId").setValue([]);
                        form.getItem("subCategoryId").setDisabled(false);
                    }
                }
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="skill.subcategory"/>",
// hint:"<spring:message code="skill.subcategory"/>",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                // editorType: "ComboBoxItem",
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                addUnknownValues: false,
                // useClientFiltering: true,
                cachePickListResults: true,
                // changeOnKeypress: false,
                // filterOnKeypress: true,
                optionDataSource: RestDataSource_Skill_SubCategory,
                autoFetchData: false,
                // filterFields: ["titleFa"],
                sortField: ["id"],
                // textMatchStyle: "startsWith",
                // generateExactMatchCriteria: true,
                // pickListProperties: {
                //     showFilterEditor: true
                // },
                // pickListFields: [
                //     {
                //         name: "code",
                //         width: "40%",
                //         filterOperator: "iContains"
                //     },
                //     {
                //         name: "titleFa",
                        <%--title: "<spring:message code="subcategory"/>",--%>
                        // width: "60%",
                        // filterOperator: "iContains"
                    // }
                // ],
            },
            {
                name: "courseId", editorType: "TrComboAutoRefresh", title: "<spring:message code='course'/>:",
                textAlign: "center",
                pickListWidth: 500,
                optionDataSource: RestDataSource_Course_JspSkill,
                displayField: "titleFa", valueField: "id",
                filterFields: ["titleFa", "code", "createdBy"],
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"},
                    {name: "createdBy"}
                ],
            },
            {
                name: "description",
                colSpan: 4,
// hint:"<spring:message code="description"/>",
                showHintInField: true,
                title: "<spring:message code="description"/>",
                length: "500",
                width: "700",
                type: 'areaText'
            }
        ]
    });

    var IButton_Skill_Skill_Save = isc.IButtonSave.create({
        click: function () {

            if (skill_Method == "POST") {
                var sub_cat_code;
                if (DynamicForm_Skill_Skill.getItem('subCategoryId').getSelectedRecord() != null)
                    sub_cat_code = DynamicForm_Skill_Skill.getItem('subCategoryId').getSelectedRecord().code;
                DynamicForm_Skill_Skill.getItem('code').setValue(sub_cat_code + skill_Level_Symbol);
            }
            DynamicForm_Skill_Skill.validate();
            if (DynamicForm_Skill_Skill.hasErrors()) {
                return;
            }
            var data = DynamicForm_Skill_Skill.getValues();

            isc.RPCManager.sendRequest({
                actionURL: skill_ActionUrl,
                httpMethod: skill_Method,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
                            message: "<spring:message code="msg.operation.successful"/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code="global.form.command.done"/>"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Skill_Skill_refresh();
                        Window_Skill_Skill.close();
                    } else {
                        var OK = isc.Dialog.create({
                            message: "<spring:message code="msg.operation.error"/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code="global.form.command.done"/>"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });

        }
    });

    var Hlayout_Skill_Skill_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        align: "center",
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Skill_Skill_Save, isc.IButtonCancel.create({
            click: function () {
                Window_Skill_Skill.close();
            }
        })]
    });

    var Window_Skill_Skill = isc.Window.create({
        title: "<spring:message code="skill"/>",
        width: "830",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            align: "center",
            members: [DynamicForm_Skill_Skill, Hlayout_Skill_Skill_SaveOrExit]
        })]
    });

    //معرفی DataSourse ها و ایجاد امکان نمایش

    var ListGrid_Skill_Attached_SkillGroups = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Attached_SkillGroups,
        doubleClick: function () {
// ListGrid_Skill_Skill_Edit();
        },
        fields: [
// {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: false,
        filterOnKeypress: true,
    });

    var ListGrid_Skill_Need_Assessment = isc.TrLG.create({
        dataSource: RestDataSource_Skill_Need_Assessment,
        showFilterEditor: false,
        filterOnKeypress: false,
        fields: [
            {name: "post.titleFa",},
            {name: "competence.titleFa",},
            {name: "edomainType.titleFa",},
            {name: "eneedAssessmentPriority.titleFa",},
// {name: "skill.titleFa", hidden: true},
            {name: "description",},
        ],
        autoFetchData: false,
        sortField: 0
    });


    var ToolStripButton__Action_Skill_SkillGroups_Select = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        click: function () {
            var record = ListGrid_Skill_Skill.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.not.selected.record'/>");
            } else {
                Skill_Add_SkillGroup();
            }
        }


    });

    var ToolStrip_Action_Skill_SkillGroups = isc.ToolStrip.create({
        width: "100%",
        vertical: true,
        center: true,
        members: [
            ToolStripButton__Action_Skill_SkillGroups_Select
        ]
    });


    // بخش مر بوط به معرفی Skill


    function ListGrid_Skill_Skill_Remove() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
//console.log(record);
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code="msg.record.remove.ask"/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                      this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='global.form.do.operation'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='global.message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: skill_SkillHomeUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Skill_Skill.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code="global.form.request.successful"/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code="global.form.command.done"/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code="msg.Item.cannot.delete"/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code="warning"/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }


    };

    function ListGrid_Skill_Skill_Edit() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
//console.log('record:' + JSON.stringify(record));
            var id = record.categoryId;
            DynamicForm_Skill_Skill.clearValues();
            RestDataSource_Skill_SubCategory.fetchDataURL = skill_CategoryHomeUrl + "/" + id + "/sub-categories";
            DynamicForm_Skill_Skill.getItem("subCategoryId").fetchData();
            skill_Method = "PUT";
            skill_ActionUrl = skill_SkillHomeUrl + "/" + record.id;
            DynamicForm_Skill_Skill.editRecord(record);
            DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("code").visible = true;
            Window_Skill_Skill.setTitle("<spring:message
        code="edit.skill"/>" + "&nbsp;" + getFormulaMessage(ListGrid_Skill_Skill.getSelectedRecord().code, 3, "red", "I"));
            Window_Skill_Skill.show();

        }
    };

    function ListGrid_Skill_Skill_Add() {
        skill_Method = "POST";
        skill_ActionUrl = skill_SkillHomeUrl;
        DynamicForm_Skill_Skill.clearValues();
        DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
        DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("code").visible = false;
        Window_Skill_Skill.setTitle("<spring:message code="create.skill"/>");
        Window_Skill_Skill.show();
    };

    function ListGrid_Skill_Skill_refresh() {
        // if(ListGrid_Skill_Skill.getSelectedRecord() != null) {
        //     let recordId = ListGrid_Skill_Skill.getSelectedRecord().id;
        //     ListGrid_Skill_Skill.invalidateCache();
        //     setTimeout(function () {
        //         let gridState = "[{id:" + recordId + "}]";
        //         ListGrid_Skill_Skill.setSelectedState(gridState);
        //     },3000)
        //     return;
        //     // if (record == null || record.id == null) {
        //     // } else {
        //     // ListGrid_Skill_Skill.selectRecord(record);
        //     // }
        // }
        var selectRecordState = ListGrid_Skill_Skill.getSelectedState()
        ListGrid_Skill_Skill.invalidateCache();
        setTimeout(function () {
            ListGrid_Skill_Skill.setSelectedState(selectRecordState);
        },5000)
    };

    var Menu_ListGrid_Skill_Skill = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code="refresh"/>",
            <%--icon: "<spring:url value="refresh.png"/>",--%>
            click: function () {
                ListGrid_Skill_Skill_refresh();
            }
        }, {
            title: "<spring:message code="create"/>",
            <%--icon: "<spring:url value="create.png"/>", --%>
            click: function () {
                ListGrid_Skill_Skill_Add();
            }
        }, {

            title: "<spring:message code="edit"/>",
            <%--icon: "<spring:url value="edit.png"/>",--%>
            click: function () {

                ListGrid_Skill_Skill_Edit();

            }
        }, {

            title: "<spring:message code="remove"/>",
            <%--icon: "<spring:url value="remove.png"/>", --%>
            click: function () {
                ListGrid_Skill_Skill_Remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>",
            <%--icon: "<spring:url value="pdf.png"/>",--%>
            click: function () {
                "<spring:url value="/skill/print-all/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "<spring:message code='print.excel'/>",
            <%--icon: "<spring:url value="excel.png"/>", --%>
            click: function () {
                "<spring:url value="/skill/print-all/excel" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "<spring:message code='print.html'/>",
            <%--icon: "<spring:url value="html.png"/>", --%>
            click: function () {
                "<spring:url value="/skill/print-all/html" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }]
    });

    var ListGrid_Skill_Skill = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Skill,
        contextMenu: Menu_ListGrid_Skill_Skill,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        doubleClick: function () {
            ListGrid_Skill_Skill_Edit();
        },
        fields: [
// {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", align: "center", filterOperator: "iContains", autoFitWidth:true},
            {name: "titleEn", title: "<spring:message code="title.en"/>", align: "center", filterOperator: "iContains"},
            {
                name: "course.code",
                // editorType: "TrComboAutoRefresh",
                title: "<spring:message code='course'/>",
                textAlign: "center",
                autoFitWidth: true,
                // pickListWidth: 500,
                // optionDataSource: RestDataSource_Course_JspSkill,
                // displayField: "code",
                // valueField: "code",
                // filterFields: ["titleFa", "code", "createdBy"],
                // pickListFields: [
                //     {name: "code"},
                //     {name: "titleFa"},
                //     {name: "createdBy"}
                // ],
                // filterEditorType:"TextItem",
                // canEdit: true,
                <%--change: function (form, item, value, oldValue) {--%>
                    <%--alert(this.grid.getSelectedRecord().course.code)--%>
                    <%--alert(oldValue)--%>
                    <%--item.setValue("123")--%>
                    <%--isc.MyYesNoDialog.create({--%>
                        <%--buttonClick: function (button, index) {--%>
                            <%--this.close();--%>
                            <%--if(index == 0){--%>
                                <%--let data = this.grid.getSelectedRecord()--%>
                                <%--isc.RPCManager.sendRequest({--%>
                                    <%--actionURL: skill_ActionUrl,--%>
                                    <%--httpMethod: "PUT",--%>
                                    <%--httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
                                    <%--useSimpleHttp: true,--%>
                                    <%--contentType: "application/json; charset=utf-8",--%>
                                    <%--showPrompt: false,--%>
                                    <%--data: JSON.stringify(data),--%>
                                    <%--serverOutputAsString: false,--%>
                                    <%--callback: function (resp) {--%>
                                        <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
                                            <%--var OK = isc.Dialog.create({--%>
                                                <%--message: "<spring:message code="msg.operation.successful"/>",--%>
                                                <%--icon: "[SKIN]say.png",--%>
                                                <%--title: "<spring:message code="global.form.command.done"/>"--%>
                                            <%--});--%>
                                            <%--setTimeout(function () {--%>
                                                <%--OK.close();--%>
                                            <%--}, 3000);--%>
                                            <%--ListGrid_Skill_Skill_refresh();--%>
                                            <%--Window_Skill_Skill.close();--%>
                                        <%--} else {--%>
                                            <%--var OK = isc.Dialog.create({--%>
                                                <%--message: "<spring:message code="msg.operation.error"/>",--%>
                                                <%--icon: "[SKIN]say.png",--%>
                                                <%--title: "<spring:message code="global.form.command.done"/>"--%>
                                            <%--});--%>
                                            <%--setTimeout(function () {--%>
                                                <%--ERROR.close();--%>
                                            <%--}, 3000);--%>
                                        <%--}--%>

                                    <%--}--%>
                                <%--});--%>
                            <%--}--%>
                        <%--}--%>
                    <%--})--%>

                <%--}--%>
            },
            {
                name: "category.titleFa",
                title: "<spring:message code="group"/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "subCategory.titleFa", title: "<spring:message
        code="subcategory"/>", align: "center", filterOperator: "iContains"
            },
            {
                name: "skillLevel.titleFa", title: "<spring:message
        code="skill.level"/>", align: "center", filterOperator: "iContains"
            },
// {name: "description",title: "<spring:message code="description"/>",align: "center",filterOperator: "iContains"}
        ],
        selectionType: "single",
        selectionUpdated  : function(record) {
            // selectedSkillId = record.id;
            // if(state) {
                let advancedCriteriaJspSkill = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: []
                };
                // ListGrid_Course_JspSkill.fetchData();
                // ListGrid_Course_JspSkill.invalidateCache();
                if (record.course !== undefined) {
                    advancedCriteriaJspSkill.criteria.add({
                        fieldName: "code",
                        operator: "iContains",
                        value: record.course.code
                    });
                // }
                    ListGrid_Course_JspSkill.fetchData(advancedCriteriaJspSkill);
                    ListGrid_Course_JspSkill.invalidateCache();
                 }
                else{
                    ListGrid_Course_JspSkill.fetchData();
                    ListGrid_Course_JspSkill.invalidateCache();
                }
        },
        // selectionChanged: function (record) {
        //     RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skillUrl + "/" + record.id + "/skill-groups";
        //     ListGrid_Skill_Attached_SkillGroups.fetchData();
        //     ListGrid_Skill_Attached_SkillGroups.invalidateCache();
        // },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
// sortFieldAscendingText: "مرتب سازی صعودی ",
// sortFieldDescendingText: "مرتب سازی نزولی",
// configureSortText: "تنظیم مرتب سازی",
// autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
// autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
// filterUsingText: "فیلتر کردن",
// groupByText: "گروه بندی",
// freezeFieldText: "ثابت نگه داشتن",
//         dataArrived: function (startRow, endRow) {
//             record = ListGrid_Skill_Skill.getSelectedRecord();
//             if (record == null) {
//                 RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/skill-group-dummy";
//                 RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/course-dummy";
//                 RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/0/need-assessment";
//                 ListGrid_Skill_Need_Assessment.invalidateCache();
//                 ListGrid_Skill_Need_Assessment.setData([]);
//             } else {
//                 RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
//                 RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/courses";
//                 RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/need-assessment";
//                 ListGrid_Skill_Need_Assessment.invalidateCache();
//                 ListGrid_Skill_Need_Assessment.fetchData();
//                 // selectedSkillId = record.id;
//             }
//             ListGrid_Skill_Attached_SkillGroups.invalidateCache();
//             ListGrid_Skill_Attached_Courses.invalidateCache();
//
//
//         },
    });


    var ToolStripButton_Skill_Skill_Refresh = isc.ToolStripButtonRefresh.create({
        <%--icon: "<spring:url value="refresh.png"/>",--%>
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Skill_Skill_refresh();
        }
    });
    var ToolStripButton_Skill_Skill_Edit = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Skill_Skill_Edit();
        }
    });
    var ToolStripButton_Skill_Skill_Add = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_Skill_Skill_Add();
        }
    });
    var ToolStripButton_Skill_Skill_Remove = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Skill_Skill_Remove();
        }
    });
    var ToolStripButton_Skill_Skill_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            "<spring:url value="/skill/print-all/pdf" var="printUrl"/>"
            <%--console.log('${printUrl}')   ;--%>
            window.open('${printUrl}');
        }
    });
    var ToolStrip_Actions_Skill_Skill = isc.ToolStrip.create({
        width: "100%",
        members: [
             ToolStripButton_Skill_Skill_Add,
             ToolStripButton_Skill_Skill_Edit,
             ToolStripButton_Skill_Skill_Remove,
             ToolStripButton_Skill_Skill_Print,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Skill_Skill_Refresh
                ]
            })
        ]
    });


    // Start Block Add Skill Groups To Skill ---------------------------------------------------------------

    var ToolStripButton_Skill_AddSkillGroup_Select_Single = isc.ToolStripButton.create({
// icon: "pieces/512/right-arrow.png",
        width: 300,
        title: getFormulaMessage(">", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecord = ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord();
                var skillGroupId = skillGroupRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-skill-group/" + skillGroupId + "/" + skillId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("<spring:message code='msg.operation.error'/>");
                        }
                    }
                });


            }

        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Select_Multiple = isc.ToolStripButton.create({

        title: getFormulaMessage(">>", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skilGroupRecords = ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecords();
                var skillGroupIds = new Array();
                for (i = 0; i < skilGroupRecords.getLength(); i++) {
                    skillGroupIds.add(skilGroupRecords[i].id);
                }
                var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-skill-group-list/" + skillId,
                    httpMethod: "POST",
                    data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("<spring:message code='msg.operation.error'/>");
                        }
                    }
                });
            }
        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Deselect_Single = isc.ToolStripButton.create({
// icon: "pieces/512/left-arrow.png",
        title: getFormulaMessage("<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_SkillGroup.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecord = ListGrid_Skill_Selected_SkillGroup.getSelectedRecord();
                var skillGroupId = skillGroupRecord.id;
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-skill-group/" + skillGroupId + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("<spring:message code='msg.operation.error'/>");
                        }
                    }
                });

            }

        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Deselect_Multiple = isc.ToolStripButton.create({

        title: getFormulaMessage("<<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_SkillGroup.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecords = ListGrid_Skill_Selected_SkillGroup.getSelectedRecords();
                var skillGroupIds = new Array();
                for (i = 0; i < skillGroupRecords.getLength(); i++) {
                    skillGroupIds.add(skillGroupRecords[i].id);
                }
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-skill-group-list/" + skillGroupIds + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("<spring:message code='msg.operation.error'/>");
                        }
                    }
                });


            }
        }
    });
    var ToolStrip_Skill_AddSkillGroup = isc.ToolStrip.create({
        height: "100%",
        vertical: true,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [
            ToolStripButton_Skill_AddSkillGroup_Select_Single,
            ToolStripButton_Skill_AddSkillGroup_Deselect_Single,
            ToolStripButton_Skill_AddSkillGroup_Select_Multiple,
            ToolStripButton_Skill_AddSkillGroup_Deselect_Multiple
        ]
    });

    var DynamicForm_Skill_SkillData_Add_SkillGroup = isc.DynamicForm.create({
        titleWidth: 400,
// border:2,
        width: "100%",
        height: "100%",
        align: "right",
        titleAlign: "left",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "<spring:message code="skill.code"/>",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "<spring:message code="title.en"/>",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_SkillGroup = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canReorderRecords: true,
        dataSource: RestDataSource_Skill_UnAttached_SkillGroups,
        showRowNumbers: true,
        autoFetchData: false,
        border: "0px solid green",
        selectionType: "multiple",
        rowNumberFieldProperties: {
// autoFitWidthApproach: "both",
// canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='title.en'/>", align: "center"}
        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var skillGroupRecord = record;
            var skillGroupId = skillGroupRecord.id;
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/add-skill-group/" + skillGroupId + "/" + skillId,
                httpMethod: "POST",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                        ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                    } else {
                        isc.say("<spring:message code='msg.operation.error'/>");
                    }
                }
            });
        },
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_SkillGroup = isc.TrLG.create({
        width: "100%",
        height: "100%",
        selectionType: "multiple",
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_SkillGroups,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        canEdit: false,
        fields: [
// {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='title.en'/>", align: "center"},
            {name: "OnDelete", title: "<spring:message code="remove"/>", align: "center"}

        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var skillGroupRecord = record;
            var skillGroupId = skillGroupRecord.id;

            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/remove-skill-group/" + skillGroupId + "/" + skillId,
                httpMethod: "DELETE",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                    } else {
                        isc.say("<spring:message code='msg.operation.error'/>");
                    }
                }
            });

        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_SkillGroup = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "45%",
        sections: [
            {
                title: "<spring:message code='skill.group.Not.selected'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_UnAttached_SkillGroup
                ]
            }
        ]
    });

    var SectionStack_Skill_Attached_SkillGroup = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "45%",
        sections: [
            {
                title: "<spring:message code='skill.group.selected'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_SkillGroup
                ]
            }
        ]
    });

    var VLayOut_Skill_SkillGroup_Add_Action = isc.VLayout.create({
        width: "10%",
        height: "100%",
        autoDraw: false,
// border: "0px solid red", layoutMargin: 5,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [ToolStrip_Skill_AddSkillGroup
        ]
    });

    var HStack_Skill_AddSkillGroup = isc.HStack.create({
        width: "100%",
        height: "100%",
        members: [
            SectionStack_Skill_UnAttached_SkillGroup,
            VLayOut_Skill_SkillGroup_Add_Action,
            SectionStack_Skill_Attached_SkillGroup
        ]
    });

    var HLayOut_Skill_AddSkillGroup_Header = isc.HLayout.create({
        width: "100%",
        height: 30,
//autoDraw: true,
        autoSize: false,
        border: "0px solid yellow",
        backgroundColor: "lightgray",

        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_SkillGroup
        ]
    });

    var VLayOut_Skill_SkillGroup_Add_Main = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddSkillGroup_Header,
            isc.HLayout.create({
                width: "100%",
                height: 10,
                backgroundColor: "blue",
                autoDraw: false,
                border: "0px solid red", layoutMargin: 5,
                members: []
            }),

            HStack_Skill_AddSkillGroup
        ]
    });

    var Window_Skill_AddSkillGroup = isc.Window.create({
        title: "<spring:message code='relate/delete.relation.skill.skillGroup'/>",
        width: "80%",
        height: "80%",
        autoSize: false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
            Skill_Finish_SkillGroup();
        },
        items: [
            VLayOut_Skill_SkillGroup_Add_Main
        ]
    });

    function Skill_Add_SkillGroup() {

        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.select.skill'/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            RestDataSource_Skill_UnAttached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/unattached-skill-groups";
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
            DynamicForm_Skill_SkillData_Add_SkillGroup.invalidateCache();
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("titleFa", record.titleFa);
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("titleEn", record.titleEn);
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("code", record.code);
            ListGrid_Skill_UnAttached_SkillGroup.fetchData();
            ListGrid_Skill_Selected_SkillGroup.fetchData();
            Window_Skill_AddSkillGroup.show();
        }

    };

    function Skill_Finish_SkillGroup() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null) {
            skill_selectedSkillId = -1;
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/skill-group-dummy";
        } else {
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
            // selectedSkillId = record.id;
        }
        ListGrid_Skill_Attached_SkillGroups.invalidateCache();
    };

    // End Block Add Skill Groups To Skill ---------------------------------------------------------------

    //مشخص نمودن قالب ظاهر فرم
    var HLayout_Action_Skill_Skill = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Skill_Skill]
    });
    var HLayout_Grid_Skill_Skill = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Skill
        ]
    });
    var VLayout_Body_Skill_Skill = isc.VLayout.create({
        showResizeBar: true,
        width: "100%",
        height: "50%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_Skill_Skill, HLayout_Grid_Skill_Skill]
    });

    var VLayout_Action_Skill_SkillGroups = isc.VLayout.create({
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Action_Skill_SkillGroups]
    });

    var HLayout_Skill_Need_Assessment_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Need_Assessment
        ]
    });
    var HLayout_Skill_SkillGroups_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Attached_SkillGroups
        ]
    });

    var HLayout_Tab_Skill_SkillGroups = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_SkillGroups_Grid, VLayout_Action_Skill_SkillGroups
        ]
    });
    var HLayout_Tab_Skill_Need_Assessment = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_Need_Assessment_Grid
        ]
    });

    var ListGrid_Course_JspSkill = isc.TrLG.create({
        dataSource: RestDataSource_Course_JspSkill,
        canAddFormulaFields: true,
        allowAdvancedCriteria: true,
        hoverMoveWithMouse: true,
        showRowNumbers:false,
        selectionAppearance: "checkbox",
        fields: [
            {
                name: "code", title: "<spring:message code="corse_code"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains"
            },
            {
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "category.titleFa", title: "<spring:message
        code="course_category"/>", align: "center", filterOperator: "iContains"
            },
            {
                name: "subCategory.titleFa", title: "<spring:message
        code="course_subcategory"/>", align: "center", filterOperator: "iContains"
            },
            {
                name: "erunType.titleFa",
                title: "<spring:message code="course_eruntype"/>",
                align: "center",
                filterOperator: "iContains",
                allowFilterOperators: false,
                canFilter: false

            },
            {
                name: "elevelType.titleFa", title: "<spring:message
        code="cousre_elevelType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "etheoType.titleFa", title: "<spring:message
        code="course_etheoType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "theoryDuration", title: "<spring:message
                code="course_theoryDuration"/>", align: "center", filterOperator: "iContains",

            },
            {
                name: "etechnicalType.titleFa", title: "<spring:message
                 code="course_etechnicalType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "minTeacherDegree", title: "<spring:message
        code="course_minTeacherDegree"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            {
                name: "minTeacherExpYears", title: "<spring:message
        code="course_minTeacherExpYears"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            {
                name: "minTeacherEvalScore", title: "<spring:message
        code="course_minTeacherEvalScore"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            // {
            //     name: "knowledge",
            //     title: "دانشی",
            //     align: "center",
            //     filterOperator: "greaterThan",
            //     format: "%",
            //     width: "50"
            //     // formatCellValue: function (value, record) {
            //     //     // if (!isc.isA.Number(record.gdp) || !isc.isA.Number(record.population)) return "N/A";
            //     //     var gdpPerCapita = Math.round(record.theoryDuration/10);
            //     //     return isc.NumberUtil.format(gdpPerCapita, "%");
            //     // }
            // },
            // {name: "skill", title: "مهارتی", align: "center", filterOperator: "greaterThan", format: "%", width: "50"},
            // {
            //     name: "attitude",
            //     title: "نگرشی",
            //     align: "center",
            //     filterOperator: "greaterThan",
            //     format: "%",
            //     width: "50"
            // },
            {name: "needText", title: "شرح", hidden: true},
            {name: "description", title: "توضیحات", hidden: true},
            {
                name: "workflowStatus",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains"
            },
            {
                name: "behavioralLevel", title: "سطح رفتاری",
                // hidden:true,
                valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای"
                }
            },
            {
                name: "evaluation", title: "<spring:message code="evaluation.level"/>",
                valueMap: {
                    "1": "واکنش",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
            },
            {
                name: "workflowStatusCode",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
                hidden: true
            },
            {name: "hasGoal", type: "boolean", title: "بدون هدف", hidden: true, canFilter: false},
            {name: "hasSkill", type: "boolean", title: "بدون مهارت", hidden: true, canFilter: false}
            // {name: "version", title: "version", canEdit: false, hidden: true},
            // {name: "goalSet", hidden: true}
        ],
        autoFetchData: false,
        selectionType: "single",
        showFilterEditor: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        getCellCSSText: function (record, rowNum, colNum) {
            // if (record.attitude==0 && record.knowledge==0 && record.skill==0) {
            if (record.hasGoal && record.hasSkill) {
                return "color:red;font-size: 12px;";
            }
            if (record.hasGoal) {
                return "color:tan; font-size: 12px;";
            }
            if (record.hasSkill) {
                return "color:orange;font-size: 12px;";
            }
        },
        selectionUpdated: function (record, recordList) {
            if(ListGrid_Skill_Skill.getSelectedRecord() == null || ListGrid_Skill_Skill.getSelectedRecord() == undefined){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return
            }
            else if(ListGrid_Skill_Skill.getSelectedRecord().course !== undefined) {
                if (record.code === ListGrid_Skill_Skill.getSelectedRecord().course.code) {
                    return;
                }
            }
            isc.MyYesNoDialog.create({
                    message:"آیا از انتصاب دوره " + ListGrid_Course_JspSkill.getSelectedRecord().titleFa + " به مهارت " + ListGrid_Skill_Skill.getSelectedRecord().titleFa + " اطمینان دارید؟ ",
                    buttonClick: function (button, index) {
                        this.close();
                        if(index == 0){
                            let data = ListGrid_Skill_Skill.getSelectedRecord();
                            data.courseId = record.id;
                            isc.RPCManager.sendRequest({
                                actionURL: skillUrl +"/"+ ListGrid_Skill_Skill.getSelectedRecord().id,
                                httpMethod: "PUT",
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                showPrompt: false,
                                data: JSON.stringify(data),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                                            "<spring:message code="msg.command.done"/>");
                                        ListGrid_Skill_Skill_refresh();
                                        setTimeout(function () {
                                            var responseID = JSON.parse(resp.data).id;
                                            var gridState = "[{id:" + responseID + "}]";
                                            ListGrid_Skill_Skill.setSelectedState(gridState);
                                            OK.close();
                                        }, 1000);
                                    } else {
                                        createDialog("info", "<spring:message code='error'/>");
                                    }
                                }
                            });
                        };
                        ListGrid_Course_JspSkill.deselectRecord(record);
                    }
                })
        }
    });
    var Detail_Tab_Skill = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                // id: "TabPane_Skill_Course",
                title: "<spring:message code='course'/>",
                pane: ListGrid_Course_JspSkill
            },
            {
                id: "TabPane_Skill_SkillGroup",
                title: "<spring:message code='list.skill.group'/>",
                pane: HLayout_Tab_Skill_SkillGroups

            },
            <%--{--%>
                <%--title: "<spring:message code='list.need.Assesment'/>",--%>
                <%--pane: HLayout_Tab_Skill_Need_Assessment--%>
            <%--},--%>
        ]
    });

    var VLayout_Tab_Skill = isc.VLayout.create({
        width: "100%",
        height: "50%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Skill]
    });

    var VLayout_Skill_Body_All = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_Skill_Skill, VLayout_Tab_Skill]
    });
