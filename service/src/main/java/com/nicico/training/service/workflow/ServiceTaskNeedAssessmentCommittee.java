package com.nicico.training.service.workflow;

import com.nicico.training.service.NeedsAssessmentService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
@Getter
@Setter
@AllArgsConstructor
public class ServiceTaskNeedAssessmentCommittee implements JavaDelegate {

    NeedsAssessmentService needsAssessmentService;

    @Override
    public void execute(DelegateExecution exe) {

        String taskName = exe.getCurrentActivityId();

        //**********service task detect committee boss**********
        if (taskName.equalsIgnoreCase("servicetaskAssignCommitteeBoss")) {
            exe.setVariable("needAssessmentCommitteeBoss", "saeidi_a");

            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("0")) {

                needsAssessmentService.updateNeedsAssessmentWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 0, "ارسال به گردش کار کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "ارسال به گردش کار کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "0");
            }
        }
        //**************************************************

        //**********service task set need assessment status****************
        if (taskName.equalsIgnoreCase("servicetaskSetNeedAssessmentStatus")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

                needsAssessmentService.updateNeedsAssessmentWorkflow(Long.parseLong(exe.getVariable("cId").toString()),-1, "عدم تایید کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-1");

            } else if (exe.getVariable("REJECT").toString().equals("N")) {
                needsAssessmentService.updateNeedsAssessmentWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 1,"تایید نهایی کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید نهایی کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "1");
            }
        }
        //**************************************************

        //**********service task need assessment correction************
        if (taskName.equalsIgnoreCase("servicetaskNeedSAssessmentCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {
                needsAssessmentService.updateNeedsAssessmentWorkflow(Long.parseLong(exe.getVariable("cId").toString()),-3, "حذف گردش کار کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "حذف گردش کار کمیته");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-3");
            } else if (exe.getVariable("REJECT").toString().equals("N")) {
                needsAssessmentService.updateNeedsAssessmentWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 10,"اصلاح نیازسنجی و ارسال به گردش کار");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "اصلاح نیازسنجی و ارسال به گردش کار");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "10");
            }

        }
        //**************************************************

    }


}
