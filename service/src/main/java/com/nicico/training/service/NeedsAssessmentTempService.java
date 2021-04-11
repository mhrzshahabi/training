
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentTempService extends BaseService<NeedsAssessmentTemp, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentTempDAO> {

    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;
    @Autowired
    private PostDAO postDAO;
    @Autowired
    private PostGroupDAO postGroupDAO;
    @Autowired
    private PostGradeDAO postGradeDAO;
    @Autowired
    private PostGradeGroupDAO postGradeGroupDAO;
    @Autowired
    private JobDAO jobDAO;
    @Autowired
    private JobGroupDAO jobGroupDAO;
    @Autowired
    private CompetenceDAO competenceDAO;
    @Autowired
    private SkillDAO skillDAO;
    @Autowired
    private TrainingPostDAO trainingPostDAO;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private PersonnelService personnelService;

    private Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

    @Autowired
    NeedsAssessmentTempService(NeedsAssessmentTempDAO needsAssessmentTempDAO) {
        super(new NeedsAssessmentTemp(), needsAssessmentTempDAO);
    }

    @Transactional
    public void initial(String objectType, Long objectId) {
        List<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, true)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return;
        needsAssessments.forEach(needsAssessment -> {
            NeedsAssessmentTemp needsAssessmentTemp = new NeedsAssessmentTemp();
            modelMapper.map(needsAssessment, needsAssessmentTemp);
            needsAssessmentTemp.setWorkflowStatus(null);
            needsAssessmentTemp.setWorkflowStatusCode(null);
            needsAssessmentTemp.setMainWorkflowStatus(null);
            needsAssessmentTemp.setMainWorkflowStatusCode(null);
            dao.saveAndFlush(needsAssessmentTemp);
        });
    }

    @Transactional
    public Boolean copyNA(String sourceObjectType, Long sourceObjectId, Long sourceCompetenceId, String objectType, Long objectId) {
        switch (readOnlyStatus(objectType, objectId)) {
            case 0:
                initial(objectType, objectId);
                break;
            case 2:
                return false;
        }
        SearchDTO.CriteriaRq criteria = getCriteria(sourceObjectType, sourceObjectId, true);
        if (sourceCompetenceId != null) {
            criteria.getCriteria().add(makeNewCriteria("competenceId", sourceCompetenceId, EOperator.equals, null));
        }
        List<Skill> skillList = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, true))).stream().map(NeedsAssessment::getSkill).collect(Collectors.toList());
        List<NeedsAssessment> sourceNeedsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(criteria));
        sourceNeedsAssessments.forEach(sourceNA -> {
            if (!skillList.contains(sourceNA.getSkill())) {
                NeedsAssessmentDTO.Create newNA = new NeedsAssessmentDTO.Create();
                modelMapper.map(sourceNA, newNA);
                newNA.setObjectId(objectId).setObjectType(objectType);
                create(newNA);
            }
        });
        return true;
    }


    @Transactional
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentDTO.verify> needsAssessmentTemps = modelMapper.map(dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, false))), new TypeToken<List<NeedsAssessmentDTO.verify>>() {
        }.getType());
        String createdBy = null;
        try {
            createdBy = needsAssessmentTemps.get(0).getCreatedBy();
            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            PersonnelDTO.Info person = personnelService.search(searchRq.setCriteria(makeNewCriteria("userName", createdBy, EOperator.equals, null))).getList().get(0);
            createdBy = person.getFirstName() + " " + person.getLastName();
        } catch (IndexOutOfBoundsException e) {
            createdBy = needsAssessmentTemps.get(0).getCreatedBy();
        } catch (Exception e) {
            createdBy = "anonymous";
        }
        needsAssessmentTemps.forEach(needsAssessmentTemp -> {
            Optional<NeedsAssessment> optional = needsAssessmentDAO.findById(needsAssessmentTemp.getId());
            if (optional.isPresent()) {
                NeedsAssessment na = optional.get();
                if (needsAssessmentTemp.getDeleted() != null && needsAssessmentTemp.getDeleted().equals(75L))
                    needsAssessmentDAO.updateDeleted(needsAssessmentTemp.getId(), 75L);
                else {
                    needsAssessmentDAO.updateNeedsAssessmentPriority(na.getId(), needsAssessmentTemp.getNeedsAssessmentPriorityId());
                }
            } else {
                NeedsAssessment needsAssessment = new NeedsAssessment();
                modelMapper.map(needsAssessmentTemp, needsAssessment);
                needsAssessmentDAO.saveAndFlush(needsAssessment);
            }
        });
        saveModifications(objectType, objectId, createdBy);
        dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional
    public Boolean rollback(String objectType, Long objectId) {
        if (readOnlyStatus(objectType, objectId) > 1)
            return false;
        deleteAllTempNA(objectType, objectId);
        return true;
    }

    @Transactional
    public void deleteAllTempNA(String objectType, Long objectId) {
        dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional(readOnly = true)
    public Integer readOnlyStatus(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId, false);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null || needsAssessmentTemps.isEmpty())
            return 0; //this object is editable and needs to be initialize
        if (needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername())) {
            if (needsAssessmentTemps.get(0).getMainWorkflowStatusCode() == null || needsAssessmentTemps.get(0).getMainWorkflowStatusCode() == -1)
                return 1; //this object is editable and dont needs to be initialize
            return 3; // this object is read only and user should see edited NAs
        } else
            return 2;
    }

    @Transactional(readOnly = true)
    public Boolean isEditable(String objectType, Long objectId) {
        switch (readOnlyStatus(objectType, objectId)) {
            case 0:
                initial(objectType, objectId);
            case 1:
                return true;
            case 2:
            case 3:
                return false;
        }
        return false;
    }

    @Override
    @Transactional
    public NeedsAssessmentDTO.Info create(NeedsAssessmentDTO.Create rq) {

        Optional<NeedsAssessmentTemp> optionalNA = dao.findFirstByObjectIdAndObjectTypeAndCompetenceIdAndSkillIdAndNeedsAssessmentDomainIdAndNeedsAssessmentPriorityId(rq.getObjectId(), rq.getObjectType(), rq.getCompetenceId(), rq.getSkillId(), rq.getNeedsAssessmentDomainId(), rq.getNeedsAssessmentPriorityId());
        if (optionalNA.isPresent()) {
            optionalNA.get().setDeleted(null);
            return modelMapper.map(dao.saveAndFlush(optionalNA.get()), NeedsAssessmentDTO.Info.class);
        }
        rq.setId(needsAssessmentDAO.getNextId());
        return super.create(rq);
    }

    @Override
    @Transactional
    public NeedsAssessmentDTO.Info delete(Long id) {
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp entityTemp = optional.orElseThrow(trainingExceptionSupplier);
        if (needsAssessmentDAO.existsById(id)) {
            entityTemp.setDeleted(75L);
            dao.saveAndFlush(entityTemp);
            return modelMapper.map(entityTemp, NeedsAssessmentDTO.Info.class);
        } else {
            try {
                dao.deleteById(id);
                return modelMapper.map(entityTemp, NeedsAssessmentDTO.Info.class);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.NotDeletable);
            }
        }
    }

    @Transactional
    public Boolean checkBeforeDeleteObject(String objectType, Long objectId) {
        List<NeedsAssessmentTemp> needsAssessments = dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, true)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return true;
        if (needsAssessments.get(0).getMainWorkflowStatusCode() == null) {
            dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
            return true;
        }
        return false;
    }

    public static SearchDTO.CriteriaRq getCriteria(String objectType, Long objectId, Boolean addNotDeletedCriteria) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        if (addNotDeletedCriteria) {
            criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        }
        return criteriaRq;
    }

    public int saveModifications(String objectType, Long objectId, String createdBy) {
        Date today = new Date();
        switch (objectType) {
            case "Post":
                return postDAO.updateModifications(objectId, today, createdBy);
            case "PostGroup":
                return postGroupDAO.updateModifications(objectId, today, createdBy);
            case "PostGrade":
                return postGradeDAO.updateModifications(objectId, today, createdBy);
            case "PostGradeGroup":
                return postGradeGroupDAO.updateModifications(objectId, today, createdBy);
            case "Job":
                return jobDAO.updateModifications(objectId, today, createdBy);
            case "JobGroup":
                return jobGroupDAO.updateModifications(objectId, today, createdBy);
            case "TrainingPost":
                return trainingPostDAO.updateModifications(objectId, today, createdBy);
        }
        return -1;
    }

    @Transactional(readOnly = true)
    public void checkCategoryNotEquals(NeedsAssessmentDTO.Create rq, HttpServletResponse resp) throws IOException {
        Optional<Competence> byId = competenceDAO.findById(rq.getCompetenceId());
        Competence competence = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        if (competence.getCategoryId() == null) {
            return;
        }
        Optional<Skill> byId1 = skillDAO.findById(rq.getSkillId());
        Skill skill = byId1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        if (!(skill.getSubCategoryId().equals(competence.getSubCategoryId()))) {
            resp.sendError(408, messageSource.getMessage("زیر گروه شایستگی با زیر گروه مهارت یکسان نیست.", null, LocaleContextHolder.getLocale()));
        }
        if (!(skill.getCategoryId().equals(competence.getCategoryId()))) {
            resp.sendError(408, messageSource.getMessage("گروه مهارت با گروه شایستگی یکسان نیست", null, LocaleContextHolder.getLocale()));
        }
    }

    @Transactional
    public Integer updateNeedsAssessmentTempMainWorkflow(String objectType, Long objectId, Integer workflowStatusCode, String workflowStatus) {
        return dao.updateNeedsAssessmentTempWorkflowMainStatus(objectType, objectId, workflowStatusCode, workflowStatus);
    }

    @Transactional(readOnly = true)
    public Boolean isCreatedByCurrentUser(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId, false);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null || needsAssessmentTemps.isEmpty())
            return null;
        return needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername());
    }
}