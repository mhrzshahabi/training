package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.RequestItem;
import com.nicico.training.repository.RequestItemDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.List;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final RequestItemDAO requestItemDAO;
    private final ICompetenceRequestService competenceRequestService;
    private final IPersonnelService personnelService;
    private final RequestItemBeanMapper requestItemBeanMapper;

    @Override
    @Transactional
    public RequestItem create(RequestItem requestItem) {
        CompetenceRequest competenceRequest = competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        RequestItem saved=requestItemDAO.save(requestItem);
        saved.setNationalCode(getNationalCode(saved.getPersonnelNumber()));
        return saved;
    }

    @Override
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
    public List<RequestItem> search(SearchDTO.SearchRq request) {
        List<RequestItem>list;
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            list= all.getContent();
        } else {
            list= requestItemDAO.findAll(NICICOSpecification.of(request));
        }
        for (RequestItem requestItem:list){
            requestItem.setNationalCode(getNationalCode(requestItem.getPersonnelNumber()));
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
        int wrongCount=getWrongCount(requestItemWithDiffList);
        res.setWrongCount(wrongCount);
        res.setList(requestItemWithDiffList);
        return res;
    }

    private int getWrongCount(List<RequestItemWithDiff> list) {
        int wrongCount=0;
        for (RequestItemWithDiff data:list){
            if (!(data.isPersonnelNumberCorrect() && data.isAffairsCorrect() && data.isLastNameCorrect() && data.isNameCorrect())){
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
        //todo after add workgroup
        requestItemWithDiff.setWorkGroupCode("");

        if (personnel != null) {
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
            RequestItem savedItem = create(requestItem);
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
