




var method = "POST";
var  url = EvaluationConfigs.baseRestUrl + "/api/department/" ;
var departmentId = "";
var RestDataSource_persons = isc.RestDataSource.create({
    fields:
        [
            {name:"id",width:"30%" , hidden:true , title:"<spring:message code='evaluation.personal.code'/>"},
            {name:"emp10",width:"30%", title:"<spring:message code='evaluation.personal.code'/>"},
            {name:"depCodeAward",width:"40%", title:"<spring:message code='evaluation.person.depCodeAward'/>"},
            {name:"firstName",width:"30%", title:"<spring:message code='global.table.first-name'/>"},
            {name:"lastName",width:"30%", title:"<spring:message code='global.table.last-name'/>"},
            {name:"departmentName",width:"50%", title:"<spring:message code='department.title'/>"}
        ],
    dataFormat: "json",
    jsonPrefix: "",
    jsonSuffix: "",
    transformRequest : function (dsRequest)
    {
        dsRequest.httpHeaders = EvaluationConfigs.httpHeaders;
        return this.Super("transformRequest", arguments);
    }
});
var child_person_restDataSource = isc.RestDataSource.create({
    fields:
        [
            {name:"id",hidden : true},
            {name:"depCodeAward",hidden : true},
            {name:"roleCode",hidden : true},
            {name:"emp10",width:"20%" , title:"<spring:message code='evaluation.personal.code'/>",showHover : true},
            {name:"firstName",width:"20%", title:"<spring:message code='global.table.first-name'/>",showHover : true},
            {name:"lastName",width:"20%", title:"<spring:message code='global.table.last-name'/>",showHover : true},
            {name:"roleDesc",width:"50%" , title:"<spring:message code='evaluation.person.postName'/>",showHover : true},
            {name:"postRade",width:"30%" , title:"<spring:message code='evaluation.post-level'/>",showHover : true},
            {name:"depName",width:"40%" , title:"<spring:message code='department.title'/>",showHover : true},
            {name:"is_overwrite",width:"15%" , title:"<spring:message code='evaluation.user.type'/>",showHover : true
                ,valueMap:
                    {
                        "y":"<spring:message code='user.special'/>",
                        "n":""
                    }
            }
        ],
    dataFormat: "json",
    jsonPrefix: "",
    jsonSuffix: "",
    transformRequest : function (dsRequest)
    {
        dsRequest.httpHeaders = EvaluationConfigs.httpHeaders;
        return this.Super("transformRequest", arguments);
    }
});
var revert_person_restDataSource = isc.RestDataSource.create({
    fields:
        [
            {name:"id",hidden : true},
            {name:"person.emp10",width:"20%" , title:"<spring:message code='evaluation.personal.code'/>"},
            {name:"person.firstName",width:"20%", title:"<spring:message code='global.table.first-name'/>"},
            {name:"person.lastName",width:"20%", title:"<spring:message code='global.table.last-name'/>"},
            {name:"person.departmentName",width:"40%", title:"<spring:message code='department.title'/>"},
            {name:"person.roleDesc",width:"30%" , title:"<spring:message code='evaluation.role.title'/>"},
            // {name:"person.roleCode",width:"20%" , title:"<spring:message code='evaluation.role.code'/>"},
            {name:"person.post.postLevel.titleFa",width:"30%" , title:"<spring:message code='evaluation.post-level'/>"}
        ],
    dataFormat: "json",
    jsonPrefix: "",
    jsonSuffix: "",
    transformRequest : function (dsRequest)
    {
        dsRequest.httpHeaders = EvaluationConfigs.httpHeaders;
        return this.Super("transformRequest", arguments);
    }
});
//*************************************************************
function TreeGrid_dep_new() {
    method = "POST";
    treeGridNewDynamicForm.clearValues();
    treeGridDepNewWindow.show();
}
function TreeGrid_dep_Edit() {
    method = "PUT";
    var record = departmentTreeGrid.getSelectedRecord();

    if (record == null || record.id == null) {
        isc.Dialog.create({
            message: "<spring:message code='global.grid.record.not.selected'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: ".editRecord(record<spring:message code='global.ok'/>"})],
            buttonClick: function () {
                this.hide();
            }
        });
    } else {
        treeGridNewDynamicForm.editRecord(record);
        treeGridDepNewWindow.show();
    }
}
function TreeGrid_dep_remove() {
    var record = departmentTreeGrid.getSelectedRecord();
    if (record != null && record.id != null)
    {
        if ( record.sync != null && typeof(record.sync)!= 'undefined' && record.sync == 1)
        {
            isc.Dialog.create({
                message: "<spring:message code='global.delete.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                    if (index == 0) {
                        isc.RPCManager.sendRequest({
                            actionURL: EvaluationConfigs.baseRestUrl + "/api/department/"+record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            httpHeaders: EvaluationConfigs.httpHeaders,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: true,
                            callback: function (resp)
                            {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201 )
                                {
                                    TreeGrid_dep_refresh();
                                    dep_person_ListGrid.invalidateCache();
                                    relation_Form.clearValues();
                                    manager_Form.clearValues();
                                    var OK = isc.Dialog.create({
                                        message: '<spring:message code="global.form.request.successful"/>',
                                        icon: "[SKIN]say.png",
                                        title: '<spring:message code="global.form.command.done"/>'
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                }
                                else isc.say(resp.data);
                            }
                        });
                    }

                }
            });
        }
        else
        {
            isc.Dialog.create({
                message: "<spring:message code='department.grid.record.not.deleted'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                }
            });
        }
    }else {
        isc.Dialog.create({
            message: "<spring:message code='global.grid.record.not.selected'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
            buttonClick: function (button, index) {
                this.hide();
            }
        });
    }
}
function TreeGrid_dep_refresh() {
    departmentTreeGrid.invalidateCache();
}

var treeGridNewDynamicForm = isc.DynamicForm.create({
    setMethod: 'POST',
    align: "center",
    wrapItemTitles: false,
    canSubmit: true,
    showInlineErrors: true,
    showErrorText: true,
    showErrorStyle: true,
    errorOrientation: "bottom",
    colWidths: ["30%", "*"],
    height: "50",
    titleAlign: "right",
    requiredMessage: '<spring:message code="validator.field.is.required" />',
    numCols: 2,
    margin: 10,
    newPadding: 5,
    fields:
        [
            {name:"departmentName",type:"text", title:"<spring:message code='department.name' />"}
        ]
});

treeGridDepSave = isc.IButtonSave.create({
    top: 260, title: '<spring:message code="global.form.save" />',
    icon: "pieces/16/save.png",
    click: function () {
        var data = treeGridNewDynamicForm.getValues();
        var record = departmentTreeGrid.getSelectedRecord();
        data.departmentName = data.departmentName;
        data.parentCode =record.parentCode;
        data.depParrentId =record.id;
        data.code =record.code;
        data.treeVersion =record.treeVersion;
        data.sync = "1";
        isc.RPCManager.sendRequest({
            actionURL:  EvaluationConfigs.baseRestUrl + "/api/department/" ,
            httpMethod: method,
            useSimpleHttp: true,
            httpHeaders: EvaluationConfigs.httpHeaders,
            contentType: "application/json; charset=utf-8",
            showPrompt: true,
            data: JSON.stringify(data),
            callback: function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201 ) {
                    TreeGrid_dep_refresh();
                    treeGridDepNewWindow.close();
                    var OK = isc.Dialog.create({
                        message: '<spring:message code="global.form.request.successful"/>',
                        icon: "[SKIN]say.png",
                        title: '<spring:message code="global.form.command.done"/>'
                    });
                    setTimeout(function () {
                        OK.close();
                    }, 3000);
                } else {
                    isc.say(resp.data);
                }
            }
        });
    }
});
var treeGridSaveOrExitHlayout = isc.HLayout.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    alignLayout: "center",
    padding: 10,
    membersMargin: 10,
    members:
        [
            treeGridDepSave,
            isc.IButtonCancel.create({
                title: '<spring:message code="global.close" />',
                prompt: "",
                width: 100,
                icon: "pieces/16/icon_delete.png",
                orientation: "vertical",
                click: function () {
                    treeGridDepNewWindow.close();
                }
            })
        ]
});
var treeGridDepNewWindow = isc.Window.create({
    title: '<spring:message code="evalution.form.freePerson" />',
    width: "500",
    height: "100",
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
    items:
        [
            isc.VLayout.create({
                members:
                    [
                        treeGridNewDynamicForm,
                        treeGridSaveOrExitHlayout
                    ]
            })
        ]
});

var departmentDS = isc.RestDataSource.create({
    fields:[
        {name:"id", primaryKey:true, type:"integer", title:" ID"},
        {name:"code", primaryKey:true, type:"text", title:"code"},
        {name:"parentDepartment.departmentName" },
        {name:"parentDepartment.id" },
        {name:"treeVersion" },
        {name:"sync" },
        {name:"departmentName" , title:"<spring:message code='department.name'/>"},
        {name:"parentCode" },
        {name:"treeVersion" },
        {name:"depParrentId", foreignKey:"id", type:"integer", title:"parent department" }
    ],
    dataFormat: "json",
    jsonPrefix: "",
    jsonSuffix: "",
    transformRequest : function (dsRequest)
    {
        dsRequest.httpHeaders = EvaluationConfigs.httpHeaders;
        return this.Super("transformRequest", arguments);
    },
    fetchDataURL: EvaluationConfigs.baseRestUrl + "/api/department/departmentGridFetch"
});
var Menu_TreeGrid_department = isc.Menu.create({
    width: 150,
    data: [
        {
            title: '<spring:message code="global.form.new" />', icon: "pieces/16/icon_add.png", click: function () {
                TreeGrid_dep_new();
            }
        },
        {
            title: '<spring:message code="global.form.edit" />', icon: "pieces/16/icon_edit.png", click: function () {
                TreeGrid_dep_Edit();
            }
        },
        {
            title: '<spring:message code="global.form.remove" />', icon: "pieces/16/icon_delete.png", click: function () {
                TreeGrid_dep_remove();
            }
        }
    ]
});
var departmentTreeGrid = isc.TreeGrid.create({
    dataSource: departmentDS,
    autoFetchData: true,
    width: "35%",
    height: "90%",
    showFilterEditor:true,
    dataPageSize: 50,
    loadDataOnDemand: true,
    border:"0px solid green",
    // filterLocalData : true ,
    dataFetchMode:"paged",
    contextMenu: Menu_TreeGrid_department,
    dataProperties: {openProperty: "isOpen"},
    showConnectors: true,
    rowClick: function(record,recordNum ,fieldNum )
    {
        var record = departmentTreeGrid.getSelectedRecord();
        departmentId = record.id;
        eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
        eval_person_restDataSource.fetchData({depCode:record.id , courseId : evaluationCourseUtil.getCurrentCourseId()}
            ,function (dsResponse, data)
            {
                var managerName = "";
                var relationName = "";
                if(data != null && data.length >0){
                    managerName = data[0].managerName;
                    relationName = data[0].relationName;
                }
                manager_Form.setValue("managerName",managerName);
                relation_Form.setValue("relationName",relationName);
            }
        );

        child_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/person/listChilds/" ;
        dep_person_ListGrid.setDataSource(child_person_restDataSource);
        dep_person_ListGrid.fetchData({depCode:record.id , courseId : evaluationCourseUtil.getCurrentCourseId()});
    },
    fields:
        [
            {name:"code",hidden:true},
            {name:"parentCode" ,hidden:true},
            {name:"depParrentId",hidden:true },
            {name:"treeVersion",hidden:true },
            {name:"sync",hidden:true },

            {name: "departmentName" , canFilter: true}
        ]
});
//*******************************************users******************************************************
var persons_ListGrid = isc.ListGrid.create({
    dataSource:RestDataSource_persons,
    width:"800",
    height:"500",
    paddingAsLayoutMargin:5,
    alternateRecordStyles:true,
    canAutoFitFields: false,
    autoFetchData: false,
    showFilterEditor:true,
    fields: []
});
var relation_ListGrid = isc.ListGrid.create({
    dataSource:RestDataSource_persons,
    width:"800",
    height:"500",
    paddingAsLayoutMargin:5,
    canAutoFitFields: false,
    alternateRecordStyles:true,
    autoFetchData: false,
    showFilterEditor:true,
    fields: [],
    canReorderFields: true
});
var IButton_Manager_Save = isc.IButtonSave.create({
    top: 260, title:"<spring:message code='global.form.save'/>", icon: "pieces/16/save.png",
    click: function ()
    {
        var record = persons_ListGrid.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='global.grid.record.not.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {
            isc.Dialog.create({
                message: "<spring:message code='evalution.management.change.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='evalution.form.managerChange'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"}), isc.Button.create({title: "<spring:message code='global.cancel'/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                    if (index == 0)
                    {
                        var record = persons_ListGrid.getSelectedRecord();
                        var personId = record.id;
                        record.userId = personId;
                        record.depCode = departmentTreeGrid.getSelectedRecord().id;
                        isc.RPCManager.sendRequest({
                            actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/",
                            httpMethod: method,
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            httpHeaders: EvaluationConfigs.httpHeaders,
                            data: JSON.stringify(record),
                            serverOutputAsString: false,
                            callback: function (RpcResponse_o)
                            {

                                if (RpcResponse_o.httpResponseCode == 200 || RpcResponse_o.httpResponseCode == 201) {
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='global.form.request.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='global.form.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                    var record = departmentTreeGrid.getSelectedRecord();
                                    eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                                    eval_person_restDataSource.fetchData({depCode:record.id}
                                        ,function (dsResponse, data)
                                        {
                                            var managerName = "";
                                            var relationName = "";
                                            if(data != null && data.length >0){
                                                managerName = data[0].managerName;
                                                relationName = data[0].relationName;
                                            }
                                            manager_Form.setValue("managerName",managerName);
                                            relation_Form.setValue("relationName",relationName);
                                        }
                                    );
                                    usersWindow.close();
                                }
                            }
                        });
                    }
                }
            });
        }

    }
});
var IButton_Relation_Save = isc.IButtonSave.create({
    top: 260, title:"<spring:message code='global.form.save'/>", icon: "pieces/16/save.png",
    click: function ()
    {
        var record = relation_ListGrid.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='global.grid.record.not.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function () {
                    this.hide();
                }

            });
        } else {
            isc.Dialog.create({
                message: "<spring:message code='evalution.relation.change.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='evalution.form.relationChange'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"}), isc.Button.create({title: "<spring:message code='global.cancel'/>"})],
                buttonClick: function (button, index) {

                    this.hide();
                    if (index == 0)
                    {
                        var record = relation_ListGrid.getSelectedRecord();
                        var relationId = record.id;
                        record.relationId = relationId;
                        record.depCode = departmentTreeGrid.getSelectedRecord().id;
                        isc.RPCManager.sendRequest({
                            actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/"+"relation/",
                            httpMethod: method,
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            httpHeaders: EvaluationConfigs.httpHeaders,
                            data: JSON.stringify(record),
                            serverOutputAsString: false,
                            callback: function (RpcResponse_o)
                            {

                                if (RpcResponse_o.httpResponseCode == 200) {
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='global.form.request.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='global.form.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                    var record = departmentTreeGrid.getSelectedRecord();
                                    eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                                    eval_person_restDataSource.fetchData({depCode:record.id}
                                        ,function (dsResponse, data)
                                        {
                                            var managerName = "";
                                            var relationName = "";
                                            if(data != null && data.length >0){
                                                managerName = data[0].managerName;
                                                relationName = data[0].relationName;
                                            }
                                            manager_Form.setValue("managerName",managerName);
                                            relation_Form.setValue("relationName",relationName);
                                        }
                                    );
                                    relationWindow.close();
                                } else  if(RpcResponse_o.httpResponseCode == 201){
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='global.form.request.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='global.form.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                    var record = departmentTreeGrid.getSelectedRecord();
                                    eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                                    eval_person_restDataSource.fetchData({depCode:record.id}
                                        ,function (dsResponse, data)
                                        {
                                            var managerName = "";
                                            var relationName = "";
                                            if(data != null && data.length >0){
                                                managerName = data[0].managerName;
                                                relationName = data[0].relationName;
                                            }
                                            manager_Form.setValue("managerName",managerName);
                                            relation_Form.setValue("relationName",relationName);
                                        }
                                    );
                                    relationWindow.close();
                                }else{
                                    var ERROR = isc.Dialog.create({
                                        message: ("<spring:message code='global.form.response.error'/>!"),
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='global.message'/>"
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

    }
});
var usersSaveOrExitHlayout = isc.HLayout.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "50",
    alignLayout: "center",
    padding: 10,
    membersMargin: 10,
    members:
        [
            IButton_Manager_Save,
            isc.IButtonCancel.create({
                title: "<spring:message code='global.cancel'/>",
                prompt: "",
                width: 100,
                icon: "pieces/16/icon_delete.png",
                orientation: "vertical",
                click: function () {
                    usersWindow.close();
                }
            })
        ]
});
var relationSaveOrExitHlayout = isc.HLayout.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "50",
    alignLayout: "center",
    padding: 10,
    membersMargin: 10,
    members:
        [
            IButton_Relation_Save,
            isc.IButtonCancel.create({
                title: "<spring:message code='global.cancel'/>",
                prompt: "",
                width: 100,
                icon: "pieces/16/icon_delete.png",
                orientation: "vertical",
                click: function () {
                    relationWindow.close();
                }
            })
        ]
});
var usersWindow = isc.Window.create({
    title: "<spring:message code='evalution.form.managerChange'/>",
    width: "500",
    height: "500",
    autoSize:true,
    autoCenter: true,
    isModal: true,
    showModalMask: true,
    autoDraw: false,
    dismissOnEscape: true,
    closeClick : function () { this.Super("closeClick", arguments)},
    items:
        [
            isc.VLayout.create({
                members:
                    [
                        persons_ListGrid,
                        usersSaveOrExitHlayout
                    ]
            })
        ]
});
var relationWindow = isc.Window.create({
    title: "<spring:message code='evalution.form.relationChange'/>",
    width: "500",
    height: "500",
    autoSize:true,
    autoCenter: true,
    isModal: true,
    showModalMask: true,
    autoDraw: false,
    dismissOnEscape: true,
    closeClick : function () { this.Super("closeClick", arguments)},
    items:
        [
            isc.VLayout.create({
                members:
                    [
                        relation_ListGrid,
                        relationSaveOrExitHlayout
                    ]
            })
        ]
});

var relation_Form = isc.DynamicForm.create({
    width: "400",
    height: "100",
    setMethod: 'POST',
    align: "center",
    canSubmit: true,
    showInlineErrors: true,
    showErrorText: true,
    showErrorStyle:true,
    errorOrientation: "bottom",
    titleWidth: "100",
    titleAlign:"right",
    requiredMessage: "<spring:message code='validator.field.is.required'/>",
    numCols: 4,
    fields:
        [
            { type:"header", defaultValue:""},
            {name: "relationName", type:"text", title: "<spring:message code='evaluation.relation'/>",required:true ,width: 400,canEdit:false },
        ]
});

var manager_Form = isc.DynamicForm.create({
    width: "400",
    height: "50",
    setMethod: 'POST',
    align: "center",
    canSubmit: true,
    showInlineErrors: true,
    autoFetchData: false,
    showErrorText: true,
    showErrorStyle:true,
    errorOrientation: "bottom",
    titleWidth: "100",
    titleAlign:"right",
    requiredMessage: "<spring:message code='validator.field.is.required'/>",
    numCols: 4,
    fields:
        [
            { type:"header", defaultValue:""},
            {name: "managerName", type:"selectItem", title: "<spring:message code='user.manager'/>",required:true ,width: 400,canEdit:false }
        ]
});

var userCriteria = {
    "operator": "and",
    "criteria": [
        {
            "fieldName": "username",
            "operator": "notNull"
        }
    ],
};
var manager_from_HLayout = isc.HLayout.create({
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "50",
    align: "center",
    members:
        [
            manager_Form,
            isc.Label.create({width: 5, height: 0 }),
            isc.VLayout.create({
                members:
                    [
                        isc.Label.create({width: 0, height: 22 }),
                        isc.HLayout.create({
                            members:
                                [
                                    isc.ToolStripButtonAdd.create({
                                        title:  "<spring:message code='evalution.form.managerChange'/>",
                                        width: 100,
                                        orientation: "vertical",
                                        click: function ()
                                        {
                                            if(departmentTreeGrid.getSelectedRecord()!= null)
                                            {
                                                var record = departmentTreeGrid.getSelectedRecord();
                                                RestDataSource_persons.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/person/spec-list/" ;
                                                // persons_ListGrid.setDataSource(RestDataSource_persons);

                                                var crt = {operator: "and",
                                                    criteria: [{fieldName: 'username', operator: "notNull"}]}
                                                persons_ListGrid.fetchData(crt);

                                                usersWindow.show();
                                            } else
                                                isc.say("<spring:message code='error.select.a.record.tree'/>");
                                        }
                                    }),
                                    isc.Label.create({width: 5, height: 0 }),
                                    isc.ToolStripButtonRemove.create({
                                        title:  "<spring:message code='evalution.form.managerDelete'/>",
                                        width: 120,
                                        icon: "pieces/16/icon_delete.png",
                                        orientation: "vertical",
                                        click: function () {
                                            manager_remove();
                                        }
                                    })
                                ]
                        })

                    ]
            })
        ]
});
var relation_from_HLayout = isc.HLayout.create({
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "50",
    align: "center",
    members:
        [
            relation_Form,
            isc.Label.create({width: 5, height: 0 }),
            isc.VLayout.create({
                members:
                    [
                        isc.Label.create({width: 0, height: 22 }),
                        isc.HLayout.create({
                            members:
                                [
                                    isc.ToolStripButtonAdd.create({
                                        title:  "<spring:message code='evalution.form.relationChange'/>",
                                        width: 100,
                                        orientation: "vertical",
                                        click: function ()
                                        {
                                            if(departmentTreeGrid.getSelectedRecord()!= null)
                                            {
                                                var record = departmentTreeGrid.getSelectedRecord();
                                                RestDataSource_persons.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/person/spec-list/" ;

                                                var crt = {operator: "and",
                                                    criteria: [{fieldName: 'username', operator: "notNull"}]}
                                                relation_ListGrid.fetchData(crt);
                                                relationWindow.show();

                                            }else
                                                isc.say("<spring:message code='error.select.a.record.tree'/>");
                                        }
                                    }),
                                    isc.Label.create({width: 5, height: 0 }),
                                    isc.ToolStripButtonRemove.create({
                                        title:  "<spring:message code='evalution.form.relationDelete'/>",
                                        width: 120,
                                        icon: "pieces/16/icon_delete.png",
                                        orientation: "vertical",
                                        click: function () {
                                            relation_remove();
                                        }
                                    })
                                ]
                        })

                    ]
            })
        ]
});
var departmentGridVLayout = isc.VLayout.create({
    width: "500",
    height: "100%",
    border:"0px solid green",
    layoutMargin:5,
    members:
        [
            manager_from_HLayout,
            relation_from_HLayout
        ]
});

//****************************************person**********************************************
var ViewLoader_Eval_Person  = isc.ViewLoader.create({
    autoDraw:false,
    width: "500",
    height: 500,
    loadingMessage: " <spring:message code='evaluation.main-desktop.loading'/>! ..."
});
var personWindow = isc.Window.create({
    title: "<spring:message code='evaluation.person.special.add'/>",
    width: "500",
    height: 500,
    autoSize:true,
    autoCenter: true,
    isModal: true,
    showModalMask: true,
    autoDraw: false,
    dismissOnEscape: true,
    closeClick : function () { this.Super("closeClick", arguments)},
    items: [
        ViewLoader_Eval_Person
    ]
});
var revert_personCriteria = {
    "operator": "and",
    "criteria": [
        {
            "fieldName": "type",
            "operator": "equal",
            "value": "deleted"
        }
    ],
};
var revert_person_ListGrid = isc.ListGrid.create({
    dataSource : revert_person_restDataSource,
    width:"100%",
    height:500,
    paddingAsLayoutMargin:5,
    canAutoFitFields: false,
    alternateRecordStyles:true,
    autoFetchData: false,
    showFilterEditor:true,
    selectionAppearance: "checkbox",
    fields: [],
    canReorderFields: true
});

var IButton_revert_Person_Save = isc.IButtonSave.create({
    top: 260,
    title:"<spring:message code='global.form.save'/>",
    icon: "pieces/16/save.png",
    click: function ()
    {
        isc.Dialog.create({
            message: "<spring:message code='evaluation.revert.ask'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
            buttonClick: function (button, index)
            {
                this.hide();
                if (index == 0)
                {
                    var records = revert_person_ListGrid.getSelectedRecords();
                    var params = {ids: []};
                    for (var i = 0; i < records.length; i++) {
                        var record = records[i];
                        params.ids.add(record.id);
                    }

                    isc.RPCManager.sendRequest({
                        actionURL:  EvaluationConfigs.baseRestUrl + "/api/evalEvalPersonAward/list",
                        httpMethod: "DELETE",
                        useSimpleHttp: true,
                        httpHeaders: EvaluationConfigs.httpHeaders,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: true,
                        params: params,
                        callback: function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                ListGrid_person_refresh();
                                revert_personWindow.close();
                                var OK = isc.Dialog.create({
                                    message: '<spring:message code="global.form.request.successful"/>',
                                    icon: "[SKIN]say.png",
                                    title: '<spring:message code="global.form.command.done"/>'
                                });
                                setTimeout(function () {
                                    OK.close();
                                }, 3000);
                            } else {
                                isc.say(resp.data);
                            }
                        }
                    });
                }
            }
        });
    }
});
var revertPersonSaveOrExitHlayout = isc.HLayout.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "50",
    alignLayout: "center",
    padding: 10,
    membersMargin: 10,
    members:
        [
            IButton_revert_Person_Save,
            isc.IButtonCancel.create({
                title: "<spring:message code='global.cancel'/>",
                prompt: "",
                width: 100,
                icon: "pieces/16/icon_delete.png",
                orientation: "vertical",
                click: function () {
                    revert_personWindow.close();
                }
            })
        ]

});
var revert_personWindow = isc.Window.create({
    title: "<spring:message code='evaluation.person.revert'/>",
    width: "60%",
    height: 500,
    autoSize:true,
    autoCenter: true,
    isModal: true,
    showModalMask: true,
    autoDraw: false,
    dismissOnEscape: true,
    closeClick : function () { this.Super("closeClick", arguments)},
    items:
        [
            revert_person_ListGrid,
            revertPersonSaveOrExitHlayout
        ]
});

//*********************************************person_************************************************

var eval_person_restDataSource = isc.RestDataSource.create({
    fields:[],
    dataFormat: "json",
    jsonPrefix: "",
    jsonSuffix: "",
    transformRequest : function (dsRequest)
    {
        dsRequest.httpHeaders = EvaluationConfigs.httpHeaders;
        return this.Super("transformRequest", arguments);
    }
});
function ListGrid_person_refresh() {

    var record = departmentTreeGrid.getSelectedRecord();
    departmentId = record.id;
    if (record == null) return;

    child_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/person/listChilds/" ;
    dep_person_ListGrid.setDataSource(child_person_restDataSource);
    dep_person_ListGrid.fetchData({depCode:record.id , courseId : evaluationCourseUtil.getCurrentCourseId()});
}
function ListGrid_person_new() {
    var record = departmentTreeGrid.getSelectedRecord();
    ViewLoader_Eval_Person.setViewURL(EvaluationConfigs.baseRestUrl + "/createEvalPerson/show-form/"+ record.id+"?depName="+record.departmentName);
    personWindow.show();
}
function ListGrid_person_revert() {

    var record = departmentTreeGrid.getSelectedRecord();
    departmentId = record.id;
    if (record == null) return;

    var crt1 = {operator: "and",criteria: [{fieldName: 'type', operator: "equals" , value :2 }]}  /*deleted=2*/

    revert_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalEvalPersonAward/spec-list/" ;
    revert_person_ListGrid.setDataSource(revert_person_restDataSource);
    revert_person_ListGrid.fetchData(crt1);
    revert_personWindow.show();
}
function manager_remove()
{
    manager_Form.setValue("userId","");
    manager_Form.setValue("depCode",departmentTreeGrid.getSelectedRecord().id);
    var record = manager_Form.getValues();
    var manager = manager_Form.getValue("managerName");
    var relation = relation_Form.getValue("relationName");
    if (manager.toString().length<=1  )
    {
        isc.Dialog.create({
            message: "<spring:message code='global.grid.records.is.null'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
            buttonClick: function () {
                this.hide();
            }
        });
    } else  if (manager.toString().length>=1 && relation.toString().length<=1 )
    {
        isc.Dialog.create({
            message: "<spring:message code='evalution.management.delete.ask'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
            buttonClick: function (button, index)
            {
                this.hide();
                if (index == 0) {
                    isc.RPCManager.sendRequest({
                        actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/manager/"+ departmentTreeGrid.getSelectedRecord().id,
                        httpMethod: "DELETE",
                        useSimpleHttp: true,
                        httpHeaders: EvaluationConfigs.httpHeaders,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: true,
                        callback: function (resp)
                        {
                            var record = departmentTreeGrid.getSelectedRecord();
                            eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                            eval_person_restDataSource.fetchData({depCode:record.id}
                                ,function (dsResponse, data)
                                {
                                    var managerName = "";
                                    var relationName = "";
                                    if(data != null && data.length >0){
                                        managerName = data[0].managerName;
                                        relationName = data[0].relationName;
                                    }
                                    manager_Form.setValue("managerName",managerName);
                                    relation_Form.setValue("relationName",relationName);
                                }
                            );
                        }
                    });
                }
            }
        });

    }else
    {
        isc.Dialog.create({
            message: "<spring:message code='evalution.management.delete.ask'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='evalution.form.managerChange'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"}), isc.Button.create({title: "<spring:message code='global.cancel'/>"})],
            buttonClick: function (button, index) {
                this.hide();
                if (index == 0)
                {

                    isc.RPCManager.sendRequest({
                        actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/",
                        httpMethod: "POST",
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        httpHeaders: EvaluationConfigs.httpHeaders,
                        data: JSON.stringify(record),
                        serverOutputAsString: false,
                        callback: function (RpcResponse_o)
                        {
                            var record = departmentTreeGrid.getSelectedRecord();
                            eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                            eval_person_restDataSource.fetchData({depCode:record.id}
                                ,function (dsResponse, data)
                                {
                                    var managerName = "";
                                    var relationName = "";
                                    if(data != null && data.length >0){
                                        managerName = data[0].managerName;
                                        relationName = data[0].relationName;
                                    }
                                    manager_Form.setValue("managerName",managerName);
                                    relation_Form.setValue("relationName",relationName);
                                }
                            );
                        }
                    });
                }
            }
        });
    }

}
function relation_remove()
{
    relation_Form.setValue("relationId","");
    relation_Form.setValue("depCode",departmentTreeGrid.getSelectedRecord().id);
    var record = relation_Form.getValues();
    var relationName = relation_Form.getValue("relationName");
    var manager = manager_Form.getValue("managerName");
    if (relationName.toString().length<=1 )
    {
        isc.Dialog.create({
            message: "<spring:message code='global.grid.records.is.null'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
            buttonClick: function () {
                this.hide();
            }
        });
    }
    else  if (relationName.toString().length>=1 && manager.toString().length<=1 )
    {
        isc.Dialog.create({
            message: "<spring:message code='evalution.relation.delete.ask'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
            buttonClick: function (button, index)
            {
                this.hide();
                if (index == 0) {
                    var type = "";
                    isc.RPCManager.sendRequest({
                        actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/relation/" + departmentTreeGrid.getSelectedRecord().id,
                        httpMethod: "DELETE",
                        useSimpleHttp: true,
                        httpHeaders: EvaluationConfigs.httpHeaders,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: true,
                        callback: function (resp)
                        {
                            var record = departmentTreeGrid.getSelectedRecord();
                            eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                            eval_person_restDataSource.fetchData({depCode:record.id}
                                ,function (dsResponse, data)
                                {
                                    var managerName = "";
                                    var relationName = "";
                                    if(data != null && data.length >0){
                                        managerName = data[0].managerName;
                                        relationName = data[0].relationName;
                                    }
                                    manager_Form.setValue("managerName",managerName);
                                    relation_Form.setValue("relationName",relationName);
                                }
                            );
                        }
                    });
                }
            }
        });

    }  else {
        isc.Dialog.create({
            message: "<spring:message code='evalution.relation.delete.ask'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='evalution.form.managerChange'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"}), isc.Button.create({title: "<spring:message code='global.cancel'/>"})],
            buttonClick: function (button, index)
            {
                this.hide();
                if (index == 0)
                {
                    isc.RPCManager.sendRequest({
                        actionURL: EvaluationConfigs.baseRestUrl + "/api/evalPerson/"+"relation/",
                        httpMethod: "POST",
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        httpHeaders: EvaluationConfigs.httpHeaders,
                        data: JSON.stringify(record),
                        serverOutputAsString: false,
                        callback: function (RpcResponse_o)
                        {
                            var OK = isc.Dialog.create({
                                message: "<spring:message code='global.form.request.successful'/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code='global.form.command.done'/>"
                            });
                            setTimeout(function () {
                                OK.close();
                            }, 3000);
                            var record = departmentTreeGrid.getSelectedRecord();
                            eval_person_restDataSource.fetchDataURL = EvaluationConfigs.baseRestUrl + "/api/evalPerson/listByDepCode/" ;
                            eval_person_restDataSource.fetchData({depCode:record.id}
                                ,function (dsResponse, data)
                                {
                                    var managerName = "";
                                    var relationName = "";
                                    if(data != null && data.length >0){
                                        managerName = data[0].managerName;
                                        relationName = data[0].relationName;
                                    }
                                    manager_Form.setValue("managerName",managerName);
                                    relation_Form.setValue("relationName",relationName);
                                }
                            );
                            relationWindow.close();

                        }
                    });
                }
            }
        });
    }

}
function ListGrid_person_remove()
{
    var record = dep_person_ListGrid.getSelectedRecord();
    if (record != null && record.id != null)
    {
        if(record.is_overwrite == 'y')
        {
            isc.Dialog.create({
                message: "<spring:message code='evaluation.special.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
                buttonClick: function (button, index)
                {
                    this.hide();
                    if (index == 0) {

                        var courseId = evaluationCourseUtil.getCurrentCourseId();
                        isc.RPCManager.sendRequest({
                            actionURL: EvaluationConfigs.baseRestUrl + "/api/evalEvalPersonAward/" + record.id+"/"+courseId,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            httpHeaders: EvaluationConfigs.httpHeaders,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: true,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode === 201) {
                                    ListGrid_person_refresh();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='global.form.request.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='global.form.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    isc.say(RpcResponse_o.data);
                                }
                            }
                        });
                    }
                }
            });
        }
        else if(record.is_overwrite == 'n')
        {
            isc.Dialog.create({
                message: "<spring:message code='global.delete.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='global.message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({title: "<spring:message code='global.no'/>"})],
                buttonClick: function (button, index)
                {
                    this.hide();
                    if (index == 0)
                    {
                        record.type = "2";
                        record.depCode = record.depCodeAward;
                        record.courseId = evaluationCourseUtil.getCurrentCourseId();
                        record.personId = record.id;
                        isc.RPCManager.sendRequest({
                            actionURL:  EvaluationConfigs.baseRestUrl + "/api/evalEvalPersonAward",
                            httpMethod: "POST",
                            useSimpleHttp: true,
                            httpHeaders: EvaluationConfigs.httpHeaders,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: true,
                            data: JSON.stringify(record),
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    ListGrid_person_refresh();
                                    var OK = isc.Dialog.create({
                                        message: '<spring:message code="global.form.request.successful"/>',
                                        icon: "[SKIN]say.png",
                                        title: '<spring:message code="global.form.command.done"/>'
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    isc.say(resp.data);
                                }
                            }
                        });
                    }
                }
            });
        }

    }else {
        isc.Dialog.create({
            message: "<spring:message code='global.grid.record.not.selected'/>",
            icon: "[SKIN]ask.png",
            title: "<spring:message code='global.message'/>",
            buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
            buttonClick: function (button, index) {
                this.hide();
            }
        });
    }
}
var Menu_ListGrid_department = isc.Menu.create({
    width: 150,
    data: [
        {
            title: '<spring:message code="global.form.refresh" />', icon: "pieces/16/refresh.png", click: function () {
                ListGrid_person_refresh();
            }
        }, {
            title: '<spring:message code="global.form.new" />', icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_person_new();
            }
        },
        {
            title: '<spring:message code="global.form.remove" />', icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_person_remove();
            }
        }
    ]
});
var dep_person_ListGrid = isc.ListGrid.create({
    width:"100%",
    height:"90%",
    paddingAsLayoutMargin:5,
    alternateRecordStyles:true,
    autoFetchData: false,
    canAutoFitFields: false,
    showFilterEditor:true,
    contextMenu: Menu_ListGrid_department,
    showHover : true,
    fields: [],
    canReorderFields: true,
    showRowNumbers : true,
    dataPageSize: 400,
    rowNumberFieldProperties:{
        autoFitWidthApproach :"both",
        canDragResize :true,
        autoFitWidth :true,
        headerTitle :"<spring:message code='global.grid.row'/>",
        align :"center",
        width : 50
    },
});

//*********************************person____ToolStripButton******************************

var personGridAddButton = isc.ToolStripButtonAdd.create({
    icon: "pieces/16/icon_add.png",
    title: "<spring:message code='evaluation.person.special.add'/>",
    click:function(){
        ListGrid_person_new();
    }
});

var personGridRemoveButton = isc.ToolStripButtonRemove.create({
    icon: "pieces/16/icon_delete.png",
    title: "<spring:message code='global.form.remove'/>",
    click:function()
    {
        ListGrid_person_remove();
    }
});
var personGridRevertButton = isc.ToolStripButton.create({
    icon: "pieces/512/undo.png",
    title: "<spring:message code='evaluation.person.revert'/>",
    click:function()
    {
        ListGrid_person_revert();
    }
});

var  personGridRefreshButton = isc.ToolStripButtonRefresh.create({
    icon: "[SKIN]/actions/refresh.png",
    title: "<spring:message code='global.form.refresh'/>",
    click: function(){
        ListGrid_person_refresh();
    }
});
var personGridToolStrip = isc.ToolStrip.create({

    width: "90%",
    members: [
        personGridAddButton,
        personGridRemoveButton,
        personGridRevertButton,
        isc.ToolStrip.create({
            width:"100%",
            align:"left",
            members:[            personGridRefreshButton,
            ],
        }),
    ]
});
var personGridButtonHLayout = isc.HLayout.create({
    width: "100%",
    height: 50,
    border:"0px solid yellow",
    layoutMargin:5,
    members: [
        personGridToolStrip
    ]
});


var person_Vlayout = isc.VLayout.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    width: "100%",
    alignLayout: "center",
    padding: 10,
    membersMargin: 10,
    members: [personGridButtonHLayout ,dep_person_ListGrid ]
});
//**********************************************************************************************
var users_Tabs = isc.TabSet.create({
    height: "100%",
    width: "100%",
    showTabScroller: false,
    tabs: [
            {
                title: "<spring:message code='user.manager'/>",
                pane: departmentGridVLayout
            },
            {
                title: "<spring:message code='user.subset'/>",
                pane: person_Vlayout
            },
        /*{*/
        /*title: "<spring:message code='user.changes'/>",*/
/*pane: departmentGridVLayout*/
/*}*/
]
});

var departmentBodyHLayout = isc.HLayout.create({
    width: "100%",
    height: "100%",
    border:"1px solid blue",
    layoutMargin:0,
    members: [
        departmentTreeGrid,
        users_Tabs
    ]
});
