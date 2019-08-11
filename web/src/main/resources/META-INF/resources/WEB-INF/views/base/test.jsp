

isc.IButton.create({
title: "Hello",
icon: "icons/16/world.png",
iconOrientation: "right",
click: "isc.say('Hello world!')"
})


<%--<script>--%>
    <%--var Menu_ListGrid_FiscalYear = isc.Menu.create({--%>
        <%--width: 150,--%>
        <%--data: [{--%>
            <%--title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {--%>
                <%--ListGrid_FiscalYear_refresh();--%>
            <%--}--%>
        <%--}, {--%>
            <%--title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {--%>
                <%--DynamicForm_FiscalYear.clearValues();--%>
                <%--Window_FiscalYear.show();--%>
            <%--}--%>
        <%--}, {--%>
            <%--title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {--%>
                <%--ListGrid_FiscalYear_edit();--%>
            <%--}--%>
        <%--}, {--%>
            <%--title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {--%>
                <%--ListGrid_FiscalYear_remove();--%>
            <%--}--%>
        <%--}, {isSeparator: true}, {--%>
            <%--title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {--%>
                <%--window.open("/fiscalYear/print/pdf");--%>
            <%--}--%>
        <%--}, {--%>
            <%--title: "ارسال به Excel", icon: "icon/excel.png", click: function () {--%>
                <%--window.open("/fiscalYear/print/excel");--%>
            <%--}--%>
        <%--}, {--%>
            <%--title: "ارسال به Html", icon: "icon/html.jpg", click: function () {--%>
                <%--window.open("/fiscalYear/print/html");--%>
            <%--}--%>
        <%--}]--%>
    <%--});--%>
    <%--var RestDataSource_FiscalYear = isc.RestDataSource.create({--%>
        <%--fields: [{name: "id"}, {name: "code"}, {name: "nameFA"}, {name: "nameEN"}, {name: "startDate"}, {name: "endDate"}, {--%>
            <%--name: "isActive",--%>
            <%--valueMap: {"true": "فعال", "false": "غیر فعال"}--%>
        <%--}], dataFormat: "json", jsonPrefix: "", jsonSuffix: "", transformRequest: function (dsRequest) {--%>
            <%--dsRequest.httpHeaders = {--%>
                <%--"Authorization": "Bearer " + "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyUm9sZXMiOiJST0xFX0FETUlOIiwidXNlckdyb3VwcyI6IkdST1VQX0FETUlOIiwiYXVkIjpbIlRyYWluaW5nUmVzb3VyY2VJZCIsIk9BdXRoUmVzb3VyY2VJZCJdLCJ1c2VyX25hbWUiOiJhZG1pbiIsInNjb3BlIjpbInVzZXJfaW5mbyJdLCJleHAiOjE1NTgzNTk5NzUsImF1dGhvcml0aWVzIjpbImNfc2tpbGxMZXZlbCIsInJfc2tpbGxXb3JrQ2F0ZWdvcnkiLCJyX2pvYiIsInVfc2tpbGxXb3JrQ2F0ZWdvcnkiLCJkX3NraWxsV29ya0NhdGVnb3J5IiwiZF9za2lsbFN0YW5kYXJkIiwiZF9qb2IiLCJjX3NraWxsV29ya1N1YkNhdGVnb3J5IiwiY19za2lsbFN0YW5kYXJkIiwidV9za2lsbFN0YW5kYXJkIiwicl9za2lsbExldmVsIiwiZF9zeWxsYWJ1cyIsImNfc2tpbGxXb3JrQ2F0ZWdvcnkiLCJ1X3NraWxsV29ya1N1YkNhdGVnb3J5IiwiY19zeWxsYWJ1cyIsInVfam9iIiwiZF9za2lsbExldmVsIiwicl9zeWxsYWJ1cyIsImNfY291cnNlIiwicl9jb3Vyc2UiLCJ1X3NraWxsTGV2ZWwiLCJ1X3N5bGxhYnVzIiwicl9za2lsbFdvcmtTdWJDYXRlZ29yeSIsInVfY291cnNlIiwiZF9za2lsbFdvcmtTdWJDYXRlZ29yeSIsImNfam9iIiwiZF9jb3Vyc2UiLCJyX3NraWxsU3RhbmRhcmQiXSwianRpIjoiNTQwZmZhYWYtMmUxNi00NDM5LTk0NWItNjA4NDY5OTg1YTFjIiwiY2xpZW50X2lkIjoiVHJhaW5pbmdDbGllbnRJZCJ9.DXDYFxtf5llRScf8R2jozm--NEG4GSxsquaJQS7HNFnZWZplKQ-RtN48esisTeTgiZVwfQfA1JAOsgd0TyCm3wZp9Pp5VT9XGZlafmFU7ofisAthOuOL8ahjGogdX-3nTwCqFYY7sb1nf07fJEpnLkNmiUuebjGbmGI6UZo3YQLI7Ye7b-o2FpypMb2BCYvL_Bsrs22sfuQcBUFh4XIb_gl1dlP1xoSANDu1TWwbsd2JaaMo2cdLY8-rxKGS2mKfmJeh4ZNlXxYI9aV6MQ7JIzKkUojKBDBo79C9JsfbhtzrjGx__JYBK3E1wGMDHcNfLTrDPI20aj3fF-_bCyGjlw",--%>
            <%--};--%>
            <%--return this.Super("transformRequest", arguments);--%>
        <%--}, fetchDataURL: "${restApiUrl}/api/skill-level/spec-list"--%>
    <%--});--%>
    <%--var ListGrid_FiscalYear = isc.ListGrid.create({--%>
        <%--width: "100%",--%>
        <%--height: "100%",--%>
        <%--dataSource: RestDataSource_FiscalYear,--%>
        <%--contextMenu: Menu_ListGrid_FiscalYear,--%>
        <%--doubleClick: function () {--%>
            <%--ListGrid_FiscalYear_edit();--%>
        <%--},--%>
        <%--fields: [{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true}, {--%>
            <%--name: "code",--%>
            <%--title: "کد سال مالی",--%>
            <%--align: "center"--%>
        <%--}, {name: "nameFA", title: "نام سال مالی", align: "center"}, {--%>
            <%--name: "nameEN",--%>
            <%--title: "نام لاتین ",--%>
            <%--align: "center"--%>
        <%--}, {name: "startDate", title: "تاریخ شروع", align: "center"}, {--%>
            <%--name: "endDate",--%>
            <%--title: "تاریخ پایان",--%>
            <%--align: "center"--%>
        <%--}, {name: "isActive", title: "وضعیت", align: "center"}],--%>
        <%--sortField: 1,--%>
        <%--sortDirection: "descending",--%>
        <%--dataPageSize: 50,--%>
        <%--autoFetchData: true,--%>
        <%--showFilterEditor: true,--%>
        <%--filterOnKeypress: true,--%>
        <%--sortFieldAscendingText: "مرتب سازی صعودی ",--%>
        <%--sortFieldDescendingText: "مرتب سازی نزولی",--%>
        <%--configureSortText: "تنظیم مرتب سازی",--%>
        <%--autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",--%>
        <%--autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",--%>
        <%--filterUsingText: "فیلتر کردن",--%>
        <%--groupByText: "گروه بندی",--%>
        <%--freezeFieldText: "ثابت نگه داشتن",--%>
        <%--startsWithTitle: "tt"--%>
    <%--});--%>
    <%--var ValuesManager_FiscalYear = isc.ValuesManager.create({});--%>
    <%--var DynamicForm_FiscalYear = isc.DynamicForm.create({--%>
        <%--width: "100%",--%>
        <%--height: "100%",--%>
        <%--setMethod: 'POST',--%>
        <%--align: "center",--%>
        <%--canSubmit: true,--%>
        <%--showInlineErrors: true,--%>
        <%--showErrorText: true,--%>
        <%--showErrorStyle: true,--%>
        <%--errorOrientation: "right",--%>
        <%--colWidths: ["30%", "*"],--%>
        <%--titleAlign: "right",--%>
        <%--requiredMessage: "فیلد اجباری است.",--%>
        <%--numCols: 2,--%>
        <%--margin: 10,--%>
        <%--newPadding: 5,--%>
        <%--fields: [{name: "id", hidden: true}, {--%>
            <%--name: "code",--%>
            <%--title: "کد سال مالی",--%>
            <%--type: 'integer',--%>
            <%--required: true,--%>
            <%--keyPressFilter: "[0-9.]",--%>
            <%--length: "4",--%>
            <%--validators: [{--%>
                <%--type: "isInteger",--%>
                <%--validateOnExit: true,--%>
                <%--stopOnError: true,--%>
                <%--errorMessage: "لطفا مقدار عددی چهار رقمی وارد نمائید."--%>
            <%--}]--%>
        <%--}, {--%>
            <%--name: "nameFA",--%>
            <%--title: "نام سال مالی",--%>
            <%--required: true,--%>
            <%--type: 'text',--%>
            <%--readonly: true,--%>
            <%--hint: "Persian/فارسی",--%>
            <%--keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",--%>
            <%--length: "20",--%>
            <%--validators: [{--%>
                <%--type: "isString",--%>
                <%--validateOnExit: true,--%>
                <%--stopOnError: true,--%>
                <%--errorMessage: "نام مجاز بین چهار تا بیست کاراکتر است"--%>
            <%--}]--%>
        <%--}, {--%>
            <%--name: "nameEN",--%>
            <%--title: "نام لاتین ",--%>
            <%--type: 'text',--%>
            <%--keyPressFilter: "[a-z|A-Z|0-9 ]",--%>
            <%--length: "20",--%>
            <%--hint: "Latin",--%>
            <%--validators: [{--%>
                <%--type: "isString",--%>
                <%--validateOnExit: true,--%>
                <%--type: "lengthRange",--%>
                <%--min: 0,--%>
                <%--max: 20,--%>
                <%--stopOnError: true,--%>
                <%--errorMessage: "نام مجاز بین چهار تا بیست کاراکتر است"--%>
            <%--}]--%>
        <%--}, {--%>
            <%--name: "startDate",--%>
            <%--title: "تاریخ شروع",--%>
            <%--type: 'text',--%>
            <%--ID: "startDate",--%>
            <%--required: true,--%>
            <%--hint: "YYYY/MM/DD",--%>
            <%--showHintInField: true,--%>
            <%--focus: function () {--%>
                <%--displayDatePicker('startDate', this, 'ymd', '/');--%>
            <%--},--%>
            <%--icons: [{--%>
                <%--src: "pieces/pcal.png", click: function () {--%>
                    <%--closeCalendarWindow();--%>
                    <%--displayDatePicker('startDate', this, 'ymd', '/');--%>
                <%--}--%>
            <%--}],--%>
            <%--validators: [{--%>
                <%--validateOnExit: true,--%>
                <%--type: "substringCount",--%>
                <%--substring: "/",--%>
                <%--operator: "==",--%>
                <%--count: "2",--%>
                <%--min: 10,--%>
                <%--max: 10,--%>
                <%--stopOnError: true,--%>
                <%--errorMessage: "تاریخ را درست وارد کنید"--%>
            <%--}]--%>
        <%--}, {--%>
            <%--name: "endDate",--%>
            <%--title: "تاریخ پایان",--%>
            <%--type: 'text',--%>
            <%--ID: "endDate",--%>
            <%--required: true,--%>
            <%--hint: "YYYY/MM/DD",--%>
            <%--showHintInField: true,--%>
            <%--focus: function () {--%>
                <%--displayDatePicker('endDate', this, 'ymd', '/');--%>
            <%--},--%>
            <%--icons: [{--%>
                <%--src: "pieces/pcal.png", click: function () {--%>
                    <%--closeCalendarWindow();--%>
                    <%--displayDatePicker('endDate', this, 'ymd', '/');--%>
                <%--}--%>
            <%--}],--%>
            <%--validators: [{--%>
                <%--validateOnExit: true,--%>
                <%--type: "substringCount",--%>
                <%--substring: "/",--%>
                <%--operator: "==",--%>
                <%--count: "2",--%>
                <%--min: 10,--%>
                <%--max: 10,--%>
                <%--stopOnError: true,--%>
                <%--errorMessage: "تاریخ را درست وارد کنید"--%>
            <%--}]--%>
        <%--}, {name: "isActive", title: "فعال", type: "boolean"}]--%>
    <%--});--%>

    <%--function compareJalaliDates(startDate, endDate) {--%>
        <%--startDateArr = splitDateString(startDate);--%>
        <%--endDateArr = splitDateString(endDate);--%>
        <%--sd = parseInt(startDateArr[2], 10);--%>
        <%--sm = parseInt(startDateArr[1], 10);--%>
        <%--sy = parseInt(startDateArr[0], 10);--%>
        <%--ed = parseInt(endDateArr[2], 10);--%>
        <%--em = parseInt(endDateArr[1], 10);--%>
        <%--ey = parseInt(endDateArr[0], 10);--%>
        <%--if (sd <= ed && sm <= em && sy <= ey) return true; else return false;--%>
    <%--}--%>

    <%--var IButton_FiscalYear_Save = isc.IButton.create({--%>
        <%--top: 260, title: "ذخیره", icon: "pieces/16/save.png", click: function () {--%>
            <%--displayDatePicker('startDate');--%>
            <%--displayDatePicker('endDate');--%>
            <%--ValuesManager_FiscalYear.validate();--%>
            <%--DynamicForm_FiscalYear.validate();--%>
            <%--if (DynamicForm_FiscalYear.hasErrors()) {--%>
                <%--return;--%>
            <%--}--%>
            <%--var data = DynamicForm_FiscalYear.getValues();--%>
            <%--if (data['isActive'] == undefined) data['isActive'] = false;--%>
            <%--if (!compareJalaliDates(data['startDate'], data['endDate'])) {--%>
                <%--var ERROR = isc.Dialog.create({--%>
                    <%--message: "ترتیب تاریخ صحیح نیست",--%>
                    <%--icon: "[SKIN]stop.png",--%>
                    <%--title: "اجرای عملیات با مشکل مواجه شده است!"--%>
                <%--});--%>
                <%--setTimeout(function () {--%>
                    <%--ERROR.hide();--%>
                <%--}, 3000);--%>
                <%--return;--%>
            <%--}--%>
            <%--isc.RPCManager.sendRequest({--%>
                <%--actionURL: "/rest/fiscalYear/add",--%>
                <%--httpMethod: "POST",--%>
                <%--useSimpleHttp: true,--%>
                <%--contentType: "application/json; charset=utf-8",--%>
                <%--showPrompt: false,--%>
                <%--data: JSON.stringify(data),--%>
                <%--serverOutputAsString: false,--%>
                <%--callback: function (RpcResponse_o) {--%>
                    <%--if (RpcResponse_o.data == 'success') {--%>
                        <%--var OK = isc.Dialog.create({--%>
                            <%--message: "عملیات با موفقیت انجام شد.",--%>
                            <%--icon: "[SKIN]say.png",--%>
                            <%--title: "انجام فرمان"--%>
                        <%--});--%>
                        <%--setTimeout(function () {--%>
                            <%--OK.close();--%>
                        <%--}, 3000);--%>
                        <%--ListGrid_FiscalYear_refresh();--%>
                        <%--Window_FiscalYear.close();--%>
                    <%--} else if (RpcResponse_o.data == 'failed') {--%>
                        <%--var ERROR = isc.Dialog.create({--%>
                            <%--message: ("اجرای عملیات با مشکل مواجه شده است!"),--%>
                            <%--icon: "[SKIN]stop.png",--%>
                            <%--title: "پیغام"--%>
                        <%--});--%>
                        <%--setTimeout(function () {--%>
                            <%--ERROR.close();--%>
                        <%--}, 3000);--%>
                    <%--}--%>
                <%--}--%>
            <%--});--%>
        <%--}--%>
    <%--});--%>
    <%--var fiscalyearSaveOrExitHlayout = isc.HLayout.create({--%>
        <%--layoutMargin: 5,--%>
        <%--showEdges: false,--%>
        <%--edgeImage: "",--%>
        <%--width: "100%",--%>
        <%--alignLayout: "center",--%>
        <%--padding: 10,--%>
        <%--membersMargin: 10,--%>
        <%--members: [IButton_FiscalYear_Save, isc.IButton.create({--%>
            <%--ID: "courseEditExitIButton",--%>
            <%--title: "لغو",--%>
            <%--prompt: "",--%>
            <%--width: 100,--%>
            <%--icon: "pieces/16/icon_delete.png",--%>
            <%--orientation: "vertical",--%>
            <%--click: function () {--%>
                <%--Window_FiscalYear.close();--%>
            <%--}--%>
        <%--})]--%>
    <%--});--%>
    <%--var Window_FiscalYear = isc.Window.create({--%>
        <%--title: "FiscalYear.title",--%>
        <%--width: 500,--%>
        <%--autoSize: true,--%>
        <%--autoCenter: true,--%>
        <%--isModal: true,--%>
        <%--showModalMask: true,--%>
        <%--align: "center",--%>
        <%--autoDraw: false,--%>
        <%--dismissOnEscape: false,--%>
        <%--border: "1px solid gray",--%>
        <%--closeClick: function () {--%>
            <%--this.Super("closeClick", arguments);--%>
        <%--},--%>
        <%--items: [isc.VLayout.create({--%>
            <%--width: "100%",--%>
            <%--height: "100%",--%>
            <%--members: [DynamicForm_FiscalYear, fiscalyearSaveOrExitHlayout]--%>
        <%--})]--%>
    <%--});--%>

    <%--function ListGrid_FiscalYear_refresh() {--%>
        <%--var record = ListGrid_FiscalYear.getSelectedRecord();--%>
        <%--if (record == null || record.id == null) {--%>
        <%--} else {--%>
            <%--ListGrid_FiscalYear.selectRecord(record);--%>
        <%--}--%>
        <%--ListGrid_FiscalYear.invalidateCache();--%>
    <%--};--%>

    <%--function ListGrid_FiscalYear_remove() {--%>
        <%--var records = ListGrid_FiscalYear.getSelectedRecords();--%>
        <%--if (records == null || records.size() < 1) {--%>
            <%--isc.Dialog.create({--%>
                <%--message: "رکوردی انتخاب نشده است. !",--%>
                <%--icon: "[SKIN]ask.png",--%>
                <%--title: "پیغام",--%>
                <%--buttons: [isc.Button.create({title: "تائید"})],--%>
                <%--buttonClick: function (button, index) {--%>
                    <%--this.close();--%>
                <%--}--%>
            <%--});--%>
        <%--} else {--%>



        <%--}--%>

    <%--};--%>

    <%--function ListGrid_FiscalYear_edit() {--%>
        <%--var record = ListGrid_FiscalYear.getSelectedRecord();--%>
        <%--if (record == null || record.id == null) {--%>
            <%--isc.Dialog.create({--%>
                <%--message: "رکوردی انتخاب نشده است.",--%>
                <%--icon: "[SKIN]ask.png",--%>
                <%--title: "پیغام",--%>
                <%--buttons: [isc.Button.create({title: "تائید"})],--%>
                <%--buttonClick: function (button, index) {--%>
                    <%--this.close();--%>
                <%--}--%>
            <%--});--%>
        <%--} else {--%>
            <%--DynamicForm_FiscalYear.editRecord(record);--%>
            <%--Window_FiscalYear.show();--%>
        <%--}--%>
    <%--};var ToolStripButton_Refresh = isc.ToolStripButton.create({--%>
        <%--icon: "[SKIN]/actions/refresh.png",--%>
        <%--title: "بازخوانی اطلاعات",--%>
        <%--click: function () {--%>
            <%--ListGrid_FiscalYear_refresh();--%>
        <%--}--%>
    <%--});--%>
    <%--var ToolStripButton_Edit = isc.ToolStripButton.create({--%>
        <%--icon: "[SKIN]/actions/edit.png",--%>
        <%--title: "ویرایش",--%>
        <%--click: function () {--%>
            <%--ListGrid_FiscalYear_edit();--%>
        <%--}--%>
    <%--});--%>
    <%--var ToolStripButton_Add = isc.ToolStripButton.create({--%>
        <%--icon: "[SKIN]/actions/add.png",--%>
        <%--title: "ایجاد",--%>
        <%--click: function () {--%>
            <%--DynamicForm_FiscalYear.clearValues();--%>
            <%--Window_FiscalYear.show();--%>
        <%--}--%>
    <%--});--%>
    <%--var ToolStripButton_Remove = isc.ToolStripButton.create({--%>
        <%--icon: "[SKIN]/actions/remove.png",--%>
        <%--title: "حذف",--%>
        <%--click: function () {--%>
            <%--ListGrid_FiscalYear_remove();--%>
        <%--}--%>
    <%--});--%>
    <%--var ToolStripButton_Print = isc.ToolStripButton.create({--%>
        <%--icon: "[SKIN]/RichTextEditor/print.png",--%>
        <%--title: "چاپ",--%>
        <%--click: function () {--%>
            <%--window.open("/fiscalYear/print/pdf");--%>
        <%--}--%>
    <%--});--%>
    <%--var ToolStrip_Actions = isc.ToolStrip.create({--%>
        <%--width: "100%",--%>
        <%--members: [ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Refresh, ToolStripButton_Print]--%>
    <%--});--%>
    <%--var HLayout_Actions = isc.HLayout.create({width: "100%", members: [ToolStrip_Actions]});--%>
    <%--var HLayout_Grid = isc.HLayout.create({width: "100%", height: "100%", members: [ListGrid_FiscalYear]});--%>
    <%--var VLayout_Body = isc.VLayout.create({width: "100%", height: "100%", members: [HLayout_Actions, HLayout_Grid]});--%>