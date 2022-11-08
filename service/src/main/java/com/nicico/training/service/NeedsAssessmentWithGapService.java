
package com.nicico.training.service;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.NeedsAssessmentWithGapDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentWithGapService implements INeedsAssessmentWithGapService {
    private final NeedsAssessmentWithGapDAO needsAssessmentDAO;
    private final ITrainingPostService iTrainingPostService;
    private final IGroupOfPersonnelService iGroupOfPersonnelService;
    private final IPostService iPostService;
    private final IPostGroupService iPostGroupService;
    private final IPostGradeService iPostGradeService;
    private final IPostGradeGroupService iPostGradeGroupService;
    private final IJobService iJobService;
    private final IJobGroupService iJobGroupService;
    private final ICompetenceService iCompetenceService;
    private final ISkillService skillService;
    private final ICompetenceService competenceService;

    @Override
    public SearchDTO.SearchRs<SkillDTO.Info2> fullSearchForSkills(Long objectId, String objectType, Long competenceId) {
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getNeedsAssessmentListForRemove(competenceId,
                objectType,objectId);

        List<NeedsAssessmentWithGap> listFromGroups=getGroupListForCompetences(objectType,objectId);
        list.addAll(listFromGroups.stream().filter(a->a.getCompetenceId().equals(competenceId)).collect(Collectors.toSet()));

        List<SkillDTO.Info2> naList = skillService.getInfoV2(list.stream().map(NeedsAssessmentWithGap::getSkillId).collect(Collectors.toList()));

        for (SkillDTO.Info2 info2 : naList) {
            Float limit = list.stream().filter(a -> a.getSkillId().equals(info2.getId())).findFirst().get().getLimitSufficiency();
            if (limit != null)
                info2.setLimitSufficiency(limit.toString());
        }
        SearchDTO.SearchRs<SkillDTO.Info2> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }

    private List<NeedsAssessmentWithGap> getGroupListForCompetences(String objectType, Long objectId) {
        List<NeedsAssessmentWithGap> list =new ArrayList<>();


        if (objectType.equals("Post")){
            List<TrainingPost> trainingPosts=iTrainingPostService.getTrainingPostWithPostId(objectId);
            for(TrainingPost trainingPost :trainingPosts){
                List<NeedsAssessmentWithGap> newItems = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(trainingPost.getId(),
                        "TrainingPost");
                list.addAll(newItems);
                List<PostGroup> postGroups=iPostGroupService.getPostGroupsByTrainingPostId(trainingPost.getId());
                for(PostGroup postGroup :postGroups){
                    List<NeedsAssessmentWithGap> newItems2 = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(postGroup.getId(),
                            "PostGroup");
                    list.addAll(newItems2);
                }
            }

        }

        ////////add postGroupData
        if (objectType.equals("TrainingPost")){
            List<PostGroup> postGroups=iPostGroupService.getPostGroupsByTrainingPostId(objectId);
            for(PostGroup postGroup :postGroups){
                List<NeedsAssessmentWithGap> newItems = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(postGroup.getId(),
                        "PostGroup");
                list.addAll(newItems);
            }

        }
        ////// add postGrad Group data
        if (objectType.equals("PostGrade")){
            List<PostGradeGroup> postGradeGroups=iPostGradeGroupService.getPostGradeGroupsByTrainingPostId(objectId);
            for(PostGradeGroup postGradeGroup :postGradeGroups){
                List<NeedsAssessmentWithGap> newItems = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(postGradeGroup.getId(),
                        "PostGradeGroup");
                list.addAll(newItems);
            }

        }


        ////// add job Group data
        if (objectType.equals("Job")){
            List<JobGroup> jobGrops=iJobGroupService.getPostGradeGroupsByJobId(objectId);
            for(JobGroup jobGroup :jobGrops){
                List<NeedsAssessmentWithGap> newItems = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(jobGroup.getId(),
                        "JobGroup");
                list.addAll(newItems);
            }

        }




        return  list;
    }

    @Override
    public SearchDTO.SearchRs<CompetenceDTO.Info> fullSearchForCompetences(Long objectId, String objectType) {
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(objectId,
                objectType);

        list.addAll(getGroupListForCompetences(objectType,objectId));

        List<CompetenceDTO.Info> naList = competenceService.getInfos(list);

        SearchDTO.SearchRs<CompetenceDTO.Info> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }

    @Override
    public List<NeedsAssessmentWithGap> fullSearchForNeedAssessment(Long objectId, String objectType) {
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(objectId,
                objectType);
        list.addAll(getGroupListForCompetences(objectType,objectId));

     return list;
    }

    @Override
    @Transactional
    public BaseResponse addSkills(NeedsAssessmentWithGapDTO.CreateNeedAssessment createNeedAssessment) {
        BaseResponse response = new BaseResponse();

        Competence competence = iCompetenceService.getCompetence(createNeedAssessment.getCompetenceId());


        Map<String, String> map = getObjectCode(createNeedAssessment.getObjectId(), createNeedAssessment.getObjectType());
        String code = null;
        String name = null;
        for (String nc : Objects.requireNonNull(map).keySet()) {
            name = map.get(nc);
            code = nc;
        }
        List<NeedsAssessmentWithGap> removeList = needsAssessmentDAO.getNeedsAssessmentListForRemove(createNeedAssessment.getCompetenceId(),
                createNeedAssessment.getObjectType(),createNeedAssessment.getObjectId());
        needsAssessmentDAO.deleteAll(removeList);

        List<NeedsAssessmentWithGap> needsAssessmentWithGapList = new ArrayList<>();
        for (NeedsAssessmentWithGapDTO.CreateNeedAssessmentSkill s : createNeedAssessment.getCreateNeedAssessmentSkills()) {
            NeedsAssessmentWithGap needsAssessmentWithGap = new NeedsAssessmentWithGap();
            needsAssessmentWithGap.setSkillId(s.getId());
            needsAssessmentWithGap.setCompetenceId(createNeedAssessment.getCompetenceId());
            needsAssessmentWithGap.setLimitSufficiency(s.getLimitSufficiency());
            needsAssessmentWithGap.setObjectCode(code);
            if (competence.getCompetenceLevelId()!=null)
            needsAssessmentWithGap.setNeedsAssessmentDomainId(competence.getCompetenceLevelId());
            else
                needsAssessmentWithGap.setNeedsAssessmentDomainId(createNeedAssessment.getNeedsAssessmentDomainId());
            needsAssessmentWithGap.setNeedsAssessmentPriorityId(competence.getCompetencePriorityId());
            needsAssessmentWithGap.setObjectId(createNeedAssessment.getObjectId());
            needsAssessmentWithGap.setObjectType(createNeedAssessment.getObjectType());
            needsAssessmentWithGap.setObjectName(name);
            needsAssessmentWithGapList.add(needsAssessmentWithGap);

        }
        needsAssessmentDAO.saveAll(needsAssessmentWithGapList);
        return response;
    }

    @Override
    public Set<Long> searchWithoutPermission(Long competenceId, Long objectId, String objectType) {
        return needsAssessmentDAO.getNeedsAssessmentListForRemove(competenceId,
                objectType,objectId).stream().map(NeedsAssessmentWithGap::getSkillId).collect(Collectors.toSet());
    }

    @Override
    @Transactional
    public BaseResponse sendToWorkFlow(Long objectId, String objectType) {
        BaseResponse response = new BaseResponse();
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getNeedsAssessmentListForSendToWorkFlow(objectId, objectType);
        for (NeedsAssessmentWithGap needsAssessmentWithGap : list) {
            needsAssessmentWithGap.setMainWorkflowStatus("temp");
            needsAssessmentWithGap.setMainWorkflowStatusCode(0);
            needsAssessmentDAO.save(needsAssessmentWithGap);
        }
        response.setStatus(200);
        return response;
    }


    private Map<String, String> getObjectCode(Long objectId, String objectType) {
        Map<String, String> map = new HashMap<>();
        switch (objectType) {
            case "TrainingPost" -> {
                TrainingPostDTO.Info trainingPost = iTrainingPostService.getTrainingPost(objectId);
                map.put(trainingPost.getCode(), trainingPost.getTitleFa());
                return map;
            }
            case "GroupOfPersonnel","organizationCompetence" -> {
                GroupOfPersonnel groupOfPersonnel = iGroupOfPersonnelService.get(objectId);
                map.put(groupOfPersonnel.getCode(), groupOfPersonnel.getTitleFa());
                return map;
            }
            case "Post" -> {
                PostDTO.Info post = iPostService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            case "PostGroup" -> {
                PostGroupDTO.Info post = iPostGroupService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            case "PostGrade" -> {
                PostGradeDTO.Info post = iPostGradeService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            case "PostGradeGroup" -> {
                PostGradeGroupDTO.Info post = iPostGradeGroupService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            case "Job" -> {
                JobDTO.Info post = iJobService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            case "JobGroup" -> {
                JobGroupDTO.Info post = iJobGroupService.get(objectId);
                map.put(post.getCode(), post.getTitleFa());
                return map;
            }
            default -> {
                return null;
            }
        }
    }

    @Override
    @Transactional
    public BaseResponse deleteUnCompleteData(Long objectId, String objectType) {
        BaseResponse baseResponse = new BaseResponse();
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getUnCompleteData(objectId, objectType);
        needsAssessmentDAO.deleteAll(list);
        baseResponse.setStatus(200);
        return baseResponse;
    }

//    private String getCodFromObject(Long objectId, String objectType) {
//        Map<String, String> map = getObjectCode(objectId, objectType);
//        String code = null;
//        for (String nc : Objects.requireNonNull(map).keySet()) {
//            code = nc;
//        }
//        return code;
//    }

    @Override
    public Boolean canChangeData(String objectType, Long objectId) {
        List<NeedsAssessmentWithGap> list = needsAssessmentDAO.getListForChangeData(objectId, objectType);
        if (list.isEmpty())
            return true;
        else {
            return checkListValidation(list, SecurityUtil.getUsername());
        }
    }



    private Boolean checkListValidation(List<NeedsAssessmentWithGap> list, String username) {
        boolean allDataIsNull = list.stream().allMatch(s -> (s.getMainWorkflowStatus() == null));
        boolean allDataIsTemp = list.stream().allMatch(s -> (s.getMainWorkflowStatus()!=null && s.getMainWorkflowStatus().equals("temp")));
        boolean allDataSendWithThisUser = list.stream().allMatch(s -> (s.getCreatedBy().equals(username)));
        if (allDataIsNull && allDataSendWithThisUser) {
            return true;
        }
        if (allDataIsTemp && allDataSendWithThisUser) {
            return true;
        }
        return allDataSendWithThisUser;
    }

//    private Object getNeedsAssessmentList(Long objectId, String objectType,Long competenceId) {
//        List<NeedsAssessmentWithGap> needsAssessmentList = new ArrayList<>();
//        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
//        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
//        criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
//        criteriaRq.getCriteria().add(makeNewCriteria("competenceId", competenceId, EOperator.equals, null));
//        needsAssessmentReportsService.addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, true, true);
//        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
//            needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
//        return removeDuplicateNAs(needsAssessmentList);
//    }
//
//
//    private List<NeedsAssessmentWithGap> removeDuplicateNAs(List<NeedsAssessmentWithGap> needsAssessmentList) {
//        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedsAssessment.priorityList.indexOf(a.getObjectType())));
//        List<NeedsAssessmentWithGap> withoutDuplicate = new ArrayList<>();
//        needsAssessmentList.forEach(needsAssessment -> {
//            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkillId().equals(needsAssessment.getSkillId())))
//                withoutDuplicate.add(needsAssessment);
//        });
//        return withoutDuplicate;
//    }


}