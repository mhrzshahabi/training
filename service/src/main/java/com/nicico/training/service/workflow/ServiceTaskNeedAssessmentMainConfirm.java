package com.nicico.training.service.workflow;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.service.NeedsAssessmentService;
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


    NeedsAssessmentService needsAssessmentService;
    private final PersonnelDAO personnelDAO;

    @Override
    public void execute(DelegateExecution exe) {

        String mainConfirmBoss = "ahmadi_z";
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());

        if(complexTitle.equals("شهر بابک"))
        {
            mainConfirmBoss = "ebrahimi_l";
        }


        String taskName = exe.getCurrentActivityId();

        //**********service task detect committee boss**********
        if (taskName.equalsIgnoreCase("servicetaskAssignMainConfirmBoss")) {
            exe.setVariable("needAssessmentMainConfirmBoss", mainConfirmBoss);

            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("0")) {

                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 0, "ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "0");

            }
        }
        //**************************************************

        //**********service task set need assessment status****************
        if (taskName.equalsIgnoreCase("servicetaskSetNeedAssessmentStatus")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), -1, "عدم تایید اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-1");

            } else if (exe.getVariable("REJECT").toString().equals("N")) {
                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 1, "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "1");
            }
        }
        //**************************************************

        //**********service task need assessment correction************
        if (taskName.equalsIgnoreCase("servicetaskNeedSAssessmentCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), -3, "حذف گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "حذف گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-3");

            } else if (exe.getVariable("REJECT").toString().equals("N")) {

                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 10, "اصلاح نیازسنجی و ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "اصلاح نیازسنجی و ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "10");

            }
        }
        //**************************************************

    }

}
