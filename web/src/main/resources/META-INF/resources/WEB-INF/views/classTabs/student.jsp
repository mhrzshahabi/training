<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <<script>
    {
        var studentRemoveWait;
        var studentDefaultPresenceId = 103;
        var evalData;
        var isEditing = false;
        var url = '';
        var studentSelection = false;
        var selectedRecord_addStudent_class = '';
        var checkRefresh = 0;
        var selectedRow = {};
        var listGridType = null;
        let previousSelectedRow = {};
        let previousSelectedRowReg = {};

        // ------------------------------------------- Menu -------------------------------------------
        let StudentMenu_student = isc.Menu.create({
            data: [

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {

                        refreshStudentsLG_student();
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_classStatus')">
                {
                    title: "<spring:message code="add"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        addStudent_student();
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_D','TclassStudentsTab_classStatus')">
                {
                    title: "<spring:message code="remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        removeStudent_student();
                    }
                },
                </sec:authorize>

                <%--                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_E','TclassStudentsTab_classStatus')">--%>
                <%--                {--%>
                <%--                    title: "<spring:message code="evaluation"/>",--%>
                <%--                    icon: "<spring:url value="remove.png"/>",--%>
                <%--                    click: function () {--%>
                <%--                        evaluationStudent_student();--%>
                <%--                    }--%>
                <%--                },--%>
                <%--                </sec:authorize>--%>
            ]
        });

        // ------------------------------------------- ToolStrip -------------------------------------------
        let btnAdd_student_class = isc.ToolStripButtonAdd.create({
            click: function () {
                addStudent_student();
            }
        });

        let btnRemove_student_class = isc.ToolStripButtonRemove.create({
            click: function () {
                removeStudent_student();
            }
        });

        let StudentTS_student = isc.ToolStrip.create({
            members: [

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_classStatus')">
                btnAdd_student_class,
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_D','TclassStudentsTab_classStatus')">
                btnRemove_student_class,
                </sec:authorize>

                <%--                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_E','TclassStudentsTab_classStatus')">--%>
                <%--                isc.ToolStripButton.create({--%>
                <%--                    title: "<spring:message code="evaluation"/>",--%>
                <%--                    click: function () {--%>
                <%--                        evaluationStudent_student();--%>
                <%--                    }--%>
                <%--                }),--%>
                <%--                </sec:authorize>--%>

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_P','TclassStudentsTab_classStatus')">
                isc.ToolStripButtonExcel.create({
                    click: function () {

                        let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        if (!(classRecord === undefined || classRecord == null)) {
                            ExportToFile.downloadExcelRestUrl(null, StudentsLG_student, tclassStudentUrl + "/students-iscList/" + classRecord.id, 0,
                                ListGrid_Class_JspClass, '', "کلاس - فراگيران", StudentsLG_student.getCriteria(), null);
                        }
                    }
                }),
                isc.ToolStripButton.create({
                    icon: "[SKIN]/RichTextEditor/print.png",
                    title: "<spring:message code='print'/>",
                    click: function () {
                        var classRecord = ListGrid_Class_JspClass.getSelectedRecord();

                        let startDateStr = [...classRecord.startDate.split("/").reverse()].join("/");
                        let endDateStr = [...classRecord.endDate.split("/").reverse()].join("/");

                        var titr = "گزارش فراگیران کلاس " + classRecord.course.titleFa +
                            " دارای کد دوره: " + classRecord.course.code +
                            " و کد کلاس: " + classRecord.code +
                            " و استاد: " + classRecord.teacher +
                            " و مدت: " + classRecord.hduration +
                            " ساعت و تاریخ شروع: " + startDateStr +
                            " و تاریخ پایان: " + endDateStr;

                        let params = {};
                        params.titr = titr;

                        let localData = StudentsLG_student.data.localData.toArray();
                        let data = [];

                        for (let i = 0; i < localData.length; i++) {
                            let obj = {};
                            obj.personnelNo = localData[i].student.personnelNo2;
                            obj.nationalCode = localData[i].student.nationalCode;
                            obj.firstName = localData[i].student.firstName.trim();
                            obj.lastName = localData[i].student.lastName.trim();
                            obj.fatherName = localData[i].student.fatherName;
                            obj.mobile = localData[i].student.mobile;
                            obj.ccpArea = localData[i].student.ccpArea;
                            obj.ccpAssistant = localData[i].student.ccpAssistant;
                            obj.ccpAffairs = localData[i].student.ccpAffairs;
                            data.push(obj);
                        }

                        // method 1:
                        // data=data.sort((a, b) => (a.lastName[0] > b.lastName[0] ? -1 : 1));

                        // method 2:
                        data = data.sort(new Intl.Collator("fa").compare);

                        printToJasper(data, params, "ClassStudents.jasper");

                    }
                }),
                isc.ToolStripButtonExcel.create({
                    title: 'اکسل نواقص اطلاعات فراگیران',
                    click: function () {
                        let sendFields = [{name:"rowNum",title:"ردیف"},{name:"fullName",title:"نام"},{name:"description",title:"توضیحات"}];
                        let data = [];
                        let rows = StudentsLG_student.data.getAllLoadedRows();
                        let j = 0;
                        for (let i = 0; i < rows.length; i++) {
                            if(rows[i].student.nationalCode === null || rows[i].student.nationalCode === undefined ){
                                data[j] = {};
                                data[j].rowNum = i + 1;
                                data[j].fullName = rows[i].fullName;
                                data[j].description = "شماره ملی فراگیر در سیستم ثبت نشده است";
                                j++;
                            } else{
                                if(rows[i].student.nationalCode.length !== 10 || !(/^-?\d+$/.test(rows[i].student.nationalCode.length))){
                                    data[j] = {};
                                    data[j].rowNum = i + 1;
                                    data[j].fullName = rows[i].fullName;
                                    data[j].description = "شماره ملی فراگیر صحیح نیست";
                                    j++;
                                }
                            }
                            if(rows[i].student.mobile === null || rows[i].student.mobile === undefined ){
                                data[j] = {};
                                data[j].rowNum = i + 1;
                                data[j].fullName = rows[i].fullName;
                                data[j].description = "شماره همراه فراگیر در سیستم ثبت نشده است";
                                j++;
                            } else{
                                if((rows[i].student.mobile.length !== 10 && rows[i].student.mobile.length !== 11) || !(/^-?\d+$/.test(rows[i].student.mobile))){
                                        data[j] = {};
                                        data[j].rowNum = i + 1;
                                        data[j].fullName = rows[i].fullName;
                                        data[j].description = "تعداد ارقام همراه فراگیر در سیستم صحیح نیست";
                                        j++;
                                }
                                if(rows[i].student.mobile.length === 10 && !rows[i].student.mobile.startsWith("9")){
                                        data[j] = {};
                                        data[j].rowNum = i + 1;
                                        data[j].fullName = rows[i].fullName;
                                        data[j].description = "فرمت شماره همراه فراگیر در سیستم صحیح نیست";
                                        j++;
                                }
                                if(rows[i].student.mobile.length === 11 && !rows[i].student.mobile.startsWith("09")){
                                        data[j] = {};
                                        data[j].rowNum = i + 1;
                                        data[j].fullName = rows[i].fullName;
                                        data[j].description = "فرمت شماره همراه فراگیر در سیستم صحیح نیست";
                                        j++;
                                }
                            }
                            if(rows[i].student.gender === null || rows[i].student.gender === undefined ){
                                data[j] = {};
                                data[j].rowNum = i + 1;
                                data[j].fullName = rows[i].fullName;
                                data[j].description = "جنسیت فراگیر در سیستم ثبت نشده است";
                                j++;
                            }
                        }
                        if(data.length === 0){
                            createDialog("info"," اطلاعات فراگیران این کلاس صحیح است." );
                        } else {
                            let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                            let fileTitle = classRecord.code + " نواقص فراگیران کلاس با کد " ;
                            ExportToFile.exportToExcelFromClient(sendFields, data, fileTitle , "اطلاعات ناقص فراگیران");
                        }
                    }
                }),
                </sec:authorize>

                isc.IButton.create({
                    baseStyle: 'MSG-btn-orange',
                    icon: '../static/img/msg/mail.svg',
                    title: "ارسال پیام", width: 80,
                    click: function () {
                        let row = ListGrid_Class_JspClass.getSelectedRecords()[0];
                        let wait = createDialog("wait");

                        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/students-iscList/" + row.id, "GET", null, function (resp) {
                            if (generalGetResp(resp)) {
                                if (resp.httpResponseCode == 200) {
                                    isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/iscList/481?operator=and&_constructor=AdvancedCriteria&criteria=" +
                                        "{\"fieldName\":\"code\",\"operator\":\"equals\",\"value\":\"MCSR\",\"_constructor\":\"AdvancedCriteria\"}&_startRow=0&_endRow=75&_sortBy=title",
                                        "GET", null, function (resp2) {
                                        wait.close();
                                        if (generalGetResp(resp)) {
                                            if (resp.httpResponseCode == 200) {


                                                let id = [];
                                                JSON.parse(resp.data).response.data.filter(p => p.student.mobile).forEach(p => id.push(p.id));

                                                MSG_sendTypesItems = [];
                                                MSG_msgContent.type = [];
                                                MSG_sendTypesItems.push('MSG_messageType_sms');
                                                MSG_msgContent.type = MSG_sendTypesItems;

                                                sendMessageFunc = sendMessage_StudentClassJsp;
                                                MSG_selectUsersForm.getItem("multipleSelect").optionDataSource = StudentsDS_student;

                                                //MSG_selectUsersForm.getItem("multipleSelect").pickListWidth=600;
                                                MSG_selectUsersForm.getItem("multipleSelect").pickListFields = [
                                                    {
                                                        name: "student.firstName",
                                                        title: "<spring:message code="firstName"/>",
                                                        autoFitWidth: false,
                                                        align: "center"
                                                    },
                                                    {
                                                        name: "student.lastName",
                                                        title: "<spring:message code="lastName"/>",
                                                        autoFitWidth: false,
                                                        align: "center"
                                                    },
                                                    {
                                                        name: "student.nationalCode",
                                                        title: "<spring:message code="national.code"/>",
                                                        width: 100,
                                                        align: "center"
                                                    },
                                                    {
                                                        name: "student.personnelNo",
                                                        title: "<spring:message code="personnel.no"/>",
                                                        width: 100,
                                                        align: "center"
                                                    },
                                                    {
                                                        name: "student.personnelNo2",
                                                        title: "<spring:message code="personnel.no.6.digits"/>",
                                                        width: 100,
                                                        align: "center"
                                                    },
                                                    {
                                                        name: "student.mobile",
                                                        title: "<spring:message code="mobile"/>",
                                                        width: 100,
                                                        align: "center"
                                                    },
                                                ];
                                                MSG_selectUsersForm.getItem("multipleSelect").displayField = "fullName";
                                                MSG_selectUsersForm.getItem("multipleSelect").valueField = "id";
                                                MSG_selectUsersForm.getItem("multipleSelect").dataArrived = function (startRow, endRow) {
                                                    let ids = MSG_selectUsersForm.getItem("multipleSelect").pickList.data.getAllCachedRows().filter(p => !p.student.mobile).map(function (item) {
                                                        return item.id;
                                                    });

                                                    let findRows = MSG_selectUsersForm.getItem("multipleSelect").pickList.findAll({
                                                        _constructor: "AdvancedCriteria",
                                                        operator: "and",
                                                        criteria: [{fieldName: "id", operator: "inSet", value: ids}]
                                                    });

                                                    findRows.setProperty("enabled", false);

                                                    MSG_selectUsersForm.getItem("multipleSelect").setValue(id);
                                                }
                                                MSG_selectUsersForm.getItem("multipleSelect").fetchData();

                                                MSG_textEditorValue = JSON.parse(resp2.data).response.data[0].description;
                                                MSG_contentEditor.setValue(MSG_textEditorValue);

                                                linkFormMLanding.getItem('link').setValue('');

                                                if (JSON.parse(resp.data).response.data.filter(p => !p.student.mobile).length != 0) {
                                                    ErrorMsg.setContents('برای ' + JSON.parse(resp.data).response.data.filter(p => !p.student.mobile).length + ' فراگیر، شماره موبایل تعریف نشده است.');
                                                } else if (JSON.parse(resp.data).response.data.filter(p => p.student.mobile).length == 0) {
                                                    ErrorMsg.setContents('هیچ مخاطبی انتخاب نشده است');
                                                } else {
                                                    ErrorMsg.setContents('');
                                                }
                                                MSG_userType = "classStudentRegistered";
                                                MSG_classID = row.id;

                                                MSG_repeatOptions.getItem('maxRepeat').setValue(0);
                                                MSG_repeatOptions.getItem('timeBMessages').setValue(1);
                                                linkFormMLanding.getItem('link').setValue('');
                                                linkFormMLanding.getItem('link').setRequired(true);
                                                linkFormMLanding.getItem('link').enable();
                                                MSG_Window_MSG_Main.show();
                                            } else {
                                                createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                                            }
                                        }
                                    }))

                                } else {
                                    wait.close();
                                    createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                                }
                            } else {
                                wait.close();
                            }
                        }));
                    }
                }),

                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "StudentsCount_student"}),

                <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
                isc.ToolStripButtonRefresh.create({
                    click: function () {
                        refreshStudentsLG_student();
                    }
                }),
                </sec:authorize>
            ]
        });

        let PersonnelsTS_student = isc.ToolStrip.create({
            members: [
                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "PersonnelsCount_student"}),
            ]
        });

        let RegisteredTS_student = isc.ToolStrip.create({
            members: [
                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "RegisteredCount_student"}),
            ]
        });

        // ------------------------------------------- DataSource & ListGrid -------------------------------------------

        let RestDataSource_company_Student = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
                {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
            ],
            canAddFormulaFields: false,
            filterOnKeypress: true,
            sortField: 1,
            sortDirection: "descending",
            dataPageSize: 50,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            // filterOnKeypress: false,
            sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
            sortFieldDescendingText: "<spring:message code='sort.descending'/>",
            configureSortText: "<spring:message code='configureSortText'/>",
            autoFitAllText: "<spring:message code='autoFitAllText'/>",
            autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
            filterUsingText: "<spring:message code='filterUsingText'/>",
            groupByText: "<spring:message code='groupByText'/>",
            freezeFieldText: "<spring:message code='freezeFieldText'/>",
            fetchDataURL: companyUrl + "spec-list"
        });

        let StudentsDS_student = isc.TrDS.create({
            <%--transformRequest: function (dsRequest) {--%>
            <%--    dsRequest.httpHeaders = {--%>
            <%--        "Authorization": "Bearer <%= accessToken1 %>"--%>
            <%--    };--%>
            <%--    return this.Super("transformRequest", arguments);--%>
            <%--},--%>
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "student.companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.fatherName",
                    title: "<spring:message code="father.name"/>",
                    filterOperator: "iContains"
                },
                {name: "student.mobile", title: "<spring:message code="mobile"/>", filterOperator: "iContains"},
                {
                    name: "student.birthCertificateNo",
                    title: "<spring:message code="birth.certificate.no"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "hasWarning",
                    title: " ",
                    width: 40,
                    type: "image",
                    imageURLPrefix: "",
                    imageURLSuffix: ".png",
                    canEdit: false
                },
                {name: "warning", autoFitWidth: true}

            ],

            fetchDataURL: tclassStudentUrl + "/students-iscList/"
        });

        let StudentsDS_PresenceType = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            fetchDataURL: parameterValueUrl + "/iscList/98"
        });

        let StudentsLG_student = isc.TrLG.create({
            ID: "StudentsLG_student",
            <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
            dataSource: StudentsDS_student,
            </sec:authorize>
            // selectionType: "single",
            selectionType: "multiple",
            sortField: 1,
            sortDirection: "descending",
            fields: [
                {
                    name: "student.firstName",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.firstName;
                    }
                },
                {
                    name: "student.lastName",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.lastName;
                    }
                },
                {
                    name: "student.nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.nationalCode;
                    }
                },
                {name: "student.fatherName", hidden: true},
                {
                    name: "applicantCompanyName",
                    textAlign: "center",
                    autoFitWidth: true,
                    <%--editorType: "ComboBoxItem",--%>
                    <%--changeOnKeypress: true,--%>
                    <%--displayField: "titleFa",--%>
                    <%--valueField: "titleFa",--%>
                    <%--<sec:authorize access="hasAuthority('TclassStudentsTab_R')">--%>
                    <%--optionDataSource: RestDataSource_company_Student,--%>
                    <%--</sec:authorize>--%>
                    <%--autoFetchData: true,--%>
                    <%--addUnknownValues: false,--%>
                    <%--cachePickListResults: false,--%>
                    <%--useClientFiltering: true,--%>
                    <%--filterFields: ["titleFa"],--%>
                    <%--sortField: ["id"],--%>
                    <%--textMatchStyle: "startsWith",--%>
                    <%--generateExactMatchCriteria: true,--%>
                    <%--canEdit: true,--%>
                    <%--// filterEditorType: "TextItem",--%>
                    <%--pickListFields: [--%>
                    <%--{--%>
                    <%--name: "titleFa",--%>
                    <%--width: "70%",--%>
                    <%--filterOperator: "iContains"--%>
                    <%--}--%>
                    <%--],--%>
                    <%--changed: function (form, item, value) {--%>
                    <%--ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);--%>
                    <%--}--%>
                },
                {
                    name: "presenceTypeId",
                    type: "selectItem",
                    optionDataSource: StudentsDS_PresenceType,
                    valueField: "id",
                    displayField: "title",
                    autoFitWidth: true,
                    filterOnKeypress: true,
                    canEdit: true,
                    changed: function (form, item, value) {
                        ListGrid_Cell_Update_Student(this.grid.getRecord(this.rowNum), value, item);
                    }
                },
                {
                    name: "student.personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.personnelNo;
                    }
                },
                {
                    name: "student.personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.personnelNo2;
                    }
                },
                {
                    name: "student.postTitle",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.postTitle;
                    }
                },
                {
                    name: "student.mobile",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.mobile;
                    }
                },
                {
                    name: "student.birthCertificateNo",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.birthCertificateNo;
                    }
                },
                {
                    name: "student.ccpArea",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.ccpArea;
                    }
                },
                {
                    name: "student.ccpAssistant",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.ccpAssistant;
                    }
                },
                {
                    name: "student.ccpAffairs",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.ccpAffairs;
                    }
                },
                {
                    name: "student.ccpSection",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.ccpSection;
                    }
                },
                {
                    name: "student.ccpUnit",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.ccpUnit;
                    }
                },
                {name: "warning", hidden: true},
                {
                    name: "hasWarning",
                    title: "قبولی در پیش تست",
                    width: 130,
                    type: "image",
                    imageURLPrefix: "",
                    imageURLSuffix: ".png",
                    canEdit: false,
                    canSort: false,
                    canFilter: false
                },
                {
                    name: "isSentMessage",
                    title: "ارسال پيام قبل از شروع کلاس",
                    width: 190,
                    type: "image",
                    imageURLPrefix: "",
                    imageURLSuffix: ".png",
                    canEdit: false,
                    canSort: false,
                    canFilter: false
                }
            ],
            gridComponents: [StudentTS_student, "filterEditor", "header", "body"],
            dataArrived: function () {
                StudentsLG_student.data.localData.filter(p => p.warning == 'Ok').forEach(p => p.hasWarning = 'checkBlue');
            },
            // contextMenu: StudentMenu_student,
            dataChanged: function () {
                this.Super("dataChanged", arguments);
                totalRows = this.data.getLength();
                if (totalRows >= 0 && this.data.lengthIsKnown()) {
                    StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
                } else {
                    StudentsCount_student.setContents("&nbsp;");
                }
            },
            getCellCSSText: function (record, rowNum, colNum) {
                let result = "background-color : ";
                let blackColor = "; color:black";
                switch (parseInt(record.presenceTypeId)) {
                    case 104:
                        result += "#FFF9C4" + blackColor;
                        break;
                }//end switch-case

                if (this.getFieldName(colNum) == "student.personnelNo") {
                    result += ";color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
                }

                return result;
            },//end getCellCSSText
            cellClick: function (record, rowNum, colNum) {
                if (colNum === 6) {
                    //console.log(record);
                    selectedRecord_addStudent_class = {
                        firstName: record.student.firstName,
                        lastName: record.student.lastName,
                        postTitle: record.student.postTitle,
                        ccpArea: record.student.ccpArea,
                        ccpAffairs: record.student.ccpAffairs,
                        personnelNo: record.student.personnelNo,
                        nationalCode: record.student.nationalCode,
                        postCode: record.student.postCode
                    };

                    let window_class_Information = isc.Window.create({
                        title: "<spring:message code="personnel.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",
                            //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
                        })]
                    });

                    if (!loadjs.isDefined('personnel-information-details')) {
                        loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                    }

                    loadjs.ready('personnel-information-details', function () {
                        let oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                        window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);

                    });
                    window_class_Information.show();
                }
            }
        });

        let SelectedPersonnelsLG_student = isc.TrLG.create({
            ID: "SelectedPersonnelsLG_student",
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            fields: [
                {name: "id", hidden: true},
                {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    textAlign: "center",
                    canEdit: true,
                    width: "*",
                    editorType: "ComboBoxItem",
                    changeOnKeypress: true,
                    displayField: "titleFa",
                    valueField: "titleFa",
                    optionDataSource: RestDataSource_company_Student,
                    autoFetchData: true,
                    addUnknownValues: false,
                    cachePickListResults: false,
                    useClientFiltering: true,
                    filterFields: ["titleFa"],
                    sortField: ["id"],
                    textMatchStyle: "startsWith",
                    generateExactMatchCriteria: true,
                    // filterEditorType: "TextItem",
                    pickListFields: [
                        {
                            name: "titleFa",
                            width: "70%",
                            filterOperator: "iContains"
                        }
                    ]
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    type: "selectItem",
                    optionDataSource: StudentsDS_PresenceType,
                    //canEdit: true,
                    valueField: "id",
                    displayField: "title",
                    filterOnKeypress: true,
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "registerTypeId", title: "پرسنل", canEdit: false,
                    formatCellValue(value) {
                        return (value === 1 ? "هست" : "نیست");
                    }
                },
                {
                    name: "isInNA",
                    title: "نیازسنجی",
                    filterOperator: "equals",
                    type: "boolean",
                    filterOnKeypress: true
                },
                {
                    name: "scoreState",
                    title: "سوابق",
                    filterOperator: "equals",
                    filterOnKeypress: true,
                    valueMap: {
                        400: "قبول با نمره",
                        401: "قبول بدون نمره",
                        410: "ثبت نام شده",
                    }
                },
                {
                    name: "departmentCode",
                    title: "کد دپارتمان",
                    hidden: true
                },
                {
                    name: "postCode",
                    title: "کد پست",
                    hidden: true
                },
                /*{name: "isNeedsAssessment", type: "boolean", canEdit: false, title:"نیازسنجی"},
                {name: "isPassed", type: "boolean", canEdit: false, title:"گذرانده"},
                {name: "isRunning", type: "boolean", canEdit: false, title:"در حال گذراندن"},*/
                <%--{name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},--%>
                <%--{name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},--%>
                <%--{name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},--%>
                <%--{name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},--%>
                <%--{name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},--%>
                <%--{name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},--%>
                <%--{name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},--%>
                <%--{name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},--%>
            ],
            gridComponents: ["filterEditor", "header", "body"],
            canRemoveRecords: true,
            removeRecordClick: function (rowNum) {
                let nationalCode = SelectedPersonnelsLG_student.data[rowNum].nationalCode;

                studentSelection = true;
                let list = PersonnelsLG_student.getSelection();
                let current = list.filter(function (x) {
                    return x.nationalCode == nationalCode
                });
                current.setProperty("enabled", true);
                if (current && current[0]) {
                    current[0].isChecked = false;
                    current[0].isClicked = false
                }
                PersonnelsLG_student.deselectRecord(current)


                list = PersonnelsRegLG_student.getSelection();
                current = list.filter(function (x) {
                    return x.nationalCode == nationalCode
                });
                current.setProperty("enabled", true);
                if (current && current[0]) {
                    current[0].isChecked = false;
                    current[0].isClicked = false
                }
                PersonnelsRegLG_student.deselectRecord(current);

                studentSelection = false;

                SelectedPersonnelsLG_student.data.removeAt(rowNum);
            },
            cellClick: function (record, rowNum, colNum) {
                if (colNum === 4) {

                    selectedRecord_addStudent_class = {
                        firstName: record.firstName,
                        lastName: record.lastName,
                        postTitle: record.postTitle,
                        ccpArea: record.ccpArea,
                        ccpAffairs: record.ccpAffairs,
                        personnelNo: record.personnelNo,
                        nationalCode: record.nationalCode,
                        postCode: record.postCode,
                    }

                    let window_class_Information = isc.Window.create({
                        title: "<spring:message code="personnel.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",
                            //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
                        })]
                    });

                    if (!loadjs.isDefined('personnel-information-details')) {
                        loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                    }

                    loadjs.ready('personnel-information-details', function () {
                        oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                        window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);
                    });

                    window_class_Information.show();


                }
            },
            getCellCSSText: function (record, rowNum, colNum) {
                let result = '';
                if (this.getFieldName(colNum) == "nationalCode") {
                    result += "color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
                }
                return result;
            },
            /*dataChanged(){
                if(checkRefresh === 0) {
                    checkRefresh = 1
                    checkExistInNeedsAssessment(ListGrid_Class_JspClass.getSelectedRecord().courseId)
                }
            }*/

            rowClick: function (record, recordNum, fieldNum) {
                selectedRow = record;
                listGridType = "SelectedPersonnelsLG_student";
            },
        });

        let PersonnelDS_student = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "isInNA",
                    title: "نیازسنجی",
                    filterOperator: "equals",
                    type: "boolean",
                    filterOnKeypress: true
                },
                {
                    name: "scoreState",
                    title: "سوابق",
                    filterOperator: "equals",
                    filterOnKeypress: true,
                    valueMap: {
                        400: "قبول با نمره",
                        401: "قبول بدون نمره",
                        410: "ثبت نام شده",
                    }
                },
                {name: "departmentCode", hidden: true},
                {name: "postCode", hidden: true},
            ],
            fetchDataURL: viewActivePersonnelInRegisteringUrl + "/spec-list",
        });

        let PersonnelsLG_student = isc.TrLG.create({
            ID: "PersonnelsLG_student",
            dataSource: PersonnelDS_student,
            selectionType: "single",
            fields: [
                // {name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {
                    name: "nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "companyName", hidden: true},
                {
                    name: "personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "postTitle"},
                {name: "ccpArea"},
                {name: "ccpAssistant", hidden: true},
                {name: "ccpAffairs", hidden: true},
                {name: "ccpSection", hidden: true},
                {name: "ccpUnit", hidden: true},
                {name: "isInNA"},
                {name: "scoreState"},
            ],
            gridComponents: [PersonnelsTS_student, "filterEditor", "header", "body"],
            selectionAppearance: "checkbox",
            dataArrived: function (startRow, endRow) {
                let lgNationalCodes = StudentsLG_student.data.localData.map(function (item) {
                    return item.student.nationalCode;
                });
                let selectedNationalCodes = SelectedPersonnelsLG_student.data.map(function (item) {
                    return item['nationalCode'];
                });

                let nationals = lgNationalCodes.concat(selectedNationalCodes);

                let findRows = PersonnelsLG_student.findAll({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "nationalCode", operator: "inSet", value: nationals}]
                });
                studentSelection = true;
                findRows.forEach(current => current.isChecked = true);

                PersonnelsLG_student.setSelectedState(findRows);
                findRows.setProperty("enabled", false);

                studentSelection = false;
            },
            getCellCSSText: rowStyle,
            rowClick: function (record, recordNum, fieldNum) {
                if (Object.keys(previousSelectedRow).length > 1) {
                    previousSelectedRow.data.isClicked = !previousSelectedRow.data.isClicked;
                    this.getCellCSSText(previousSelectedRow.data, previousSelectedRow.row, previousSelectedRow.col);
                    PersonnelsLG_student.redraw();
                }
                record.isClicked = true;
                selectedRow = record;
                previousSelectedRow = {data: selectedRow, row: recordNum, col: fieldNum};
                listGridType = "PersonnelsLG_student";
                this.getCellCSSText(record, recordNum, fieldNum);
            },
            dataChanged: function () {
                this.Super("dataChanged", arguments);
                totalRows = this.data.getLength();
                if (totalRows >= 0 && this.data.lengthIsKnown()) {
                    PersonnelsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
                } else {
                    PersonnelsCount_student.setContents("&nbsp;");
                }
            },
            selectionUpdated: function () {

                if (studentSelection) {
                    return;
                }

                let current = PersonnelsLG_student.getSelection().filter(function (x) {
                    return x.enabled != false
                })[0];//.filter(p->p.enabled==false);

                if (typeof (current) == "undefined") {
                    return;
                }
                if (current.nationalCode == "" || current.nationalCode == null || typeof (current.nationalCode) == "undefined") {
                    isc.Dialog.create({
                        message: "اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });

                    studentSelection = true;
                    PersonnelsLG_student.deselectRecord(current)
                    studentSelection = false;
                } else if (!nationalCodeExists(current.nationalCode)) {
                    if (checkIfAlreadyExist(current)) {
                        return '';
                    } else {
                        current.applicantCompanyName = current.companyName;
                        current.presenceTypeId = studentDefaultPresenceId;
                        current.registerTypeId = 1;

                        SelectedPersonnelsLG_student.addData({...current});
                        PersonnelsLG_student.findAll({
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [{fieldName: "nationalCode", operator: "equals", value: current.nationalCode}]
                        }).setProperty("enabled", false);

                        delete current.isClicked;
                        current.isChecked = true;

                        PersonnelsLG_student.redraw();
                    }

                    function checkIfAlreadyExist(currentVal) {
                        return SelectedPersonnelsLG_student.data.some(function (item) {
                            return (item.nationalCode === currentVal.nationalCode);
                        });
                    }
                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="student.is.duplicate"/>",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                    studentSelection = true;
                    PersonnelsLG_student.deselectRecord(current);
                    studentSelection = false;
                }
            },
            cellClick: function (record, rowNum, colNum) {
                if (colNum === 5) {
                    selectedRecord_addStudent_class = {
                        firstName: record.firstName,
                        lastName: record.lastName,
                        postTitle: record.postTitle,
                        ccpArea: record.ccpArea,
                        ccpAffairs: record.ccpAffairs,
                        personnelNo: record.personnelNo,
                        nationalCode: record.nationalCode,
                        postCode: record.postCode,
                    }

                    let window_class_Information = isc.Window.create({
                        title: "<spring:message code="personnel.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",
                            //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
                        })]
                    });

                    if (!loadjs.isDefined('personnel-information-details')) {
                        loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                    }

                    loadjs.ready('personnel-information-details', function () {
                        oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                        window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);
                    });

                    window_class_Information.show();


                }
            }
        });

        // let criteria_ActivePersonnel = {
        //     _constructor: "AdvancedCriteria",
        //     operator: "and",
        //     criteria: [
        //         {fieldName: "active", operator: "equals", value: 1}
        //     ]
        // };

        // PersonnelsLG_student.implicitCriteria = criteria_ActivePersonnel;

        function nationalCodeExists(nationalCode) {
            return StudentsLG_student.data.localData.some(function (el) {
                return el.student.nationalCode === nationalCode;
            });
        }

        let PersonnelRegDS_student = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                },
            ],
            // autoFetchData: true,
            fetchDataURL: personnelRegUrl + "/spec-list",
        });

        let PersonnelsRegLG_student = isc.TrLG.create({
            ID: "PersonnelsRegLG_student",
            dataSource: PersonnelRegDS_student,
            selectionType: "single",
            fields: [
                //{name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {
                    name: "nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "companyName", hidden: true},
                {
                    name: "personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "postTitle"},
                {name: "ccpArea"},
                {name: "ccpAssistant", hidden: true},
                {name: "ccpAffairs", hidden: true},
                {name: "ccpSection", hidden: true},
                {name: "ccpUnit", hidden: true},
            ],
            gridComponents: [RegisteredTS_student, "filterEditor", "header", "body"],
            dataArrived: function (startRow, endRow) {
                let lgNationalCodes = StudentsLG_student.data.localData.map(function (item) {
                    return item.student.nationalCode;
                });
                let selectedNationalCodes = SelectedPersonnelsLG_student.data.map(function (item) {
                    return item['nationalCode'];
                });

                let nationals = lgNationalCodes.concat(selectedNationalCodes);

                let findRows = PersonnelsRegLG_student.findAll({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "nationalCode", operator: "inSet", value: nationals}]
                });
                studentSelection = true;
                findRows.forEach(current => current.isChecked = true);
                PersonnelsRegLG_student.setSelectedState(findRows);
                findRows.setProperty("enabled", false);

                studentSelection = false;
            },
            getCellCSSText: rowStyle,
            rowClick: function (record, recordNum, fieldNum) {
                if (Object.keys(previousSelectedRowReg).length > 1) {
                    previousSelectedRowReg.data.isClicked = !previousSelectedRowReg.data.isClicked;
                    this.getCellCSSText(previousSelectedRowReg.data, previousSelectedRowReg.row, previousSelectedRowReg.col);
                    PersonnelsRegLG_student.redraw();
                }
                record.isClicked = true;
                selectedRow = record;
                previousSelectedRowReg = {data: selectedRow, row: recordNum, col: fieldNum};
                listGridType = "PersonnelsRegLG_student";
                this.getCellCSSText(record, recordNum, fieldNum);
            },

            dataChanged: function () {
                this.Super("dataChanged", arguments);
                totalRows = this.data.getLength();
                if (totalRows >= 0 && this.data.lengthIsKnown()) {
                    PersonnelsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
                } else {
                    PersonnelsCount_student.setContents("&nbsp;");
                }
            },
            selectionAppearance: "checkbox",
            selectionUpdated: function () {
                if (studentSelection) {
                    return;
                }
                let current = PersonnelsRegLG_student.getSelection().filter(function (x) {
                    return x.enabled != false
                })[0];//.filter(p->p.enabled==false);

                if (typeof (current) == "undefined") {
                    return;
                }
                if (current.nationalCode == "" || current.nationalCode == null || typeof (current.nationalCode) == "undefined") {
                    isc.Dialog.create({
                        message: "اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });

                    studentSelection = true;
                    PersonnelsRegLG_student.deselectRecord(current);
                    studentSelection = false;
                } else if (!nationalCodeExists(current.nationalCode)) {
                    if (checkIfAlreadyExist(current)) {
                        return '';
                    } else {
                        current.applicantCompanyName = current.companyName;
                        current.presenceTypeId = studentDefaultPresenceId;
                        current.registerTypeId = 2;

                        SelectedPersonnelsLG_student.data.add(Object.assign({}, current));
                        PersonnelsRegLG_student.findAll({
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [{fieldName: "nationalCode", operator: "equals", value: current.nationalCode}]
                        }).setProperty("enabled", false);
                    }
                    delete current.isClicked;
                    current.isChecked = true;
                    PersonnelsLG_student.redraw();

                    function checkIfAlreadyExist(currentVal) {
                        return SelectedPersonnelsLG_student.data.some(function (item) {
                            return (item.nationalCode === currentVal.nationalCode);
                        });
                    }
                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="student.is.duplicate"/>",
                        icon: "[SKIN]stop.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });

                    studentSelection = true;
                    PersonnelsRegLG_student.deselectRecord(current);
                    studentSelection = false;
                }
            },
            cellClick: function (record, rowNum, colNum) {
                if (colNum === 5) {

                    selectedRecord_addStudent_class = {
                        firstName: record.firstName,
                        lastName: record.lastName,
                        postTitle: record.postTitle,
                        ccpArea: record.ccpArea,
                        ccpAffairs: record.ccpAffairs,
                        personnelNo: record.personnelNo,
                        nationalCode: record.nationalCode,
                        postCode: record.postCode,
                    };

                    let window_class_Information = isc.Window.create({
                        title: "<spring:message code="personnel.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",
                            //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
                        })]
                    });

                    if (!loadjs.isDefined('personnel-information-details')) {
                        loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                    }

                    loadjs.ready('personnel-information-details', function () {
                        oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                        window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);
                    });


                    window_class_Information.show();


                }
            }
        });

        let criteriaActivePersonnelRegistered_studentjsp = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "deleted", operator: "isNull"}
            ]
        };

        PersonnelsRegLG_student.implicitCriteria = criteriaActivePersonnelRegistered_studentjsp;

        // ------------------------------------------- DynamicForm & Window -------------------------------------------

        let personnel_List_VLayout = isc.VLayout.create({
            width: "100%",
            height: "100%",
            autoDraw: false,
            border: "0px solid red", layoutMargin: 5,
            members: [
                isc.SectionStack.create({
                    sections: [{
                        title: "<spring:message code="all.persons"/>",
                        expanded: true,
                        canCollapse: false,
                        align: "center",
                        items: [
                            isc.TrHLayoutButtons.create({
                                layoutMargin: 0,
                                showEdges: false,
                                edgeImage: "",
                                width: "100%",
                                height: "40",
                                padding: 0,
                                members: [
                                    isc.ToolStripButtonAdd.create({
                                        title: 'اضافه کردن گروهي',
                                        click: function () {
                                            groupFilter("اضافه کردن گروهی", personnelUrl + "/checkPersonnelNos", checkPersonnelNosResponse, true, true,
                                                ListGrid_Class_JspClass.getSelectedRecord().courseId);
                                        }
                                    })
                                ]
                            }),
                            PersonnelsLG_student
                        ]
                    }]
                }),
            ]
        });

        let registered_List_VLayout = isc.VLayout.create({
            width: "100%",
            height: "100%",
            autoDraw: false,
            border: "0px solid red", layoutMargin: 5,
            members: [
                isc.SectionStack.create({
                    sections: [{
                        title: "<spring:message code="all.persons"/>",
                        expanded: true,
                        canCollapse: false,
                        align: "center",
                        items: [isc.TrHLayoutButtons.create({
                            layoutMargin: 0, showEdges: false, edgeImage: "", width: "100%", height: "40", padding: 0,
                            members: [
                                isc.ToolStripButtonAdd.create({
                                    title: 'اضافه کردن گروهي',
                                    click: function () {
                                        groupFilter("اضافه کردن گروهی", personnelRegUrl + "/checkPersonnelNos", checkPersonnelNosResponse, true, true,
                                            ListGrid_Class_JspClass.getSelectedRecord().courseId);
                                    }
                                })
                            ]
                        }),
                            PersonnelsRegLG_student
                        ]
                    }]
                }),

            ]
        });

        let personnelTabs = isc.TabSet.create({
            height: "50%",
            width: "100%",
            showTabScroller: false,
            tabs: [
                {
                    title: "<spring:message code='personnel.tab.persone'/>",
                    pane: personnel_List_VLayout
                },
                {
                    title: "<spring:message code='personnel.tab.registered'/>",
                    pane: registered_List_VLayout
                }
            ]
        });

        let ClassStudentWin_student = isc.Window.create({
            width: 1000,
            height: 768,
            minWidth: 1000,
            minHeight: 600,
            autoSize: false,
            items: [
                personnelTabs,
                isc.SectionStack.create({
                    sections: [{
                        title: "<spring:message code="selected.persons"/>",
                        expanded: true,
                        canCollapse: false,
                        align: "center",
                        items: [
                            SelectedPersonnelsLG_student,
                            isc.TrHLayoutButtons.create({
                                members: [
                                    isc.IButtonSave.create({
                                        top: 260,
                                        title: "<spring:message code='save'/>",
                                        align: "center",
                                        icon: "[SKIN]/actions/save.png",
                                        click: function () {

                                            SelectedPersonnelsLG_student.endEditing();
                                            let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                                            let courseId = ListGrid_Class_JspClass.getSelectedRecord().courseId;
                                            let equalCourseIds = [];
                                            equalCourseIds.add(courseId);
                                            if (SelectedPersonnelsLG_student.data.toArray().getLength() > 0) {

                                                addValidStudents(classId, courseId, equalCourseIds, SelectedPersonnelsLG_student.data.toArray());
                                            }
                                            // SelectedPersonnelsLG_student.data.clearAll();
                                        }
                                    }),
                                    isc.IButtonCancel.create({
                                        top: 260,
                                        title: "<spring:message code='cancel'/>",
                                        align: "center",
                                        icon: "[SKIN]/actions/cancel.png",
                                        click: function () {

                                            SelectedPersonnelsLG_student.invalidateCache();
                                            ClassStudentWin_student.close();
                                        }
                                    }),
                                ],
                            }),
                        ]
                    }]
                }),
            ]
        });

        let evaluationViewloader = isc.ViewLoader.create({
            width: "100%",
            height: "100%",
            autoDraw: true,
            loadingMessage: " "
        });

        let evaluationWindowViewloader = isc.Window.create({
            width: 800,
            height: 900,
            autoSize: false,
            autoCenter: true,
            isModal: true,
            showModalMask: true,
            align: "center",
            autoDraw: false,
            dismissOnEscape: true,
            items: [
                evaluationViewloader
            ]
        });

        // ------------------------------------------- Page UI -------------------------------------------
        isc.TrVLayout.create({
            members: [
                StudentsLG_student
            ],
        });

        // ------------------------------------------- Functions -------------------------------------------
        function refreshStudentsLG_student() {
            // StudentsLG_student.filterByEditor();
            StudentsLG_student.invalidateCache();

        }

        function addStudent_student() {
            let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            if (classRecord == null || classRecord.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            ClassStudentWin_student.setTitle("<spring:message code="add.student.to.class"/> \'" + classRecord.titleClass + "\'");
            let cr = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "courseId", operator: "equals", value: classRecord.courseId}]
            };
            PersonnelsLG_student.invalidateCache();
            PersonnelsLG_student.setImplicitCriteria(cr);
            PersonnelsLG_student.fetchData();
            PersonnelsRegLG_student.invalidateCache();
            PersonnelsRegLG_student.fetchData();
            SelectedPersonnelsLG_student.setData([]);
            ClassStudentWin_student.show();
        }

        function class_add_students_result(resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                ClassStudentWin_student.close();
                refreshLG(StudentsLG_student);
                let messages = JSON.parse(resp.data);
                let invalMessage = " ";
                let timeOut = 5000;
                if (messages.names !== null && messages.names !== undefined) {
                    invalMessage = "<spring:message code="for"/>" + " " + "<spring:message code="student.plural"/>" + " " + messages.names + " "
                        + "<spring:message code="message.define.applicant.company"/>";
                    timeOut = 15000
                }
                let OK = createDialog("info", messages.accepted + " " + "<spring:message code="message.students.added.successfully"/>"
                    + "<br/>" + invalMessage,

                    "<spring:message code="msg.command.done"/>");
                setTimeout(function () {
                    OK.close();
                }, timeOut);
            } else {
                let OK = createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="error"/>");
                setTimeout(function () {
                    OK.close();
                }, 5000);
            }
        }

        function removeStudent_student() {
            let studentIds = new Array();
            let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
            let studentRecord = StudentsLG_student.getSelectedRecords();

            if (studentRecord.length < 1) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                let Dialog_Delete = isc.Dialog.create({
                    message: "<spring:message code='msg.record.remove.ask'/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code='msg.remove.title'/>",
                    buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                        title: "<spring:message code='no'/>"
                    })],
                    buttonClick: function (button, index) {
                        this.close();

                        if (index == 0) {
                            studentRemoveWait = isc.Dialog.create({
                                message: "<spring:message code='msg.waiting'/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code='message'/>"
                            });

                            for (let i = 0; i < studentRecord.getLength(); i++) {
                                studentIds.add(studentRecord[i].id)
                            }

                            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + studentIds, "DELETE", null, class_remove_student_result));
                            //  isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/" + studentRecord.id, "DELETE", null, class_remove_student_result));
                        }
                    }
                });
            }
        };

        function class_remove_student_result(resp) {
            studentRemoveWait.close();
            if (resp.httpResponseCode == 200) {
                simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                refreshLG(StudentsLG_student);
            } else if (resp.httpResponseCode == 406) {
                createDialog('info', resp.httpResponseText, 'خطا در حذف فراگير(ان)');
                refreshLG(StudentsLG_student);
            } else if (resp.data == false) {
                let ERROR = isc.Dialog.create({
                    message: "<spring:message code='msg.student.remove.error'/>",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            } else {
                let ERROR = isc.Dialog.create({
                    message: "<spring:message code='msg.record.remove.failed'/>",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            }
        };

        function ListGrid_Cell_Update_Student(record, newValue, item) {
            // var updating = {};
            // if (item.name === "applicantCompanyName") {
            //     updating.applicantCompanyName = newValue;
            //     updating.presenceTypeId = record.presenceTypeId;
            // } else if (item.name === "presenceTypeId") {
            //     updating.applicantCompanyName = record.applicantCompanyName;
            //     updating.presenceTypeId = newValue;
            // }
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/update-presence-type-id/" + record.id + "/" + newValue, "PUT", null, class_student_update_student_result));
        }

        function class_student_update_student_result(resp) {
            wait.close();
            let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
            if (resp.httpResponseCode === 200) {
                refreshLG(StudentsLG_student);
            }
            <%--else {--%>
            <%--isc.Dialog.create({--%>
            <%--message: "<spring:message code='msg.operation.error'/>",--%>
            <%--icon: "[SKIN]stop.png",--%>
            <%--title: "<spring:message code='message'/>"--%>
            <%--});--%>
            <%--}--%>
        }

        function addValidStudents(classId, courseId, equalCourseIds, studentsDataArray) {

            let warnStudents = [];
            let warnPreCourseStudents = [];
            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "equalCourseIds/" + courseId, "GET", null, function (response) {

                JSON.parse(response.data).forEach(q => equalCourseIds.add(q));
                let checkAll = 0;

                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "preCourse/" + courseId, "GET", null, function (resp) {

                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                let preCourseIds = JSON.parse(resp.httpResponseText).map(q => q.id);
                for (let inx = 0; inx < studentsDataArray.length; inx++) {

                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "personnel-training/" + studentsDataArray[inx].nationalCode + "/" +
                    studentsDataArray[inx].personnelNo, "GET", null, function (resp) {

                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                            let personnelCourses = (JSON.parse(resp.httpResponseText).response.data).map(q => q.courseId);
                            if (preCourseIds.every(pq => personnelCourses.includes(pq))) {

                                if(equalCourseIds.some(eq => personnelCourses.includes(eq))) {
                                    warnStudents.add(studentsDataArray[inx]);
                                }
                            } else {
                                warnPreCourseStudents.add(studentsDataArray[inx]);
                            }

                            checkAll ++;
                            if (studentsDataArray.length-1 === checkAll-1) {
                                var uniqueWarnStudents = warnStudents.filter((nationalCode, index, arr) => arr.indexOf(nationalCode) === index).sort();
                                studentsDataArray.removeList(warnPreCourseStudents);
                                validateStudents(uniqueWarnStudents, warnPreCourseStudents, classId, studentsDataArray);
                            }

                        } else {

                            var ERROR = isc.Dialog.create({
                                message: "<spring:message code='exception.un-managed'/>",
                                icon: "[SKIN]stop.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                ERROR.close();
                            }, 8000);
                            inx = studentsDataArray.length-1;
                        }
                    }));
                }

                } else {
                    createDialog("info", "<spring:message code='exception.un-managed'/>");
                }
                }));
            }));
        }

        function validateStudents(warnStudents, warnPreCourseStudents, classId, studentsDataArray) {

            let preCourseNames = "";
            let names = "";

            if (warnPreCourseStudents.length > 0) {

                for (var j = 0; j < warnPreCourseStudents.length; j++) {
                    preCourseNames = preCourseNames.concat(warnPreCourseStudents[j].firstName + " " + warnPreCourseStudents[j].lastName);
                    if (j !== warnPreCourseStudents.length -1)
                        preCourseNames = preCourseNames.concat(", ");
                }
            }

            if (warnStudents.length > 0) {

                for (var j = 0; j < warnStudents.length; j++) {
                    names = names.concat(warnStudents[j].firstName + " " + warnStudents[j].lastName);
                    if (j !== warnStudents.length -1)
                        names = names.concat(", ");
                }
            }

            if (warnPreCourseStudents.length > 0 || warnStudents.length > 0) {

                let DynamicForm_Warn_Students = isc.DynamicForm.create({
                    width: 600,
                    height: 100,
                    padding: 6,
                    titleAlign: "right",
                    fields: [
                        {
                            name: "preCourseText",
                            width: "100%",
                            colSpan: 2,
                            value: "<spring:message code='msg.class.student.not.pass.pre.course.warn'/>",
                            showTitle: false,
                            editorType: 'staticText'
                        },
                        {
                            name: "warnPreCourseNames",
                            width: "100%",
                            colSpan: 2,
                            title: "<spring:message code="title"/>",
                            showTitle: false,
                            editorType: 'textArea',
                            canEdit: false
                        },
                        {
                            type: "RowSpacerItem"
                        },
                        {
                            name: "text",
                            width: "100%",
                            colSpan: 2,
                            value: "<spring:message code='msg.class.student.pass.course.warn'/>",
                            showTitle: false,
                            editorType: 'staticText'
                        },
                        {
                            name: "warnNames",
                            width: "100%",
                            colSpan: 2,
                            title: "<spring:message code="title"/>",
                            showTitle: false,
                            editorType: 'textArea',
                            canEdit: false
                        }
                    ]
                });

                DynamicForm_Warn_Students.getItem("preCourseText").hide();
                DynamicForm_Warn_Students.getItem("warnPreCourseNames").hide();
                DynamicForm_Warn_Students.getItem("text").hide();
                DynamicForm_Warn_Students.getItem("warnNames").hide();

                if (warnPreCourseStudents.length > 0) {

                    DynamicForm_Warn_Students.getItem("preCourseText").show();
                    DynamicForm_Warn_Students.getItem("warnPreCourseNames").show();
                    DynamicForm_Warn_Students.setValue("warnPreCourseNames", preCourseNames);
                }
                if (warnStudents.length > 0) {

                    DynamicForm_Warn_Students.getItem("text").show();
                    DynamicForm_Warn_Students.getItem("warnNames").show();
                    DynamicForm_Warn_Students.setValue("warnNames", names);
                }

                let Window_Warn_Students = isc.Window.create({
                    width: 600,
                    height: 150,
                    numCols: 2,
                    title: "<spring:message code='student.plural'/>",
                    items: [
                        DynamicForm_Warn_Students,
                        isc.MyHLayoutButtons.create({
                        members: [
                            isc.IButtonSave.create({
                                title: "<spring:message code="continue"/>",
                                click: function () {
                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/register-students/" + classId, "POST",
                                        JSON.stringify(studentsDataArray), class_add_students_result));
                                    Window_Warn_Students.close();
                                }
                            }),
                            isc.IButtonCancel.create({
                                title: "<spring:message code="cancel"/>",
                                    click: function () {
                                    wait.close();
                                    Window_Warn_Students.close();
                                }
                            })
                        ]
                        })
                    ]
                });

                let appCompany = SelectedPersonnelsLG_student.getData().map(std => std.applicantCompanyName);
                if (appCompany.contains(undefined)) {
                    createDialog("info", "لطفا ابتدا شرکت اعلام کننده همه فراگیران را مشخص کنید");
                } else {
                    Window_Warn_Students.show();
                }

            } else {
                let appCompany = SelectedPersonnelsLG_student.getData().map(std => std.applicantCompanyName);
                if (appCompany.contains(undefined)) {
                    createDialog("info", "لطفا ابتدا شرکت اعلام کننده همه فراگیران را مشخص کنید");
                } else {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/register-students/" + classId, "POST",
                        JSON.stringify(studentsDataArray), class_add_students_result));
                }
            }
        }

        function loadPage_student() {
            let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            if (!(classRecord === undefined || classRecord == null)) {
                StudentsDS_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;

                btnAdd_student_class.setVisibility(true);
                btnRemove_student_class.setVisibility(true);

                if (classRecord.classStatus === "3" || classRecord.classStatus === "4"
                     || classRecord.classStatus === "5") {
                    //StudentTS_student.setVisibility(false)
                    btnAdd_student_class.setVisibility(false);
                    btnRemove_student_class.setVisibility(false);
                } else {
                    <sec:authorize access="hasAnyAuthority('TclassStudentsTab_ADD','TclassStudentsTab_D','TclassStudentsTab_E','TclassStudentsTab_P','TclassStudentsTab_R')">
                    StudentTS_student.setVisibility(true)

                    </sec:authorize>
                }

                StudentsLG_student.invalidateCache();
                StudentsLG_student.fetchData();
            } else {
                StudentsLG_student.setData([]);
            }
        }

        // ------------------------------------------- Duplicate Student

        function checkStudentDuplicateNationalCode() {
            let record = PersonnelsRegLG_student.getSelectedRecord().getValue("nationalCode");
            let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "checkStudentInClass/" + nationalCode + "/" + classId, "GET",
                null, "callback: student_national_code_findOne_result(rpcResponse)"));
        }

        function student_national_code_findOne_result(resp) {
            if (resp == null || resp == undefined || resp.data == "") {
                duplicateCodePerReg = true;
                let ERROR = isc.Dialog.create({
                    message: ("<spring:message code='msg.national.code.duplicate'/>"),
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            }
        }

        function evaluationStudent_student() {

            var studentId = StudentsLG_student.getSelectedRecord();
            var classId = ListGrid_Class_JspClass.getSelectedRecord();
            if (studentId == null || studentId == undefined || classId == null || classId == undefined) {
                var ERROR = isc.Dialog.create({
                    message: ("<spring:message code='global.grid.record.not.selected'/>"),
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            } else {
                isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/checkEvaluationStudentInClass/" + studentId.student.id + "/" + classId.id, "GET",
                    null, "callback: student_evaluation_class_findOne_result(rpcResponse)"));
            }
        }

        function student_evaluation_class_findOne_result(resp) {
            if (resp == null || resp == undefined || resp.data == "") {
                var ERROR = isc.Dialog.create({
                    message: ("<spring:message code='msg.operation.error'/>"),
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            } else {
                evalData = resp.data;
                // var studentId = StudentsLG_student.getSelectedRecord().student.id;
                // var classId = ListGrid_Class_JspClass.getSelectedRecord().id;

                var studentRecord = StudentsLG_student.getSelectedRecord();
                var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                switch (evalData) {
                    case "1": {
                        // evaluationViewloader.setViewURL("evaluation/reaction-form"+ studentId + "/" + classId);

                        evaluationViewloader.setViewURL("evaluation/reaction-form");
                        evaluationWindowViewloader.setTitle("<spring:message code="evaluation.reaction"/>");
                        evaluationWindowViewloader.show();
                        setTimeout(function () {
                            loadPage_reaction();
                        }, 100);

                        break;
                    }
                    case "2": {
                        evaluationViewloader.setViewURL("evaluation/learning-form");
                        evaluationWindowViewloader.setTitle("<spring:message code="evaluation.learning"/>");
                        evaluationWindowViewloader.show();
                        break;
                    }
                    case "3": {
                        evaluationViewloader.setViewURL("evaluation/behavioral-form");
                        evaluationWindowViewloader.setTitle("<spring:message code="evaluation.behavioral"/>");
                        evaluationWindowViewloader.show();
                        break;
                    }
                    case "4": {
                        evaluationViewloader.setViewURL("evaluation/results-form");
                        evaluationWindowViewloader.setTitle("<spring:message code="evaluation.results"/>");
                        evaluationWindowViewloader.show();
                        break;
                    }
                }
            }
        }

        function checkPersonnelNosResponse(url, result, addStudentsInGroupInsert) {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(result)
                , "callback: checkPersonnelNos(rpcResponse," + JSON.stringify(result) + ",'" + url + "'," + addStudentsInGroupInsert + ")"));
        }

        function checkPersonnelNos(resp, result, url, insert) {
            if (generalGetResp(resp)) {
                if (resp.httpResponseCode === 200) {
                    //------------------------------------*/
                    let len = GroupSelectedPersonnelsLG_student.data.length;
                    let list = GroupSelectedPersonnelsLG_student.data;
                    let data = JSON.parse(resp.data);
                    let allRowsOK = true;
                    var students = [];

                    function checkIfAlreadyExist(currentVal) {
                        return SelectedPersonnelsLG_student.data.some(function (item) {
                            return (item.nationalCode === currentVal.nationalCode);
                        });
                    }

                    for (let i = 0; i < len; i++) {
                        let personnelNo = list[i].personnelNo;

                        if (!result.includes(personnelNo)) {
                            continue;
                        }

                        if (personnelNo != "" && personnelNo != null && typeof (personnelNo) != "undefined") {
                            let person = data.filter(function (item) {
                                return item.personnelNo == personnelNo || item.personnelNo2 == personnelNo;
                            });

                            if (person.length == 0) {
                                allRowsOK = false;
                                list[i].error = true;
                                list[i].hasWarning = "warning";
                                list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شخصی با کد پرسنلی وارد شده وجود ندارد.</span>";
                            } else {
                                person = person[0];

                                if (person.nationalCode == "" || person.nationalCode == null || typeof (person.nationalCode) == "undefined") {
                                    allRowsOK = false;
                                    list[i].firstName = person.firstName;
                                    list[i].lastName = person.lastName;
                                    list[i].nationalCode = person.nationalCode;
                                    list[i].personnelNo1 = person.personnelNo;
                                    list[i].personnelNo2 = person.personnelNo2;
                                    list[i].isInNA = person.isInNA;
                                    list[i].scoreState = person.scoreState;
                                    list[i].error = true;
                                    list[i].hasWarning = "warning";
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">اطلاعات شخص مورد نظر ناقص است. کد ملی برای این شخص وارد نشده است.</span>";
                                } else if (nationalCodeExists(person.nationalCode)) {
                                    allRowsOK = false;
                                    list[i].firstName = person.firstName;
                                    list[i].lastName = person.lastName;
                                    list[i].nationalCode = person.nationalCode;
                                    list[i].personnelNo1 = person.personnelNo;
                                    list[i].personnelNo2 = person.personnelNo2;
                                    list[i].isInNA = person.isInNA;
                                    list[i].scoreState = person.scoreState;
                                    list[i].error = true;
                                    list[i].hasWarning = "warning";
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">این شخص قبلا اضافه شده است.</span>";
                                } else {
                                    list[i].firstName = person.firstName;
                                    list[i].lastName = person.lastName;
                                    list[i].nationalCode = person.nationalCode;
                                    list[i].personnelNo1 = person.personnelNo;
                                    list[i].personnelNo2 = person.personnelNo2;
                                    list[i].isInNA = person.isInNA;
                                    list[i].scoreState = person.scoreState;
                                    list[i].error = false;
                                    list[i].hasWarning = "check";
                                    list[i].description = "";

                                    if (!checkIfAlreadyExist(person)) {

                                        if (students.filter(function (item) {
                                            return item.personnelNo2 == person.personnelNo2 || item.personnelNo == person.personnelNo;
                                        }).length == 0) {
                                            students.add({
                                                "firstName" : person.firstName,
                                                "lastName" : person.lastName,
                                                "personnelNo": person.personnelNo,
                                                "nationalCode" : person.nationalCode,
                                                "applicantCompanyName": person.companyName,
                                                "presenceTypeId": studentDefaultPresenceId,
                                                "registerTypeId": url.indexOf(personnelUrl + "/") > -1 ? 1 : 2
                                            });
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (students.getLength() > 0 /*allRowsOK*/ && insert) {

                        SelectedPersonnelsLG_student.endEditing();
                        let classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                        let courseId = ListGrid_Class_JspClass.getSelectedRecord().courseId;
                        let equalCourseIds = [];
                        equalCourseIds.add(courseId);
                        SelectedPersonnelsLG_student.setData(students);
                        wait.close();
                        addValidStudents(classId, courseId, equalCourseIds, students);
                        // SelectedPersonnelsLG_student.data.clearAll();
                        ClassStudentWin_student_GroupInsert.close();

                    } else {

                        GroupSelectedPersonnelsLG_student.invalidateCache();
                        GroupSelectedPersonnelsLG_student.fetchData();
                        wait.close();
                        if (insert) {
                            createDialog('info', 'شخصي جهت اضافه شدن وجود ندارد.');
                        }
                    }

                } else {
                    wait.close();
                }
            } else {
                wait.close();
            }
        }

        function checkExistInNeedsAssessment(courseId) {
            // let personnelIds = personnel.map(x => x.id);
            // isc.RPCManager.sendRequest(TrDSRequest(url, "GET", JSON.stringify(SelectedPersonnelsLG_student.data.toArray()), (resp) => {
            //
            // }));
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/check-register-students/" + courseId, "POST", JSON.stringify(SelectedPersonnelsLG_student.data.toArray()), (resp) => {
                wait.close()
                SelectedPersonnelsLG_student.setData(JSON.parse(resp.data));
                // let ids = JSON.parse(resp.data);

                // for (let i = 0; i < SelectedPersonnelsLG_student.data.length; i++) {
                //     if(ids.includes(SelectedPersonnelsLG_student.data[i].id)){
                //         SelectedPersonnelsLG_student.data[i].isNeedsAssesment = true;
                //     }
                //     else{
                //         SelectedPersonnelsLG_student.data[i].isNeedsAssesment = false;
                //     }
                // }
                SelectedPersonnelsLG_student.fetchData();
                checkRefresh = 0;
            }));
        }

        function deleteCachedValue() {
            selectedRow = {};
            listGridType = null;
            this.close();
        }

        function rowStyle(record, rowNum, colNum) {
            let result = '';
            if (this.getFieldName(colNum) == "personnelNo") {
                result += "color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;";
            }

            if (record.isChecked) {
                result += " background-color:#ededed; color:#b8b8b8 !important";
            } else if (record.isClicked) {
                result += " background-color:#929292;";
            } else if (!record.isClicked || !record.isChecked) {
                result += " background-color:white;";
            }
            return result;
        }
    }

    function sendMessage_StudentClassJsp() {

        let data = {
            type: ['sms'],
            message: MSG_msgContent.text,
            maxRepeat: MSG_repeatOptions.getItem('maxRepeat').getValue(),
            timeBMessages: MSG_repeatOptions.getItem('timeBMessages').getValue(),
            link: linkFormMLanding.getItem('link').getValue(),
        }

        data.classStudentRegistered = MSG_msgContent.users;
        data.classID = MSG_classID;

        let wait = createDialog("wait");

        isc.RPCManager.sendRequest(TrDSRequest(sendMessageUrl +
            "/sendSMS",
            "POST",
            JSON.stringify(data),
            function (resp) {
                wait.close();
                if (generalGetResp(resp)) {
                    if (resp.httpResponseCode == 200) {
                        var ERROR = isc.Dialog.create({
                            message: "پیام با موفقیت ارسال شد",
                            icon: "[SKIN]say.png",
                            title: "متن پیام"
                        });

                        setTimeout(function () {
                            ERROR.close();
                        }, 1000);

                        MSG_initMSG()
                        MSG_Window_MSG_Main.clear()
                        MSG_Window_MSG_Main.close();

                    } else {
                        createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                    }
                }
            })
        );
    }

// </script>
