package com.nicico.training.service.workflow;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.service.NeedsAssessmentTempService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@Getter
@Setter
@AllArgsConstructor
public class ServiceTaskCompetence implements JavaDelegate {


    NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final PersonnelDAO personnelDAO;
    private final CompetenceDAO competenceDAO;

    @Override
    public void execute(DelegateExecution exe) {

        String mainConfirmBoss = "ahmadi_z";
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());

        if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
//            mainConfirmBoss = "pourfathian_a";
            mainConfirmBoss = "aminpour_r ";
        }


        String taskName = exe.getCurrentActivityId();

        //**********service task detect committee boss**********
        if (taskName.equalsIgnoreCase("servicetaskAssignBoss")) {
            exe.setVariable("competenceBoss", mainConfirmBoss);

            if (exe.getVariable("REJECT").toString().equals("") && exe.getVariable("workflowStatusCode").toString().equals("0")) {

//                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 0, "ارسال به گردش کار ");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS", "ارسال به گردش کار");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS_CODE", "0");
                updateWorkFlow(Long.parseLong(exe.getVariable("cId").toString()), 0);

            }
        }
        //**************************************************

        //**********service task set need assessment status****************
        if (taskName.equalsIgnoreCase("servicetaskSetCompetenceStatus")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

//                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), -1, "عدم تایید");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS", "عدم تایید");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS_CODE", "1");
                updateWorkFlow(Long.parseLong(exe.getVariable("cId").toString()), 1);


            } else if (exe.getVariable("REJECT").toString().equals("N")) {
//                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 1, "تایید نهایی اصلی");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS", "تایید نهایی ");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS_CODE", "2");
                updateWorkFlow(Long.parseLong(exe.getVariable("cId").toString()), 2);
            }
        }
        //**************************************************

        //**********service task need assessment correction************
        if (taskName.equalsIgnoreCase("servicetaskCompetenceCorrection")) {

            if (exe.getVariable("REJECT").toString().equals("Y")) {

//                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), -3, "حذف گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS", "حذف گردش کار ");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS_CODE", "3");
                updateWorkFlow(Long.parseLong(exe.getVariable("cId").toString()), 3);

            } else if (exe.getVariable("REJECT").toString().equals("N")) {

//                needsAssessmentService.updateNeedsAssessmentMainWorkflow(Long.parseLong(exe.getVariable("cId").toString()), 10, "اصلاح نیازسنجی و ارسال به گردش کار اصلی");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS", "اصلاح شایستگی و ارسال به گردش کار ");
                exe.setVariable("C_WORKFLOW_COMPETENCE_STATUS_CODE", "4");
                updateWorkFlow(Long.parseLong(exe.getVariable("cId").toString()), 4);

            }
        }
        //**************************************************


    }

    @Transactional
    public void updateWorkFlow(Long id, Integer code) {
        competenceDAO.updateCompetenceState(id, code);
    }
}
