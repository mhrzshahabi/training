package com.nicico.training.service.workflow;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.service.NeedsAssessmentTempService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

@Component
@Getter
@Setter
@AllArgsConstructor
public class ServiceTaskNeedAssessmentMainConfirm implements JavaDelegate {


    private final NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final PersonnelDAO personnelDAO;

    @Override
    public void execute(DelegateExecution exe) {

        String objectType = (String) exe.getVariable("cType");
        Long objectId = Long.parseLong((String) exe.getVariable("cId"));

        String mainConfirmBoss = "ahmadi_z";
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());

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
