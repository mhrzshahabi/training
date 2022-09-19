<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page import="static com.nicico.copper.core.SecurityUtil.hasAuthority" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>

<html>
<head>
    <title><spring:message code="training.system"/></title>
    <link rel="shortcut icon" href="<spring:url value='/images/nicico.png' />"/>

    <SCRIPT>var _set=Set; localStorage.setItem("ticketing-token","<%= accessToken %>")</SCRIPT>
    <SCRIPT>var isomorphicDir = "isomorphic/";</SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Core.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Foundation.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Containers.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Grids.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Forms.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_DataBinding.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Drawing.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Charts.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Analytics.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_FileLoader.js></SCRIPT>
    <script src="isomorphic/system/modules/ISC_RichTextEditor.js"></script>
    <SCRIPT SRC=isomorphic/skins/Nicico/load_skin.js></SCRIPT>
    <SCRIPT SRC=isomorphic/locales/frameworkMessages_fa.properties></SCRIPT>
    <!-- ---------------------------------------- Not Ok - Start ---------------------------------------- -->
    <link rel="stylesheet" href='<spring:url value="/css/commonStyle.css"/>'/>
    <link rel="stylesheet" href="<spring:url value='/css/calendar.css' />"/>
    <link rel="stylesheet" href="<spring:url value='/css/training.css' />"/>
    <link rel="stylesheet" href='<spring:url value="/static/css/OAManagementUsers.css"/>'/>
    <script src="<spring:url value='/js/calendar.js'/>"></script>
    <script src="<spring:url value='/js/jalali.js'/>"></script>
    <script src="<spring:url value='/js/training_function.js'/>"></script>
    <script src="<spring:url value='/js/all.js'/>"></script>
    <script src="<spring:url value='/js/jquery.min.js' />"></script>
    <script src="<spring:url value='/js/langConverter.js' />"></script>
    <script src="<spring:url value='/js/xlsx.full.min.js' />"></script>
    <script src="<spring:url value='/js/svg-inject.min.js' />"></script>
    <script src="<spring:url value='/js/loadjs.min.js' />"></script>
    <script src="<spring:url value='/js/VersionsWindow.js' />"></script>

    <script>
        // const set1 = new Set([1, 2, 3, 4, 5]);

        var sayBrowser = (function(){
            var ua= navigator.userAgent, tem,
                M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
            if(/trident/i.test(M[1])){
                tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
                return 'IE '+(tem[1] || '');
            }
            if(M[1]=== 'Chrome'){
                tem= ua.match(/\b(OPR|Edge?)\/(\d+)/);
                if(tem!= null) return tem.slice(1).join(' ').replace('OPR', 'Opera').replace('Edg ', 'Edge ');
            }
            M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
            if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
            return M;
        })();

        var userRoles={};
        let access= "<%= hasAuthority("shahreBabakAccess") %>"
        userRoles.shahreBabak = access;
         access= "<%= hasAuthority("sarcheshmeAccess") %>"
        userRoles.sarcheshme = access;
        access= "<%= hasAuthority("rafsanjanAccess") %>"
        userRoles.rafsanjan = access;
        access= "<%= hasAuthority("azarbayejanAccess") %>"
        userRoles.azarbayejan = access;
        access= "<%= hasAuthority("tehranManagementAccess") %>"
        userRoles.tehranRetirement = access;
        access= "<%= hasAuthority("tehranRetirementAccess") %>"
        userRoles.tehranRetirement = access;
        <%--access= "<%= hasAuthority("ROLE.Training.admin_role") %>"--%>
        <%--userRoles.admin = access;--%>
        let postAdmin= "<%= hasAuthority("Admin_Post_Access") %>"


       /* jQuery.loadScript = function (url, callback) {
            jQuery.ajax({
                url: url,
                dataType: 'script',
                success: callback,
                async: false
            });
        }*/

        String.prototype.toEnglishDigit = function() {
            var find = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
            var replace = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
            var replaceString = this;
            var regex;
            for (var i = 0; i < find.length; i++)
            {
                regex = new RegExp(find[i], "g");
                replaceString = replaceString.replace(regex, replace[i]);
            }
            return replaceString;
        };

        function groupFilter(title,inputURL,func,isCheck=false,addStudentsInGroupInsert=false, courseId=0,withNA=true){
            TabSet_GroupInsert_JspStudent=isc.TabSet.create({
                ID:"leftTabSet",
                autoDraw:false,
                tabBarPosition: "top",
                width: "100%",
                height: 115,
                tabs: [
                    { title: "ورود  مستقیم",
                        pane: isc.DynamicForm.create({
                            height: "6%",
                            width:"100%",
                            left:0,
                            align:"left",
                            numCols: 5,
                            colWidths: ["0%","50%","10%","30%"],
                            fields: [
                                /*{
                                    title: "",
                                    type: "select",
                                    padding:50,
                                    margin:5,
                                    defaultValue: "کد پرسنلی 6 رقمی",
                                    valueMap: ["کد پرسنلی 6 رقمی", "کد پرسنلی 10 رقمی"]
                                },*/
                                {
                                    ID:"DynamicForm_GroupInsert_Textbox_JspStudent",
                                    title:"",
                                    type: "TextItem",
                                    length: 10000,
                                    controlStyle : "inputRTL",cellStyle  : "inputRTL",showRTL :false,
                                    transformPastedValue:function(item, form, pastedValue)
                                    {
                                        item.setValue(pastedValue.split('\n').filter(p=>p!='').join(',')) ;
                                    }

                                },
                                {
                                    type: "button",
                                    title: "اضافه کردن به لیست",
                                    startRow: false,
                                    click:function () {
                                        let value=DynamicForm_GroupInsert_Textbox_JspStudent.getValue();
                                        if(value != null&& value != "" && typeof(value) != "undefined")
                                        {
                                            value=value.toEnglishDigit();
                                            value=value.replace(/،/g,',');

                                            let personnels=value.split(',');
                                            let records=[];
                                            let len=personnels.size();

                                            for (let i=0;i<len;i++){
                                                if(isNaN(personnels[i])){
                                                    continue;
                                                }
                                                else if(GroupSelectedPersonnelsLG_student.data.filter(function (item) {
                                                    return item.personnelNo==personnels[i];
                                                }).length==0){

                                                    let current={personnelNo:personnels[i]};
                                                    records.push(current);
                                                }
                                            }

                                            let uniqueRecords = [];

                                            for (let i=0; i < records.length; i++) {
                                                if (uniqueRecords.filter(function (item) {return item.personnelNo == records[i].personnelNo;}).length==0) {
                                                    uniqueRecords.push(records[i]);
                                                }
                                            }

                                            GroupSelectedPersonnelsLG_student.setData(GroupSelectedPersonnelsLG_student.data.concat(uniqueRecords));

                                            GroupSelectedPersonnelsLG_student.invalidateCache();
                                            GroupSelectedPersonnelsLG_student.fetchData();

                                            if(uniqueRecords.length > 0 && isCheck){
                                                func(inputURL+"/"+courseId,uniqueRecords.map(function(item) {return item.personnelNo;}),false);
                                            }

                                            DynamicForm_GroupInsert_Textbox_JspStudent.setValue('');
                                            if(uniqueRecords.length > 0){
                                                createDialog("info", "کدهای پرسنلی به لیست اضافه شدند.");
                                            }
                                            else{
                                                createDialog("info", "پرسنل جدیدی برای اضافه کردن وجود ندارد.");
                                            }

                                        }
                                    }
                                }
                            ]
                        })
                    },
                    {title: "فایل اکسل", width:200, overflow:"hidden",
                        pane: isc.DynamicForm.create({
                            height: "100%",
                            width:"100%",
                            numCols: 4,
                            colWidths: ["10%","40%","20%","20%"],
                            fields: [
                                {
                                    ID:"DynamicForm_GroupInsert_FileUploader_JspStudent",
                                    name:"DynamicForm_GroupInsert_FileUploader_JspStudent",
                                    type:"imageFile",
                                    title:"مسیر فایل",
                                },
                                {
                                    type: "button",
                                    startRow:false,
                                    title: "آپلود فايل",
                                    click:function () {
                                        let address=DynamicForm_GroupInsert_FileUploader_JspStudent.getValue();

                                        if(address==null){
                                            createDialog("info", "فايل خود را انتخاب نماييد.");
                                        }else{
                                            var ExcelToJSON = function() {

                                                this.parseExcel = function(file) {
                                                    var reader = new FileReader();
                                                    var records = [];

                                                    reader.onload = function(e) {
                                                        var data = e.target.result;
                                                        var workbook = XLSX.read(data, {
                                                            type: 'binary'
                                                        });
                                                        var isEmpty=true;

                                                        workbook.SheetNames.forEach(function(sheetName) {
                                                            // Here is your object
                                                            var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                            //var json_object = JSON.stringify(XL_row_object);

                                                            for(let i=0;i<XL_row_object.length;i++){
                                                                if(isNaN(Object.values(XL_row_object[i])[0])){
                                                                    continue;
                                                                }
                                                                else if(GroupSelectedPersonnelsLG_student.data.filter(function (item) {
                                                                    return item.personnelNo==Object.values(XL_row_object[i])[0];
                                                                }).length==0){
                                                                    let current={personnelNo:Object.values(XL_row_object[i])[0]};
                                                                    records.add(current);
                                                                    isEmpty=false;

                                                                    continue;
                                                                }
                                                                else{
                                                                    isEmpty=false;

                                                                    continue;
                                                                }
                                                            }

                                                            DynamicForm_GroupInsert_FileUploader_JspStudent.setValue('');
                                                        });

                                                        if(records.length > 0){

                                                            let uniqueRecords = [];

                                                            for (let i=0; i < records.length; i++) {
                                                                if (uniqueRecords.filter(function (item) {return item.personnelNo == records[i].personnelNo;}).length==0) {
                                                                    uniqueRecords.push(records[i]);
                                                                }
                                                            }


                                                            GroupSelectedPersonnelsLG_student.setData(GroupSelectedPersonnelsLG_student.data.concat(uniqueRecords));
                                                            GroupSelectedPersonnelsLG_student.invalidateCache();
                                                            GroupSelectedPersonnelsLG_student.fetchData();

                                                            if(isCheck){
                                                                func(inputURL+"/"+courseId,uniqueRecords.map(function(item) {return item.personnelNo;}),false);
                                                            }

                                                            createDialog("info", "فایل به لیست اضافه شد.");
                                                        }else{
                                                            if(isEmpty){
                                                                createDialog("info", "خطا در محتویات فایل");
                                                            }else{
                                                                createDialog("info", "پرسنل جدیدی برای اضافه کردن وجود ندارد.");
                                                            }

                                                        }

                                                    };

                                                    reader.onerror = function(ex) {
                                                        createDialog("info", "خطا در باز کردن فایل");
                                                    };

                                                    reader.readAsBinaryString(file);
                                                };
                                            };
                                            let split=$('[name="DynamicForm_GroupInsert_FileUploader_JspStudent"]')[0].files[0].name.split('.');

                                            if(split[split.length-1]=='xls'||split[split.length-1]=='csv'||split[split.length-1]=='xlsx'){
                                                var xl2json = new ExcelToJSON();
                                                xl2json.parseExcel($('[name="DynamicForm_GroupInsert_FileUploader_JspStudent"]')[0].files[0]);
                                            }else{
                                                createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                            }

                                        }
                                    }
                                },
                                {
                                    type: "button",
                                    title: "فرمت فايل ورودی",
                                    click:function () {
                                        window.open("excel/sample-excel.xlsx");
                                    }
                                },
                            ]
                        })
                    }
                ]
            });

            ClassStudentWin_student_GroupInsert = isc.Window.create({
                width: 1050,
                height: 750,
                minWidth: 700,
                minHeight: 500,
                autoSize: false,
                overflow:"hidden",
                title:title,
                items: [isc.HLayout.create({
                    width:1050,
                    height: "88%",
                    autoDraw: false,
                    overflow:"auto",
                    align: "center",
                    members: [
                        isc.TrLG.create({
                            ID: "GroupSelectedPersonnelsLG_student",
                            showFilterEditor: false,
                            editEvent: "click",
                            //listEndEditAction: "next",
                            enterKeyEditAction: "nextRowStart",
                            canSort:false,
                            canEdit:true,
                            filterOnKeypress: true,
                            selectionType: "single",
                            fields: [
                                {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true,width:"10%"},
                                {
                                    name: "personnelNo",
                                    title: "پرسنلی وارد شده",
                                    width:130,
                                    editorExit:function(editCompletionEvent, record, newValue, rowNum, colNum)
                                    {
                                        isEditing=false;
                                        if(editCompletionEvent=='escape'){
                                            return true;
                                        }else if(editCompletionEvent=='enter'){
                                            if (newValue != null) {
                                                if(GroupSelectedPersonnelsLG_student.data.filter(function (item) {
                                                    return item.personnelNo==newValue;
                                                }).length==0){

                                                    if(isCheck){
                                                        func(inputURL+"/"+courseId,[newValue],false);
                                                    }
                                                    return true;
                                                }
                                                else{
                                                    createDialog("info", "<spring:message code="msg.record.duplicate" />", "<spring:message code="error"/>");
                                                    return false;
                                                }
                                            }
                                            else {return true}
                                        }else if(editCompletionEvent=='programmatic') {
                                            if(newValue!=''||newValue!=null||typeof(newValue)=='undefined'){
                                                isEditing=true;
                                                return false;
                                            }
                                        }
                                    },
                                    change:function (form,item,value) {
                                        if(!value.match(/^\d{0,10}$/)){
                                            item.setValue(value.substring(0,value.length-1));
                                        }
                                    }
                                },
                                {name: "firstName", title: "<spring:message code="firstName"/>", canEdit: false ,autoFithWidth:true},
                                {name: "lastName", title: "<spring:message code="lastName"/>", canEdit: false ,autoFithWidth:true},
                                {name: "nationalCode", title: "<spring:message code="national.code"/>", canEdit: false ,autoFithWidth:true},
                                {name: "personnelNo1", title: "<spring:message code="personnel.no"/>", canEdit: false ,autoFithWidth:true},
                                {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", canEdit: false ,autoFithWidth:true,},
                                {name: "isInNA", title: "نیازسنجی", canEdit: false ,autoFithWidth:true ,type: "boolean"},
                                {name: "scoreState", title: "سوابق", canEdit: false ,autoFithWidth:true,valueMap: {
                                        400: "قبول با نمره",
                                        401: "قبول بدون نمره",
                                        410: "ثبت نام شده",
                                    }
                                },
                                {name: "description", title: "<spring:message code="description"/>", canEdit: false ,width:300, align: "left"},
                                {name: "error", canEdit: false ,hidden:true,autoFithWidth:true},
                                {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".png", canEdit: false}
                            ],
                            gridComponents: [TabSet_GroupInsert_JspStudent, "header", "body"],
                            canRemoveRecords: true,
                            deferRemoval:true,
                            removeRecordClick:function (rowNum){
                                GroupSelectedPersonnelsLG_student.data.removeAt(rowNum);
                            }
                        })
                    ]
                }),
                    isc.TrHLayoutButtons.create({
                        members: [
                            isc.IButtonSave.create({
                                top: 260,
                                title: "<spring:message code='save'/>",
                                align: "center",
                                icon: "[SKIN]/actions/save.png",
                                click: function () {

                                    let getEditCells=GroupSelectedPersonnelsLG_student.getAllEditCells();

                                    if(getEditCells.size()!=0){
                                        let value=GroupSelectedPersonnelsLG_student.getEditValue(getEditCells[0][0],getEditCells[0][1]);

                                        if(value == "" || value == null || typeof(value) == "undefined"){
                                            GroupSelectedPersonnelsLG_student.cancelEditing(getEditCells[0][0]);
                                        }else{
                                            if(GroupSelectedPersonnelsLG_student.data.filter(function (item) {
                                                return item.personnelNo==value;
                                            }).length==0){
                                                GroupSelectedPersonnelsLG_student.saveAndEditNextRow();
                                            }
                                            else{
                                                GroupSelectedPersonnelsLG_student.cancelEditing(getEditCells[0][0]);
                                            }
                                        }
                                    }

                                    let len=GroupSelectedPersonnelsLG_student.data.length;
                                    let list=GroupSelectedPersonnelsLG_student.data;
                                    let result=[];

                                    for (let index = 0; index < len; index++) {
                                        if(list[index].personnelNo != "" && list[index].personnelNo != null && typeof(list[index].personnelNo) != "undefined")
                                        {
                                            if (result.filter(function (item) {return (item.personnelNo2 && item.personnelNo2 == GroupSelectedPersonnelsLG_student.data[index].personnelNo2) || (item.personnelNo1 && item.personnelNo1 == GroupSelectedPersonnelsLG_student.data[index].personnelNo1);}).length==0) {
                                                result.push(list[index].personnelNo)
                                            }
                                        }
                                    }

                                    if (func) {
                                        func(inputURL+"/"+courseId,result,true);
                                    }
                                }
                            }), isc.IButtonCancel.create({
                                top: 260,
                                title: "<spring:message code='cancel'/>",
                                align: "center",
                                icon: "[SKIN]/actions/cancel.png",
                                click: function () {
                                    ClassStudentWin_student_GroupInsert.close();
                                }
                            })
                        ]
                    })
                ]
            });

            if(!withNA){
                GroupSelectedPersonnelsLG_student.getField('isInNA').hidden=true;
                GroupSelectedPersonnelsLG_student.getField('scoreState').hidden=true;
            }else{
                GroupSelectedPersonnelsLG_student.getField('isInNA').hidden=false;
                GroupSelectedPersonnelsLG_student.getField('scoreState').hidden=false;
            }

            TabSet_GroupInsert_JspStudent.selectTab(0);
            GroupSelectedPersonnelsLG_student.discardAllEdits();
            GroupSelectedPersonnelsLG_student.data.clearAll();
            /*GroupSelectedPersonnelsLG_student.addData({nationalCode: ""});*/

            DynamicForm_GroupInsert_FileUploader_JspStudent.setValue('');
            DynamicForm_GroupInsert_Textbox_JspStudent.setValue('');
            ClassStudentWin_student_GroupInsert.show();
        }

        class ExportToFile {

            constructor() {

            }

            //Base Methods
            static getAllFields(listGrid, exceptColumn) {
                let data = listGrid.getAllFields();
                let len = data.length;
                let fields = [{'title': 'رديف', 'name': 'rowNum'}];
                let isValueMap = [false];

                //let nameOfFields = [];

                if((typeof (data[0].showIf) == "undefined" || data[0].showIf == "true" || data[0].showIf == null) && data[0].rowNumberStart==null && (!exceptColumn || !exceptColumn.some(p=>p==data[0].name))) {
                    fields.push({'title': data[0].title, 'name': data[0].name});
                    isValueMap.push((typeof (data[0].valueMap) == "undefined") ? false : true);
                }

                for (let i = 1; i < len; i++) {
                    if ((typeof (data[i].showIf) == "undefined" || data[i].showIf == "true" || data[i].showIf == null) && data[i].rowNumberStart==null && (!exceptColumn || !exceptColumn.some(p=>p==data[i].name))) {
                        fields.push({'title': data[i].title, 'name': data[i].name});
                        isValueMap.push((typeof (data[i].valueMap) == "undefined") ? false : true);
                    }
                }

                return {fields: fields, isValueMap: isValueMap};
            }

            static getData(row, array, index) {
                if (array.length - 1 > index) {
                    if (row[array[index]] == null) {
                        return "";
                    }
                    return this.getData(row[array[index]], array, ++index);
                } else if (array.length - 1 == index) {

                    return row[array[index]];
                } else {
                    return '';
                }
            }

            static getAllData(listGrid, exceptColumn) {
                let rows = listGrid.getOriginalData().localData.toArray();
                let result = this.getAllFields(listGrid, exceptColumn);
                let fields = result.fields;
                let isValueMaps = result.isValueMap;

                let data = [];

                for (let i = 0; i < rows.length; i++) {

                    data[i] = {};

                    for (let j = 0; j < fields.length; j++) {
                        if (fields[j].name == 'rowNum') {
                            data[i][fields[j].name] = (i + 1).toString();
                        } else {
                            let tmpStr = ExportToFile.getData(rows[i], fields[j].name.split('.'), 0);
                            data[i][fields[j].name] = typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? tmpStr : listGrid.getDisplayValue(fields[j].name, tmpStr));
                        }
                    }
                }
                return {data, fields};
            }

            static generateTitle(parentlistGrid) {
                let classRecord = parentlistGrid.getSelectedRecord();
                let result = this.getAllFields(parentlistGrid);
                let fields = result.fields;
                let isValueMaps = result.isValueMap;
                var titr = "";

                for (let j = 1; j < fields.length; j++) {
                    let tmpStr = ExportToFile.getData(classRecord, fields[j].name.split('.'), 0);
                    tmpStr=(typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? (tmpStr + ' ').trim().replace(/(<a)([^>href]+)(href)([ ]*)(=)([ ]*)\"([^\"]*)\"([^>]*)(>)([^<]*)(<\/a>)/g, "[link href=$7]$10[/link]").replace(/<[^>ابپتثجچحخدذرزژصضسشطظکگفقعغونيي]*>/g, "") : parentlistGrid.getDisplayValue(fields[j].name, tmpStr).trim()));

                    if(tmpStr && tmpStr != '')
                        titr += fields[j].title + ': ' + tmpStr + ' - ';
                }

                titr = titr.substring(0, titr.length - 3);

                return titr;
            }

            static generateCriteria(listGrid){

                if(listGrid.implicitCriteria){
                    let implicitCriteria = JSON.parse(JSON.stringify(listGrid.implicitCriteria)) ;
                    let criteria = listGrid.getCriteria();

                    if(criteria.criteria){
                        for (let i = 0; i < criteria.criteria.length ; i++) {
                            implicitCriteria.criteria.push(criteria.criteria[i]);
                        }
                    }

                    return implicitCriteria;
                }else{
                    return listGrid.getCriteria();
                }

            }

            //Send Data Methods
            static exportToExcelFromClient(fields, data, titr, pageName, exceptColumn) {
                let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/export-to-file/exportExcelFromClient/",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "myToken", type: "hidden"},
                            {name: "fields", type: "hidden"},
                            {name: "data", type: "hidden"},
                            {name: "titr", type: "hidden"},
                            {name: "pageName", type: "hidden"}
                        ]
                });
                downloadForm.setValue("fields", JSON.stringify(fields.toArray()));
                downloadForm.setValue("data", JSON.stringify(data.toArray()));
                downloadForm.setValue("titr", titr);
                downloadForm.setValue("pageName", pageName);
                downloadForm.show();
                downloadForm.submitForm();
            }

            static exportToExcelFromServer(fields, fileName, criteriaStr, sortBy,startRow, len, titr, pageName, valueMaps) {

                let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/export-to-file/exportExcelFromServer/",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "myToken", type: "hidden"},
                            {name: "fields", type: "hidden"},
                            {name: "fileName", type: "hidden"},
                            {name: "titr", type: "hidden"},
                            {name: "pageName", type: "hidden"},
                            {name: "_sortBy", type: "hidden"},
                            {name: "_len", type: "hidden"},
                            {name: "_startRow", type: "hidden"},
                            {name: "criteriaStr", type: "hidden"},
                            {name: "valueMaps", type: "hidden"}
                        ]
                });


                downloadForm.setValue("fields", JSON.stringify(fields.toArray()));
                downloadForm.setValue("titr", titr);
                downloadForm.setValue("fileName", fileName);
                downloadForm.setValue("pageName", pageName);
                downloadForm.setValue("_sortBy", sortBy);
                downloadForm.setValue("_len", len);
                downloadForm.setValue("_startRow", startRow);
                downloadForm.setValue("criteriaStr", criteriaStr);
                downloadForm.setValue("valueMaps", JSON.stringify(valueMaps));
                downloadForm.show();
                downloadForm.submitForm();
            }

            static exportToExcelFromRestUrl(fields, restUrl, criteria, sortBy,startRow, len, titr, pageName, valueMaps) {

                let downloadForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/training/export-to-file/exportExcelFromRestController/",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            //{name: "myToken", type: "hidden"},
                            {name: "fields", type: "hidden"},
                            {name: "titr", type: "hidden"},
                            {name: "restUrl", type: "hidden"},
                            {name: "pageName", type: "hidden"},
                            {name: "_sortBy", type: "hidden"},
                            {name: "_len", type: "hidden"},
                            {name: "_startRow", type: "hidden"},
                            {name: "valueMaps", type: "hidden"}
                        ]
                });

                downloadForm.setValue("fields", JSON.stringify(fields.toArray()));
                downloadForm.setValue("titr", titr);
                downloadForm.setValue("restUrl", restUrl);
                downloadForm.setValue("pageName", pageName);
                downloadForm.setValue("_sortBy", sortBy);
                downloadForm.setValue("_len", len);
                downloadForm.setValue("_startRow", startRow);
                downloadForm.setValue("valueMaps", JSON.stringify(valueMaps));

                for (let i = 0; i < criteria.length ; i++) {
                    downloadForm.addField({name: criteria[i].name, type: "hidden"});
                    if(criteria[i].name=='criteria'){
                        downloadForm.setValue(criteria[i].name, JSON.stringify(criteria[i].value));
                    }else{
                        downloadForm.setValue(criteria[i].name, criteria[i].value);
                    }
                }

                downloadForm.show();
                downloadForm.submitForm();
            }

            //Get Data For Send
            static downloadExcelFromClient(listGrid, parentListGrid, titr, pageName, exceptColumn) {

                let tmptitr = '';

                if ((titr.length === 0) && parentListGrid != null) {
                    tmptitr = this.generateTitle(parentListGrid);
                } else {
                    tmptitr = titr;
                }

                let result = this.getAllData(listGrid, exceptColumn);


                this.exportToExcelFromClient(result.fields, result.data, tmptitr, pageName, exceptColumn);
            }

            static downloadExcelFromServer(listGrid, fileName,startRow, len, parentListGrid, titr, pageName, criteria) {

                let tmptitr = '';

                if ((titr.length === 0) && parentListGrid != null) {
                    tmptitr = this.generateTitle(parentListGrid);
                } else {
                    tmptitr = titr;
                }

                let fields = this.getAllFields(listGrid);
                //let criteria=JSON.stringify(listGrid.data.criteria.criteria);
                let sort = listGrid.getSort();
                let sortStr='';

                let valueMaps =[];

                for (var v = 0; v <fields.isValueMap.length ; v++) {
                    if(fields.isValueMap[v]){
                        let parameter = fields.fields[v].name;
                        valueMaps.add({value : parameter, map : listGrid.getField(parameter).valueMap});
                    }
                }


                if (sort != null && sort.size() != 0){

                    if(sort.size() == 1){
                        sortStr=(listGrid.getSort()[0].direction=='descending'?'-':'')+listGrid.getSort()[0].property

                        /*let sortField=NALG_PGG.getFields().filter(p=>p.name==NALG_PGG.getSort()[0].property);
                        if(sortField){
                            if(sortField.valueMap&&!sortField.optionDataSource){
                                showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد ممکن است مرتب سازي اعمال شده برروي .');
                            }
                        }*/
                    }else{
                        let listSort=[];
                        for (var i = 0; i <sort.size() ; i++) {
                            listSort.push((listGrid.getSort()[i].direction=='descending'?'-':'')+listGrid.getSort()[i].property)
                        }

                        sortStr=JSON.stringify(listSort);
                    }
                }

                this.exportToExcelFromServer(fields.fields, fileName, criteria, sortStr ,startRow, len, tmptitr, pageName, valueMaps);
            }

            static downloadExcelFromRestUrl(listGrid, restUrl,startRow, len, parentListGrid, titr, pageName, criteria, exceptColumn) {

                let tmptitr = '';

                if ((titr.length === 0) && parentListGrid != null) {
                    tmptitr = this.generateTitle(parentListGrid);
                } else {
                    tmptitr = titr;
                }

                let fields = this.getAllFields(listGrid, exceptColumn);
                //let criteria=JSON.stringify(listGrid.data.criteria.criteria);
                let sort = listGrid.getSort();
                let sortStr='';

                let valueMaps =[];

                for (var v = 0; v <fields.isValueMap.length ; v++) {
                    if(fields.isValueMap[v]){
                        let parameter = fields.fields[v].name;
                        valueMaps.add({value : parameter, map : listGrid.getField(parameter).valueMap});
                    }
                }


                if (sort != null && sort.size() != 0){

                    if(sort.size() == 1){
                        sortStr=(listGrid.getSort()[0].direction=='descending'?'-':'')+listGrid.getSort()[0].property
                    }else{
                        let listSort=[];
                        for (var i = 0; i <sort.size() ; i++) {
                            listSort.push((listGrid.getSort()[i].direction=='descending'?'-':'')+listGrid.getSort()[i].property)
                        }

                        sortStr=JSON.stringify(listSort);
                    }
                }

                this.exportToExcelFromRestUrl(fields.fields, restUrl, criteria, sortStr ,startRow, len, tmptitr, pageName, valueMaps);
            }

            static showDialog(title, listgrid, fileName, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate){
                let size = listgrid.getOriginalData().size();
                let maxCount=5000;

                size = Math.min(maxCount,size);
                if(isValidate==null){
                    isValidate=function (len) {
                        return true;
                    }
                }

                if(title==null){
                    title = "خروجی اکسل";
                }

                isc.Window.create({
                    ID: "exportExcelWindow",
                    title: title,
                    autoSize: true,
                    width: 400,
                    items: [
                        isc.DynamicForm.create({
                            ID: "exportExcelForm",
                            numCols: 2,
                            colWidths: ["80%","20%"],
                            padding: 10,
                            fields: [
                                {
                                    title: "سطرهاي موجود: " + listgrid.getOriginalData().size(),
                                    type: 'staticText',
                                    width: "150",
                                    colSpan:2,
                                    height: 30
                                },
                                {
                                    name: "startRow",
                                    startRow: true,
                                    colSpan:2,
                                    width: "100%",
                                    titleOrientation: "top",
                                    title: "از کدام سطر شروع شود:",
                                    value: 1,
                                    suppressBrowserClearIcon: true,
                                    icons: [{
                                        name: "clear",
                                        src: "[SKIN]actions/close.png",
                                        width: 10,
                                        height: 10,
                                        inline: true,
                                        prompt: "پاک کردن",
                                        click: function (form, item, icon) {
                                            item.clearValue();
                                            item.focusInItem();
                                        }
                                    }],
                                    iconWidth: 16,
                                    iconHeight: 16
                                },
                                {
                                    name: "maxRow",
                                    startRow: true,
                                    colSpan:2,
                                    width: "100%",
                                    titleOrientation: "top",
                                    title: "لطفا حداکثر تعداد سطرهای موجود در اکسل را وارد نمایید:",
                                    value: size,
                                    hint: "حداکثر سطرهاي قابل چاپ: " + size,
                                    minHintWidth:'100%',
                                    suppressBrowserClearIcon: true,
                                    icons: [{
                                        name: "clear",
                                        src: "[SKIN]actions/close.png",
                                        width: 10,
                                        height: 10,
                                        inline: true,
                                        prompt: "پاک کردن",
                                        click: function (form, item, icon) {
                                            item.clearValue();
                                            item.focusInItem();
                                        }
                                    }],
                                    iconWidth: 16,
                                    iconHeight: 16
                                }
                            ]
                        }),
                        isc.TrHLayoutButtons.create({
                            members: [
                                isc.IButton.create({
                                    title: "تایید",
                                    click: function () {
                                        if (trTrim(exportExcelForm.getValue("maxRow")) != "") {

                                            /*if(Number(trTrim(exportExcelForm.getValue("maxRow")))+Number(trTrim(exportExcelForm.getValue("startRow"))) > Number(listgrid.getOriginalData().size())){
                                                createDialog("info", "مجمع سطر شروع و تعداد سطر ها در خواستي براي خروجي بيشتر از تعداد کل سطرهاي موجود است");
                                                return;
                                            }else if(Number(trTrim(exportExcelForm.getValue("maxRow"))) > size){
                                                createDialog("info", "تعداد سطرهاي وارد شده جهت خروجي، بيشتر از حداکثر تعداد سطرهاي قابل چاپ است");
                                                return;
                                            }*/

                                            if(maxCount < size){
                                                createDialog("info", "تعداد سطرهاي وارد شده جهت خروجي، بيشتر از حداکثر تعداد سطرهاي قابل چاپ است");
                                                return;
                                            }

                                            if(isValidate(trTrim(exportExcelForm.getValue("maxRow")))) {

                                                let outputRow = exportExcelForm.getValue("maxRow") > size ? size : exportExcelForm.getValue("maxRow");
                                                ExportToFile.downloadExcelFromServer(listgrid, fileName, parseInt(trTrim(exportExcelForm.getValue("startRow")))-1, outputRow, parentListGrid, titr, pageName,JSON.stringify(criteria));
                                                exportExcelWindow.close();

                                            }
                                        }
                                    }
                                }),
                                isc.IButton.create({
                                    title: "لغو",
                                    click: function () {
                                        exportExcelWindow.close();
                                    }
                                }),
                            ]
                        })
                    ]
                });

                exportExcelWindow.show();
            }

            static showDialogRestUrl(title, listgrid, restUrl, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate, exceptColumn){
                let size = listgrid.getOriginalData().size();
                let maxCount=5000;

                size = Math.min(maxCount,size);
                if(isValidate==null){
                    isValidate=function (len) {
                        return true;
                    }
                }

                if(title==null){
                    title = "خروجی اکسل";
                }

                isc.Window.create({
                    ID: "exportExcelWindow",
                    title: title,
                    autoSize: true,
                    width: 400,
                    items: [
                        isc.DynamicForm.create({
                            ID: "exportExcelForm",
                            numCols: 2,
                            colWidths: ["80%","20%"],
                            padding: 10,
                            fields: [
                                {
                                    title: "سطرهاي موجود: " + listgrid.getOriginalData().size(),
                                    type: 'staticText',
                                    width: "150",
                                    colSpan:2,
                                    height: 30
                                },
                                {
                                    name: "startRow",
                                    startRow: true,
                                    colSpan:2,
                                    width: "100%",
                                    titleOrientation: "top",
                                    title: "از کدام سطر شروع شود:",
                                    value: 1,
                                    suppressBrowserClearIcon: true,
                                    icons: [{
                                        name: "clear",
                                        src: "[SKIN]actions/close.png",
                                        width: 10,
                                        height: 10,
                                        inline: true,
                                        prompt: "پاک کردن",
                                        click: function (form, item, icon) {
                                            item.clearValue();
                                            item.focusInItem();
                                        }
                                    }],
                                    iconWidth: 16,
                                    iconHeight: 16
                                },
                                {
                                    name: "maxRow",
                                    startRow: true,
                                    colSpan:2,
                                    width: "100%",
                                    titleOrientation: "top",
                                    title: "لطفا حداکثر تعداد سطرهای موجود در اکسل را وارد نمایید:",
                                    value: size,
                                    hint: "حداکثر سطرهاي قابل چاپ: " + size,
                                    minHintWidth:'100%',
                                    suppressBrowserClearIcon: true,
                                    icons: [{
                                        name: "clear",
                                        src: "[SKIN]actions/close.png",
                                        width: 10,
                                        height: 10,
                                        inline: true,
                                        prompt: "پاک کردن",
                                        click: function (form, item, icon) {
                                            item.clearValue();
                                            item.focusInItem();
                                        }
                                    }],
                                    iconWidth: 16,
                                    iconHeight: 16
                                }
                            ]
                        }),
                        isc.TrHLayoutButtons.create({
                            members: [
                                isc.IButton.create({
                                    title: "تایید",
                                    click: function () {
                                        if (trTrim(exportExcelForm.getValue("maxRow")) != "") {
                                            /*if(Number(trTrim(exportExcelForm.getValue("maxRow")))+Number(trTrim(exportExcelForm.getValue("startRow"))) > Number(listgrid.getOriginalData().size())){
                                                createDialog("info", "مجمع سطر شروع و تعداد سطر ها در خواستي براي خروجي بيشتر از تعداد کل سطرهاي موجود است");
                                                return;
                                            }else if(Number(trTrim(exportExcelForm.getValue("maxRow"))) > size){
                                                createDialog("info", "تعداد سطرهاي وارد شده جهت خروجي، بيشتر از حداکثر تعداد سطرهاي قابل چاپ است");
                                                return;
                                            }*/

                                            if(maxCount < size){

                                                createDialog("info", "تعداد سطرهاي وارد شده جهت خروجي، بيشتر از حداکثر تعداد سطرهاي قابل چاپ است");
                                                return;
                                            }

                                            if(isValidate(trTrim(exportExcelForm.getValue("maxRow")))) {
                                                ExportToFile.downloadExcelFromRestUrl(listgrid, restUrl, parseInt(trTrim(exportExcelForm.getValue("startRow")))-1, parseInt(trTrim(exportExcelForm.getValue("maxRow"))), parentListGrid, titr, pageName, Object.keys(criteria).map(function(key) {return {'name':key, 'value':criteria[key]};}), exceptColumn);
                                                exportExcelWindow.close();
                                            }
                                        }
                                    }
                                }),
                                isc.IButton.create({
                                    title: "لغو",
                                    click: function () {
                                        exportExcelWindow.close();
                                    }
                                }),
                            ]
                        })
                    ]
                });

                exportExcelWindow.show();
            }

            static downloadExcel(title, listgrid, fileName, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate,warning){

                if(listgrid.getOriginalData().size() > listgrid.getOriginalData().cachedRows || listgrid.getOriginalData().size() > 200){

                    let showDialog=null;

                    if(warning==1){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>نحوه مرتب سازي</b> و <b>فيلتر هاي اعمال شده</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }else if(warning ==2){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>فيلتر هاي اعمال شده</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }else if(warning ==3){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>نحوه مرتب سازي</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }

                    if(showDialog != null){
                        let me=this;
                        showDialog.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                me.showDialog(title, listgrid, fileName, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate);
                            }
                        });
                    }else{
                        this.showDialog(title, listgrid, fileName, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate);
                    }
                }else{
                    this.downloadExcelFromClient(listgrid, parentListGrid, titr, pageName);
                }
            }

            static downloadExcelRestUrl(title, listgrid, restUrl, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate,warning,generateCriteria = false, exceptColumn){


                if(listgrid.getOriginalData().size() > listgrid.getOriginalData().cachedRows || listgrid.getOriginalData().size() > 200){

                    let showDialog=null;

                    if(warning == 1){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>نحوه مرتب سازي</b> و <b>فيلتر هاي اعمال شده</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }else if(warning == 2){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>فيلتر هاي اعمال شده</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }else if(warning == 3){
                        showDialog = createDialog('info','کاربر گرامي توجه داشته باشيد <b>نحوه مرتب سازي</b> بر روي ليست گريد در خروجي اکسل اعمال نخواهند شد.');
                    }

                    if(criteria == null && generateCriteria){
                        criteria = this.generateCriteria(listgrid);
                    }

                    if(showDialog != null){
                        let me=this;
                        showDialog.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                me.showDialogRestUrl(title, listgrid, restUrl, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate, exceptColumn);
                            }
                        });
                    }else{
                        this.showDialogRestUrl(title, listgrid, restUrl, maxSizeRecords, parentListGrid, titr, pageName, criteria, isValidate, exceptColumn);
                    }
                }else{
                    this.downloadExcelFromClient(listgrid, parentListGrid, titr, pageName, exceptColumn);
                }
            }

            static makeExcelOutputWithFieldsAndData(dataSource, listGridDataArray, title, pageName, sliceStart, sliceEnd) {

                let excelData = [];
                let excelFields = [];

                let data = listGridDataArray;
                let fields = Object.values(dataSource.getFields());
                let fieldNames = fields.map(q => q.name).slice(sliceStart, fields.length - sliceEnd);
                let fieldTitles = fields.map(q => q.title).slice(sliceStart, fields.length - sliceEnd);

                let obj = {};
                for (let i = 0; i < fieldNames.length; i++) {
                    obj[fieldNames[i]] = fieldTitles[i];
                }
                excelData.push(obj);

                for (let d of data) {
                    let obj = {};
                    for (let i = 0; i < fieldNames.length; i++) {
                        obj[fieldNames[i]] = d[fieldNames[i]];
                    }
                    excelData.push(obj);
                }

                for (let i = 0; i < fieldNames.length; i++) {
                    let obj = {};
                    obj["name"] = fieldNames[i];
                    excelFields.push(obj);
                }
                ExportToFile.exportToExcelFromClient(excelFields, excelData, title, pageName, null);
            }
        }

        function generalGetResp(resp) {
            if (resp.httpResponseCode === 401) {
                var dialog = createDialog("confirm", "<spring:message code="unauthorized"/>");
                dialog.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
                            logout();
                        }
                    }
                });
                return false;
            }
            return true;
        }
    </script>
    <sec:authorize access="hasAuthority('NICICO_Ticketing')">
    <script src="<spring:url value='/js/nicico-ticket.js' />"></script>
    </sec:authorize>


    <script src="<spring:url value='/js/dateReformat.js' />"></script>
    <!-- ---------------------------------------- Not Ok - End ---------------------------------------- -->
</head>

<c:choose>
<c:when test="${pageContext.response.locale == 'fa'}">
<body class="rtl" dir="rtl">
</c:when>
<c:otherwise>
<body class="ltr" dir="ltr">
</c:otherwise>
</c:choose>
<script type="application/javascript">

    // -------------------------------------------  REST API URLs  -----------------------------------------------
    <spring:eval var="contextPath" expression="pageContext.servletContext.contextPath" />
    const userFullName = '<%= SecurityUtil.getFullName()%>';
    const userUserName = '<%= SecurityUtil.getUsername()%>';
    const rootUrl = "${contextPath}/api";
    const baseUrl = "${contextPath}";
    const trainingMainUrl = rootUrl + "/main";
    const oauthUserUrl = rootUrl + "/oauth/users";
    const oauthRoleUrl = rootUrl + "/oauth/app-roles";
    const oauthGroupUrl = rootUrl + "/oauth/groups";
    const oauthPermissionUrl = rootUrl + "/oauth/permissions";
    const workflowUrl = rootUrl + "/workflow";
    const bpmsWorkflowUrl = rootUrl + "/bpms";
    const jobUrl = rootUrl + "/job";
    const postGroupUrl = rootUrl + "/post-group";
    const postGradeUrl = rootUrl + "/postGrade";
    const postUrl = rootUrl + "/post";
    const trainingPostUrl = rootUrl + "/training-post";
    const viewAllPostUrl = rootUrl + "/ViewAllPost";
    const competenceUrl = rootUrl + "/competence";
    const needAssessmentUrl = rootUrl + "/needAssessment";
    const skillUrl = rootUrl + "/skill";
    const attachmentUrl = rootUrl + "/attachment";
    const trainingPlaceUrl = rootUrl + "/trainingPlace";
    const personnelUrl = rootUrl + "/personnel";
    const viewActivePersonnelUrl = rootUrl + "/view_active_personnel";
    const viewActivePersonnelInRegisteringUrl = rootUrl + "/view-active-personnel-in-registering";
    const personnelRegUrl = rootUrl + "/personnelRegistered";
    const attendanceUrl = rootUrl + "/attendance";
    const attendanceAuditUrl = rootUrl + "/attendance-audit";
    const downloadFiles = baseUrl + "/anonymous/els/download/";
    const parameterUrl = rootUrl + "/parameter";
    const parameterValueUrl = rootUrl + "/parameter-value";
    const employmentHistoryUrl = rootUrl + "/employmentHistory";
    const teachingHistoryUrl = rootUrl + "/teachingHistory";
    const teacherCertificationUrl = rootUrl + "/teacherCertification";
    const agreementFurtherInfoUrl=rootUrl + "/teacherExperienceInfo"
    const foreignLangKnowledgeUrl = rootUrl + "/foreignLangKnowledge";
    const publicationUrl = rootUrl + "/publication";
    const configQuestionnaireUrl = rootUrl + "/config-questionnaire";
    const evaluationIndexUrl = rootUrl + "/evaluationIndex";
    const academicBKUrl = rootUrl + "/academicBK";
    const questionnaireUrl = rootUrl + "/questionnaire";
    const questionnaireQuestionUrl = rootUrl + "/questionnaireQuestion";
    const tclassStudentUrl = rootUrl + "/class-student";
    const trainingFileUrl = rootUrl + "/view-training_file";
    const teacherInformation = rootUrl + "/teacherInformation";
    const needsAssessmentUrl = rootUrl + "/needsAssessment";
    const workGroupUrl = rootUrl + "/work-group";
    const operationalRoleUrl = rootUrl + "/operational-role";
    const evaluationUrl = rootUrl + "/evaluation";
    const hasAccessToChangeClassStatus = rootUrl + "/tclass/hasAccessToChangeClassStatus/";
    const isValidForExam = rootUrl + "/tclass/isValidForExam/";
    const getClassScoring = rootUrl + "/tclass/get-class-scoring/";
    const hasAccessToGroups= rootUrl + "/tclass/hasAccessToGroups/";
    const changeClassStatusToLock = rootUrl + "/tclass/changeClassStatusToLock";
    const uploadFms = rootUrl + "/attachment/upload/fms";
    const getFmsConfig = rootUrl + "/fms/config";
    const changeClassStatusToUnLock = rootUrl + "/tclass/changeClassStatusToUnLock/";
    const needsAssessmentReportsUrl = rootUrl + "/needsAssessment-reports";
    const skillNAUrl = rootUrl + "/skill-na";
    const trainingOverTimeReportUrl = rootUrl + "/trainingOverTime";
    const needsAssessmentsPerformedUrl = rootUrl + "/needAssessmentInRange";
    const assigneeNeedsAssessmentsReport = rootUrl + "/assigneeNeedsAssessmentsReport";
    const unAssigneeNeedsAssessmentsReport = rootUrl + "/unAssigneeNeedsAssessmentsReport";
    const personnelInformationUrl = rootUrl + "/personnelInformation";
    const unfinishedClasses = rootUrl + "/unfinishedClasses";
    const studentPortalUrl = rootUrl + "/student-portal";
    const studentClassReportUrl = rootUrl + "/student-class-report-view";
    const personnelCourseNAReportUrl = rootUrl + "/personnel-course-na-report";
    const trainingFileNAReportUrl = rootUrl + "/training-file-na-report";
    const personnelDurationNAReportUrl = rootUrl + "/personnel-duration-na-report";
    const personnelCourseNotPassedReportUrl = rootUrl + "/personnel-course-not-passed-report";
    const classContractUrl = rootUrl + "/class-contract";
    const evaluationAnalysisUrl = rootUrl + "/evaluationAnalysis";
    const classOutsideCurrentTerm = rootUrl + "/class-outside-current-term";
    const viewPostGroupUrl = rootUrl + "/view-post-group";
    const viewPostUrl = rootUrl + "/view-post";
    const viewJobUrl = rootUrl + "/view-job";
    const viewJobGroupUrl = rootUrl + "/view-job-group";
    const viewPostGradeUrl = rootUrl + "/view-post-grade";
    const viewPostGradeGroupUrl = rootUrl + "/view-post-grade-group";
    const viewTrainingPostUrl = rootUrl + "/view-training-post";
    const viewCoursesEvaluationReportUrl = rootUrl + "/view_courses_evaluation_report";
    const viewCoursesEvaluationStatisticalReportUrl = rootUrl + "/view_courses_evaluation_statistical_report";
    const viewReactionEvaluationFormulaReportUrl = rootUrl + "/view_reaction_evaluation_formula_report";
    const viewReactionEvaluationCommentUrl = rootUrl + "/evaluation/comments";
    const viewClassCostReportUrl = rootUrl + "/view-class-cost";
    const masterDataUrl = rootUrl + "/masterData";
    const viewEvaluationStaticalReportUrl = rootUrl + "/view-evaluation-statical-report";
    const viewTeacherReportUrl = rootUrl + "/view-teacher-report/";
    const sendMessageUrl = rootUrl + "/sendMessage";
    const attendanceReportUrl = rootUrl + "/attendanceReport";
    const classPerformanceReport = rootUrl + "/classPerformance/";
    const attendancePerformanceReportUrl = rootUrl + "/attendancePerformance/";
    const controlReportUrl = rootUrl + "/controlReport";
    const presenceReportUrl = rootUrl + "/presence-report";
    const continuousStatusReportViewUrl = rootUrl + "/continuous-status-report-view";
    const departmentUrl = rootUrl + "/department";
    const operationalChartUrl = rootUrl + "/operationalchart";
    const educationalCalenderReportUrl = rootUrl + "/view-educational-calender-report"
    const timeInterferenceComprehensiveClassesReportUrl = rootUrl + "/timeInterference-Comprehensive-Classes-report"
    const viewClassDetailUrl = rootUrl + "/view-class-detail";
    const statisticsUnitReportUrl = rootUrl + "/ViewStatisticsUnitReport";
    const manHourStatisticsByClassFeaturesReportUrl = rootUrl + "/manHourStatisticsByClassFeatureReport";
    const manHourStatisticsByClassCategoryReportUrl = rootUrl + "/manHourStatisticsByClassCategoryReport";
    const manHourStatisticsPerDepartmentReportUrl = rootUrl + "/manHourStatisticsPerDepartmentReport";
    const questionBankUrl = rootUrl + "/question-bank";
    const viewPersonnelTrainingStatusReportUrl = rootUrl + "/view-personnel-training-status-report";
    const viewCoursesPassedPersonnelReportUrl = rootUrl + "/view-courses-passed-personnel-report";
    const questionBankTestQuestionUrl = rootUrl + "/question-bank-test-question";
    const annualStatisticsReportUrl = rootUrl + "/annualStatisticsReport";
    const testQuestionUrl = rootUrl + "/test-question";
    const viewStudentsInCanceledClassReportUrl = rootUrl + "/view-students-in-canceled-class-report";
    const loginLogUrl = rootUrl + "/log";
    const helpFilesUrl = rootUrl + "/help-files";
    const fileLabelUrl = rootUrl + "/file-label";
    const agreementUrl = rootUrl + "/agreement";
    const agreementClassCostUrl = rootUrl + "/agreement-class-cost";
    const examMonitoringUrl = rootUrl + "/exam-monitoring";
    const competenceRequestUrl = rootUrl + "/competence-request";
    const educationalDecisionHeaderRequestUrl = rootUrl + "/header";
    const committeeRequestUrl = rootUrl + "/CommitteeOfExperts";
    const educationalDecisionRequestUrl = rootUrl + "/decision";
    const requestItemUrl = rootUrl + "/request-item";
    const requestItemAuditUrl = rootUrl + "/request-item-audit";
    const requestUrl = rootUrl + "/request";
    const mobileVerifyUrl = rootUrl + "/anonymous-mobile";
    const selfDeclarationUrl = rootUrl + "/self-declaration";
    const needAssessmentForGroup = rootUrl + "/personnel/import/post-personnel";
    const synonymPersonnel = rootUrl + "/personnel/Synonym";
    const minIoUrl = rootUrl + "/minIo";
    const bpmsUrl = rootUrl + "/bpms" ;
    const requestItemBPMSUrl = rootUrl + "/certification-bpms" ;
    const systemStatusUrl = rootUrl + "/system-status";
    const addIndividualPost = rootUrl + "/view-training-post/add";
    const addNeedAssmentForGaps = rootUrl + "/needsAssessmentWithGap/addSkills";
    const getSkills = rootUrl + "/needsAssessmentWithGap/iscList/";
    const CompetencesIscList = rootUrl + "/needsAssessmentWithGap/competence/iscList";
    const allCompetencesIscList = rootUrl + "/needsAssessmentWithGap/ISC/competence/iscList";
    const sendToWorkFlow = rootUrl + "/needsAssessmentWithGap/sendToWorkFlow/";
    const deleteTempDataFromWorkFlow = rootUrl + "/needsAssessmentWithGap/deleteUnCompleteData/";
    const canChangeData = rootUrl + "/needsAssessmentWithGap/canChangeData/";
    const deleteIndividualPost = rootUrl + "/view-training-post/delete";
    const genericStatisticalIndexReportUrl = rootUrl + "/generic_statistical_index_report";
    const effectiveCoursesReportUrl = rootUrl + "/effective-courses-report";

    // -------------------------------------------  Filters  -----------------------------------------------
    const enFaNumSpcFilter = "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F]|[a-zA-Z0-9 ]";
    const enNumSpcFilter = "[a-zA-Z0-9 ]";
    const numFilter = "[0-9]";

    // -------------------------------------------  Constant Variables  -----------------------------------------------
    const dialogShowTime = 2000;
    const wait = createDialog("wait");

    // -------------------------------------------  Isomorphic Configs & Components   -----------------------------------------------
    isc.setAutoDraw(false);
    isc.RPCManager.allowCrossDomainCalls = true;
    // isc.FileLoader.loadLocale("fa");
    // isc.FileLoader.cacheLocale("fa");
    isc.TextItem.addProperties({height: 27, length: 255, width: "*"});
    isc.SelectItem.addProperties({
        height: 27,
        width: "*",
        addUnknownValues: false,
        wrapHintText: false,
        canSelectText: true,
        cachePickListResults: false,
        pickListProperties: {
            showFilterEditor: true,
            alternateRecordStyles: true,
            autoFitWidthApproach: "both",
        },
    });
    isc.SpinnerItem.addProperties({height: 27, length: 255, width: "*"});
    isc.Button.addProperties({height: 27});
    isc.TextAreaItem.addProperties({height: 27, length: 500, width: "*"});
    isc.Label.addProperties({wrap: false});
    isc.ToolStrip.addProperties({membersMargin: 5, border: "0px solid",});
    isc.ToolStripMenuButton.addProperties({showMenuOnRollOver: true});
    isc.TabSet.addProperties({width: "100%", height: "100%",});
    isc.ViewLoader.addProperties({width: "100%", height: "100%", border: "0px",});
    isc.Dialog.addProperties({isModal: true, askIcon: "info.png", autoDraw: true, iconSize: 24});
    isc.DynamicForm.addProperties({
        width: "100%",
        errorOrientation: "right",
        showErrorStyle: false,
        wrapItemTitles: false,
        titleAlign: "right",
        titleSuffix: "",
        requiredTitlePrefix: "<span style='color:#ff0842;font-size:22px; padding-left: 2px;'>*</span>",
        requiredTitleSuffix: "",
        readOnlyDisplay: "static",
        padding: 10,
        canTabToIcons: false,
    });
    isc.Window.addProperties({
        autoSize: true, autoCenter: true, isModal: true, showModalMask: true, canFocus: true, dismissOnEscape: true,
        canDragResize: true, showHeaderIcon: false, animateMinimize: true, showMaximizeButton: true,
    });
    isc.ComboBoxItem.addProperties({
        pickListProperties: {showFilterEditor: true},
        addUnknownValues: false,
        useClientFiltering: false,
        changeOnKeypress: false,
    });
    isc.defineClass("TrHLayout", HLayout);
    isc.TrHLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});
    isc.defineClass("TrVLayout", VLayout);
    isc.TrVLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});
    TrDSRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
       // wait.show();
        return {
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            contentType: "application/json; charset=utf-8",
            useSimpleHttp: true,
            showPrompt: false,
            willHandleError: true,
            actionURL: actionURLParam,
            httpMethod: httpMethodParam,
            data: dataParam,
            callback: callbackParam,
        }
    };
    isc.defineClass("TrDS", RestDataSource);
    isc.TrDS.addProperties({
        dataFormat: "json",
        jsonSuffix: "",
        jsonPrefix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {"Authorization": "Bearer <%= accessToken %>"};
            return this.Super("transformRequest", arguments);
        },
        transformResponse: function (dsResponse, dsRequest, data) {
            return this.Super("transformResponse", arguments);
        }
    });

    // -------------------------------------------  SET DEFAULT SESSIONS  -----------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(trainingMainUrl + "/getMainData", "GET", null, null));
    // -------------------------------------------  SET DEFAULT SESSIONS  -----------------------------------------------

    isc.defineClass("LgLabel", Label);
    isc.LgLabel.addProperties({height: "27", align: "center", showEdges: true, edgeSize: 2, customEdges: []});

    isc.DetailViewer.addProperties({wrapValues: false});

    isc.defineClass("TrLG", ListGrid);
    isc.TrLG.addProperties({
        autoFitWidthApproach: "both",
        selectCellTextOnClick: true,
        alternateRecordStyles: true,
        showClippedValuesOnHover: true,
        leaveScrollbarGap: false,
        showRowNumbers: true,
        rowNumberFieldProperties: {
            headerTitle: "<spring:message code="row.number"/>",
            width: 50,
            align: "center"
        },

        showFilterEditor: true,
        filterOnKeypress: false,

        preventDuplicates: true,
        duplicateDragMessage: "<spring:message code="msg.can't.transfer.duplicated.data"/>",

        sortField: 0,
        canAutoFitFields: false,
    });

    TrValidators = {
        NotEmpty: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.is.required"/>",
            expression: /^(?!\s*$).+/
        },
        NotStartWithNumber: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.start.number"/>",
            expression: /^(?!([0-9]))/,
        },
        NotStartWithSpecialChar: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.start.special.char"/>",
            expression: /^(?!([!@#$%^&*~';:.{}_]))/,
        },
        NotContainSpecialChar: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.contains.special.chars"/>",
            expression: /^((?![~!@#$%^&*()+='"?]).)*$/,
        },
        NotAllowedInFileNameChar: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.contains.special.chars"/>",
            expression: /^((?![\/\\?%*:|"<>.]).)*$/,
        },
        EmailValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.email.address"/>",
            expression: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
        },
        WebsiteValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.web.address"/>",
            expression: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
        },
        MobileValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.mobile.number"/>",
            expression: /^((\+98)|(0))[9\d{9}]{10}$/,
        },
        PhoneValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.phone.number"/>",
            expression: /^(0\d{2})[\d{8}]{8}$/,
            // |()|(\+\d{4}):can be add in order to not use any section's code or use +---- format for that.
        },
        PostalCodeValidate: {
            type: "custom",
            errorMessage: "<spring:message code='msg.postal.code.validation'/>",
            condition: function (item, validator, value) {
                if (value == null)
                    return true;
                return value >= 1e9 && value < 1e10;
            }
        },
        NationalCodeValidate: {
            type: "custom",
            errorMessage: "<spring:message code='msg.national.code.validation'/>",
            condition: function (item, validator, value) {
                let code = value;
                if (code === undefined || code === null || code === "")
                    return true;
                let L = code.length;
                if (L < 8 || parseFloat(code, 10) === 0)
                    return false;
                code = ('0000' + code).substr(L + 4 - 10);
                if (parseFloat(code.substr(3, 6), 10) === 0)
                    return false;
                let c = parseFloat(code.substr(9, 1), 10);
                let s = 0;
                for (let i = 0; i < 9; i++) {
                    s += parseFloat(code.substr(i, 1), 10) * (10 - i);
                }
                s = s % 11;
                return (s < 2 && c === s) || (s >= 2 && c === (11 - s));
            }
        },
        Trimmer: {
            type: "custom",
            condition: function (item, validator, value) {
                if (value != null) {
                    trimmed = trTrim(value);
                    validator.resultingValue = trimmed;
                }
                return true;
            }
        }
    };

    function trTrim(value) {
        trimmed = (value.toString() || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
        return trimmed.replace(/\s\s+/g, ' ');
    }

    isc.TextItem.addProperties({validators: [TrValidators.Trimmer]});
    isc.TextAreaItem.addProperties({validators: [TrValidators.Trimmer]});

    isc.defineClass("TrHLayoutButtons", TrHLayout);
    isc.TrHLayoutButtons.addProperties({align: "center", height: 40, defaultLayoutAlign: "center", membersMargin: 10,});

    isc.defineClass("TrComboAutoRefresh", ComboBoxItem);
    isc.TrComboAutoRefresh.addProperties({
        click: function (form, item) {
            item.fetchData();
        }
    });

    isc.ToolStripButtonRefresh.addProperties({title: "<spring:message code="refresh"/>",});
    isc.ToolStripButtonCreate.addProperties({title: "<spring:message code="create"/>",});
    isc.ToolStripButtonAdd.addProperties({title: "<spring:message code="add"/>",});
    isc.ToolStripButtonEdit.addProperties({title: "<spring:message code="edit"/>",});
    isc.ToolStripButtonRemove.addProperties({title: "<spring:message code="remove"/>",});
    isc.ToolStripButtonPrint.addProperties({title: "<spring:message code="print"/>",});
    isc.IButtonSave.addProperties({title: "<spring:message code="save"/>",});
    isc.IButtonCancel.addProperties({title: "<spring:message code="cancel"/>",});



    // -------------------------------------------  Page UI - Header  -----------------------------------------------
    var headerLogo = isc.HTMLFlow.create({
        width: 350,
        height: "100%",
        styleName: "header-logo",
        contents: "<div class='header-title-right'><div class='header-title-top'><h3><spring:message code='training.system.company'/></h3><h4><spring:message code='training.system'/></h4></div><div class='header-title-version'><h4><spring:message code='training.system.version'/></h4></div><img width='50' height='50' src='static/img/logo-23.svg'/></div>"
    });
    var ticket = isc.HTMLFlow.create({
        width: 350,
        height: "100%",
        styleName: "header-logo",
        contents: "<nicico-ticket></nicico-ticket>"
    });

    <%--var headerFlow = isc.HTMLFlow.create({--%>
    <%--width: "10%",--%>
    <%--height: "100%",--%>
    <%--styleName: "mainHeaderStyleOnline header-logo-title",--%>
    <%--contents: "<span><spring:message code="training.system.version"/></span>"--%>
    <%--});--%>

    var versionLbl = isc.Label.create({
        width: "100%",
        // height: 25,
        topPadding: 7,
        top: 450,
        align: "left",
        contents: "اطلاعات نسخه",
        dynamicContents: false,
        icon: 'info.png',
        iconClick: "isc.VersionsWindow.create();",
        iconOrientation: 'right'

    });
    <%--var trVersion = "${trainingVersion}";--%>
    <%--var versionHLayout = isc.HLayout.create({--%>
    <%--    width: "10%",--%>
    <%--    align: "center",--%>
    <%--    members: [versionLbl]--%>
    <%--});--%>

    var label_Username = isc.Label.create({
        width: 200,
        dynamicContents: true,
        styleName: "header-label-username",
        contents: "<spring:message code="user"/>" + ": " + `<%= SecurityUtil.getFullName()%>`,
    });

    var userNameHLayout = isc.HLayout.create({
        width: "10%",
        align: "center",
        members: [label_Username]
    });

    languageForm = isc.DynamicForm.create({
        width: 120,
        height: 30,
        styleName: "header-change-lng",
        fields: [{
            name: "languageName",
            showTitle: false,
            width: "100%",
            type: "select",
            valueMap: {
                "fa": "پارسی",
                "en": "English",
            },
            imageURLSuffix: ".png",
            valueIconRightPadding: "10",
            valueIcons: {
                "fa": "<spring:url value="flags/iran"/>",
                "en": "<spring:url value="flags/united-kingdom"/>",
            },
            changed: function () {
                newUrl = window.location.href;
                newLang = languageForm.getValue("languageName");
                if (newUrl.indexOf("lang") > 0) {
                    newUrl = newUrl.replace(new RegExp("lang=[a-zA-Z_]+"), "lang=" + newLang);
                } else {
                    if (newUrl.indexOf("?") > 0) {
                        if (newUrl.indexOf("#") > 0) {
                            newUrl = newUrl.replace("#", "&lang=" + newLang + "#")
                        } else {
                            newUrl += "&lang=" + newLang;
                        }
                    } else {
                        newUrl = newUrl + "?lang=" + newLang;
                    }
                }
                window.location.href = newUrl;
            }
        }]
    });

    languageForm.setValue("languageName", "<c:out value='${pageContext.response.locale}'/>");

    var languageVLayout = isc.VLayout.create({
        width: "5%",
        align: "center",
        defaultLayoutAlign: "left",
        members: [languageForm]
    });

    var toggleSwitch = isc.HTMLFlow.create({
        width: 32,
        height: "100%",
        align: "center",
        styleName: "toggle-switch",
        contents: "<label class=\"switch-btn\">\n" +
            "  <input type=\"checkbox\" onchange='onToggleClick(event)'>\n" +
            "  <span class=\"slider round\"></span>\n" +
            "</label>"
    });

    var languageAndToggleHLayout = isc.HLayout.create({
        width: "5%",
        align: "center",
        defaultLayoutAlign: "left",
        members: [toggleSwitch, languageVLayout]
    });


    logoutButton = isc.IButton.create({
        width: "100",
        baseStyle: "header-logout",
        title: "<span><spring:message code="logout"/></span>",
        icon: "<spring:url value="/images/logout.png"/>",
        click: function () {
            logout();
        }
    });

    var logoutVLayout = isc.VLayout.create({
        width: "5%",
        align: "center",
        styleName: "header-logout-Vlayout",
        defaultLayoutAlign: "left",
        members: [logoutButton]
    });

    // -------------------------------------------  Page UI - Menu  -----------------------------------------------
    <sec:authorize access="hasAuthority('Menu_BasicInfo')">
    basicInfoTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="basic.information"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_BasicInfo_Parameter')">
                {
                    title: "<spring:message code="parameter"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/parameter/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_BasicInfo_Group')">
                {
                    title: "<spring:message code="category&subcategory"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/category/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('Menu_BasicInfo_Parameter','Menu_BasicInfo_Group')">
                {isSeparator: true},
                </sec:authorize>

<%--                <sec:authorize access="hasAuthority('Menu_BasicInfo_Skill')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="skill.level"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="/skill-level/show-form"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                {isSeparator: true},--%>
<%--                </sec:authorize>--%>

                <sec:authorize access="hasAuthority('Menu_BasicInfo_EducationDegree')">
                {
                    title: "<spring:message code="education.degree"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/education/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_BasicInfo_EquipmentPlural')">
                {
                    title: "<spring:message code="equipment.plural"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/equipment/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_BasicInfo_Personnel')">
                {
                    title: "<spring:message code="personnel.information"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="personnelInformation/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Organizational_chart')">
                {
                    title: "<spring:message code="organizational.chart"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/organizationalChart"/>");
                    }
                },
                </sec:authorize>

                {
                    title: "<spring:message code="department.chart"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/departmentChart"/>");
                    }
                },

                {
                    title: "<spring:message code="operational.chart"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/operationalChart"/>");
                    }
                },

                <sec:authorize access="hasAuthority('Menu_BasicInfo_HelpFiles')">
                {
                    title: "<spring:message code='users.training'/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/helpFiles/"/>");
                    }
                },
                </sec:authorize>

                {
                    title: "وضعیت سایر سیستم ها",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/systemStatus/"/>");
                    }
                }

            ]
        }),
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Menu_NeedAssessment')">
    needsAssessmentTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="need.assessment"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_NeedAssessment_CompetenceRequest')">
                {
                    title: "<spring:message code="scientific.technical.certification"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/certification"/>");
                    }
                },
                </sec:authorize>
                {
                    title: "<spring:message code="scientific.technical.certification.report"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/certification-level-report"/>");
                    }
                },
                {isSeparator: true},
                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Competence')">
                {
                    title: "<spring:message code="competence"/>",
                    click: function () {
                        <%--createTab(this.title, "<spring:url value="web/competence/"/>");--%>
                        createTab(this.title, "<spring:url value="web/competenceV2/"/>");
                    }
                },
                </sec:authorize>

<%--                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Competence')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="competenceV2"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="web/competenceV2/"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                </sec:authorize>--%>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Skill')">
                {
                    title: "<spring:message code="skill"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill/show-form"/>");
                    }
                },
                </sec:authorize>

<%--                <sec:authorize access="hasAuthority('Menu_NeedAssessment_NeedAssessment')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="needs.assessment"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="web/needsAssessment/"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                </sec:authorize>--%>

                <sec:authorize access="hasAnyAuthority('Menu_NeedAssessment_Competence','Menu_NeedAssessment_Skill','Menu_NeedAssessment_NeedAssessment')">
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Job')">
                {
                    title: "<spring:message code="job"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/job/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_GroupJob')">
                {
                    title: "<spring:message code="job.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="job-group/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('Menu_NeedAssessment_Job','Menu_NeedAssessment_GroupJob')">
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_PostGrade')">
                {
                    title: "<spring:message code="post.grade"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGrade/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_PostGradeGroup')">
                {
                    title: "<spring:message code="post.grade.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGradeGroup/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('Menu_NeedAssessment_PostGrade','Menu_NeedAssessment_PostGradeGroup')">
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Post')">
                {
                    title: "<spring:message code="post.individual"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_PostGroup')">
                {
                    title: "<spring:message code="post.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post-group/"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_NeedAssessment_Training_Post')">
                {
                    title: "<spring:message code="post"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/training-post"/>");
                    }
                },
                </sec:authorize>

                 <sec:authorize access="hasAuthority('Menu_NeedAssessment_Committee_Of_Experts')">
                {
                    title: "کمیته خبرگان",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/Committee-Of-Experts"/>");
                    }
                },
                </sec:authorize>

                <%--,--%>
                <%--{--%>
                <%--    title: "<spring:message code="skill.group"/>",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="/skill-group/show-form"/>");--%>
                <%--    }--%>
                <%--},--%>
                <%--{isSeparator: true},--%>
                <%--{--%>
                <%--    title: "<spring:message code="need.assessment.skill.based"/>",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="web/needAssessmentSkillBased/"/>");--%>
                <%--    }--%>
                <%--},--%>
            ]
        }),
    });
    </sec:authorize>


    <sec:authorize access="hasAuthority('Menu_Designing')">
    designingTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="designing.and.planning"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_Designing_Course')">
                {
                    title: "<spring:message code="course"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/course/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Designing_Term')">
                {
                    title: "<spring:message code="term"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/term/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

<%--                <sec:authorize access="hasAuthority('Menu_Designing_committee')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="specialized.committee"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="/committee/show-form"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                {isSeparator: true},--%>
<%--                </sec:authorize>--%>

                <sec:authorize access="hasAuthority('Menu_Designing_Company')">
                {
                    title: "<spring:message code="company"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/company/show-form"/>");
                    }
                },
                // {isSeparator: true},
                </sec:authorize>
                {isSeparator: true},
                {
                    title: "<spring:message code="educational.calender"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/educationalCalender/show-form"/>");
                    }
                },
            ]
        })
    });
    </sec:authorize>


    <sec:authorize access="hasAuthority('Menu_Run')">
    runTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="run"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_Run_Class')">
                {
                    title: "<spring:message code="class"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/tclass/show-form"/>");
                    },
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Run_Student')">
                {
                    title: "<spring:message code="other-student"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/personnelRegistered/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Run_Teacher')">
                {
                    title: "<spring:message code="teacher"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/teacher/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Run_Institute')">
                {
                    title: "<spring:message code="institute"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/institute/show-form"/>");
                    }
                },
                </sec:authorize>

                {
                    title: "<spring:message code="self.declaration"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/selfDeclaration/"/>");
                    }
                }

                <%--{isSeparator: true},--%>
                <%--{--%>
                <%--    title: "قرارداد آموزشی",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="web/class-contract"/>");--%>
                <%--    }--%>
                <%--},--%>
            ]
        }),
    });
    </sec:authorize>


    <sec:authorize access="hasAuthority('Menu_Evaluation')">
    evaluationTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="evaluation"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_Evaluation_EvaluationIndex')">
                {
                    title: "<spring:message code="evaluation.index.title"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluationIndex/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_Questionnaire')">
                {
                    title: "<spring:message code="questionnaire"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/config-questionnaire"/>");
                    },
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_Evaluation')">
                {
                    title: "<spring:message code="evaluation"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluation/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_EvaluationAnalysis')">
                {
                    title: "<spring:message code="evaluation.analysis"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluationAnalysis/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_EvaluationCoefficient')">
                {
                    title: "<spring:message code="evaluation.Coefficient"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluationCoefficient/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_QuestionBank')">
                {
                    title: "<spring:message code="evaluation.question.bank"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluation-question-bank/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_FinalTest')">
                {
                    title: "<spring:message code="exam"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/evaluation-final-test/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_Requests')">
                {
                    title: "<spring:message code="requests"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/request"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Evaluation_MobileVerify')">
                {
                    title: "<spring:message code="mobile.verify"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/mobileVerify/"/>");
                    }
                }
                </sec:authorize>

                <%--{--%>
                <%--title: "ثبت نتایج",--%>
                <%--click: function () {--%>
                <%--createTab(this.title, "<spring:url value="/questionEvaluation/show-form"/>");--%>
                <%--}--%>
                <%--},--%>

<%--                <sec:authorize access="hasAuthority('Menu_Evaluation_RegisterScorePreTest')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="register.Score.PreTest"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="/registerScorePreTest/show-form"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                </sec:authorize>--%>

            ]
        }),
    });
    </sec:authorize>


    <sec:authorize access="hasAuthority('Menu_Cartable')">
    cartableTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="cartable"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
<%--                <sec:authorize access="hasAuthority('Menu_Cartable_Personal')">--%>
<%--                {--%>
<%--                    title: "<spring:message code="bpms.personal"/>",--%>
<%--                    click: function () {--%>
<%--                        createTab(this.title, "<spring:url value="/web/workflow/userBPMSPortfolio/showForm"/>");--%>
<%--                    }--%>
<%--                },--%>
<%--                {isSeparator: true},--%>
<%--                </sec:authorize>--%>

                <sec:authorize access="hasAuthority('Menu_Cartable_Personal')">
                {
                    title: "<spring:message code="personal"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/userBPMSPortfolio/showForm"/>");
                        <%--createTab(this.title, "<spring:url value="/web/workflow/userCartable/showForm"/>");--%>
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Cartable_Group')">
                {
                    title: "<spring:message code="group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/groupCartable/showForm"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Cartable_Workflow')">
                {
                    title: "<spring:message code="workflow"/>",
                    submenu: [
                        <sec:authorize access="hasAuthority('Menu_Cartable_Workflow_ProcessDefinition')">
                        {
                            title: "<spring:message code="process.definition"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/processDefinition/showForm"/>");
                            }
                        },
                        {isSeparator: true},
                        </sec:authorize>

                        <sec:authorize access="hasAuthority('Menu_Cartable_Workflow_Processes')">
                        {
                            title: "<spring:message code="all.processes"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/bPMSProcesses/showForm"/>")
                                <%--createTab(this.title, "<spring:url value="/web/workflow/processInstance/showForm"/>")--%>
                            }
                        },
                        </sec:authorize>
                        <%--{isSeparator: true},--%>
                        <%--{--%>
                        <%--    title: "<spring:message code="bpms.all.processes"/>",--%>
                        <%--    click: function () {--%>
                        <%--        createTab(this.title, "<spring:url value="/web/workflow/bPMSProcesses/showForm"/>")--%>
                        <%--    }--%>
                        <%--}--%>
                    ]
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Cartable_StudentPortal')">
                {
                    title: "<spring:message code='personnel.portal'/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/personnel-portal"/>");
                    }
                },
                </sec:authorize>

                {
                    title: "<spring:message code='teacher.portal'/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/teacher-portal"/>");
                    }
                },
            ]
        }),
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Menu_Finance')">
    financeTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="finance"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <sec:authorize access="hasAuthority('Menu_Finance_Agreement')">
                {
                    title: "<spring:message code="agreement"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/agreement"/>");
                    }
                },
                {
                    title: "<spring:message code="educational.decision"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/educational/decision"/>");
                    }
                },
                </sec:authorize>
            ]
        })
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Menu_Report')">
    reportTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="report"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <%--{--%>
                <%--    title: "گزارش حضور و غیاب",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="web/presenceReport"/>");--%>
                <%--    }--%>
                <%--},--%>
                <sec:authorize access="hasAuthority('Menu_Report_Basic')">
                {
                    title: "<spring:message code="reports.basic"/>",
                    submenu:
                        [
                            <sec:authorize access="hasAuthority('Menu_Report_Basic_Teachers')">
                            {
                                title: "<spring:message code="teachers.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="teacherReport/show-form"/>");
                                }
                            },
                            </sec:authorize>
                        ]
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Report_ReportsRun')">
                {
                    title: "<spring:message code="reports.run"/>",
                    submenu:
                        [
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingFile')">
                            {
                                title: "<spring:message code="training.file"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/trainingFile/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_PassedPersonnel')">
                            {
                                title: "<spring:message code="personnel.courses"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/studentClassReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_PersonnelCoursesNotPassed')">
                            {
                                title: "<spring:message code="personnel.courses.not.passed"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/personnelCourseNotPassed/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_CalenderCurrentTerm')">
                            <%--{--%>
                            <%--title: "<spring:message code="report.calender.current.term"/>",--%>
                            <%--click: function () {--%>
                            <%--createTab(this.title, "<spring:url value="web/calenderCurrentTerm"/>");--%>
                            <%--}--%>
                            <%--},--%>
                            <%--{isSeparator: true},--%>
                            {
                                title: "<spring:message code="report.class.outside.current.term"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/classOutsideCurrentTerm"/>");
                                }
                            },
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_CourseWithOutTeacher')">
                            {isSeparator: true},
                            {
                                title: "<spring:message code="report.course.withOut.class"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/courseWithOutTeacherReaport"/>");
                                }
                            },
                            </sec:authorize>


                            <sec:authorize access="hasAnyAuthority('Menu_Report_ReportsRun_CalenderCurrentTerm','Menu_Report_ReportsRun_CourseWithOutTeacher')">
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingOverTime')">
                            {
                                title: "<spring:message code="report.training.overtime"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/trainingOverTime/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_WeeklyTrainingSchedule')">
                            {
                                title: "<spring:message code="weekly.training.schedule"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="weeklyTrainingSchedule/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_WeeklyClass')">
                            {
                                title: "<spring:message code="training.class.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="trainingClassReport/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "<spring:message code="noncompliance.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="nonComplianceReport/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_UnfinishedClasses')">
                            {
                                title: "<spring:message code="unfinished.classes"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="unfinishedClasses-report/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingOverTime')">
                            {
                                title: "<spring:message code="report.Absence"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/attendanceReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingOverTime')">
                            {
                            title: "کنترل",
                            click: function () {
                            createTab(this.title, "<spring:url value="web/controlReport/"/>");
                            }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingOverTime')">
                            {
                                title: "گزارش حضور و غياب کلاس های آمورشي",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/presenceReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            {isSeparator: true},
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingOverTime')">
                            {
                                title: "گزارش دوره های گذرانده فرد",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/coursesPassedPersonnelReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            {
                                title: "گزارش کلاس های حذف شده",
                                click: function () {
                                    createTab(this.title, "<spring:url value="/students-in-canceled-class-report/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "گزارش دوره های گذرانده / نگذرانده شده بر اساس نیازسنجی",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/CoursePassedOrUnPassedInNAReport"/>");
                                }
                            },
                            {isSeparator: true},

                            {
                                title: "گزارش تقویم آموزشی",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/educationalCalenderReport"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "گزارش تداخل زمانی کلاسهای فراگیر",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/timeInterferenceComprehensiveClassesReport"/>");
                                }
                            },
                            {isSeparator: true},
                        ]
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment')">
                {
                    title: "<spring:message code="reports.needs.assessment"/>",
                    submenu:
                        [
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_ReportsNeedsAssessment')">
                            {
                                title: "<spring:message code="reports.need.assessment"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/needsAssessment-reports"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsGroupJobPromotionNeedsAssessment_ReportsNeedsAssessment')">
                            {
                                title: "<spring:message code="reports.need.assessment.group.job.promotion"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/need.assessment-group-job-promotion-report"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Designing_NeedsAssessmentReportCourse')">
                            {
                                title: "<spring:message code='needsAssessment.report.course'/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/course-needs-assessment-reports"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>


                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: "آمار دوره های نیازسنجی افراد",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/personnel-course-NA-report"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: "گزارش مقایسه نیازسنجی با پرونده آموزشی",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/training-file-na-report"/>");
                                }
                            },
                             {isSeparator: true},
                            </sec:authorize>
                             <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: "گزارش نیازسنجی مشاغل بر اساس دوره",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/training-course-need-assessment"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: "گزارش پست های نیازسنجی نشده",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/training-area-need-assessment"/>");
                                }
                            },
                            </sec:authorize>
                            {isSeparator: true},
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: "گزارش نیازسنجی های انجام شده",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/needsAssessmentsPerformed"/>");
                                }
                            },
                            </sec:authorize>
                            {isSeparator: true},
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: " نیازسنجی های تایید نشده توسط سرپرست",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/assigneeNeedsAssessmentsReport"/>");
                                }
                            },
                            </sec:authorize>
                            {isSeparator: true},
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_People')">
                            {
                                title: " نیازسنجی های بلاتکلیف",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/unAssigneeNeedsAssessments"/>");
                                }
                            },
                            </sec:authorize>
                        ]
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Report_ReportsFECR')">
                {
                    title: "<spring:message code="reports.evaluation.efficacy"/>",
                    submenu:
                        [
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsFECR_PretestScoreGreatThanAcceptLimited')">
                            {
                                title: "<spring:message code="pretest.score.great.than.accept.limited"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="/preTestScoreReport/show-form"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>

<%--                            <sec:authorize access="hasAuthority('Menu_Report_ReportsFECR_StaticalEvaluation')">--%>
                            {
                                title:  "<spring:message code="evaluation.statical.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/evaluationStaticalReport"/>");
                                }
                            },

                            {
                                title:  "<spring:message code="courses.evaluation.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/coursesEvaluationReport"/>");
                                }
                            },

                            {
                                title:  "<spring:message code="reaction.evaluation.formula.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/reactionEvaluationFormulaReport"/>");
                                }
                            },
                            {
                                title:  "<spring:message code="learning.evaluation.formula.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/learningEvaluationFormulaReport"/>");
                                }
                            },
                            {
                                title:  "<spring:message code="reaction.evaluation.comment.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/reactionEvaluationCommentsReport"/>");
                                }
                            },

                            {
                                title:  "<spring:message code="class.reaction.evaluation.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/reactionEvaluationReport"/>");
                                }
                            },
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsFECR_AnsweredEvalQuestionsDetailsReport')">
                            {
                                title: "<spring:message code="evaluation.answered.questions.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/evaluationAnsweredQuestionsReport"/>");
                                }
                            },


                            </sec:authorize>
                            {
                                title: "گزارش آماری ارزیابی دوره ها",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/coursesEvaluationStatisticalReport"/>");
                                }
                            },
                            <%--                            </sec:authorize>--%>
                            {
                                title: "<spring:message code="students.satisfaction.of.teachers.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/studentsSatisfactionOfTeachersReport"/>");
                                }

                            },
                            {
                                title: "<spring:message code="effective.courses.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/effectiveCoursesReport"/>");
                                }

                            },
                            {
                                title: "<spring:message code="personnel.statistic.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/personnelStatisticReport"/>");
                                }

                            },


                        ]
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Report_ReportsManagment')">
                {
                    title: "<spring:message code="reports.managment"/>",
                    submenu:
                        [
                            <sec:authorize access="hasAuthority('Menu_Report_ReportsManagment_ReportMonthlyStatistical')">
                            {
                                title: "<spring:message code="report.monthly.statistical"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/monthlyStatisticalReport"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "گزارش آماری سالانه",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/annualStatisticalReportBySections"/>");
                                }
                            },
                            </sec:authorize>
                            {isSeparator: true},
                            <sec:authorize access="hasAuthority('Menu_Categories_performance')">
                            {
                                title: "<spring:message code="course.performance.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/categoriesPerformanceReport"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_Personnel_Training_Status_Report')">
                            {
                                title: "<spring:message code="personnel.training.status.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/personnelTrainingStatusReport"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_continuous_Status_Report')">
                            {
                                title: "<spring:message code="continuous.status.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/continuousStatusReport"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            <sec:authorize access="hasAuthority('Menu_continuous_Status_Report')">
                            {
                                title: "گزارش اصلی واحد آمار",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/statisticsUnitReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            </sec:authorize>
                            {
                                title: "<spring:message code="man.hour.statistics.per.department.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/manHourStatisticsPerDepartmentReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "<spring:message code="man.hour.statistics.by.class.features.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/manHourStatisticsByClassFeaturesReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "<spring:message code="man.hour.statistics.by.class.category.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/manHourStatisticsByClassCategoryReport/"/>");
                                }
                            },
                            {isSeparator: true},
                            {
                                title: "<spring:message code="class.final.status.report"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/classFinalStatusReport/"/>");
                                }
                            },
                        ]
                },
                </sec:authorize>
                //@Todo sec:authorize for this menu
                {
                    title: "<spring:message code="reports.evaluation.and.online.exam"/>",
                    submenu:
                        [
                            //@Todo sec:authorize access="hasAuthority('Menu_Report_ReportsManagment_ReportMonthlyStatistical')">
                            {
                                title: "<spring:message code="reports.done.evaluations"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/evaluationDoneOnlineReport"/>");
                                }
                            },
                            //@Todo /sec:authorize>
                            {
                                title: "<spring:message code="reports.done.exams"/>",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/doneOnlineExamReport"/>");
                                }
                            },
                            //@Todo /sec:authorize>
                        ]
                },
                {
                    title: "گزارشات مالی",
                    submenu:
                        [
                            {
                                title: "گزارش هزینه کلاس ها",
                                click: function () {
                                    createTab(this.title, "<spring:url value="web/classCostReport"/>");
                                }
                            }

                        ]
                },
                {
                    title: "گزارشات شاخص های آماری",
                    submenu: [
                        {
                            title: "گزارش شاخص های آماری",
                            click: function () {
                                createTab(this.title, "<spring:url value="web/genericStatisticalIndexReport"/>");
                            }
                        }
                    ]
                }
            ]
        }),
    });
    </sec:authorize>


    <sec:authorize access="hasAuthority('Menu_ReportMaker')">
    jasperMenu = isc.ToolStripMenuButton.create({
            title: "<span>" +
                <%--isc.Canvas.imgHTML("<spring:url value="/static/img/pieces/report.png" />", 15, 15) + "&nbsp; </span>"+--%>
                "<spring:message code="training.jasper.soft.server.title"/>",
    menu: isc.Menu.create({
        autoDraw: false,
        showShadow: true,
        shadowDepth: 10,
        data: [
<%--            <sec:authorize access="hasAuthority('V_JASPER_ADHOC_SHOW')">--%>
            {
                title: "<spring:message code="training.jasper.adhoc.show"/>",// icon: "pieces/report.png",
                click: function () {
                    createTab("<spring:message code='training.jasper.adhoc.show'/>", "<spring:url value="/jasperSoft/adhocsShow"/>", false);
                }
            },
<%--            </sec:authorize>--%>
<%--            <sec:authorize access="hasAuthority('C_JASPER_ADHOC_CREATE')">--%>
            {
                title: "<spring:message code="training.jasper.adhoc.create"/>", //icon: "pieces/report.png",
                click: function () {
                    createTab("<spring:message code='training.jasper.adhoc.create'/>", "<spring:url value="/jasperSoft/adhocCreate"/>", false);
                }
            },
<%--            </sec:authorize>--%>
<%--            <sec:authorize access="hasAuthority('V_JASPER_REPORT_LIST_SHOW')">--%>
            {
                title: "<spring:message code='training.jasper.report'/>", //icon: "pieces/report.png",
                click: function () {
                    createTab("<spring:message code='training.jasper.report'/>", "<spring:url value="/jasperSoft/reports"/>", false);
                }
            },
<%--            </sec:authorize>--%>
<%--            <sec:authorize access="hasAuthority('V_JASPER_DASHBOARD_SHOW')">--%>
            {
                title: "<spring:message code='training.jasper.dashboard'/>", //icon: "pieces/report.png",
                click: function () {
                    createTab("<spring:message code='training.jasper.dashboard'/>", "<spring:url value="/jasperSoft/dashboards"/>", false);
                }
            },
<%--            </sec:authorize>--%>
<%--            <sec:authorize access="hasAuthority('V_JASPER_REPORTBUILDER_MANAGEMENT')">--%>
            {
                title: "<spring:message code='training.jasper.report.builder.management'/>"//, icon: "pieces/report.png"
                , submenu: [
<%--                    <sec:authorize access="hasAuthority('V_JASPER_DATASOURCE_LINK')">--%>

                    {
                        title: "<spring:message code='training.jasper.dataSource'/>", //icon: "pieces/report.png",
                        click: function () {
                            createTab("<spring:message code='training.jasper.dataSource'/>", "<spring:url value="/jasperSoft/dataSources"/>", false);
                        }
                    },
<%--                    </sec:authorize>--%>
<%--                    <sec:authorize access="hasAuthority('JASPER_DOMAINS_LINK')">--%>
                    {
                        title: "<spring:message code='training.jasper.domains'/>", //icon: "pieces/report.png",
                        click: function () {
                            createTab("<spring:message code='training.jasper.domains'/>", "<spring:url value="/jasperSoft/domains"/>", false);
                        }
                    }
<%--                    </sec:authorize>--%>
                ]
            }
<%--            </sec:authorize>--%>
        ]
     })
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Menu_Security')">
    securityTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="security"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                <%--{--%>
                <%--    title: "مدیریت کاربران",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="/web/oauth/landing/show-form" />", false);--%>
                <%--    }--%>
                <%--},--%>
                <%--{--%>
                <%--    title: "<spring:message code="user.plural"/>",--%>
                <%--    click: function () {--%>
                <%--        createTab(this.title, "<spring:url value="web/oaUser"/>");--%>
                <%--    }--%>
                <%--},--%>
                <%--<sec:authorize access="hasAuthority('Menu_Security_Users')">
                {
                    title: "کاربران",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/users/show-form"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>--%>


                <%--<sec:authorize access="hasAuthority('Menu_Security_PermissionGroup')">--%>
                <%--{--%>
                    <%--title: "گروه دسترسی",--%>
                    <%--click: function () {--%>
                        <%--createTab(this.title, "<spring:url value="web/oauth/groups/show-form"/>");--%>
                    <%--}--%>
                <%--},--%>
                <%--</sec:authorize>--%>


                <sec:authorize access="hasAuthority('Menu_Security_WorkGroup')">
                {
                    title: "<spring:message code="workGroup"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/work-group"/>");
                    },
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('Menu_Security_PermissionGroup','Menu_Security_WorkGroup')">
                {isSeparator: true},
                </sec:authorize>

                <%--<sec:authorize access="hasAuthority('Menu_Security_Roles')">--%>
                <%--{--%>
                    <%--title: "نقش ها",--%>
                    <%--click: function () {--%>
                        <%--createTab(this.title, "<spring:url value="web/oauth/app-roles/show-form"/>");--%>
                    <%--}--%>
                <%--},--%>
                <%--{isSeparator: true},--%>
                <%--</sec:authorize>--%>

                <%--<sec:authorize access="hasAuthority('Menu_Security_RoleSpecialized')">--%>
                <%--{--%>
                    <%--title: "تخصیص نقش",--%>
                    <%--click: function () {--%>
                        <%--createTab(this.title, "<spring:url value="web/oauth/users/show-form"/>");--%>
                    <%--}--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                <sec:authorize access="hasAuthority('Menu_Security_BlackList')">
                {
                    title: "لیست سیاه",
                    click: function () {
                        createTab(this.title, "<spring:url value="/black-list/show-form"/>");
                    }
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('Menu_Security_RoleSpecialized','Menu_Security_BlackList')">
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Security_OperationalUnit')">
                {
                    title: "<spring:message code="operational.unit"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/operational-unit/show-form"/>");
                    }
                },
<%--                </sec:authorize>--%>

<%--                <sec:authorize access="hasAuthority('Menu_Security_OperationalUnit')">--%>
<%--                {--%>
<%--                    title: "zaza",--%>
<%--                    click: function () {--%>
<%--alert("Bearer <%= accessToken %>")--%>
<%--                    }--%>
<%--                },--%>
                {isSeparator: true},
                </sec:authorize>
                <sec:authorize access="hasAuthority('Menu_Security_OperationalًRole')">
                {
                    title: "<spring:message code="operational.role"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/operationalRole/"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Security_Settings')">
                {
                    title: "<spring:message code="configurations"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/config/"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                  <sec:authorize access="hasAuthority('Menu_Security_Settings')">
                {
                    title: "تنظیمات ورژن جدید",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/v2/config/"/>");
                    }
                },
                {isSeparator: true},
                </sec:authorize>

                <sec:authorize access="hasAuthority('Menu_Security_UsersLoginReport')">
                {
                    title: "<spring:message code="users.login.report"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/usersLoginReport/"/>");
                    }
                },
                </sec:authorize>
            ]
        }),
    });
    </sec:authorize>

    trainingToolStrip = isc.ToolStrip.create({
        align: "center",
        membersMargin: 20,
        layoutMargin: 5,
        showShadow: true,
        shadowDepth: 3,
        shadowColor: "#153560",
        members: [
            <sec:authorize access="hasAuthority('Menu_BasicInfo')">
            basicInfoTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_NeedAssessment')">
            needsAssessmentTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Designing')">
            designingTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Run')">
            runTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Evaluation')">
            evaluationTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Cartable')">
            cartableTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Finance')">
            financeTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Report')">
            reportTSMB,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_ReportMaker')">
            jasperMenu,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Menu_Security')">
            securityTSMB
            </sec:authorize>
        ]
    });

    // -------------------------------------------  Page UI - TabSet  -----------------------------------------------

    closeAllButton = isc.IButtonClose.create({
        width: 100,
        title: "<spring:message code="close.all"/>",
        click: function () {
            if (mainTabSet.tabs.length == 0) return;
            var dialog = createDialog("ask", "<spring:message code="close.all.tabs?"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        mainTabSet.removeTabs(mainTabSet.tabs);
                        initShortcuts();
                    }
                }
            });
        }
    });
    <%--setTimeout(function(){--%>
        <%--createTab(this.title, "<spring:url value="web/parameter/"/>");--%>
    <%--}, 2000)--%>




    mainTabSet = isc.TabSet.create({
        minWidth: 1024,
        height: "100%",
        tabs: [
            ],
        tabBarControls: [closeAllButton],
    });







    function openShortcutTab(titleUrl){
       createTab( titleUrl.split(',')[0], titleUrl.split(',')[1]);
    }

    function initShortcuts() {
        shortcuts = [
            <sec:authorize access="hasAuthority('Menu_BasicInfo_Personnel')">
            {
                title: "<spring:message code="personnel.information"/>",
                url: "<spring:url value="personnelInformation/show-form"/>",
                icon: "static/img/shortcutMenu/personal.svg",

            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Run_Class')">
            {
                title: "<spring:message code="class"/>",
                url: "<spring:url value="/tclass/show-form"/>",
                icon: "static/img/shortcutMenu/classroom.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Designing_Course')">
            {
                title: "<spring:message code="course"/>",
                url: "<spring:url value="/course/show-form"/>",
                icon: "static/img/shortcutMenu/periods.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Evaluation_Evaluation')">
            {
                title: "<spring:message code="evaluation"/>",
                url:"<spring:url value="/evaluation/show-form"/>",
                icon: "static/img/shortcutMenu/evaluation.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_NeedAssessment_PostGroup')">
            {
                title: "<spring:message code="post.group"/>",
                url:"<spring:url value="web/post-group/"/>",
                icon: "static/img/shortcutMenu/needs.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_TrainingFile')">
            {
                title: "<spring:message code="training.file"/>",
                url:"<spring:url value="web/trainingFile/"/>",
                icon: "static/img/shortcutMenu/report.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_PassedPersonnel')">
            {
                title: "<spring:message code="personnel.courses"/>",
                url:"<spring:url value="web/studentClassReport/"/>",
                icon: "static/img/shortcutMenu/periodReport.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Report_ReportsRun_PersonnelCoursesNotPassed')">
            {
                title: "<spring:message code="personnel.courses.not.passed"/>",
                url:"<spring:url value="web/personnelCourseNotPassed/"/>",
                icon: "static/img/shortcutMenu/trainingReport.svg"
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Menu_Report_ReportsNeedsAssessment_ReportsNeedsAssessment')">
            {
                title: "<spring:message code="reports.need.assessment"/>",
                url:"<spring:url value="web/needsAssessment-reports"/>",
                icon: "static/img/shortcutMenu/needReports.svg"
            }
            </sec:authorize>

        ];

        vLayoutShortcuts = isc.VLayout.create({
            width: "100%",
            height: "100%",
            align: "center",
            vAlign: "center",
            membersMargin: 20,
            styleName: "landingPage",
            defaultLayoutAlign: "center",
        });
        mainTabSet.addTab(
            {
                title: 'خانه',
                pane:vLayoutShortcuts
            }
        )


        let shortcut;
        let index = 0;
        let hLayoutShortcut;
        let htmlPanShortcut;
        for( shortcut of shortcuts){
            if(index == 0 || index%3 == 0){
                hLayoutShortcut = isc.HLayout.create({
                    height: 160,
                    align: "center",
                    vAlign: "center",
                    defaultLayoutAlign: "center",
                    membersMargin: 20,
                })
            }
            hLayoutShortcut.addMembers(
                htmlPanShortcut = isc.HTMLPane.create({
                    width:160, height:160,
                    showEdges:false,
                    styleName:"shortcut-box",
                    contents: "<div class='sh-item' onclick=\"openShortcutTab('"+shortcut.title+","+shortcut.url+"')\" id='shortcutLink' ><img  class='sh-icon' onload=\"SVGInject(this)\"  src='"+shortcut.icon+"'> <h3>"+shortcut.title+"</h3></div>",
                    selectContentOnSelectAll:true
                })
            )
            if(index%3 == 0 )
                vLayoutShortcuts.addMembers(hLayoutShortcut)
            index++;
        }

    }
    initShortcuts();
    // -------------------------------------------  Page UI -----------------------------------------------

    var headerExitHLayout = isc.HLayout.create({
        width: "80%",
        height: "100%",
        align: "center",
        styleName: "header-exit",
        members: [isc.LayoutSpacer.create({width: "80%"}), userNameHLayout, languageAndToggleHLayout, logoutVLayout]
    });

    var headerLayout = isc.HLayout.create({
        width: "100%",
        height: 50,
        styleName: "header-top",
        members: [headerLogo,
            // ticket,
            // headerFlow,
            versionLbl,
            headerExitHLayout],
    });

    var MainDesktopMenuH = isc.HLayout.create({
        width: "100%",
        minWidth: 1024,
        height: "4%",
        styleName: "main-menu",
        align: "center",
        members: [
            trainingToolStrip
        ]
    });

    isc.TrVLayout.create({
        autoDraw: true,
        //styleName: "relativePosition",
        overflow: "auto",
        width: "100%",
        height: "100%",
        members: [
            headerLayout,
            MainDesktopMenuH,
            mainTabSet,
        ]
    });


    var checked = null;

    function onToggleClick(e) {
        checked = e.target.checked;
        if (checked) {

            headerLayout.setStyleName('header-top toggle-hide')
            MainDesktopMenuH.setStyleName('main-menu toggle-hide')
            headerLayout.setVisibility(false);
            MainDesktopMenuH.setVisibility(false);


        } else {
            headerLayout.setStyleName('header-top toggle-show')
            MainDesktopMenuH.setStyleName('main-menu toggle-show')
            headerLayout.setVisibility(true);
            MainDesktopMenuH.setVisibility(true);
        }
        // console.log(checked)
    }

    document.addEventListener("mousemove", function (event) {
        // console.log(event.clientY)
        if (event.clientY <= 2) {
            headerLayout.setStyleName('header-top toggle-show')
            MainDesktopMenuH.setStyleName('main-menu toggle-show')
            headerLayout.setVisibility(true);
            MainDesktopMenuH.setVisibility(true);

        } else if (event.clientY > 100) {
            if (checked) {
                headerLayout.setStyleName('header-top toggle-hide')
                MainDesktopMenuH.setStyleName('main-menu toggle-hide')
                headerLayout.setVisibility(false);
                MainDesktopMenuH.setVisibility(false);
            } else {
                headerLayout.setStyleName('header-top toggle-show')
                MainDesktopMenuH.setStyleName('main-menu toggle-show')
                headerLayout.setVisibility(true);
                MainDesktopMenuH.setVisibility(true);
            }

        }
    });


    // -------------------------------------------  Functions  -----------------------------------------------
    function logout() {
        document.location.href = "logout";
    }

    function createTab(title, url, callFunction, autoRefresh) {
        let tab = mainTabSet.getTabObject(title);
        if (tab !== undefined) {
            if ((autoRefresh !== undefined) && (autoRefresh === true) || (url.includes("oauth") && mainTabSet.getTab(i).pane.viewURL.includes("oauth"))) {
                mainTabSet.setTabPane(tab, isc.ViewLoader.create({viewURL: url}));
            }
            mainTabSet.selectTab(tab);
            if (callFunction != null) eval(callFunction);
        } else {
            mainTabSet.addTab({
                title: title,
                ID: title,
                pane: isc.ViewLoader.create({
                    viewURL: url,
                    viewLoaded() {eval(callFunction)},
                    handleError(rpcRequest, rpcResponse) {
                        // console.log('******************************************* Add Tab Error *******************************************');
                        // console.log(rpcResponse);
                        // console.log('*****************************************************************************************************');
                        createDialog("info", "خطا در ایجاد تب")
                    }
                }),
                canClose: true,
            });
            createTab(title, url, null, true);
        }
    }

    function createDialog(type, message, title) {
        if (type === 'wait') {
            message = message ? message : "<spring:message code='in.operation'/>"
        }
        let dialog = isc.Dialog.create({
            icon: type + (type === "wait" ? '.gif' : '.png'),
            iconSize: "20",
            title: title ? title : "<spring:message code="message"/>",
            message: message,
        });

        if (type === 'info') {
            dialog.setButtons([
                isc.IButtonSave.create({
                    title: "<spring:message code="ok"/>",
                    click: function () {
                        dialog.close();
                    }
                })
            ]);
        } else if (type === 'ask') {
            dialog.setButtons([
                isc.IButtonSave.create({title: "<spring:message code="yes"/>",}),
                isc.IButtonCancel.create({title: "<spring:message code="no"/>",})
            ]);
        } else if (type === 'confirm') {
            dialog.setButtons([
                isc.IButtonSave.create({title: "<spring:message code="ok"/>",}),
                isc.IButtonCancel.create({title: "<spring:message code="cancel"/>",})
            ]);
        } else if (type === 'wait'){
            dialog.setProperties({
                showCloseButton: false
            })
        }
        return dialog;
    }

    function refreshLG(listGridID, nextFunction) {
        // if (listGridID.getFilterEditorCriteria() !== null) {
        //     listGridID.filterByEditor();
        // } else {
        //     listGridID.clearCriteria();
        //     listGridID.invalidateCache();
        // }
        listGridID.filterByEditor();
        listGridID.invalidateCache();
        // if (listGridID.getCriteria() != null && listGridID.getCriteria().operator !== undefined)
        //     listGridID.filterByEditor();
        // else
        //     listGridID.invalidateCache();
        if (!nextFunction === undefined) {
            nextFunction();
        }
    }

    function refreshLgDs(listGridID, dataSourceID, fetchDataUrl) {
        if (!(dataSourceID === undefined)) {
            dataSourceID.fetchDataURL = fetchDataUrl;
        }
        refreshLG(listGridID);
    }

    function cleanLG(listGridID) {
        listGridID.setData([]);
    }

    function checkRecordAsSelected(record, showDialog, entityType, msg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            let dialog = createDialog("info", msg ? msg : (entityType ? "<spring:message code="from"/>&nbsp;<b>" + entityType + "</b>&nbsp;<spring:message code="msg.no.records.selected"/>" : "<spring:message code="msg.no.records.selected"/>"));
            Timer.setTimeout(function () {
                dialog.close();
            }, dialogShowTime);
        }
        return false;
    }

    function studyResponse(resp, action, entityType, winToClose, gridToRefresh, entityTitle) {
        let msg;
        let selectedState;
        if (resp == null) {
            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>");
        } else {
            let respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {
                isDelete_questionnaire=true;
                selectedState = "[{id:" + JSON.parse(resp.data).id + "}]";
                let entityTitle = JSON.parse(resp.httpResponseText).title;
                msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + entityTitle + '</b>\' &nbsp;' + "<spring:message code="msg.successfully.done"/>";

                if (gridToRefresh !== undefined) {
                    refreshLG(gridToRefresh);
                }
                let dialog = createDialog("info", msg);
                Timer.setTimeout(function () {
                    dialog.close();
                }, dialogShowTime);
            } else {
                if (respCode === 409) {
                    msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + entityTitle + '</b>\' &nbsp;' + "<spring:message code="msg.is.not.possible"/>";
                } else if (respCode === 401) {
                    msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + entityTitle + '</b>\' &nbsp;' + resp.httpResponseText;
                } else {
                    msg = "<spring:message code='msg.operation.error'/>";
                }
                createDialog("info", msg);
            }
            if (winToClose !== undefined) {
                winToClose.close();
            }
        }
    }

    function updateCountLabel(listGridID, LabelID) {
        listGridID.Super("dataChanged", arguments);
        let data = listGridID.data;
        let totalRows = data.getLength();
        if (totalRows >= 0 && data.lengthIsKnown())
            LabelID.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
        else
            LabelID.setContents("&nbsp;");
    }

    function removeRecord(actionURL, entityType, entityTitle, gridToRefresh) {
        let callback = "callback: studyResponse(rpcResponse, '" + "<spring:message code="remove"/>" + "', '" + entityType +
            "'," + undefined + "," + gridToRefresh + ",'" + entityTitle + "')";
        let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
        dialog.addProperties({
            buttonClick: function (button, index) {
                this.close();
                if (index == 0) {
                    isc.RPCManager.sendRequest(
                        TrDSRequest(actionURL, "DELETE", null, callback)
                    );
                }
            }
        })
    }

    function exportToExcel(fields, data, titr) {
        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/export/excel/",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "myToken", type: "hidden"},
                    {name: "fields", type: "hidden"},
                    {name: "data", type: "hidden"},
                    {name: "titr", type: "hidden"}
                ]
        });
        <%--downloadForm.setValue("myToken", "<%=accessToken%>");--%>
        downloadForm.setValue("fields", JSON.stringify(fields.toArray()));
        downloadForm.setValue("data", JSON.stringify(data.toArray()));
        downloadForm.setValue("titr", titr);
        downloadForm.show();
        downloadForm.submitForm();
    }

    function loadFrameworkMessageFa() {
        isc.RPCManager.sendRequest({
            httpMethod: "GET",
            showPrompt: false,
            useSimpleHttp: true,
            serverOutputAsString: false,
            contentType: "application/json; charset=utf-8",
            actionURL: "${contextPath}/isomorphic/locales/frameworkMessages_fa.properties",
            callback: function (RpcResponse_o) {
                eval(RpcResponse_o.data);
            }
        });
    }

    function printToJasper(data, params, fileName, type = "pdf") {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/export/print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fileName", type: "hidden"},
                    {name: "data", type: "hidden"},
                    {name: "params", type: "hidden"}
                ]
        });
        criteriaForm.setValue("data", JSON.stringify(data));
        criteriaForm.setValue("fileName", fileName);
        criteriaForm.setValue("params", JSON.stringify(params));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function printWithCriteria(advancedCriteria, params, fileName, type = "pdf", sortBy = null) {
        // var advancedCriteria = LG.getCriteria();
        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/export/print-criteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "fileName", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "sortBy", type: "hidden"},
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("fileName", fileName);
        criteriaForm.setValue("sortBy", sortBy);
        criteriaForm.setValue("params", JSON.stringify(params));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function transformCriteriaForLastModifiedDateNA(dsRequest){
        if (dsRequest.data && dsRequest.data.criteria) {
            let lastModifiedDateNA = dsRequest.data.criteria.filter(o => o.fieldName == 'lastModifiedDateNA');
            let georgianDate;
            if (lastModifiedDateNA && lastModifiedDateNA.length == 1)
                georgianDate = jalaliStrToGeorgianStr(lastModifiedDateNA[0].value);
            if(lastModifiedDateNA && lastModifiedDateNA.length == 2)
                georgianDate = lastModifiedDateNA[0].value.split(" ")[0];
            if (georgianDate){
                let date_criteria = dsRequest.data.criteria.filter(o => o.fieldName == 'lastModifiedDateNA')[0];
                date_criteria.value = georgianDate;
                date_criteria.operator = 'greaterOrEqual';
                dsRequest.data.criteria.add({
                    fieldName: 'lastModifiedDateNA',
                    value: georgianDate.concat(" 23:59:59"),
                    operator: 'lessOrEqual'
                });
            }
            else
                dsRequest.data.criteria.remove(dsRequest.data.criteria.filter(o => o.fieldName ==
                    'lastModifiedDateNA')[0]);
            if(dsRequest.data.criteria.length == 0)
                delete dsRequest.data;
        }
    }
    // ---------------------------------------- Not Ok - Start ----------------------------------------
    const enumUrl = rootUrl + "/enum/";
    const goalUrl = rootUrl + "/goal/";
    const syllabusUrl = rootUrl + "/syllabus/";
    const courseUrl = rootUrl + "/course/";
    const categoryUrl = rootUrl + "/category/";
    const subCategoryUrl = rootUrl + "/subcategory/";
    const teacherUrl = rootUrl + "/teacher/";
    const studentUrl = rootUrl + "/student/";
    const classUrl = rootUrl + "/tclass/";
    const classAuditUrl = rootUrl + "/tclass/audit/";
    const requestAuditUrl = rootUrl +"/request/audit/"
    const classEvalAuditUrl = rootUrl + "/tclass/evalAudit/";
    const evalAnswerAuditUrl = rootUrl + "/evaluationAnswer/evalAnswerAudit/";
    const classStudentHistoryUrl = rootUrl + "/class-student/history/";
    const classStudentAddHistoryUrl = rootUrl + "/class-student/add/history/";
    const classFinishUrl = rootUrl + "/tclass/finish/";
    const targetSocietyUrl = rootUrl + "/target-society/";
    const calenderCurrentTermUrl = rootUrl + "/calenderCurrentTerm/";
    const classReportUrl = rootUrl + "/classReport/";
    const instituteUrl = rootUrl + "/institute/";
    const educationUrl = rootUrl + "/education/";
    const educationLevelUrl = rootUrl + "/educationLevel/";
    const educationMajorUrl = rootUrl + "/educationMajor/";
    const educationOrientationUrl = rootUrl + "/educationOrientation/";
    const termUrl = rootUrl + "/term/";
    const unjustifiedAbsenceReport=rootUrl +"/unjustifiedAbsenceReport/"
    const preTestScoreReportURL = rootUrl + "/preTestScoreReport/";
    const cityUrl = rootUrl + "/city/";
    const stateUrl = rootUrl + "/state/";
    const personalInfoUrl = rootUrl + "/personalInfo/";
    const committeeUrl = rootUrl + "/committee/";
    const skillGroupUrl = rootUrl + "/skill-group/";
    const jobGroupUrl = rootUrl + "/job-group/";
    const companyUrl = rootUrl + "/company/";
    const addressUrl = rootUrl + "/address/";
    const operationalUnitUrl = rootUrl + "/operationalUnit/";
    const postGradeGroupUrl = rootUrl + "/postGradeGroup/";
    const checklistUrl = rootUrl + "/checklist/";
    const categoriesListUrl = rootUrl + "/category/";
    const checklistItemUrl = rootUrl + "/checklistItem/";
    const classCheckListUrl = rootUrl + "/class-checklist/";
    const needAssessmentSkillBasedUrl = rootUrl + "/needAssessmentSkillBased/";
    const sessionServiceUrl = rootUrl + "/sessionService/";
    const classStudent = rootUrl + "/classStudent/";
    const classAlarm = rootUrl + "/classAlarm/";
    const monthlyStatistical = rootUrl + "/monthlyStatistical/";
    const personnelRegByNationalCodeUrl = rootUrl + "/personnelRegistered/";
    const checkPersonnelNationalCodes = rootUrl + "/personnelRegistered/checkPersonnelNationalCodes";
    const addPerssonelRegisteredList = rootUrl + "/personnelRegistered/addList";
    const provinceUrl = rootUrl + "/province/";
    const polisUrl = rootUrl + "/polis/";
    const classDocumentUrl = rootUrl + "/classDocument/"
    const courseListNeedAssessment = rootUrl + "/trainingNeedAssessment/"
    const roleUrl = rootUrl + "/role/";
    const educationalCalenderUrl= rootUrl + "/educational-calender/"
    const classCourseFinalStatusReport = rootUrl + "/class-course-final-status-report"
    const classStudentFinalStatusReport = rootUrl + "/class-student-final-status-report"


    function TrnXmlHttpRequest(formData1, url, method, cFunction) {
        let xhttpRequest = new XMLHttpRequest();
        xhttpRequest.willHandleError = true;
        xhttpRequest.onreadystatechange = function () {
            if (this.readyState === 4) {
                cFunction(this);
            } else {
                // isc.say("خطا در اتصال به سرور");

            }
        };
        xhttpRequest.open(method, url, true);
        xhttpRequest.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
        xhttpRequest.send(formData1);
    }
    function MinIoUploadHttpRequest(formData1, url, groupId, cFunction) {

        let xhttpRequest = new XMLHttpRequest();
        xhttpRequest.willHandleError = true;
        xhttpRequest.onreadystatechange = function () {
            if (this.readyState === 4) {
                cFunction(this);
            } else {
                // isc.say("خطا در اتصال به سرور");

            }
        };
        xhttpRequest.open("Post", url+"/"+groupId, true);
        xhttpRequest.setRequestHeader("user-id", "Bearer <%= accessToken %>");
        xhttpRequest.setRequestHeader("app-id", "Training");
        <%--xhttpRequest.setRequestHeader("Authorization", "Bearer <%= accessToken %>");--%>
        xhttpRequest.send(formData1);
    }
    isc.defineClass("MyHLayoutButtons", HLayout);
    isc.MyHLayoutButtons.addProperties({
        width: "100%",
        height: 50,
        align: "center",
        verticalAlign: "center",
        membersMargin: 15,
        defaultLayoutAlign: "center",
    });

    isc.defineClass("MyComboBoxItem", ComboBoxItem);
    isc.MyComboBoxItem.addProperties({
        addUnknownValues: false,
        useClientFiltering: false,
        cachePickListResults: true,
        changeOnKeypress: false,
        width: "*"
    });

    isc.defineClass("MyOkDialog", Dialog);
    isc.MyOkDialog.addProperties({
        title: "<spring:message code='message'/>",
        isModal: true,
        buttons: [isc.IButtonSave.create({title: "تائید"})],
        icon: "[SKIN]say.png",
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.defineClass("MyYesNoDialog", Dialog);
    isc.MyYesNoDialog.addProperties({
        isModal: true,
        icon: "[SKIN]say.png",
        title: "<spring:message code='message'/>",
        buttons: [
            isc.IButtonSave.create({title: "بله",}),
            isc.IButtonCancel.create({title: "خير",})],
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.RPCManager.addClassProperties({
        defaultTimeout: 90000,
        willHandleError: true,
        handleError: function (response, request) {
            if(generalGetResp(response)){
                let userErrorMessage = "<spring:message code="msg.error.connecting.to.server"/>";
                if (JSON.parse(response.httpResponseText).message !== undefined && JSON.parse(response.httpResponseText).message !== "No message available" && JSON.parse(response.httpResponseText).message.length > 0) {
                    userErrorMessage = JSON.parse(response.httpResponseText).message;
                }else if (JSON.parse(response.httpResponseText).message !== undefined && (JSON.parse(response.httpResponseText).status == 404 ||JSON.parse(response.httpResponseText).status == 500 || JSON.parse(response.httpResponseText).status == 400)) {

                    if(JSON.parse(response.httpResponseText).path.indexOf("isomorphic/IDACall")==-1){

                        /*if(JSON.parse(response.httpResponseText).status == 400){
                            userErrorMessage = "خطا در ارسال اطلاعات";
                        }else */if(JSON.parse(response.httpResponseText).status == 404){
                            userErrorMessage = "خطا در ارسال اطلاعات";
                        }/*else if(JSON.parse(response.httpResponseText).status == 500){
                        userErrorMessage = "خطا در سرور";
                    }*/

                        createDialog("warning", userErrorMessage, "اخطار");
                        wait.close();
                    }
                    return;
                } else if (JSON.parse(response.httpResponseText).errors[0].message !== undefined && JSON.parse(response.httpResponseText).errors[0].message.length > 0) {
                    userErrorMessage = JSON.parse(response.httpResponseText).errors[0].message;
                }
                wait.close();
                createDialog("warning", userErrorMessage, "اخطار");


                <%--if (JSON.parse(response.httpResponseText).message !== "No message available" && response.httpResponseText.length > 0) {--%>
                <%--let userErrorMessage = "<spring:message code="exception.un-managed"/>";--%>
                <%--if(JSON.parse(response.httpResponseText).message.length > 0)--%>
                <%--userErrorMessage = JSON.parse(response.httpResponseText).message;--%>
                <%--else if(JSON.parse(response.httpResponseText).errors[0].message.length > 0 && response.httpResponseCode === 403)--%>
                <%--userErrorMessage = JSON.parse(response.httpResponseText).errors[0].message;--%>

                <%--createDialog("info", userErrorMessage);--%>
                <%--} else--%>
                <%--createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>");--%>
            }

        }
    });

    // isc.ViewLoader.addClassProperties({
    //     defaultTimeout: 60000,
    //     willHandleError: true,
    //     handleError: function (response, request) {
    //         alert('ViewLoader Error');
    //         console.log(response);
    //         // if (response.httpResponseCode == 401) {
    //         //     logout();
    //         // }
    //         return false;
    //     },
    // });

    function trPrintWithCriteria(url, advancedCriteria, dataParam) {
        trCriteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: url,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "token", type: "hidden"},
                    {name: "data", type: "hidden"}
                ]
        });
        trCriteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        if (dataParam != undefined || dataParam != null)
            trCriteriaForm.setValue("data", dataParam);
        trCriteriaForm.setValue("token", "<%=accessToken%>");
        trCriteriaForm.show();
        trCriteriaForm.submitForm();
    }

    function checkNationalCode(code) {
        if (code === undefined || code === null || code === "")
            return true;
        let L = code.length;

        if (L < 8 || parseFloat(code, 10) === 0)
            return false;
        code = ('0000' + code).substr(L + 4 - 10);
        if (parseFloat(code.substr(3, 6), 10) === 0)
            return false;
        let c = parseFloat(code.substr(9, 1), 10);
        let s = 0;
        for (let i = 0; i < 9; i++) {
            s += parseFloat(code.substr(i, 1), 10) * (10 - i);
        }
        s = s % 11;
        return (s < 2 && c === s) || (s >= 2 && c === (11 - s));
    }

    isc.defineClass("TrRefreshBtn", ToolStripButton);
    isc.TrRefreshBtn.addProperties({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
    });

    isc.defineClass("TrCreateBtn", ToolStripButton);
    isc.TrCreateBtn.addProperties({
        icon: "<spring:url value="create.png"/>",
        title: "<spring:message code="create"/>",
    });

    isc.defineClass("TrAddBtn", TrCreateBtn);
    isc.TrAddBtn.addProperties({
        title: "<spring:message code="add"/>",
    });

    isc.defineClass("TrEditBtn", ToolStripButton);
    isc.TrEditBtn.addProperties({
        icon: "<spring:url value="edit.png"/>",
        title: "<spring:message code="edit"/>",
    });

    isc.defineClass("TrRemoveBtn", ToolStripButton);
    isc.TrRemoveBtn.addProperties({
        icon: "<spring:url value="remove.png"/>",
        title: "<spring:message code="remove"/>",
    });

    isc.defineClass("TrPrintBtn", ToolStripMenuButton);
    isc.TrPrintBtn.addProperties({
        title: Canvas.imgHTML("<spring:url value="print.png"/>", 16, 16) + "&nbsp; <spring:message code="print"/>",
    });

    isc.defineClass("TrSaveBtn", Button);
    isc.TrSaveBtn.addProperties({
        title: "<spring:message code="save"/>",
    });

    isc.defineClass("TrSaveNextBtn", Button);
    isc.TrSaveNextBtn.addProperties({
        title: "<spring:message code="save.and.next"/>",
    });

    isc.defineClass("TrCancelBtn", Button);
    isc.TrCancelBtn.addProperties({
        title: "<spring:message code="cancel"/>",
    });

    //Calendar
    isc.SimpleType.create({
        name: "persianDate",
        inheritsFrom: "text",
        validators: [{
            type: "custom",
            errorMessage: "<spring:message code='validator.field.date'/>",
            condition: "moment.from(value, 'fa', 'YYYY/MM/DD').isValid()"
        }]
    });

    const persianDatePicker = isc.FormItem.getPickerIcon("date", {
        disableOnReadOnly: false,
        click: function (form, item, icon) {
            if (!item.getCanEdit())
                return;
            closeCalendarWindow();
            displayDatePicker(null, item, 'ymd', '/');
        },
        blur: function () {
            closeCalendarWindow();
        },
    });

    <%--function handleErrors(resp, req) {--%>

    <%--    if (resp == null || resp.httpResponseText == null)--%>
    <%--        return;--%>

    <%--    const title = {title: "<spring:message code='error'/>"};--%>
    <%--    if (resp.httpResponseCode === 401 || resp.httpResponseCode === 302) {--%>
    <%--        isc.say('<spring:message code="global.form.refresh" />', null, title);--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    if (resp.httpResponseCode === 400) {--%>
    <%--        isc.say('<spring:message code="exception.too-large" />', null, title);--%>
    <%--        return;--%>
    <%--    }--%>

    <%--    var errText = "";--%>
    <%--    var response = JSON.parse(resp.httpResponseText);--%>

    <%--    if (response == null || response.length === 0)--%>
    <%--        return;--%>

    <%--    if (response.errors != null)--%>
    <%--        response.errors.forEach(value => {--%>

    <%--            // if (value.field !== "")--%>
    <%--            //     errText += "<strong>" + value.field + "</strong>:<br>";--%>
    <%--            if (value.message != null && value.message !== "") {--%>
    <%--                if (value.message.startsWith('{') && value.message.endsWith('}'))--%>
    <%--                    errText += "<em><spring:message code='exception.data-validation'/>.</em><br>";--%>
    <%--                else--%>
    <%--                    errText += "<em>" + value.message + "</em><br>";--%>
    <%--            }--%>
    <%--        });--%>
    <%--    else if (response.exception != null)--%>
    <%--        if (response.exception !== "") {--%>
    <%--            if (response.exception.startsWith('{') && response.exception.endsWith('}'))--%>
    <%--                errText += "<em><spring:message code='exception.data-validation'/>.</em><br>";--%>
    <%--            else--%>
    <%--                errText += "<em>" + response.exception + "</em><br>";--%>
    <%--        }--%>

    <%--    if (errText !== "")--%>
    <%--        isc.say(errText, null, title);--%>
    <%--    else if (response.error === "NotFound")--%>
    <%--        isc.say('<spring:message code="exception.record.not−found" />', null, title);--%>
    <%--    else if (response.error === "Unauthorized")--%>
    <%--        isc.say('<spring:message code="exception.unauthorized" />', null, title);--%>
    <%--    else--%>
    <%--        isc.say('<spring:message code="exception.server.connection" />', null, title);--%>
    <%--}--%>

    <%--const trainingConfigs = {--%>
    <%--    Urls: {--%>
    <%--        DocumentUrl: document.URL.split("?")[0],--%>
    <%--        TClassFee: rootUrl + "/tclass-fee-title",--%>
    <%--        TClassFeeTitle: rootUrl + "/tclass-fee-title",--%>
    <%--        rootUrl: "${contextPath}/api",--%>
    <%--        workflowUrl: rootUrl + "/workflow",--%>
    <%--        jobUrl: rootUrl + "/job",--%>
    <%--        postGroupUrl: rootUrl + "/post-group",--%>
    <%--        postGradeUrl: rootUrl + "/postGrade",--%>
    <%--        postUrl: rootUrl + "/post",--%>
    <%--        competenceUrl: rootUrl + "/competence",--%>
    <%--        needAssessmentUrl: rootUrl + "/needAssessment",--%>
    <%--        skillUrl: rootUrl + "/skill",--%>
    <%--        attachmentUrl: rootUrl + "/attachment",--%>
    <%--        trainingPlaceUrl: rootUrl + "/trainingPlace",--%>
    <%--        personnelUrl: rootUrl + "/personnel",--%>
    <%--        personnelRegUrl: rootUrl + "/personnelRegistered",--%>
    <%--        attendanceUrl: rootUrl + "/attendance",--%>
    <%--        parameterUrl: rootUrl + "/parameter",--%>
    <%--        parameterValueUrl: rootUrl + "/parameter-value",--%>
    <%--        employmentHistoryUrl: rootUrl + "/employmentHistory",--%>
    <%--        teachingHistoryUrl: rootUrl + "/teachingHistory",--%>
    <%--        teacherCertificationUrl: rootUrl + "/teacherCertification",--%>
    <%--    },--%>
    <%--    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
    <%--    userFullName: '<%= SecurityUtil.getFullName()%>',--%>
    <%--    };--%>

    // -------------------------------------------  Variables  -----------------------------------------------
    var workflowRecordId = null;
    var workflowParameters = null;
    var todayDate = JalaliDate.JalaliTodayDate();
    var oneMonthBeforeToday = JalaliDate.JalaliOneMonthBeforeDate();
    var userPersonInfo = null;
    isc.RPCManager.sendRequest(TrDSRequest(viewActivePersonnelUrl + "/get-user-info", "GET", null, setUserPersonInfo));

    function setUserPersonInfo(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            userPersonInfo = (JSON.parse(resp.data));
        }
    }
    if(sayBrowser[0] === "Chrome"){
        createDialog("warning", "بهتر است با مرورگر فایرفاکس وارد شوید.", "اخطار");
    }
    else if(sayBrowser[0] !== "Firefox"){
        let warn = createDialog("warning", "لطفا با مرورگر فایرفاکس وارد شوید.", "اخطار");
        warn.setProperties({
            showCloseButton: false
        })
    }



    <%--isc.Validator.addProperties({requiredField: "<spring:message code="msg.field.is.required"/>"});--%>
    <%--loadingMessage: "<spring:message code="loading"/>",--%>
    <%--requiredMessage: "<spring:message code="msg.field.is.required"/>"--%>
    // emptyPickListMessage: "",
    <%--sortFieldAscendingText: "<spring:message code="sort.ascending"/>",--%>
    <%--sortFieldDescendingText: "<spring:message code="sort.descending"/>",--%>
    <%--configureSortText: "<spring:message code="sort.config"/>",--%>
    <%--clearSortFieldText: "<spring:message code="sort.clear"/>",--%>
    <%--autoFitAllText: "<spring:message code="auto.fit.all.columns"/>",--%>
    <%--autoFitFieldText: "<spring:message code="auto.fit"/>",--%>
    <%--emptyMessage: "",--%>
    <%--loadingDataMessage: "<spring:message code="loading"/>"--%>
    <%--createTab("<spring:message code="post"/>", "<spring:url value="/web/training-post"/>");--%>
    <%--createTab("<spring:message code="class"/>", "<spring:url value="/tclass/show-form"/>");--%>
    <%--createTab("<spring:message code="evaluation"/>", "<spring:url value="web/needsAssessment/"/>");--%>

    loadFrameworkMessageFa();
    wait.close();
    // ---------------------------------------- Not Ok - End ----------------------------------------

    // ---------------------------------------- OrganSegmentFilterDF ----------------------------------------

    function init_OrganSegmentFilterDF(disableField = false,
                                       useNameInCriteria = false,
                                       hideCompanyFilter = false,
                                       hideGhesmatFilter = false,
                                       hideVahedFilter = false,
                                       companyFieldName = "companyName",
                                       mojtameFieldName = "department.mojtameCode",
                                       moavenatFieldName = "department.moavenatCode",
                                       omorFieldName = "department.omorCode",
                                       ghesmatFieldName = "department.ghesmatCode",
                                       vahedFieldName = "department.vahedCode") {

        let filterDF;

        if (useNameInCriteria)
            filterDF = isc.OrganSegmentFilterDF_title.create({});
        else
            filterDF = isc.OrganSegmentFilterDF_code.create({});

        if (hideCompanyFilter === true)
            filterDF.getFields()[0].hide();

        if (hideGhesmatFilter === true)
            filterDF.getFields()[4].hide();

        if (hideVahedFilter === true)
            filterDF.getFields()[5].hide();

        if (disableField === true){
            filterDF.getFields()[2].disable();
            filterDF.getFields()[3].disable();
            filterDF.getFields()[4].disable();
            filterDF.getFields()[5].disable();
        }

        filterDF.getFields()[0].criteriaField = companyFieldName;
        filterDF.getFields()[1].criteriaField = mojtameFieldName;
        filterDF.getFields()[2].criteriaField = moavenatFieldName;
        filterDF.getFields()[3].criteriaField = omorFieldName;
        filterDF.getFields()[4].criteriaField = ghesmatFieldName;
        filterDF.getFields()[5].criteriaField = vahedFieldName;

        filterDF.getFields()[1].organSegmentFilterFieldName = useNameInCriteria ? "mojtameTitle" : "mojtameCode";
        filterDF.getFields()[2].organSegmentFilterFieldName = useNameInCriteria ? "moavenatTitle" : "moavenatCode";
        filterDF.getFields()[3].organSegmentFilterFieldName = useNameInCriteria ? "omorTitle" : "omorCode";
        filterDF.getFields()[4].organSegmentFilterFieldName = useNameInCriteria ? "ghesmatTitle" : "ghesmatCode";

        return filterDF;
    }

    isc.defineClass("OrganSegmentFilterDF_code", DynamicForm);
    isc.OrganSegmentFilterDF_code.addProperties({
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        numCols: 4,
        align: "right",
        titleAlign:"center",
        titleWidth: 0,
        overflow: "auto",
        height: 100,
        padding: 0,
        fields: [
            {
                name: "companyName",
                type: "SelectItem",
                title: "<spring:message code='company'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "titleFa"}],
                    cacheAllData: true,
                    fetchDataURL: rootUrl + "/geo-work/company-list"
                }),
                operator: "inSet",
                valueField: "titleFa",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                titleVAlign: "top",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",  width: "20%"},
                    {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "60%"}
                ],
                changed: function (form, item, value) {
                    if (value == null || value.length === 0 || (value.length === 1 && value[0] === "شرکت ملی صنایع مس ایران")){
                        form.getFields().forEach(f => f.enable());
                    } else {
                        form.getFields().forEach(f => { if (item.name !== f.name) {f.disable(); f.setValue([])}});
                    }
                }
            },
            {
                name: "department.mojtameCode",
                type: "SelectItem",
                title: "<spring:message code='complex'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    cacheAllData: true,
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",  width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                changed: function (form, item, value) {
                    form.updateCriteria(item, value, 1);
                },
            },
            {
                name: "department.moavenatCode",
                type: "SelectItem",
                title: "<spring:message code='assistance'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/moavenat"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",  width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;}
                },
                changed: function (form, item, value) {
                    form.updateCriteria(item, value, 2);
                }
            },
            {
                name: "department.omorCode",
                type: "SelectItem",
                title: "<spring:message code='affairs'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/omor"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;}
                },
                changed: function (form, item, value) {
                    form.updateCriteria(item, value, 3);
                }
            },
            {
                name: "department.ghesmatCode",
                type: "SelectItem",
                title: "<spring:message code='section'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/ghesmat"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",  width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {this.fetchData(); this.criteriaHasChanged = false;}
                },
                changed: function (form, item, value) {
                    form.updateCriteria(item, value, 4);
                }
            },
            {
                name: "department.vahedCode",
                type: "SelectItem",
                title: "<spring:message code='unit'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/vahed"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals", autoFitWidth: true,valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {this.fetchData(); this.criteriaHasChanged = false;}
                }
            },
        ],
        getCriteria: function (criteria){
            return isc.DataSource.combineCriteria(this.getValuesAsAdvancedCriteria(), criteria);
        },
        updateCriteria: function(item, value, fieldIndex){
            let criteria = null;
            if (value != null && value.length > 0) {
                criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {fieldName: item.organSegmentFilterFieldName, operator: "inSet", value: value},
                    ]
                };
            }
            for (let i = fieldIndex + 1; i < this.getFields().length; i++) {
                let fieldCriteria = this.getField(i).optionCriteria;
                if (fieldCriteria && fieldCriteria.criteria)
                    fieldCriteria.criteria.remove(fieldCriteria.criteria.find({fieldName: item.organSegmentFilterFieldName}));
                if (fieldCriteria && (fieldCriteria.criteria == null || fieldCriteria.criteria.length === 0))
                    fieldCriteria = null;
                let afterChangeCriteria = isc.DataSource.combineCriteria(criteria, fieldCriteria);
                this.getField(i).optionCriteria = afterChangeCriteria;
                this.getField(i).optionDataSource.implicitCriteria = afterChangeCriteria;
                this.getField(i).optionDataSource.invalidateCache();
                this.getField(i).criteriaHasChanged = true;
            }
        }
    });

    isc.defineClass("OrganSegmentFilterDF_title", DynamicForm);
    isc.OrganSegmentFilterDF_title.addProperties({
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        numCols: 4,
        align: "right",
        titleWidth: 0,
        titleAlign:"center",
        overflow: "auto",
        height: 100,
        padding: 0,
        fields: [
            {
                name: "companyName",
                type: "SelectItem",
                title: "<spring:message code='company'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "titleFa"}],
                    cacheAllData: true,
                    fetchDataURL: rootUrl + "/geo-work/company-list"
                }),
                operator: "inSet",
                valueField: "titleFa",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                titleVAlign: "top",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",  width: "20%"},
                    {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains",  width: "80%"}
                ],                changed: function (form, item, value) {
                    if (value == null || value.length === 0 || (value.length === 1 && value[0] === "شرکت ملی صنایع مس ایران")){
                        form.getFields().forEach(f => f.enable());
                    } else {
                        form.getFields().forEach(f => { if (item.name !== f.name) {f.disable(); f.setValue([])}});
                    }
                }
            },
            {
                name: "department.mojtameCode",
                type: "SelectItem",
                title: "<spring:message code='complex'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    cacheAllData: true,
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
                }),
                operator: "inSet",
                valueField: "title",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                // layoutStyle: "vertical",
                vAlign: "top",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>",width: "20%", filterOperator: "iContains"},
                    {name: "title", title: "<spring:message code='title'/>",width: "60%", filterOperator: "iContains"},
                    {name: "enabled", title: "<spring:message code="active.status"/>",width: "20%", filterOperator: "equals",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                changed: function (form, item, value) {
                    if(value!==null){
                        form.getFields()[2].enable();
                    }else{
                        form.getFields()[2].disable();
                    }
                    form.updateCriteria(item, value, 1);
                },
            },
            {
                name: "department.moavenatCode",
                type: "SelectItem",
                title: "<spring:message code='assistance'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/moavenat"
                }),
                operator: "inSet",
                valueField: "title",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals", width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {this.fetchData(); this.criteriaHasChanged = false;}
                },
                changed: function (form, item, value) {
                    if(value!==null){
                        form.getFields()[3].enable();
                    }else{
                        form.getFields()[3].disable();
                    }
                    form.updateCriteria(item, value, 2);
                }
            },
            {
                name: "department.omorCode",
                type: "SelectItem",
                title: "<spring:message code='affairs'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/omor"
                }),
                operator: "inSet",
                valueField: "title",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;
                    }
                },
                changed: function (form, item, value) {
                    if(value!==null){
                        form.getFields()[4].enable();
                    }else{
                        form.getFields()[4].disable();
                    }
                    form.updateCriteria(item, value, 3);
                }
            },
            {
                name: "department.ghesmatCode",
                type: "SelectItem",
                title: "<spring:message code='section'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/ghesmat"
                }),
                operator: "inSet",
                valueField: "title",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains",width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals", width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;}
                },
                changed: function (form, item, value) {
                    if(value!==null){
                        form.getFields()[5].enable();
                    }else{
                        form.getFields()[5].disable();
                    }
                    form.updateCriteria(item, value, 4);
                }
            },
            {
                name: "department.vahedCode",
                type: "SelectItem",
                title: "<spring:message code='unit'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/vahed"
                }),
                operator: "inSet",
                valueField: "title",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", width: "20%"},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                    {name: "enabled", title: "<spring:message code="active.status"/>", filterOperator: "equals",  width: "20%",valueMap:{74 : "غیر فعال"},filterOnKeypress: true}
                ],
                click(form, item){
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;}
                }
            },
        ],
        getCriteria: function (criteria){
            return isc.DataSource.combineCriteria(this.getValuesAsAdvancedCriteria(), criteria);
        },
        updateCriteria: function(item, value, fieldIndex){
            let criteria = null;
            if (value != null && value.length > 0) {
                criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {fieldName: item.organSegmentFilterFieldName, operator: "inSet", value: value},
                    ]
                };
            }
            for (let i = fieldIndex + 1; i < this.getFields().length; i++) {
                let fieldCriteria = this.getField(i).optionCriteria;
                if (fieldCriteria && fieldCriteria.criteria)
                fieldCriteria.criteria.remove(fieldCriteria.criteria.find({fieldName: item.organSegmentFilterFieldName}));
                if (fieldCriteria && (fieldCriteria.criteria == null || fieldCriteria.criteria.length === 0))
                    fieldCriteria = null;
                let afterChangeCriteria = isc.DataSource.combineCriteria(criteria, fieldCriteria);
                this.getField(i).optionCriteria = afterChangeCriteria;
                this.getField(i).optionDataSource.implicitCriteria = afterChangeCriteria;
                this.getField(i).optionDataSource.invalidateCache();
                this.getField(i).criteriaHasChanged = true;
            }
        }
    });

    <%--const localVer=localStorage.getItem('trainingVersion')--%>
    <%--if(!localVer || localVer !== "${trainingVersion}")--%>
    <%--{--%>
    <%--    isc.VersionsWindow.create({newVersion:"${trainingVersion}"});--%>
    <%--    localStorage.setItem('trainingVersion',"${trainingVersion}");--%>
    <%--}--%>

</script>
<nicico-ticket></nicico-ticket>
</body>
</html>
