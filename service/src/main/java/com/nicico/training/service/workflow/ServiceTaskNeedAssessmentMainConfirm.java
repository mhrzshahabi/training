package com.nicico.training.service.workflow;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.copper.oauth.common.dto.OAUserDTO;
import com.nicico.training.client.oauth.OauthClient;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.*;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.service.NeedsAssessmentTempService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;


@Component
@Getter
@Setter
@AllArgsConstructor
public class ServiceTaskNeedAssessmentMainConfirm implements JavaDelegate {


    private final NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final PersonnelDAO personnelDAO;
    //TODO TAVASOLI XANIAR we need these to remove hard codes
//    private final SynonymPersonnelDAO synonymPersonnelDAO;
//    private final OperationalRoleDAO operationalRoleDAO;
//    private final ComplexDAO complexDAO;
//    private final DepartmentDAO departmentDAO;
//    private final ParameterValueDAO parameterValueDAO;
//    private final OauthClient oauthClient;

    @Override
    public void execute(DelegateExecution exe) {

        String objectType = (String) exe.getVariable("cType");
        Long objectId = Long.parseLong((String) exe.getVariable("cId"));

        String mainConfirmBoss = "ahmadi_z";
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());

        //TODO TAVASOLI XANIAR we need these to remove hard codes
//        SynonymPersonnel synonymPersonnel = synonymPersonnelDAO.findSynonymPersonnelDataByNationalCode(SecurityUtil.getNationalCode());
//        String departmentParamCode = "";
//        if (!synonymPersonnel.getComplexTitle().equals(null)){
//            ParameterValue parameterValue = parameterValueDAO.findByTitle(synonymPersonnel.getComplexTitle());
//            departmentParamCode = parameterValue.getCode();
//        }
//
//        String roleCode= "";
//        switch (departmentParamCode){
//            case "130": {
//                roleCode = "1300018864";
//                break;
//            }
//            case "110": {
//                roleCode = "1100011216";
//                break;
//            }
//            case "122": {
//                roleCode = "1220015175";
//                break;
//            }
//            case "121": {
//                roleCode = "1210017314";
//                break;
//            }
//            case "111": {
//                roleCode = "1110018056";
//                break;
//            }
//        }
//
//        if (roleCode != null){
//            Long mainConfirmOauthUserId = operationalRoleDAO.findRoleByCode(roleCode);
//            if (mainConfirmOauthUserId != null){
//                ResponseEntity<OAUserDTO.InfoByApp> res = oauthClient.get(mainConfirmOauthUserId);
//                OAUserDTO.InfoByApp info = res.getBody();
//                String nationalCode = info.getNationalCode();
//                String userName = info.getUsername();
//            }
//        }
//
        if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
//            mainConfirmBoss = "pourfathian_a";
            mainConfirmBoss = "hajizadeh_mh";
        }


        String taskName = exe.getCurrentActivityId();

        //**********service task detect committee boss**********
        if (taskName.equalsIgnoreCase("servicetaskAssignMainConfirmBoss")) {
            exe.setVariable("needAssessmentMainConfirmBoss", mainConfirmBoss);

            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("0")) {

                needsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(objectType, objectId, 0, "ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "0");

            }
        }
        //**************************************************

        //**********service task set need assessment status****************
        if (taskName.equalsIgnoreCase("servicetaskSetNeedAssessmentStatus")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

                needsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(objectType, objectId, -1, "عدم تایید اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-1");


            } else if (exe.getVariable("REJECT").toString().equals("N")) {
                needsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(objectType, objectId, 1, "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "1");
                needsAssessmentTempService.verify(objectType, objectId);
            }
        }
        //**************************************************

        //**********service task need assessment correction************
        if (taskName.equalsIgnoreCase("servicetaskNeedSAssessmentCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

                needsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(objectType, objectId, -3, "حذف گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "حذف گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-3");
                needsAssessmentTempService.deleteAllTempNA(objectType, objectId);

            } else if (exe.getVariable("REJECT").toString().equals("N")) {

                needsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(objectType, objectId, 10, "اصلاح نیازسنجی و ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "اصلاح نیازسنجی و ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "10");

            }
        }
        //**************************************************

    }

}
