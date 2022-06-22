package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.iservice.INeedsAssessmentService;
import com.nicico.training.mapper.NeedAssessment.NeedAssessmentBeanMapper;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.repository.NeedsAssessmentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.nicico.training.service.NeedsAssessmentTempService.getCriteria;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentService extends BaseService<NeedsAssessment, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentDAO> implements INeedsAssessmentService {

    @Autowired
    private CompetenceService competenceService;
    @Autowired
    private ParameterValueService parameterValueService;
    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;
    @Autowired
    private NeedsAssessmentReportsService needsAssessmentReportsService;
    @Autowired
    private NeedsAssessmentTempService needsAssessmentTempService;
    @Autowired
    private NeedAssessmentBeanMapper needAssessmentBeanMapper;

    @Autowired
    NeedsAssessmentService(NeedsAssessmentDAO competenceDAO) {
        super(new NeedsAssessment(), competenceDAO);
    }

//    @Transactional(readOnly = true)
//    @Override
//    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> search(SearchDTO.SearchRq request) {
//        return SearchUtil.search(dao, request, na -> modelMapper.map(na, NeedsAssessmentDTO.Info.class));
//    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> fullSearch(SearchDTO.SearchRq request) {
        Long objectId = 0L;
        String objectType = "";
        List<SearchDTO.CriteriaRq> criteriaList = request.getCriteria().getCriteria();
        for (SearchDTO.CriteriaRq c : criteriaList) {
            if (c.getFieldName().equalsIgnoreCase("objectId")) {
                objectId = Long.valueOf((Integer) c.getValue().get(0));
            } else if (c.getFieldName().equalsIgnoreCase("objectType")) {
                objectType = c.getValue().get(0).toString();
            }
        }
        return this.fullSearch(objectId, objectType);
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> fullSearch(Long objectId, String objectType) {
        List<NeedsAssessmentDTO.Info> naList;
        Integer readOnlyStatus = needsAssessmentTempService.readOnlyStatus(objectType, objectId);
        if (readOnlyStatus == 1 /* || readOnlyStatus == 3 */)
            naList = modelMapper.map(needsAssessmentReportsService.getUnverifiedNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentDTO.Info>>() {
            }.getType());
        else
            naList = modelMapper.map(needsAssessmentReportsService.getNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentDTO.Info>>() {
            }.getType());
        SearchDTO.SearchRs<NeedsAssessmentDTO.Info> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }


    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> verifiedNeedsAssessmentList(Long objectId, String objectType) {
        List<NeedsAssessmentDTO.Info> naList = modelMapper.map(needsAssessmentReportsService.getNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentDTO.Info>>() {
            }.getType());
        SearchDTO.SearchRs<NeedsAssessmentDTO.Info> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> workflowSearch(Long objectId, String objectType) {
        List<NeedsAssessmentDTO.Info> naList = modelMapper.map(needsAssessmentReportsService.getUnverifiedNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentDTO.Info>>() {
        }.getType());
        SearchDTO.SearchRs<NeedsAssessmentDTO.Info> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }

    @Transactional
    public NeedsAssessmentDTO.Info checkAndCreate(NeedsAssessmentDTO.Create rq) {
        if (!competenceService.isExist(rq.getCompetenceId())) {
            throw new TrainingException(TrainingException.ErrorType.CompetenceNotFound);
        }
        if (!parameterValueService.isExist(rq.getNeedsAssessmentDomainId())) {
            throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentDomainNotFound);
        }
        if (!parameterValueService.isExist(rq.getNeedsAssessmentPriorityId())) {
            throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentPriorityNotFound);
        }
        return create(rq);
    }

    @Transactional
    public Integer updateNeedsAssessmentWorkflow(Long needsAssessmentId, Integer workflowStatusCode, String workflowStatus) {
        return needsAssessmentDAO.updateNeedsAssessmentWorkflowStatus(needsAssessmentId, workflowStatusCode, workflowStatus);
    }

    @Transactional
    public Integer updateNeedsAssessmentMainWorkflow(Long needsAssessmentId, Integer workflowStatusCode, String workflowStatus) {
        return needsAssessmentDAO.updateNeedsAssessmentWorkflowMainStatus(needsAssessmentId, workflowStatusCode, workflowStatus);
    }

    @Transactional(readOnly = true)
    public TotalResponse<NeedsAssessmentDTO.Tree> tree(NICICOCriteria rq) {
        TotalResponse<NeedsAssessmentDTO.Tree> treeTotalResponse = (TotalResponse<NeedsAssessmentDTO.Tree>) (Object) SearchUtil.search(dao, rq, e -> modelMapper.map(e, NeedsAssessmentDTO.Info.class));
        treeTotalResponse.getResponse().setData(modelMapper.map(treeTotalResponse.getResponse().getData(), new TypeToken<List<NeedsAssessmentDTO.Tree>>() {
        }.getType()));


        findGenerations(treeTotalResponse.getResponse().getData());
        Set<NeedsAssessmentDTO.Tree> ancestors = new HashSet<NeedsAssessmentDTO.Tree>();

        int index = -1;
        for (NeedsAssessmentDTO.Tree t : treeTotalResponse.getResponse().getData()) {
            index = findAncestors(ancestors, t, 0, 0, index);
        }

        List<NeedsAssessmentDTO.Tree> generations = new ArrayList<>(ancestors);
        treeTotalResponse.getResponse().setData(generations);

        return treeTotalResponse;
    }

    @Override
    public List<NeedsAssessmentDTO.CourseDetail> findCoursesByTrainingPostCode(String trainingPostCode) {
        List<NeedsAssessment> needsAssessmentList = needsAssessmentDAO.findAllByObjectTypeAndObjectCode("TrainingPost", trainingPostCode);
        return needAssessmentBeanMapper.toNeedsAssessmentCourseDetailDTOList(needsAssessmentList);
    }

    private List<NeedsAssessmentDTO.Tree> findGenerations(List<NeedsAssessmentDTO.Tree> tree) {
        Set<NeedsAssessmentDTO.Tree> ancestors = new HashSet<>();
        for (NeedsAssessmentDTO.Tree node : tree) {
            node.setCompetenceTypeTitle(node.getCompetence().getCompetenceType().getTitle());
            node.setCompetenceNameTitle(node.getCompetence().getTitle());
            node.setNeedsAssessmentDomainTitle(node.getNeedsAssessmentDomain().getTitle());
            node.setNeedsAssessmentPriorityTitle(node.getNeedsAssessmentPriority().getTitle());
            node.setSkillTitle(node.getSkill().getTitleFa());
            node.setSkillCourseTitle(node.getSkill().getCourse().getTitleFa());
            ancestors.add(node);
        }
        return new ArrayList<>(ancestors);
    }

    private int findAncestors(Set<NeedsAssessmentDTO.Tree> ancestors, NeedsAssessmentDTO.Tree child, int no, int parent, int index) {
        String[] keys = {"competenceTypeTitle", "needsAssessmentDomainTitle", "needsAssessmentPriorityTitle", "competenceNameTitle", "skillTitle", "skillCourseTitle"};
        int i = index;
        if (keys.length - 1 > no) {
            String property = keys[no];
            NeedsAssessmentDTO.Tree father = new NeedsAssessmentDTO.Tree();
//            father.setProperty(property,child.getProperty(property));
            father.setName(child.getProperty(property));
            father.setParentId((long) parent);
            NeedsAssessmentDTO.Tree node = ancestors.stream().filter(n -> n.equvalentOf(father)).findFirst().orElse(null);
            if (node == null) {
                father.setId((long) i);
                ancestors.add(father);
                parent = i;
                --i;
            } else {
                parent = node.getId().intValue();
            }
            child.setProperty(property, "");
            i = findAncestors(ancestors, child, ++no, parent, i);
        } else {
            child.setParentId((long) parent);
            child.setName(child.getProperty(keys[no]));
            ancestors.add(child);
        }
        return i;
    }

    @Transactional
    public Boolean checkBeforeDeleteObject(String objectType, Long objectId) {
        List<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId, true)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return true;
        return false;
    }
}