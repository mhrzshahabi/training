<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    let saveMethod = null;
    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Competence_Request = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "applicant", title: "درخواست دهنده", filterOperator: "iContains"},
            {name: "requestDate", title: "تاریخ درخواست", filterOperator: "iContains"},
            {name: "requestType", title: "نوع درخواست", filterOperator: "iContains",
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تغییر وضعیت"
                }
            },
            {name: "letterNumber", title: "شماره نامه کارگزینی", filterOperator: "iContains"}
        ],
        fetchDataURL: competenceRequestUrl + "/spec-list"
    });
    RestDataSource_Competence_Request_Item = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "processInstanceId", hidden: true},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "personnelNo2", title: "شماره پرسنلی قدیم", filterOperator: "iContains"},
            {name: "personnelNumber", title: "شماره پرسنلی جدید", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "educationLevel", title: "مدرک تحصیلی", filterOperator: "iContains"},
            {name: "educationMajor", title: "رشته", filterOperator: "iContains"},
            {name: "currentPostTitle", title: "پست فعلی", filterOperator: "iContains"},
            {name: "postTitle", title: "پست پیشنهادی", filterOperator: "iContains"},
            {name: "affairs", title: "امور", filterOperator: "iContains"},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "operationalRoleTitles", title: "گروه های کاری"},
            {name: "planningChiefOpinion", title: "نظر رئیس برنامه ریزی"},
            {name: "processStatusTitle", title: "وضعیت فرایند در گردش کار"},
            {name: "competenceReqId", hidden: true}
        ],
        fetchDataURL: requestItemUrl + "/spec-list"
    });
    RestDataSource_Competence_Request_Item_Audit = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "personnelNumber", title: "شماره پرسنلی 10 رقمی", filterOperator: "iContains"},
            {name: "personnelNo2", title: "شماره پرسنلی 6 رقمی", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "affairs", title: "امور", filterOperator: "iContains"},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "state.titleFa", title: "وضعیت", filterOperator: "iContains"},
            {name: "lastModifiedDate", title: "تغییر داده شده درتاریخ"},
            {name: "lastModifiedBy", title: "تغییر داده شده توسط"},
            {name: "revType", title: "نوع تغییر"},
            {name: "deleted", hidden: true}
        ]
    });
    RestDataSource_Competence_Request_Item_Valid_Data = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "personnelNo2", title: "شماره پرسنلی قدیم", filterOperator: "iContains"},
            {name: "personnelNumber", title: "شماره پرسنلی جدید", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "currentPostTitle", title: "پست فعلی", filterOperator: "iContains"},
            {name: "postTitle", title: "پست پیشنهادی", filterOperator: "iContains"},
            {name: "affairs", title: "امور", filterOperator: "iContains"},
            {name: "post", title: "کدپست پیشنهادی", filterOperator: "iContains"},
            {name: "competenceReqId", hidden: true}
        ]
    });
    RestDataSource_Competence_Request_Category = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_Competence_Request_PersonnelJobExperiences = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personnelNo", title: "شماره پرسنلی"},
            {name: "ssn", title: "کدملی"},
            {name: "assignmentDate", title: "تاریخ شروع"},
            {name: "dismissalDate", title: "تاریخ پایان"},
            {name: "postCode", title: "کد پست"},
            {name: "postTitle", title: "عنوان پست"},
            {name: "jobNo", title: "کد شغل"},
            {name: "jobTitle", title: "عنوان شغل"},
            {name: "departmentTitle", title: "نام دپارتمان"},
            {name: "departmentCode", title: "کد دپارتمان"},
            {name: "omur", title: "امور"},
            {name: "ghesmat", title: "قسمت"},
            {name: "companyName", title: "نام شرکت"}
        ]
    });
    RestDataSource_Competence_Request_PostInfo = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "personnelNo", title: "شماره پرسنلی"},
            {name: "firstName", title: "نام"},
            {name: "lastName", title: "نام خانوادگی"},
            {name: "nationalCode", title: "کدملی"},
            {name: "assignmentDate", title: "تاریخ شروع"},
            {name: "dismissalDate", title: "تاریخ پایان"},
            {name: "postCode", title: "کدپست"},
            {name: "postTitle", title: "عنوان پست"},
            {name: "jobNo", title: "کد شغل"},
            {name: "jobTitle", title: "عنوان شغل"},
            {name: "departmentTitle", title: "نام دپارتمان"},
            {name: "departmentCode", title: "کد دپارتمان", hidden: true},
            {name: "omur", title: "امور"},
            {name: "ghesmat", title: "قسمت"},
            {name: "companyName", title: "نام شرکت"}]
    });
    RestDataSource_Competence_Request_PersonnelTraining = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "courseId"},
            {name: "courseTitle"},
            {name: "courseCode"},
            {name: "code"},
            {name: "titleClass"},
            {name: "hduration"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "classStatusId"},
            {name: "classStatus"},
            {name: "scoreStateId"},
            {name: "scoreState"},
            {name: "erunType"}
        ]
    });

    //--------------------------------------------------------Actions---------------------------------------------------

    ToolStripButton_Add_Competence_Request = isc.ToolStripButtonCreate.create({
        title: "افزودن درخواست",
        click: function () {
            saveMethod = "POST";
            addCompetenceRequest();
        }
    });
    ToolStripButton_Edit_Competence_Request = isc.ToolStripButtonEdit.create({
        click: function () {
            saveMethod = "PUT";
            editCompetenceRequest();
        }
    });
    ToolStripButton_Delete_Competence_Request = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteCompetenceRequest();
        }
    });
    ToolStripButton_Excel_Competence_Request = isc.ToolStripButton.create({
        name: "excelTemplate",
        title: "دریافت فایل خام اکسل",
        icon: "<spring:url value="excel.png"/>",
        click: function () {
            // let headers = ["کدملی", "شماره پرسنلی قدیم", "شماره پرسنلی جدید", "نام", "نام خانوادگی", "مدرک تحصیلی", "رشته", "پست فعلی", "پست پیشنهادی", "امور", "کدپست پیشنهادی"];
            // let fieldNames = ["nationalCode", "personnelNo2", "personnelNumber", "name", "lastName", "educationLevel", "educationMajor", "currentPostTitle", "postTitle", "affairs", "post" ];
            window.open("excel/certification-input.xlsx");
        }
    });
    ToolStripButton_Refresh_Competence_Request = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Competence_Request.invalidateCache();
        }
    });

    ToolStrip_Actions_Requests_Certification = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('CompetenceRequest_C')">
            ToolStripButton_Add_Competence_Request,
            </sec:authorize>
            <%--<sec:authorize access="hasAuthority('CompetenceRequest_U')">--%>
            // ToolStripButton_Edit_Competence_Request,
            <%--</sec:authorize>--%>
            <sec:authorize access="hasAuthority('CompetenceRequest_D')">
            ToolStripButton_Delete_Competence_Request,
            </sec:authorize>
            <sec:authorize access="hasAuthority('CompetenceRequest_P')">
            ToolStripButton_Excel_Competence_Request,
            </sec:authorize>
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('CompetenceRequest_R')">
                    ToolStripButton_Refresh_Competence_Request
                    </sec:authorize>
                ]
            })
        ]
    });
    Menu_Requests_Certification = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    ListGrid_Competence_Request.invalidateCache();
                }
            },
            {
                title: "تاریخچه تغییرات آیتم های درخواست",
                click: function () {
                    let competenceId = ListGrid_Competence_Request.getSelectedRecord().id;
                    showRequestItemsAudit(competenceId);
                }
            }
        ]
    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Competence_Request = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "applicant",
                title: "درخواست دهنده",
                required: true,
                canEdit: false
            },
            {
                name: "requestDate",
                ID: "date_requestDate",
                title: "تاریخ درخواست",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_requestDate', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "requestType",
                title: "نوع درخواست",
                required: true,
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تغییر وضعیت"
                }
            },
            {
                name: "letterNumber",
                title: "شماره نامه کارگزینی",
                required: true,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }]
            }
        ]
    });

    Save_Button_Add_Requests = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveCompetenceRequest();
        }
    });
    Cancel_Button_Add_Requests = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Competence_Request.close();
        }
    });
    HLayout_IButtons_Competence_Request = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Requests,
            Cancel_Button_Add_Requests
        ]
    });

    Window_Competence_Request = isc.Window.create({
        title: "افزودن درخواست",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Competence_Request,
            HLayout_IButtons_Competence_Request
        ]
    });

    //------------------------------------------------------List Grids--------------------------------------------------

    Menu_Competence_Request_Items = isc.Menu.create({
        data: [
            {
                title: "بروز رسانی گروه های کاری",
                click: function () {
                    updateOperationalRoles();
                }
            }
        ]
    });

    ListGrid_Competence_Request = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('CompetenceRequest_R')">
        dataSource: RestDataSource_Competence_Request,
        contextMenu: Menu_Requests_Certification,
        </sec:authorize>
        autoFetchData: true,
        styleName: 'expandList',
        alternateRecordStyles: true,
        canExpandRecords: true,
        canExpandMultipleRecords: false,
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
        fields: [
            {
                name: "id",
                title: "شماره درخواست",
                primaryKey: true,
                canEdit: false,
                width: "10%",
                align: "center"
            },
            {
                name: "applicant",
                title: "درخواست دهنده",
                width: "10%",
                align: "center"
            },
            {
                name: "requestDate",
                title: "تاریخ درخواست",
                width: "10%",
                align: "center",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toLocaleDateString('fa-IR');
                    }
                }
            },
            {
                name: "requestType",
                title: "نوع درخواست",
                width: "10%",
                align: "center",
                valueMap: {
                    1 : "انتصاب سمت",
                    2 : "تغییر وضعیت"
                }
            },
            {
                name: "letterNumber",
                title: "شماره نامه کارگزینی",
                width: "10%",
                align: "center"
            }
        ],
        getExpansionComponent: function (record) {

            let criteriaReq = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "competenceReqId", operator: "equals", value: record.id}]
            };
            ListGrid_Competence_Request_Items.fetchData(criteriaReq, function (dsResponse, data, dsRequest) {
                if (data.length == 0) {
                    ListGrid_Competence_Request_Items.setData([]);
                    ListGrid_Competence_Request_Items.show();
                } else {
                    ListGrid_Competence_Request_Items.setData(data);
                    ListGrid_Competence_Request_Items.setAutoFitMaxRecords(1);
                    ListGrid_Competence_Request_Items.show();
                }
            }, {operationId: "00"});

            let ToolStrip_Actions_Import_Data = isc.HLayout.create({
                width: "100%",
                members: [
                    isc.DynamicForm.create({
                        width: "20%",
                        numCols: 8,
                        fields: [
                            <sec:authorize access="hasAuthority('CompetenceRequest_C')">
                            {
                                ID:"certificationExcelFile",
                                name: "certificationExcelFile",
                                type: "file",
                                title: "انتخاب فایل",
                                endRow: false,
                                colSpan: 1,
                                titleColSpan: 1
                            },
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('CompetenceRequest_C')">
                            {
                                name: "import",
                                title: "وارد کردن اطلاعات",
                                type: "ButtonItem",
                                width: 120,
                                startRow: false,
                                colSpan: 1,
                                click:function () {
                                    let address=certificationExcelFile.getValue();
                                    if(address==null) {
                                        createDialog("info", "فايل خود را انتخاب نماييد.");
                                    } else {
                                        let ExcelToJSON = function() {

                                            this.parseExcel = function(file) {
                                                let reader = new FileReader();
                                                let records = [];

                                                reader.onload = function(e) {
                                                    let data = e.target.result;
                                                    let workbook = XLSX.read(data, {
                                                        type: 'binary'
                                                    });
                                                    let isEmpty = true;
                                                    workbook.SheetNames.forEach(function(sheetName) {
                                                        let XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                        for (let i=0;i<XL_row_object.length;i++) {
                                                            if(ListGrid_Competence_Request_Items.getData().filter(c =>
                                                                c.nationalCode === Object.values(XL_row_object[i])[0]).length === 0) {
                                                                let current = {
                                                                    nationalCode: XL_row_object[i]["کدملی (اجباری)"],
                                                                    personnelNo2: XL_row_object[i]["شماره پرسنلی قدیم"],
                                                                    personnelNumber: XL_row_object[i]["شماره پرسنلی جدید"],
                                                                    name: XL_row_object[i]["نام"],
                                                                    lastName: XL_row_object[i]["نام خانوادگی"],
                                                                    educationLevel: XL_row_object[i]["مدرک تحصیلی"],
                                                                    educationMajor: XL_row_object[i]["رشته"],
                                                                    currentPostTitle: XL_row_object[i]["پست فعلی"],
                                                                    postTitle: XL_row_object[i]["پست پیشنهادی"],
                                                                    affairs: XL_row_object[i]["امور"],
                                                                    post: XL_row_object[i]["کدپست پیشنهادی"],
                                                                    competenceReqId:ListGrid_Competence_Request.getSelectedRecord().id
                                                                };
                                                                records.add(current);
                                                                isEmpty=false;
                                                                continue;
                                                            }
                                                            else{
                                                                isEmpty=false;
                                                                continue;
                                                            }
                                                        }
                                                        certificationExcelFile.setValue('');
                                                    });

                                                    if(records.length > 0) {

                                                        // let uniqueRecords = [];
                                                        // for (let i=0; i < records.length; i++) {
                                                        //     if (uniqueRecords.filter(function (item) {return item.personnelNumber === records[i].personnelNumber ;}).length===0) {
                                                        //         uniqueRecords.push(records[i]);
                                                        //     }
                                                        // }
                                                        wait.show();
                                                        isc.RPCManager.sendRequest(TrDSRequest(requestItemUrl + "/list", "POST", JSON.stringify(records), function (resp) {
                                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                                wait.close();
                                                                let result = JSON.parse(resp.data);
                                                                setRequestItemData(result);
                                                            } else {
                                                                wait.close();
                                                                createDialog("info", "خطایی رخ داده است");
                                                            }
                                                        }));

                                                    } else {

                                                        if(isEmpty) {
                                                            createDialog("info", "خطا در محتویات فایل");
                                                        } else {
                                                            createDialog("info", "فرد جدیدی برای اضافه کردن وجود ندارد.");
                                                        }
                                                    }
                                                };
                                                reader.onerror = function(ex) {
                                                    createDialog("info", "خطا در باز کردن فایل");
                                                };
                                                reader.readAsBinaryString(file);
                                            };
                                        };

                                        let split=$('[name="certificationExcelFile"]')[0].files[0].name.split('.');
                                        if(split[split.length-1]=='xls'||split[split.length-1]=='csv'||split[split.length-1]=='xlsx'){
                                            let xl2json = new ExcelToJSON();
                                            xl2json.parseExcel($('[name="certificationExcelFile"]')[0].files[0]);
                                        }else{
                                            createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                        }
                                    }
                                }
                            },
                            </sec:authorize>
                        ]
                    }),
                    isc.DynamicForm.create({
                        ID:"trainingPostNeedAssessmentStatus",
                        width: "20%",
                        numCols: 4,
                        fields: [
                            {
                                name: "statusTitle",
                                title: "وضعیت نیازسنجی پست پیشنهادی",
                                type: "staticText",
                                colSpan: 4
                            },
                            {
                                name: "modifiedDate",
                                title: "تاریخ بروزرسانی:",
                                type: "staticText",
                                colSpan: 1
                            },
                            {
                                name: "modifiedBy",
                                title: "بروزرسانی کننده:",
                                type: "staticText",
                                colSpan: 1
                            }
                        ]
                    }),
                    isc.DynamicForm.create({
                        ID:"processStatus",
                        width: "10%",
                        numCols: 2,
                        fields: [
                            {
                                name: "processStatusTitle",
                                title: "وضعیت فرایند در گردش کار:",
                                type: "staticText",
                                hidden: true,
                                colSpan: 2
                            }
                        ]
                    }),
                    isc.Button.create({
                        title: "ارسال گروهی به گردش کار",
                        width: "150",
                        click: function () {
                            let records = ListGrid_Competence_Request_Items.getData();
                            sendGroupRequestItemProcess(records);
                        }
                    }),
                    <sec:authorize access="hasAuthority('CompetenceRequest_P')">
                    isc.ToolStripButtonExcel.create({
                        align: "left",
                        click: function () {
                            exportToExcelRequestItems();
                        }
                    }),
                    </sec:authorize>
                ]
            });

            let layoutCompetenceRequest = isc.VLayout.create({
                styleName: "expand-layout",
                padding: 5,
                members: [
                    ListGrid_Competence_Request_Items,
                    ToolStrip_Actions_Import_Data
                ]
            });
            return layoutCompetenceRequest;
        }
    });
    ListGrid_Competence_Request_Items = isc.TrLG.create({
        showFilterEditor: true,
        canAutoFitFields: true,
        width: "100%",
        styleName: "listgrid-child",
        height: 250,
        <sec:authorize access="hasAuthority('CompetenceRequest_R')">
        dataSource: RestDataSource_Competence_Request_Item,
        contextMenu: Menu_Competence_Request_Items,
        </sec:authorize>
        setAutoFitExtraRecords: true,
        editEvent: "doubleClick",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true
            },
            {
                name: "processInstanceId",
                hidden: true
            },
            {
                name: "nationalCode",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelNo2",
                width: "10%",
                align: "center"
            },
            {
                name: "personnelNumber",
                width: "10%",
                align: "center"
            },
            {
                name: "name",
                width: "10%",
                align: "center"
            },
            {
                name: "lastName",
                width: "10%",
                align: "center"
            },
            {
                name: "educationLevel",
                width: "10%",
                align: "center"
            },
            {
                name: "educationMajor",
                width: "10%",
                align: "center"
            },
            {
                name: "currentPostTitle",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "postTitle",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "affairs",
                width: "10%",
                align: "center"
            },
            {
                name: "post",
                width: "10%",
                align: "center"
            },
            {
                name: "operationalRoleTitles",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "planningChiefOpinion",
                width: "10%",
                align: "center"
            },
            {
                name: "state",
                width: "10%",
                align: "center",
                hidden: true,
                canEdit: false,
                canFilter: false,
                valueMap: {
                    "نیاز به گذراندن دوره": "نیاز به گذراندن دوره",
                    "بلامانع": "بلامانع",
                    "پست موجود نیست": "پست موجود نیست"
                }
            },
            {
                name: "competenceReqId",
                hidden: true
            },
            {
                name: "infoIcon",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false
            },
            {
                name: "editIcon",
                width: "4%",
                align: "center",
                hidden: true,
                showTitle: false,
                canFilter: false
            },
            {
                name: "removeIcon",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false
            },
            {
                name: "sendIcon",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false
            }
        ],
        autoFetchData: false,
        recordClick: function () {
            selectionUpdated_Competence_Request();
        },
        getCellCSSText: function (record, rowNum, colNum) {

            if (record.processInstanceId !== undefined)
                return "background-color:#92f0ab";

            if (this.getFieldName(colNum) === "nationalCode") {
                if (record.nationalCodeCorrect != null && !record.nationalCodeCorrect)
                    return "background-color:#fa5f71;";
            } else if (this.getFieldName(colNum) === "personnelNumber") {
                if (record.personnelNumberCorrect != null && !record.personnelNumberCorrect)
                    return "background-color:#fa5f71;";
            } else if (this.getFieldName(colNum) === "personnelNo2") {
                if (record.personnelNo2Correct != null && !record.personnelNo2Correct)
                    return "background-color:#fa5f71;";
            } else if (this.getFieldName(colNum) === "name") {
                if (record.nameCorrect != null && !record.nameCorrect)
                    return "background-color:#fa5f71;";
            } else if (this.getFieldName(colNum) === "lastName") {
                if (record.lastNameCorrect != null && !record.lastNameCorrect)
                    return "background-color:#fa5f71;";
            } else if (this.getFieldName(colNum) === "affairs") {
                if (record.affairsCorrect != null && !record.affairsCorrect)
                    return "background-color:#fa5f71;";
            }
        },
        rowEditorExit: function (editCompletionEvent, record, newValues, rowNum) {

            if (editCompletionEvent == "enter") {

                delete newValues["id"];

                if (newValues && Object.keys(newValues).length === 0 && Object.getPrototypeOf(newValues) === Object.prototype)
                    ListGrid_Competence_Request_Items.endEditing();

                else {
                    let recordData = newValues;
                    if (record != null) {
                        recordData = Object.assign(record, newValues);
                    }

                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(requestItemUrl + "/" + recordData.id, "PUT", JSON.stringify(recordData), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            wait.close();
                            createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            ListGrid_Competence_Request_Items.invalidateCache();
                        } else {
                            wait.close();
                            createDialog("info", "خطایی رخ داده است");
                        }
                    }));
                }
            }
        },
        createRecordComponent: function (record, colNum) {

            let fieldName = this.getFieldName(colNum);
            if (fieldName === "infoIcon") {
                <sec:authorize access="hasAuthority('CompetenceRequest_R')">
                let infoImg = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/exclamation.png",
                    prompt: "مشاهده اطلاعات صحیح",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        ListGrid_Competence_Request_Items.selectSingleRecord(record);
                        let requestItemId = ListGrid_Competence_Request_Items.getSelectedRecord().id;
                        validRequestItemData(requestItemId);
                    }
                });
                return infoImg;
                </sec:authorize>
            } else if (fieldName === "editIcon") {
                <sec:authorize access="hasAuthority('CompetenceRequest_U')">
                let editImg = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/edit.png",
                    prompt: "ویرایش",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        editRequestItem(record);
                    }
                });
                return editImg;
                </sec:authorize>
            } else if (fieldName === "removeIcon") {
                <sec:authorize access="hasAuthority('CompetenceRequest_D')">
                let removeImg = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    prompt: "حذف",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        ListGrid_Competence_Request_Items.selectSingleRecord(record);
                        deleteRequestItem(record);
                    }
                });
                return removeImg;
                </sec:authorize>
            } else if (fieldName === "sendIcon") {
                let sendImg = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/approve.png",
                    prompt: "ارسال به گردش کار",
                    height: 16,
                    width: 16,
                    click: function () {
                        ListGrid_Competence_Request_Items.selectSingleRecord(record);
                        sendRequestItemProcess(record);
                    }
                });
                return sendImg;
            } else {
                return null;
            }
        }
    });

    //--------------------------------------------------------Tab Set---------------------------------------------------

    ToolStrip_Personnel_Job_History_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    exportToExcelPersonnelJobHistory();
                }.bind(this)
            })
        ]
    });
    ToolStrip_Post_History_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    exportToExcelPostHistory();
                }.bind(this)
            }),
            isc.Label.create({
                width: "100"
            }),
            isc.Label.create({
                ID:"postStatus",
                wrap: false,
                icon: "",
                contents: "وضعیت پست:",
                dynamicContents: true
            }),
            isc.Label.create({
                width: "200"
            }),
            isc.DynamicForm.create({
                ID:"needAStatus",
                width: "40%",
                height: "100%",
                numCols: 8,
                fields: [
                    {
                        name: "statusTitle",
                        title: "وضعیت نیازسنجی پست",
                        type: "staticText",
                        colSpan: 8
                    },
                    {
                        name: "modifiedDate",
                        ID:"needADate",
                        title: "تاریخ بروزرسانی:",
                        type: "staticText",
                        colSpan: 1
                    },
                    {
                        name: "modifiedBy",
                        ID:"needABy",
                        title: "بروزرسانی کننده:",
                        type: "staticText",
                        colSpan: 1
                    }
                ]
            })
        ]
    });
    ToolStrip_Personnel_Training_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    exportToExcelPersonnelTraining();
                }.bind(this)
            })
        ]
    });

    ListGrid_Personnel_Job_History = isc.TrLG.create({
        dataSource: RestDataSource_Competence_Request_PersonnelJobExperiences,
        selectionType: "single",
        autoFetchData: false,
        width: "100%",
        height: "100%",
        initialSort: [
            {property: "assignmentDate", direction: "ascending"}
        ],
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "personnelNo"},
            {name: "ssn"},
            {name: "assignmentDate"},
            {name: "dismissalDate"},
            {name: "postCode"},
            {name: "postTitle"},
            {name: "jobNo"},
            {name: "jobTitle"},
            {name: "departmentTitle"},
            {name: "departmentCode", hidden: true},
            {name: "omur"},
            {name: "ghesmat"},
            {name: "companyName"}

        ],
        gridComponents: [ToolStrip_Personnel_Job_History_Actions, "filterEditor", "header", "body"]
    });
    ListGrid_Post_History = isc.TrLG.create({
        dataSource: RestDataSource_Competence_Request_PostInfo,
        selectionType: "single",
        autoFetchData: false,
        width: "100%",
        height: "100%",
        initialSort: [
            {property: "assignmentDate", direction: "ascending"}
        ],
        gridComponents: [ToolStrip_Post_History_Actions, "filterEditor", "header", "body"],
        dataArrived: function (startRow, endRow, data) {
            let totalRows = this.data.getLength();

           if (this.data.localData.get(totalRows-1)!==undefined){
                if (this.data.localData.get(totalRows-1).dismissalDate===undefined){
                   postStatus.setContents("وضعیت پست : دارای انتصاب سمت");
               }else {
                   postStatus.setContents("وضعیت پست : بلاتصدی");
               }
           }

        },
    });
    ListGrid_Personnel_Training_History = isc.TrLG.create({
        dataSource: RestDataSource_Competence_Request_PersonnelTraining,
        selectionType: "single",
        autoFetchData: false,
        showGridSummary: true,
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code",
                title: "<spring:message code="class.code"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction:function (records) {
                    return competenceRequestTotalPlanning(records)
                }.bind(this)
            },
            {
                name: "courseId",
                title: "courseId",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "courseTitle",
                title: "<spring:message code="course.title"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: function(records){
                    return competenceRequestTotalPassed(records)
                }.bind(this)
            },
            {
                name: "courseCode",
                title: "<spring:message code="course.code"/>",
                align: "center",
                width: 100,
                filterOperator: "iContains"
            },
            {
                name: "titleClass",
                title: "<spring:message code='class.title'/>",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "hduration",
                title: "<spring:message code="class.duration"/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "classStatusId",
                title: "classStatusId",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "classStatus",
                title: "<spring:message code="class.status"/>",
                align: "center",
                filterOperator: "equals",
                summaryFunction: function(records){
                    return competenceRequestTotalRejected(records)
                }.bind(this)
            },
            {
                name: "scoreStateId",
                title: "scoreStateId",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "scoreState",
                title: "<spring:message code="score.state"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: function(records){
                    return competenceRequestTotalAll(records)
                }.bind(this)
            },
            {
                name: "erunType",
                title: "<spring:message code="course_eruntype"/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ],
        gridComponents: [ToolStrip_Personnel_Training_Actions, "filterEditor", "header", "body", "summaryRow"]
    });

    Requests_Detail_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_Personnel_Training_History", title: "دوره های گذرانده فرد", pane: ListGrid_Personnel_Training_History},
            {name: "TabPane_Personnel_Job_History", title: "سوابق شغلی پرسنل", pane: ListGrid_Personnel_Job_History},
            // {name: "TabPane_Post_History", title: "سوابق پست پیشنهادی", pane: ListGrid_Post_History},
        ],
        tabSelected: function () {
            selectionUpdated_Competence_Request();
        }
    });

    //------------------------------------------------------Main Layout-------------------------------------------------

    VLayout_Requests_Certification = isc.VLayout.create({
        width: "100%",
        height: "1%",
        members: [
            ToolStrip_Actions_Requests_Certification,
            ListGrid_Competence_Request
        ]
    });
    VLayout_Requests_Detail_Certification = isc.VLayout.create({
        width: "100%",
        members: [
            ListGrid_Competence_Request_Items
        ]
    });
    HLayout_Body_Certification_Jsp = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        members: [
            isc.SectionStack.create({
                sections: [
                    {
                        title: "درخواست های تاییدیه",
                        items: VLayout_Requests_Certification,
                        showHeader: false,
                        expanded: true
                    },
                    {
                        title: "جزئیات درخواست",
                        hidden: true,
                        items: VLayout_Requests_Detail_Certification,
                        expanded: false
                    }
                ]
            })
        ]
    });

    HLayout_Tabs_Certification = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [Requests_Detail_Tabs]
    });

    VLayout_Body_Certification_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Body_Certification_Jsp,
            HLayout_Tabs_Certification
        ]
    });

    //-------------------------------------------------------Functions--------------------------------------------------

    function addCompetenceRequest() {

        DynamicForm_Competence_Request.clearValues();
        DynamicForm_Competence_Request.clearErrors();
        DynamicForm_Competence_Request.setValue("applicant", userUserName);
        Window_Competence_Request.show();
    }
    function editCompetenceRequest() {

        let record = ListGrid_Competence_Request.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            record.requestDate = new Date(record.requestDate).toLocaleDateString('fa-IR');
            DynamicForm_Competence_Request.editRecord(record);
            Window_Competence_Request.show();
        }
    }
    function saveCompetenceRequest() {

        if (!DynamicForm_Competence_Request.validate())
            return;

        if (saveMethod === "POST") {

            let data = DynamicForm_Competence_Request.getValues();
            data.requestDate = JalaliDate.jalaliToGregori(data.requestDate);

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Competence_Request.close();
                    ListGrid_Competence_Request.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else {


            let record = ListGrid_Competence_Request.getSelectedRecord();

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl + "/" + record.id, "PUT", JSON.stringify(record), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Competence_Request.close();
                    ListGrid_Competence_Request.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }

    }
    function deleteCompetenceRequest() {

        let record = ListGrid_Competence_Request.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_Request_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(competenceRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Competence_Request.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            });
        }
    }

    function validRequestItemData(requestItemId) {

        let ListGrid_Request_Item_Valid_Data = isc.TrLG.create({
            canAutoFitFields: true,
            width: "100%",
            height: 70,
            <sec:authorize access="hasAuthority('CompetenceRequest_R')">
            dataSource: RestDataSource_Competence_Request_Item_Valid_Data,
            </sec:authorize>
            setAutoFitExtraRecords: true,
            autoFetchData: false,
            showFilterEditor: false,
            fields: [
                {
                    name: "id",
                    hidden: true,
                    primaryKey: true
                },
                {
                    name: "nationalCode",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.nationalCodeCorrect != null && !record.nationalCodeCorrect)
                            return record.correctNationalCode;
                        else
                            return value;
                    }
                },
                {
                    name: "personnelNo2",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.personnelNo2Correct != null && !record.personnelNo2Correct)
                            return record.correctPersonnelNo2;
                        else
                            return value;
                    }
                },
                {
                    name: "personnelNumber",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.personnelNumberCorrect != null && !record.personnelNumberCorrect)
                            return record.correctPersonnelNumber;
                        else
                            return value;
                    }
                },
                {
                    name: "name",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.nameCorrect != null && !record.nameCorrect)
                            return record.correctName;
                        else
                            return value;
                    }
                },
                {
                    name: "lastName",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.lastNameCorrect != null && !record.lastNameCorrect)
                            return record.correctLastName;
                        else
                            return value;
                    }
                },
                {
                    name: "currentPostTitle",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.currentPostTitleCorrect != null && !record.currentPostTitleCorrect)
                            return record.correctCurrentPostTitle;
                        else
                            return value;
                    }
                },
                {
                    name: "postTitle",
                    width: "10%",
                    align: "center",
                    hidden: true
                },
                {
                    name: "affairs",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (record.affairsCorrect != null && !record.affairsCorrect)
                            return record.correctAffairs;
                        else
                            return value;
                    }
                },
                {
                    name: "post",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "competenceReqId",
                    hidden: true
                },
            ],
            getCellCSSText: function (record, rowNum, colNum) {

                if (this.getFieldName(colNum) === "nationalCode") {
                    if (record.nationalCodeCorrect != null && !record.nationalCodeCorrect)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "personnelNo2") {
                    if (record.personnelNo2Correct != null && !record.personnelNo2Correct)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "personnelNumber") {
                    if (record.personnelNumberCorrect != null && !record.personnelNumberCorrect)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "name") {
                    if (record.nameCorrect != null && !record.nameCorrect)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "lastName") {
                    if (record.lastNameCorrect != null && !record.lastNameCorrect)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "currentPostTitle") {
                    if (record.currentPostTitleCorrect != null && !record.currentPostTitleCorrect)
                        return "background-color:#57f271;";
                } else if (this.getFieldName(colNum) === "affairs") {
                    if (record.affairsCorrect != null && !record.affairsCorrect)
                        return "background-color:#57f271;";
                }
            }
        });

        let Window_Request_Item_Valid_Data = isc.Window.create({
            width: "90%",
            height: 95,
            numCols: 2,
            title: "اطلاعات صحیح براساس کدملی یا شماره پرسنلی قدیم",
            items: [
                ListGrid_Request_Item_Valid_Data,
                isc.MyHLayoutButtons.create({
                    members: [
                        isc.IButtonCancel.create({
                            title: "<spring:message code="close"/>",
                            click: function () {
                                Window_Request_Item_Valid_Data.close();
                            }
                        })]
                })]
        });

        RestDataSource_Competence_Request_Item_Valid_Data.fetchDataURL = requestItemUrl + "/valid-data/" + requestItemId;
        ListGrid_Request_Item_Valid_Data.fetchData();
        Window_Request_Item_Valid_Data.show();
    }
    function editRequestItem(record) {

        let rowNum = ListGrid_Competence_Request_Items.getRowNum(record);
        let cellNum = 11;
        ListGrid_Competence_Request_Items.startEditing(rowNum, cellNum);
    }

    function refreshRequestItem() {
        ListGrid_Competence_Request_Items.invalidateCache();
        let record = ListGrid_Competence_Request.getSelectedRecord();
        if (record == null || record.id == null)
            return;
        let criteriaReq = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "competenceReqId", operator: "equals", value: record.id}]
        };
        ListGrid_Competence_Request_Items.fetchData(criteriaReq, function (dsResponse, data, dsRequest) {
            if (data.length == 0) {
                ListGrid_Competence_Request_Items.setData([]);
                ListGrid_Competence_Request_Items.show();
            } else {
                ListGrid_Competence_Request_Items.setData(data);
                ListGrid_Competence_Request_Items.setAutoFitMaxRecords(1);
                ListGrid_Competence_Request_Items.show();
            }
        }, {operationId: "00"});
    }
    function deleteRequestItem(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            if (record.processInstanceId === undefined || record.processInstanceId === null) {
                let Dialog_Competence_Request_Item_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                    "<spring:message code="verify.delete"/>");
                Dialog_Competence_Request_Item_remove.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(requestItemUrl + "/" + record.id, "DELETE", null, function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    wait.close();
                                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                    refreshRequestItem();
                                } else {
                                    wait.close();
                                    createDialog("info", "خطایی رخ داده است");
                                }
                            }));
                        }
                    }
                });
            } else {
                createDialog("info", "درخواست تایید صلاحیت به گردش کار ارسال شده است و امکان حذف آن وجود ندارد");
            }
        }
    }
    function setRequestItemData(result) {

        ListGrid_Competence_Request_Items.setData(result.list);
        if (result.list.size() === 0)
            createDialog("info", "رکوردی با کدملی صحیح برای اضافه شدن وجود ندارد");
        else {
            if (result.wrongCount !== 0)
                createDialog("info"," از مجموع رکوردهای وارد شده؛ " + result.wrongCount + " رکورد با دیتای نادرست اضافه شده است ");
        }
    }
    function sendRequestItemProcess(record) {

        if (record.processInstanceId != null) {
            createDialog("info", "فرایند پیش تر به موتور گردش کار ارسال شده است");
        } else if (record.operationalRoleUsers.size() === 0 || record.operationalRoleUsers == null) {
            createDialog("info", "کارشناس ارشد برنامه ریزی برای پست پیشنهادی تعریف نشده است.");
        } else {
            isc.MyYesNoDialog.create({
                message: "<spring:message code="request.item.sent.to.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let requestRecord = ListGrid_Competence_Request.getSelectedRecord();
                        let param = {}
                        let postTitle = "";
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(trainingPostUrl + "/getNeedAssessmentInfo?trainingPostCode=" + record.post, "GET", null, function (response) {
                            if (response.httpResponseCode === 200 || response.httpResponseCode === 201) {
                                let data = JSON.parse(response.httpResponseText);
                                postTitle = data.titleFa;
                            }
                            if (record.nationalCode !== undefined) {
                                param.data = {
                                    "processDefinitionKey": "فرآیند درخواست تایید صلاحیت علمی و فنی",
                                    "title": "درخواست تایید صلاحیت علمی و فنی پرسنل با کدملی " + record.nationalCode + " برای کدپست پیشنهادی " + record.post + " با عنوان " + postTitle + " و شماره نامه کارگزینی " + requestRecord.letterNumber,
                                    "requestItemId": record.id,
                                    "requestNo": requestRecord.id
                                };
                            } else {
                                param.data = {
                                    "processDefinitionKey": "فرآیند درخواست تایید صلاحیت علمی و فنی",
                                    "title": "درخواست تایید صلاحیت علمی و فنی پرسنل با شماره پرسنلی قدیم " + record.personnelNo2 + " برای کدپست پیشنهادی " + record.post + " با عنوان " + postTitle + " و شماره نامه کارگزینی " + requestRecord.letterNumber,
                                    "requestItemId": record.id,
                                    "requestNo": requestRecord.id
                                };
                            }
                            isc.RPCManager.sendRequest(TrDSRequest(requestItemBPMSUrl + "/processes/request-item/start-data-validation", "POST", JSON.stringify(param), function (resp) {
                                wait.close();
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    createDialog("info", "<spring:message code='course.set.on.workflow.engine'/>");
                                    refreshRequestItem();
                                } else if (resp.httpResponseCode === 403) {
                                    createDialog("info", JSON.parse(resp.httpResponseText).message);
                                } else {
                                    createDialog("info", "<spring:message code='msg.send.to.workflow.problem'/>");
                                }
                            }));
                        }));
                    }
                }
            });
        }
    }
    function sendGroupRequestItemProcess(records) {

        let validRecords = [];
        for (let i = 0; i < records.length; i++) {
            if (records[i].processInstanceId == null && records[i].operationalRoleUsers.size() !== 0)
                validRecords.add(records[i]);
        }
        if (validRecords.length === 0) {
            createDialog("info", "همه درخواست ها ارسال شده اند یا رکوردی با اطلاعات کامل برای ارسال به گردش کار وجود ندارد");
        } else {
            isc.MyYesNoDialog.create({
                message: "<spring:message code="request.item.sent.to.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let data = [];
                        let requestRecord = ListGrid_Competence_Request.getSelectedRecord();
                        for (let i = 0; i < validRecords.length; i++) {
                            let param = {}
                            if (validRecords[i].nationalCode !== undefined) {
                                param.data = {
                                    "processDefinitionKey": "فرآیند درخواست تایید صلاحیت علمی و فنی",
                                    "title": "درخواست تایید صلاحیت علمی و فنی پرسنل با کدملی " + validRecords[i].nationalCode + " برای کدپست پیشنهادی " + validRecords[i].post + " و شماره نامه کارگزینی " + requestRecord.letterNumber,
                                    "requestItemId": validRecords[i].id,
                                    "requestNo": requestRecord.id
                                };
                            } else {
                                param.data = {
                                    "processDefinitionKey": "فرآیند درخواست تایید صلاحیت علمی و فنی",
                                    "title": "درخواست تایید صلاحیت علمی و فنی پرسنل با شماره پرسنلی قدیم " + validRecords[i].personnelNo2 + " برای کدپست پیشنهادی " + validRecords[i].post + " و شماره نامه کارگزینی " + requestRecord.letterNumber,
                                    "requestItemId": validRecords[i].id,
                                    "requestNo": requestRecord.id
                                };
                            }
                            data.add(param);
                        }
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(requestItemBPMSUrl + "/processes/request-item/start-data-validation/group", "POST", JSON.stringify(data), function (resp) {
                            wait.close();
                            let hasException = JSON.parse(resp.httpResponseText);
                            if (hasException === false) {
                                createDialog("info", "<spring:message code='global.form.request.successful'/>");
                                refreshRequestItem();
                            } else {
                                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
                                refreshRequestItem();
                            }
                        }));
                    }
                }
            });
        }
    }
    function updateOperationalRoles() {

        let record = ListGrid_Competence_Request_Items.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(requestItemUrl + "/operational-roles/" + record.id, "PUT", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    refreshRequestItem();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }
    }

    function selectionUpdated_Competence_Request() {

        let requestItem = ListGrid_Competence_Request_Items.getSelectedRecord();
        let tab = Requests_Detail_Tabs.getSelectedTab();

        if (requestItem == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }

        processStatus.setValue("processStatusTitle", requestItem.processStatusTitle === "" ? "به گردش کار ارسال نشده" : requestItem.processStatusTitle);

        isc.RPCManager.sendRequest(TrDSRequest(trainingPostUrl + "/getNeedAssessmentInfo?trainingPostCode=" + requestItem.post, "GET", null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let data = JSON.parse(resp.httpResponseText);
                trainingPostNeedAssessmentStatus.setValue("modifiedDate", data.lastModifiedDateNA);
                trainingPostNeedAssessmentStatus.setValue("modifiedBy", data.modifiedByNA);
            } else {
                trainingPostNeedAssessmentStatus.setValue("modifiedDate", "پست وجود ندارد");
                trainingPostNeedAssessmentStatus.setValue("modifiedBy", "پست وجود ندارد");
            }
        }));

        switch (tab.name) {
            case "TabPane_Personnel_Training_History": {
                RestDataSource_Competence_Request_PersonnelTraining.fetchDataURL = classUrl + "personnel-training/" + requestItem.nationalCode + "/" + requestItem.personnelNumber;
                ListGrid_Personnel_Training_History.invalidateCache();
                ListGrid_Personnel_Training_History.fetchData();
                break;
            }
            case "TabPane_Personnel_Job_History": {
                RestDataSource_Competence_Request_PersonnelJobExperiences.fetchDataURL = masterDataUrl + "/job/" + requestItem.nationalCode;
                ListGrid_Personnel_Job_History.fetchData();
                ListGrid_Personnel_Job_History.invalidateCache();
                break;
            }
            case "TabPane_Post_History": {
                RestDataSource_Competence_Request_PostInfo.fetchDataURL = masterDataUrl + "/post?postCode=" + requestItem.post;
                ListGrid_Post_History.fetchData();
                ListGrid_Post_History.invalidateCache();

                postStatus.setContents("وضعیت پست :");
                isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/getNeedAssessmentInfo?postCode=" + requestItem.post, "GET", null, function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let data = JSON.parse(resp.httpResponseText);
                        needADate.setValue(data.lastModifiedDateNA);
                        needABy.setValue(data.modifiedByNA);
                    } else {
                        needADate.setValue("پست وجود ندارد");
                        needABy.setValue("پست وجود ندارد");
                    }
                }));
                break;
            }
        }
    }
    function showRequestItemsAudit(competenceId) {

        let ListGrid_Request_Item_Show_Audit = isc.TrLG.create({
            canAutoFitFields: true,
            width: "100%",
            height: 600,
            <sec:authorize access="hasAuthority('CompetenceRequest_R')">
            dataSource: RestDataSource_Competence_Request_Item_Audit,
            </sec:authorize>
            setAutoFitExtraRecords: true,
            autoFetchData: false,
            showFilterEditor: false,
            fields: [
                {
                    name: "id",
                    hidden: true,
                    primaryKey: true
                },
                {
                    name: "nationalCode",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "personnelNumber",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "personnelNo2",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "name",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "lastName",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "affairs",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "post",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "state.titleFa",
                    width: "10%",
                    align: "center",
                    hidden: true
                },
                {
                    name: "lastModifiedDate",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value) {
                        if (value) {
                            let date = new Date (value);
                            return date.toLocaleString('fa-IR');
                        }
                    }
                },
                {
                    name: "lastModifiedBy",
                    width: "10%",
                    align: "center"
                },
                {
                    name: "revType",
                    width: "10%",
                    align: "center",
                    formatCellValue: function (value, record) {
                        if (value === 0)
                            return "اضافه شده";
                        else if (value === 1) {
                            if (record.deleted === 75)
                                return "حذف شده";
                            else
                                return "ویرایش شده";
                        } else
                            return "";
                    }
                }
            ]
        });

        let Window_Request_Item_Show_Audit = isc.Window.create({
            width: "90%",
            height: 625,
            numCols: 2,
            title: "تاریخچه تغییرات آیتم های درخواست",
            items: [
                ListGrid_Request_Item_Show_Audit,
                isc.MyHLayoutButtons.create({
                    members: [
                        isc.IButtonCancel.create({
                            title: "<spring:message code="close"/>",
                            click: function () {
                                Window_Request_Item_Show_Audit.close();
                            }
                        })]
                })]
        });

        RestDataSource_Competence_Request_Item_Audit.fetchDataURL = requestItemAuditUrl + "/change-list/" + competenceId;
        ListGrid_Request_Item_Show_Audit.fetchData();
        Window_Request_Item_Show_Audit.show();
    }

    function competenceRequestTotalAll(records) {
        let totalAll_ = 0;
        for (let i = 0; i < records.length; i++) {
            totalAll_ += records[i].hduration;
        }
        return "<spring:message code='total.sum'/> : " + totalAll_ + " <spring:message code='hour'/> ";
    }
    function competenceRequestTotalRejected(records) {
        let totalRejected_ = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].scoreStateId === 403 || records[i].scoreStateId === 405 || records[i].scoreStateId === 449)
                totalRejected_ += records[i].hduration;
        }
        return "<spring:message code='missing.or.absent.sum'/> : " + totalRejected_ + " <spring:message code='hour'/> ";
    }
    function competenceRequestTotalPassed(records) {
        let totalPassed_ = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].classStatusId !== 1)
                totalPassed_ += records[i].hduration;
        }
        return "<spring:message code='passed.or.running.sum'/> : " + totalPassed_ + " <spring:message code='hour'/> ";
    }
    function competenceRequestTotalPlanning(records) {
        let totalPlanning_ = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].classStatusId === 1)
                totalPlanning_ += records[i].hduration;
        }
        return "<spring:message code='planning.sum'/> : " + totalPlanning_ + " <spring:message code='hour'/> ";
    }

    function exportToExcelRequestItems() {

        let competenceRequest = ListGrid_Competence_Request.getSelectedRecord();
        if (ListGrid_Competence_Request_Items.getData() === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else {

            let DynamicForm_Select_Status = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "state",
                        title: "وضعیت آموزشی",
                        width: "100%",
                        align: "center",
                        required: true,
                        valueMap: {
                            "نیاز به گذراندن دوره": "نیاز به گذراندن دوره",
                            "بلا مانع": "بلا مانع",
                            "همه": "همه"
                        }
                    }
                ]
            });
            let Button_Select_Status_Excel = isc.IButton.create({
                title: "ارسال به اکسل",
                align: "center",
                width: "120",
                click: function () {

                    let itemFields = ["personnelNo2", "name", "lastName", "affairs", "currentPostTitle", "postTitle", "post", "planningChiefOpinion"];
                    let itemHeaders = ["شماره کار", "نام شرکت کننده", "نام خانوادگی", "امور", "پست قدیم", "پست پیشنهادی", "کدپست پیشنهادی", "وضعیت آموزشی"];
                    let state = DynamicForm_Select_Status.getValue("state");

                    let downloadForm = isc.DynamicForm.create({
                        method: "POST",
                        action: "/training/reportsToExcel/competenceRequestWithItems",
                        target: "_Blank",
                        canSubmit: true,
                        fields:
                            [
                                {name: "fieldNames", type: "hidden"},
                                {name: "headers", type: "hidden"},
                                {name: "compReqId", type: "hidden"},
                                {name: "state", type: "hidden"},
                            ]
                    });

                    downloadForm.setValue("fieldNames", itemFields);
                    downloadForm.setValue("headers", itemHeaders);
                    downloadForm.setValue("compReqId", competenceRequest.id);
                    downloadForm.setValue("state", state);
                    downloadForm.show();
                    downloadForm.submitForm();

                    Window_Select_Status.close();
                }
            });
            let Button_Select_Status_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "120",
                click: function () {
                    Window_Select_Status.close();
                }
            });
            let HLayout_Select_Status = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_Select_Status_Excel,
                    Button_Select_Status_Close
                ]
            });
            let Window_Select_Status = isc.Window.create({
                title: "انتخاب رکوردها براساس وضعیت آموزشی",
                autoSize: false,
                width: "30%",
                height: "15%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_Select_Status,
                    HLayout_Select_Status
                ]
            });
            Window_Select_Status.show();
        }
    }
    function exportToExcelPersonnelJobHistory() {

        let requestItem = ListGrid_Competence_Request_Items.getSelectedRecord();
        if (ListGrid_Personnel_Job_History.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Personnel_Job_History, masterDataUrl + "/job/" + requestItem.nationalCode, 0, null,
                '',"گزارش سوابق شغلی پرسنل"  , null, null);
    }
    function exportToExcelPostHistory() {

        let requestItem = ListGrid_Competence_Request_Items.getSelectedRecord();
        if (ListGrid_Post_History.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Post_History, masterDataUrl + "/post?postCode=" + requestItem.post, 0, null,
                '',"گزارش سوابق پیشنهادی"  , null, null);
    }
    function exportToExcelPersonnelTraining() {

        let requestItem = ListGrid_Competence_Request_Items.getSelectedRecord();
        if (ListGrid_Personnel_Training_History.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Personnel_Training_History, classUrl + "personnel-training/" + requestItem.nationalCode + "/" + requestItem.personnelNumber, 0, null,
                '',"گزارش دوره های گذرانده فرد"  , null, null);
    }

// </script>