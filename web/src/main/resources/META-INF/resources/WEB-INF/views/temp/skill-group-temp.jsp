<%--	var url = "${restApiUrl}/api/skill-group";--%>

//
// skillData=[
//     {
//         skill_code:"CO6A001",
//         skill_name:"آشنایی با مفاهیم فن آوری"
//     },
//     {
//         skill_code:"CO2B004",
//         skill_name:"توانایی برنامه نویسی با زبان C"
//     }
// ]
// var skillDS=isc.DataSource.create({
//     fields:[
//         {name:"skill_code", title:"کد مهارت"},
//         {name:"skill_name", title:"نام مهارت"},
//     ],
//     clientOnly: true,
//     testData: skillData
// })
//
//
// var SkillListGrid=isc.ListGrid.create({
//     width:"100%", alternateRecordStyles:true,
//     dataSource: skillDS,
//     autoFetchData: true
// })

//
// competencyData=[
//     {
//         competencey_name:"شایستگی برنامه سازی",
//         competencey_type:"عملکردی"
//     },
//     {
//         competencey_name:"شایستگی مدیریت",
//         competencey_type:"توسعه ای"
//     },
//     {
//         competencey_name:"شایستگی برنامه ریزی",
//         competencey_type:"عملکردی"
//     }
// ]
// var CompetenceDS=isc.DataSource.create({
//       fields:[
//         {name:"competencey_name", title:"نام شایستگی"},
//         {name:"competencey_type", title:"نوع شایستگی"},
//              ],
//     clientOnly: true,
//     testData: competencyData
// })



<%--var RestDataSource_Skill_Group_Jsp = isc.RestDataSource.create({--%>
<%--fields: [--%>
<%--{name: "id"},--%>
<%--{name: "titleFa"},--%>
<%--{name: "titleEn"},--%>
<%--{name: "description"},--%>
<%--], dataFormat: "json",--%>
<%--jsonPrefix: "",--%>
<%--jsonSuffix: "",--%>
<%--transformRequest: function (dsRequest) {--%>
<%--dsRequest.httpHeaders = {--%>
<%--"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",--%>
<%--"Access-Control-Allow-Origin": "${restApiUrl}"--%>
<%--};--%>
<%--return this.Super("transformRequest", arguments);--%>
<%--},--%>
<%--fetchDataURL: "${restApiUrl}/api/course/spec-list"--%>
<%--});--%>

// alert(getFormulaMessage("salam","10","red"))