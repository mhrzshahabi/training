package com.nicico.training.service.workflow;

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

    @Override
    public void execute(DelegateExecution exe) {

        String taskName = exe.getCurrentActivityId();

        //**********service task detect committee boss**********
        if (taskName.equalsIgnoreCase("servicetaskAssignMainConfirmBoss")) {
            exe.setVariable("needAssessmentMainConfirmBoss", "ahmadi_z");


            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("50")) {

//                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "ارسال به گردش کار تاییدیه اصلی", 50);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "ارسال به گردش کار تاییدیه اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "50");

            }
        }
        //**************************************************

        //**********service task set need assessment status****************
        if (taskName.equalsIgnoreCase("servicetaskSetNeedAssessmentStatus")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

//                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "عدم تایید اصلی", -51);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-51");

            } else if (exe.getVariable("REJECT").toString().equals("N")) {
//                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "تایید نهایی اصلی", 51);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "51");
            }
        }
        //**************************************************

        //**********service task need assessment correction************
        if (taskName.equalsIgnoreCase("servicetaskNeedSAssessmentCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {
                //tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "حذف گردش کار تاییدیه اصلی", -53);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "حذف گردش کار تاییدیه اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-53");
            }
            else if (exe.getVariable("REJECT").toString().equals("N")) {
                //tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "اصلاح نیازسنجی و ارسال به گردش کار تاییدیه اصلی", 60);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "اصلاح نیازسنجی و ارسال به گردش کار تاییدیه اصلی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "60");
            }
        }
        //**************************************************

    }

}
