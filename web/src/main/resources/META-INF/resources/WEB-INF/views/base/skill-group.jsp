<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var RestDataSource_Skill_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام گروه مهارت", align: "center", filterOperator: "contains"},
            {name: "titleEn", title: "نام لاتین گروه مهارت ", align: "center", filterOperator: "contains"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        fetchDataURL: skillGroupUrl + "spec-list"
    });
    var Menu_ListGrid_Skill_Group_Jsp = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Skill_Group_refresh();
            }
        }, {
            title: " ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Skill_Group_add();
            }
        }, {
            title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
// alert(ListGrid_Skill_Group_Competence.getData().size());
                ListGrid_Skill_Group_edit();
            }
        }, {
            title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {


                var skillGrouprecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();
                if (skillGrouprecord == null || skillGrouprecord.id == null) {

                    simpleDialog("پیغام", "گروه مهارتی انتخاب نشده است.", 0, "stop");

                } else {



                    isc.RPCManager.sendRequest({
                        actionURL: skillGroupUrl + skillGrouprecord.id + "/canDelete",
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
// data: JSON.stringify(data1),
                        serverOutputAsString: false,
                        callback: function (resp) {

                            if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                if (resp.data == "true") {

                                    ListGrid_Skill_Group_remove();

                                } else {
                                    msg = " گروه مهارت " + getFormulaMessage(skillGrouprecord.titleFa, "2", "red", "B") + " بدلیل مرتبط بودن با شایستگی قابل حذف نمی باشد ";
                                    simpleDialog("خطا در حذف", msg, 0, "stop");
                                }
                            }

                        }
                    });
                }


            }
        }, {isSeparator: true},
            {title:"<spring:message code="print.SelectedRecords"/>", icon: "<spring:url value="print.png"/>",submenu:[
            {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",
                        click: function () {
                            var strSkillrecords="";
                            var selectedSkillGroup=new Array();
                            var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                            for(i=0;i<selectedSkillGroup.length;i++)
                                if(i==0)
                                    strSkillrecords+=selectedSkillGroup[i].id;
                                else
                                    strSkillrecords+=","+selectedSkillGroup[i].id

                            if(strSkillrecords==""){
                                isc.Dialog.create({

                                    message:"<spring:message code="msg.skillGroup.notFound"/>",
                                    icon:"[SKIN]ask.png",
                                    title: "پیام",
                                    buttons: [isc.Button.create({title: "تائید"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });

                            }
                            else{


                                "<spring:url value="/skill-group/printSelected/pdf/" var="printUrl"/>"
                                window.open('${printUrl}'+strSkillrecords);
                            }

                        }},
                    {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",
                        click: function () {
                            var strSkillrecords="";
                            var selectedSkillGroup=new Array();
                            var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                            for(i=0;i<selectedSkillGroup.length;i++)
                                if(i==0)
                                    strSkillrecords+=selectedSkillGroup[i].id;
                                else
                                    strSkillrecords+=","+selectedSkillGroup[i].id

                            if(strSkillrecords==""){
                                isc.Dialog.create({

                                    message: "<spring:message code="msg.skillGroup.notFound"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "پیام",
                                    buttons: [isc.Button.create({title: "تائید"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });

                            }
                            else{


                                "<spring:url value="/skill-group/printSelected/excel/" var="printUrl"/>"
                                window.open('${printUrl}'+strSkillrecords);
                            }

                        }},
                    {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",
                        click: function () {
                            var strSkillrecords="";
                            var selectedSkillGroup=new Array();
                            var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                            for(i=0;i<selectedSkillGroup.length;i++)
                                if(i==0)
                                    strSkillrecords+=selectedSkillGroup[i].id;
                                else
                                    strSkillrecords+=","+selectedSkillGroup[i].id

                            if(strSkillrecords==""){
                                isc.Dialog.create({

                                    message: "<spring:message code="msg.skillGroup.notFound"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "پیام",
                                    buttons: [isc.Button.create({title: "تائید"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });

                            }
                            else{


                                "<spring:url value="/skill-group/printSelected/html/" var="printUrl"/>"
                                window.open('${printUrl}'+strSkillrecords);
                            }

                        }}
                ]}, {
            title: "چاپ همه گروه مهارت ها", icon: "<spring:url value="pdf.png"/>", click: function () {
                "<spring:url value="/skill-group/print/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "چاپ همه با جزئیات", icon: "<spring:url value="pdf.png"/>", click: function () {
                "<spring:url value="/skill-group/printAll/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {isSeparator: true}, {
            title: "حذف گروه مهارت از تمام شایستگی ها", icon: "<spring:url value="remove.png"/>", click: function () {
                var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();


                if (record == null || record.id == null) {

                    isc.Dialog.create({

                        message: "<spring:message code="msg.skillGroup.notFound"/>",
                        icon: "[SKIN]ask.png",
                        title: "پیام",
                        buttons: [isc.Button.create({title: "تائید"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                } else {


                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" از  کلیه شایستگی هایش ", "2", "black", "c") + getFormulaMessage("  مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه مهارت:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deleteSkillGroupFromAllCompetence(record.id);
                                simpleDialog("پیغام", "حذف با موفقیت انجام گردید.", 0, "confirm");
                            }
                        }
                    });


                   // ListGrid_Skill_Group_Competence.invalidateCache();

                }
            }
        },
            {isSeparator: true}, {
                title: "لیست مهارت ها", icon: "<spring:url value="skill.png"/>", click: function () {
                    var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();


                    if (record == null || record.id == null) {

                        isc.Dialog.create({

                            message: "<spring:message code="msg.skillGroup.notFound"/>",
                            icon: "[SKIN]ask.png",
                            title: "پیام",
                            buttons: [isc.Button.create({title: "تائید"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                    } else {

                        // alert(record.id);
                        RestDataSource_All_Skills.fetchDataURL = skillGroupUrl + record.id + "/unAttachSkills";
                        RestDataSource_All_Skills.invalidateCache();
                        RestDataSource_All_Skills.fetchData();
                        ListGrid_AllSkills.invalidateCache();
                        ListGrid_AllSkills.fetchData();


                        RestDataSource_ForThisSkillGroup_GetSkills.fetchDataURL = skillGroupUrl + record.id + "/getSkills"
                        RestDataSource_ForThisSkillGroup_GetSkills.invalidateCache();
                        RestDataSource_ForThisSkillGroup_GetSkills.fetchData();
                        ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
                        ListGrid_ForThisSkillGroup_GetSkills.fetchData();
                        DynamicForm_thisSkillGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                        Window_Add_Skill_to_SkillGroup.show();
                    }
                }
            }
        ]
    });



    var ListGrid_Skill_Group_Jsp = isc.TrLG.create({
        color: "red",
        selectionType:"multiple",
        dataSource: RestDataSource_Skill_Group_Jsp,
        contextMenu: Menu_ListGrid_Skill_Group_Jsp,
        selectionChange: function (record, state) {
            record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
            if (record == null || record.id == null) {
            } else {
                // RestDataSource_Skill_Group_Competencies_Jsp.fetchDataURL = skillGroupUrl + record.id + "/getCompetences"
                RestDataSource_Skill_Group_Skills_Jsp.fetchDataURL = skillGroupUrl + record.id + "/getSkills"
                ListGrid_Skill_Group_Skills.invalidateCache();
                ListGrid_Skill_Group_Skills.fetchData();
                // RestDataSource_Skill_Group_Competencies_Jsp.invalidateCache();
                // RestDataSource_Skill_Group_Competencies_Jsp.fetchData();
                RestDataSource_Skill_Group_Skills_Jsp.invalidateCache();
                RestDataSource_Skill_Group_Skills_Jsp.fetchData();
                // ListGrid_Skill_Group_Competence.invalidateCache();
                // ListGrid_Skill_Group_Competence.fetchData();
            }
        },
        doubleClick: function () {
            ListGrid_Skill_Group_edit();
        },
        sortField: 1,
        autoFetchData: true,
    });



    var method = "POST";

    var Menu_ListGrid_Skill_Group_Competences = isc.Menu.create({
            width: 150,
            data: [{
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Skill_Group_Competence_refresh();
                }
            }, {
                title: " حذف گروه مهارت از  شایستگی مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                    activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
                    activeCompetence = ListGrid_Skill_Group_Competence.getSelectedRecord();
                    if (activeSkillGroup == null || activeCompetence == null) {
                        simpleDialog("پیام", "شایستگی یا گروه مهارت انتخاب نشده است.", 0, "confirm");

                    } else {
                        var Dialog_Delete = isc.Dialog.create({
                            message: getFormulaMessage("آیا از حذف  گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(activeSkillGroup.titleFa, "3", "red", "U") + getFormulaMessage(" از  شایستگی:' ", "2", "black", "c") + getFormulaMessage(activeCompetence.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه مهارت:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                            icon: "[SKIN]ask.png",
                            title: "تائید حذف",
                            buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                                title: "خیر"
                            })],
                            buttonClick: function (button, index) {
                                this.close();

                                if (index == 0) {
                                    deleteCompetenceFromSkillGroup(activeCompetence.id, activeSkillGroup.id);
                                }
                            }
                        });

                    }
                }
            },

            ]
        });

    var Menu_ListGrid_Skill_Group_Skills = isc.Menu.create({
            width: 150,
            data: [{
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Skill_Group_Skills_refresh();
                }
            }, {
                title: " حذف مهارت از گروه مهارت مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                    activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
                    activeSkill = ListGrid_Skill_Group_Skills.getSelectedRecord();
                    if (activeSkillGroup == null || activeSkill == null) {
                        simpleDialog("پیام", "مهارت یا گروه مهارت انتخاب نشده است.", 0, "confirm");

                    } else {
                        var Dialog_Delete = isc.Dialog.create({
                            message: getFormulaMessage("آیا از حذف  مهارت:' ", "2", "black", "c") + getFormulaMessage(activeSkill.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(activeSkillGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه مهارت:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                            icon: "[SKIN]ask.png",
                            title: "تائید حذف",
                            buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                                title: "خیر"
                            })],
                            buttonClick: function (button, index) {
                                this.close();

                                if (index == 0) {
                                    deleteSkillFromSkillGroup(activeSkill.id, activeSkillGroup.id);
                                }
                            }
                        });

                    }
                }
            },

            ]
        });

    function ListGrid_Skill_Group_Skills_refresh() {

        if (ListGrid_Skill_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Skill_Group_Skills.setData([]);
        else
            ListGrid_Skill_Group_Skills.invalidateCache();
    }

    function ListGrid_Skill_Group_Competence_refresh() {

        if (ListGrid_Skill_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Skill_Group_Competence.setData([]);
        else
            ListGrid_Skill_Group_Competence.invalidateCache();
    }

    var RestDataSource_Skill_Group_Skills_Jsp = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        // ,fetchDataURL:"${restApiUrl}/api/skill-group/1/getSkills"
    });

    var RestDataSource_All_Skills = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        , fetchDataURL: skillGroupUrl + "spec-list"
    });

    var RestDataSource_ForThisSkillGroup_GetSkills = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        //,fetchDataURL:"${restApiUrl}/api/skill-group/1/getSkills"
    });

    var DynamicForm_thisSkillGroupHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        autoDraw: false,


        fields: [

            {
                name: "sgTitle",
                type: "staticText",
                title: "افزودن مهارت به گروه مهارت:",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_AllSkills = isc.ListGrid.create({
        //title:"تمام مهارت ها",
        width: "100%",
        height: "100%", canDragResize: true,

        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        autoFetchData: false,
        dataSource: RestDataSource_All_Skills,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد مهارت", align: "center", width: "20%"},
            {name: "titleFa", title: "نام مهارت", align: "center", width: "60%"},
            {name: "titleEn", title: "نام لاتین مهارت", align: "center", hidden: true},
            {name: "description", title: "توضیحات", align: "center", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        showFilterEditor: true,
        filterOnKeypress: true,
        dragTrackerMode: "title",
        canDrag: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",


        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

            // var activeSkill = record;
            // var activeSkillId = activeSkill.id;
            // var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
            // var activeSkillGroupId = activeSkillGroup.id;

            var skillGroupRecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();
            var skillGroupId = skillGroupRecord.id;
            //  alert(skillGroupId);
            // var skillId=dropRecords[0].id;
            var skillIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                skillIds.add(dropRecords[i].id);
            }
            ;

            //  alert("${restApiUrl}/api/skill-group/addSkills/"+skillGroupId+"/"+skillIds);

            var JSONObj = {"ids": skillIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skillGroupUrl + "removeSkills/" + skillGroupId + "/" + skillIds,
                httpMethod: "DELETE",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
                        ListGrid_AllSkills.invalidateCache();


                    } else {
                        isc.say("خطا");
                    }
                }
            });
        }

    });

    var ListGrid_ForThisSkillGroup_GetSkills = isc.ListGrid.create({
        //title:"تمام مهارت ها",
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        //showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,

        dataSource: RestDataSource_ForThisSkillGroup_GetSkills,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد مهارت", align: "center", width: "20%"},
            {name: "titleFa", title: "نام مهارت", align: "center", width: "70%"},
            {name: "OnDelete", title: "حذف", align: "center"}
        ],

        //--------------------------------------------


        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    prompt: "remove",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {

                        var activeSkill = record;
                        var activeSkillId = activeSkill.id;
                        var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
                        var activeSkillGroupId = activeSkillGroup.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: skillGroupUrl + "removeSkill/" + activeSkillGroupId + "/" + activeSkillId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                    // RestDataSource_ForThisSkillGroup_GetSkills.removeRecord(activeSkill);
                                    ListGrid_AllSkills.invalidateCache();
                                    ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },


        //----------------------------------------------------


        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

            // alert(dropRecords[0].titleFa);


            var skillGroupRecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();
            var skillGroupId = skillGroupRecord.id;
            //  alert(skillGroupId);
            // var skillId=dropRecords[0].id;
            var skillIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                skillIds.add(dropRecords[i].id);
            }
            ;
            var JSONObj = {"ids": skillIds};


            TrDSRequest()


            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skillGroupUrl + "addSkills/" + skillGroupId + "/" + skillIds, //"${restApiUrl}/api/tclass/addStudents/" + ClassID,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
                        ListGrid_AllSkills.invalidateCache();

                        // var OK = isc.Dialog.create({
                        //     message: "عملیات با موفقیت انجام شد",
                        //     icon: "[SKIN]say.png",
                        //     title: "پیام موفقیت"
                        // });
                        // setTimeout(function () {
                        //     // OK.close();
                        // }, 3000);
                    } else {
                        isc.say("خطا");
                    }
                }
            });
        },

        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"


    });

    var SectionStack_All_Skills_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست مهارت ها",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_AllSkills
                ]
            }
        ]
    });

    var SectionStack_Current_Skill_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست مهارت های این گروه مهارت",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_ForThisSkillGroup_GetSkills
                ]
            }
        ]
    });

    var HStack_thisSkillGroup_AddSkill_Jsp = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Skills_Jsp,
            SectionStack_Current_Skill_JspClass
        ]
    });

    var HLayOut_thisSkillGroup_AddSkill_Jsp = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",

        members: [
            DynamicForm_thisSkillGroupHeader_Jsp
        ]
    });

    var VLayOut_SkillGroup_Skills_Jsp = isc.VLayout.create({
        width: "100%",
        height: "300",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [
            HLayOut_thisSkillGroup_AddSkill_Jsp,
            HStack_thisSkillGroup_AddSkill_Jsp
        ]
    });

    var Window_Add_Skill_to_SkillGroup = isc.Window.create({
        title: "لیست مهارت ها",
        width: "900",
        height: "400",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,

        closeClick: function () {
            ListGrid_Skill_Group_Competence.invalidateCache();
            ListGrid_Skill_Group_Skills.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_SkillGroup_Skills_Jsp
        ]
    });

    var RestDataSource_Skill_Group_Competencies_Jsp = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        //,fetchDataURL:"${restApiUrl}/api/skill-group/?/getCompetences"
    });

    var ListGrid_Skill_Group_Skills = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showResizeBars: true,
        filterOnKeypress: true,
        dataSource: RestDataSource_Skill_Group_Skills_Jsp,
        contextMenu: Menu_ListGrid_Skill_Group_Skills,
        doubleClick: function () {
            //    ListGrid_Skill_Group_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام مهارت", align: "center", filterOperator: "contains"},
            {name: "titleEn", title: "نام لاتین مهارت ", align: "center", filterOperator: "contains"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var ListGrid_Skill_Group_Competence = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        showResizeBars: true,
        dataSource: RestDataSource_Skill_Group_Competencies_Jsp,
        contextMenu: Menu_ListGrid_Skill_Group_Competences,
        doubleClick: function () {
            //    ListGrid_Skill_Group_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام شایستگی", align: "center"},
            {name: "titleEn", title: "نام لاتین شایستگی ", align: "center"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    function ListGrid_Skill_Group_edit() {
        var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {

            simpleDialog("پیغام", "گروه مهارتی انتخاب نشده است.", 0, "say");

        } else {
            DynamicForm_Skill_Group_Jsp.clearValues();
            method = "PUT";
            url = skillGroupUrl + record.id;
            DynamicForm_Skill_Group_Jsp.editRecord(record);

            Window_Skill_Group_Jsp.show();
        }
    };

    function ListGrid_Skill_Group_remove() {


        var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
        if (record == null) {
            //	isc.Dialog.create({

            simpleDialog("پیغام", "گروه مهارتی انتخاب نشده است.", 0, "ask");


        } else {


            //  str=getFormulaMessage("گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' در شایستگی ها استفاده شده و حق حذف آن را ندارید.", "2 ", "black", "c")


            var Dialog_Delete = isc.Dialog.create({
                message: getFormulaMessage("آیا از حذف گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه مهارت:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="verify.delete"/>",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                    title: "خیر"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "در حال انجام عملیات...",
                            icon: "[SKIN]say.png",
                            title: "پیام"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: skillGroupUrl + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Skill_Group_Jsp.invalidateCache();
                                    simpleDialog("انجام فرمان", "حذف با موفقیت انجام شد", 2000, "say");
                                    ListGrid_Skill_Group_Skills.setData([]);
                                    ListGrid_Skill_Group_Competence.setData([]);

                                } else {
                                    simpleDialog("پیام خطا", "حذف با خطا مواجه شد", 2000, "stop");

                                }
                            }
                        });
                    }
                }
            });


        }
    };

    function ListGrid_Skill_Group_refresh() {
        ListGrid_Skill_Group_Jsp.invalidateCache();
        ListGrid_Skill_Group_Skills_refresh();
        ListGrid_Skill_Group_Competence_refresh();


    };

    function ListGrid_Skill_Group_add() {
        method = "POST";
        url = skillGroupUrl;
        DynamicForm_Skill_Group_Jsp.clearValues();
        Window_Skill_Group_Jsp.show();
    };

    var DynamicForm_Skill_Group_Jsp = isc.DynamicForm.create({
        width: "750",
        height: "150",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        validateOnExit: true,
        numCols: 2,
        wrapTitle: false,
        colWidths: [140, "*"],
        margin: 10,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام گروه مهارت",
                type: "text",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar,TrValidators.NotStartWithNumber],
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "250",
                width: "*",
                height: "40"
            },
            {
                name: "titleEn",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "نام لاتین گروه مهارت ",
                hint: "English/انگلیسی",
                showHintInField: true,
                keyPressFilter: "[a-z|A-Z|0-9 |]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar,TrValidators.NotStartWithNumber],
            },
            {
                name: "description",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "توضیحات",
                hint: "توضیحات",
                showHintInField: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar,TrValidators.NotStartWithNumber],
            }
        ]
    });

    var IButton_Skill_Group_Exit_Jsp = isc.IButton.create({
        top: 260, title: "لغو", icon: "<spring:url value="remove.png"/>", align: "center",
        click: function () {
            Window_Skill_Group_Jsp.close();
        }
    });

    var IButton_Skill_Group_Save_Jsp = isc.IButton.create({
        top: 260, title: "ذخیره", icon: "pieces/16/save.png", align: "center", click: function () {

            DynamicForm_Skill_Group_Jsp.validate();
            if (DynamicForm_Skill_Group_Jsp.hasErrors()) {
                return;
            }
            var data = DynamicForm_Skill_Group_Jsp.getValues();

            isc.RPCManager.sendRequest({
                actionURL: url,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
                            message: "عملیات با موفقیت انجام شد.",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Skill_Group_refresh();
                        Window_Skill_Group_Jsp.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });
        }
    });

    var HLayOut_Skill_GroupSaveOrExit_Jsp = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "700",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Skill_Group_Save_Jsp, IButton_Skill_Group_Exit_Jsp]
    });

    var Window_Skill_Group_Jsp = isc.Window.create({
        title: " گروه مهارت ",
        width: 700,
        height: 200,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Skill_Group_Jsp, HLayOut_Skill_GroupSaveOrExit_Jsp]
        })]
    });

    function deleteSkillFromSkillGroup(skillId, skillGroupId) {

        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: skillGroupUrl + "removeSkill/" + skillGroupId + "/" + skillId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Skill_Group_Skills.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    };

    function deleteCompetenceFromSkillGroup(competenceId, skillGroupId) {
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: skillGroupUrl + "removeCompetence/" + skillGroupId + "/" + competenceId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Skill_Group_Competence.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    };

    function deleteSkillGroupFromAllCompetence(skillGroupId) {


        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: skillGroupUrl + "removeAllCompetence/" + skillGroupId + "/",
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Skill_Group_Competence.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    };

    var ToolStripButton_Refresh_Skill_Group_Jsp = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            //  var xx;
            //  yesNoDialog("taeed","salam???",0,"stop",xx);
            //
            // if(parseInt(xx)==0){
            //     alert("yes selected");
            // }
            // else{
            //     alert("noSelected");
            //     }

// alert("abcdef");

            ListGrid_Skill_Group_refresh();
            //ListGrid_Skill_Group_Competence_refresh();
            //ListGrid_Skill_Group_Skills_refresh();
        }
    });

    var ToolStripButton_Edit_Skill_Group_Jsp = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {

            ListGrid_Skill_Group_edit();
        }
    });

    var ToolStripButton_Add_Skill_Group_Jsp = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {

            ListGrid_Skill_Group_add();
        }
    });

    var ToolStripButton_Remove_Skill_Group_Jsp = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            var activeSkillGrouprecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();

            if (activeSkillGrouprecord == null || activeSkillGrouprecord.id == null) {


                simpleDialog("پیغام", "گروه مهارتی انتخاب نشده است.", 0, "stop");

            } else {


                isc.RPCManager.sendRequest({
                    actionURL: skillGroupUrl + activeSkillGrouprecord.id + "/canDelete",
                    httpMethod: "GET",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
// data: JSON.stringify(data1),
                    serverOutputAsString: false,
                    callback: function (resp) {

                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                            if (resp.data == "true") {

                                ListGrid_Skill_Group_remove();

                            } else {
                                msg = " گروه مهارت " + getFormulaMessage(activeSkillGrouprecord.titleFa, "2", "red", "B") + " بدلیل مرتبط بودن با شایستگی قابل حذف نمی باشد ";
                                simpleDialog("خطا در حذف", msg, 0, "stop");
                            }
                        }

                    }
                });
            }

        }
    });


    <%--var ToolStripButton_PrintAll_Skill_Group_Jsp = isc.ToolStripButton.create({--%>
    <%--    icon: "[SKIN]/RichTextEditor/print.png",--%>
    <%--    title: "چاپ با جزییات",--%>
    <%--    click: function () {--%>
    <%--        "<spring:url value="/skill-group/printAll/pdf" var="printUrl"/>"--%>
    <%--        window.open('${printUrl}');--%>

    <%--    }--%>
    <%--});--%>


    <%--var ToolStripButton_Print_selected_Skill_Group = isc.ToolStripButton.create({--%>
    <%--    icon: "[SKIN]/RichTextEditor/print.png",--%>
    <%--    title: "چاپ گروه مهارت انتخاب شده",--%>
    <%--    click: function () {--%>



    <%--        var strSkillrecords="";--%>
    <%--        var selectedSkillGroup=new Array();--%>
    <%--        var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();--%>
    <%--        for(i=0;i<selectedSkillGroup.length;i++)--%>
    <%--            if(i==0)--%>
    <%--            strSkillrecords+=selectedSkillGroup[i].id;--%>
    <%--        else--%>
    <%--                strSkillrecords+=","+selectedSkillGroup[i].id--%>

    <%--        if(strSkillrecords==""){--%>
    <%--            isc.Dialog.create({--%>

    <%--                message: "گروه مهارتی انتخاب نشده است",--%>
    <%--                icon: "[SKIN]ask.png",--%>
    <%--                title: "پیام",--%>
    <%--                buttons: [isc.Button.create({title: "تائید"})],--%>
    <%--                buttonClick: function (button, index) {--%>
    <%--                    this.close();--%>
    <%--                }--%>
    <%--            });--%>

    <%--        }--%>
    <%--        else{--%>


    <%--        "<spring:url value="/skill-group/printSelected/pdf/" var="printUrl"/>"--%>
    <%--        window.open('${printUrl}'+strSkillrecords);--%>
    <%--        }--%>

    <%--    }--%>
    <%--});--%>

    var ToolStripButton_Print_Skill_Group_Jsp = isc.TrPrintBtn.create({
       // icon: "[SKIN]/RichTextEditor/print.png",
       // title: "چاپ",




        <%--click: function () {--%>
        <%--    "<spring:url value="/skill-group/print/pdf" var="printUrl"/>"--%>
        <%--    window.open('${printUrl}');--%>

        <%--}--%>


        menu: isc.Menu.create({
            data: [
                {title: "<spring:message code="print"/>", icon: "<spring:url value="print.png"/>" , submenu:[
                        {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>" ,  click: function () {
                                "<spring:url value="/skill-group/print/pdf" var="printUrl"/>"
                                window.open('${printUrl}');

                            }},
                        {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>" ,  click: function () {
                                "<spring:url value="/skill-group/print/excel" var="printUrl"/>"
                                window.open('${printUrl}');

                            }},
                        {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>" ,  click: function () {
                                "<spring:url value="/skill-group/print/html" var="printUrl"/>"
                                window.open('${printUrl}');

                            }}

                    ]},
                {title:"<spring:message code="print.Detail"/>", icon: "<spring:url value="print.png"/>", submenu:[
                        {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",click: function () {
                                "<spring:url value="/skill-group/printAll/pdf" var="printUrl"/>"
                                window.open('${printUrl}');

                            }},
                        {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",click: function () {
                                "<spring:url value="/skill-group/printAll/excel" var="printUrl"/>"
                                window.open('${printUrl}');

                            }},
                        {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",click: function () {
                                "<spring:url value="/skill-group/printAll/html" var="printUrl"/>"
                                window.open('${printUrl}');

                            }}
                    ]},
                {title:"<spring:message code="print.SelectedRecords"/>", icon: "<spring:url value="print.png"/>", submenu:[
                        {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",
                            click: function () {
                                var strSkillrecords="";
                                var selectedSkillGroup=new Array();
                                var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                                for(i=0;i<selectedSkillGroup.length;i++)
                                    if(i==0)
                                        strSkillrecords+=selectedSkillGroup[i].id;
                                    else
                                        strSkillrecords+=","+selectedSkillGroup[i].id

                                if(strSkillrecords==""){
                                    isc.Dialog.create({

                                        message: "<spring:message code="msg.skillGroup.notFound"/>",
                                        icon: "[SKIN]ask.png",
                                        title: "پیام",
                                        buttons: [isc.Button.create({title: "تائید"})],
                                        buttonClick: function (button, index) {
                                            this.close();
                                        }
                                    });

                                }
                                else{


                                    "<spring:url value="/skill-group/printSelected/pdf/" var="printUrl"/>"
                                    window.open('${printUrl}'+strSkillrecords);
                                }

                            }},
                        {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",
                            click: function () {
                                var strSkillrecords="";
                                var selectedSkillGroup=new Array();
                                var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                                for(i=0;i<selectedSkillGroup.length;i++)
                                    if(i==0)
                                        strSkillrecords+=selectedSkillGroup[i].id;
                                    else
                                        strSkillrecords+=","+selectedSkillGroup[i].id

                                if(strSkillrecords==""){
                                    isc.Dialog.create({

                                        message: "<spring:message code="msg.skillGroup.notFound"/>",
                                        icon: "[SKIN]ask.png",
                                        title: "پیام",
                                        buttons: [isc.Button.create({title: "تائید"})],
                                        buttonClick: function (button, index) {
                                            this.close();
                                        }
                                    });

                                }
                                else{


                                    "<spring:url value="/skill-group/printSelected/excel/" var="printUrl"/>"
                                    window.open('${printUrl}'+strSkillrecords);
                                }

                            }},
                        {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",
                            click: function () {
                                var strSkillrecords="";
                                var selectedSkillGroup=new Array();
                                var selectedSkillGroup=ListGrid_Skill_Group_Jsp.getSelectedRecords();
                                for(i=0;i<selectedSkillGroup.length;i++)
                                    if(i==0)
                                        strSkillrecords+=selectedSkillGroup[i].id;
                                    else
                                        strSkillrecords+=","+selectedSkillGroup[i].id

                                if(strSkillrecords==""){
                                    isc.Dialog.create({

                                        message: "<spring:message code="msg.skillGroup.notFound"/>",
                                        icon: "[SKIN]ask.png",
                                        title: "پیام",
                                        buttons: [isc.Button.create({title: "تائید"})],
                                        buttonClick: function (button, index) {
                                            this.close();
                                        }
                                    });

                                }
                                else{


                                    "<spring:url value="/skill-group/printSelected/html/" var="printUrl"/>"
                                    window.open('${printUrl}'+strSkillrecords);
                                }

                            }}
                    ]}
            ]
        })
    });
    var ToolStripButton_Add_Skill_Group_AddSkill_Jsp = isc.ToolStripButton.create({
        icon: "<spring:url value="skill.png"/>",
        title: "لیست مهارت ها",
        click: function () {
            var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
            //  alert(Window_Add_Skill_to_SkillGroup.DynamicForm[0].fields[0]);
            // alert(DynamicForm_thisSkillGroupHeader_Jsp.getItem("titleFa"));

            if (record == null || record.id == null) {


                isc.Dialog.create({

                    message: "<spring:message code="msg.skillGroup.notFound"/>",
                    icon: "[SKIN]ask.png",
                    title: "پیام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {


                RestDataSource_All_Skills.fetchDataURL = skillGroupUrl + record.id + "/unAttachSkills";
                RestDataSource_All_Skills.invalidateCache();
                RestDataSource_All_Skills.fetchData();
                ListGrid_AllSkills.invalidateCache();
                ListGrid_AllSkills.fetchData();


                RestDataSource_ForThisSkillGroup_GetSkills.fetchDataURL = skillGroupUrl + record.id + "/getSkills"
                RestDataSource_ForThisSkillGroup_GetSkills.invalidateCache();
                RestDataSource_ForThisSkillGroup_GetSkills.fetchData();
                ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
                ListGrid_ForThisSkillGroup_GetSkills.fetchData();
                DynamicForm_thisSkillGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Skill_to_SkillGroup.show();


                //Window_Add_Skill_to_SkillGroup.
                //   Window_Add_Skill_to_SkillGroup.show();

            }
        }
    });

    var ToolStrip_Actions_Skill_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh_Skill_Group_Jsp,
            ToolStripButton_Add_Skill_Group_Jsp,
            ToolStripButton_Edit_Skill_Group_Jsp,
            ToolStripButton_Remove_Skill_Group_Jsp,
            ToolStripButton_Print_Skill_Group_Jsp,
            ToolStripButton_Add_Skill_Group_AddSkill_Jsp]
    });


    var HLayout_Actions_Skill_Group_Jsp = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Skill_Group_Jsp]
    });


    var Detail_Tab_Skill_Group = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Skill_Group_Skill",
                title: "لیست مهارت ها",
                pane: ListGrid_Skill_Group_Skills

            }
            ,{
                id: "TabPane_Skill_Group_Competence",
                title: "لیست شایستگی ها",
                visable:false,
                pane: ListGrid_Skill_Group_Competence
            }
            // ,{
            //     id: "TabPane_Skill_Group_Competence",
            //     title: "لیست پستهای این گروه مهارت",
            //     visable:false,
            //     pane: ListGrid_Skill_Group_Competence
            // }
        ]
    });


    var HLayout_Tab_Skill_Group = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Skill_Group]
    });


    var HLayout_Grid_Skill_Group_Jsp = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Skill_Group_Jsp]
    });
    var VLayout_Body_Skill_Group_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Skill_Group_Jsp
            , HLayout_Grid_Skill_Group_Jsp
            , HLayout_Tab_Skill_Group
        ]

    });
