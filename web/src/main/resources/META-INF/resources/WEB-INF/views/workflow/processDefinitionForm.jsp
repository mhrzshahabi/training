<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var Menu_ListGrid_WorkflowProcessDefinitionList = isc.Menu.create({
        width: 150,
        data: [
            {
                title: "نمایش فرم فرایند", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowProcessList_showProcessDefinitionForm();
                }
            },
            {
                title: "حذف رکورد", icon: "<spring:url value="remove.png"/>",
                click: function () {
                    ListGrid_ProcessDefinition_remove();
                }
            },
            {
                title: "آپلود فایل فرایند", icon: "pieces/16/icon_add_files.png",
                click: function () {
                    ListGrid_WorkflowProcessList_uploadProcessDefinition();
                }
            }
        ]
    });

    var workflowProcessDefinitionViewLoader = isc.ViewLoader.create({
        <%--width: "100%",--%>
        <%--height: "100%",--%>
        autoDraw: false,
        <%--border: "10px solid black",--%>
        viewURL: "",
        overflow: "scroll",
        loadingMessage: "فرم فرایندی برای نمایش وجود ندارد"
    });

    function ListGrid_WorkflowProcessList_uploadProcessDefinition() {

        var filesList = document.getElementById(window.uploadFileFieldSample1.uploadItem.getElement().id);
        var fileToLoad = filesList.files[0];
        var formData = new FormData();
        formData.append("file", fileToLoad);
        if (fileToLoad !== undefined) {
            TrnXmlHttpRequest(formData, workflowUrl + "uploadProcessDefinition", "POST", checkUploadResult);
        } else {
            isc.say("فایلی برای آپلود انتخاب نشده است.");
        }


    }

    function checkUploadResult(resp) {

        if (resp.status == 200)
            isc.say("فایل فرایند با موفقیت روی موتور گردش کار قرار گرفت");
        else {
            isc.say("کد خطا : " + resp.status);
        }
        // if (resp.status == "error")
        //     isc.say("آپلود فایل با مشکل مواجه شده است.");
        // if (resp.responseText == "badFile")
        //     isc.say("آپلود فایل قابل قرارگیری روی موتور گردش کار نیست.");
        ListGrid_ProcessDefinitionList.invalidateCache();

    }

    <spring:url value="static/img/pieces/16/icon_add_files.png" var="icon_add_files"/>
    var uploadForm = isc.DynamicForm.create({
        fields: [
            {
                id: "uploadFileFieldSample1",
                ID: "uploadFileFieldSample1",
                name: "file",
                type: "file",
                accept: ".bpmn",
                style: "position: relative; filter:alpha(opacity: 0); opacity: 0;",
                title: "<span style='color:#000000;'><image src='${icon_add_files}' />انتخاب فایل</span>"
            }
        ]
    });


    <%--Get Process Form Details--%>

    function ListGrid_WorkflowProcessList_showProcessDefinitionForm() {

        var record = ListGrid_ProcessDefinitionList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است !",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {

            isc.Dialog.create({
                message: "آیا فرایند انتخاب شده برای شروع آماده شود؟",
                icon: "[SKIN]ask.png",
                title: "تائید",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({title: "خیر"})],
                buttonClick: function (button, index) {
                    this.hide();
                    if (index == 0) {
                        var processDefID = record.id;
                        <spring:url value="/web/workflow/getProcessDefinitionDetailForm/" var="getProcessDefinitionDetailForm"/>
                        workflowProcessDefinitionViewLoader.setViewURL("${getProcessDefinitionDetailForm}" + processDefID + "?Authorization=Bearer " + '${cookie['access_token'].getValue()}');
                        workflowProcessDefinitionViewLoader.show();
                    }
                }
            });
        }
    }


    function ListGrid_ProcessDefinition_remove() {

        var record = ListGrid_ProcessDefinitionList.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است !",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.hide();
                }
            });
        } else {
            isc.Dialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "حذف تائید",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({title: "خیر"})],
                buttonClick: function (button, index) {
                    this.hide();
                    if (index == 0) {
                        var deployId = record.deploymentId;
                        isc.RPCManager.sendRequest(
                            TrDSRequest(workflowUrl + "processDefinition/remove/" + deployId, "DELETE",
                                null, ProcessDefinition_remove_result));
                    }
                }
            });
        }
    };

    function ProcessDefinition_remove_result(resp) {

        alert("done");

        if (resp.httpResponseCode === 200) {
            ListGrid_ProcessDefinitionList.invalidateCache();
            var OK = createDialog("info", "<spring:message code='msg.record.remove.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else if (resp.data === false) {
            createDialog("info", "<spring:message code='msg.teacher.remove.error'/>");
        } else {
            createDialog("info", "<spring:message code='msg.record.remove.failed'/>");
        }
    }

    function ListGrid_WorkflowProcessList_showProcessDefinitionImage() {

        var record = ListGrid_ProcessDefinitionList.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است !",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.hide();
                }
            });
        } else {
            var deployId = record.id;
            <spring:url value="/web/workflow/processDefinition/diagram/" var="diagram"/>
            workflowProcessDefinitionViewLoader.setViewURL("${diagram}" + deployId);
            workflowProcessDefinitionViewLoader.show();
        }

    }

    var ToolStripButton_showProcessDefinitionForm = isc.ToolStripButton.create({
        icon: "pieces/512/task.png",
        title: " نمایش فرم فرایند",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessDefinitionForm();
        }
    });

    var ToolStripButton_showProcessDefinitionImage = isc.ToolStripButton.create({
        icon: "pieces/512/contact.png",
        title: "تصویر فرایند",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessDefinitionImage();
        }
    });

    var ToolStripButton_uploadProcessDefinitionForm = isc.ToolStripButton.create({
        title: "آپلود تعریف فرایند", icon: "pieces/16/upload.png",
        click: function () {
            ListGrid_WorkflowProcessList_uploadProcessDefinition();
        }
    });


    var ToolStripButton_deleteProcessDefinitionForm = isc.ToolStripButton.create({


        title: "حذف فرایند", icon: "<spring:url value="remove.png"/>",
        click: function () {
            ListGrid_ProcessDefinition_remove();
        }

    });


    var ToolStrip_ProcessDefinitionActions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_showProcessDefinitionForm,
            ToolStripButton_showProcessDefinitionImage,
            ToolStripButton_deleteProcessDefinitionForm,
            ToolStripButton_uploadProcessDefinitionForm,
            uploadForm
        ]
    });

    var HLayout_ProcessDefinitionActions = isc.HLayout.create({
        width: "100%",
        members: [
            ToolStrip_ProcessDefinitionActions
        ]
    });

    var RestDataSource_ProcessDefinitionList = isc.TrDS.create({
        fields: [

            {name: "name", title: "نام فرایند"},
            {name: "resourceName", title: "نام فایل فرایند"},
            {name: "deploymentId", title: "ای دی فرایند"},
            {name: "key", title: "کلید"},
            {name: "description", title: "توصیف"},
            {name: "version", title: "نسخه"},
            {name: "id", title: "id", type: "text"}
        ],
        fetchDataURL: workflowUrl + "processDefinition/list"
    });

    var ListGrid_ProcessDefinitionList = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_ProcessDefinitionList,
        sortDirection: "descending",
        doubleClick: function () {
            ListGrid_WorkflowDefinitionList_showTaskForm();
        },
        contextMenu: Menu_ListGrid_WorkflowProcessDefinitionList,
        fields: [

            {name: "name", title: "نام", width: "30%"},
            {name: "resourceName", title: "نام فایل فرایند", width: "30%"},
            {name: "deploymentId", title: "ای دی فرایند", width: "30%"},
            {name: "key", title: "کلید", width: "30%"},
            {name: "description", title: "توصیف", width: "30%"},
            {name: "version", title: "نسخه", width: "10%"},
            {name: "id", title: "id", type: "text", width: "30%"}

        ],
        sortField: "deploymentId",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        startsWithTitle: "tt"
    });

    function ListGrid_WorkflowDefinitionList_showTaskForm() {

        ListGrid_WorkflowProcessList_showProcessDefinitionImage();
    }


    var HLayout_ProcessDefinitionGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid green",--%>

        members: [
            ListGrid_ProcessDefinitionList
        ]
    });
    var VLayout_workflowProcessDefinition = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid red",--%>
        overflow: "auto",
        members: [

            workflowProcessDefinitionViewLoader
        ]
    });

    var VLayout_ProcessDefinitionBody = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid red",--%>
        members: [
            HLayout_ProcessDefinitionActions,
            HLayout_ProcessDefinitionGrid,
            VLayout_workflowProcessDefinition
        ]
    });