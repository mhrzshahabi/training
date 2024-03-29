
package com.nicico.training.service;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.dto.NeedsAssessmentForBpms;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.INeedsAssessmentService;
import com.nicico.training.iservice.INeedsAssessmentTempService;
import com.nicico.training.model.Competence;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.model.NeedsAssessmentTemp;
import com.nicico.training.model.Skill;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.*;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentTempService extends BaseService<NeedsAssessmentTemp, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentTempDAO> implements INeedsAssessmentTempService {


    @Autowired
    protected EntityManager entityManager;


    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;
    @Autowired
    private INeedsAssessmentService iNeedsAssessmentService;
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

    private final Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

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
    public List<NeedsAssessmentDTO.Info> getValuesForCopyNA(String sourceObjectType, Long sourceObjectId, Long sourceCompetenceId, String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteria = getCriteria(sourceObjectType, sourceObjectId, true);
        if (sourceCompetenceId != null) {
            criteria.getCriteria().add(makeNewCriteria("competenceId", sourceCompetenceId, EOperator.equals, null));
        }
        List<Skill> skillList = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, true))).stream().map(NeedsAssessment::getSkill).collect(Collectors.toList());
        List<NeedsAssessment> sourceNeedsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(criteria));
        List<NeedsAssessmentDTO.Info> list = new ArrayList<>();
        sourceNeedsAssessments.forEach(sourceNA -> {
            if (!skillList.contains(sourceNA.getSkill())) {
                NeedsAssessmentDTO.Info newNA = new NeedsAssessmentDTO.Info();
                modelMapper.map(sourceNA, newNA);
                newNA.setObjectId(objectId).setObjectType(objectType);
                list.add(newNA);
            }
        });
        return list;
    }

    @Transactional
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentDTO.verify> needsAssessmentTemps = modelMapper.map(dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, false))), new TypeToken<List<NeedsAssessmentDTO.verify>>() {
        }.getType());
        String createdBy = null;
        try {
            if (needsAssessmentTemps.size()>0){
                createdBy = needsAssessmentTemps.get(0).getCreatedBy();
                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
                PersonnelDTO.Info person = personnelService.search(searchRq.setCriteria(makeNewCriteria("userName", createdBy, EOperator.equals, null))).getList().get(0);
                createdBy = person.getFirstName() + " " + person.getLastName();
            }
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
                    needsAssessmentDAO.updateNeedsAssessmentPriority(na.getId(), needsAssessmentTemp.getNeedsAssessmentPriorityId() ,needsAssessmentTemp.getLimitSufficiency());
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
        deleteAllNotSentTempNA(objectType, objectId);
        return true;
    }

    @Transactional
    public void deleteAllTempNA(String objectType, Long objectId) {
        dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional
    public void deleteAllNotSentTempNA(String objectType, Long objectId) {
        dao.deleteAllNotSentByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional(readOnly = true)
    public Integer readOnlyStatus(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId, false);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null || needsAssessmentTemps.isEmpty())
            return 0; //this object is editable and needs to be initialize
        if (needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername())) {
            return 1; //this object is editable and dont needs to be initialize
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
    public static SearchDTO.CriteriaRq getCriteriaForInstance(String processInstanceId) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("processInstanceId", processInstanceId, EOperator.equals, null));
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
    public TrainingException checkCategoryNotEquals(NeedsAssessmentDTO.Create rq) {
        Optional<Competence> byId = competenceDAO.findById(rq.getCompetenceId());
        Competence competence = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        if (competence.getCategoryId() == null) {
            return null;
        }
        Optional<Skill> byId1 = skillDAO.findById(rq.getSkillId());
        Skill skill = byId1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        if (!(skill.getSubCategoryId().equals(competence.getSubCategoryId()))) {
            return new TrainingException(TrainingException.ErrorType.SkillSubCatIsNotEqualWithNASubCat, messageSource.getMessage("زیر گروه شایستگی با زیر گروه مهارت یکسان نیست.", null, LocaleContextHolder.getLocale()));
        }
        if (!(skill.getCategoryId().equals(competence.getCategoryId()))) {
            return new TrainingException(TrainingException.ErrorType.SkillCatIsNotEqualWithNACat, messageSource.getMessage("گروه مهارت با گروه شایستگی یکسان نیست", null, LocaleContextHolder.getLocale()));
        }
        return null;
    }

    @Transactional
    public Integer updateNeedsAssessmentTempMainWorkflow(String  processInstanceId, Integer workflowStatusCode, String workflowStatus) {
        return dao.updateNeedsAssessmentTempWorkflowMainStatus(processInstanceId, workflowStatusCode, workflowStatus);
    }

    @Override
    public Integer updateNeedsAssessmentTempWorkflowMainStatusInBpms(String objectType, Long objectId, Integer workflowStatusCode, String workflowStatus, String reason) {
        return dao.updateNeedsAssessmentTempWorkflowMainStatusInBpms(objectType, objectId, workflowStatusCode, workflowStatus,reason);

    }

    @Transactional(readOnly = true)
    public Boolean isCreatedByCurrentUser(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId, false);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null || needsAssessmentTemps.isEmpty())
            return null;
        return needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername());
    }

    public List<NeedsAssessmentTemp> getListByObjectIdAndType(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId, false);
        return dao.findAll(NICICOSpecification.of(criteriaRq));
    }

    public Boolean createOrUpdateList(List<NeedsAssessmentDTO.Create> createList, Long objectId, String objectType) {
        for (NeedsAssessmentDTO.Create create : createList) {
            TrainingException exception = checkCategoryNotEquals(create);
            if (exception != null)
                throw exception;
            if (create.getObjectType().equals(objectType) && !isEditable(create.getObjectType(), create.getObjectId()) )
                throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentIsNotEditable, messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()));
        }
        List<NeedsAssessmentTemp> alreadyExist = getListByObjectIdAndType(objectType, objectId);
        List<NeedsAssessmentTemp> removedRecords = new ArrayList<>();
        if (alreadyExist != null && !alreadyExist.isEmpty()) {
            for (NeedsAssessmentTemp needsAssessmentTemp : alreadyExist) {
                Optional<NeedsAssessmentDTO.Create> any = createList.stream().filter(create -> create.getId() != null).filter(create -> create.getId().equals(needsAssessmentTemp.getId())).findAny();
                if (any.isPresent())
                    createList.remove(any.get());
                else
                    removedRecords.add(needsAssessmentTemp);
            }
        }
        if (!removedRecords.isEmpty())
            for (NeedsAssessmentTemp removedRecord : removedRecords) {
                delete(removedRecord.getId());
            }
        for (NeedsAssessmentDTO.Create create : createList) {
            if (create.getObjectType().equals(objectType))
            create(create);
        }
        Boolean hasAlreadySentToWorkFlow = !alreadyExist.isEmpty() && alreadyExist.stream()
                .anyMatch(needsAssessmentTemp -> needsAssessmentTemp.getMainWorkflowStatusCode() != null && (needsAssessmentTemp.getMainWorkflowStatusCode() == 0 || needsAssessmentTemp.getMainWorkflowStatusCode() == -1 ));
        return hasAlreadySentToWorkFlow;
    }

    public Long createOrUpdateListForNewSkill(List<NeedsAssessmentDTO.Create> createList, Long skill) {
        List<NeedsAssessmentDTO.Create> newList = new ArrayList<>();
        for (NeedsAssessmentDTO.Create needsAssessmentDTO : createList) {
            if (needsAssessmentDTO.getSkillId().equals(skill))
                newList.add(needsAssessmentDTO);
        }
        for (NeedsAssessmentDTO.Create create : newList) {
            TrainingException exception = checkCategoryNotEquals(create);
            if (exception != null)
                throw exception;
            if (!isEditable(create.getObjectType(), create.getObjectId()))
                throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentIsNotEditable, messageSource.getMessage("read.only.na.message", null, LocaleContextHolder.getLocale()));
        }
        NeedsAssessmentDTO.Info createItem = new NeedsAssessmentDTO.Info();

        for (NeedsAssessmentDTO.Create create : newList) {
            createItem = create(create);
        }
        return createItem.getId();
    }

    @Override
    public boolean updateNeedsAssessmentTempBpmsWorkflow(ProcessInstance ProcessInstance, Long objectId, String objectType, String mainWorkflowStatus, String mainWorkflowStatusCode) {
        try {

            SearchDTO.SearchRs<NeedsAssessmentDTO.Info> list=  iNeedsAssessmentService.fullSearch(objectId, objectType);
            Set<NeedsAssessmentForBpms> dataForUpdate=new HashSet<>();
            list.getList().forEach(item->{
                NeedsAssessmentForBpms needsAssessmentForBpms=new NeedsAssessmentForBpms();
                needsAssessmentForBpms.setObjectId(item.getObjectId());
                needsAssessmentForBpms.setObjectType(item.getObjectType());
                if (dataForUpdate.stream().noneMatch(a -> (a.getObjectId().equals(item.getObjectId()))) && dataForUpdate.stream().noneMatch(a -> (a.getObjectType().equals(item.getObjectType()))))
                dataForUpdate.add(needsAssessmentForBpms);
            });
            var ref = new Object() {
                int index = 0;
            };
            dataForUpdate.forEach(data->{
                dao.updateNeedsAssessmentTempBpmsWorkflow(ProcessInstance.getId(), data.getObjectId(), data.getObjectType(), mainWorkflowStatus, mainWorkflowStatusCode);
                ref.index = ref.index +1;
            });
            return ref.index == dataForUpdate.size();
        } catch (Exception e) {
            return false;
        }
    }

    @Transactional
    @Override
    public Integer updateNeedsAssessmentTempMainWorkflowProcessInstanceId(String objectType, Long objectId, Integer workflowStatusCode, String workflowStatus) {
        Optional<NeedsAssessmentTemp> needsAssessmentTemp = dao.findFirstByObjectTypeAndObjectIdAndProcessInstanceIdNotNull(objectType, objectId);

        if (needsAssessmentTemp.isPresent()) {
            return dao.updateNeedsAssessmentTempWorkflowProcessInstanceId(needsAssessmentTemp.get().getProcessInstanceId(), objectType, objectId, workflowStatusCode, workflowStatus);
        } else return null;
    }

    @Transactional
    @Override
    public void verifyNeedsAssessmentTempMainWorkflow(String processInstanceId) {
        List<NeedsAssessmentDTO.verify> needsAssessmentTemps = modelMapper.map(dao.findAll(NICICOSpecification.of(getCriteriaForInstance(processInstanceId))), new TypeToken<List<NeedsAssessmentDTO.verify>>() {
        }.getType());
        String createdBy = null;
        try {
            if (needsAssessmentTemps.size()>0){
                createdBy = needsAssessmentTemps.get(0).getCreatedBy();
                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
                PersonnelDTO.Info person = personnelService.search(searchRq.setCriteria(makeNewCriteria("userName", createdBy, EOperator.equals, null))).getList().get(0);
                createdBy = person.getFirstName() + " " + person.getLastName();
            }
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
                    needsAssessmentDAO.updateNeedsAssessmentPriority(na.getId(), needsAssessmentTemp.getNeedsAssessmentPriorityId() ,needsAssessmentTemp.getLimitSufficiency());
                }
            } else {
                NeedsAssessment needsAssessment = new NeedsAssessment();
                modelMapper.map(needsAssessmentTemp, needsAssessment);
                needsAssessmentDAO.saveAndFlush(needsAssessment);
            }
        });
        needsAssessmentTemps.forEach(item->{
            saveModifications(item.getObjectType(), item.getObjectId(), item.getCreatedBy());
        });
        dao.deleteAllByProcessInstanceId(processInstanceId);
    }


    @Scheduled(cron = "0 30 17 1/1 * ?")
    @Transactional
    public void changeClassStatus() {
        try {
            String query = " BEGIN\n" +
                    "            MERGE\n" +
                    "                INTO    tbl_needs_assessment_temp trg\n" +
                    "                    USING   (\n" +
                    "                        SELECT\n" +
                    "\n" +
                    "                            tbl_needs_assessment_temp.id as rid ,\n" +
                    "                            tbl_training_post.c_code AS postcode,\n" +
                    "                            tbl_training_post.c_title_fa AS postName,\n" +
                    "                            tbl_needs_assessment_temp.c_object_code\n" +
                    "\n" +
                    "                        FROM\n" +
                    "                            tbl_needs_assessment_temp\n" +
                    "                                INNER JOIN tbl_training_post ON tbl_needs_assessment_temp.f_object = tbl_training_post.id\n" +
                    "                        WHERE\n" +
                    "                            tbl_needs_assessment_temp.c_object_code != tbl_training_post.c_code\n" +
                    "    AND tbl_needs_assessment_temp.c_object_type = 'TrainingPost'\n" +
                    "                    ) src\n" +
                    "                    ON      (trg.id = src.rid)\n" +
                    "                    WHEN MATCHED THEN UPDATE\n" +
                    "                        SET trg.c_object_code = src.postcode,\n" +
                    "                            trg.c_object_name = src.postName;\n" +
                    "            END;";
            entityManager.createNativeQuery(query).getResultList();

        }catch (Exception e){

        }



    }
}