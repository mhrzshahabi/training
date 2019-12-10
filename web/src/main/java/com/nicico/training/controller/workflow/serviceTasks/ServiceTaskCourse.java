package com.nicico.training.controller.workflow.serviceTasks;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;

public class ServiceTaskCourse implements JavaDelegate {


    @Override
    public void execute(DelegateExecution exe) {

        exe.setVariable("courseSupervisor", "h.rastegari");
        exe.setVariable("courseBoss", "h.rastegari");
        exe.setVariable("status", "h.rastegari");
    }

}
