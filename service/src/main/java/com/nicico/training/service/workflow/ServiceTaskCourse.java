package com.nicico.training.service.workflow;

import com.nicico.training.service.CourseService;
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
public class ServiceTaskCourse implements JavaDelegate {

    CourseService courseService;

    @Override
    public void execute(DelegateExecution exe) {

        String taskName = exe.getCurrentActivityId();

        //**********service task detect Supervisor**********
        if (taskName.equalsIgnoreCase("servicetaskAssignSupervisor")) {
            exe.setVariable("courseSupervisor", "saeidi_a");
        }
        //**************************************************


        //**********service task detect Boss****************
        if (taskName.equalsIgnoreCase("servicetaskAssignBoss")) {

            exe.setVariable("courseBoss", "ahmadi_z");

            if (exe.getVariable("REJECT").toString().equals("N")) {
                courseService.updateCourseState(Long.parseLong(exe.getVariable("cId").toString()), "تایید سرپرست", 1);
                exe.setVariable("C_WORKFLOW_STATUS", "تایید سرپرست");
                exe.setVariable("C_WORKFLOW_STATUS_CODE", "1");
            }
        }
        //**************************************************


        //**********service task set course status**********
        if (taskName.equalsIgnoreCase("servicetaskSetStatus1")) {

            if (exe.getVariable("REJECT").toString().equals("N")) {
                courseService.updateCourseState(Long.parseLong(exe.getVariable("cId").toString()), "تایید رئیس", 2);
                exe.setVariable("C_WORKFLOW_STATUS", "تایید رئیس");
                exe.setVariable("C_WORKFLOW_STATUS_CODE", "2");
            }
        }
        //**************************************************


        //**********service task correct course*************
        if (taskName.equalsIgnoreCase("servicetaskCorrection")) {


        }
        //**************************************************


        //**********service task delete workflow************
        if (taskName.equalsIgnoreCase("servicetaskDeleteWorkflow")) {


        }
        //**************************************************
    }

}
