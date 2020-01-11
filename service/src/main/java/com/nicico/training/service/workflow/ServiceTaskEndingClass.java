package com.nicico.training.service.workflow;

import com.nicico.training.service.TclassService;
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
public class ServiceTaskEndingClass implements JavaDelegate {

    TclassService tclassService;

    @Override
    public void execute(DelegateExecution exe) {

        String taskName = exe.getCurrentActivityId();

        //**********service task detect Supervisor**********
        if (taskName.equalsIgnoreCase("servicetaskAssignSupervisor")) {
            exe.setVariable("endingClassSupervisor", "saeidi_a");


            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("0")) {

                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "ارسال به گردش کار", 0);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "ارسال به گردش کار");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "0");

            } else if (exe.getVariable("REJECT").toString().equals("Y")) {

                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "عدم تایید نهایی", -2);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید نهایی");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-2");

            }
        }
        //**************************************************

        //**********service task detect Boss****************
        if (taskName.equalsIgnoreCase("servicetaskAssignBoss")) {

            exe.setVariable("endingClassBoss", "ahmadi_z");

            if (exe.getVariable("REJECT").toString().equals("N")) {
                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "تایید سرپرست", 1);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید سرپرست");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "1");
            }
        }
        //**************************************************


        //**********service task set course status**********
        if (taskName.equalsIgnoreCase("servicetaskSetStatus1")) {

            if (exe.getVariable("REJECT").toString().equals("N")) {
                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "تایید نهایی پایان کلاس", 2);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "تایید نهایی پایان کلاس");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "2");
            }
        }
        //**************************************************


        //**********service task set course status**********
        if (taskName.equalsIgnoreCase("servicetaskSetStatus2")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {
                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "عدم تایید سرپرست", -1);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "عدم تایید سرپرست");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-1");
            }
        }
        //**************************************************


        //**********service task correct course*************
        if (taskName.equalsIgnoreCase("servicetaskCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("N")) {
                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "اصلاح پایان کلاس", 20);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "اصلاح پایان کلاس");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "20");
            }
        }
        //**************************************************


        //**********service task delete workflow************
        if (taskName.equalsIgnoreCase("servicetaskDeleteWorkflow")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {
                tclassService.updateClassState(Long.parseLong(exe.getVariable("cId").toString()), "حذف گردش کار", -3);
                exe.setVariable("C_WORKFLOW_ENDING_STATUS", "حذف گردش کار");
                exe.setVariable("C_WORKFLOW_ENDING_STATUS_CODE", "-3");
            }
        }
        //**************************************************

    }
}
