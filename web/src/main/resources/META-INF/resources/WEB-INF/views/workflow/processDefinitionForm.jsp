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
                title: "<spring:message code="display.process.form"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowProcessList_showProcessDefinitionForm();
                }
            },
            {
                title: "<spring:message code="remove"/>" , icon: "<spring:url value="remove.png"/>",
                click: function () {
                    ListGrid_ProcessDefinition_remove();
                }
            },
            {
                title: "<spring:message code="upload.process.file"/>" , icon: "pieces/16/icon_add_files.png",
                click: function () {
                    ListGrid_WorkflowProcessList_uploadProcessDefinition();
                }
            }
        ]
    });

    var workflowProcessDefinitionViewLoader = isc.ViewLoader.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        viewURL: "",
        loadingMessage: "<spring:message code="there.is.no.process.form.to.display"/>"
    });

    function ListGrid_WorkflowProcessList_uploadProcessDefinition() {

        var filesList = document.getElementById(window.uploadFileFieldSample1.uploadItem.getElement().id);
        var fileToLoad = filesList.files[0];
        var formData = new FormData();
        formData.append("file", fileToLoad);
        if (fileToLoad !== undefined) {
            isc.RPCManager.sendRequest(TrDSRequest(getFmsConfig, "Get",  null, function (resp) {
                let data= JSON.parse(resp.data)
                MinIoUploadHttpRequest(formData, data.url, data.groupId, checkUploadResult);

            }));
            // TrnXmlHttpRequest(formData, workflowUrl + "/uploadProcessDefinition", "POST", checkUploadResult);
        } else {
            isc.say("<spring:message code="no.file.selected.for.upload"/>");
        }
    }

    function checkUploadResult(resp) {
        if (resp.status == 200)
            isc.say("<spring:message code="course.set.on.workflow.engine"/>" );
        else {
            isc.say("آپلود فایل با مشکل مواجه شده است.");
        }

// if (resp.status == "error")
// isc.say("آپلود فایل با مشکل مواجه شده است.");
// if (resp.responseText == "badFile")
// isc.say("آپلود فایل قابل قرارگیری روی موتور گردش کار نیست.");
        ListGrid_ProcessDefinitionList.invalidateCache();

    }

    <spring:url value="static/img/pieces/16/icon_add_files.png" var="icon_add_files"/>
    var uploadForm = isc.DynamicForm.create({
        width:100,
        fields: [
            {
                id: "uploadFileFieldSample1",
                ID: "uploadFileFieldSample1",
                name: "file",
                type: "file",
                accept: ".bpmn",
                style: "position: relative; filter:alpha(opacity: 0); opacity: 0;",
                title: "<span style='color:#000000;'><image src='${icon_add_files}   ' />انتخاب فایل</span>"
            }
        ]
    });


    <%--Get Process Form Details--%>

    function ListGrid_WorkflowProcessList_showProcessDefinitionForm() {

        var record = ListGrid_ProcessDefinitionList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {

            isc.Dialog.create({
                message: "<spring:message code="have.the.selected.process.ready.to.begin"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.ok"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="yes"/>"}), isc.IButtonCancel.create({title: "<spring:message code="global.no"/>"})],
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
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                }
            });
        } else {
            isc.Dialog.create({
                message: "<spring:message code="global.grid.record.remove.ask"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="verify.delete"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="yes"/>"}), isc.IButtonCancel.create({title: "<spring:message code="global.no"/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                    if (index == 0) {
                        var deployId = record.deploymentId;
                        isc.RPCManager.sendRequest(
                            TrDSRequest(workflowUrl + "/processDefinition/remove/" + deployId, "DELETE",
                                null, ProcessDefinition_remove_result));
                    }
                }
            });
        }
    };

    function ProcessDefinition_remove_result(resp) {

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
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="global.ok"/>"})],
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
        icon: "task.png",
        title: "<spring:message code="display.process.form"/>",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessDefinitionForm();
        }
    });

    var ToolStripButton_showProcessDefinitionImage = isc.ToolStripButton.create({
        icon: "contact.png",
        title: "<spring:message code="process.image"/>",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessDefinitionImage();
        }
    });

    var ToolStripButton_uploadProcessDefinitionForm = isc.ToolStripButton.create({
        title: "<spring:message code="upload.process.file"/>", icon: "upload.png",
        click: function () {
            ListGrid_WorkflowProcessList_uploadProcessDefinition();
        }
    });


    var ToolStripButton_deleteProcessDefinitionForm = isc.ToolStripButton.create({


        title: "<spring:message code="remove.process"/>", icon: "remove.png",
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

            {name: "name", title: "<spring:message code="process.name"/>"},
            {name: "resourceName", title: "<spring:message code="process.name"/>"},
            {name: "deploymentId", title: "<spring:message code="process.id"/>"},
            {name: "key", title: "<spring:message code="key"/>"},
            {name: "description", title: "<spring:message code="description"/>"},
            {name: "version", title: "<spring:message code="version"/>"},
            {name: "id", title: "id", type: "text"}
        ],
        fetchDataURL: workflowUrl + "/processDefinition/list"
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
            {name: "resourceName", title: "<spring:message code="process.name"/>", width: "30%"},
            {name: "deploymentId", title: "<spring:message code="process.id"/>", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "key", title: "<spring:message code="key"/>", width: "30%"},
            {name: "description", title: "<spring:message code="description"/>", width: "30%"},
            {name: "version", title: "<spring:message code="version"/>", width: "10%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                }
            },
            {name: "id", title: "id", type: "text", width: "30%", hidden: true}

        ],
        sortField: "deploymentId",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "<spring:message code="sort.ascending"/>",
        sortFieldDescendingText: "<spring:message code="sort.descending"/>",
        configureSortText: "<spring:message code="configureSortText"/>",
        autoFitAllText: "<spring:message code="autoFitAllText"/>",
        autoFitFieldText: "<spring:message code="autoFitFieldText"/>",
        filterUsingText: "<spring:message code="filterUsingText"/>",
        groupByText: "<spring:message code="groupByText"/>",
        freezeFieldText: "<spring:message code="freezeFieldText"/>",
        startsWithTitle: "tt"
    });

    function ListGrid_WorkflowDefinitionList_showTaskForm() {

        ListGrid_WorkflowProcessList_showProcessDefinitionImage();
    }


    var HLayout_ProcessDefinitionGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",

        members: [
            ListGrid_ProcessDefinitionList
        ]
    });

    var VLayout_ProcessDefinitionBody = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
             HLayout_ProcessDefinitionActions,
             HLayout_ProcessDefinitionGrid,
             workflowProcessDefinitionViewLoader
        ]
    });