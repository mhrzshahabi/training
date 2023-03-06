<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>


    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Management_class_req = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "trainingRequestTypeTitle"},
            {name: "requesterNationalCode"},
            {name: "requesterSupervisorNationalCode"},
            {name: "requesterSupervisorFullName"},
            {name: "requesterSupervisorComment"},
            {name: "runSupervisorComment"},
            {name: "runExpertNationalCode"},
            {name: "runExpertComment"},
            {name: "objectCode"},
            {name: "objectName"},
            {name: "trainingRequestStateTitle"},
            {name: "description"},
            {name: "createdDate"}
        ],
        fetchDataURL: elsUrl + "/run-supervisor/task-list/by-type/Class"
    });

    //
    let RestDataSource_TrainingClassRequestManagement = isc.TrDS.create({
        ID: "RestDataSource_TrainingClassRequestManagement",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nationalCode", hidden: true},
            {name: "firstName", title: "نام"},
            {name: "lastName", title: "نام خانوادگی"},
        ],
    });


    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Accept_training_class_Managment = isc.ToolStripButtonCreate.create({
        title: "تایید درخواست",
        click: function () {
            if (ListGrid_training_Managment_class_req.getSelectedRecord() !== undefined && ListGrid_training_Managment_class_req.getSelectedRecord() !== null) {
if (ListGrid_training_Managment_class_req.getSelectedRecord().trainingRequestTypeTitle!== undefined && ListGrid_training_Managment_class_req.getSelectedRecord().trainingRequestTypeTitle!==null &&
    ListGrid_training_Managment_class_req.getSelectedRecord().trainingRequestStateTitle!=="درانتظار بررسی کارشناس اجرا"){
    
    addTrainingClassRequestManagement();

}else {
    createDialog("info", "در صورتی که درخواست در وضعیت (( درانتظار بررسی کارشناس اجرا )) باشد نیاز به تایید درخواست وجود ندارد و بعد اضافه شدن فراگیر به کلاس به صورت اتوماتیک درخواست تایید خواهد شد");

}

            }else {
                isc.Dialog.create({
                    message: "رکوردی انتخاب نشده است!",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            }
        }
    });

    ToolStripButton_Refresh_Managment_class_req = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_training_Managment_class_req.invalidateCache();
        }
    });

    ToolStrip_Actions_Requests_Managment_class_req = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Accept_training_class_Managment,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Managment_class_req
                ]
            })
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_training_Managment_class_req = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Management_class_req,
        autoFetchData: true,
        alternateRecordStyles: true,
        wrapCells: false,
        showRollOver: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFitExpandField: true,
        virtualScrolling: true,
        loadOnExpand: true,
        loaded: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        recordClick: function () {
            // selectionUpdated_Management();
        },
        fields: [
            {
                name: "id",
                primaryKey: true,
                canEdit: false,
                hidden:true,
                width: "10%",
                align: "center"
            },
            {
                name: "trainingRequestTypeTitle",
                title: " نوع درخواست ",
                hidden:true,
                width: "10%",
                align: "center"
            },
            {
                name: "requesterNationalCode",
                title: "کد ملی درخواست دهنده",
                width: "10%",
                align: "center"
            },

            {
                name: "requesterSupervisorNationalCode",
                title: " کد ملی سرپرست درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "requesterSupervisorFullName",
                title: "سرپرست درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "requesterSupervisorComment",
                title: "نظر سرپرست درخواست دهنده",
                width: "10%",
                hidden:true,
                align: "center"
            },
            {
                name: "runSupervisorComment",
                title: "نظر سرپرست اجرا",
                width: "10%",
                hidden:true,
                align: "center"
            },
            {
                name: "runExpertNationalCode",
                title: "کد ملی کارشناس اجرا",
                width: "10%",
                hidden:true,
                align: "center"
            },
            {
                name: "runExpertComment",
                title: "نظر کارشناس اجرا",
                width: "10%",
                hidden:true,
                align: "center"
            },
            {
                name: "objectCode",
                title: "کد",
                width: "10%",
                align: "center"
            }
            ,{
                name: "objectName",
                title: "عنوان",
                width: "10%",
                align: "center"
            },
            {
                name: "trainingRequestStateTitle",
                title: "وضعیت درخواست",
                width: "10%",
                align: "center"
            },
            {
                name: "description",
                title: "توضیحات",
                width: "10%",
                align: "center"
            },
            {
                name: "createdDate",
                title: "تاریخ ایجاد",
                width: "10%",
                align: "center"
            }

        ],

    });


    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Managment_class_req = isc.VLayout.create({
        width: "100%",
        height: "1%",
        members: [
            ToolStrip_Actions_Requests_Managment_class_req,
            ListGrid_training_Managment_class_req
        ]
    });

    HLayout_Body_Managment_class_req_Jsp = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        members: [
            isc.SectionStack.create({
                sections: [
                    {
                        title: "درخواست های دوره آموشی",
                        items: VLayout_Managment_class_req,
                        showHeader: false,
                        expanded: true
                    }
                ]
            })
        ]
    });

    VLayout_Body_Managment_class_req_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Body_Managment_class_req_Jsp
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------


    function addTrainingClassRequestManagement() {
        let Window_TrainingClassRequestManagement = isc.Window.create({
            title: "انتخاب کارشناس اجرا",
            width: "50%",
            height: "50%",
            keepInParentRect: true,
            isModal: false,
            autoSize: false,
            items: [
                isc.TrVLayout.create({
                    members: [
                        isc.TrLG.create({
                            ID: "ListGrid_AllHeadTRClassM",
                            dataSource: RestDataSource_TrainingClassRequestManagement,
                            showHeaderContextMenu: false,
                            selectionType: "single",
                            filterOnKeypress: true,
                            autoFetchData:true,
                            canDragRecordsOut: true,
                            dragDataAction: "none",
                            canAcceptDroppedRecords: true,
                            fields: [
                                {name: "id", title: "کد", autoFitData: true, autoFitWidthApproach: true,hidden: true},
                                {name: "firstName", title: "نام"},
                                {name: "lastName", title: "نام خانوادگی"},
                                {name: "nationalCode",hidden: true},
                            ],
                            gridComponents: ["filterEditor", "header", "body"],

                        }),
                        isc.DynamicForm.create({
                            ID: "reasonTRCMForm",
                            width: "100%",
                             autoFocus: "true",
                            cellPadding: 5,
                            fields: [
                                {
                                    name: "runSupervisorComment",
                                    title: "نظر سرپرست اجرا",
                                    type: "text",
                                    required: false,
                                    validators: [{
                                        validateOnExit: true,
                                        type: "lengthRange",
                                        min: 1,
                                        max: 250,
                                        stopOnError: true,
                                        errorMessage: "حداکثر تعداد کاراکتر مجاز 250 می باشد. "
                                    }]
                                }
                            ]
                        }),
                        isc.HLayout.create({
                            layoutMargin: 5,
                            showEdges: false,
                            edgeImage: "",
                            width: "100%",
                            height:"10%",
                            align: "center",
                            padding: 10,
                            membersMargin: 10,
                            members: [
                                isc.IButton.create({
                                    title: "تایید",
                                    click: function () {
                                        if (ListGrid_AllHeadTRClassM.getSelectedRecord() !== undefined && ListGrid_AllHeadTRClassM.getSelectedRecord() !== null) {
                                            let data = {};
                                            data.id = ListGrid_training_Managment_class_req.getSelectedRecord().id;
                                            data.runSupervisorComment = reasonTRCMForm.getField("runSupervisorComment").getValue();
                                            data.runExpertNationalCode = ListGrid_AllHeadTRClassM.getSelectedRecord().nationalCode;
                                            reviewRunSupervisorFoClass(data,Window_TrainingClassRequestManagement)


                                        }else {
                                            isc.Dialog.create({
                                                message: "رکوردی انتخاب نشده است!",
                                                icon: "[SKIN]ask.png",
                                                title: "توجه",
                                                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                                                buttonClick: function (button, index) {
                                                    this.close();
                                                }
                                            });
                                        }
                                    }
                                })
                                , isc.IButtonCancel.create({
                                    title: "<spring:message code='cancel'/>",
                                    prompt: "",
                                    width: 100,
//icon: "<spring:url value="remove.png"/>",
                                    orientation: "vertical",
                                    click: function () {
                                        Window_TrainingClassRequestManagement.close()
                                    }
                                })]
                        })
                    ]
                })]
        });

        RestDataSource_TrainingClassRequestManagement.fetchDataURL=operationalRoleUrl + "/findAllByClassTypeAndPermission/"+"EXECUTION_EXPERT"+"/"+ListGrid_training_Managment_class_req.getSelectedRecord().objectCode;
        ListGrid_AllHeadTRClassM.invalidateCache();
        Window_TrainingClassRequestManagement.show();
    }

    function reviewRunSupervisorFoClass(dataReq,form) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(elsUrl + "/review/run-Supervisor", "POST", JSON.stringify(dataReq), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                form.close();
                ListGrid_training_Managment_class_req.invalidateCache();
                isc.say("عملیات با موفقیت انجام شد.");

            } else {
                wait.close();
                createDialog("info", "خطایی رخ داده است");
            }

        }));
    }


    // </script>