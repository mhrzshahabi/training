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
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.Post;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.enums.RequestItemState;
import com.nicico.training.repository.RequestItemDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final RequestItemDAO requestItemDAO;
    private final ICompetenceRequestService competenceRequestService;
    private final IPersonnelService personnelService;
    private final INeedsAssessmentReportsService iNeedsAssessmentReportsService;
    private final IPostService iPostService;
    private final ParameterValueService parameterValueService;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IOperationalRoleService iOperationalRoleService;

    @Override
    @Transactional
    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItem create(RequestItem requestItem, Long id) {
        CompetenceRequest competenceRequest = competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        RequestItem saved = requestItemDAO.save(requestItem);
        saved.setNationalCode(getNationalCode(saved.getPersonnelNumber()));
        return saved;
    }

    @Override
    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItemWithDiff update(RequestItem newData, Long id) {
        RequestItem requestItem = get(id);
        requestItem.setAffairs(newData.getAffairs());
        requestItem.setCompetenceReq(newData.getCompetenceReq());
        requestItem.setCompetenceReqId(newData.getCompetenceReqId());
        requestItem.setLastName(newData.getLastName());
        requestItem.setName(newData.getName());
        requestItem.setWorkGroupCode(newData.getWorkGroupCode());
        requestItem.setPersonnelNumber(newData.getPersonnelNumber());
        requestItem.setPost(newData.getPost());
        requestItem.setState(newData.getState());
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
    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
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
    @Cacheable(value = "searchIRequestItemService", key = "{#id}")
    public List<RequestItem> search(SearchDTO.SearchRq request, Long id) {
        List<RequestItem> list;
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            list = all.getContent();
        } else {
            list = requestItemDAO.findAll(NICICOSpecification.of(request));
        }
        for (RequestItem requestItem : list) {
            requestItem.setNationalCode(getNationalCode(requestItem.getPersonnelNumber()));
            Optional<Post> optionalPost = iPostService.isPostExist(requestItem.getPost());
            requestItem.setState(getRequestState(requestItem.getPersonnelNumber(), optionalPost.isPresent(),requestItem.getPost(), requestItem.getNationalCode()));

        }

        return list;

    }

    @Override
    @Transactional
    public RequestItemDto createList(List<RequestItem> requestItems) {
        RequestItemDto res = new RequestItemDto();
        List<RequestItemWithDiff> requestItemWithDiffList = new ArrayList<>();
        for (RequestItem requestItem : requestItems) {
            RequestItemWithDiff data = getRequestDiff(requestItem);
            if (data.isPersonnelNumberCorrect()) {
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
            if (!(data.isPersonnelNumberCorrect() && data.isAffairsCorrect() && data.isLastNameCorrect() && data.isNameCorrect())) {
                wrongCount++;
            }
        }
        return wrongCount;
    }

    private RequestItemWithDiff getRequestDiff(RequestItem requestItem) {
        Personnel personnel = personnelService.getByPersonnelNumber(requestItem.getPersonnelNumber());
        RequestItemWithDiff requestItemWithDiff = new RequestItemWithDiff();
        requestItemWithDiff.setPersonnelNumber(requestItem.getPersonnelNumber());
        requestItemWithDiff.setName(requestItem.getName());
        requestItemWithDiff.setLastName(requestItem.getLastName());
        requestItemWithDiff.setPost(requestItem.getPost());
        requestItemWithDiff.setAffairs(requestItem.getAffairs());
        Optional<Post> optionalPost = iPostService.isPostExist(requestItem.getPost());
        if (!optionalPost.isPresent())
            requestItemWithDiff.setWorkGroupCode("پست وجود ندارد");
        else {
            requestItemWithDiff.setWorkGroupCode(iOperationalRoleService.getWorkGroup(optionalPost.get().getId()));
        }
        if (personnel != null) {
            requestItemWithDiff.setState(getRequestState(personnel.getPersonnelNo(), optionalPost.isPresent(),requestItem.getPost(), personnel.getNationalCode()).getTitleFa());
            requestItemWithDiff.setPersonnelNumberCorrect(true);
            requestItemWithDiff.setNationalCode(personnel.getNationalCode());
            if (personnel.getFirstName() != null && personnel.getFirstName().trim().equals(requestItem.getName().trim())) {
                requestItemWithDiff.setNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectName(personnel.getFirstName());
                requestItemWithDiff.setNameCorrect(false);
            }
            if (personnel.getLastName() != null && personnel.getLastName().trim().equals(requestItem.getLastName().trim())) {
                requestItemWithDiff.setLastNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectLastName(personnel.getLastName());
                requestItemWithDiff.setLastNameCorrect(false);
            }
            if (personnel.getCcpAffairs() != null && personnel.getCcpAffairs().trim().equals(requestItem.getAffairs().trim())) {
                requestItemWithDiff.setAffairsCorrect(true);
            } else {
                requestItemWithDiff.setCorrectAffairs(personnel.getCcpAffairs());
                requestItemWithDiff.setAffairsCorrect(false);
            }
            RequestItem savedItem = create(requestItem, requestItem.getCompetenceReqId());
            requestItemWithDiff.setId(savedItem.getId());
            requestItemWithDiff.setCompetenceReqId(savedItem.getCompetenceReqId());
        } else {
            requestItemWithDiff.setPersonnelNumberCorrect(false);
            requestItemWithDiff.setAffairsCorrect(false);
            requestItemWithDiff.setLastNameCorrect(false);
            requestItemWithDiff.setNameCorrect(false);
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

}
