package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.model.enums.RequestItemState;
import com.nicico.training.repository.RequestItemDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final RequestItemDAO requestItemDAO;
    private final ICompetenceRequestService competenceRequestService;
    private final IPersonnelService personnelService;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final INeedsAssessmentReportsService iNeedsAssessmentReportsService;
    private final ITrainingPostService trainingPostService;
    private final ParameterValueService parameterValueService;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IOperationalRoleService iOperationalRoleService;
    private final EnumsConverter.RequestItemStateTypeConverter stateTypeConverter = new EnumsConverter.RequestItemStateTypeConverter();


    @Override
    @Transactional
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItem create(RequestItem requestItem, Long id) {
        CompetenceRequest competenceRequest = competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        RequestItem saved = requestItemDAO.save(requestItem);
//        saved.setNationalCode(getNationalCode(saved.getPersonnelNumber()));
        return saved;
    }

    @Override
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItemWithDiff update(RequestItem newData, Long id) {
        RequestItem requestItem = get(id);
        requestItem.setAffairs(newData.getAffairs());
        requestItem.setCompetenceReq(newData.getCompetenceReq());
        requestItem.setCompetenceReqId(newData.getCompetenceReqId());
        requestItem.setLastName(newData.getLastName());
        requestItem.setName(newData.getName());
        requestItem.setWorkGroupCode(newData.getWorkGroupCode());
        requestItem.setPersonnelNumber(newData.getPersonnelNumber());
        requestItem.setPersonnelNo2(newData.getPersonnelNo2());
        requestItem.setPost(newData.getPost());
        requestItem.setState(newData.getState());
        requestItem.setNationalCode(newData.getNationalCode());
        return getRequestDiff(requestItem);
    }

    @Override
    public RequestItem get(Long id) {
        return requestItemDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    public String getNationalCode(String personnelNumber) {
        Personnel personnel = personnelService.getByPersonnelNumber(personnelNumber);
        return personnel.getNationalCode();
    }

    @Override
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public void delete(Long id) {
        requestItemDAO.deleteById(id);
    }

    @Override
    public List<RequestItem> getList() {
        return requestItemDAO.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(requestItemDAO.count());
    }

    @Override
    public Integer getTotalCountForOneCompetenceReqId(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id).size();
    }

    @Override
//    @Cacheable(value = "searchIRequestItemService", key = "{#id}")
    public List<RequestItem> search(SearchDTO.SearchRq request, Long id) {
        List<RequestItem> list;
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            list = all.getContent();
        } else {
            list = requestItemDAO.findAll(NICICOSpecification.of(request));
        }
        return list;

    }

    @Override
    @Transactional
    public RequestItemDto createList(List<RequestItem> requestItems) {
        List<RequestItem> temp=new ArrayList<>();
        if (!requestItems.isEmpty()){
          Long competenceReqId=  requestItems.get(0).getCompetenceReqId();
            List<RequestItem> list = getListWithCompetenceRequest(competenceReqId);
            for (RequestItem requestItem:requestItems) {
                if (!(!list.isEmpty() && list.stream().anyMatch(q -> q.getNationalCode().equals(requestItem.getNationalCode()))))
                    temp.add(requestItem);
            }
            if (list.isEmpty())
                temp=requestItems;
        }
        RequestItemDto res = new RequestItemDto();
        List<RequestItemWithDiff> requestItemWithDiffList = new ArrayList<>();
        for (RequestItem requestItem : temp) {
            RequestItemWithDiff data = getRequestDiff(requestItem);
            if (data.isNationalCodeCorrect() || data.isPersonnelNo2Correct()) {
                requestItemWithDiffList.add(data);
            }

        }
        int wrongCount = getWrongCount(requestItemWithDiffList);
        res.setWrongCount(wrongCount);
        res.setList(requestItemWithDiffList);
        return res;
    }

    private int getWrongCount(List<RequestItemWithDiff> list) {
        int wrongCount = 0;
        for (RequestItemWithDiff data : list) {
            if (!(data.isPersonnelNumberCorrect() && data.isLastNameCorrect() && data.isNameCorrect() && data.isCurrentPostTitleCorrect() && data.isAffairsCorrect())) {
                wrongCount++;
            }
        }
        return wrongCount;
    }

    private RequestItemWithDiff getRequestDiff(RequestItem requestItem) {

        SynonymPersonnel synonymPersonnel;
        RequestItemWithDiff requestItemWithDiff = new RequestItemWithDiff();

        SynonymPersonnel synonymPersonnelByNationalCode = synonymPersonnelService.getByNationalCode(requestItem.getNationalCode());
        SynonymPersonnel synonymPersonnelByPersonnelNo2 = synonymPersonnelService.getByPersonnelNo2(requestItem.getPersonnelNo2());

        if (synonymPersonnelByNationalCode != null) {
            synonymPersonnel = synonymPersonnelByNationalCode;
            requestItemWithDiff.setNationalCodeCorrect(true);
            requestItemWithDiff.setNationalCode(requestItem.getNationalCode());
            if (requestItem.getPersonnelNo2() != null && synonymPersonnel.getPersonnelNo2() != null && synonymPersonnel.getPersonnelNo2().trim().equals(requestItem.getPersonnelNo2().trim())) {
                requestItemWithDiff.setPersonnelNo2Correct(true);
                requestItemWithDiff.setPersonnelNo2(requestItem.getPersonnelNo2());
            } else {
                requestItemWithDiff.setPersonnelNo2Correct(false);
                requestItemWithDiff.setPersonnelNo2(requestItem.getPersonnelNo2());
                requestItemWithDiff.setCorrectPersonnelNo2(synonymPersonnel.getPersonnelNo2());
            }
        } else {
            synonymPersonnel = synonymPersonnelByPersonnelNo2;
            requestItemWithDiff.setPersonnelNo2Correct(true);
            requestItemWithDiff.setPersonnelNo2(synonymPersonnel.getPersonnelNo2());
            requestItemWithDiff.setNationalCodeCorrect(false);
            requestItemWithDiff.setNationalCode(requestItem.getNationalCode());
            requestItemWithDiff.setCorrectNationalCode(synonymPersonnel.getNationalCode());
        }

        if (synonymPersonnel != null) {

            requestItemWithDiff.setPersonnelNumber(requestItem.getPersonnelNumber());
            requestItemWithDiff.setName(requestItem.getName());
            requestItemWithDiff.setLastName(requestItem.getLastName());
            requestItemWithDiff.setEducationLevel(requestItem.getEducationLevel());
            requestItemWithDiff.setEducationMajor(requestItem.getEducationMajor());
            requestItemWithDiff.setCurrentPostTitle(requestItem.getCurrentPostTitle());
            requestItemWithDiff.setPost(requestItem.getPost());
            requestItemWithDiff.setPostTitle(requestItem.getPostTitle());
            requestItemWithDiff.setAffairs(requestItem.getAffairs());
            requestItemWithDiff.setState(requestItem.getState() != null ? stateTypeConverter.requestItemStateToStr(requestItem.getState()) : null);
            Optional<TrainingPost> optionalTrainingPost = trainingPostService.isTrainingPostExist(requestItem.getPost());

            if (!optionalTrainingPost.isPresent()) {
                requestItemWithDiff.setOperationalRoleIds(null);
                requestItem.setOperationalRoleIds(null);
//                requestItemWithDiff.setWorkGroupCode("پست وجود ندارد");
                requestItem.setWorkGroupCode("پست وجود ندارد");
            } else {
                List<OperationalRole> operationalRoles = iOperationalRoleService.getOperationalRolesById(optionalTrainingPost.get().getId());
                List<Long> operationalRoleIds = operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList());
//                String workGroupCode = iOperationalRoleService.getWorkGroup(optionalTrainingPost.get().getId());
                requestItemWithDiff.setOperationalRoleIds(operationalRoleIds);
                requestItemWithDiff.setOperationalRoleTitles(operationalRoles.stream().map(OperationalRole::getTitle).collect(Collectors.toList()));
                requestItem.setOperationalRoleIds(operationalRoleIds);
//                requestItemWithDiff.setWorkGroupCode("گروه کاری");
                requestItem.setWorkGroupCode("گروه کاری");
            }

            if (synonymPersonnel.getPersonnelNo() != null && requestItem.getPersonnelNumber() != null && synonymPersonnel.getPersonnelNo().trim().equals(requestItem.getPersonnelNumber().trim())) {
                requestItemWithDiff.setPersonnelNumberCorrect(true);
            } else {
                requestItemWithDiff.setCorrectPersonnelNumber(synonymPersonnel.getPersonnelNo());
                requestItemWithDiff.setPersonnelNumberCorrect(false);
            }
            if (synonymPersonnel.getFirstName() != null && requestItem.getName() != null && synonymPersonnel.getFirstName().trim().equals(requestItem.getName().trim())) {
                requestItemWithDiff.setNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectName(synonymPersonnel.getFirstName());
                requestItemWithDiff.setNameCorrect(false);
            }
            if (synonymPersonnel.getLastName() != null && requestItem.getLastName() != null && synonymPersonnel.getLastName().trim().equals(requestItem.getLastName().trim())) {
                requestItemWithDiff.setLastNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectLastName(synonymPersonnel.getLastName());
                requestItemWithDiff.setLastNameCorrect(false);
            }
            if (synonymPersonnel.getPostTitle() != null && requestItem.getCurrentPostTitle() != null && synonymPersonnel.getPostTitle().trim().equals(requestItem.getCurrentPostTitle().trim())) {
                requestItemWithDiff.setCurrentPostTitleCorrect(true);
            } else {
                requestItemWithDiff.setCorrectCurrentPostTitle(synonymPersonnel.getPostTitle());
                requestItemWithDiff.setCurrentPostTitleCorrect(false);
            }
            if (synonymPersonnel.getCcpAffairs() != null && requestItem.getAffairs() != null && synonymPersonnel.getCcpAffairs().trim().equals(requestItem.getAffairs().trim())) {
                requestItemWithDiff.setAffairsCorrect(true);
            } else {
                requestItemWithDiff.setCorrectAffairs(synonymPersonnel.getCcpAffairs());
                requestItemWithDiff.setAffairsCorrect(false);
            }

            RequestItem savedItem = create(requestItem, requestItem.getCompetenceReqId());
            requestItemWithDiff.setId(savedItem.getId());
            requestItemWithDiff.setCompetenceReqId(savedItem.getCompetenceReqId());
        } else {
            requestItemWithDiff.setNationalCodeCorrect(false);
            requestItemWithDiff.setPersonnelNo2Correct(false);
        }
        return requestItemWithDiff;
    }

    private RequestItemState getRequestState(String personnelNumber, boolean isPostExist,String post, String nationalCode) {
        if (isPostExist) {
            List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = iNeedsAssessmentReportsService.getCourseListForBpms(post, "Post", nationalCode, personnelNumber);
            if (needsAssessmentReportList.isEmpty()) {
                return RequestItemState.Unimpeded;
            } else {
                Long notPassedCodeId = parameterValueService.getId("false");
                boolean isNotPassedCodeIdExist = needsAssessmentReportList.stream().anyMatch(o -> o.getSkill().getCourse().getScoresState().equals(notPassedCodeId));
                if (isNotPassedCodeIdExist)
                    return RequestItemState.Impeded;
                else
                    return RequestItemState.Unimpeded;
            }
        } else {
            return RequestItemState.PostMissed;
        }
    }


    @Override
    public List<RequestItem> getListWithCompetenceRequest(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id);
    }

    @Override
    public List<RequestItemDTO.Info> getItemListWithCompetenceRequest(Long id) {

        List<RequestItemDTO.Info> infoList = new ArrayList<>();
        List<RequestItem> requestItems = requestItemDAO.findAllByCompetenceReqId(id);
        requestItems.forEach(item -> {
            RequestItemDTO.Info info = requestItemBeanMapper.toRequestItemDto(item);
            infoList.add(info);
        });
        return infoList;
    }

    @Override
    public List<Long> getAllRequestItemIdsWithCompetenceId(Long competenceId) {
        return requestItemDAO.findAllRequestItemIdsWithCompetenceId(competenceId);
    }

    @Override
    public RequestItemWithDiff validData(Long id) {
        Optional<RequestItem> requestItemOptional = requestItemDAO.findById(id);
        if (requestItemOptional.isPresent()) {
            RequestItem requestItem = requestItemOptional.get();
            return getRequestDiff(requestItem);
        } else
            throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

}
